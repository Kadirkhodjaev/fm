package ckb.mobile;

import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONObject;

import java.sql.Connection;
import java.util.*;

/**
 * Лечение дома после выписки: таблица "Препараты на дом" в выписке (med/lv/vypiska.jsp) и повторный приём.
 *
 * Строки привязаны к госпитализации (Patients.id). Курс каждого препарата начинается на следующий день после
 * выписки (Patients.Date_End) и длится days дней. Текст "Рекомендовано" (Lv_Docs.c7) страница выписки собирает
 * из таблицы сама: блок начинается строкой "Препараты на дом:", остальной текст врача не трогается.
 */
public class HomePlan {

  /** Заголовки блоков, которые страница выписки вставляет в c7 (по ним блок убирается при показе в приложении) */
  public static final String DRUGS_TITLE = "Препараты на дом:";
  public static final String FOLLOWUP_TITLE = "Повторный приём:";

  public static final String[] SLOTS = {"M", "N", "E"};

  public static String slotName(String slot) {
    return "M".equals(slot) ? "Утро" : "N".equals(slot) ? "Обед" : "Вечер";
  }

  public static String foodText(String food) {
    return "B".equals(food) ? "до еды" : "W".equals(food) ? "во время еды" : "A".equals(food) ? "после еды" : "";
  }

  static void initTables(Connection conn) throws Exception {
    MobDb.exec(conn,
      "Create Table If Not Exists Lv_Home_Drugs (" +
      "  id Int Not Null Auto_Increment Primary Key," +
      "  patient_id Int Not Null," +
      "  ord Int Not Null," +
      "  drug Varchar(255) Not Null," +
      "  dose Varchar(128) Null," +
      "  morning Char(1) Not Null Default 'N'," +
      "  noon Char(1) Not Null Default 'N'," +
      "  evening Char(1) Not Null Default 'N'," +
      "  food Char(1) Null," +
      "  days Int Null," +
      "  cr_by Int Null," +
      "  cr_on DateTime Not Null," +
      "  Key lv_home_drugs_p (patient_id)" +
      ") Default Charset = utf8");
    MobDb.exec(conn,
      "Create Table If Not Exists Lv_Home_Plans (" +
      "  patient_id Int Not Null Primary Key," +
      "  followup_days Int Null," +
      "  followup_doctor Varchar(255) Null," +
      "  upd_by Int Null," +
      "  upd_on DateTime Not Null" +
      ") Default Charset = utf8");
  }

  // ---------- Страница выписки ----------

  /** Таблица для страницы выписки: {drugs:[{drug, dose, m, n, e, food, days}], followupDays, followupDoctor} */
  public static JSONObject load(Connection conn, int patientId) throws Exception {
    MobTables.init(conn);
    JSONObject res = new JSONObject();
    JSONArray arr = new JSONArray();
    for (Map<String, Object> r : MobDb.rows(conn, "Select * From Lv_Home_Drugs Where patient_id = ? Order By ord, id", patientId)) {
      JSONObject o = new JSONObject();
      o.put("drug", MobDb.s(r, "drug"));
      o.put("dose", MobDb.s(r, "dose"));
      o.put("m", MobDb.b(r, "morning"));
      o.put("n", MobDb.b(r, "noon"));
      o.put("e", MobDb.b(r, "evening"));
      o.put("food", MobDb.s(r, "food"));
      o.put("days", r.get("days") == null ? "" : String.valueOf(MobDb.i(r, "days")));
      arr.put(o);
    }
    res.put("drugs", arr);
    Map<String, Object> p = MobDb.row(conn, "Select * From Lv_Home_Plans Where patient_id = ?", patientId);
    res.put("followupDays", p == null || p.get("followup_days") == null ? "" : String.valueOf(MobDb.i(p, "followup_days")));
    res.put("followupDoctor", p == null ? "" : MobDb.s(p, "followup_doctor"));
    return res;
  }

