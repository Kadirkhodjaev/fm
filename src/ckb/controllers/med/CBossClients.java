package ckb.controllers.med;

import ckb.dao.med.client.DClient;
import ckb.domains.admin.Clients;
import ckb.services.med.client.ClientFinance;
import ckb.services.med.client.ClientStats;
import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.DB;
import ckb.utils.Util;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;

/**
 * –уководство -> вкладка " лиенты": клиентска€ база с типами клиентов (VIP, посто€нные, ...) и финансовый анализ клиента.
 * —траницы груз€тс€ внутрь вкладки модул€ –уководство (boss.jsp), а не в общее меню " лиенты" регистратуры.
 */
@Controller
@RequestMapping("/boss/clients/")
public class CBossClients {

  private static final int BOSS_ROLE = 27;

  @Autowired private DClient dClient;

  private static boolean allowed(Session session) {
    return session != null && (session.getRoleId() == BOSS_ROLE || session.getRoleId() == 1 || session.getUserId() == 1);
  }

  private static final int PAGE_SIZE = 100;
  private static final Map<String, String> SORTS = new LinkedHashMap<>();
  static {
    SORTS.put("new", "c.id Desc");
    SORTS.put("paid", "IfNull(s.total_paid, 0) Desc, c.id Desc");
    SORTS.put("paid12", "IfNull(s.paid_12m, 0) Desc, c.id Desc");
    SORTS.put("visits", "(IfNull(s.amb_visits, 0) + IfNull(s.stat_visits, 0)) Desc, c.id Desc");
    SORTS.put("last", "s.last_visit Is Null, s.last_visit Desc, c.id Desc");
    SORTS.put("fio", "c.surname, c.name, c.middlename");
  }

