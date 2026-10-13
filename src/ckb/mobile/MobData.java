package ckb.mobile;

import ckb.mobile.MobAuth.ApiError;
import ckb.mobile.MobAuth.Who;
import ckb.utils.tg.Tg;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONObject;

import java.sql.Connection;
import java.util.*;

/**
 * Данные экранов приложения. Запросы те же, что у бота пациента (TgPatientBot, TgClientBot),
 * поэтому бот и приложение показывают одно и то же. Значения анализов не отдаются: только "результат готов".
 *
 * Каждый запрос проверяет, что клиент, госпитализация или визит относятся к номеру из токена:
 * клиент найден по последним 9 цифрам в карточке клиента, в визите или в истории болезни.
 */
public class MobData {

  // ---------- Номер -> клиенты ----------

  private static final Map<String, Object[]> CACHE = new HashMap<>(); // phone9 -> [время, Set<Integer>]
  private static final long CACHE_MS = 120000;

  /** Клиенты номера: Crm_Clients.tel, Amb_Patients.tel или Patients.tel совпадают по последним 9 цифрам */
  @SuppressWarnings("unchecked")
  public static Set<Integer> clientIds(Connection conn, String phone9, boolean fresh) throws Exception {
    synchronized (CACHE) {
      Object[] c = CACHE.get(phone9);
      if (!fresh && c != null && System.currentTimeMillis() - (Long) c[0] < CACHE_MS) return (Set<Integer>) c[1];
    }
    Set<Integer> ids = new LinkedHashSet<>();
    for (Map<String, Object> r : MobDb.rows(conn,
      "Select c.id From Crm_Clients c Where " + MobDb.tel9("c.tel") + " = ? " +
      "Union Select a.client_Id From Amb_Patients a Where a.client_Id Is Not Null And " + MobDb.tel9("a.tel") + " = ? " +
      "Union Select p.client_Id From Patients p Where p.client_Id Is Not Null And " + MobDb.tel9("p.tel") + " = ?",
      phone9, phone9, phone9)) ids.add(MobDb.i(r, "id"));
    // карточка клиента могла быть удалена
    if (!ids.isEmpty()) {
      Set<Integer> real = new LinkedHashSet<>();
      for (Map<String, Object> r : MobDb.rows(conn, "Select id From Crm_Clients Where id In (" + MobDb.marks(ids.size()) + ")", ids.toArray()))
        real.add(MobDb.i(r, "id"));
      ids = real;
    }
    synchronized (CACHE) {
      if (CACHE.size() > 5000) CACHE.clear();
      CACHE.put(phone9, new Object[]{System.currentTimeMillis(), ids});
    }
    return ids;
  }

  static void ownClient(Connection conn, Who who, int clientId) throws Exception {
    if (!clientIds(conn, who.phone9, false).contains(clientId)) throw new ApiError(404, "not_found", "Клиент не найден.");
  }

  /** Госпитализация клиента этого номера: строка Patients или ошибка 404 */
  static Map<String, Object> ownStay(Connection conn, Who who, int stayId) throws Exception {
    Map<String, Object> p = MobDb.row(conn, "Select id, client_Id, state, Date_Begin, Date_End, paid, name From Patients Where id = ?", stayId);
    if (p == null || p.get("client_Id") == null || !clientIds(conn, who.phone9, false).contains(MobDb.i(p, "client_Id")))
      throw new ApiError(404, "not_found", "Лечение не найдено.");
    return p;
  }

  static Map<String, Object> ownVisit(Connection conn, Who who, int ambId) throws Exception {
    Map<String, Object> a = MobDb.row(conn, "Select id, client_Id, qrcode, Reg_Date From Amb_Patients Where id = ?", ambId);
    if (a == null || a.get("client_Id") == null || !clientIds(conn, who.phone9, false).contains(MobDb.i(a, "client_Id")))
      throw new ApiError(404, "not_found", "Визит не найден.");
    return a;
  }

  // ---------- GET /clients ----------