  /** Сохранение таблицы со страницы выписки. null - сохранено, иначе текст ошибки */
  public static String save(Connection conn, int patientId, int userId, JSONObject data) throws Exception {
    MobTables.init(conn);
    JSONArray arr = data.optJSONArray("drugs");
    List<Object[]> rows = new ArrayList<>();
    if (arr != null) {
      for (int k = 0; k < arr.length(); k++) {
        JSONObject o = arr.getJSONObject(k);
        String drug = o.optString("drug", "").trim();
        if (drug.isEmpty()) continue;
        if (drug.length() > 255) drug = drug.substring(0, 255);
        String dose = o.optString("dose", "").trim();
        if (dose.length() > 128) dose = dose.substring(0, 128);
        boolean m = o.optBoolean("m"), n = o.optBoolean("n"), e = o.optBoolean("e");
        if (!m && !n && !e) return "«" + drug + "»: отметьте утро, обед или вечер.";
        String food = o.optString("food", "");
        if (!food.matches("[BWA]")) food = "";
        int days;
        try {
          days = Integer.parseInt(o.optString("days", "").trim());
        } catch (Exception ex) {
          return "«" + drug + "»: укажите, сколько дней принимать.";
        }
        if (days < 1 || days > 365) return "«" + drug + "»: срок от 1 до 365 дней.";
        rows.add(new Object[]{drug, dose, m ? "Y" : "N", n ? "Y" : "N", e ? "Y" : "N", food, days});
      }
    }
    Integer fDays = null;
    String fDays0 = data.optString("followupDays", "").trim();
    if (!fDays0.isEmpty()) {
      try {
        fDays = Integer.parseInt(fDays0);
      } catch (Exception ex) {
        return "Повторный приём: укажите число дней.";
      }
      if (fDays < 1 || fDays > 365) return "Повторный приём: от 1 до 365 дней.";
    }
    String fDoctor = data.optString("followupDoctor", "").trim();
    if (fDoctor.length() > 255) fDoctor = fDoctor.substring(0, 255);

    boolean auto = conn.getAutoCommit();
    conn.setAutoCommit(false);
    try {
      MobDb.exec(conn, "Delete From Lv_Home_Drugs Where patient_id = ?", patientId);
      int ord = 0;
      for (Object[] r : rows)
        MobDb.exec(conn, "Insert Into Lv_Home_Drugs (patient_id, ord, drug, dose, morning, noon, evening, food, days, cr_by, cr_on) Values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, Now())",
          patientId, ++ord, r[0], r[1], r[2], r[3], r[4], r[5], r[6], userId);
      if (fDays == null && fDoctor.isEmpty())
        MobDb.exec(conn, "Delete From Lv_Home_Plans Where patient_id = ?", patientId);
      else
        MobDb.exec(conn, "Insert Into Lv_Home_Plans (patient_id, followup_days, followup_doctor, upd_by, upd_on) Values (?, ?, ?, ?, Now()) " +
          "On Duplicate Key Update followup_days = Values(followup_days), followup_doctor = Values(followup_doctor), upd_by = Values(upd_by), upd_on = Now()",
          patientId, fDays, fDoctor, userId);
      conn.commit();
    } catch (Exception ex) {
      conn.rollback();
      throw ex;
    } finally {
      conn.setAutoCommit(auto);
    }
    return null;
  }