  //  лиентска€ база: типы клиентов, финансовые итоги, поиск и сортировка (итоги из Crm_Client_Stats)
  @RequestMapping("list.s")
  protected String patients(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    if (!allowed(session)) return "/boss/clients/denied";
    HashMap<String, String> filters = session.getFilters();
    // параметры запоминаютс€ в сессии, чтобы при возврате из карточки клиента список был тем же
    String seg = param(req, filters, "boss_cl_seg", "seg", "");
    String flag = param(req, filters, "boss_cl_flag", "flag", "");
    String q = param(req, filters, "boss_cl_q", "q", "").trim();
    String sort = param(req, filters, "boss_cl_sort", "sort", "new");
    String pg = param(req, filters, "boss_cl_page", "page", "1");
    int page = pg.matches("\\d{1,6}") ? Math.max(1, Integer.parseInt(pg)) : 1;
    // смена фильтра или сортировки - с первой страницы
    boolean changed = req.getParameter("seg") != null || req.getParameter("flag") != null || req.getParameter("q") != null || req.getParameter("sort") != null;
    if (changed && req.getParameter("page") == null) page = 1;
    if (!SORTS.containsKey(sort)) sort = "new";
    if (!seg.isEmpty() && !ClientStats.SEGMENTS.containsKey(seg)) seg = "";
    filters.put("boss_cl_page", String.valueOf(page));
    session.setFilters(filters);

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    List<Map<String, Object>> rows = new ArrayList<>();
    try {
      conn = DB.getConnection();
      Object[] info = ClientStats.info(conn);
      if (info == null) {
        // первый запуск: итогов ещЄ нет
        DB.done(conn);
        conn = null;
        ClientStats.refresh();
        conn = DB.getConnection();
        info = ClientStats.info(conn);
      }
      model.addAttribute("calcDate", info == null ? "" : Util.dateTimeToString((Date) info[0]));
      model.addAttribute("vipFrom", info == null ? "" : ClientStats.money((Double) info[1]));

      // общие услови€ (без типа клиента) - дл€ счЄтчиков на плашках
      StringBuilder where = new StringBuilder(" Where 1 = 1");
      List<Object> args = new ArrayList<>();
      if (flag.equals("DONE")) where.append(" And c.flag = 'DONE'");
      if (flag.equals("UNDONE")) where.append(" And c.flag Is Null");
      if (session.getRoleId() == 21) where.append(" And c.id In (Select x.client_id From Ss_Contract_Clients x)");
      for (String w : q.toUpperCase().split("\\s+")) {
        if (w.isEmpty()) continue;
        if (w.matches("\\d{4,}")) {
          where.append(" And (c.tel Like ? Or c.id = ? Or c.docNum Like ?)");
          args.add("%" + w + "%");
          args.add(Long.parseLong(w) > Integer.MAX_VALUE ? -1 : Integer.parseInt(w));
          args.add("%" + w + "%");
        } else {
          where.append(" And (Upper(c.surname) Like ? Or Upper(c.name) Like ? Or Upper(c.middlename) Like ?)");
          args.add(w + "%");
          args.add(w + "%");
          args.add(w + "%");
        }
      }
      String from = " From Crm_Clients c Left Join Crm_Client_Stats s On s.client_id = c.id ";

      // плашки типов: количество клиентов и сумма оплат
      Map<String, long[]> segCounts = new LinkedHashMap<>();
      Map<String, Double> segPaid = new HashMap<>();
      for (String k : ClientStats.SEGMENTS.keySet()) segCounts.put(k, new long[]{0});
      ps = prepare(conn, "Select IfNull(s.segment, 'NONE') seg, Count(*), Sum(IfNull(s.total_paid, 0))" + from + where + " Group By IfNull(s.segment, 'NONE')", args);
      rs = ps.executeQuery();
      long all = 0;
      double allPaid = 0;
      while (rs.next()) {
        if (segCounts.containsKey(rs.getString(1))) segCounts.get(rs.getString(1))[0] = rs.getLong(2);
        segPaid.put(rs.getString(1), rs.getDouble(3));
        all += rs.getLong(2);
        allPaid += rs.getDouble(3);
      }
      DB.done(rs);
      DB.done(ps);
      List<Map<String, Object>> segs = new ArrayList<>();
      for (Map.Entry<String, String[]> e : ClientStats.SEGMENTS.entrySet()) {
        Map<String, Object> s = new HashMap<>();
        s.put("code", e.getKey());
        s.put("name", e.getValue()[0]);
        s.put("hint", e.getValue()[1]);
        s.put("count", segCounts.get(e.getKey())[0]);
        double p = segPaid.containsKey(e.getKey()) ? segPaid.get(e.getKey()) : 0;
        s.put("share", allPaid > 0 ? Math.round(p * 100 / allPaid) : 0);
        segs.add(s);
      }
      model.addAttribute("segs", segs);
      model.addAttribute("allCount", all);
      model.addAttribute("allPaid", ClientStats.moneyShort(allPaid));

      // страница списка
      if (!seg.isEmpty()) {
        where.append(seg.equals(ClientStats.NONE) ? " And (s.segment Is Null Or s.segment = 'NONE')" : " And s.segment = ?");
        if (!seg.equals(ClientStats.NONE)) args.add(seg);
      }
      ps = prepare(conn, "Select Count(*)" + from + where, args);
      rs = ps.executeQuery();
      rs.next();
      long count = rs.getLong(1);
      DB.done(rs);
      DB.done(ps);
      int maxPage = (int) Math.max(1, (count + PAGE_SIZE - 1) / PAGE_SIZE);
      if (page > maxPage) page = maxPage;
      ps = prepare(conn,
        "Select c.id, c.surname, c.name, c.middlename, c.birthdate, c.birthyear, c.tel, c.flag, c.crOn, " +
        "       s.segment, s.amb_visits, s.stat_visits, s.total_paid, s.paid_12m, s.last_visit " + from + where +
        " Order By " + SORTS.get(sort) + " Limit " + ((page - 1) * PAGE_SIZE) + ", " + PAGE_SIZE, args);
      rs = ps.executeQuery();
      while (rs.next()) {
        Map<String, Object> r = new HashMap<>();
        r.put("id", rs.getInt("id"));
        r.put("fio", (Util.nvl(rs.getString("surname")) + " " + Util.nvl(rs.getString("name")) + " " + Util.nvl(rs.getString("middlename"))).trim());
        r.put("birth", rs.getDate("birthdate") != null ? Util.dateToString(rs.getDate("birthdate")) : (rs.getInt("birthyear") > 0 ? rs.getInt("birthyear") + "" : ""));
        r.put("tel", Util.nvl(rs.getString("tel")));
        r.put("flag", "DONE".equals(rs.getString("flag")));
        String sg = rs.getString("segment") == null ? ClientStats.NONE : rs.getString("segment");
        r.put("seg", sg);
        r.put("segName", ClientStats.segmentName(sg));
        r.put("amb", rs.getInt("amb_visits"));
        r.put("stat", rs.getInt("stat_visits"));
        r.put("paid", rs.getDouble("total_paid") != 0 ? ClientStats.money(rs.getDouble("total_paid")) : "");
        r.put("paid12", rs.getDouble("paid_12m") != 0 ? ClientStats.money(rs.getDouble("paid_12m")) : "");
        r.put("last", Util.dateToString(rs.getTimestamp("last_visit")));
        r.put("reg", Util.dateToString(rs.getTimestamp("crOn")));
        rows.add(r);
      }
      model.addAttribute("count", count);
      model.addAttribute("page", page);
      model.addAttribute("maxPage", maxPage);
      model.addAttribute("from", count == 0 ? 0 : (page - 1) * PAGE_SIZE + 1);
      model.addAttribute("to", Math.min(count, (long) page * PAGE_SIZE));
    } catch (Exception e) {
      e.printStackTrace();
      model.addAttribute("loadErr", e.getMessage());
    } finally {
      DB.done(conn, ps, rs);
    }
    model.addAttribute("rows", rows);
    model.addAttribute("seg", seg);
    model.addAttribute("flag", flag);
    model.addAttribute("q", q);
    model.addAttribute("sort", sort);
    model.addAttribute("canRefresh", true);
    return "/boss/clients/list";
  }