  public static JSONArray clients(Connection conn, Who who) throws Exception {
    Set<Integer> ids = clientIds(conn, who.phone9, false);
    JSONArray arr = new JSONArray();
    if (ids.isEmpty()) return arr;
    Set<Integer> off = new HashSet<>();
    for (Map<String, Object> r : MobDb.rows(conn, "Select client_id From Mob_Client_Off Where phone9 = ?", who.phone9)) off.add(MobDb.i(r, "client_id"));
    List<Object> params = new ArrayList<>();
    params.add(who.phone9);
    params.addAll(ids);
    List<Map<String, Object>> list = MobDb.rows(conn,
      "Select c.id, c.surname, c.name, c.middlename, c.birthyear, c.birthdate, (" + MobDb.tel9("c.tel") + " = ?) own, " +
      "       (Select p.id From Patients p Where p.client_Id = c.id And p.state = 'LV' Order By p.Date_Begin Desc, p.id Desc Limit 1) stay_id, " +
      "       (Select Count(*) From Amb_Patients a Where a.client_Id = c.id " +
      "           And Exists (Select 1 From Amb_Patient_Services s Where s.patient = a.id And s.state Not In ('DEL', 'AUTO_DEL'))) visits " +
      "  From Crm_Clients c Where c.id In (" + MobDb.marks(ids.size()) + ") " +
      " Order By own Desc, IfNull(c.birthyear, 3000), c.id", params.toArray());
    Calendar now = Calendar.getInstance();
    for (Map<String, Object> r : list) {
      int id = MobDb.i(r, "id");
      JSONObject o = new JSONObject();
      o.put("id", id);
      o.put("surname", MobDb.s(r, "surname"));
      o.put("firstName", MobDb.s(r, "name"));
      o.put("middlename", MobDb.s(r, "middlename"));
      o.put("name", fio(MobDb.s(r, "surname"), MobDb.s(r, "name"), MobDb.s(r, "middlename")));
      o.put("initials", initials(MobDb.s(r, "surname"), MobDb.s(r, "name")));
      int year = MobDb.i(r, "birthyear");
      Date bd = MobDb.d(r, "birthdate");
      if (year == 0 && bd != null) {
        Calendar c = Calendar.getInstance();
        c.setTime(bd);
        year = c.get(Calendar.YEAR);
      }
      if (year > 1900) {
        o.put("birthyear", year);
        o.put("age", age(bd, year, now));
      }
      o.put("own", MobDb.i(r, "own") == 1);
      o.put("visits", MobDb.i(r, "visits"));
      o.put("notify", !off.contains(id));
      if (r.get("stay_id") != null) o.put("stay", stayShort(conn, MobDb.i(r, "stay_id")));
      o.put("home", HomePlan.activeStay(conn, id) != null);
      arr.put(o);
    }
    return arr;
  }

  private static int age(Date bd, int year, Calendar now) {
    if (bd == null) return now.get(Calendar.YEAR) - year;
    Calendar b = Calendar.getInstance();
    b.setTime(bd);
    int a = now.get(Calendar.YEAR) - b.get(Calendar.YEAR);
    if (now.get(Calendar.DAY_OF_YEAR) < b.get(Calendar.DAY_OF_YEAR)) a--;
    return a;
  }

  static String fio(String s, String n, String m) {
    return (s + " " + n + " " + m).trim().replaceAll("\\s+", " ");
  }

  private static String initials(String s, String n) {
    return ((n.isEmpty() ? "" : n.substring(0, 1)) + (s.isEmpty() ? "" : s.substring(0, 1))).toUpperCase();
  }

  // ---------- Стационар ----------

  /** Текущая госпитализация коротко: отделение, палата, врач, день N из M */
  private static JSONObject stayShort(Connection conn, int pid) throws Exception {
    Map<String, Object> p = MobDb.row(conn,
      "Select p.id, p.yearNum, p.Date_Begin, p.day_count, d.name dept, IfNull(p.Palata, r.name) room, u.fio lv " +
      "  From Patients p Left Join Depts d On d.id = p.Dept_Id Left Join Rooms r On r.id = p.Room_Id Left Join Users u On u.id = p.lv_id Where p.id = ?", pid);
    JSONObject o = new JSONObject();
    o.put("id", pid);
    o.put("dept", MobDb.s(p, "dept"));
    o.put("room", MobDb.s(p, "room"));
    o.put("doctor", MobDb.s(p, "lv"));
    o.put("ib", MobDb.i(p, "yearNum") == 0 ? "" : String.valueOf(MobDb.i(p, "yearNum")));
    Date begin = MobDb.d(p, "Date_Begin");
    o.put("from", MobDb.iso(begin));
    int days = MobDb.i(p, "day_count");
    if (begin != null) {
      int day = MobDb.daysBetween(begin, new Date()) + 1;
      o.put("day", day);
      if (days > 0) {
        o.put("days", days);
        o.put("plannedTo", MobDb.iso(MobDb.addDays(begin, days - 1)));
      }
    }
    o.put("diet", diet(conn, pid));
    return o;
  }

