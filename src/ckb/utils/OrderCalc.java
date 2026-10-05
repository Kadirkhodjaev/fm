package ckb.utils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Purchase planning for the pharmacy: what to order from the suppliers.
 *
 * Orders are placed on the order days (system parameter DRUG_ORDER_DAYS, default Mon, Wed, Fri), sent the same day,
 * delivered in the evening and used from the next day. The order has to cover the main departments (DRUG_AUTO_OUT_DIRS)
 * until the evening delivery of the next order day (coverDays).
 *
 * Demand = what the main departments use up (hn_date_rows + hn_date_patient_rows), by department and day.
 * For every drug and main department dep:
 *   d_dep     average use per day during the full days of the period (today not included; new drugs: the days since the first delivery, at least 7)
 *   today_dep used today
 *   threshold_dep = proc of the norm if 0 < proc < norm_dep, otherwise half of norm_dep
 *   forecast_dep  = stock_dep - max(0, d_dep - today_dep) - d_dep * coverDays   (stock when the next delivery is in use)
 *   issue_dep = max(0, norm_dep + max(0, d_dep - today_dep) + d_dep * coverDays - stock_dep) if forecast_dep <= threshold_dep, otherwise 0
 * For the drug:
 *   sigma  day-to-day variability of the daily use of all main departments (full days of the period)
 *   SS     safety stock = z * sigma * sqrt(coverDays)
 *   transfers: the surplus of a department (stock - use until the delivery - threshold) covers the needs of the others first
 *   target = sum(issue_dep) - transferred + SS, or 0 when the pharmacy does not have to issue anything
 *   stock  usable stock of the pharmacy = what can be used up before the expiry date (FEFO), unconfirmed acts are counted as stock
 *   order  = target - stock, rounded up to whole blocks, limited by the shelf life of the drug
 * The class has a pure part (compute) that is covered by a self test and a JDBC part (run).
 */
public class OrderCalc {

  public static final int RECENT = 14;  // days for the trend (the last days against the whole period)

  public static class Params {
    public int period = 28;        // analysis period, full days
    public int cover = 0;          // days until the next delivery is in use; 0 = from the order days
    public double service = 0.90;  // service level
    public boolean abc = false;    // A drugs get a higher, C drugs a lower service level
    public boolean drafts = true;  // unconfirmed acts are goods that are already here
    public double shelfCap = 0.6;  // do not order more than this share of the typical shelf life of demand
    public String dirs = "25, 28, 29"; // main departments that have norms
    public String orderDays = "1,3,5"; // order days, 1 = Monday ... 7 = Sunday
    // filled by run()
    public int coverDays;
    public int[] dirIds = new int[0];
    public String[] dirNames = new String[0];
  }

  public static class Input {
    public int id;
    public String name = "", measure = "", partner = "";
    public double block = 1;
    public double[] daily = new double[0];   // used by the main departments per day, index 0 = today, 1 = yesterday ...
    public int effDays = 7;                  // days of history inside the period (>= 7)
    public List<double[]> batches = new ArrayList<double[]>(); // {remain, daysLeft, draft(1/0)} sorted by daysLeft
    // by main department (same order as Params.dirIds)
    public double[] depStock = new double[0], depNorm = new double[0], depRate = new double[0], depToday = new double[0];
    public double proc;                      // threshold of the norm (drug_s_normas.proc), the same for every department
    public double deptAll, deficit;          // stock of the main departments, sum of (norm - stock) over them
    public double lastPrice, lastNds;
    public double shelfDays;                 // typical shelf life of a delivery, days (0 = unknown)
    public boolean hasNorm;
    public double qTotal;                    // used during the period
    public int firstInDays;                  // days since the first delivery (99999 if never)

    public void dirs(int n) {
      depStock = new double[n]; depNorm = new double[n]; depRate = new double[n]; depToday = new double[n];
    }
  }

  public static class Result {
    public Input in;
    public double d, dBase, sigma, ss, rop, target, usable, risk, draftQty, cover, trend;
    public double[] depIssue = new double[0], depToNorm = new double[0], depThreshold = new double[0], depSurplus = new double[0];
    public List<double[]> transfers = new ArrayList<double[]>();  // {from department index, to department index, quantity}
    public double issue, moved, fromPharmacy;                     // to issue to the departments, of it transferred between them, from the pharmacy
    public double used, pharmacy;                                 // used during the period (with today), all the stock of the pharmacy
    public double expired, late, draftAll;                        // risk = expired (already) + late (expires before it is used up); stock of unconfirmed acts
    public double orderUnits, orderBlocks;
    public String status = "ok", abc = "C";  // status: no_stock, urgent, order, expired, stale, excess, ok
    public boolean lowData, capped;
  }

