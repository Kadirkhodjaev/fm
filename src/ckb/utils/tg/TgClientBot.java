package ckb.utils.tg;

import ckb.utils.DB;
import ckb.utils.Util;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;

/**
 * Амбулаторные клиенты в боте пациентов (тот же бот, что и для стационара). Без QR и личных кодов:
 *
 * 1. Клиент открывает бота (сам или по ссылке, которую отправила регистратура) и отправляет свой номер телефона.
 *    Номер (последние 9 цифр) запоминается в Tg_Phone_Chats вместе с чатом.
 * 2. Клиент считается подключённым, если номер в его карточке (Crm_Clients.tel) совпадает с номером в боте.
 *    Регистратура видит это в карточке визита и отправляет PDF результатов кнопкой.
 * 3. Клиент сам скачивает результаты кнопкой "Мои результаты" - по всем карточкам с его номером.
 *
 * PDF результатов строит существующий QR-сервис клиники (result?id=<Amb_Patients.qrcode>), бот только пересылает файл.
 */
public class TgClientBot {

  private static volatile boolean tablesReady = false;

  /** SQL: последние 9 цифр телефона (пробелы, +, -, скобки убираются) */
  private static String tel9(String col) {
    return "Right(Replace(Replace(Replace(Replace(Replace(" + col + ", ' ', ''), '+', ''), '-', ''), '(', ''), ')', ''), 9)";
  }

  private static final String TEL9 = tel9("c.tel");
  /** Номер визита или номер карточки клиента совпадает с номером в боте */
  private static final String TEL9_ANY = "(" + TEL9 + " = ? Or " + tel9("a.tel") + " = ?)";

  static void initTables(Connection conn) throws Exception {
    if (tablesReady) return;
    PreparedStatement ps = conn.prepareStatement(
      "Create Table If Not Exists Tg_Phone_Chats (" +
      "  phone9 Char(9) Not Null Primary Key," +
      "  chat_id BigInt Not Null," +
      "  phone Varchar(32) Not Null," +
      "  linked_date DateTime Not Null," +
      "  Key tg_phone_chats_chat (chat_id)" +
      ") Default Charset = utf8");
    ps.executeUpdate();
    DB.done(ps);
    // Кто уже зарегистрировался по QR стационара - тоже считается зарегистрированным по номеру
    ps = conn.prepareStatement(
      "Insert Ignore Into Tg_Phone_Chats (phone9, chat_id, phone, linked_date) " +
      "Select " + tel9("phone") + ", chat_id, phone, Ifnull(linked_date, Now()) From Tg_Patient_Links " +
      " Where chat_id Is Not Null And Length(" + tel9("phone") + ") = 9 Order By linked_date Desc");
    ps.executeUpdate();
    DB.done(ps);
    // журнал отправки PDF результатов амбулаторного визита в Telegram (показывается в карточке визита)
    ps = conn.prepareStatement(
      "Create Table If Not Exists Amb_Result_Sent (" +
      "  id Int Not Null Auto_Increment Primary Key," +
      "  amb_id Int Not Null," +
      "  chat_id BigInt Not Null," +
      "  by_registry Char(1) Not Null," +
      "  sent_date DateTime Not Null," +
      "  Key amb_result_sent_amb (amb_id)" +
      ") Default Charset = utf8");
    ps.executeUpdate();
    DB.done(ps);
    tablesReady = true;
  }

  private static String e(int cp) {
    return new String(Character.toChars(cp));
  }

  static String tail9(String s) {
    String d = s == null ? "" : s.replaceAll("\\D", "");
    return d.length() >= 9 ? d.substring(d.length() - 9) : null;
  }

  // ---------- Регистратура ----------