  /** GET /clients/{id}/stays: текущая и прошлые госпитализации */
  public static JSONObject stays(Connection conn, Who who, int clientId) throws Exception {
    ownClient(conn, who, clientId);
    JSONObject res = new JSONObject();
    JSONArray past = new JSONArray();
    for (Map<String, Object> p : MobDb.rows(conn,
      "Select p.id, p.state, p.yearNum, p.Date_Begin, p.Date_End, p.paid, d.name dept, " +
      "       (Select Count(*) From Lv_Docs v Where v.patient_Id = p.id And v.docCode = 'vypiska') vyp " +
      "  From Patients p Left Join Depts d On d.id = p.Dept_Id Where p.client_Id = ? And p.Date_Begin Is Not Null " +
      " Order By p.Date_Begin Desc, p.id Desc", clientId)) {
      if ("LV".equals(MobDb.s(p, "state"))) {
        if (!res.has("current")) res.put("current", stayShort(conn, MobDb.i(p, "id")));
        continue;
      }
      JSONObject o = new JSONObject();
      o.put("id", MobDb.i(p, "id"));
      o.put("dept", MobDb.s(p, "dept"));
      o.put("from", MobDb.iso(MobDb.d(p, "Date_Begin")));
      o.put("to", MobDb.iso(MobDb.d(p, "Date_End")));
      o.put("ib", MobDb.i(p, "yearNum") == 0 ? "" : String.valueOf(MobDb.i(p, "yearNum")));
      // выписку отдаём, как и бот: касса закрыта и врач заполнил выписку
      o.put("epicrisis", "CLOSED".equals(MobDb.s(p, "paid")) && MobDb.i(p, "vyp") > 0);
      past.put(o);
    }
    if (!res.has("current")) res.put("current", JSONObject.NULL);
    res.put("past", past);
    return res;
  }

  private static String diet(Connection conn, int pid) throws Exception {
    Object v = MobDb.value(conn,
      "Select t.name From Patient_Eats e Join Eat_s_Tables t On t.id = e.table_Id Where e.patient_Id = ? Order By e.actDate Desc, e.id Desc Limit 1", pid);
    return v == null ? "" : v.toString().trim();
  }

  private static final String[] SLOT_COLS = {"morning", "noon", "evening"};