  /** z value of the normal distribution for the nearest supported service level */
  public static double z(double service) {
    double[][] t = {{0.85, 1.04}, {0.90, 1.28}, {0.95, 1.65}, {0.975, 1.96}, {0.98, 2.05}, {0.99, 2.33}};
    double best = t[0][1], bd = 9;
    for (double[] r : t) {
      double dd = Math.abs(r[0] - service);
      if (dd < bd) { bd = dd; best = r[1]; }
    }
    return best;
  }

  /** full days after today until the evening delivery of the next order day is in use (dow: 1 = Monday ... 7 = Sunday) */
  public static int coverDays(int dow, String orderDays) {
    Set<Integer> days = new HashSet<Integer>();
    if (orderDays != null)
      for (String s : orderDays.split(",")) { try { int v = Integer.parseInt(s.trim()); if (v >= 1 && v <= 7) days.add(v); } catch (Exception ignored) { } }
    if (days.isEmpty()) { days.add(1); days.add(3); days.add(5); }
    for (int k = 1; k <= 7; k++)
      if (days.contains((dow - 1 + k) % 7 + 1)) return k;
    return 7;
  }

  /** use per day of every department: the use during the full days of the period (collected in depRate) divided by the days of history */
  public static void rates(Input in, int period) {
    int days = Math.max(1, Math.min(period, in.effDays));
    for (int k = 0; k < in.depRate.length; k++) in.depRate[k] /= days;
  }

  public static Result compute(Input in, Params p, double z) {
    Result r = new Result();
    r.in = in;
    int cover = Math.max(1, p.coverDays);
    int n = in.depStock.length;
    // history: full days only (index 1..), not more than the drug exists
    int full = Math.max(1, Math.min(in.daily.length - 1, in.effDays));
    double tot = 0;
    for (int i = 1; i <= full && i < in.daily.length; i++) tot += in.daily[i];
    r.dBase = tot / full;
    for (int k = 0; k < n; k++) r.d += in.depRate[k];
    // trend: the last 14 days against the whole period
    double recent = 0;
    for (int i = 1; i <= RECENT && i < in.daily.length; i++) recent += in.daily[i];
    r.trend = (full > RECENT && r.dBase > 0) ? (recent / RECENT - r.dBase) / r.dBase : 0;
    for (double q : in.daily) r.used += q;
    r.lowData = in.firstInDays < 14 || in.effDays < 14;
    // variability of the daily use; with few days assume Poisson-like demand
    if (full >= 7) {
      double s2 = 0;
      for (int i = 1; i <= full; i++) { double x = (i < in.daily.length ? in.daily[i] : 0) - r.dBase; s2 += x * x; }
      r.sigma = Math.sqrt(s2 / (full - 1));
    } else {
      r.sigma = Math.sqrt(Math.max(0, r.dBase));
    }
    r.ss = z * r.sigma * Math.sqrt(cover);

    // what every main department has to get: up to the norm plus the use until the next delivery
    r.depIssue = new double[n];
    r.depToNorm = new double[n];
    r.depThreshold = new double[n];
    r.depSurplus = new double[n];
    double issue = 0;
    for (int k = 0; k < n; k++) {
      double rate = in.depRate[k], norm = in.depNorm[k];
      double use = Math.max(0, rate - in.depToday[k]) + rate * cover;   // until the next delivery is in use
      r.depToNorm[k] = Math.max(0, norm - in.depStock[k]);
      // up to the norm only when the stock falls to the threshold before the next delivery
      r.depThreshold[k] = in.proc > 0 && in.proc < norm ? in.proc : 0.5 * norm;
      if (in.depStock[k] - use <= r.depThreshold[k] + 1e-9)
        r.depIssue[k] = Math.max(0, norm + use - in.depStock[k]);
      // what the department can give away and still be at the threshold when the next delivery is in use
      else
        r.depSurplus[k] = Math.max(0, in.depStock[k] - use - r.depThreshold[k]);
      issue += r.depIssue[k];
    }
    r.issue = issue;
    // the departments transfer their surplus to each other first: the biggest surplus to the biggest need
    double[] needLeft = r.depIssue.clone(), surLeft = r.depSurplus.clone();
    while (true) {
      int to = -1, from = -1;
      for (int k = 0; k < n; k++) {
        if (needLeft[k] > 0.0001 && (to < 0 || needLeft[k] > needLeft[to])) to = k;
        if (surLeft[k] > 0.0001 && (from < 0 || surLeft[k] > surLeft[from])) from = k;
      }
      if (to < 0 || from < 0) break;
      double q = Math.min(needLeft[to], surLeft[from]);
      r.transfers.add(new double[]{from, to, q});
      r.moved += q;
      needLeft[to] -= q;
      surLeft[from] -= q;
    }
    r.fromPharmacy = Math.max(0, issue - r.moved);
    // the safety stock only when the pharmacy has to issue something; otherwise nothing is ordered
    r.target = r.fromPharmacy > 0.0001 ? r.fromPharmacy + r.ss : 0;
    r.rop = r.ss + r.d;

    // usable stock: FEFO, a batch can only be used as long as it is not expired
    double cum = 0;
    for (double[] b : in.batches) {
      boolean draft = b[2] > 0;
      if (draft && !p.drafts) continue;
      double remain = b[0], left = b[1];
      if (draft) r.draftAll += remain;
      if (left <= 0) { r.risk += remain; r.expired += remain; continue; }   // already expired
      double cap = r.d > 0 ? Math.max(0, r.d * left - cum) : remain;
      double use = Math.min(remain, cap);
      r.usable += use;
      if (draft) r.draftQty += use;
      cum += use;
      r.risk += remain - use;
      r.late += remain - use;                                          // expires before it is used up
    }
    // days the whole stock lasts: the pharmacy and the main departments
    double stock = r.usable + in.deptAll;
    r.cover = r.d > 0 ? stock / r.d : (stock > 0 ? 99999 : 0);
    for (double[] b : in.batches) if (b[2] <= 0 || p.drafts) r.pharmacy += b[0];

    double need = r.target - r.usable;
    double block = in.block > 0 ? in.block : 1;
    if (need > 0.0001) {
      double blocks = Math.ceil(need / block - 1e-9);
      if (in.shelfDays > 0 && r.d > 0) {
        double capUnits = r.d * in.shelfDays * p.shelfCap - r.usable;
        double capBlocks = Math.max(1, Math.floor(capUnits / block));
        if (capBlocks < blocks) { blocks = capBlocks; r.capped = true; }
      }
      r.orderBlocks = blocks;
      r.orderUnits = blocks * block;
    }
    if (!in.hasNorm && r.pharmacy + in.deptAll <= 0.0001) r.status = "no_stock";       // no norm and no stock anywhere: the pharmacy decides
    else if (r.fromPharmacy > r.usable + 0.0001) r.status = "urgent";                // the departments need more than the pharmacy has
    else if (r.orderUnits > 0) r.status = "order";
    else if (r.usable <= 0.0001 && in.deptAll <= 0.0001 && r.expired > 0.0001) r.status = "expired";  // only expired stock: to write off
    else if (r.used <= 0.0001 && issue <= 0.0001 && r.usable + in.deptAll > 0.0001) r.status = "stale";  // usable stock without any use during the period
    else r.status = r.cover > Math.max(90, 4 * (cover + 1)) ? "excess" : "ok";
    return r;
  }

