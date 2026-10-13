package ckb.services.med.client;

import ckb.utils.DB;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Клиентская база: финансовые итоги и тип каждого клиента (Crm_Clients).
 *
 * Итоги по 54 тыс. клиентов считаются ~2 секунды, поэтому они хранятся в Crm_Client_Stats
 * и пересчитываются ночью (MedScheduler) и по кнопке "Пересчитать" в списке клиентов.
 * Финансовый анализ одного клиента (карточка) считается сразу, без кэша.
 *
 * Оплаты: Amb_Patient_Pays (амбулатория) и patient_pays (стационар), возвраты там хранятся с минусом.
 */
public class ClientStats {

  // ---------- Типы клиентов (правила в одном месте) ----------

  /** VIP - верхние N% клиентов по сумме всех оплат */
  public static final int VIP_TOP_PERCENT = 5;
  /** Постоянный - не меньше N визитов за последние 12 месяцев */
  public static final int REGULAR_VISITS_12M = 3;
  /** Новый - первый визит не раньше N дней назад */
  public static final int NEW_DAYS = 90;

  public static final String VIP = "VIP";
  public static final String REGULAR = "REGULAR";
  public static final String NEW = "NEW";
  public static final String USUAL = "USUAL";
  public static final String SLEEP = "SLEEP";
  public static final String NONE = "NONE";

  /** код -> [название, описание]; порядок = приоритет типа */
  public static final Map<String, String[]> SEGMENTS = new LinkedHashMap<>();
  static {
    SEGMENTS.put(VIP, new String[]{"VIP", "Топ " + VIP_TOP_PERCENT + "% клиентов по сумме оплат"});
    SEGMENTS.put(REGULAR, new String[]{"Постоянный", REGULAR_VISITS_12M + " и более визитов за последние 12 месяцев"});
    SEGMENTS.put(NEW, new String[]{"Новый", "Первый визит за последние " + NEW_DAYS + " дней"});
    SEGMENTS.put(USUAL, new String[]{"Обычный", "Был в клинике за последние 12 месяцев"});
    SEGMENTS.put(SLEEP, new String[]{"Спящий", "Не был в клинике больше 12 месяцев"});
    SEGMENTS.put(NONE, new String[]{"Без визитов", "Карточка есть, визитов нет"});
  }

  public static String segmentName(String code) {
    String[] s = SEGMENTS.get(code == null ? NONE : code);
    return s == null ? code : s[0];
  }

  // ---------- Таблицы ----------

  private static volatile boolean ready = false;

  private static void createStatsTable(Connection conn, String name) throws Exception {
    exec(conn,
      "Create Table If Not Exists " + name + " (" +
      "  client_id Int Not Null Primary Key," +
      "  amb_visits Int Not Null Default 0," +
      "  stat_visits Int Not Null Default 0," +
      "  visits_12m Int Not Null Default 0," +
      "  amb_paid Double(20,2) Not Null Default 0," +
      "  stat_paid Double(20,2) Not Null Default 0," +
      "  total_paid Double(20,2) Not Null Default 0," +
      "  paid_12m Double(20,2) Not Null Default 0," +
      "  first_visit DateTime Null," +
      "  last_visit DateTime Null," +
      "  segment Varchar(16) Not Null," +
      "  Key crm_client_stats_seg (segment)," +
      "  Key crm_client_stats_paid (total_paid)" +
      ") Default Charset = utf8");
  }

  public static void initTables(Connection conn) throws Exception {
    if (ready) return;
    createStatsTable(conn, "Crm_Client_Stats");
    exec(conn,
      "Create Table If Not Exists Crm_Client_Stats_Info (" +
      "  id Int Not Null Primary Key," +
      "  calc_date DateTime Not Null," +
      "  vip_threshold Double(20,2) Not Null Default 0," +
      "  clients Int Not Null Default 0" +
      ") Default Charset = utf8");
    ready = true;
  }