  private static String param(HttpServletRequest req, HashMap<String, String> filters, String key, String name, String def) {
    String v = req.getParameter(name);
    if (v == null) v = filters.containsKey(key) ? filters.get(key) : def;
    filters.put(key, v);
    return v;
  }

  private static PreparedStatement prepare(Connection conn, String sql, List<Object> args) throws Exception {
    PreparedStatement ps = conn.prepareStatement(sql);
    for (int i = 0; i < args.size(); i++) ps.setObject(i + 1, args.get(i));
    return ps;
  }

  // ѕересчЄт типов и итогов клиентов (ночью он идЄт автоматически)
  @RequestMapping(value = "refresh.s", method = RequestMethod.POST)
  @ResponseBody
  protected String refresh(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    if (!allowed(SessionUtil.getUser(req))) return Util.err(json, "Ќет доступа");
    try {
      json.put("count", ClientStats.refresh());
      json.put("success", true);
    } catch (Exception e) {
      e.printStackTrace();
      return Util.err(json, e.getMessage());
    }
    return json.toString();
  }

  //  арточка клиента дл€ руководства: реквизиты (только просмотр) и финансовый анализ
  @RequestMapping("view.s")
  protected String view(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    if (!allowed(session)) return "/boss/clients/denied";
    int id = Util.getInt(req, "id");
    Clients client = dClient.get(id);
    model.addAttribute("client", client);
    try {
      model.addAttribute("fin", ClientFinance.analyze(id));
    } catch (Exception e) {
      e.printStackTrace();
    }
    return "/boss/clients/view";
  }
}