  // ------------------------------------------------------------------ JDBC part

  private static String esc(String s) { return s == null ? "" : s; }

  public static List<Result> run(Connection conn, Params p) throws SQLException {
    int period = Math.max(14, Math.min(365, p.period));
    Map<Integer, Input> map = new HashMap<Integer, Input>();
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      // main departments
      List<Integer> ids = new ArrayList<Integer>();
      for (String s : p.dirs.split(",")) { try { int v = Integer.parseInt(s.trim()); if (!ids.contains(v)) ids.add(v); } catch (Exception ignored) { } }
      if (ids.isEmpty()) { ids.add(25); ids.add(28); ids.add(29); }
      StringBuilder sb = new StringBuilder();
      for (Integer v : ids) sb.append(sb.length() == 0 ? "" : ",").append(v);
      String dirsSql = sb.toString();
      final Map<Integer, String> names = new HashMap<Integer, String>();
      ps = conn.prepareStatement("Select id, name From drug_s_directions Where id in (" + dirsSql + ")");
      rs = ps.executeQuery();
      while (rs.next()) names.put(rs.getInt("id"), esc(rs.getString("name")));
      rs.close(); ps.close();
      // ordered by name, as everywhere else in the pharmacy
      Collections.sort(ids, new Comparator<Integer>() {
        public int compare(Integer a, Integer b) { return String.valueOf(names.get(a)).compareTo(String.valueOf(names.get(b))); }
      });
      int nd = ids.size();
      Map<Integer, Integer> pos = new HashMap<Integer, Integer>();
      p.dirIds = new int[nd];
      p.dirNames = new String[nd];
      for (int k = 0; k < nd; k++) {
        p.dirIds[k] = ids.get(k);
        p.dirNames[k] = names.containsKey(ids.get(k)) ? names.get(ids.get(k)) : "" + ids.get(k);
        pos.put(ids.get(k), k);
      }

      // days until the next delivery is in use
      if (p.cover > 0) p.coverDays = p.cover;
      else {
        ps = conn.prepareStatement("Select weekday(curdate()) + 1 dow");
        rs = ps.executeQuery();
        int dow = rs.next() ? rs.getInt("dow") : 1;
        rs.close(); ps.close();
        p.coverDays = coverDays(dow, p.orderDays);
      }

      // drugs
      ps = conn.prepareStatement("Select c.id, c.name, ifnull(c.counter, 1) block, m.name measure From drug_s_names c Left Join drug_s_measures m On m.id = c.measure_id");
      rs = ps.executeQuery();
      while (rs.next()) {
        Input in = new Input();
        in.id = rs.getInt("id");
        in.name = esc(rs.getString("name"));
        in.block = rs.getDouble("block") > 0 ? rs.getDouble("block") : 1;
        in.measure = esc(rs.getString("measure"));
        in.daily = new double[period + 1];
        in.effDays = period;
        in.firstInDays = 99999;
        in.dirs(nd);
        map.put(in.id, in);
      }
      rs.close(); ps.close();

      // first delivery of every drug: the days before it are not a lack of demand
      ps = conn.prepareStatement("Select t.drug_id, datediff(curdate(), min(a.regDate)) days From drug_act_drugs t Join drug_acts a On a.id = t.act_id Where a.state != 'E' Group By t.drug_id");
      rs = ps.executeQuery();
      while (rs.next()) {
        Input in = map.get(rs.getInt("drug_id"));
        if (in == null) continue;
        in.firstInDays = rs.getInt("days");
        in.effDays = Math.max(7, Math.min(period, in.firstInDays));
      }
      rs.close(); ps.close();

      // demand: used up by the main departments (general and patient rows), by department and day
      String from =
        "   From %s c, hn_drugs f, hn_dates d " +
        "  Where d.id = c.doc_id And c.drug_id = f.id And c.rasxod > 0 " +
        "    And d.direction_id in (" + dirsSql + ") " +
        "    And date(d.date) Between date_sub(curdate(), interval " + period + " day) And curdate() " +
        "  Group By f.drug_id, d.direction_id, date(d.date)";
      String sel = " Select f.drug_id, d.direction_id, datediff(curdate(), date(d.date)) dd, Sum(c.rasxod) q ";
      ps = conn.prepareStatement(sel + String.format(from, "hn_date_rows") + " Union All " + sel + String.format(from, "hn_date_patient_rows"));
      rs = ps.executeQuery();
      while (rs.next()) {
        Input in = map.get(rs.getInt("drug_id"));
        Integer k = pos.get(rs.getInt("direction_id"));
        if (in == null || k == null) continue;
        int dd = rs.getInt("dd");
        double q = rs.getDouble("q");
        if (dd < 0 || dd > period) continue;
        in.daily[dd] += q;
        if (dd == 0) in.depToday[k] += q;
        else in.depRate[k] += q;
      }
      rs.close(); ps.close();
      for (Input in : map.values()) rates(in, period);

      // stock by batch (confirmed and unconfirmed acts), earliest expiry first
      ps = conn.prepareStatement(
        " Select t.drug_id, t.counter - t.rasxod remain, datediff(t.endDate, curdate()) days_left, a.state " +
        "   From drug_act_drugs t Join drug_acts a On a.id = t.act_id " +
        "  Where t.counter - t.rasxod > 0 Order By t.drug_id, t.endDate");
      rs = ps.executeQuery();
      while (rs.next()) {
        Input in = map.get(rs.getInt("drug_id"));
        if (in == null) continue;
        double rem = rs.getDouble("remain");
        double dl = rs.getDouble("days_left");
        if (rs.wasNull()) dl = 99999;   // no expiry date
        in.batches.add(new double[]{rem, dl, "E".equals(rs.getString("state")) ? 1 : 0});
      }
      rs.close(); ps.close();

      // the last purchase: price, supplier; typical shelf life of the last deliveries
      ps = conn.prepareStatement(
        " Select t.drug_id, t.countPrice, t.nds, p.name partner, datediff(t.endDate, a.regDate) shelf " +
        "   From drug_act_drugs t Join drug_acts a On a.id = t.act_id " +
        "   Left Join drug_s_contracts k On k.id = a.contract_id Left Join drug_s_partners p On p.id = k.partner_id " +
        "  Where a.state != 'E' Order By t.drug_id, a.regDate Desc, t.id Desc");
      rs = ps.executeQuery();
      int lastDrug = -1, cnt = 0;
      double shelfSum = 0;
      Input cur = null;
      while (rs.next()) {
        int id = rs.getInt("drug_id");
        if (id != lastDrug) {
          if (cur != null && cnt > 0) cur.shelfDays = shelfSum / cnt;
          lastDrug = id; cnt = 0; shelfSum = 0; cur = map.get(id);
          if (cur != null) {
            cur.lastPrice = rs.getDouble("countPrice");
            cur.lastNds = rs.getDouble("nds");
            cur.partner = esc(rs.getString("partner"));
          }
        }
        if (cur != null && cnt < 5) {
          double sh = rs.getDouble("shelf");
          if (!rs.wasNull() && sh > 0) { shelfSum += sh; cnt++; }
        }
      }
      if (cur != null && cnt > 0) cur.shelfDays = shelfSum / cnt;
      rs.close(); ps.close();

      // stock of the main departments
      ps = conn.prepareStatement("Select drug_id, direction_id, Sum(drugCount - rasxod) s From hn_drugs Where drugCount - rasxod > 0 And direction_id in (" + dirsSql + ") Group By drug_id, direction_id");
      rs = ps.executeQuery();
      while (rs.next()) {
        Input in = map.get(rs.getInt("drug_id"));
        Integer k = pos.get(rs.getInt("direction_id"));
        if (in == null || k == null) continue;
        double s = rs.getDouble("s");
        in.deptAll += s;
        in.depStock[k] += s;
      }
      rs.close(); ps.close();

      // norms of the main departments: ALL = the same norm for every department, otherwise by department
      ps = conn.prepareStatement("Select n.drug_id, n.normaType, n.norma, ifnull(n.proc, 0) proc, d.direction_id, d.norma dnorma From drug_s_normas n Left Join drug_s_norma_directions d On d.doc_id = n.id");
      rs = ps.executeQuery();
      Set<String> seen = new HashSet<String>();
      while (rs.next()) {
        Input in = map.get(rs.getInt("drug_id"));
        if (in == null) continue;
        in.hasNorm = true;
        in.proc = rs.getDouble("proc");
        if ("ALL".equals(rs.getString("normaType"))) {
          if (!seen.add(in.id + ":ALL")) continue;
          for (int k = 0; k < nd; k++) in.depNorm[k] = rs.getDouble("norma");
        } else {
          Integer k = pos.get(rs.getInt("direction_id"));
          if (rs.wasNull() || k == null) continue;
          in.depNorm[k] = rs.getDouble("dnorma");
        }
      }
      rs.close(); ps.close();
      for (Input in : map.values())
        for (int k = 0; k < nd; k++) in.deficit += Math.max(0, in.depNorm[k] - in.depStock[k]);
    } finally {
      if (rs != null) try { rs.close(); } catch (Exception ignored) { }
      if (ps != null) try { ps.close(); } catch (Exception ignored) { }
    }