  /** GET /stays/{id}/day?date=: препараты по времени, физиотерапия, обследования, стол */
  public static JSONObject day(Connection conn, Who who, int stayId, Date date) throws Exception {
    ownStay(conn, who, stayId);
    Date day = MobDb.day(date == null ? new Date() : date);
    JSONObject res = new JSONObject();
    res.put("date", MobDb.iso(day));
    res.put("diet", diet(conn, stayId));
    String[] times = {MobConfig.patientTime("morning", "08:00"), MobConfig.patientTime("noon", "13:00"), MobConfig.patientTime("evening", "19:00")};
    List<Map<String, Object>> rows = MobDb.rows(conn,
      "Select d.id, d.morningTime, d.noonTime, d.eveningTime, d.morningTimeBefore, d.morningTimeAfter, d.noonTimeBefore, d.noonTimeAfter, " +
      "       d.eveningTimeBefore, d.eveningTimeAfter, dt.name drug_type, it.name inj_type, " +
      "       dd.morningTimeDone, dd.noonTimeDone, dd.eveningTimeDone, IfNull(n.name, r.name) nm, r.source, r.expanse, m.name measure " +
      "  From Patient_Drugs d " +
      "  Join Patient_Drug_Dates dd On dd.patientDrug_Id = d.id And dd.date = ? And dd.checked = 1 " +
      "  Join Patient_Drug_Rows r On r.patientDrug_Id = d.id " +
      "  Left Join Drug_s_Names n On n.id = r.drug_Id Left Join Drug_s_Measures m On m.id = r.measure_Id " +
      "  Left Join Dicts dt On dt.id = d.drugType_Id Left Join Dicts it On it.id = d.injectionType_Id " +
      " Where d.patient_Id = ? Order By d.id, r.id", MobDb.iso(day), stayId);
    JSONArray slots = new JSONArray();
    for (int k = 0; k < 3; k++) {
      String c = SLOT_COLS[k];
      JSONArray items = new JSONArray();
      for (Map<String, Object> r : rows) {
        if (!MobDb.b(r, c + "Time") || MobDb.s(r, "nm").isEmpty()) continue;
        boolean tablet = r.get("inj_type") == null;
        JSONObject o = new JSONObject();
        o.put("name", MobDb.s(r, "nm"));
        o.put("dose", dose(r));
        o.put("kind", tablet ? (MobDb.s(r, "drug_type").isEmpty() ? "Таблетки" : MobDb.s(r, "drug_type")) : MobDb.s(r, "inj_type"));
        o.put("tablet", tablet);
        o.put("food", MobDb.b(r, c + "TimeBefore") ? "до еды" : MobDb.b(r, c + "TimeAfter") ? "после еды" : "");
        o.put("own", "own".equals(MobDb.s(r, "source")));
        o.put("done", MobDb.b(r, c + "TimeDone"));
        items.put(o);
      }
      if (items.length() == 0) continue;
      JSONObject s = new JSONObject();
      s.put("slot", HomePlan.SLOTS[k]);
      s.put("name", HomePlan.slotName(HomePlan.SLOTS[k]));
      s.put("time", times[k]);
      s.put("items", items);
      slots.put(s);
    }
    res.put("slots", slots);
    JSONArray fizio = new JSONArray();
    for (Map<String, Object> r : MobDb.rows(conn,
      "Select k.name, k.room, f.oblast, d.done, " +
      "       (Select Count(*) From Lv_Fizio_Dates x Where x.fizio_Id = f.id And x.state = 'Y') total, " +
      "       (Select Count(*) From Lv_Fizio_Dates x Where x.fizio_Id = f.id And x.state = 'Y' And x.done = 'Y') done_cnt " +
      "  From Lv_Fizio_Dates d Join Lv_Fizios f On f.id = d.fizio_Id Left Join Kdos k On k.id = f.Kdo_Id " +
      " Where f.patientId = ? And d.date = ? And d.state = 'Y' Order By k.name", stayId, MobDb.iso(day))) {
      JSONObject o = new JSONObject();
      o.put("name", MobDb.s(r, "name"));
      o.put("area", MobDb.s(r, "oblast"));
      o.put("room", MobDb.s(r, "room"));
      o.put("done", "Y".equals(MobDb.s(r, "done")));
      o.put("session", MobDb.i(r, "done_cnt") + ("Y".equals(MobDb.s(r, "done")) ? 0 : 1));
      o.put("total", MobDb.i(r, "total"));
      fizio.put(o);
    }
    res.put("fizio", fizio);
    res.put("exams", examsOn(conn, stayId, day));
    res.put("tomorrow", examsOn(conn, stayId, MobDb.addDays(day, 1)));
    return res;
  }

  private static String dose(Map<String, Object> r) {
    Object exp = r.get("expanse");
    if (!(exp instanceof Number) || ((Number) exp).doubleValue() <= 0) return "";
    double x = ((Number) exp).doubleValue();
    return (x == Math.floor(x) ? String.valueOf((long) x) : String.valueOf(x).replace('.', ',')) + (MobDb.s(r, "measure").isEmpty() ? "" : " " + MobDb.s(r, "measure"));
  }

  /** Обследования, назначенные на день и ещё не сделанные */
  private static JSONArray examsOn(Connection conn, int pid, Date day) throws Exception {
    JSONArray arr = new JSONArray();
    for (Map<String, Object> r : MobDb.rows(conn,
      "Select k.name From Lv_Plans p Join Kdos k On k.id = p.Kdo_Id " +
      " Where p.patientId = ? And p.Done_Flag != 'Y' And IfNull(p.rejectFlag, 'N') != 'Y' " +
      "   And p.actDate >= ? And p.actDate < Date_Add(?, Interval 1 Day) Order By k.name", pid, MobDb.iso(day), MobDb.iso(day)))
      arr.put(MobDb.s(r, "name"));
    return arr;
  }

