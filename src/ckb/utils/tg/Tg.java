package ckb.utils.tg;

import ckb.utils.DB;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

/**
 * Telegram-бот для сотрудников: привязка пользователя к чату и отправка уведомлений.
 *
 * Токен бота лежит в /telegram.properties (bot.token), без него всё молча выключено.
 * Привязка хранится в отдельной таблице Tg_Users (а не в Users), потому что Users
 * кэшируется Hibernate и сохранение пользователя из админки затирало бы chat_id.
 *
 * Пользователь в МедОнлайн жмёт "Подключить Telegram" -> получает ссылку t.me/<бот>?start=<код>
 * -> бот получает "/start <код>" и записывает chat_id, затем просит поделиться номером телефона.
 */
public class Tg {

  private static final String API = "https://api.telegram.org/bot";

  private static volatile Properties props;
  private static volatile String botName;
  private static volatile boolean tablesReady = false;
  private static long updateOffset = 0;

  // ---------- Настройки ----------

  /**
   * Где запущен fm: "prod" - служба Tomcat на сервере, "dev" - Tomcat из IntelliJ (папка JetBrains).
   * Можно задать явно: -Dfm.env=dev|prod или переменная окружения FM_ENV.
   */
  public static String env() {
    String e = System.getProperty("fm.env");
    if (e == null || e.trim().isEmpty()) e = System.getenv("FM_ENV");
    if (e != null && !e.trim().isEmpty()) return e.trim().toLowerCase();
    String base = System.getProperty("catalina.base", "") + "|" + System.getProperty("catalina.home", "");
    return base.contains("JetBrains") ? "dev" : "prod";
  }

  public static boolean isProd() {
    return "prod".equals(env());
  }

  /** Эти параметры вне prod берутся только из dev.*: боевые боты на компьютере разработчика не запускаются никогда */
  private static final String[] ENV_KEYS = {"bot.token", "bot.name", "patient.bot.token", "patient.bot.name", "invite.url", "invite.token"};

  /**
   * telegram.properties: общие параметры + боевые (bot.token и т.д.) + для разработки с префиксом dev. (dev.bot.token и т.д.).
   * В prod ключи dev.* не читаются; вне prod любой dev.ключ заменяет ключ, а боты без dev.*-токена выключены.
   */
  static Properties props() {
    if (props == null) {
      Properties p = new Properties();
      try (InputStream is = Tg.class.getResourceAsStream("/telegram.properties")) {
        if (is != null) p.load(is);
      } catch (Exception e) {
        e.printStackTrace();
      }
      Properties r = new Properties();
      for (String k : p.stringPropertyNames()) if (!k.startsWith("dev.")) r.setProperty(k, p.getProperty(k));
      if (!isProd()) {
        for (String k : ENV_KEYS) r.setProperty(k, p.getProperty("dev." + k, ""));
        for (String k : p.stringPropertyNames()) if (k.startsWith("dev.")) r.setProperty(k.substring(4), p.getProperty(k));
      }
      System.out.println("TG_ENV " + env() + ": бот сотрудников " + (r.getProperty("bot.token", "").trim().isEmpty() ? "выключен" : "включён") +
        ", бот пациентов " + (r.getProperty("patient.bot.token", "").trim().isEmpty() ? "выключен" : "включён"));
      props = r;
    }
    return props;
  }

  private static String token() {
    return props().getProperty("bot.token", "").trim();
  }

  public static boolean isEnabled() {
    return !token().isEmpty();
  }

  /** Имя бота (без @): из настроек или из getMe */
  public static String botName() {
    if (botName == null) {
      String n = props().getProperty("bot.name", "").trim();
      if (n.isEmpty() && isEnabled()) {
        try {
          n = call("getMe", new JSONObject()).getJSONObject("result").getString("username");
        } catch (Exception e) {
          e.printStackTrace();
          return "";
        }
      }
      botName = n.startsWith("@") ? n.substring(1) : n;
    }
    return botName;
  }

  // ---------- Таблицы ----------

