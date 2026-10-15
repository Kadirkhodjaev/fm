package ckb.services.med.patient;

import ckb.domains.med.patient.Patients;
import ckb.session.Session;
import ckb.utils.DB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Кол-во койко-дней пациента (Patients.day_count) - строгая величина: по ней считаются бронирование коек,
 * питание и допустимый период назначений.
 *
 * - Задаёт медсестра приёмного при регистрации; пока пациент у приёмного (state пусто / PRN / PRD) его можно править там же.
 * - После приёмного врача меняют только лечащий врач пациента и администратор: кнопка в карточке -> Регистрация,
 *   с причиной; каждое изменение пишется в историю (Lv_Day_Counts).
 * - Дата регистрации + кол-во дней не может быть раньше сегодняшнего дня.
 * - При изменении сразу меняется конец питания пациента (Patient_Eats): дни добавляются со столом последнего дня,
 *   лишние неподтверждённые дни удаляются.
 * - Плановая дата выписки = дата регистрации + кол-во дней - 1 (день регистрации и день выписки оба койко-дни);
 *   после выписки границей служит Date_End (она всегда равна этой же дате).
 */
public class DayCount {

  public static final int MAX_DAYS = 365;
  private static volatile boolean tableReady = false;

  private static String fmt(Date d) {
    return d == null ? "" : new SimpleDateFormat("dd.MM.yyyy").format(d);
  }

  public static Date day(Date d) {
    Calendar c = Calendar.getInstance();
    c.setTime(d);
    c.set(Calendar.HOUR_OF_DAY, 0);
    c.set(Calendar.MINUTE, 0);
    c.set(Calendar.SECOND, 0);
    c.set(Calendar.MILLISECOND, 0);
    return c.getTime();
  }

  public static Date addDays(Date d, int n) {
    Calendar c = Calendar.getInstance();
    c.setTime(day(d));
    c.add(Calendar.DATE, n);
    return c.getTime();
  }

  /** Плановая дата выписки: дата регистрации + кол-во дней - 1 (или null) */
  public static Date planEnd(Date begin, Integer days) {
    return begin == null || days == null ? null : addDays(begin, days - 1);
  }

  /** Последний допустимый день назначений: дата выписки, а во время лечения - дата регистрации + кол-во дней */
  public static Date periodEnd(Patients p) {
    return p.getDateEnd() != null ? day(p.getDateEnd()) : planEnd(p.getDateBegin(), p.getDayCount());
  }

  /** Пока пациент у приёмного (медсестра, врач приёмного), кол-во дней правится в регистрации */
  public static boolean regEditable(Patients p) {
    String s = p.getState();
    return p.getId() == null || s == null || s.isEmpty() || "PRN".equals(s) || "PRD".equals(s);
  }

  /** После приёмного: лечащий врач этого пациента или администратор, пока карта не в архиве */
  public static boolean canChange(Session s, Patients p) {
    if (s == null || p == null || "ARCH".equals(p.getState())) return false;
    if (s.getRoleId() == 1 || s.getUserId() == 1) return true;
    return p.getLv_id() != null && p.getLv_id() == s.getUserId();
  }

  /** Проверка нового кол-ва дней; null - всё верно, иначе текст ошибки */
  public static String check(Date begin, Integer days) {
    if (days == null || days < 1) return "Укажите кол-во койко-дней (не меньше 1).";
    if (days > MAX_DAYS) return "Кол-во койко-дней не может быть больше " + MAX_DAYS + ".";
    Date b = begin == null ? day(new Date()) : day(begin);
    Date end = planEnd(b, days);
    if (end.before(day(new Date())))
      return "Дата регистрации (" + fmt(b) + ") + " + days + " дн. - 1 = выписка " + fmt(end) + ": это раньше сегодняшнего дня. " +
        "Укажите не меньше " + minDays(b) + " дн.";
    return null;
  }

  /** Проверка для пациента: после выписки (Date_End есть) ограничение «не раньше сегодня» не действует, только 1..365 */
  public static String check(Patients p, Integer days) {
    if (p.getDateEnd() != null) {
      if (days == null || days < 1) return "Укажите кол-во койко-дней (не меньше 1).";
      if (days > MAX_DAYS) return "Кол-во койко-дней не может быть больше " + MAX_DAYS + ".";
      return null;
    }
    return check(p.getDateBegin(), days);
  }