  /** GET /stays/{id}/progress */
  public static JSONObject progress(Connection conn, Who who, int stayId) throws Exception {
    ownStay(conn, who, stayId);
    JSONObject res = stayShort(conn, stayId);
    Map<String, Object> c = MobDb.row(conn,
      "Select (Select Count(*) From Lv_Plans x Where x.patientId = p.id And IfNull(x.rejectFlag, 'N') != 'Y') plans, " +
      "       (Select Count(*) From Lv_Plans x Where x.patientId = p.id And x.Done_Flag = 'Y' And IfNull(x.rejectFlag, 'N') != 'Y') plans_done, " +
      "       (Select Count(*) From Lv_Fizio_Dates x Join Lv_Fizios f On f.id = x.fizio_Id Where f.patientId = p.id And x.state = 'Y') fz, " +
      "       (Select Count(*) From Lv_Fizio_Dates x Join Lv_Fizios f On f.id = x.fizio_Id Where f.patientId = p.id And x.state = 'Y' And x.done = 'Y') fz_done " +
      "  From Patients p Where p.id = ?", stayId);
    // уколы и капельницы: каждое время приёма в отмеченные дни
    Map<String, Object> inj = MobDb.row(conn,
      "Select Sum((d.morningTime = 1) + (d.noonTime = 1) + (d.eveningTime = 1)) total, " +
      "       Sum((d.morningTime = 1 And dd.morningTimeDone = 1) + (d.noonTime = 1 And dd.noonTimeDone = 1) + (d.eveningTime = 1 And dd.eveningTimeDone = 1)) done " +
      "  From Patient_Drugs d Join Patient_Drug_Dates dd On dd.patientDrug_Id = d.id And dd.checked = 1 " +
      " Where d.patient_Id = ? And d.injectionType_Id Is Not Null", stayId);
    JSONArray parts = new JSONArray();
    part(parts, "Обследования", MobDb.i(c, "plans_done"), MobDb.i(c, "plans"));
    part(parts, "Процедуры и уколы", MobDb.i(inj, "done"), MobDb.i(inj, "total"));
    part(parts, "Физиотерапия", MobDb.i(c, "fz_done"), MobDb.i(c, "fz"));
    res.put("parts", parts);
    return res;
  }

  private static void part(JSONArray arr, String name, int done, int total) throws Exception {
    if (total <= 0) return;
    JSONObject o = new JSONObject();
    o.put("name", name);
    o.put("done", done);
    o.put("total", total);
    arr.put(o);
  }

  /** GET /stays/{id}/exams: только статус, без значений */
  public static JSONObject exams(Connection conn, Who who, int stayId) throws Exception {
    Map<String, Object> p = ownStay(conn, who, stayId);
    JSONObject res = new JSONObject();
    JSONArray arr = new JSONArray();
    Date now = new Date();
    for (Map<String, Object> r : MobDb.rows(conn,
      "Select k.name, p.actDate, p.Done_Flag From Lv_Plans p Join Kdos k On k.id = p.Kdo_Id " +
      " Where p.patientId = ? And IfNull(p.rejectFlag, 'N') != 'Y' Order By p.actDate, k.name", stayId)) {
      JSONObject o = new JSONObject();
      o.put("name", MobDb.s(r, "name"));
      o.put("date", MobDb.iso(MobDb.d(r, "actDate")));
      Date act = MobDb.d(r, "actDate");
      o.put("status", "Y".equals(MobDb.s(r, "Done_Flag")) ? "ok" : act != null && act.after(now) ? "plan" : "wait");
      arr.put(o);
    }
    res.put("items", arr);
    res.put("note", "Результаты обсудите с лечащим врачом. Значения он объяснит на обходе.");
    res.put("epicrisis", "CLOSED".equals(MobDb.s(p, "paid")) &&
      MobDb.count(conn, "Select Count(*) From Lv_Docs Where patient_Id = ? And docCode = 'vypiska'", stayId) > 0);
    return res;
  }

  // ---------- Амбулатория ----------