  /** Дата последнего пересчёта и порог VIP: [Date, Double] или null, если ещё не считали */
  public static Object[] info(Connection conn) throws Exception {
    initTables(conn);
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      ps = conn.prepareStatement("Select calc_date, vip_threshold From Crm_Client_Stats_Info Where id = 1");
      rs = ps.executeQuery();
      return rs.next() ? new Object[]{rs.getTimestamp(1), rs.getDouble(2)} : null;
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
  }

  // ---------- Пересчёт ----------

  private static class Row {
    int ambVisits, statVisits, visits12m;
    double ambPaid, statPaid, paid12m;
    Timestamp first, last;

    double total() { return ambPaid + statPaid; }

    void visit(Timestamp f, Timestamp l) {
      if (f != null && (first == null || f.before(first))) first = f;
      if (l != null && (last == null || l.after(last))) last = l;
    }
  }

  /** Пересчитывает итоги и типы всех клиентов. Новая таблица заполняется рядом и подменяет старую одним RENAME. */
  public static synchronized int refresh() throws Exception {
    Connection conn = null;
    try {
      conn = DB.getConnection();
      initTables(conn);
      Map<Integer, Row> rows = new HashMap<>();
      // визиты
      collectVisits(conn, rows, "Select client_id, Count(*), Sum(Reg_Date >= Now() - Interval 12 Month), Min(Reg_Date), Max(Reg_Date) " +
        " From Amb_Patients Where client_id Is Not Null Group By client_id", true);
      collectVisits(conn, rows, "Select client_id, Count(*), Sum(Date_Begin >= Now() - Interval 12 Month), Min(Date_Begin), Max(Date_Begin) " +
        " From Patients Where client_id Is Not Null Group By client_id", false);
      // оплаты за вычетом возвратов
      collectPaid(conn, rows, "Select a.client_id, " + sumPay("p") + ", Sum(If(p.crOn >= Now() - Interval 12 Month, " + amount("p") + ", 0)) " +
        " From Amb_Patient_Pays p Join Amb_Patients a On a.id = p.patient " +
        " Where a.client_id Is Not Null And IfNull(p.payType, '') != 'discount' Group By a.client_id", true);
      collectPaid(conn, rows, "Select a.client_id, " + sumPay("p") + ", Sum(If(p.crOn >= Now() - Interval 12 Month, " + amount("p") + ", 0)) " +
        " From patient_pays p Join Patients a On a.id = p.patient_id " +
        " Where a.client_id Is Not Null And IfNull(p.payType, '') != 'discount' Group By a.client_id", false);

      // порог VIP: сумма оплат клиента на границе верхних VIP_TOP_PERCENT%
      List<Double> totals = new ArrayList<>();
      for (Row r : rows.values()) if (r.total() > 0) totals.add(r.total());
      Collections.sort(totals, Collections.<Double>reverseOrder());
      double vip = totals.isEmpty() ? Double.MAX_VALUE : totals.get(Math.max(0, (int) Math.ceil(totals.size() * VIP_TOP_PERCENT / 100.0) - 1));

      long now = System.currentTimeMillis();
      long year = 365L * 24 * 3600 * 1000;
      long newFrom = now - NEW_DAYS * 24L * 3600 * 1000;

      exec(conn, "Drop Table If Exists Crm_Client_Stats_New");
      createStatsTable(conn, "Crm_Client_Stats_New");
      StringBuilder sql = new StringBuilder();
      int n = 0, inBatch = 0;
      for (Map.Entry<Integer, Row> e : rows.entrySet()) {
        Row r = e.getValue();
        String seg;
        if (r.total() > 0 && r.total() >= vip) seg = VIP;
        else if (r.visits12m >= REGULAR_VISITS_12M) seg = REGULAR;
        else if (r.first != null && r.first.getTime() >= newFrom) seg = NEW;
        else if (r.last != null && r.last.getTime() >= now - year) seg = USUAL;
        else if (r.last != null) seg = SLEEP;
        else seg = NONE;
        sql.append(inBatch == 0 ? "" : ",").append("(")
          .append(e.getKey()).append(",").append(r.ambVisits).append(",").append(r.statVisits).append(",").append(r.visits12m).append(",")
          .append(num(r.ambPaid)).append(",").append(num(r.statPaid)).append(",").append(num(r.total())).append(",").append(num(r.paid12m)).append(",")
          .append(date(r.first)).append(",").append(date(r.last)).append(",'").append(seg).append("')");
        n++;
        if (++inBatch == 500) {
          insert(conn, sql);
          sql.setLength(0);
          inBatch = 0;
        }
      }
      if (inBatch > 0) insert(conn, sql);
      exec(conn, "Drop Table If Exists Crm_Client_Stats_Old");
      exec(conn, "Rename Table Crm_Client_Stats To Crm_Client_Stats_Old, Crm_Client_Stats_New To Crm_Client_Stats");
      exec(conn, "Drop Table If Exists Crm_Client_Stats_Old");
      PreparedStatement ps = conn.prepareStatement(
        "Replace Into Crm_Client_Stats_Info (id, calc_date, vip_threshold, clients) Values (1, Now(), ?, ?)");
      ps.setDouble(1, vip == Double.MAX_VALUE ? 0 : vip);
      ps.setInt(2, n);
      ps.executeUpdate();
      DB.done(ps);
      return n;
    } finally {
      DB.done(conn);
    }
  }