    // keep the drugs that have any use, stock or norm
    List<Input> list = new ArrayList<Input>();
    for (Input in : map.values()) {
      double used = 0;
      for (double w : in.daily) used += w;
      in.qTotal = used;
      if (used > 0 || !in.batches.isEmpty() || in.hasNorm || in.deptAll > 0) list.add(in);
    }
    // ABC by the value of the use
    final Map<Integer, Double> value = new HashMap<Integer, Double>();
    double all = 0;
    for (Input in : list) { double v = in.qTotal * in.lastPrice; value.put(in.id, v); all += v; }
    Collections.sort(list, new Comparator<Input>() {
      public int compare(Input a, Input b) { return Double.compare(value.get(b.id), value.get(a.id)); }
    });
    Map<Integer, String> abc = new HashMap<Integer, String>();
    double run = 0;
    for (Input in : list) {
      run += value.get(in.id);
      double share = all > 0 ? run / all : 1;
      abc.put(in.id, value.get(in.id) <= 0 ? "C" : share <= 0.8 ? "A" : share <= 0.95 ? "B" : "C");
    }
    List<Result> res = new ArrayList<Result>();
    for (Input in : list) {
      String cls = abc.get(in.id);
      double zz = z(p.service);
      if (p.abc) zz = "A".equals(cls) ? z(Math.min(0.99, p.service + 0.03)) : "C".equals(cls) ? z(Math.max(0.85, p.service - 0.05)) : zz;
      Result r = compute(in, p, zz);
      r.abc = cls;
      res.add(r);
    }
    return res;
  }

  // ------------------------------------------------------------------ self test: java ckb.utils.OrderCalc
  public static void main(String[] a) {
    // order days Mon, Wed, Fri
    check("cover Mon", coverDays(1, "1,3,5"), 2, 0);
    check("cover Tue", coverDays(2, "1,3,5"), 1, 0);
    check("cover Wed", coverDays(3, "1,3,5"), 2, 0);
    check("cover Thu", coverDays(4, "1,3,5"), 1, 0);
    check("cover Fri", coverDays(5, "1,3,5"), 3, 0);
    check("cover Sat", coverDays(6, "1,3,5"), 2, 0);
    check("cover Sun", coverDays(7, "1,3,5"), 1, 0);

    Params p = new Params();
    p.coverDays = 2;
    // one department: 10 per day without variability, norm 50 (threshold 25), stock 45, 6 already used today
    // forecast 45 - 4 - 20 = 21 <= 25 -> up to the norm
    Input in = new Input();
    in.name = "test"; in.block = 1; in.effDays = 28; in.firstInDays = 365; in.proc = 25; in.hasNorm = true;
    in.daily = new double[29];
    for (int i = 1; i <= 28; i++) in.daily[i] = 10;
    in.daily[0] = 6;
    in.dirs(1);
    in.depRate[0] = 10; in.depToday[0] = 6; in.depNorm[0] = 50; in.depStock[0] = 45;
    in.batches.add(new double[]{10, 365, 0});
    Result r = compute(in, p, z(0.90));
    check("d", r.d, 10, 0.001);
    check("sigma", r.sigma, 0, 0.001);
    check("to norm", r.depToNorm[0], 5, 0.001);
    check("issue", r.depIssue[0], 29, 0.001);       // 50 + (10 - 6) + 10 * 2 - 45
    check("target", r.target, 29, 0.001);
    check("usable", r.usable, 10, 0.001);
    check("order units", r.orderUnits, 19, 0.001);  // 29 - 10
    check("rop", r.rop, 10, 0.001);
    // whole blocks of 10
    in.block = 10;
    r = compute(in, p, z(0.90));
    check("order blocks", r.orderBlocks, 2, 0.001);
    check("order units in blocks", r.orderUnits, 20, 0.001);
    // FEFO: 40 units that expire in 2 days (only 10/day * 2 = 20 can be used), 60 good for 100 days
    in.block = 1;
    in.batches.clear();
    in.batches.add(new double[]{40, 2, 0});
    in.batches.add(new double[]{60, 100, 0});
    r = compute(in, p, z(0.90));
    check("usable fefo", r.usable, 80, 0.001);
    check("risk", r.risk, 20, 0.001);
    check("order none", r.orderUnits, 0, 0.001);
    // a new drug without use: only up to the norms of three departments
    Input n = new Input();
    n.block = 1; n.effDays = 7; n.daily = new double[29]; n.firstInDays = 3; n.hasNorm = true;
    n.dirs(3);
    n.depNorm[0] = 10; n.depNorm[1] = 10; n.depNorm[2] = 10; n.depStock[1] = 4;
    r = compute(n, p, z(0.90));
    check("deficit order", r.orderUnits, 26, 0.001);
    // the stock stays above the threshold until the next delivery: nothing to issue (Soda-Buffer: norms 10/10/10, stocks 10/9/7)
    Input s = new Input();
    s.block = 1; s.effDays = 28; s.daily = new double[29]; s.firstInDays = 365; s.proc = 10; s.hasNorm = true;  // proc = norm -> not set, threshold = 5
    s.dirs(3);
    s.depNorm[0] = 10; s.depNorm[1] = 10; s.depNorm[2] = 10;
    s.depStock[0] = 10; s.depStock[1] = 9; s.depStock[2] = 7;
    s.depRate[1] = 0.21; s.depRate[2] = 0.21;
    s.batches.add(new double[]{1, 365, 0});
    r = compute(s, p, z(0.90));
    check("soda threshold", r.depThreshold[2], 5, 0.001);
    check("soda issue", r.depIssue[0] + r.depIssue[1] + r.depIssue[2], 0, 0.001);
    check("soda order", r.orderUnits, 0, 0.001);
    if (!"stale".equals(r.status)) throw new IllegalStateException("soda status: " + r.status);   // no use during the period
    // the explicit threshold: 7 - 0.21 * 3 = 6.37 <= 7 -> up to the norm: 10 + 0.21 * 3 - 7 = 3.63
    s.proc = 7;
    r = compute(s, p, z(0.90));
    check("proc issue", r.depIssue[2], 3.63, 0.001);
    check("proc issue others", r.depIssue[0] + r.depIssue[1], 0, 0.001);   // 9 - 0.63 = 8.37 > 7
    check("proc moved", r.moved, 3.63, 0.001);                               // surplus above the threshold: 10 - 7 = 3 and 8.37 - 7 = 1.37
    check("proc order", r.orderUnits, 0, 0.001);                             // the departments cover it themselves
    // Ksavron: every department stays above the threshold, the pharmacy is empty: no safety stock alone, nothing to order
    Input x = new Input();
    x.block = 10; x.effDays = 28; x.firstInDays = 365; x.proc = 10; x.hasNorm = true;      // threshold 5
    x.daily = new double[29];
    for (int i = 1; i <= 28; i++) x.daily[i] = i % 2 == 0 ? 3 : 0.7;      // uneven use: sigma > 0
    x.dirs(3);
    x.depNorm[0] = 10; x.depNorm[1] = 10; x.depNorm[2] = 10;
    x.depStock[0] = 9; x.depStock[1] = 7; x.depStock[2] = 15; x.deptAll = 31;
    x.depRate[0] = 0.79; x.depRate[1] = 0.36; x.depRate[2] = 0.71;
    x.depToday[0] = 1;
    r = compute(x, p, z(0.90));
    check("ksavron sigma > 0", r.sigma > 1 ? 1 : 0, 1, 0);
    check("ksavron issue", r.depIssue[0] + r.depIssue[1] + r.depIssue[2], 0, 0.001);
    check("ksavron target", r.target, 0, 0.001);
    check("ksavron order", r.orderUnits, 0, 0.001);
    check("ksavron cover", r.cover, 31 / 1.86, 0.01);                     // the stock of the departments counts
    if (!"ok".equals(r.status)) throw new IllegalStateException("ksavron status: " + r.status);
    // one department falls below the threshold (4 - 0.36 - 0.72 = 2.92 <= 5), the others give their surplus above the threshold
    x.depStock[1] = 4; x.deptAll = 28;
    r = compute(x, p, z(0.90));
    check("ksavron issue", r.depIssue[1], 7.08, 0.001);                    // 10 + 1.08 - 4
    check("ksavron surplus 1", r.depSurplus[0], 9 - 1.58 - 5, 0.001);       // 2.42
    check("ksavron surplus 3", r.depSurplus[2], 15 - 2.13 - 5, 0.001);      // 7.87
    check("ksavron moved", r.moved, 7.08, 0.001);                          // from the third department
    check("ksavron transfer from", r.transfers.get(0)[0], 2, 0);
    check("ksavron transfer order", r.orderUnits, 0, 0.001);
    if ("urgent".equals(r.status)) throw new IllegalStateException("ksavron transfer status: " + r.status);
    // every department falls below the threshold, the pharmacy is empty: urgent, rounded up to a block
    x.depStock[0] = 4; x.depStock[1] = 4; x.depStock[2] = 4; x.deptAll = 12;
    r = compute(x, p, z(0.90));
    check("urgent moved", r.moved, 0, 0.001);
    check("urgent issue", r.depIssue[0] + r.depIssue[1] + r.depIssue[2], 7.58 + 7.08 + 8.13, 0.001);
    check("urgent order", r.orderUnits, 30, 0.001);                        // 22.79 + SS 2.12 -> 3 blocks of 10
    if (!"urgent".equals(r.status)) throw new IllegalStateException("urgent status: " + r.status);
    // transfers between the departments: norms 10/10/10 (threshold 5), stocks 4/10/20, use 1/0/1 per day, pharmacy empty
    Input t = new Input();
    t.block = 1; t.effDays = 28; t.firstInDays = 365; t.proc = 10; t.hasNorm = true;
    t.daily = new double[29];
    for (int i = 1; i <= 28; i++) t.daily[i] = 2;                          // sigma = 0
    t.dirs(3);
    t.depNorm[0] = 10; t.depNorm[1] = 10; t.depNorm[2] = 10;
    t.depStock[0] = 4; t.depStock[1] = 10; t.depStock[2] = 20; t.deptAll = 34;
    t.depRate[0] = 1; t.depRate[2] = 1;
    r = compute(t, p, z(0.90));
    check("transfer issue", r.depIssue[0], 9, 0.001);                      // 4 - 1 - 2 = 1 <= 5 -> 10 + 3 - 4
    check("transfer surplus 2", r.depSurplus[1], 5, 0.001);                // 10 - 0 - 5
    check("transfer surplus 3", r.depSurplus[2], 12, 0.001);               // 20 - 3 - 5
    check("transfer count", r.transfers.size(), 1, 0);
    check("transfer from", r.transfers.get(0)[0], 2, 0);
    check("transfer to", r.transfers.get(0)[1], 0, 0);
    check("transfer qty", r.transfers.get(0)[2], 9, 0.001);
    check("from pharmacy", r.fromPharmacy, 0, 0.001);
    check("transfer order", r.orderUnits, 0, 0.001);
    if ("urgent".equals(r.status)) throw new IllegalStateException("transfer status: " + r.status);
    // not enough surplus: stocks 4/6/8 -> needs 9 + 5 (8 - 3 = 5 <= 5), surplus 1 (6 - 5)
    t.depStock[1] = 6; t.depStock[2] = 8; t.deptAll = 18;
    r = compute(t, p, z(0.90));
    check("short issue 3", r.depIssue[2], 5, 0.001);                       // 10 + 3 - 8
    check("short surplus", r.depSurplus[1], 1, 0.001);
    check("short moved", r.moved, 1, 0.001);
    check("short to", r.transfers.get(0)[1], 0, 0);                        // to the biggest need
    check("short from pharmacy", r.fromPharmacy, 13, 0.001);               // 14 - 1
    check("short order", r.orderUnits, 13, 0.001);
    if (!"urgent".equals(r.status)) throw new IllegalStateException("short status: " + r.status);
    t.block = 10;
    r = compute(t, p, z(0.90));
    check("short order block", r.orderUnits, 20, 0.001);
    // the use per day comes from the whole period: 280 during 28 days -> 10 per day; a new drug: 14 during its 7 days -> 2 per day
    Input u = new Input();
    u.effDays = 28; u.dirs(2); u.depRate[0] = 280; u.depRate[1] = 56;
    rates(u, 28);
    check("rate period", u.depRate[0], 10, 0.001);
    check("rate period 2", u.depRate[1], 2, 0.001);
    u.effDays = 7; u.depRate[0] = 14;
    rates(u, 28);
    check("rate new drug", u.depRate[0], 2, 0.001);
    // Kartan: no norm, nothing in the pharmacy and in the departments, used 1 per day -> no_stock, still something to order
    Input k = new Input();
    k.block = 1; k.effDays = 28; k.firstInDays = 365;
    k.daily = new double[29];
    for (int i = 1; i <= 28; i++) k.daily[i] = 1;
    k.dirs(3);
    k.depRate[0] = 1;
    r = compute(k, p, z(0.90));
    check("kartan issue", r.depIssue[0], 3, 0.001);                        // 0 + 1 + 1 * 2 - 0
    check("kartan order", r.orderUnits, 3, 0.001);
    if (!"no_stock".equals(r.status)) throw new IllegalStateException("kartan status: " + r.status);
    // stock without any use during the period: stale, also with a norm when every department is above the threshold
    Input w = new Input();
    w.block = 1; w.effDays = 28; w.firstInDays = 365; w.hasNorm = true; w.proc = 10;
    w.daily = new double[29];
    w.dirs(3);
    w.depNorm[0] = 10; w.depNorm[1] = 10; w.depNorm[2] = 10;
    w.depStock[0] = 10; w.depStock[1] = 8; w.depStock[2] = 6; w.deptAll = 24;
    w.batches.add(new double[]{50, 300, 0});
    r = compute(w, p, z(0.90));
    check("stale order", r.orderUnits, 0, 0.001);
    if (!"stale".equals(r.status)) throw new IllegalStateException("stale status: " + r.status);
    w.hasNorm = false;                                                      // no norm, only the pharmacy has it
    r = compute(w, p, z(0.90));
    if (!"stale".equals(r.status)) throw new IllegalStateException("stale no norm status: " + r.status);
    // the same drug with some use during the period is not stale
    w.hasNorm = true; w.daily[20] = 1;
    r = compute(w, p, z(0.90));
    if ("stale".equals(r.status)) throw new IllegalStateException("used status: " + r.status);
    // ear funnels: 600 in the pharmacy, everything expired, no use, no norm -> expired, nothing to order
    Input e = new Input();
    e.block = 1; e.effDays = 28; e.firstInDays = 365;
    e.daily = new double[29];
    e.dirs(3);
    e.batches.add(new double[]{600, -10, 0});
    r = compute(e, p, z(0.90));
    check("funnels usable", r.usable, 0, 0.001);
    check("funnels expired", r.expired, 600, 0.001);
    check("funnels late", r.late, 0, 0.001);
    check("funnels order", r.orderUnits, 0, 0.001);
    if (!"expired".equals(r.status)) throw new IllegalStateException("funnels status: " + r.status);
    // the same with some usable stock: stale, the expired part is still shown apart
    e.batches.add(new double[]{20, 300, 1});
    r = compute(e, p, z(0.90));
    check("funnels usable 2", r.usable, 20, 0.001);
    check("funnels drafts", r.draftAll, 20, 0.001);
    if (!"stale".equals(r.status)) throw new IllegalStateException("funnels stale status: " + r.status);
    // expired and late are told apart: 10 per day, 40 expire in 2 days (20 cannot be used), 30 already expired
    Input f = new Input();
    f.block = 1; f.effDays = 28; f.firstInDays = 365;
    f.daily = new double[29];
    for (int i = 1; i <= 28; i++) f.daily[i] = 10;
    f.dirs(1); f.depRate[0] = 10; f.depStock[0] = 100; f.deptAll = 100;
    f.batches.add(new double[]{30, 0, 0});
    f.batches.add(new double[]{40, 2, 0});
    r = compute(f, p, z(0.90));
    check("split expired", r.expired, 30, 0.001);
    check("split late", r.late, 20, 0.001);
    check("split risk", r.risk, 50, 0.001);
    System.out.println("OrderCalc self test: OK");
  }

  private static void check(String what, double got, double want, double eps) {
    if (Math.abs(got - want) > eps) throw new IllegalStateException(what + ": " + got + " != " + want);
  }
}