  private static int daysBetween(Date a, Date b) {
    return (int) Math.round((day(b).getTime() - day(a).getTime()) / (24.0 * 3600 * 1000));
  }

  /** Наименьшее кол-во дней, при котором выписка (регистрация + дни - 1) не раньше сегодняшнего дня */
  public static int minDays(Date begin) {
    return begin == null ? 1 : Math.max(1, daysBetween(begin, day(new Date())) + 1);
  }

  /** Период назначения внутри лечения: не раньше даты регистрации и не позже выписки (или регистрации + кол-во дней) */
  public static String checkPeriod(Patients p, Date from, Date to) {
    if (p == null || p.getDateBegin() == null) return null;
    Date b = day(p.getDateBegin()), e = periodEnd(p);
    if (from != null && day(from).before(b))
      return "Начало назначения (" + fmt(from) + ") не может быть раньше даты регистрации пациента (" + fmt(b) + ").";
    if (e != null && to != null && day(to).after(e))
      return "Конец назначения (" + fmt(to) + ") не может быть позже " + (p.getDateEnd() != null ? "даты выписки" : "плановой выписки: регистрация + " + p.getDayCount() + " дн.") +
        " (" + fmt(e) + ").";
    if (e != null && from != null && day(from).after(e))
      return "Начало назначения (" + fmt(from) + ") позже " + (p.getDateEnd() != null ? "даты выписки" : "плановой выписки") + " (" + fmt(e) + ").";
    return null;
  }

  // ---------- История и питание ----------

  private static void initTable(Connection conn) throws Exception {
    if (tableReady) return;
    PreparedStatement ps = conn.prepareStatement(
      "Create Table If Not Exists Lv_Day_Counts (" +
      "  id Int Not Null Auto_Increment Primary Key," +
      "  patient_id Int Not Null," +
      "  old_days Int Null," +
      "  new_days Int Not Null," +
      "  reason Varchar(500) Null," +
      "  user_id Int Not Null," +
      "  created DateTime Not Null," +
      "  Key lv_day_counts_p (patient_id)" +
      ") Default Charset = utf8");
    ps.executeUpdate();
    DB.done(ps);
    tableReady = true;
  }

  /** Записать изменение в историю и привести питание к новому концу лечения. Сам Patients.day_count сохраняет вызывающий. */
  public static void afterChange(Patients p, Integer oldDays, int newDays, String reason, int userId) throws Exception {
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    try {
      initTable(conn);
      ps = conn.prepareStatement("Insert Into Lv_Day_Counts (patient_id, old_days, new_days, reason, user_id, created) Values (?, ?, ?, ?, ?, Now())");
      ps.setInt(1, p.getId());
      if (oldDays == null) ps.setNull(2, java.sql.Types.INTEGER); else ps.setInt(2, oldDays);
      ps.setInt(3, newDays);
      ps.setString(4, reason == null ? null : (reason.length() > 500 ? reason.substring(0, 500) : reason));
      ps.setInt(5, userId);
      ps.executeUpdate();
      DB.done(ps);
      ps = null;
      shapeEats(conn, p.getId());
    } finally {
      DB.done(ps);
      DB.done(conn);
    }
  }

  // ---------- Время ухода в день выписки ----------

  /**
   * После какого приёма пищи пациент уходит в день выписки: 1..N - порядковый номер типа питания (Eat_s_Menu_Types по id:
   * Нонушта, Тушлик, Кечки чой, Кечки овкат), NEXT_BREAKFAST - остаётся до завтрака следующего дня. 0 - ещё не выбрано
   * (питание считается как «только завтрак»). Выбирает лечащий врач в карточке -> Регистрация (таблица Lv_Leaves).
   */
  public static final int NEXT_BREAKFAST = 99;
  private static volatile boolean leaveReady = false;

