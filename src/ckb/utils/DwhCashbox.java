package ckb.utils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Calendar;

/**
 * Витрина кассы Dwh_Cashboxs (её читает модуль Руководство): поступления по дням.
 *
 *   oper_day - день оплаты (yyyy-MM-dd, строкой)
 *   amb_stat - AMB (Amb_Patient_Pays) или STAT (patient_pays); возвраты (payType = 'ret') - AMB_ / STAT_
 *   pay_type - cash / card / online / transfer
 *   summ     - сумма за день, возвраты с минусом (так они хранятся в оплатах); нулевые строки не пишутся
 *
 * Ночью (MedScheduler) пересобираются последние RECENT_DAYS дней, чтобы попали и поздние исправления оплат;
 * если витрина пустая - собирается целиком.
 */
public class DwhCashbox {

  public static final int RECENT_DAYS = 45;

  public static synchronized int rebuildRecent() throws Exception {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      conn = DB.getConnection();
      ps = conn.prepareStatement("Select Count(*) From Dwh_Cashboxs");
      rs = ps.executeQuery();
      boolean empty = rs.next() && rs.getLong(1) == 0;
      DB.done(rs);
      DB.done(ps);
      rs = null;
      ps = null;
      Calendar c = Calendar.getInstance();
      c.add(Calendar.DATE, -RECENT_DAYS);
      return rebuild(conn, "Dwh_Cashboxs", empty ? "2000-01-01" : new SimpleDateFormat("yyyy-MM-dd").format(c.getTime()));
    } finally {
      DB.done(conn, ps, rs);
    }
  }

  /** Пересобирает витрину table начиная с дня fromDay (yyyy-MM-dd). Возвращает число записанных строк. */
  static int rebuild(Connection conn, String table, String fromDay) throws Exception {
    StringBuilder sql = new StringBuilder();
    String[][] sources = {{"AMB", "Amb_Patient_Pays"}, {"STAT", "patient_pays"}};
    String[] methods = {"cash", "card", "online", "transfer"};
    for (String[] src : sources) {
      for (String m : methods) {
        if (sql.length() > 0) sql.append(" Union All ");
        sql.append("Select Date_Format(p.crOn, '%Y-%m-%d') d, Concat('").append(src[0]).append("', If(p.payType = 'ret', '_', '')) st, '")
          .append(m).append("' pt, Sum(IfNull(p.").append(m).append(", 0)) s")
          .append(" From ").append(src[1]).append(" p")
          .append(" Where p.crOn >= '").append(fromDay).append("' And IfNull(p.payType, '') != 'discount'")
          .append(" Group By Date_Format(p.crOn, '%Y-%m-%d'), Concat('").append(src[0]).append("', If(p.payType = 'ret', '_', ''))");
      }
    }
    boolean auto = conn.getAutoCommit();
    PreparedStatement ps = null;
    try {
      conn.setAutoCommit(false);
      ps = conn.prepareStatement("Delete From " + table + " Where oper_day >= ?");
      ps.setString(1, fromDay);
      ps.executeUpdate();
      DB.done(ps);
      ps = conn.prepareStatement(
        "Insert Into " + table + " (oper_day, amb_stat, pay_type, summ) " +
        "Select x.d, x.st, x.pt, Cast(Round(x.s, 2) As Decimal(20,2)) From (" + sql + ") x Where Round(x.s, 2) <> 0 Order By x.d, x.st, x.pt");
      int n = ps.executeUpdate();
      conn.commit();
      return n;
    } catch (Exception e) {
      conn.rollback();
      throw e;
    } finally {
      DB.done(ps);
      conn.setAutoCommit(auto);
    }
  }
}
