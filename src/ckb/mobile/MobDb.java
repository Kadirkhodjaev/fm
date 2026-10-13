package ckb.mobile;

import ckb.utils.DB;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Date;

/** Короткие JDBC-помощники для API приложения: строки как Map, одно значение, обновление. */
public class MobDb {

  /** SQL: последние 9 цифр телефона (пробелы, +, -, скобки убираются) - то же правило, что в боте пациента */
  public static String tel9(String col) {
    return "Right(Replace(Replace(Replace(Replace(Replace(" + col + ", ' ', ''), '+', ''), '-', ''), '(', ''), ')', ''), 9)";
  }

  /** Последние 9 цифр номера или null, если цифр меньше 9 */
  public static String tail9(String s) {
    String d = s == null ? "" : s.replaceAll("\\D", "");
    return d.length() >= 9 ? d.substring(d.length() - 9) : null;
  }

  public static List<Map<String, Object>> rows(Connection conn, String sql, Object... params) throws SQLException {
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      ps = prepare(conn, sql, params);
      rs = ps.executeQuery();
      ResultSetMetaData md = rs.getMetaData();
      List<Map<String, Object>> list = new ArrayList<>();
      while (rs.next()) {
        Map<String, Object> m = new LinkedHashMap<>();
        for (int i = 1; i <= md.getColumnCount(); i++) m.put(md.getColumnLabel(i), rs.getObject(i));
        list.add(m);
      }
      return list;
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
  }

  public static Map<String, Object> row(Connection conn, String sql, Object... params) throws SQLException {
    List<Map<String, Object>> l = rows(conn, sql, params);
    return l.isEmpty() ? null : l.get(0);
  }

  public static Object value(Connection conn, String sql, Object... params) throws SQLException {
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      ps = prepare(conn, sql, params);
      rs = ps.executeQuery();
      return rs.next() ? rs.getObject(1) : null;
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
  }

  public static int count(Connection conn, String sql, Object... params) throws SQLException {
    Object v = value(conn, sql, params);
    return v == null ? 0 : ((Number) v).intValue();
  }

  public static int exec(Connection conn, String sql, Object... params) throws SQLException {
    PreparedStatement ps = null;
    try {
      ps = prepare(conn, sql, params);
      return ps.executeUpdate();
    } finally {
      DB.done(ps);
    }
  }

  /** Insert с автоинкрементом: возвращает новый id */
  public static int insert(Connection conn, String sql, Object... params) throws SQLException {
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
      bind(ps, params);
      ps.executeUpdate();
      rs = ps.getGeneratedKeys();
      return rs.next() ? rs.getInt(1) : 0;
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
  }

  private static PreparedStatement prepare(Connection conn, String sql, Object... params) throws SQLException {
    PreparedStatement ps = conn.prepareStatement(sql);
    bind(ps, params);
    return ps;
  }

  private static void bind(PreparedStatement ps, Object... params) throws SQLException {
    for (int i = 0; i < params.length; i++) {
      Object p = params[i];
      if (p == null) ps.setNull(i + 1, Types.VARCHAR);
      else if (p instanceof Date && !(p instanceof java.sql.Date) && !(p instanceof Timestamp)) ps.setTimestamp(i + 1, new Timestamp(((Date) p).getTime()));
      else ps.setObject(i + 1, p);
    }
  }

  /** "?, ?, ?" для In (...) */
  public static String marks(int n) {
    StringBuilder b = new StringBuilder();
    for (int i = 0; i < n; i++) b.append(i == 0 ? "?" : ", ?");
    return b.length() == 0 ? "Null" : b.toString();
  }

  // ---------- значения из Map ----------

  public static String s(Map<String, Object> m, String k) {
    Object v = m.get(k);
    return v == null ? "" : v.toString().trim();
  }

  public static int i(Map<String, Object> m, String k) {
    Object v = m.get(k);
    if (v == null) return 0;
    if (v instanceof Number) return ((Number) v).intValue();
    if (v instanceof Boolean) return (Boolean) v ? 1 : 0;
    if (v instanceof byte[]) return ((byte[]) v).length > 0 && ((byte[]) v)[0] != 0 ? 1 : 0;
    try {
      return Integer.parseInt(v.toString().trim());
    } catch (Exception e) {
      return 0;
    }
  }

  /** bit(1), 'Y', 1 - всё считается "да" */
  public static boolean b(Map<String, Object> m, String k) {
    Object v = m.get(k);
    if (v == null) return false;
    if (v instanceof String) return "Y".equals(v) || "1".equals(v);
    return i(m, k) != 0;
  }

  public static Date d(Map<String, Object> m, String k) {
    Object v = m.get(k);
    return v instanceof Date ? (Date) v : null;
  }

  // ---------- даты ----------

  public static String iso(Date d) {
    return d == null ? null : new SimpleDateFormat("yyyy-MM-dd").format(d);
  }

  public static String isoTime(Date d) {
    return d == null ? null : new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss").format(d);
  }

  public static Date parseIso(String s) {
    try {
      return s == null || s.isEmpty() ? null : new SimpleDateFormat("yyyy-MM-dd").parse(s);
    } catch (Exception e) {
      return null;
    }
  }

  /** Полночь дня */
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
    c.setTime(d);
    c.add(Calendar.DATE, n);
    return c.getTime();
  }

  /** Целых дней от a до b (по календарю) */
  public static int daysBetween(Date a, Date b) {
    return (int) Math.round((day(b).getTime() - day(a).getTime()) / (24.0 * 3600 * 1000));
  }

  /** yyyymmdd */
  public static int dayNum(Date d) {
    return Integer.parseInt(new SimpleDateFormat("yyyyMMdd").format(d));
  }
}