  /** GET /clients/{id}/visits: визиты, услуги со статусом, готовы ли результаты (PDF) */
  public static JSONArray visits(Connection conn, Who who, int clientId) throws Exception {
    ownClient(conn, who, clientId);
    List<Map<String, Object>> list = MobDb.rows(conn,
      "Select a.id, a.Reg_Date, a.qrcode From Amb_Patients a Where a.client_Id = ? " +
      "   And Exists (Select 1 From Amb_Patient_Services s Where s.patient = a.id And s.state Not In ('DEL', 'AUTO_DEL')) " +
      " Order By a.Reg_Date Desc, a.id Desc Limit 100", clientId);
    JSONArray arr = new JSONArray();
    if (list.isEmpty()) return arr;
    List<Object> ids = new ArrayList<>();
    for (Map<String, Object> a : list) ids.add(MobDb.i(a, "id"));
    Map<Integer, List<Map<String, Object>>> services = new HashMap<>();
    for (Map<String, Object> s : MobDb.rows(conn,
      "Select s.patient, v.name, s.state From Amb_Patient_Services s Join Amb_Services v On v.id = s.service_Id " +
      " Where s.patient In (" + MobDb.marks(ids.size()) + ") And s.state Not In ('DEL', 'AUTO_DEL') Order By s.id", ids.toArray())) {
      int pid = MobDb.i(s, "patient");
      if (!services.containsKey(pid)) services.put(pid, new ArrayList<Map<String, Object>>());
      services.get(pid).add(s);
    }
    for (Map<String, Object> a : list) {
      int id = MobDb.i(a, "id");
      JSONObject o = new JSONObject();
      o.put("id", id);
      o.put("date", MobDb.iso(MobDb.d(a, "Reg_Date")));
      JSONArray sv = new JSONArray();
      int done = 0, total = 0;
      List<Map<String, Object>> ss = services.get(id);
      if (ss != null) for (Map<String, Object> s : ss) {
        JSONObject x = new JSONObject();
        x.put("name", MobDb.s(s, "name"));
        String st = MobDb.s(s, "state");
        // DONE - готово; оплачено и ждёт выполнения - в работе; ещё не оплачено - запланировано
        x.put("status", "DONE".equals(st) ? "ok" : "ENT".equals(st) ? "plan" : "wait");
        if ("DONE".equals(st)) done++;
        total++;
        sv.put(x);
      }
      o.put("services", sv);
      o.put("status", total > 0 && done == total ? "ok" : "wait");
      // PDF строит сервис результатов клиники (как кнопка «Мои результаты» в боте)
      o.put("pdf", done > 0 && !MobDb.s(a, "qrcode").isEmpty());
      arr.put(o);
    }
    return arr;
  }

  // ---------- Вопрос врачу ----------

  public static JSONObject questions(Connection conn, Who who, int stayId) throws Exception {
    Map<String, Object> p = ownStay(conn, who, stayId);
    JSONObject res = new JSONObject();
    Map<String, Object> d = MobDb.row(conn, "Select u.fio From Patients p Left Join Users u On u.id = p.lv_id Where p.id = ?", stayId);
    res.put("doctor", d == null ? "" : MobDb.s(d, "fio"));
    res.put("open", "LV".equals(MobDb.s(p, "state")));
    JSONArray arr = new JSONArray();
    for (Map<String, Object> q : MobDb.rows(conn,
      "Select q.id, q.text, q.created, q.delivered, q.answer, q.answered_date, u.fio answered_by " +
      "  From Mob_Questions q Left Join Users u On u.id = q.answered_by Where q.patient_id = ? And q.phone9 = ? Order By q.id", stayId, who.phone9)) {
      JSONObject o = new JSONObject();
      o.put("id", MobDb.i(q, "id"));
      o.put("text", MobDb.s(q, "text"));
      o.put("created", MobDb.isoTime(MobDb.d(q, "created")));
      o.put("delivered", "Y".equals(MobDb.s(q, "delivered")));
      if (!MobDb.s(q, "answer").isEmpty()) {
        o.put("answer", MobDb.s(q, "answer"));
        o.put("answeredAt", MobDb.isoTime(MobDb.d(q, "answered_date")));
        o.put("answeredBy", MobDb.s(q, "answered_by"));
      }
      arr.put(o);
    }
    res.put("items", arr);
    return res;
  }