  /** Создаёт таблицы при первом обращении. Возвращает true, если журнал событий только что создан (пустой). */
  public static boolean initTables(Connection conn) throws Exception {
    if (tablesReady) return false;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      ps = conn.prepareStatement(
        "Create Table If Not Exists Tg_Users (" +
        "  user_id Int Not Null Primary Key," +
        "  chat_id BigInt Null," +
        "  phone Varchar(32) Null," +
        "  code Varchar(32) Null," +
        "  code_date DateTime Null," +
        "  linked_date DateTime Null," +
        "  Key tg_users_code (code)" +
        ") Default Charset = utf8");
      ps.executeUpdate();
      DB.done(ps);
      // журнал уже обработанных событий: одно событие - одно уведомление, без повторов
      ps = conn.prepareStatement(
        "Create Table If Not Exists Tg_Events (" +
        "  kind Varchar(32) Not Null," +
        "  ref_id Int Not Null," +
        "  user_id Int Not Null," +
        "  sent_date DateTime Not Null," +
        "  Primary Key (kind, ref_id, user_id)" +
        ") Default Charset = utf8");
      ps.executeUpdate();
      DB.done(ps);
      // типы уведомлений, отключённые администратором для пользователя
      ps = conn.prepareStatement(
        "Create Table If Not Exists Tg_User_Off (" +
        "  user_id Int Not Null," +
        "  kind Varchar(32) Not Null," +
        "  Primary Key (user_id, kind)" +
        ") Default Charset = utf8");
      ps.executeUpdate();
      DB.done(ps);
      // история отправленных сообщений (для администратора)
      ps = conn.prepareStatement(
        "Create Table If Not Exists Tg_Log (" +
        "  id Int Not Null Auto_Increment Primary Key," +
        "  user_id Int Not Null," +
        "  kind Varchar(32) Not Null," +
        "  text Text," +
        "  ok Char(1) Not Null," +
        "  sent_date DateTime Not Null," +
        "  sent_by Int Null," +
        "  Key tg_log_user (user_id, sent_date)" +
        ") Default Charset = utf8");
      ps.executeUpdate();
      DB.done(ps);
      ps = conn.prepareStatement("Select Count(*) From Tg_Events");
      rs = ps.executeQuery();
      rs.next();
      boolean empty = rs.getLong(1) == 0;
      tablesReady = true;
      return empty;
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
  }

  // ---------- Журнал событий ----------

  /** Отмечает событие как обработанное. false - если оно уже было отмечено раньше. */
  public static boolean markEvent(Connection conn, String kind, int refId, int userId) throws Exception {
    PreparedStatement ps = null;
    try {
      ps = conn.prepareStatement("Insert Ignore Into Tg_Events (kind, ref_id, user_id, sent_date) Values (?, ?, ?, Now())");
      ps.setString(1, kind);
      ps.setInt(2, refId);
      ps.setInt(3, userId);
      return ps.executeUpdate() > 0;
    } finally {
      DB.done(ps);
    }
  }

  // ---------- Типы уведомлений ----------

  public static final String LV_NEW = "LV_NEW";
  public static final String GLV_NEW = "GLV_NEW";
  public static final String SICK_REPEAT = "SICK_REPEAT";
  public static final String AMB_CONSUL = "AMB_CONSUL";
  public static final String LV_CONSUL = "LV_CONSUL";
  public static final String P_QUESTION = "P_QUESTION";
  public static final String DIET_CHANGE = "DIET_CHANGE";
  public static final String TABS_CHANGE = "TABS_CHANGE";
  public static final String MANUAL = "MANUAL";

  /** Типы уведомлений, которые администратор может включать и отключать. Новый тип - одна строка здесь. */
  public static final Map<String, String> KINDS = new LinkedHashMap<>();
  static {
    KINDS.put(LV_NEW, "Новый пациент (ЛВ)");
    KINDS.put(GLV_NEW, "Новый пациент (главврачу)");
    KINDS.put(SICK_REPEAT, "Повторный больничный");
    KINDS.put(AMB_CONSUL, "Консультация амбулатории");
    KINDS.put(LV_CONSUL, "Консультация стационара");
    KINDS.put(P_QUESTION, "Вопрос пациента");
    KINDS.put(DIET_CHANGE, "Смена стола питания");
    KINDS.put(TABS_CHANGE, "Назначения: таблетки");
  }