  /** Кнопка "Перенести из листа назначений": таблетки (не инъекции), которые назначены на конец лечения */
  public static JSONArray fromPrescriptions(Connection conn, int patientId) throws Exception {
    List<Map<String, Object>> list = MobDb.rows(conn,
      "Select d.id, d.morningTime, d.noonTime, d.eveningTime, d.morningTimeBefore, d.morningTimeAfter, d.noonTimeBefore, d.noonTimeAfter, " +
      "       d.eveningTimeBefore, d.eveningTimeAfter, d.dateEnd, IfNull(n.name, r.name) nm, r.expanse, m.name measure " +
      "  From Patient_Drugs d Join Patient_Drug_Rows r On r.patientDrug_Id = d.id " +
      "  Left Join Drug_s_Names n On n.id = r.drug_Id Left Join Drug_s_Measures m On m.id = r.measure_Id " +
      " Where d.patient_Id = ? And d.injectionType_Id Is Null " +
      " Order By d.dateEnd Desc, d.id, r.id", patientId);
    // назначения, которые идут до конца лечения: дата окончания не раньше последней минус 1 день
    Date last = null;
    for (Map<String, Object> r : list) {
      Date e = MobDb.d(r, "dateEnd");
      if (e != null && (last == null || e.after(last))) last = e;
    }
    JSONArray arr = new JSONArray();
    Set<String> seen = new HashSet<>();
    for (Map<String, Object> r : list) {
      Date e = MobDb.d(r, "dateEnd");
      if (last != null && e != null && e.before(MobDb.addDays(MobDb.day(last), -1))) continue;
      String name = MobDb.s(r, "nm");
      if (name.isEmpty() || !seen.add(name.toLowerCase())) continue;
      JSONObject o = new JSONObject();
      o.put("drug", name);
      String dose = "";
      Object exp = r.get("expanse");
      if (exp instanceof Number && ((Number) exp).doubleValue() > 0) {
        double x = ((Number) exp).doubleValue();
        dose = (x == Math.floor(x) ? String.valueOf((long) x) : String.valueOf(x).replace('.', ',')) + (MobDb.s(r, "measure").isEmpty() ? "" : " " + MobDb.s(r, "measure"));
      }
      o.put("dose", dose);
      o.put("m", MobDb.b(r, "morningTime"));
      o.put("n", MobDb.b(r, "noonTime"));
      o.put("e", MobDb.b(r, "eveningTime"));
      String food = "";
      for (String c : new String[]{"morning", "noon", "evening"}) {
        if (!MobDb.b(r, c + "Time")) continue;
        food = MobDb.b(r, c + "TimeBefore") ? "B" : MobDb.b(r, c + "TimeAfter") ? "A" : "";
        break;
      }
      o.put("food", food);
      o.put("days", "");
      arr.put(o);
    }
    return arr;
  }

  // ---------- Приложение и напоминания ----------

  /** Строка препарата на дом с датами курса */
  public static class Drug {
    public String name, dose, food;
    public boolean[] slots = new boolean[3];
    public int days;
    public Date from, until;

    public boolean in(String slot) {
      return slots["M".equals(slot) ? 0 : "N".equals(slot) ? 1 : 2];
    }

    public boolean activeOn(Date day) {
      Date d = MobDb.day(day);
      return !d.before(from) && !d.after(until);
    }
  }

  /** Препараты на дом госпитализации; пустой список, если таблица не заполнена или нет даты выписки */
  public static List<Drug> drugs(Connection conn, int patientId) throws Exception {
    List<Drug> res = new ArrayList<>();
    Date out = (Date) MobDb.value(conn, "Select Date_End From Patients Where id = ?", patientId);
    if (out == null) return res;
    Date start = MobDb.addDays(MobDb.day(out), 1);
    for (Map<String, Object> r : MobDb.rows(conn, "Select * From Lv_Home_Drugs Where patient_id = ? Order By ord, id", patientId)) {
      Drug d = new Drug();
      d.name = MobDb.s(r, "drug");
      d.dose = MobDb.s(r, "dose");
      d.food = MobDb.s(r, "food");
      d.slots[0] = MobDb.b(r, "morning");
      d.slots[1] = MobDb.b(r, "noon");
      d.slots[2] = MobDb.b(r, "evening");
      d.days = Math.max(1, MobDb.i(r, "days"));
      d.from = start;
      d.until = MobDb.addDays(start, d.days - 1);
      res.add(d);
    }
    return res;
  }