  /** POST /stays/{id}/questions: вопрос уходит лечащему врачу в бот сотрудников, если врач не подключён - постовым */
  public static JSONObject ask(Connection conn, Who who, int stayId, String text) throws Exception {
    Map<String, Object> p = ownStay(conn, who, stayId);
    if (!"LV".equals(MobDb.s(p, "state"))) throw new ApiError(409, "closed", "Лечение завершено, вопрос врачу недоступен.");
    text = text == null ? "" : text.trim();
    if (text.isEmpty()) throw new ApiError(400, "empty", "Напишите вопрос.");
    if (text.length() > 2000) text = text.substring(0, 2000);
    if (MobDb.count(conn, "Select Count(*) From Mob_Questions Where phone9 = ? And created > Date_Sub(Now(), Interval 1 Hour)", who.phone9) >= 10)
      throw new ApiError(429, "too_many", "Слишком много вопросов за час. Задайте вопрос медсестре на посту.");
    Map<String, Object> x = MobDb.row(conn,
      "Select p.lv_id, p.Dept_Id, p.surname, p.name, p.middlename, p.yearNum, IfNull(p.Palata, r.name) room " +
      "  From Patients p Left Join Rooms r On r.id = p.Room_Id Where p.id = ?", stayId);
    String fio = fio(MobDb.s(x, "surname"), MobDb.s(x, "name"), MobDb.s(x, "middlename")) + (MobDb.i(x, "yearNum") != 0 ? ", ИБ №" + MobDb.i(x, "yearNum") : "");
    String html = new String(Character.toChars(0x2709)) + " <b>Вопрос пациента</b> (приложение)\n" + Tg.esc(fio) +
      (MobDb.s(x, "room").isEmpty() ? "" : ", палата " + Tg.esc(MobDb.s(x, "room"))) + "\n\n" + Tg.esc(text);
    Integer to = null;
    if (x.get("lv_id") != null && Tg.isEnabled() && Tg.notify(conn, MobDb.i(x, "lv_id"), Tg.P_QUESTION, html)) to = MobDb.i(x, "lv_id");
    if (to == null && x.get("Dept_Id") != null && Tg.isEnabled()) {
      List<Integer> nurses = new ArrayList<>();
      for (Map<String, Object> u : MobDb.rows(conn,
        "Select Distinct u.id From Users u Join User_Roles ur On ur.users_id = u.id Where u.active = 1 And ur.roles_id = 11 And u.Dept_Id = ?", MobDb.i(x, "Dept_Id")))
        nurses.add(MobDb.i(u, "id"));
      if (Tg.notifyUsers(conn, nurses, Tg.P_QUESTION, html) > 0) to = 0;
    }
    MobDb.exec(conn, "Insert Into Mob_Questions (patient_id, client_id, phone9, session_id, text, to_user, delivered, created) Values (?, ?, ?, ?, ?, ?, ?, Now())",
      stayId, MobDb.i(p, "client_Id"), who.phone9, who.sessionId, ckb.utils.tg.Tg.bmp(text), to, to == null ? "N" : "Y");
    JSONObject res = new JSONObject();
    res.put("delivered", to != null);
    res.put("message", to == null ? "Сейчас не удалось передать вопрос. Пожалуйста, задайте его медсестре на посту."
      : to == 0 ? "Вопрос передан на пост медсёстрам вашего отделения." : "Вопрос передан лечащему врачу.");
    return res;
  }

  // ---------- Уведомления, настройки, устройства ----------

  public static JSONArray notifications(Connection conn, Who who) throws Exception {
    JSONArray arr = new JSONArray();
    for (Map<String, Object> n : MobDb.rows(conn,
      "Select id, client_id, kind, title, body, ref, created From Mob_Notifications Where phone9 = ? Order By id Desc Limit 100", who.phone9)) {
      JSONObject o = new JSONObject();
      o.put("id", MobDb.i(n, "id"));
      if (n.get("client_id") != null) o.put("clientId", MobDb.i(n, "client_id"));
      o.put("kind", MobDb.s(n, "kind"));
      o.put("title", MobDb.s(n, "title"));
      o.put("body", MobDb.s(n, "body"));
      o.put("created", MobDb.isoTime(MobDb.d(n, "created")));
      arr.put(o);
    }
    return arr;
  }