  static void initLeave(Connection conn) throws Exception {
    if (leaveReady) return;
    PreparedStatement ps = conn.prepareStatement(
      "Create Table If Not Exists Lv_Leaves (" +
      "  patient_id Int Not Null Primary Key," +
      "  meal Int Not Null," +
      "  user_id Int Not Null," +
      "  updated DateTime Not Null" +
      ") Default Charset = utf8");
    ps.executeUpdate();
    DB.done(ps);
    leaveReady = true;
  }

  /** Активные типы питания по порядку: [id, название] */
  public static List<Object[]> menuTypes(Connection conn) throws Exception {
    List<Object[]> res = new ArrayList<>();
    PreparedStatement ps = conn.prepareStatement("Select id, name From Eat_s_Menu_Types Where state = 'A' Order By id");
    ResultSet rs = ps.executeQuery();
    while (rs.next()) res.add(new Object[]{rs.getInt(1), rs.getString(2)});
    DB.done(rs);
    DB.done(ps);
    return res;
  }

  /** Выбранное время ухода (0 - не выбрано) */
  public static int leave(Connection conn, int patientId) throws Exception {
    initLeave(conn);
    PreparedStatement ps = conn.prepareStatement("Select meal From Lv_Leaves Where patient_id = ?");
    ps.setInt(1, patientId);
    ResultSet rs = ps.executeQuery();
    int v = rs.next() ? rs.getInt(1) : 0;
    DB.done(rs);
    DB.done(ps);
    return v;
  }

  public static int leave(int patientId) throws Exception {
    Connection conn = DB.getConnection();
    try {
      return leave(conn, patientId);
    } finally {
      DB.done(conn);
    }
  }

  /** Сохранить время ухода и сразу привести питание дня выписки к нему */
  public static void setLeave(int patientId, int meal, int userId) throws Exception {
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    try {
      initLeave(conn);
      ps = conn.prepareStatement("Insert Into Lv_Leaves (patient_id, meal, user_id, updated) Values (?, ?, ?, Now()) " +
        "On Duplicate Key Update meal = Values(meal), user_id = Values(user_id), updated = Now()");
      ps.setInt(1, patientId);
      ps.setInt(2, meal);
      ps.setInt(3, userId);
      ps.executeUpdate();
      DB.done(ps);
      ps = null;
      shapeEats(conn, patientId);
    } finally {
      DB.done(ps);
      DB.done(conn);
    }
  }

  /** Время ухода нужно выбрать: с 12:00 дня перед выпиской (и позже), пока не выбрано */
  public static boolean leaveRequired(Date planEnd, int meal) {
    if (meal != 0 || planEnd == null) return false;
    Date today = day(new Date());
    Date eve = addDays(planEnd, -1);
    if (today.after(eve)) return true;
    return today.equals(eve) && Calendar.getInstance().get(Calendar.HOUR_OF_DAY) >= 12;
  }

