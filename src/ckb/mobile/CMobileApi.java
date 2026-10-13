package ckb.mobile;

import ckb.mobile.MobAuth.ApiError;
import ckb.mobile.MobAuth.Who;
import ckb.utils.DB;
import ckb.utils.tg.TgClientBot;
import ckb.utils.tg.TgPatientBot;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONObject;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Connection;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * API мобильного приложения пациента: /api/m/v1/... (servlet в web.xml, вне Spring и вне проверки входа сотрудников).
 * Ответы в JSON UTF-8. Ошибка: HTTP-код и {"error": код, "message": текст для пациента}.
 * Авторизация: заголовок "Authorization: Bearer <accessToken>" (кроме /auth/* и /files/<token>).
 *
 * Наружу через прокси (HTTPS) открывается только /api/m/, рабочие страницы fm остаются внутри сети.
 */
public class CMobileApi extends HttpServlet {

  private static final Pattern ID = Pattern.compile("^/v1/(clients|stays|visits)/(\\d+)(/[a-z-]+)?$");
  private static final Pattern FILE = Pattern.compile("^/v1/files/([0-9a-f]{40})\\.(pdf|html)$");

  @Override
  protected void service(HttpServletRequest req, HttpServletResponse res) {
    String path = req.getPathInfo() == null ? "/" : req.getPathInfo();
    String method = req.getMethod();
    Connection conn = null;
    try {
      conn = DB.getConnection();
      if (conn == null) throw new ApiError(503, "db", "Сервер клиники временно недоступен.");
      MobTables.init(conn);

      Matcher fm = FILE.matcher(path);
      if (fm.matches() && "GET".equals(method)) {
        serveFile(conn, req, res, fm.group(1));
        return;
      }
      if (path.equals("/v1/ping")) {
        JSONObject o = new JSONObject();
        o.put("ok", true);
        o.put("api", 1);
        json(res, 200, o);
        return;
      }
      if (path.startsWith("/v1/auth/")) {
        if (!"POST".equals(method)) throw new ApiError(405, "method", "Метод не поддерживается.");
        JSONObject in = body(req);
        if (path.equals("/v1/auth/code")) json(res, 200, MobAuth.sendCode(conn, in.optString("phone")));
        else if (path.equals("/v1/auth/verify"))
          json(res, 200, MobAuth.verify(conn, in.optString("phone"), in.optString("code"), in.optString("device", null), in.optString("platform", null)));
        else if (path.equals("/v1/auth/refresh")) json(res, 200, MobAuth.refresh(conn, in.optString("refreshToken")));
        else if (path.equals("/v1/auth/logout")) {
          MobAuth.logout(conn, MobAuth.check(conn, req.getHeader("Authorization")));
          json(res, 200, ok());
        } else throw new ApiError(404, "no_route", "Нет такого адреса.");
        return;
      }

      Who who = MobAuth.check(conn, req.getHeader("Authorization"));
      if (path.equals("/v1/clients") && "GET".equals(method)) {
        JSONObject o = new JSONObject();
        o.put("phone", MobAuth.format(who.phone9));
        o.put("clients", MobData.clients(conn, who));
        json(res, 200, o);
        return;
      }
      if (path.equals("/v1/notifications") && "GET".equals(method)) {
        JSONObject o = new JSONObject();
        o.put("items", MobData.notifications(conn, who));
        json(res, 200, o);
        return;
      }
      if (path.equals("/v1/settings")) {
        if ("GET".equals(method)) json(res, 200, MobData.settings(conn, who));
        else if ("PUT".equals(method) || "POST".equals(method)) json(res, 200, MobData.saveSettings(conn, who, body(req)));
        else throw new ApiError(405, "method", "Метод не поддерживается.");
        return;
      }
      if (path.equals("/v1/devices") && "POST".equals(method)) {
        MobData.device(conn, who, body(req));
        json(res, 200, ok());
        return;
      }
      if (path.equals("/v1/files") && "POST".equals(method)) {
        json(res, 200, fileLink(conn, who, body(req)));
        return;
      }

      Matcher m = ID.matcher(path);
      if (!m.matches()) throw new ApiError(404, "no_route", "Нет такого адреса.");
      String what = m.group(1), sub = m.group(3) == null ? "" : m.group(3);
      int id = Integer.parseInt(m.group(2));
      JSONObject out = null;
      JSONArray list = null;
      if ("clients".equals(what) && "GET".equals(method)) {
        if (sub.equals("/stays")) out = MobData.stays(conn, who, id);
        else if (sub.equals("/visits")) list = MobData.visits(conn, who, id);
        else if (sub.equals("/home-plan")) {
          MobData.ownClient(conn, who, id);
          out = new JSONObject();
          JSONObject plan = HomePlan.forApp(conn, id, who.phone9);
          out.put("plan", plan == null ? JSONObject.NULL : plan);
        }
      } else if ("stays".equals(what)) {
        if (sub.equals("/day") && "GET".equals(method)) out = MobData.day(conn, who, id, MobDb.parseIso(req.getParameter("date")));
        else if (sub.equals("/progress") && "GET".equals(method)) out = MobData.progress(conn, who, id);
        else if (sub.equals("/exams") && "GET".equals(method)) out = MobData.exams(conn, who, id);
        else if (sub.equals("/questions") && "GET".equals(method)) out = MobData.questions(conn, who, id);
        else if (sub.equals("/questions") && "POST".equals(method)) out = MobData.ask(conn, who, id, body(req).optString("text"));
      }
      if (out == null && list == null) throw new ApiError(404, "no_route", "Нет такого адреса.");
      if (list != null) {
        out = new JSONObject();
        out.put("items", list);
      }
      json(res, 200, out);
    } catch (ApiError e) {
      error(res, e.status, e.code, e.getMessage());
    } catch (Exception e) {
      System.err.println("MOB_API_ERR " + method + " " + path + ": " + e);
      e.printStackTrace();
      error(res, 500, "server", "Ошибка на сервере клиники. Попробуйте позже.");
    } finally {
      DB.done(conn);
    }
  }

  // ---------- Файлы: PDF результатов визита и выписка ----------

  /** POST /files {kind: "result"|"epicrisis", id}: ссылка на 10 минут */
  private static JSONObject fileLink(Connection conn, Who who, JSONObject in) throws Exception {
    String kind = in.optString("kind");
    int id = in.optInt("id");
    String ext;
    if ("result".equals(kind)) {
      Map<String, Object> a = MobData.ownVisit(conn, who, id);
      if (MobDb.s(a, "qrcode").isEmpty()) throw new ApiError(404, "no_file", "У этого визита нет результатов.");
      kind = "RESULT";
      ext = "pdf";
    } else if ("epicrisis".equals(kind)) {
      Map<String, Object> p = MobData.ownStay(conn, who, id);
      if (!"CLOSED".equals(MobDb.s(p, "paid")) || MobDb.count(conn, "Select Count(*) From Lv_Docs Where patient_Id = ? And docCode = 'vypiska'", id) == 0)
        throw new ApiError(404, "no_file", "Выписка появится после закрытия счёта.");
      kind = "EPI";
      ext = "html";
    } else throw new ApiError(400, "bad_kind", "Неизвестный файл.");
    String token = MobAuth.token().substring(0, 40);
    int minutes = Math.max(1, MobConfig.getInt("mobile.file.minutes", 10));
    MobDb.exec(conn, "Insert Into Mob_Files (token, phone9, session_id, kind, ref_id, expires, created) Values (?, ?, ?, ?, ?, Date_Add(Now(), Interval " + minutes + " Minute), Now())",
      token, who.phone9, who.sessionId, kind, id);
    JSONObject o = new JSONObject();
    o.put("url", "/api/m/v1/files/" + token + "." + ext);
    o.put("type", ext);
    o.put("expiresIn", minutes * 60);
    return o;
  }

  private static void serveFile(Connection conn, HttpServletRequest req, HttpServletResponse res, String token) throws Exception {
    Map<String, Object> f = MobDb.row(conn, "Select * From Mob_Files Where token = ? And expires > Now()", token);
    if (f == null) throw new ApiError(404, "expired", "Ссылка устарела. Откройте файл в приложении ещё раз.");
    int id = MobDb.i(f, "ref_id");
    String kind = MobDb.s(f, "kind");
    Map<String, Object> s = MobDb.row(conn, "Select device From Mob_Sessions Where id = ?", MobDb.i(f, "session_id"));
    MobDb.exec(conn, "Insert Into Mob_File_Log (phone9, session_id, kind, ref_id, device, ip, created) Values (?, ?, ?, ?, ?, ?, Now())",
      MobDb.s(f, "phone9"), MobDb.i(f, "session_id"), kind, id, s == null ? null : MobDb.s(s, "device"), req.getRemoteAddr());
    byte[] data;
    String type, name;
    if ("RESULT".equals(kind)) {
      try {
        data = TgClientBot.resultPdf(conn, id);
      } catch (Exception e) {
        System.err.println("MOB_RESULT_PDF_ERR amb=" + id + ": " + e.getMessage());
        throw new ApiError(502, "no_pdf", "Не удалось получить PDF у сервиса результатов. Попробуйте позже.");
      }
      type = "application/pdf";
      name = "result_" + id + ".pdf";
    } else {
      String html = TgPatientBot.vypiskaHtml(conn, id);
      if (html == null) throw new ApiError(404, "no_file", "Выписка не найдена.");
      data = html.getBytes("UTF-8");
      type = "text/html; charset=UTF-8";
      name = "vypiska_" + id + ".html";
    }
    res.setStatus(200);
    res.setContentType(type);
    res.setHeader("Content-Disposition", "inline; filename=\"" + name + "\"");
    res.setHeader("Cache-Control", "no-store");
    res.setContentLength(data.length);
    OutputStream out = res.getOutputStream();
    out.write(data);
    out.flush();
  }

  // ---------- JSON ----------

  private static JSONObject body(HttpServletRequest req) throws Exception {
    ByteArrayOutputStream b = new ByteArrayOutputStream();
    try (InputStream in = req.getInputStream()) {
      byte[] buf = new byte[4096];
      int n;
      while ((n = in.read(buf)) > 0) {
        b.write(buf, 0, n);
        if (b.size() > 65536) throw new ApiError(413, "too_big", "Слишком большой запрос.");
      }
    }
    String s = new String(b.toByteArray(), "UTF-8").trim();
    if (s.isEmpty()) return new JSONObject();
    try {
      return new JSONObject(s);
    } catch (Exception e) {
      throw new ApiError(400, "bad_json", "Неверный запрос.");
    }
  }

  private static JSONObject ok() throws Exception {
    JSONObject o = new JSONObject();
    o.put("ok", true);
    return o;
  }

  private static void json(HttpServletResponse res, int status, JSONObject o) throws Exception {
    byte[] b = o.toString().getBytes("UTF-8");
    res.setStatus(status);
    res.setContentType("application/json; charset=UTF-8");
    res.setHeader("Cache-Control", "no-store");
    res.setContentLength(b.length);
    OutputStream out = res.getOutputStream();
    out.write(b);
    out.flush();
  }

  private static void error(HttpServletResponse res, int status, String code, String message) {
    try {
      if (res.isCommitted()) return;
      res.reset();
      JSONObject o = new JSONObject();
      o.put("error", code);
      o.put("message", message);
      json(res, status, o);
    } catch (Exception e) {
      e.printStackTrace();
    }
  }
}