  public static JSONObject settings(Connection conn, Who who) throws Exception {
    Map<String, Object> s = MobDb.row(conn, "Select * From Mob_Settings Where phone9 = ?", who.phone9);
    String[] t = HomePlan.slotTimes(conn, who.phone9);
    JSONObject res = new JSONObject();
    res.put("lang", s == null || MobDb.s(s, "lang").isEmpty() ? "ru" : MobDb.s(s, "lang"));
    JSONObject times = new JSONObject();
    times.put("morning", t[0]);
    times.put("noon", t[1]);
    times.put("evening", t[2]);
    res.put("homeTimes", times);
    JSONObject st = new JSONObject();
    st.put("morning", MobConfig.patientTime("morning", "08:00"));
    st.put("noon", MobConfig.patientTime("noon", "13:00"));
    st.put("evening", MobConfig.patientTime("evening", "19:00"));
    st.put("digest", MobConfig.patientTime("digest", "07:30"));
    res.put("stayTimes", st);
    res.put("meds", s == null || !"N".equals(MobDb.s(s, "meds")));
    res.put("results", s == null || !"N".equals(MobDb.s(s, "results")));
    JSONArray off = new JSONArray();
    for (Map<String, Object> r : MobDb.rows(conn, "Select client_id From Mob_Client_Off Where phone9 = ?", who.phone9)) off.put(MobDb.i(r, "client_id"));
    res.put("clientsOff", off);
    return res;
  }

  /** PUT /settings: меняются только переданные поля */
  public static JSONObject saveSettings(Connection conn, Who who, JSONObject in) throws Exception {
    Map<String, Object> s = MobDb.row(conn, "Select * From Mob_Settings Where phone9 = ?", who.phone9);
    String lang = s == null ? "ru" : MobDb.s(s, "lang");
    String[] t = {s == null ? null : MobDb.s(s, "t_morning"), s == null ? null : MobDb.s(s, "t_noon"), s == null ? null : MobDb.s(s, "t_evening")};
    String meds = s == null ? "Y" : MobDb.s(s, "meds"), results = s == null ? "Y" : MobDb.s(s, "results");
    if (in.has("lang")) lang = "uz".equals(in.optString("lang")) ? "uz" : "ru";
    JSONObject times = in.optJSONObject("homeTimes");
    if (times != null) {
      String[] keys = {"morning", "noon", "evening"};
      for (int k = 0; k < 3; k++) {
        if (!times.has(keys[k])) continue;
        String v = MobConfig.normTime(times.optString(keys[k]));
        if (v == null) throw new ApiError(400, "bad_time", "Время в формате ЧЧ:ММ.");
        t[k] = v;
      }
    }
    if (in.has("meds")) meds = in.optBoolean("meds") ? "Y" : "N";
    if (in.has("results")) results = in.optBoolean("results") ? "Y" : "N";
    MobDb.exec(conn,
      "Insert Into Mob_Settings (phone9, lang, t_morning, t_noon, t_evening, meds, results, updated) Values (?, ?, ?, ?, ?, ?, ?, Now()) " +
      "On Duplicate Key Update lang = Values(lang), t_morning = Values(t_morning), t_noon = Values(t_noon), t_evening = Values(t_evening), " +
      "  meds = Values(meds), results = Values(results), updated = Now()",
      who.phone9, lang, t[0], t[1], t[2], meds, results);
    JSONArray off = in.optJSONArray("clientsOff");
    if (off != null) {
      Set<Integer> own = clientIds(conn, who.phone9, false);
      MobDb.exec(conn, "Delete From Mob_Client_Off Where phone9 = ?", who.phone9);
      for (int k = 0; k < off.length(); k++) {
        int id = off.optInt(k);
        if (own.contains(id)) MobDb.exec(conn, "Insert Ignore Into Mob_Client_Off (phone9, client_id) Values (?, ?)", who.phone9, id);
      }
    }
    return settings(conn, who);
  }

  /** POST /devices: телефон для push (fcm-токен) */
  public static void device(Connection conn, Who who, JSONObject in) throws Exception {
    String token = in.optString("fcmToken", "").trim();
    if (token.isEmpty() || token.length() > 255) throw new ApiError(400, "bad_token", "Нет токена устройства.");
    String platform = in.optString("platform", "").trim();
    String lang = "uz".equals(in.optString("lang")) ? "uz" : "ru";
    MobDb.exec(conn,
      "Insert Into Mob_Devices (session_id, phone9, fcm_token, platform, lang, updated) Values (?, ?, ?, ?, ?, Now()) " +
      "On Duplicate Key Update session_id = Values(session_id), phone9 = Values(phone9), platform = Values(platform), lang = Values(lang), updated = Now()",
      who.sessionId, who.phone9, token, platform.length() > 16 ? platform.substring(0, 16) : platform, lang);
  }
}