  public static String kindName(String kind) {
    if (MANUAL.equals(kind)) return "Сообщение администратора";
    return KINDS.containsKey(kind) ? KINDS.get(kind) : kind;
  }

  // ---------- Отправка ----------

  /**
   * Уведомление пользователю МедОнлайн: уходит, если он привязал Telegram и администратор
   * не отключил ему этот тип. Каждая отправка пишется в Tg_Log.
   */
  public static boolean notify(Connection conn, int userId, String kind, String html) {
    Long chat = chatId(conn, userId);
    if (chat == null || isOff(conn, userId, kind)) return false;
    boolean ok = send(chat, html);
    log(conn, userId, kind, html, ok, null);
    return ok;
  }

  /** Одно и то же уведомление нескольким пользователям. Возвращает число доставленных. */
  public static int notifyUsers(Connection conn, List<Integer> userIds, String kind, String html) {
    int n = 0;
    for (Integer id : userIds) {
      if (id != null && notify(conn, id, kind, html)) n++;
    }
    return n;
  }

  /** Сообщение от администратора (обычный текст) */
  public static boolean sendManual(Connection conn, int userId, String text, int byUser) throws Exception {
    initTables(conn);
    Long chat = chatId(conn, userId);
    if (chat == null) return false;
    String html = new String(Character.toChars(0x2709)) + " <b>Сообщение от администратора</b>\n" + esc(text);
    boolean ok = send(chat, html);
    log(conn, userId, MANUAL, html, ok, byUser);
    return ok;
  }

  public static boolean isOff(Connection conn, int userId, String kind) {
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      ps = conn.prepareStatement("Select 1 From Tg_User_Off Where user_id = ? And kind = ?");
      ps.setInt(1, userId);
      ps.setString(2, kind);
      rs = ps.executeQuery();
      return rs.next();
    } catch (Exception e) {
      e.printStackTrace();
      return false;
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
  }

  public static void setOff(Connection conn, int userId, String kind, boolean off) throws Exception {
    initTables(conn);
    PreparedStatement ps = null;
    try {
      ps = conn.prepareStatement(off
        ? "Insert Ignore Into Tg_User_Off (user_id, kind) Values (?, ?)"
        : "Delete From Tg_User_Off Where user_id = ? And kind = ?");
      ps.setInt(1, userId);
      ps.setString(2, kind);
      ps.executeUpdate();
    } finally {
      DB.done(ps);
    }
  }

  /**
   * Убирает символы вне BMP (эмодзи и другие 4-байтовые символы): колонки utf8 в MySQL 5.0 их не хранят,
   * в строгом режиме вставка падала целиком и уведомление не попадало в историю.
   */
  public static String bmp(String s) {
    if (s == null) return null;
    StringBuilder b = new StringBuilder(s.length());
    for (int i = 0; i < s.length(); ) {
      int cp = s.codePointAt(i);
      if (cp <= 0xFFFF) b.appendCodePoint(cp);
      i += Character.charCount(cp);
    }
    return b.toString().replaceAll("^\\s+", "");
  }

  private static void log(Connection conn, int userId, String kind, String html, boolean ok, Integer byUser) {
    PreparedStatement ps = null;
    try {
      ps = conn.prepareStatement("Insert Into Tg_Log (user_id, kind, text, ok, sent_date, sent_by) Values (?, ?, ?, ?, Now(), ?)");
      ps.setInt(1, userId);
      ps.setString(2, kind);
      ps.setString(3, bmp(html.replaceAll("<[^>]+>", "").replace("&lt;", "<").replace("&gt;", ">").replace("&amp;", "&")));
      ps.setString(4, ok ? "Y" : "N");
      if (byUser == null) ps.setNull(5, java.sql.Types.INTEGER); else ps.setInt(5, byUser);
      ps.executeUpdate();
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(ps);
    }
  }

  public static boolean send(long chatId, String html) {
    return send(chatId, html, null);
  }

  private static boolean send(long chatId, String html, JSONObject replyMarkup) {
    if (!isEnabled()) return false;
    try {
      JSONObject body = new JSONObject();
      body.put("chat_id", chatId);
      body.put("text", html);
      body.put("parse_mode", "HTML");
      body.put("disable_web_page_preview", true);
      if (replyMarkup != null) body.put("reply_markup", replyMarkup);
      return call("sendMessage", body).optBoolean("ok");
    } catch (Exception e) {
      System.err.println("TG_SEND_ERR chat=" + chatId + ": " + e.getMessage());
      return false;
    }
  }