  /** linked (Y/N), phone, linkedDate - по номеру визита (ambId, если есть) или по номеру в карточке клиента */
  public static Map<String, String> status(int clientId, int ambId) throws Exception {
    Map<String, String> m = new HashMap<>();
    m.put("linked", "N");
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      conn = DB.getConnection();
      initTables(conn);
      ps = conn.prepareStatement(
        "Select (Select tel From Amb_Patients Where id = ?), (Select tel From Crm_Clients Where id = ?)");
      ps.setInt(1, ambId);
      ps.setInt(2, clientId);
      rs = ps.executeQuery();
      rs.next();
      String a9 = tail9(rs.getString(1)), c9 = tail9(rs.getString(2));
      DB.done(rs);
      DB.done(ps);
      rs = null;
      ps = null;
      if (a9 == null && c9 == null) {
        m.put("noPhone", "Y");
        return m;
      }
      ps = conn.prepareStatement("Select phone, linked_date From Tg_Phone_Chats Where phone9 In (?, ?) Order By phone9 = ? Desc");
      ps.setString(1, Util.nvl(a9));
      ps.setString(2, Util.nvl(c9));
      ps.setString(3, Util.nvl(a9));
      rs = ps.executeQuery();
      if (rs.next()) {
        m.put("linked", "Y");
        m.put("phone", Util.nvl(rs.getString(1)));
        m.put("linkedDate", rs.getTimestamp(2) == null ? "" : Util.dateTimeToString(rs.getTimestamp(2)));
      }
    } finally {
      DB.done(conn, ps, rs);
    }
    return m;
  }

  /** Общая ссылка на бот для регистрации (её отправляет регистратура, если клиент ещё не зарегистрирован) */
  public static String link() {
    return "https://t.me/" + TgPatientBot.botName() + "?start=r";
  }

  /** Отправка результатов визита по кнопке регистратуры. null - отправлено, иначе текст ошибки */
  public static String sendResultFromRegistry(int ambId) throws Exception {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      conn = DB.getConnection();
      initTables(conn);
      ps = conn.prepareStatement("Select a.tel, c.tel From Amb_Patients a Left Join Crm_Clients c On c.id = a.client_Id Where a.id = ?");
      ps.setInt(1, ambId);
      rs = ps.executeQuery();
      String a9 = null, c9 = null;
      if (rs.next()) {
        a9 = tail9(rs.getString(1));
        c9 = tail9(rs.getString(2));
      }
      DB.done(rs);
      DB.done(ps);
      rs = null;
      ps = null;
      if (a9 == null && c9 == null) return "В визите и в карточке клиента нет полного номера телефона.";
      ps = conn.prepareStatement("Select chat_id From Tg_Phone_Chats Where phone9 In (?, ?) Order By phone9 = ? Desc");
      ps.setString(1, Util.nvl(a9));
      ps.setString(2, Util.nvl(c9));
      ps.setString(3, Util.nvl(a9));
      rs = ps.executeQuery();
      if (!rs.next()) return "Клиент ещё не зарегистрирован в боте с этим номером. Отправьте ему ссылку.";
      long chat = rs.getLong(1);
      DB.done(rs);
      DB.done(ps);
      rs = null;
      ps = null;
      return sendResult(conn, chat, ambId, true);
    } finally {
      DB.done(conn, ps, rs);
    }
  }

  // ---------- Бот ----------

  /** Номер (9 цифр), с которым этот чат зарегистрирован, или null */
  static String phoneOf(Connection conn, long chat) throws Exception {
    initTables(conn);
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      ps = conn.prepareStatement("Select phone9 From Tg_Phone_Chats Where chat_id = ? Order By linked_date Desc");
      ps.setLong(1, chat);
      rs = ps.executeQuery();
      return rs.next() ? rs.getString(1) : null;
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
  }

  /** Не null, если чат зарегистрирован как амбулаторный клиент (по номеру) */
  static Integer clientOf(Connection conn, long chat) throws Exception {
    return phoneOf(conn, chat) != null ? 0 : null;
  }

  /** /start (без кода), /start r, старые ссылки c<код>: просим номер телефона */
  static void startLink(Connection conn, long chat, String ignored) throws Exception {
    initTables(conn);
    TgPatientBot.askContact(chat, "Здравствуйте! Это помощник клиники «Фарход Мадад Шифо». Чтобы получать результаты анализов " +
      "и обследований в Telegram, отправьте свой номер телефона кнопкой ниже. Он должен совпадать с номером, который вы указываете в регистратуре.");
  }

  /** Номер от клиента: регистрируем чат по номеру. Всегда true (контакт обработан) */
  static boolean onContact(Connection conn, long chat, String phoneDigits) throws Exception {
    initTables(conn);
    String t9 = tail9(phoneDigits);
    if (t9 == null) {
      TgPatientBot.send(chat, "Не удалось прочитать номер. Попробуйте ещё раз кнопкой «Отправить мой номер».", null);
      return true;
    }
    remember(conn, chat, phoneDigits);
    int cards = countClients(conn, t9);
    TgPatientBot.send(chat, "Готово, вы зарегистрированы! " + (cards > 0
        ? "Ваши результаты анализов и обследований можно скачать кнопкой «Мои результаты», а регистратура сможет присылать их сюда."
        : "Когда вы придёте в клинику с этим номером, регистратура сможет присылать сюда ваши результаты."),
      menu());
    return true;
  }

  /** Запомнить номер чата (и при регистрации по QR стационара) */
  static void remember(Connection conn, long chat, String phoneDigits) throws Exception {
    initTables(conn);
    String d = phoneDigits == null ? "" : phoneDigits.replaceAll("\\D", "");
    String t9 = tail9(d);
    if (t9 == null) return;
    PreparedStatement ps = conn.prepareStatement(
      "Insert Into Tg_Phone_Chats (phone9, chat_id, phone, linked_date) Values (?, ?, ?, Now()) " +
      "On Duplicate Key Update chat_id = Values(chat_id), phone = Values(phone), linked_date = Now()");
    ps.setString(1, t9);
    ps.setLong(2, chat);
    ps.setString(3, "+" + d);
    ps.executeUpdate();
    DB.done(ps);
  }

  private static int countClients(Connection conn, String t9) throws Exception {
    PreparedStatement ps = conn.prepareStatement("Select Count(*) From Crm_Clients c Where " + TEL9 + " = ?");
    ps.setString(1, t9);
    ResultSet rs = ps.executeQuery();
    int n = rs.next() ? rs.getInt(1) : 0;
    DB.done(rs);
    DB.done(ps);
    return n;
  }

  static JSONObject menu() throws Exception {
    JSONObject kb = new JSONObject();
    kb.put("keyboard", new JSONArray().put(new JSONArray().put(e(0x1F4CB) + " Мои результаты")));
    kb.put("resize_keyboard", true);
    return kb;
  }

  /** Визиты с результатами по всем карточкам с номером этого чата: кнопка на визит, по нажатию бот присылает PDF */
  static void showResults(Connection conn, long chat, Integer ignored) throws Exception {
    String t9 = phoneOf(conn, chat);
    if (t9 == null) {
      startLink(conn, chat, null);
      return;
    }
    PreparedStatement ps = null;
    ResultSet rs = null;
    JSONArray rows = new JSONArray();
    try {
      ps = conn.prepareStatement(
        "Select a.id, a.Reg_Date, " +
        "       (Select Group_Concat(v.name Separator ', ') From Amb_Patient_Services s Join Amb_Services v On v.id = s.service_Id " +
        "         Where s.patient = a.id And s.state = 'DONE') names " +
        "  From Amb_Patients a Left Join Crm_Clients c On c.id = a.client_Id " +
        " Where " + TEL9_ANY + " And a.qrcode Is Not Null And a.qrcode != '' " +
        "   And Exists (Select 1 From Amb_Patient_Services s Where s.patient = a.id And s.state = 'DONE') " +
        " Order By a.Reg_Date Desc Limit 10");
      ps.setString(1, t9);
      ps.setString(2, t9);
      rs = ps.executeQuery();
      while (rs.next()) {
        String names = Util.nvl(rs.getString("names"));
        if (names.length() > 40) names = names.substring(0, 39) + "…";
        JSONObject btn = new JSONObject();
        btn.put("text", Util.dateToString(rs.getTimestamp("Reg_Date")) + " · " + names);
        btn.put("callback_data", "rs:" + rs.getInt("id"));
        rows.put(new JSONArray().put(btn));
      }
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
    if (rows.length() == 0) {
      TgPatientBot.send(chat, "Готовых результатов пока нет. Когда они будут готовы, их можно будет скачать здесь.", menu());
      return;
    }
    JSONObject kb = new JSONObject();
    kb.put("inline_keyboard", rows);
    TgPatientBot.send(chat, e(0x1F4CB) + " <b>Ваши результаты</b>\nВыберите визит, и я пришлю PDF:", kb);
  }

  /** Нажатие на визит в списке (callback rs:<amb id>): визит должен быть клиента с номером этого чата */
  static void onCallback(Connection conn, long chat, String data) throws Exception {
    String t9 = phoneOf(conn, chat);
    if (t9 == null) return;
    int ambId = Integer.parseInt(data.substring(3));
    PreparedStatement ps = conn.prepareStatement(
      "Select 1 From Amb_Patients a Left Join Crm_Clients c On c.id = a.client_Id Where a.id = ? And " + TEL9_ANY);
    ps.setInt(1, ambId);
    ps.setString(2, t9);
    ps.setString(3, t9);
    ResultSet rs = ps.executeQuery();
    boolean own = rs.next();
    DB.done(rs);
    DB.done(ps);
    if (!own) return;
    TgPatientBot.send(chat, "Готовлю файл, подождите несколько секунд…", null);
    String err = sendResult(conn, chat, ambId, false);
    if (err != null) TgPatientBot.send(chat, err, menu());
  }

  /** Скачивает PDF результатов визита у QR-сервиса и отправляет в чат. null - отправлено */
  static String sendResult(Connection conn, long chat, int ambId, boolean fromRegistry) throws Exception {
    PreparedStatement ps = conn.prepareStatement("Select qrcode, Reg_Date From Amb_Patients Where id = ?");
    ps.setInt(1, ambId);
    ResultSet rs = ps.executeQuery();
    String qr = null;
    String date = "";
    if (rs.next()) {
      qr = rs.getString(1);
      date = Util.dateToString(rs.getTimestamp(2));
    }
    DB.done(rs);
    DB.done(ps);
    if (qr == null || qr.isEmpty()) return "У этого визита нет результатов для отправки.";
    String base = resultUrl(conn);
    if (base.isEmpty()) return "Не настроен адрес сервиса результатов (amb.result.url).";
    byte[] pdf;
    try {
      pdf = download(base + qr);
    } catch (Exception ex) {
      System.err.println("TG_RESULT_PDF_ERR amb=" + ambId + ": " + ex.getMessage());
      return "Не удалось получить PDF у сервиса результатов. Попробуйте позже.";
    }
    String caption = "Результаты от " + date + (fromRegistry ? ". Отправлено регистратурой клиники." : "");
    if (!Tg.sendDocument(TgPatientBot.token(), chat, "result_" + date.replace(".", "") + ".pdf", pdf, caption)) return "Telegram не принял файл, попробуйте ещё раз.";
    try {
      initTables(conn);
      ps = conn.prepareStatement("Insert Into Amb_Result_Sent (amb_id, chat_id, by_registry, sent_date) Values (?, ?, ?, Now())");
      ps.setInt(1, ambId);
      ps.setLong(2, chat);
      ps.setString(3, fromRegistry ? "Y" : "N");
      ps.executeUpdate();
      DB.done(ps);
    } catch (Exception e) {
      System.err.println("TG_RESULT_LOG_ERR amb=" + ambId + ": " + e.getMessage());
    }
    return null;
  }

  /**
   * Отправлены ли результаты визита: последняя отправка PDF в Telegram (sent, sentCount, byRegistry)
   * и последнее открытие файла в приложении пациента (opened, openCount). Пустая карта — не отправлялись.
   */
  public static Map<String, Object> resultSentInfo(int ambId) {
    Map<String, Object> m = new HashMap<String, Object>();
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      conn = DB.getConnection();
      initTables(conn);
      ps = conn.prepareStatement("Select Count(*), Max(sent_date), Max(Case When by_registry = 'Y' Then 1 Else 0 End) From Amb_Result_Sent Where amb_id = ?");
      ps.setInt(1, ambId);
      rs = ps.executeQuery();
      if (rs.next() && rs.getInt(1) > 0) {
        m.put("sentCount", rs.getInt(1));
        m.put("sent", Util.dateTimeToString(rs.getTimestamp(2)));
        m.put("byRegistry", rs.getInt(3) == 1);
      }
      DB.done(rs);
      DB.done(ps);
      rs = null;
      ps = null;
      try {
        ps = conn.prepareStatement("Select Count(*), Max(created) From Mob_File_Log Where kind = 'RESULT' And ref_id = ?");
        ps.setInt(1, ambId);
        rs = ps.executeQuery();
        if (rs.next() && rs.getInt(1) > 0) {
          m.put("openCount", rs.getInt(1));
          m.put("opened", Util.dateTimeToString(rs.getTimestamp(2)));
        }
      } catch (Exception ignore) {
        // таблицы приложения может ещё не быть
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn, ps, rs);
    }
    return m;
  }

  /** PDF результатов визита для приложения пациента (тот же файл, что уходит кнопкой «Отправить результаты») */
  public static byte[] resultPdf(Connection conn, int ambId) throws Exception {
    PreparedStatement ps = conn.prepareStatement("Select qrcode From Amb_Patients Where id = ?");
    ps.setInt(1, ambId);
    ResultSet rs = ps.executeQuery();
    String qr = rs.next() ? rs.getString(1) : null;
    DB.done(rs);
    DB.done(ps);
    if (qr == null || qr.isEmpty()) throw new RuntimeException("no qrcode");
    String base = resultUrl(conn);
    if (base.isEmpty()) throw new RuntimeException("amb.result.url is not set");
    return download(base + qr);
  }

  /** amb.result.url из telegram.properties; если пусто - QR-сервис из параметра QRCODEURL (адрес до "qrcode?url=") + "result?id=" */
  private static String resultUrl(Connection conn) throws Exception {
    String u = Tg.props().getProperty("amb.result.url", "").trim();
    if (!u.isEmpty()) return u;
    PreparedStatement ps = conn.prepareStatement("Select val From Params Where code = 'QRCODEURL'");
    ResultSet rs = ps.executeQuery();
    String q = rs.next() ? Util.nvl(rs.getString(1)) : "";
    DB.done(rs);
    DB.done(ps);
    int i = q.indexOf("qrcode?url=");
    if (i > 0) return q.substring(0, i) + "result?id=";
    i = q.indexOf("url=");
    return i >= 0 ? q.substring(i + 4) : "";
  }

  private static byte[] download(String url) throws Exception {
    HttpURLConnection c = (HttpURLConnection) new URL(url).openConnection();
    try {
      c.setConnectTimeout(10000);
      c.setReadTimeout(90000);
      int code = c.getResponseCode();
      if (code >= 400) throw new RuntimeException("HTTP " + code);
      ByteArrayOutputStream out = new ByteArrayOutputStream();
      try (InputStream in = c.getInputStream()) {
        byte[] buf = new byte[8192];
        int n;
        while ((n = in.read(buf)) > 0) out.write(buf, 0, n);
      }
      byte[] b = out.toByteArray();
      if (b.length < 5 || b[0] != '%' || b[1] != 'P' || b[2] != 'D' || b[3] != 'F') throw new RuntimeException("not a PDF");
      return b;
    } finally {
      c.disconnect();
    }
  }
}