  /**
   * Пациенты лечащего врача, которым пора выбрать время ухода: [id, ФИО, ИБ, палата, дата выписки].
   * Те, кто ещё на лечении (state LV), у кого плановая выписка завтра (после 12:00) или уже наступила.
   */
  public static List<String[]> leavePending(int lvId) throws Exception {
    List<String[]> res = new ArrayList<>();
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      initLeave(conn);
      ps = conn.prepareStatement(
        "Select p.id, p.surname, p.name, p.middlename, p.yearNum, IfNull(p.Palata, r.name) room, p.Date_Begin, p.day_count " +
        "  From Patients p Left Join Rooms r On r.id = p.Room_Id " +
        " Where p.lv_id = ? And p.state = 'LV' And p.Date_Begin Is Not Null And p.day_count Is Not Null " +
        "   And Not Exists (Select 1 From Lv_Leaves l Where l.patient_id = p.id) " +
        "   And Date_Add(p.Date_Begin, Interval p.day_count - 2 Day) <= CurDate() " +
        " Order By p.surname, p.name");
      ps.setInt(1, lvId);
      rs = ps.executeQuery();
      while (rs.next()) {
        Date end = planEnd(rs.getDate("Date_Begin"), rs.getInt("day_count"));
        if (!leaveRequired(end, 0)) continue;
        String fio = ((rs.getString("surname") == null ? "" : rs.getString("surname")) + " " + (rs.getString("name") == null ? "" : rs.getString("name")) + " " +
          (rs.getString("middlename") == null ? "" : rs.getString("middlename"))).trim();
        res.add(new String[]{String.valueOf(rs.getInt("id")), fio, rs.getInt("yearNum") == 0 ? "" : String.valueOf(rs.getInt("yearNum")),
          rs.getString("room") == null ? "" : rs.getString("room"), fmt(end)});
      }
    } finally {
      DB.done(conn, ps, rs);
    }
    return res;
  }

  // ---------- Питание по дням лечения ----------

  /** Питание пациента по датам лечения (вызывается при открытии карточки «Питание» и после изменения дней или времени ухода). */
  public static void shapeEats(int patientId) throws Exception {
    Connection conn = DB.getConnection();
    try {
      shapeEats(conn, patientId);
    } finally {
      DB.done(conn);
    }
  }

  /**
   * Приводит Patient_Eats к датам лечения:
   *  - день регистрации без завтрака (пациент поступает после завтрака);
   *  - дни между ними - все приёмы пищи;
   *  - день выписки (регистрация + дни - 1, или Date_End) - до выбранного времени ухода включительно
   *    (не выбрано - только завтрак), «завтрак следующего дня» - весь день выписки и завтрак следующего дня.
   * Если питания ещё нет, оно создаётся целиком; иначе добавляются недостающие дни и приёмы в конце (стол - как в предыдущий раз
   * для этого приёма пищи), лишние неподтверждённые записи после конца удаляются. Подтверждённые (заявка сформирована) не трогаются.
   */
  static void shapeEats(Connection conn, int patientId) throws Exception {
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      ps = conn.prepareStatement("Select Date_Begin, Date_End, day_count, state From Patients Where id = ?");
      ps.setInt(1, patientId);
      rs = ps.executeQuery();
      if (!rs.next()) return;
      Date begin = rs.getDate(1) == null ? null : day(rs.getDate(1));
      Date last = rs.getDate(2) != null ? day(rs.getDate(2)) : planEnd(begin, rs.getObject(3) == null ? null : rs.getInt(3));
      DB.done(rs);
      DB.done(ps);
      rs = null;
      ps = null;
      if (begin == null || last == null || last.before(begin)) return;
      List<Object[]> types = menuTypes(conn);
      if (types.isEmpty()) return;
      int meal = leave(conn, patientId);
      boolean nextBreakfast = meal == NEXT_BREAKFAST;
      int upTo = meal == 0 ? 1 : (nextBreakfast ? types.size() : Math.min(meal, types.size()));
      Date stop = nextBreakfast ? addDays(last, 1) : last;
      int breakfast = (Integer) types.get(0)[0];

      // какие приёмы пищи нужны: дата -> множество menuType
      Map<Long, Set<Integer>> want = new LinkedHashMap<>();
      for (Date d = begin; !d.after(stop); d = addDays(d, 1)) {
        Set<Integer> s = new LinkedHashSet<>();
        for (int k = 0; k < types.size(); k++) {
          int id = (Integer) types.get(k)[0];
          if (d.equals(begin) && id == breakfast) continue;
          if (d.equals(last) && k + 1 > upTo) continue;
          if (nextBreakfast && d.equals(stop) && id != breakfast) continue;
          s.add(id);
        }
        want.put(d.getTime(), s);
      }

      // что уже есть
      Map<Long, Map<Integer, String>> have = new HashMap<>();
      ps = conn.prepareStatement("Select actDate, menuType_Id, state From Patient_Eats Where patient_Id = ?");
      ps.setInt(1, patientId);
      rs = ps.executeQuery();
      boolean any = false;
      Date maxHave = null;
      while (rs.next()) {
        any = true;
        Date d = day(rs.getTimestamp(1));
        if (maxHave == null || d.after(maxHave)) maxHave = d;
        Map<Integer, String> m = have.get(d.getTime());
        if (m == null) have.put(d.getTime(), m = new HashMap<>());
        m.put(rs.getInt(2), rs.getString(3) == null ? "ENT" : rs.getString(3));
      }
      DB.done(rs);
      DB.done(ps);
      rs = null;
      ps = null;

      // у существующего питания правим только хвост: от прежнего последнего дня (он мог быть днём выписки и стать обычным)
      // или от нового дня выписки, если лечение сократили; день регистрации и середину не трогаем
      Date tailFrom = !any ? begin : (maxHave.before(last) ? maxHave : last);

      // удалить лишнее после конца и лишние приёмы в дни хвоста
      ps = conn.prepareStatement("Delete From Patient_Eats Where patient_Id = ? And actDate >= ? And actDate < ? And menuType_Id = ? And IfNull(state, 'ENT') In ('ENT', 'REF')");
      for (Map.Entry<Long, Map<Integer, String>> e : have.entrySet()) {
        Date d = new Date(e.getKey());
        if (d.before(tailFrom)) continue;
        Set<Integer> s = want.get(e.getKey());
        for (Map.Entry<Integer, String> x : e.getValue().entrySet()) {
          if (s != null && s.contains(x.getKey())) continue;
          if (!"ENT".equals(x.getValue()) && !"REF".equals(x.getValue())) continue;
          ps.setInt(1, patientId);
          ps.setTimestamp(2, new Timestamp(d.getTime()));
          ps.setTimestamp(3, new Timestamp(addDays(d, 1).getTime()));
          ps.setInt(4, x.getKey());
          ps.executeUpdate();
        }
      }
      DB.done(ps);
      ps = null;

      // добавить недостающее (стол - последний выбранный для этого приёма пищи до этой даты)
      PreparedStatement prev = conn.prepareStatement(
        "Select table_Id, mode_Id, state From Patient_Eats Where patient_Id = ? And menuType_Id = ? And actDate < ? Order By actDate Desc, id Desc Limit 1");
      ps = conn.prepareStatement("Insert Into Patient_Eats (patient_Id, actDate, menuType_Id, table_Id, mode_Id, state) Values (?, ?, ?, ?, ?, 'ENT')");
      try {
        for (Map.Entry<Long, Set<Integer>> e : want.entrySet()) {
          Date d = new Date(e.getKey());
          if (d.before(tailFrom)) continue;
          Map<Integer, String> m = have.get(e.getKey());
          for (Integer t : e.getValue()) {
            if (m != null && m.containsKey(t)) continue;
            Object table = null, mode = null;
            prev.setInt(1, patientId);
            prev.setInt(2, t);
            prev.setTimestamp(3, new Timestamp(d.getTime()));
            ResultSet p = prev.executeQuery();
            if (p.next()) {
              table = "REF".equals(p.getString(3)) ? null : p.getObject(1);
              mode = p.getObject(2);
            }
            DB.done(p);
            ps.setInt(1, patientId);
            ps.setTimestamp(2, new Timestamp(d.getTime()));
            ps.setInt(3, t);
            ps.setObject(4, table);
            ps.setObject(5, mode);
            ps.executeUpdate();
          }
        }
      } finally {
        DB.done(prev);
      }
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
  }

  /** История изменений: [дата, кто, было, стало, причина], новые сверху */
  public static List<String[]> history(int patientId) throws Exception {
    List<String[]> res = new ArrayList<>();
    Connection conn = DB.getConnection();
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      initTable(conn);
      ps = conn.prepareStatement(
        "Select h.created, u.fio, h.old_days, h.new_days, h.reason From Lv_Day_Counts h Left Join Users u On u.id = h.user_id " +
        " Where h.patient_id = ? Order By h.id Desc");
      ps.setInt(1, patientId);
      rs = ps.executeQuery();
      while (rs.next())
        res.add(new String[]{new SimpleDateFormat("dd.MM.yyyy HH:mm").format(rs.getTimestamp(1)), rs.getString(2) == null ? "" : rs.getString(2),
          rs.getObject(3) == null ? "" : String.valueOf(rs.getInt(3)), String.valueOf(rs.getInt(4)), rs.getString(5) == null ? "" : rs.getString(5)});
    } finally {
      DB.done(conn, ps, rs);
    }
    return res;
  }
}