  /** Экранирование текста для parse_mode=HTML */
  public static String esc(String s) {
    if (s == null) return "";
    return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
  }

  public static Long chatId(Connection conn, int userId) {
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      ps = conn.prepareStatement("Select chat_id From Tg_Users Where user_id = ? And chat_id Is Not Null");
      ps.setInt(1, userId);
      rs = ps.executeQuery();
      return rs.next() ? rs.getLong(1) : null;
    } catch (Exception e) {
      e.printStackTrace();
      return null;
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
  }

  // ---------- Привязка (вызывается со страницы пользователя) ----------

  /** Статус привязки для страницы пользователя: [привязан?, телефон] */
  public static String[] status(int userId) {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      conn = DB.getConnection();
      initTables(conn);
      ps = conn.prepareStatement("Select chat_id, phone From Tg_Users Where user_id = ?");
      ps.setInt(1, userId);
      rs = ps.executeQuery();
      if (rs.next() && rs.getObject("chat_id") != null)
        return new String[]{"Y", rs.getString("phone") == null ? "" : rs.getString("phone")};
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn, ps, rs);
    }
    return new String[]{"N", ""};
  }

  /** Новый одноразовый код и ссылка на бота для привязки */
  public static String linkUrl(int userId) throws Exception {
    byte[] b = new byte[12];
    new SecureRandom().nextBytes(b);
    StringBuilder code = new StringBuilder();
    for (byte x : b) code.append(String.format("%02x", x));
    Connection conn = null;
    PreparedStatement ps = null;
    try {
      conn = DB.getConnection();
      initTables(conn);
      ps = conn.prepareStatement(
        "Insert Into Tg_Users (user_id, code, code_date) Values (?, ?, Now()) " +
        "On Duplicate Key Update code = Values(code), code_date = Now()");
      ps.setInt(1, userId);
      ps.setString(2, code.toString());
      ps.executeUpdate();
    } finally {
      DB.done(ps);
      DB.done(conn);
    }
    return "https://t.me/" + botName() + "?start=" + code;
  }

  public static void unlink(int userId) throws Exception {
    Connection conn = null;
    PreparedStatement ps = null;
    try {
      conn = DB.getConnection();
      initTables(conn);
      ps = conn.prepareStatement("Delete From Tg_Users Where user_id = ?");
      ps.setInt(1, userId);
      ps.executeUpdate();
    } finally {
      DB.done(ps);
      DB.done(conn);
    }
  }

  // ---------- Входящие сообщения бота ----------

  /** Забирает новые сообщения бота (getUpdates) и обрабатывает /start, /stop и номер телефона. */
  /** Долгий опрос: Telegram держит запрос до waitSec секунд и отвечает сразу, как придёт сообщение. */
  static void poll(int waitSec) throws Exception {
    JSONObject body = new JSONObject();
    body.put("offset", updateOffset);
    body.put("timeout", waitSec);
    body.put("allowed_updates", new JSONArray().put("message"));
    JSONArray updates = call(token(), "getUpdates", body, waitSec).optJSONArray("result");
    if (updates == null || updates.length() == 0) return;
    // соединение с базой берём только когда есть сообщения, а не на всё время ожидания
    Connection conn = DB.getConnection();
    if (conn == null) return;
    try {
      initTables(conn);
      handle(conn, updates);
    } finally {
      DB.done(conn);
    }
  }

  private static void handle(Connection conn, JSONArray updates) throws Exception {
    for (int i = 0; i < updates.length(); i++) {
      JSONObject u = updates.getJSONObject(i);
      updateOffset = Math.max(updateOffset, u.getLong("update_id") + 1);
      JSONObject msg = u.optJSONObject("message");
      if (msg == null) continue;
      JSONObject chat = msg.optJSONObject("chat");
      if (chat == null || !"private".equals(chat.optString("type"))) continue;
      try {
        onMessage(conn, chat.getLong("id"), msg);
      } catch (Exception e) {
        e.printStackTrace();
      }
    }
  }

  private static void onMessage(Connection conn, long chatId, JSONObject msg) throws Exception {
    JSONObject contact = msg.optJSONObject("contact");
    if (contact != null) {
      onContact(conn, chatId, msg, contact);
      return;
    }
    String text = msg.optString("text", "").trim();
    if (text.startsWith("/start")) {
      String code = text.length() > 6 ? text.substring(6).trim() : "";
      if (code.isEmpty()) {
        send(chatId, linkedFio(conn, chatId) != null
          ? "Вы уже подключены к уведомлениям МедОнлайн."
          : "Чтобы получать уведомления, откройте МедОнлайн, нажмите на своё имя вверху и затем <b>Подключить Telegram</b>.");
        return;
      }
      link(conn, chatId, code);
    } else if (text.startsWith("/stop")) {
      PreparedStatement ps = conn.prepareStatement("Delete From Tg_Users Where chat_id = ?");
      ps.setLong(1, chatId);
      ps.executeUpdate();
      DB.done(ps);
      send(chatId, "Уведомления отключены. Подключить снова можно в МедОнлайн.", removeKeyboard());
    } else {
      String fio = linkedFio(conn, chatId);
      send(chatId, fio != null
        ? "Этот бот только присылает уведомления МедОнлайн. /stop - отключить."
        : "Чтобы получать уведомления, откройте МедОнлайн, нажмите на своё имя вверху и затем <b>Подключить Telegram</b>.");
    }
  }

  private static void link(Connection conn, long chatId, String code) throws Exception {
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      ps = conn.prepareStatement(
        "Select t.user_id, u.fio From Tg_Users t Join Users u On u.id = t.user_id " +
        " Where t.code = ? And t.code_date > Now() - Interval 1 Day");
      ps.setString(1, code);
      rs = ps.executeQuery();
      if (!rs.next()) {
        send(chatId, "Ссылка устарела или уже использована. Получите новую в МедОнлайн.");
        return;
      }
      int userId = rs.getInt("user_id");
      String fio = rs.getString("fio");
      DB.done(rs);
      DB.done(ps);
      rs = null;
      // один чат - один пользователь
      ps = conn.prepareStatement("Update Tg_Users Set chat_id = Null Where chat_id = ? And user_id != ?");
      ps.setLong(1, chatId);
      ps.setInt(2, userId);
      ps.executeUpdate();
      DB.done(ps);
      ps = conn.prepareStatement("Update Tg_Users Set chat_id = ?, code = Null, code_date = Null, linked_date = Now() Where user_id = ?");
      ps.setLong(1, chatId);
      ps.setInt(2, userId);
      ps.executeUpdate();
      JSONObject kb = new JSONObject();
      JSONObject btn = new JSONObject();
      btn.put("text", "Поделиться номером");
      btn.put("request_contact", true);
      kb.put("keyboard", new JSONArray().put(new JSONArray().put(btn)));
      kb.put("resize_keyboard", true);
      kb.put("one_time_keyboard", true);
      send(chatId, "Готово, <b>" + esc(fio) + "</b>, вы будете получать уведомления МедОнлайн.\nПоделитесь, пожалуйста, номером телефона кнопкой ниже.", kb);
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
  }

  private static void onContact(Connection conn, long chatId, JSONObject msg, JSONObject contact) throws Exception {
    JSONObject from = msg.optJSONObject("from");
    // принимаем только собственный номер, а не пересланный чужой контакт
    if (from == null || contact.optLong("user_id") != from.optLong("id")) {
      send(chatId, "Отправьте, пожалуйста, свой номер кнопкой <b>Поделиться номером</b>.");
      return;
    }
    PreparedStatement ps = conn.prepareStatement("Update Tg_Users Set phone = ? Where chat_id = ?");
    String phone = contact.optString("phone_number", "");
    ps.setString(1, phone.startsWith("+") ? phone : "+" + phone);
    ps.setLong(2, chatId);
    int n = ps.executeUpdate();
    DB.done(ps);
    send(chatId, n > 0 ? "Спасибо, номер сохранён." : "Сначала подключитесь по ссылке из МедОнлайн.", removeKeyboard());
  }

  private static String linkedFio(Connection conn, long chatId) throws Exception {
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      ps = conn.prepareStatement("Select u.fio From Tg_Users t Join Users u On u.id = t.user_id Where t.chat_id = ?");
      ps.setLong(1, chatId);
      rs = ps.executeQuery();
      return rs.next() ? rs.getString(1) : null;
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
  }

  private static JSONObject removeKeyboard() throws Exception {
    JSONObject kb = new JSONObject();
    kb.put("remove_keyboard", true);
    return kb;
  }

  // ---------- HTTP ----------

  /** Отправка файла (sendDocument, multipart/form-data) любым ботом */
  static boolean sendDocument(String botToken, long chatId, String fileName, byte[] data, String caption) {
    String boundary = "----fm" + Long.toHexString(System.nanoTime());
    HttpURLConnection c = null;
    try {
      c = (HttpURLConnection) new URL(API + botToken + "/sendDocument").openConnection();
      c.setConnectTimeout(10000);
      c.setReadTimeout(60000);
      c.setRequestMethod("POST");
      c.setDoOutput(true);
      c.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + boundary);
      try (OutputStream os = c.getOutputStream()) {
        String head =
          "--" + boundary + "\r\nContent-Disposition: form-data; name=\"chat_id\"\r\n\r\n" + chatId + "\r\n" +
          (caption == null ? "" : "--" + boundary + "\r\nContent-Disposition: form-data; name=\"caption\"\r\n\r\n" + caption + "\r\n") +
          "--" + boundary + "\r\nContent-Disposition: form-data; name=\"document\"; filename=\"" + fileName + "\"\r\n" +
          "Content-Type: application/octet-stream\r\n\r\n";
        os.write(head.getBytes("UTF-8"));
        os.write(data);
        os.write(("\r\n--" + boundary + "--\r\n").getBytes("UTF-8"));
      }
      int code = c.getResponseCode();
      if (code >= 400) System.err.println("TG_DOC_ERR chat=" + chatId + ": HTTP " + code);
      return code < 400;
    } catch (Exception e) {
      System.err.println("TG_DOC_ERR chat=" + chatId + ": " + e.getMessage());
      return false;
    } finally {
      if (c != null) c.disconnect();
    }
  }

  private static JSONObject call(String method, JSONObject body) throws Exception {
    return call(token(), method, body);
  }

  /** Вызов Bot API любым ботом (бот пациентов использует свой токен) */
  static JSONObject call(String botToken, String method, JSONObject body) throws Exception {
    return call(botToken, method, body, 0);
  }

  /** waitSec - сколько Telegram может держать запрос (getUpdates с timeout), чтение ждём дольше */
  static JSONObject call(String botToken, String method, JSONObject body, int waitSec) throws Exception {
    HttpURLConnection c = (HttpURLConnection) new URL(API + botToken + "/" + method).openConnection();
    try {
      c.setConnectTimeout(10000);
      c.setReadTimeout(20000 + waitSec * 1000);
      c.setRequestMethod("POST");
      c.setDoOutput(true);
      c.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
      try (OutputStream os = c.getOutputStream()) {
        os.write(body.toString().getBytes("UTF-8"));
      }
      int code = c.getResponseCode();
      InputStream is = code >= 400 ? c.getErrorStream() : c.getInputStream();
      ByteArrayOutputStream out = new ByteArrayOutputStream();
      if (is != null) {
        try (InputStream in = is) {
          byte[] buf = new byte[4096];
          int n;
          while ((n = in.read(buf)) > 0) out.write(buf, 0, n);
        }
      }
      String res = out.toString("UTF-8");
      if (code >= 400) throw new RuntimeException("Telegram " + method + " HTTP " + code + ": " + res);
      return new JSONObject(res);
    } finally {
      c.disconnect();
    }
  }

  /** Список id пользователей из запроса с одним параметром-числом */
  static List<Integer> ids(Connection conn, String sql, int param) throws Exception {
    List<Integer> list = new ArrayList<>();
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      ps = conn.prepareStatement(sql);
      ps.setInt(1, param);
      rs = ps.executeQuery();
      while (rs.next()) list.add(rs.getInt(1));
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
    return list;
  }
}