  /** Дата повторного приёма или null */
  public static Object[] followup(Connection conn, int patientId) throws Exception {
    Map<String, Object> p = MobDb.row(conn,
      "Select h.followup_days, h.followup_doctor, p.Date_End From Lv_Home_Plans h Join Patients p On p.id = h.patient_id Where h.patient_id = ?", patientId);
    if (p == null || p.get("followup_days") == null || MobDb.d(p, "Date_End") == null) return null;
    return new Object[]{MobDb.addDays(MobDb.day(MobDb.d(p, "Date_End")), MobDb.i(p, "followup_days")), MobDb.s(p, "followup_doctor")};
  }

  /** Последняя выписка клиента, для которой сейчас идёт лечение дома (курс или повторный приём впереди), или null */
  public static Integer activeStay(Connection conn, int clientId) throws Exception {
    Date today = MobDb.day(new Date());
    List<Map<String, Object>> stays = MobDb.rows(conn,
      "Select p.id, p.Date_End, " +
      "       (Select Max(h.days) From Lv_Home_Drugs h Where h.patient_id = p.id) max_days, " +
      "       (Select h.followup_days From Lv_Home_Plans h Where h.patient_id = p.id) f_days, " +
      "       (Select Count(*) From Lv_Docs d Where d.patient_Id = p.id And d.docCode = 'vypiska' And d.c7 Is Not Null And d.c7 != '') rec " +
      "  From Patients p Where p.client_Id = ? And p.state != 'LV' And p.Date_End Is Not Null And p.Date_End >= ? " +
      " Order By p.Date_End Desc, p.id Desc Limit 3", clientId, MobDb.addDays(today, -400));
    for (Map<String, Object> s : stays) {
      Date out = MobDb.day(MobDb.d(s, "Date_End"));
      int maxDays = MobDb.i(s, "max_days"), fDays = MobDb.i(s, "f_days");
      if (maxDays > 0 && !today.after(MobDb.addDays(out, maxDays))) return MobDb.i(s, "id");
      if (s.get("f_days") != null && !today.after(MobDb.addDays(out, fDays))) return MobDb.i(s, "id");
      // таблица не заполнена: 30 дней показываем текст рекомендаций
      if (maxDays == 0 && MobDb.i(s, "rec") > 0 && !today.after(MobDb.addDays(out, 30))) return MobDb.i(s, "id");
    }
    return null;
  }

  /** Время приёма для номера: из настроек приложения или по умолчанию (home.time.*) */
  public static String[] slotTimes(Connection conn, String phone9) throws Exception {
    String[] t = {MobConfig.get("home.time.morning", "08:00"), MobConfig.get("home.time.noon", "13:00"), MobConfig.get("home.time.evening", "20:00")};
    if (phone9 == null) return t;
    Map<String, Object> s = MobDb.row(conn, "Select t_morning, t_noon, t_evening From Mob_Settings Where phone9 = ?", phone9);
    if (s != null) {
      String[] cols = {"t_morning", "t_noon", "t_evening"};
      for (int k = 0; k < 3; k++) if (MobConfig.normTime(MobDb.s(s, cols[k])) != null) t[k] = MobConfig.normTime(MobDb.s(s, cols[k]));
    }
    return t;
  }

