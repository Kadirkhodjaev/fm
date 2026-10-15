package ckb.utils.tg;

import ckb.utils.DB;
import ckb.utils.Util;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONObject;

import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Telegram-бот для пациентов стационара (отдельный бот, токен patient.bot.token в telegram.properties).
 *
 * Подключение: на посту печатают QR-код пациента (страница "Telegram пациента" в карточке, CLv) -> пациент
 * открывает бота по ссылке t.me/<бот>?start=p<код> -> делится номером телефона -> номер сверяется с карточкой.
 * Привязка к госпитализации (Patients.id) хранится в Tg_Patient_Links.
 *
 * Что умеет: "Мой день" (препараты по времени, физиотерапия, обследования, стол), "Ход лечения",
 * "Обследования", "Вопрос врачу" (уходит лечащему врачу в бот сотрудников), напоминания о приёме таблеток
 * с кнопкой "Принял", утренняя сводка, вечернее напоминание об обследованиях на завтра, "результат готов".
 * Значения анализов пациенту не показываются: только "готов, обсудите с лечащим врачом".
 */
public class TgPatientBot {

  private static long updateOffset = 0;
  private static volatile boolean tablesReady = false;
  private static volatile String botName;
  /** чат -> пациент, от которого ждём текст вопроса врачу */
  private static final Map<Long, Integer> awaitingQuestion = new HashMap<>();

  // ---------- Настройки ----------

  static String token() {
    return Tg.props().getProperty("patient.bot.token", "").trim();
  }

  public static boolean isEnabled() {
    return !token().isEmpty();
  }

  public static String botName() {
    if (botName == null) {
      String n = Tg.props().getProperty("patient.bot.name", "").trim();
      if (n.isEmpty() && isEnabled()) {
        try {
          n = Tg.call(token(), "getMe", new JSONObject()).getJSONObject("result").getString("username");
        } catch (Exception e) {
          e.printStackTrace();
          return "";
        }
      }
      botName = n.startsWith("@") ? n.substring(1) : n;
    }
    return botName;
  }

  /** Время напоминания из настроек, "08:00" -> минуты от полуночи */
  private static int time(String key, String def) {
    String v = Tg.props().getProperty(key, def).trim();
    try {
      String[] p = v.split(":");
      return Integer.parseInt(p[0].trim()) * 60 + (p.length > 1 ? Integer.parseInt(p[1].trim()) : 0);
    } catch (Exception e) {
      String[] p = def.split(":");
      return Integer.parseInt(p[0]) * 60 + Integer.parseInt(p[1]);
    }
  }

  private static String e(int codePoint) {
    return new String(Character.toChars(codePoint));
  }

  // ---------- Таблицы ----------

  static void initTables(Connection conn) throws Exception {
    if (tablesReady) return;
    exec(conn,
      "Create Table If Not Exists Tg_Patient_Links (" +
      "  patient_id Int Not Null Primary Key," +
      "  code Varchar(32) Not Null," +
      "  code_date DateTime Not Null," +
      "  chat_id BigInt Null," +
      "  pending_chat_id BigInt Null," +
      "  phone Varchar(32) Null," +
      "  linked_date DateTime Null," +
      "  Unique Key tg_patient_links_code (code)," +
      "  Key tg_patient_links_chat (chat_id)" +
      ") Default Charset = utf8");
    // уже отправленные напоминания: kind + ref_id (пациент или обследование) + день yyyymmdd
    exec(conn,
      "Create Table If Not Exists Tg_Patient_Sent (" +
      "  kind Varchar(16) Not Null," +
      "  ref_id Int Not Null," +
      "  day Int Not Null," +
      "  sent_date DateTime Not Null," +
      "  Primary Key (kind, ref_id, day)" +
      ") Default Charset = utf8");
    // отметки пациента "Принял" (вспомогательные, отметка медсестры остаётся главной)
    exec(conn,
      "Create Table If Not Exists Tg_Patient_Marks (" +
      "  patient_id Int Not Null," +
      "  day Int Not Null," +
      "  slot Char(1) Not Null," +
      "  taken_date DateTime Not Null," +
      "  Primary Key (patient_id, day, slot)" +
      ") Default Charset = utf8");
    exec(conn,
      "Create Table If Not Exists Tg_Patient_Questions (" +
      "  id Int Not Null Auto_Increment Primary Key," +
      "  patient_id Int Not Null," +
      "  chat_id BigInt Not Null," +
      "  text Text," +
      "  to_user Int Null," +
      "  delivered Char(1) Not Null," +
      "  sent_date DateTime Not Null," +
      "  Key tg_patient_questions_p (patient_id)" +
      ") Default Charset = utf8");
    tablesReady = true;
  }

  // ---------- Страница поста: код и статус ----------

