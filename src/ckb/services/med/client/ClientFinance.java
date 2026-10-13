package ckb.services.med.client;

import ckb.utils.DB;
import ckb.utils.Util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.*;

/** Финансовый анализ одного клиента для карточки клиента. Считается сразу, по всем визитам клиента. */
public class ClientFinance {

  private static final String[] MONTHS = {"янв", "фев", "мар", "апр", "май", "июн", "июл", "авг", "сен", "окт", "ноя", "дек"};

  public static Map<String, Object> analyze(int clientId) throws Exception {
    Map<String, Object> m = new HashMap<>();
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      conn = DB.getConnection();
      ClientStats.initTables(conn);
      String amt = "(IfNull(p.cash, 0) + IfNull(p.card, 0) + IfNull(p.transfer, 0) + IfNull(p.online, 0))";
      String ambPays = " From Amb_Patient_Pays p Join Amb_Patients a On a.id = p.patient Where a.client_id = ? And IfNull(p.payType, '') != 'discount'";
      String statPays = " From patient_pays p Join Patients a On a.id = p.patient_id Where a.client_id = ? And IfNull(p.payType, '') != 'discount'";

      // ---------- итоги по способам оплаты, возвраты ----------
      double ambPaid = 0, statPaid = 0, returns = 0, cash = 0, card = 0, transfer = 0, online = 0, paid12 = 0, paidPrev12 = 0;
      for (int k = 0; k < 2; k++) {
        ps = conn.prepareStatement(
          "Select Sum" + amt + ", Sum(If(" + amt + " < 0, " + amt + ", 0)), Sum(IfNull(p.cash, 0)), Sum(IfNull(p.card, 0)), " +
          "       Sum(IfNull(p.transfer, 0)), Sum(IfNull(p.online, 0)), " +
          "       Sum(If(p.crOn >= Now() - Interval 12 Month, " + amt + ", 0)), " +
          "       Sum(If(p.crOn < Now() - Interval 12 Month And p.crOn >= Now() - Interval 24 Month, " + amt + ", 0)) " +
          (k == 0 ? ambPays : statPays));
        ps.setInt(1, clientId);
        rs = ps.executeQuery();
        if (rs.next()) {
          if (k == 0) ambPaid = rs.getDouble(1); else statPaid = rs.getDouble(1);
          returns += rs.getDouble(2);
          cash += rs.getDouble(3);
          card += rs.getDouble(4);
          transfer += rs.getDouble(5);
          online += rs.getDouble(6);
          paid12 += rs.getDouble(7);
          paidPrev12 += rs.getDouble(8);
        }
        DB.done(rs);
        DB.done(ps);
      }
      double total = ambPaid + statPaid;

      // скидки кассы
      double discounts = 0;
      ps = conn.prepareStatement(
        "Select IfNull(Sum(d.summ), 0) From Cash_Discounts d " +
        " Where (d.ambStat = 'AMB' And d.patient In (Select a.id From Amb_Patients a Where a.client_id = ?)) " +
        "    Or (d.ambStat = 'STAT' And d.patient In (Select a.id From Patients a Where a.client_id = ?))");
      ps.setInt(1, clientId);
      ps.setInt(2, clientId);
      rs = ps.executeQuery();
      if (rs.next()) discounts = rs.getDouble(1);
      DB.done(rs);
      DB.done(ps);

      // ---------- визиты ----------
      List<Map<String, Object>> visits = new ArrayList<>();
      ps = conn.prepareStatement(
        "Select a.id, a.Reg_Date, a.state, (Select Sum" + amt + " From Amb_Patient_Pays p Where p.patient = a.id And IfNull(p.payType, '') != 'discount') paid, " +
        "       (Select Count(*) From Amb_Patient_Services s Where s.patient = a.id And s.state In ('PAID', 'DONE')) services " +
        "  From Amb_Patients a Where a.client_id = ?");
      ps.setInt(1, clientId);
      rs = ps.executeQuery();
      while (rs.next()) {
        Map<String, Object> v = new HashMap<>();
        v.put("id", rs.getInt("id"));
        v.put("type", "AMB");
        v.put("date", rs.getTimestamp("Reg_Date"));
        v.put("dateStr", Util.dateToString(rs.getTimestamp("Reg_Date")));
        v.put("info", rs.getInt("services") + " усл.");
        v.put("state", ambState(rs.getString("state")));
        v.put("paid", ClientStats.money(rs.getDouble("paid")));
        visits.add(v);
      }
      DB.done(rs);
      DB.done(ps);
      ps = conn.prepareStatement(
        "Select a.id, a.Date_Begin, a.Date_End, a.state, d.name dept_name, (Select Sum" + amt + " From patient_pays p Where p.patient_id = a.id And IfNull(p.payType, '') != 'discount') paid " +
        "  From Patients a Left Join Depts d On d.id = a.Dept_Id Where a.client_id = ?");
      ps.setInt(1, clientId);
      rs = ps.executeQuery();
      while (rs.next()) {
        Map<String, Object> v = new HashMap<>();
        v.put("id", rs.getInt("id"));
        v.put("type", "STAT");
        v.put("date", rs.getTimestamp("Date_Begin"));
        v.put("dateStr", Util.dateToString(rs.getTimestamp("Date_Begin")) +
          (rs.getTimestamp("Date_End") != null ? " – " + Util.dateToString(rs.getTimestamp("Date_End")) : ""));
        v.put("info", Util.nvl(rs.getString("dept_name")));
        v.put("state", statState(rs.getString("state")));
        v.put("paid", ClientStats.money(rs.getDouble("paid")));
        visits.add(v);
      }
      DB.done(rs);
      DB.done(ps);
      Collections.sort(visits, new Comparator<Map<String, Object>>() {
        @Override
        public int compare(Map<String, Object> a, Map<String, Object> b) {
          Timestamp x = (Timestamp) a.get("date"), y = (Timestamp) b.get("date");
          if (x == null) return 1;
          if (y == null) return -1;
          return y.compareTo(x);
        }
      });
      int visitCount = visits.size();
      Timestamp first = null, last = null;
      for (Map<String, Object> v : visits) {
        Timestamp t = (Timestamp) v.get("date");
        if (t == null) continue;
        if (first == null || t.before(first)) first = t;
        if (last == null || t.after(last)) last = t;
      }

      // ---------- оплаты по месяцам за 12 месяцев ----------
      Map<String, Double> byMonth = new LinkedHashMap<>();
      Calendar c = Calendar.getInstance();
      c.set(Calendar.DAY_OF_MONTH, 1);
      c.add(Calendar.MONTH, -11);
      List<String[]> monthKeys = new ArrayList<>();
      for (int i = 0; i < 12; i++) {
        String key = String.format("%04d-%02d", c.get(Calendar.YEAR), c.get(Calendar.MONTH) + 1);
        byMonth.put(key, 0D);
        monthKeys.add(new String[]{key, MONTHS[c.get(Calendar.MONTH)] + (c.get(Calendar.MONTH) == 0 || i == 0 ? " " + (c.get(Calendar.YEAR) % 100) : "")});
        c.add(Calendar.MONTH, 1);
      }
      for (int k = 0; k < 2; k++) {
        ps = conn.prepareStatement("Select Date_Format(p.crOn, '%Y-%m') m, Sum" + amt + (k == 0 ? ambPays : statPays) +
          " And p.crOn >= ? Group By Date_Format(p.crOn, '%Y-%m')");
        ps.setInt(1, clientId);
        ps.setString(2, monthKeys.get(0)[0] + "-01");
        rs = ps.executeQuery();
        while (rs.next()) {
          if (byMonth.containsKey(rs.getString(1))) byMonth.put(rs.getString(1), byMonth.get(rs.getString(1)) + rs.getDouble(2));
        }
        DB.done(rs);
        DB.done(ps);
      }
      double maxMonth = 0;
      for (Double d : byMonth.values()) maxMonth = Math.max(maxMonth, d);
      List<Map<String, Object>> months = new ArrayList<>();
      for (String[] k : monthKeys) {
        double d = byMonth.get(k[0]);
        Map<String, Object> mm = new HashMap<>();
        mm.put("label", k[1]);
        mm.put("value", ClientStats.money(d));
        mm.put("pct", maxMonth > 0 ? Math.max(d > 0 ? 3 : 0, (int) Math.round(d * 100 / maxMonth)) : 0);
        months.add(mm);
      }

      // ---------- направления амбулатории (стоимость оказанных услуг) ----------
      List<Map<String, Object>> groups = new ArrayList<>();
      ps = conn.prepareStatement(
        "Select IfNull(g.name, '—') g, Count(*) cnt, Sum(s.price) summ " +
        "  From Amb_Patient_Services s " +
        "  Join Amb_Patients a On a.id = s.patient " +
        "  Left Join Amb_Services v On v.id = s.service_Id " +
        "  Left Join amb_groups g On g.id = v.group_Id " +
        " Where a.client_id = ? And s.state In ('PAID', 'DONE') " +
        " Group By g.name Order By summ Desc");
      ps.setInt(1, clientId);
      rs = ps.executeQuery();
      double groupTotal = 0;
      while (rs.next()) {
        Map<String, Object> g = new HashMap<>();
        g.put("name", rs.getString("g"));
        g.put("count", rs.getInt("cnt"));
        g.put("sumRaw", rs.getDouble("summ"));
        g.put("sum", ClientStats.money(rs.getDouble("summ")));
        groupTotal += rs.getDouble("summ");
        groups.add(g);
      }
      DB.done(rs);
      DB.done(ps);
      for (Map<String, Object> g : groups)
        g.put("pct", groupTotal > 0 ? (int) Math.round((Double) g.get("sumRaw") * 100 / groupTotal) : 0);
      if (groups.size() > 8) groups = groups.subList(0, 8);

      // топ услуг
      List<Map<String, Object>> services = new ArrayList<>();
      ps = conn.prepareStatement(
        "Select v.name, Count(*) cnt, Sum(s.price) summ From Amb_Patient_Services s " +
        "  Join Amb_Patients a On a.id = s.patient Join Amb_Services v On v.id = s.service_Id " +
        " Where a.client_id = ? And s.state In ('PAID', 'DONE') Group By v.id, v.name Order By cnt Desc, summ Desc Limit 6");
      ps.setInt(1, clientId);
      rs = ps.executeQuery();
      while (rs.next()) {
        Map<String, Object> s = new HashMap<>();
        s.put("name", rs.getString(1));
        s.put("count", rs.getInt(2));
        s.put("sum", ClientStats.money(rs.getDouble(3)));
        services.add(s);
      }
      DB.done(rs);
      DB.done(ps);

      // ---------- тип клиента и место среди всех ----------
      String segment = ClientStats.NONE;
      ps = conn.prepareStatement("Select segment From Crm_Client_Stats Where client_id = ?");
      ps.setInt(1, clientId);
      rs = ps.executeQuery();
      boolean hasStats = rs.next();
      if (hasStats) segment = rs.getString(1);
      DB.done(rs);
      DB.done(ps);
      if (total > 0) {
        ps = conn.prepareStatement("Select Sum(total_paid > ?), Sum(total_paid > 0) From Crm_Client_Stats");
        ps.setDouble(1, total);
        rs = ps.executeQuery();
        if (rs.next() && rs.getInt(2) > 0) {
          int place = rs.getInt(1) + 1;
          m.put("place", place);
          m.put("placeOf", rs.getInt(2));
          m.put("topPct", Math.max(1, (int) Math.ceil(place * 100.0 / rs.getInt(2))));
        }
        DB.done(rs);
        DB.done(ps);
      }

      m.put("segment", segment);
      m.put("segmentName", ClientStats.segmentName(segment));
      m.put("segmentHint", ClientStats.SEGMENTS.containsKey(segment) ? ClientStats.SEGMENTS.get(segment)[1] : "");
      m.put("total", ClientStats.money(total));
      m.put("totalShort", ClientStats.moneyShort(total));
      m.put("ambPaid", ClientStats.money(ambPaid));
      m.put("statPaid", ClientStats.money(statPaid));
      m.put("ambPct", total > 0 ? (int) Math.round(ambPaid * 100 / total) : 0);
      m.put("returns", ClientStats.money(Math.abs(returns)));
      m.put("hasReturns", returns < 0);
      m.put("discounts", ClientStats.money(discounts));
      m.put("hasDiscounts", discounts > 0);
      m.put("paid12", ClientStats.moneyShort(paid12));
      m.put("trend", paidPrev12 > 0 ? (int) Math.round((paid12 - paidPrev12) * 100 / paidPrev12) : null);
      m.put("visitCount", visitCount);
      m.put("ambCount", count(visits, "AMB"));
      m.put("statCount", count(visits, "STAT"));
      m.put("avgCheck", ClientStats.moneyShort(visitCount > 0 ? total / visitCount : 0));
      m.put("first", Util.dateToString(first));
      m.put("last", Util.dateToString(last));
      m.put("daysSinceLast", last == null ? null : (int) ((System.currentTimeMillis() - last.getTime()) / (24L * 3600 * 1000)));
      m.put("avgInterval", visitCount > 1 && first != null && last != null ? (int) ((last.getTime() - first.getTime()) / (24L * 3600 * 1000) / (visitCount - 1)) : null);
      double methodsTotal = Math.abs(cash) + Math.abs(card) + Math.abs(transfer) + Math.abs(online);
      List<Map<String, Object>> methods = new ArrayList<>();
      addMethod(methods, "Наличные", cash, methodsTotal);
      addMethod(methods, "Карта", card, methodsTotal);
      addMethod(methods, "Перечисление", transfer, methodsTotal);
      addMethod(methods, "Онлайн", online, methodsTotal);
      m.put("methods", methods);
      m.put("months", months);
      m.put("hasMonths", maxMonth > 0);
      m.put("groups", groups);
      m.put("services", services);
      m.put("visits", visits.size() > 100 ? visits.subList(0, 100) : visits);
      return m;
    } finally {
      DB.done(conn, ps, rs);
    }
  }

  private static int count(List<Map<String, Object>> visits, String type) {
    int n = 0;
    for (Map<String, Object> v : visits) if (type.equals(v.get("type"))) n++;
    return n;
  }

  private static void addMethod(List<Map<String, Object>> list, String name, double sum, double total) {
    if (Math.abs(sum) < 0.01) return;
    Map<String, Object> m = new HashMap<>();
    m.put("name", name);
    m.put("sum", ClientStats.money(sum));
    m.put("pct", total > 0 ? (int) Math.round(Math.abs(sum) * 100 / total) : 0);
    list.add(m);
  }

  private static String ambState(String s) {
    if ("PRN".equals(s)) return "Регистрация";
    if ("CASH".equals(s)) return "Ожидание оплаты";
    if ("WORK".equals(s)) return "Оказание услуг";
    if ("DONE".equals(s)) return "Услуги оказаны";
    if ("ARCH".equals(s)) return "Закрыта";
    return Util.nvl(s);
  }

  private static String statState(String s) {
    if ("LV".equals(s)) return "На лечении";
    if ("ZGV".equals(s)) return "Выписан";
    if ("ARCH".equals(s)) return "Архив";
    if ("PRD".equals(s)) return "Приёмное";
    return Util.nvl(s);
  }
}