  /** Лечение дома для приложения (GET /clients/{id}/home-plan) */
  public static JSONObject forApp(Connection conn, int clientId, String phone9) throws Exception {
    Integer pid = activeStay(conn, clientId);
    if (pid == null) return null;
    Map<String, Object> p = MobDb.row(conn,
      "Select p.id, p.Date_End, dp.name dept, u.fio doctor, " +
      "       (Select d.c7 From Lv_Docs d Where d.patient_Id = p.id And d.docCode = 'vypiska' Order By d.id Desc Limit 1) c7 " +
      "  From Patients p Left Join Depts dp On dp.id = p.Dept_Id Left Join Users u On u.id = p.lv_id Where p.id = ?", pid);
    Date today = MobDb.day(new Date());
    Date out = MobDb.day(MobDb.d(p, "Date_End"));
    List<Drug> drugs = drugs(conn, pid);
    String[] times = slotTimes(conn, phone9);
    JSONObject res = new JSONObject();
    res.put("stayId", pid);
    res.put("dept", MobDb.s(p, "dept"));
    res.put("discharged", MobDb.iso(out));
    res.put("doctor", MobDb.s(p, "doctor"));
    int maxDays = 0;
    for (Drug d : drugs) maxDays = Math.max(maxDays, d.days);
    res.put("days", maxDays);
    res.put("day", maxDays == 0 ? 0 : Math.max(0, Math.min(maxDays, MobDb.daysBetween(out, today))));
    JSONArray list = new JSONArray();
    for (Drug d : drugs) {
      JSONObject o = new JSONObject();
      o.put("name", d.name);
      o.put("dose", d.dose);
      o.put("morning", d.slots[0]);
      o.put("noon", d.slots[1]);
      o.put("evening", d.slots[2]);
      o.put("food", d.food);
      o.put("foodText", foodText(d.food));
      o.put("days", d.days);
      o.put("from", MobDb.iso(d.from));
      o.put("until", MobDb.iso(d.until));
      o.put("left", Math.max(0, MobDb.daysBetween(today, d.until) + 1));
      o.put("active", d.activeOn(today));
      list.put(o);
    }
    res.put("drugs", list);
    JSONArray schedule = new JSONArray();
    for (int k = 0; k < 3; k++) {
      JSONArray items = new JSONArray();
      for (Drug d : drugs) {
        if (!d.in(SLOTS[k]) || !d.activeOn(today)) continue;
        JSONObject o = new JSONObject();
        o.put("name", d.name);
        o.put("dose", d.dose);
        o.put("foodText", foodText(d.food));
        items.put(o);
      }
      if (items.length() == 0) continue;
      JSONObject s = new JSONObject();
      s.put("slot", SLOTS[k]);
      s.put("name", slotName(SLOTS[k]));
      s.put("time", times[k]);
      s.put("items", items);
      schedule.put(s);
    }
    res.put("schedule", schedule);
    res.put("recommendations", recommendations(MobDb.s(p, "c7")));
    Object[] f = followup(conn, pid);
    if (f != null) {
      JSONObject o = new JSONObject();
      o.put("date", MobDb.iso((Date) f[0]));
      o.put("doctor", f[1]);
      o.put("inDays", MobDb.daysBetween(today, (Date) f[0]));
      res.put("followup", o);
    }
    return res;
  }

  /** Текст "Рекомендовано" для приложения: без блока препаратов и повторного приёма (они показаны отдельно), без HTML */
  public static String recommendations(String c7) {
    if (c7 == null) return "";
    String h = c7.replaceAll("(?is)<p>\\s*(<strong>)?\\s*" + DRUGS_TITLE + "\\s*(</strong>)?\\s*</p>\\s*(<(ol|ul)>.*?</\\4>\\s*)*", "")
      .replaceAll("(?is)<p>\\s*(<strong>)?\\s*" + FOLLOWUP_TITLE + ".*?</p>", "");
    return htmlToText(h);
  }

  /** HTML редактора -> обычный текст с переносами строк */
  public static String htmlToText(String html) {
    if (html == null) return "";
    String t = html.replaceAll("(?is)<script.*?</script>", "")
      .replaceAll("(?i)<br\\s*/?>", "\n")
      .replaceAll("(?i)<li[^>]*>", "\n• ")
      .replaceAll("(?i)</(p|div|h\\d|li|tr)>", "\n")
      .replaceAll("<[^>]+>", "")
      .replace("&nbsp;", " ").replace("&lt;", "<").replace("&gt;", ">").replace("&quot;", "\"").replace("&#39;", "'").replace("&amp;", "&");
    t = t.replaceAll("[ \\t]+", " ").replaceAll(" *\n *", "\n").replaceAll("\n{3,}", "\n\n");
    return t.trim();
  }
}