  /** Статус пациента для страницы в карточке: code, linked (Y/N), phone, linked_date */
  public static Map<String, String> status(int patientId) throws Exception {
    Map<String, String> m = new HashMap<>();
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      conn = DB.getConnection();
      initTables(conn);
      ps = conn.prepareStatement("Select code, chat_id, phone, linked_date From Tg_Patient_Links Where patient_id = ?");
      ps.setInt(1, patientId);
      rs = ps.executeQuery();
      if (rs.next()) {
        m.put("code", rs.getString("code"));
        m.put("linked", rs.getObject("chat_id") != null ? "Y" : "N");
        m.put("phone", Util.nvl(rs.getString("phone")));
        m.put("linkedDate", rs.getTimestamp("linked_date") == null ? "" : Util.dateTimeToString(rs.getTimestamp("linked_date")));
      }
    } finally {
      DB.done(conn, ps, rs);
    }
    return m;
  }

  /** Код для QR. reset = true: новый код, старая привязка снимается. */
  public static String code(int patientId, boolean reset) throws Exception {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      conn = DB.getConnection();
      initTables(conn);
      if (!reset) {
        ps = conn.prepareStatement("Select code From Tg_Patient_Links Where patient_id = ?");
        ps.setInt(1, patientId);
        rs = ps.executeQuery();
        if (rs.next()) return rs.getString(1);
        DB.done(rs);
        DB.done(ps);
        rs = null;
      }
      byte[] b = new byte[9];
      new SecureRandom().nextBytes(b);
      StringBuilder code = new StringBuilder();
      for (byte x : b) code.append(String.format("%02x", x));
      ps = conn.prepareStatement(
        "Insert Into Tg_Patient_Links (patient_id, code, code_date) Values (?, ?, Now()) " +
        "On Duplicate Key Update code = Values(code), code_date = Now(), chat_id = Null, pending_chat_id = Null, phone = Null, linked_date = Null");
      ps.setInt(1, patientId);
      ps.setString(2, code.toString());
      ps.executeUpdate();
      return code.toString();
    } finally {
      DB.done(conn, ps, rs);
    }
  }

  public static String link(String code) {
    return "https://t.me/" + botName() + "?start=p" + code;
  }

  // ---------- Входящие ----------

  /** Долгий опрос (см. TgPoller): ответ приходит сразу, как пациент что-то нажал. */
  static void poll(int waitSec) throws Exception {
    JSONObject body = new JSONObject();
    body.put("offset", updateOffset);
    body.put("timeout", waitSec);
    body.put("allowed_updates", new JSONArray().put("message").put("callback_query"));
    JSONArray updates = Tg.call(token(), "getUpdates", body, waitSec).optJSONArray("result");
    if (updates == null || updates.length() == 0) return;
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
      try {
        if (u.optJSONObject("callback_query") != null) {
          onCallback(conn, u.getJSONObject("callback_query"));
          continue;
        }
        JSONObject msg = u.optJSONObject("message");
        if (msg == null) continue;
        JSONObject chat = msg.optJSONObject("chat");
        if (chat == null || !"private".equals(chat.optString("type"))) continue;
        onMessage(conn, chat.getLong("id"), msg);
      } catch (Exception e) {
        e.printStackTrace();
      }
    }
  }

  private static void onMessage(Connection conn, long chat, JSONObject msg) throws Exception {
    JSONObject contact = msg.optJSONObject("contact");
    if (contact != null) {
      onContact(conn, chat, msg, contact);
      return;
    }
    String text = msg.optString("text", "").trim();
    if (text.startsWith("/start")) {
      String code = text.length() > 6 ? text.substring(6).trim() : "";
      // c<код> - амбулаторный клиент (ссылка от регистратуры), p<код> - пациент стационара (QR на посту)
      if (code.startsWith("c") || code.equals("r")) {
        TgClientBot.startLink(conn, chat, code.substring(1));
        return;
      }
      if (code.startsWith("p")) code = code.substring(1);
      if (code.isEmpty()) {
        if (patientOf(conn, chat) != null) sendMenu(chat, "Вы уже подключены. Выберите раздел в меню ниже.");
        else if (TgClientBot.clientOf(conn, chat) != null) send(chat, "Вы уже подключены. Выберите действие в меню ниже.", TgClientBot.menu());
        else TgClientBot.startLink(conn, chat, null);
        return;
      }
      startLink(conn, chat, code);
      return;
    }
    Integer pid = patientOf(conn, chat);
    // амбулаторный клиент: результаты (и пациенту стационара, если он подключён ещё и как клиент)
    if (text.toLowerCase().contains("результат")) {
      Integer cid = TgClientBot.clientOf(conn, chat);
      if (cid != null) {
        TgClientBot.showResults(conn, chat, cid);
        return;
      }
    }
    if (pid == null && dischargedOf(conn, chat) == null && TgClientBot.clientOf(conn, chat) != null) {
      send(chat, "Чтобы скачать результаты анализов и обследований, нажмите «Мои результаты».", TgClientBot.menu());
      return;
    }
    if (pid == null) {
      // лечение завершено: можно только скачать выписку (когда касса закрыта)
      Integer done = dischargedOf(conn, chat);
      if (done != null) {
        if (text.toLowerCase().contains("выписк") && sendVypiska(conn, chat, done)) return;
        send(chat, "Ваше лечение завершено. Желаем крепкого здоровья!" +
          (hasVypiska(conn, done) ? " Выписку можно скачать кнопкой ниже." : " Выписка будет доступна здесь после закрытия кассы."), dischargeMenu(conn, done));
        return;
      }
      TgClientBot.startLink(conn, chat, null);
      return;
    }
    synchronized (awaitingQuestion) {
      if (awaitingQuestion.containsKey(chat) && !isMenu(text)) {
        awaitingQuestion.remove(chat);
        question(conn, chat, pid, text);
        return;
      }
      awaitingQuestion.remove(chat);
    }
    String t = text.toLowerCase();
    if (t.contains("мой день") || t.equals("/today")) send(chat, myDay(conn, pid, today()), menu());
    else if (t.contains("ход лечения") || t.equals("/progress")) send(chat, progress(conn, pid), menu());
    else if (t.contains("обследован") || t.equals("/exams")) send(chat, exams(conn, pid), menu());
    else if (t.contains("выписк") || t.equals("/vypiska")) {
      // касса может быть закрыта, пока пациент ещё в отделении
      if (!sendVypiska(conn, chat, pid))
        send(chat, "Выписка будет доступна здесь, как только врач её оформит и касса закроет ваш счёт.", menu());
    }
    else if (t.contains("вопрос врачу") || t.equals("/question")) {
      synchronized (awaitingQuestion) {
        awaitingQuestion.put(chat, pid);
      }
      send(chat, "Напишите ваш вопрос одним сообщением, я передам его лечащему врачу.", null);
    } else if (t.equals("/stop")) {
      PreparedStatement ps = conn.prepareStatement("Update Tg_Patient_Links Set chat_id = Null, linked_date = Null Where chat_id = ?");
      ps.setLong(1, chat);
      ps.executeUpdate();
      DB.done(ps);
      send(chat, "Бот отключён. Подключиться снова можно по QR-коду с поста.", removeKeyboard());
    } else sendMenu(chat, "Выберите раздел в меню ниже.");
  }

  private static boolean isMenu(String text) {
    String t = text.toLowerCase();
    return t.startsWith("/") || t.contains("мой день") || t.contains("ход лечения") || t.contains("обследован") || t.contains("вопрос врачу") || t.contains("выписк");
  }

  private static void startLink(Connection conn, long chat, String code) throws Exception {
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      ps = conn.prepareStatement(
        "Select l.patient_id, p.state, p.name From Tg_Patient_Links l Join Patients p On p.id = l.patient_id Where l.code = ?");
      ps.setString(1, code);
      rs = ps.executeQuery();
      if (!rs.next()) {
        send(chat, "Код не найден или устарел. Попросите на посту новый QR-код.", null);
        return;
      }
      int pid = rs.getInt(1);
      if (!"LV".equals(rs.getString(2))) {
        send(chat, "Лечение по этому коду уже завершено.", null);
        return;
      }
      DB.done(rs);
      DB.done(ps);
      rs = null;
      ps = conn.prepareStatement("Update Tg_Patient_Links Set pending_chat_id = ? Where patient_id = ?");
      ps.setLong(1, chat);
      ps.setInt(2, pid);
      ps.executeUpdate();
      askContact(chat, "Здравствуйте! Для защиты ваших данных подтвердите номер телефона кнопкой ниже. Он должен совпасть с номером в вашей карточке.");
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
  }

  /** Кнопка "Отправить мой номер" (request_contact) */
  static void askContact(long chat, String html) throws Exception {
    JSONObject kb = new JSONObject();
    JSONObject btn = new JSONObject();
    btn.put("text", e(0x1F4F1) + " Отправить мой номер");
    btn.put("request_contact", true);
    kb.put("keyboard", new JSONArray().put(new JSONArray().put(btn)));
    kb.put("resize_keyboard", true);
    kb.put("one_time_keyboard", true);
    send(chat, html, kb);
  }

  private static void onContact(Connection conn, long chat, JSONObject msg, JSONObject contact) throws Exception {
    JSONObject from = msg.optJSONObject("from");
    if (from == null || contact.optLong("user_id") != from.optLong("id")) {
      send(chat, "Отправьте, пожалуйста, свой номер кнопкой «Отправить мой номер».", null);
      return;
    }
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      ps = conn.prepareStatement(
        "Select l.patient_id, p.tel, p.name, p.middlename From Tg_Patient_Links l Join Patients p On p.id = l.patient_id " +
        " Where l.pending_chat_id = ? And p.state = 'LV' Order By l.code_date Desc");
      ps.setLong(1, chat);
      rs = ps.executeQuery();
      if (!rs.next()) {
        // не пациент стационара - может быть амбулаторный клиент по ссылке регистратуры
        if (TgClientBot.onContact(conn, chat, digits(contact.optString("phone_number", "")))) return;
        send(chat, "Сначала откройте ссылку от регистратуры или отсканируйте QR-код с поста.", removeKeyboard());
        return;
      }
      int pid = rs.getInt(1);
      String tel = digits(rs.getString(2));
      String name = (Util.nvl(rs.getString(3)) + " " + Util.nvl(rs.getString(4))).trim();
      String phone = digits(contact.optString("phone_number", ""));
      DB.done(rs);
      DB.done(ps);
      rs = null;
      // сверяем последние 9 цифр (номер без кода страны); если в карточке номера нет - принимаем
      if (tel.length() >= 9 && !tail(tel).equals(tail(phone))) {
        send(chat, "Номер не совпадает с номером в карточке. Попросите медсестру на посту проверить номер телефона в вашей карточке.", removeKeyboard());
        return;
      }
      ps = conn.prepareStatement(
        "Update Tg_Patient_Links Set chat_id = ?, pending_chat_id = Null, phone = ?, linked_date = Now() Where patient_id = ?");
      ps.setLong(1, chat);
      ps.setString(2, "+" + phone);
      ps.setInt(3, pid);
      ps.executeUpdate();
      TgClientBot.remember(conn, chat, phone);
      sendMenu(chat, "Готово, " + Tg.esc(name) + "! Здесь вы увидите свои назначения, процедуры и обследования, " +
        "а я буду напоминать о приёме таблеток.\n\n" + myDay(conn, pid, today()));
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
  }

  private static String digits(String s) {
    return s == null ? "" : s.replaceAll("\\D", "");
  }

  private static String tail(String s) {
    return s.length() > 9 ? s.substring(s.length() - 9) : s;
  }

  private static void onCallback(Connection conn, JSONObject cb) throws Exception {
    String data = cb.optString("data", "");
    JSONObject a = new JSONObject();
    a.put("callback_query_id", cb.getString("id"));
    // rs:<визит> - клиент выбрал результаты амбулатории
    if (data.startsWith("rs:")) {
      Tg.call(token(), "answerCallbackQuery", a);
      TgClientBot.onCallback(conn, cb.getJSONObject("message").getJSONObject("chat").getLong("id"), data);
      return;
    }
    // tk:<пациент>:<день>:<слот> - пациент нажал "Принял"
    if (data.startsWith("tk:")) {
      String[] p = data.split(":");
      long chat = cb.getJSONObject("message").getJSONObject("chat").getLong("id");
      Integer pid = patientOf(conn, chat);
      if (pid != null && p.length == 4 && pid == Integer.parseInt(p[1])) {
        PreparedStatement ps = conn.prepareStatement("Insert Ignore Into Tg_Patient_Marks (patient_id, day, slot, taken_date) Values (?, ?, ?, Now())");
        ps.setInt(1, pid);
        ps.setInt(2, Integer.parseInt(p[2]));
        ps.setString(3, p[3]);
        ps.executeUpdate();
        DB.done(ps);
        a.put("text", "Отмечено, спасибо!");
        // убираем кнопку и дописываем отметку
        JSONObject edit = new JSONObject();
        edit.put("chat_id", chat);
        edit.put("message_id", cb.getJSONObject("message").getLong("message_id"));
        edit.put("parse_mode", "HTML");
        edit.put("text", Tg.esc(cb.getJSONObject("message").optString("text", "")) + "\n\n" + e(0x2705) + " Принято в " + new SimpleDateFormat("HH:mm").format(new Date()));
        try {
          Tg.call(token(), "editMessageText", edit);
        } catch (Exception ex) {
          // старое сообщение могло быть удалено - не страшно
        }
      }
    }
    Tg.call(token(), "answerCallbackQuery", a);
  }

  // ---------- Вопрос врачу ----------

  private static void question(Connection conn, long chat, int pid, String text) throws Exception {
    if (text.isEmpty()) {
      send(chat, "Вопрос пустой. Нажмите «Вопрос врачу» и напишите текст.", menu());
      return;
    }
    if (text.length() > 2000) text = text.substring(0, 2000);
    PreparedStatement ps = null;
    ResultSet rs = null;
    Integer lv = null;
    Integer dept = null;
    String fio = "", room = "";
    try {
      ps = conn.prepareStatement(
        "Select p.lv_id, p.Dept_Id, p.surname, p.name, p.middlename, p.yearNum, IfNull(p.Palata, r.name) room " +
        "  From Patients p Left Join Rooms r On r.id = p.Room_Id Where p.id = ?");
      ps.setInt(1, pid);
      rs = ps.executeQuery();
      if (rs.next()) {
        lv = rs.getObject("lv_id") == null ? null : rs.getInt("lv_id");
        dept = rs.getObject("Dept_Id") == null ? null : rs.getInt("Dept_Id");
        fio = (Util.nvl(rs.getString("surname")) + " " + Util.nvl(rs.getString("name")) + " " + Util.nvl(rs.getString("middlename"))).trim()
          + (rs.getInt("yearNum") != 0 ? ", ИБ №" + rs.getInt("yearNum") : "");
        room = Util.nvl(rs.getString("room"));
      }
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
    String html = e(0x2709) + " <b>Вопрос пациента</b>\n" + Tg.esc(fio) + (room.isEmpty() ? "" : ", палата " + Tg.esc(room)) + "\n\n" + Tg.esc(text);
    Integer to = null;
    if (lv != null && Tg.isEnabled() && Tg.notify(conn, lv, Tg.P_QUESTION, html)) to = lv;
    // врач не подключён к боту сотрудников - вопрос получают постовые отделения
    if (to == null && dept != null && Tg.isEnabled()) {
      List<Integer> nurses = Tg.ids(conn,
        "Select Distinct u.id From Users u Join User_Roles ur On ur.users_id = u.id Where u.active = 1 And ur.roles_id = 11 And u.Dept_Id = ?", dept);
      if (Tg.notifyUsers(conn, nurses, Tg.P_QUESTION, html) > 0) to = 0;
    }
    ps = conn.prepareStatement("Insert Into Tg_Patient_Questions (patient_id, chat_id, text, to_user, delivered, sent_date) Values (?, ?, ?, ?, ?, Now())");
    ps.setInt(1, pid);
    ps.setLong(2, chat);
    ps.setString(3, Tg.bmp(text)); // эмодзи в вопросе не помещаются в utf8-колонку
    if (to == null) ps.setNull(4, java.sql.Types.INTEGER); else ps.setInt(4, to);
    ps.setString(5, to == null ? "N" : "Y");
    ps.executeUpdate();
    DB.done(ps);
    send(chat, to == null
      ? "Сейчас не удалось передать вопрос в Telegram. Пожалуйста, задайте его медсестре на посту."
      : to == 0 ? "Вопрос передан на пост медсёстрам вашего отделения." : "Вопрос передан лечащему врачу. Он ответит вам на обходе или подойдёт сам.", menu());
  }

  // ---------- Экраны ----------

  /** День в формате yyyymmdd */
  private static int today() {
    return Integer.parseInt(new SimpleDateFormat("yyyyMMdd").format(new Date()));
  }

  private static String dayDb(int day) {
    String s = String.valueOf(day);
    return s.substring(0, 4) + "-" + s.substring(4, 6) + "-" + s.substring(6);
  }

  private static final String[] SLOTS = {"M", "N", "E"};

  private static String slotName(String slot) {
    return "M".equals(slot) ? "Утро" : "N".equals(slot) ? "Обед" : "Вечер";
  }

  private static String slotCol(String slot) {
    return "M".equals(slot) ? "morning" : "N".equals(slot) ? "noon" : "evening";
  }

  /** Препараты на день по слотам: slot -> строки "• название (до еды)"; tablets -> есть ли таблетки в слоте; done -> медсестра отметила */
  private static class Slot {
    List<String> lines = new ArrayList<>();
    boolean tablets;
    boolean nurseDone = true;
  }

  private static Map<String, Slot> drugs(Connection conn, int pid, int day) throws Exception {
    Map<String, Slot> map = new LinkedHashMap<>();
    for (String s : SLOTS) map.put(s, new Slot());
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      ps = conn.prepareStatement(
        "Select d.id, d.morningTime, d.noonTime, d.eveningTime, d.morningTimeBefore, d.morningTimeAfter, d.noonTimeBefore, d.noonTimeAfter, " +
        "       d.eveningTimeBefore, d.eveningTimeAfter, dt.name drug_type, it.name inj_type, " +
        "       dd.morningTimeDone, dd.noonTimeDone, dd.eveningTimeDone, " +
        "       (Select Group_Concat(Concat(IfNull(n.name, r.name), If(r.source = 'own', ' (свой)', '')) Separator ', ') " +
        "          From patient_drug_rows r Left Join Drug_s_Names n On n.id = r.drug_Id Where r.patientDrug_Id = d.id) names " +
        "  From patient_drugs d " +
        "  Join patient_drug_dates dd On dd.patientDrug_Id = d.id And dd.date = ? And dd.checked = 1 " +
        "  Left Join Dicts dt On dt.id = d.drugType_Id Left Join Dicts it On it.id = d.injectionType_Id " +
        " Where d.patient_Id = ? Order By d.id");
      ps.setString(1, dayDb(day));
      ps.setInt(2, pid);
      rs = ps.executeQuery();
      while (rs.next()) {
        String names = Util.nvl(rs.getString("names")).trim();
        if (names.isEmpty()) continue;
        boolean tablet = rs.getString("inj_type") == null;
        String kind = tablet ? Util.nvl(rs.getString("drug_type"), "Таблетки") : rs.getString("inj_type");
        for (String s : SLOTS) {
          String c = slotCol(s);
          if (!rs.getBoolean(c + "Time")) continue;
          String food = rs.getBoolean(c + "TimeBefore") ? ", до еды" : rs.getBoolean(c + "TimeAfter") ? ", после еды" : "";
          Slot sl = map.get(s);
          sl.lines.add("• " + Tg.esc(names) + " <i>(" + Tg.esc(kind.toLowerCase()) + Tg.esc(food) + ")</i>");
          if (tablet) {
            sl.tablets = true;
            if (!rs.getBoolean(c + "TimeDone")) sl.nurseDone = false;
          }
        }
      }
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
    return map;
  }

  private static List<String> fizio(Connection conn, int pid, int day) throws Exception {
    List<String> list = new ArrayList<>();
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      ps = conn.prepareStatement(
        "Select k.name, k.room, f.oblast, d.done, " +
        "       (Select Count(*) From Lv_Fizio_Dates x Where x.fizio_Id = f.id And x.state = 'Y') total, " +
        "       (Select Count(*) From Lv_Fizio_Dates x Where x.fizio_Id = f.id And x.state = 'Y' And x.done = 'Y') done_cnt " +
        "  From Lv_Fizio_Dates d Join Lv_Fizios f On f.id = d.fizio_Id Left Join Kdos k On k.id = f.Kdo_Id " +
        " Where f.patientId = ? And d.date = ? And d.state = 'Y'");
      ps.setInt(1, pid);
      ps.setString(2, dayDb(day));
      rs = ps.executeQuery();
      while (rs.next()) {
        list.add("• " + Tg.esc(Util.nvl(rs.getString("name")).trim()) + (Util.nvl(rs.getString("oblast")).isEmpty() ? "" : " — " + Tg.esc(rs.getString("oblast"))) +
          (Util.nvl(rs.getString("room")).trim().isEmpty() ? "" : ", <b>комната " + Tg.esc(rs.getString("room").trim()) + "</b>") +
          " <i>(" + ("Y".equals(rs.getString("done")) ? "сделано, " : "") + rs.getInt("done_cnt") + " из " + rs.getInt("total") + ")</i>");
      }
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
    return list;
  }

  /** Обследования, назначенные на день и ещё не сделанные */
  private static List<String> examsOn(Connection conn, int pid, int day) throws Exception {
    List<String> list = new ArrayList<>();
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      ps = conn.prepareStatement(
        "Select k.name From Lv_Plans p Join Kdos k On k.id = p.Kdo_Id " +
        " Where p.patientId = ? And p.Done_Flag != 'Y' And IfNull(p.rejectFlag, 'N') != 'Y' " +
        "   And p.actDate >= ? And p.actDate < Date_Add(?, Interval 1 Day) Order By k.name");
      ps.setInt(1, pid);
      ps.setString(2, dayDb(day));
      ps.setString(3, dayDb(day));
      rs = ps.executeQuery();
      while (rs.next()) list.add("• " + Tg.esc(Util.nvl(rs.getString(1)).trim()));
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
    return list;
  }

  static String myDay(Connection conn, int pid, int day) throws Exception {
    StringBuilder b = new StringBuilder();
    b.append(e(0x1F4C5)).append(" <b>Мой день, ").append(new SimpleDateFormat("dd.MM").format(new SimpleDateFormat("yyyyMMdd").parse(String.valueOf(day)))).append("</b>\n");
    Map<String, Slot> drugs = drugs(conn, pid, day);
    boolean any = false;
    for (Map.Entry<String, Slot> s : drugs.entrySet()) {
      if (s.getValue().lines.isEmpty()) continue;
      any = true;
      b.append("\n<b>").append(slotName(s.getKey())).append("</b>\n");
      for (String l : s.getValue().lines) b.append(l).append("\n");
    }
    if (!any) b.append("\nПрепаратов на сегодня не назначено.\n");
    List<String> f = fizio(conn, pid, day);
    if (!f.isEmpty()) {
      b.append("\n").append(e(0x1F486)).append(" <b>Физиотерапия</b>\n");
      for (String l : f) b.append(l).append("\n");
    }
    List<String> x = examsOn(conn, pid, day);
    if (!x.isEmpty()) {
      b.append("\n").append(e(0x1F52C)).append(" <b>Обследования</b>\n");
      for (String l : x) b.append(l).append("\n");
    }
    String diet = diet(conn, pid);
    if (!diet.isEmpty()) b.append("\n").append(e(0x1F37D)).append(" Питание: ").append(Tg.esc(diet)).append("\n");
    return b.toString().trim();
  }

  private static String diet(Connection conn, int pid) throws Exception {
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      ps = conn.prepareStatement(
        "Select t.name From Patient_Eats e Join Eat_s_Tables t On t.id = e.table_Id Where e.patient_Id = ? Order By e.actDate Desc, e.id Desc Limit 1");
      ps.setInt(1, pid);
      rs = ps.executeQuery();
      return rs.next() ? Util.nvl(rs.getString(1)) : "";
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
  }

  static String progress(Connection conn, int pid) throws Exception {
    StringBuilder b = new StringBuilder();
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      ps = conn.prepareStatement(
        "Select p.Date_Begin, p.day_count, d.name dept, IfNull(p.Palata, r.name) room, u.fio lv, " +
        "       (Select Count(*) From Lv_Plans x Where x.patientId = p.id And IfNull(x.rejectFlag, 'N') != 'Y') plans, " +
        "       (Select Count(*) From Lv_Plans x Where x.patientId = p.id And x.Done_Flag = 'Y') plans_done, " +
        "       (Select Count(*) From Lv_Fizio_Dates x Join Lv_Fizios f On f.id = x.fizio_Id Where f.patientId = p.id And x.state = 'Y') fz, " +
        "       (Select Count(*) From Lv_Fizio_Dates x Join Lv_Fizios f On f.id = x.fizio_Id Where f.patientId = p.id And x.state = 'Y' And x.done = 'Y') fz_done " +
        "  From Patients p Left Join Depts d On d.id = p.Dept_Id Left Join Rooms r On r.id = p.Room_Id Left Join Users u On u.id = p.lv_id Where p.id = ?");
      ps.setInt(1, pid);
      rs = ps.executeQuery();
      if (!rs.next()) return "Нет данных.";
      b.append(e(0x1F4C8)).append(" <b>Ход лечения</b>\n\n");
      Timestamp begin = rs.getTimestamp("Date_Begin");
      if (begin != null) {
        long dayNo = (System.currentTimeMillis() - begin.getTime()) / (24L * 3600 * 1000) + 1;
        b.append("День лечения: <b>").append(dayNo).append("</b>");
        if (rs.getInt("day_count") > 0 && dayNo <= rs.getInt("day_count")) b.append(" из ").append(rs.getInt("day_count"));
        b.append(" (поступили ").append(Util.dateToString(begin)).append(")\n");
      }
      if (rs.getString("dept") != null) b.append("Отделение: ").append(Tg.esc(rs.getString("dept").trim())).append("\n");
      if (rs.getString("room") != null) b.append("Палата: ").append(Tg.esc(rs.getString("room"))).append("\n");
      if (rs.getString("lv") != null) b.append("Лечащий врач: ").append(Tg.esc(rs.getString("lv"))).append("\n");
      if (rs.getInt("plans") > 0) b.append("\n").append(e(0x1F52C)).append(" Обследования: ").append(rs.getInt("plans_done")).append(" из ").append(rs.getInt("plans")).append(" готово\n");
      if (rs.getInt("fz") > 0) b.append(e(0x1F486)).append(" Физиотерапия: ").append(rs.getInt("fz_done")).append(" из ").append(rs.getInt("fz")).append(" процедур\n");
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
    return b.toString().trim();
  }

  static String exams(Connection conn, int pid) throws Exception {
    StringBuilder ready = new StringBuilder(), planned = new StringBuilder();
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      ps = conn.prepareStatement(
        "Select k.name, p.actDate, p.Done_Flag, p.Result_Date From Lv_Plans p Join Kdos k On k.id = p.Kdo_Id " +
        " Where p.patientId = ? And IfNull(p.rejectFlag, 'N') != 'Y' Order By p.actDate, k.name");
      ps.setInt(1, pid);
      rs = ps.executeQuery();
      while (rs.next()) {
        if ("Y".equals(rs.getString("Done_Flag")))
          ready.append(e(0x2705)).append(" ").append(Tg.esc(Util.nvl(rs.getString("name")).trim())).append("\n");
        else
          planned.append(e(0x23F3)).append(" ").append(Tg.esc(Util.nvl(rs.getString("name")).trim()))
            .append(rs.getTimestamp("actDate") != null ? " — " + Util.dateToString(rs.getTimestamp("actDate")) : "").append("\n");
      }
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
    if (ready.length() == 0 && planned.length() == 0) return "Обследования пока не назначены.";
    return e(0x1F52C) + " <b>Обследования</b>\n" +
      (planned.length() > 0 ? "\n<b>Предстоит</b>\n" + planned : "") +
      (ready.length() > 0 ? "\n<b>Готово</b>\n" + ready + "\nРезультаты обсудите с лечащим врачом." : "");
  }

  // ---------- Напоминания (каждые 30 с из TgJob) ----------

  static void reminders(Connection conn) throws Exception {
    initTables(conn);
    Calendar now = Calendar.getInstance();
    int min = now.get(Calendar.HOUR_OF_DAY) * 60 + now.get(Calendar.MINUTE);
    int day = today();
    try {
      dischargeDocs(conn);
    } catch (Exception e) {
      System.err.println("TG_PATIENT_VYPISKA_ERR: " + e.getMessage());
    }
    try {
      if (inWindow(min, time("patient.time.birthday", "10:00"))) birthdays(conn, now);
    } catch (Exception e) {
      System.err.println("TG_PATIENT_BDAY_ERR: " + e.getMessage());
    }
    List<long[]> patients = new ArrayList<>(); // [patient_id, chat_id, linked millis]
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      ps = conn.prepareStatement(
        "Select l.patient_id, l.chat_id, l.linked_date From Tg_Patient_Links l Join Patients p On p.id = l.patient_id " +
        " Where l.chat_id Is Not Null And p.state = 'LV'");
      rs = ps.executeQuery();
      while (rs.next()) patients.add(new long[]{rs.getInt(1), rs.getLong(2), rs.getTimestamp(3) == null ? 0 : rs.getTimestamp(3).getTime()});
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
    if (patients.isEmpty()) return;

    int digest = time("patient.time.digest", "07:30");
    int[] slotTimes = {time("patient.time.morning", "08:00"), time("patient.time.noon", "13:00"), time("patient.time.evening", "19:00")};
    int tomorrow = time("patient.time.tomorrow", "20:00");
    for (long[] p : patients) {
      int pid = (int) p[0];
      long chat = p[1];
      try {
        // утренняя сводка дня
        if (inWindow(min, digest) && once(conn, "DIGEST", pid, day))
          send(chat, "Доброе утро!\n\n" + myDay(conn, pid, day), menu());
        // таблетки: утро / обед / вечер, если медсестра ещё не отметила
        for (int i = 0; i < SLOTS.length; i++) {
          if (!inWindow(min, slotTimes[i]) || sent(conn, "DRUG_" + SLOTS[i], pid, day)) continue;
          Slot sl = drugs(conn, pid, day).get(SLOTS[i]);
          if (sl.lines.isEmpty() || !sl.tablets || sl.nurseDone) continue;
          if (!once(conn, "DRUG_" + SLOTS[i], pid, day)) continue;
          StringBuilder b = new StringBuilder(e(0x1F48A) + " <b>" + slotName(SLOTS[i]) + ": время принять препараты</b>\n");
          for (String l : sl.lines) b.append(l).append("\n");
          send(chat, b.toString().trim(), menu());
        }
        // вечером: обследования на завтра
        if (inWindow(min, tomorrow) && !sent(conn, "TOMORROW", pid, day)) {
          Calendar c = Calendar.getInstance();
          c.add(Calendar.DATE, 1);
          int next = Integer.parseInt(new SimpleDateFormat("yyyyMMdd").format(c.getTime()));
          List<String> x = examsOn(conn, pid, next);
          if (!x.isEmpty() && once(conn, "TOMORROW", pid, day)) {
            StringBuilder b = new StringBuilder(e(0x1F52C) + " <b>Завтра обследования</b>\n");
            for (String l : x) b.append(l).append("\n");
            b.append("\nЕсли среди них анализ крови, уточните у медсестры, нужно ли сдавать натощак.");
            send(chat, b.toString(), menu());
          }
        }
        results(conn, pid, chat, p[2]);
      } catch (Exception e) {
        System.err.println("TG_PATIENT_REMIND_ERR patient=" + pid + ": " + e.getMessage());
      }
    }
  }

  // ---------- Выписка после закрытия кассы ----------

  /** Последняя завершённая госпитализация, к которой привязан чат */
  private static Integer dischargedOf(Connection conn, long chat) throws Exception {
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      ps = conn.prepareStatement(
        "Select l.patient_id From Tg_Patient_Links l Join Patients p On p.id = l.patient_id " +
        " Where l.chat_id = ? And p.state != 'LV' Order By p.Date_Begin Desc, l.patient_id Desc");
      ps.setLong(1, chat);
      rs = ps.executeQuery();
      return rs.next() ? rs.getInt(1) : null;
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
  }

  /** Выписку отдаём, только когда касса закрыта и врач заполнил выписку */
  private static boolean hasVypiska(Connection conn, int pid) throws Exception {
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      ps = conn.prepareStatement(
        "Select 1 From Patients p Join Lv_Docs d On d.patient_Id = p.id And d.docCode = 'vypiska' Where p.id = ? And p.paid = 'CLOSED'");
      ps.setInt(1, pid);
      rs = ps.executeQuery();
      return rs.next();
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
  }

  private static JSONObject dischargeMenu(Connection conn, int pid) throws Exception {
    if (!hasVypiska(conn, pid)) return removeKeyboard();
    JSONObject kb = new JSONObject();
    kb.put("keyboard", new JSONArray().put(new JSONArray().put(e(0x1F4C4) + " Выписка")));
    kb.put("resize_keyboard", true);
    return kb;
  }

  /** Как только касса закрыта: один раз отправляем выписку пациенту, который подключён к боту */
  private static void dischargeDocs(Connection conn) throws Exception {
    List<long[]> list = new ArrayList<>();
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      ps = conn.prepareStatement(
        "Select l.patient_id, l.chat_id From Tg_Patient_Links l Join Patients p On p.id = l.patient_id " +
        "  Join Lv_Docs d On d.patient_Id = p.id And d.docCode = 'vypiska' " +
        " Where l.chat_id Is Not Null And p.paid = 'CLOSED' " +
        "   And Not Exists (Select 1 From Tg_Patient_Sent s Where s.kind = 'VYPISKA' And s.ref_id = l.patient_id And s.day = 0)");
      rs = ps.executeQuery();
      while (rs.next()) list.add(new long[]{rs.getInt(1), rs.getLong(2)});
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
    for (long[] x : list) {
      if (!once(conn, "VYPISKA", (int) x[0], 0)) continue;
      send(x[1], e(0x1F33F) + " <b>Ваша выписка готова</b>\n\nСпасибо, что доверили своё здоровье нашей клинике! " +
        "Отправляю выписку. Сохраните её: она понадобится на приёме у врача по месту жительства. " +
        "Получить её снова можно кнопкой «Выписка».", menu());
      sendVypiska(conn, x[1], (int) x[0]);
    }
  }

  private static boolean sendVypiska(Connection conn, long chat, int pid) throws Exception {
    if (!hasVypiska(conn, pid)) return false;
    String html = vypiskaHtml(conn, pid);
    if (html == null) return false;
    String name = "vypiska_" + pid + ".html";
    return Tg.sendDocument(token(), chat, name, html.getBytes("UTF-8"), "Выписка из истории болезни. Откройте файл в браузере, его можно распечатать.");
  }

  /** Выписка отдельным HTML-файлом: те же разделы и оформление, что в печатной форме (med/lv/print/vypiska.jsp) */
  public static String vypiskaHtml(Connection conn, int pid) throws Exception {
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      ps = conn.prepareStatement(
        "Select p.surname, p.name, p.middlename, p.birthyear, p.yearNum, p.Date_Begin, p.Date_End, dp.name dept, lv.fio lv_fio, zv.fio zav_fio, " +
        "       d.c1, d.c2, d.c3, d.c4, d.c5, d.c6, d.c7, d.c8, d.c9, d.c10, d.c11, d.c12, " +
        "       (Select v.val From Params v Where v.code = 'GLB_NEXT') glb " +
        "  From Patients p Join Lv_Docs d On d.patient_Id = p.id And d.docCode = 'vypiska' " +
        "  Left Join Depts dp On dp.id = p.Dept_Id Left Join Users lv On lv.id = p.lv_id Left Join Users zv On zv.id = p.zavlv_Id " +
        " Where p.id = ? Order By d.id Desc");
      ps.setInt(1, pid);
      rs = ps.executeQuery();
      if (!rs.next()) return null;
      StringBuilder b = new StringBuilder();
      b.append("<!DOCTYPE html><html><head><meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">")
        .append("<title>Выписка ").append(Tg.esc(Util.nvl(rs.getString("surname")))).append("</title><style>")
        .append("body{margin:0;background:#fff}")
        .append(".osmp{max-width:790px;margin:0 auto;padding:24px 16px;font-family:Arial,'Segoe UI',sans-serif;font-size:15px;color:#000;line-height:1.4}")
        .append(".osmp table{border-collapse:collapse;width:100%}.osmp td{vertical-align:top;font-size:inherit}")
        .append(".org{text-align:center;font-weight:bold;padding:0 0 2px}.doc-title{text-align:center;font-size:20px;font-weight:bold;padding:0 0 12px}")
        .append(".info td{border:1px solid #888;padding:4px 8px}.info .l{width:22%;background:#f3f3f3;color:#333;font-size:13px}.info .v{font-weight:bold}")
        .append(".sec-h{font-weight:bold;padding:10px 0 2px;border-bottom:1px solid #888;text-transform:uppercase;font-size:13px}")
        .append(".grp-h{font-weight:bold;padding:12px 0 2px;border-bottom:2px solid #000;text-transform:uppercase}.dx-h{font-weight:bold;padding:5px 0 0}")
        .append(".sec-b{padding:3px 0 1px;text-align:justify}.sign{margin-top:22px}.sign td{padding:8px 0 3px}")
        .append(".osmp td[data-row]{border:1px solid #888;padding:3px 6px;vertical-align:top}.osmp table{max-width:100%}@media print{.osmp{max-width:none;padding:0}}</style></head><body><div class=\"osmp\">");
      b.append("<div class=\"org\">«").append(Tg.esc(clinicName(conn))).append("»</div>");
      b.append("<div class=\"doc-title\">Касаллик тарихидан кучирма № ").append(rs.getInt("yearNum") != 0 ? rs.getInt("yearNum") + "" : "").append("</div>");
      b.append("<table class=\"info\"><tr><td class=\"l\">Бемор</td><td class=\"v\" colspan=\"3\">")
        .append(Tg.esc((Util.nvl(rs.getString("surname")) + " " + Util.nvl(rs.getString("name")) + " " + Util.nvl(rs.getString("middlename"))).trim())).append("</td></tr>")
        .append("<tr><td class=\"l\">Тугилган йили</td><td class=\"v\">").append(rs.getInt("birthyear") != 0 ? rs.getInt("birthyear") + "" : "").append("</td>")
        .append("<td class=\"l\">Бўлим</td><td class=\"v\">").append(Tg.esc(Util.nvl(rs.getString("dept")))).append("</td></tr>")
        .append("<tr><td class=\"l\">Касалхонага келди</td><td class=\"v\">").append(Util.dateToString(rs.getTimestamp("Date_Begin"))).append("</td>")
        .append("<td class=\"l\">Касалхонадан кетди</td><td class=\"v\">").append(Util.dateToString(rs.getTimestamp("Date_End"))).append("</td></tr></table>");
      // тексты разделов - HTML из редактора выписки, выводим как в печатной форме
      String[] dxTitles = {"Асосий", "Хамрох", "Асорати"};
      group(b, "Клиник ташхис", dxTitles, rs.getString("c1"), rs.getString("c8"), rs.getString("c9"));
      String[] mainTitles = {"Шикоятлар", "Анамнез", "Объектив", "Утказилган текширувлар", "Утказилган даволашлар"};
      String[] main = {rs.getString("c2"), rs.getString("c3"), rs.getString("c4"), rs.getString("c5"), rs.getString("c6")};
      for (int i = 0; i < main.length; i++)
        if (filled(main[i])) b.append("<div class=\"sec-h\">").append(mainTitles[i]).append("</div><div class=\"sec-b\">").append(clean(main[i])).append("</div>");
      group(b, "Чи" + e(0x049B) + "арув ва" + e(0x049B) + "тидаги ташхис", dxTitles, rs.getString("c10"), rs.getString("c11"), rs.getString("c12"));
      if (filled(rs.getString("c7"))) b.append("<div class=\"sec-h\">Тавсия</div><div class=\"sec-b\">").append(clean(rs.getString("c7"))).append("</div>");
      b.append("<table class=\"sign\">")
        .append(sign("Даволовчи шифокор", rs.getString("lv_fio")))
        .append(sign("Булим мудири", rs.getString("zav_fio")))
        .append(sign("Бош шифокор", rs.getString("glb")))
        .append("</table></div></body></html>");
      return b.toString();
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
  }

  private static void group(StringBuilder b, String title, String[] titles, String... vals) {
    boolean any = false;
    for (String v : vals) any |= filled(v);
    if (!any) return;
    b.append("<div class=\"grp-h\">").append(title).append("</div>");
    for (int i = 0; i < vals.length; i++)
      if (filled(vals[i])) b.append("<div class=\"dx-h\">").append(titles[i]).append(":</div><div class=\"sec-b\">").append(clean(vals[i])).append("</div>");
  }

  private static String sign(String title, String fio) {
    return "<tr><td style=\"width:30%\"><b>" + title + "</b></td><td style=\"text-align:right\">" + Tg.esc(Util.nvl(fio)) + "</td></tr>";
  }

  private static boolean filled(String v) {
    return v != null && !v.trim().isEmpty() && !v.trim().equals("<br>");
  }

  /** Текст из редактора: убираем скрипты на всякий случай, &nbsp; как в печатной форме */
  private static String clean(String v) {
    return v.replaceAll("(?is)<script.*?</script>", "").replaceAll("(?i)\\son\\w+\\s*=", " data-x=").replace("&nbsp;", " ");
  }

  private static String clinicName(Connection conn) throws Exception {
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      ps = conn.prepareStatement("Select val From Params Where code = 'CLINIC_NAME'");
      rs = ps.executeQuery();
      return rs.next() ? Util.nvl(rs.getString(1)) : "";
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
  }

  // ---------- Поздравление с днём рождения ----------

  /** Один раз в год каждому подключённому пациенту (по последней госпитализации чата), в patient.time.birthday */
  private static void birthdays(Connection conn, Calendar now) throws Exception {
    int year = now.get(Calendar.YEAR);
    List<Object[]> list = new ArrayList<>();
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      ps = conn.prepareStatement(
        "Select l.chat_id, p.id, p.name, p.middlename, p.Sex_Id From Tg_Patient_Links l Join Patients p On p.id = l.patient_id " +
        " Where l.chat_id Is Not Null And p.birthday Is Not Null " +
        "   And Month(p.birthday) = ? And DayOfMonth(p.birthday) = ? " +
        "   And l.patient_id = (Select Max(z.patient_id) From Tg_Patient_Links z Where z.chat_id = l.chat_id)");
      ps.setInt(1, now.get(Calendar.MONTH) + 1);
      ps.setInt(2, now.get(Calendar.DAY_OF_MONTH));
      rs = ps.executeQuery();
      while (rs.next())
        list.add(new Object[]{rs.getLong(1), rs.getInt(2), (Util.nvl(rs.getString(3)) + " " + Util.nvl(rs.getString(4))).trim(), rs.getInt(5)});
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
    if (list.isEmpty()) return;
    String clinic = clinicName(conn);
    for (Object[] x : list) {
      if (!once(conn, "BDAY", (Integer) x[1], year)) continue;
      send((Long) x[0], birthdayText((String) x[2], (Integer) x[3], clinic), null);
    }
  }

  /** Текст поздравления. sexId: 12 - Эркак, 13 - Аёл (Sel_Opts) */
  static String birthdayText(String name, int sexId, String clinic) {
    String dear = sexId == 13 ? "Дорогая" : sexId == 12 ? "Дорогой" : "Дорогой друг,";
    String who = name.isEmpty() ? "" : " " + Tg.esc(name);
    return e(0x1F382) + " <b>" + dear + who + "!</b>\n\n" +
      "От всей души поздравляем вас с днём рождения!\n\n" +
      "Пусть этот день будет наполнен теплом, улыбками и вниманием близких, а каждый новый год жизни приносит " +
      "крепкое здоровье, бодрость и душевный покой. Желаем вам сил на всё задуманное, долгих счастливых лет " +
      "рядом с любимыми людьми и поводов радоваться каждый день.\n\n" +
      "Мы искренне благодарны вам за доверие. Берегите себя, а мы всегда рядом, когда понадобится забота и помощь.\n\n" +
      "С уважением и наилучшими пожеланиями,\n" +
      "<i>руководство клиники «" + Tg.esc(clinic) + "»</i> " + e(0x1F490);
  }

  /** Время наступило и прошло не больше 2 часов (если сервер был выключен - не шлём устаревшее) */
  private static boolean inWindow(int nowMin, int at) {
    return nowMin >= at && nowMin < at + 120;
  }

  private static boolean sent(Connection conn, String kind, int refId, int day) throws Exception {
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      ps = conn.prepareStatement("Select 1 From Tg_Patient_Sent Where kind = ? And ref_id = ? And day = ?");
      ps.setString(1, kind);
      ps.setInt(2, refId);
      ps.setInt(3, day);
      rs = ps.executeQuery();
      return rs.next();
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
  }

  /** Отмечает отправку; false - уже отправляли */
  private static boolean once(Connection conn, String kind, int refId, int day) throws Exception {
    PreparedStatement ps = null;
    try {
      ps = conn.prepareStatement("Insert Ignore Into Tg_Patient_Sent (kind, ref_id, day, sent_date) Values (?, ?, ?, Now())");
      ps.setString(1, kind);
      ps.setInt(2, refId);
      ps.setInt(3, day);
      return ps.executeUpdate() > 0;
    } finally {
      DB.done(ps);
    }
  }

  /** "Результат готов" по обследованиям, готовым после подключения пациента. Значения не показываем. */
  private static void results(Connection conn, int pid, long chat, long linkedMillis) throws Exception {
    if (linkedMillis == 0) return;
    List<Object[]> ready = new ArrayList<>();
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      ps = conn.prepareStatement(
        "Select p.id, k.name From Lv_Plans p Join Kdos k On k.id = p.Kdo_Id " +
        " Where p.patientId = ? And p.Done_Flag = 'Y' And p.Result_Date >= ? " +
        "   And Not Exists (Select 1 From Tg_Patient_Sent s Where s.kind = 'RESULT' And s.ref_id = p.id And s.day = 0)");
      ps.setInt(1, pid);
      ps.setTimestamp(2, new Timestamp(linkedMillis));
      rs = ps.executeQuery();
      while (rs.next()) ready.add(new Object[]{rs.getInt(1), rs.getString(2)});
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
    if (ready.isEmpty()) return;
    StringBuilder b = new StringBuilder(e(0x1F4CB) + " <b>Готов результат</b>\n");
    for (Object[] r : ready) {
      if (once(conn, "RESULT", (Integer) r[0], 0)) b.append("• ").append(Tg.esc(Util.nvl((String) r[1]).trim())).append("\n");
    }
    b.append("\nРезультат обсудите с лечащим врачом.");
    send(chat, b.toString(), menu());
  }

  // ---------- Отправка ----------

  private static Integer patientOf(Connection conn, long chat) throws Exception {
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      ps = conn.prepareStatement(
        "Select l.patient_id From Tg_Patient_Links l Join Patients p On p.id = l.patient_id Where l.chat_id = ? And p.state = 'LV' Order By l.linked_date Desc");
      ps.setLong(1, chat);
      rs = ps.executeQuery();
      return rs.next() ? rs.getInt(1) : null;
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
  }

  private static JSONObject menu() throws Exception {
    JSONObject kb = new JSONObject();
    kb.put("keyboard", new JSONArray()
      .put(new JSONArray().put(e(0x1F4C5) + " Мой день").put(e(0x1F4C8) + " Ход лечения"))
      .put(new JSONArray().put(e(0x1F52C) + " Обследования").put(e(0x2709) + " Вопрос врачу"))
      .put(new JSONArray().put(e(0x1F4C4) + " Выписка")));
    kb.put("resize_keyboard", true);
    return kb;
  }

  static JSONObject removeKeyboard() throws Exception {
    JSONObject kb = new JSONObject();
    kb.put("remove_keyboard", true);
    return kb;
  }

  private static void sendMenu(long chat, String html) throws Exception {
    send(chat, html, menu());
  }

  public static boolean send(long chat, String html, JSONObject markup) {
    try {
      JSONObject body = new JSONObject();
      body.put("chat_id", chat);
      body.put("text", html);
      body.put("parse_mode", "HTML");
      body.put("disable_web_page_preview", true);
      if (markup != null) body.put("reply_markup", markup);
      return Tg.call(token(), "sendMessage", body).optBoolean("ok");
    } catch (Exception e) {
      System.err.println("TG_PATIENT_SEND_ERR chat=" + chat + ": " + e.getMessage());
      return false;
    }
  }

  private static void exec(Connection conn, String sql) throws Exception {
    PreparedStatement ps = null;
    try {
      ps = conn.prepareStatement(sql);
      ps.executeUpdate();
    } finally {
      DB.done(ps);
    }
  }
}