  private static String amount(String a) {
    return "(IfNull(" + a + ".cash, 0) + IfNull(" + a + ".card, 0) + IfNull(" + a + ".transfer, 0) + IfNull(" + a + ".online, 0))";
  }

  private static String sumPay(String a) {
    return "Sum" + amount(a);
  }

  private static void collectVisits(Connection conn, Map<Integer, Row> rows, String sql, boolean amb) throws Exception {
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      ps = conn.prepareStatement(sql);
      rs = ps.executeQuery();
      while (rs.next()) {
        Row r = row(rows, rs.getInt(1));
        if (amb) r.ambVisits = rs.getInt(2); else r.statVisits = rs.getInt(2);
        r.visits12m += rs.getInt(3);
        r.visit(rs.getTimestamp(4), rs.getTimestamp(5));
      }
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
  }

  private static void collectPaid(Connection conn, Map<Integer, Row> rows, String sql, boolean amb) throws Exception {
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      ps = conn.prepareStatement(sql);
      rs = ps.executeQuery();
      while (rs.next()) {
        Row r = row(rows, rs.getInt(1));
        if (amb) r.ambPaid = rs.getDouble(2); else r.statPaid = rs.getDouble(2);
        r.paid12m += rs.getDouble(3);
      }
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
  }

  private static Row row(Map<Integer, Row> rows, int id) {
    Row r = rows.get(id);
    if (r == null) {
      r = new Row();
      rows.put(id, r);
    }
    return r;
  }

  private static void insert(Connection conn, StringBuilder values) throws Exception {
    exec(conn, "Insert Into Crm_Client_Stats_New (client_id, amb_visits, stat_visits, visits_12m, amb_paid, stat_paid, total_paid, paid_12m, " +
      "first_visit, last_visit, segment) Values " + values);
  }

  private static String num(double d) {
    return String.format(Locale.US, "%.2f", d);
  }

  private static String date(Timestamp t) {
    return t == null ? "Null" : "'" + new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(t) + "'";
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

  // ---------- Форматирование ----------

  private static final DecimalFormat MONEY;
  static {
    DecimalFormatSymbols s = new DecimalFormatSymbols(Locale.US);
    s.setGroupingSeparator(' ');
    MONEY = new DecimalFormat("#,##0", s);
  }

  /** 1234567.8 -> "1 234 568" */
  public static String money(double d) {
    synchronized (MONEY) {
      return MONEY.format(d);
    }
  }

  /** Короткая сумма для плиток: 1 250 000 -> "1,25 млн" */
  public static String moneyShort(double d) {
    double a = Math.abs(d);
    if (a >= 1e9) return String.format(Locale.US, "%.2f млрд", d / 1e9).replace('.', ',');
    if (a >= 1e6) return String.format(Locale.US, "%.2f млн", d / 1e6).replace('.', ',');
    if (a >= 1e4) return String.format(Locale.US, "%.0f тыс", d / 1e3);
    return money(d);
  }
}
