package ckb.controllers.med;

import ckb.dao.med.amb.DAmbGroups;
import ckb.dao.med.drug.dict.directions.DDrugDirection;
import ckb.dao.med.kdos.DKdoTypes;
import ckb.domains.admin.KdoTypes;
import ckb.domains.med.amb.AmbGroups;
import ckb.domains.med.drug.dict.DrugDirections;
import ckb.models.Obj;
import ckb.models.ObjList;
import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.DB;
import ckb.utils.Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/mn/")
public class CMn {

  private Session session = null;

  @Autowired private DKdoTypes dKdoType;
  @Autowired private DAmbGroups dAmbGroup;
  @Autowired private DDrugDirection dDrugDirection;

  @RequestMapping("index.s")
  protected String patients(HttpServletRequest req, Model m) {
    return "drugs";
  }

  @RequestMapping("/drugstore.s")
  protected String sklad(HttpServletRequest req, Model model) {
    session = SessionUtil.getUser(req);
    session.setCurUrl("/mn/drugstore.s");
    String startDate = Util.get(req, "period_start", "01" + Util.getCurDate().substring(2));
    String endDate = Util.get(req, "period_end", Util.getCurDate());
    //
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      conn = DB.getConnection();
      //
      Double income_in = DB.getSum(conn, "Select Sum(c.countprice * c.counter) From Drug_Acts t, Drug_Act_Drugs c Where t.id = c.act_id And t.regDate < '" + Util.dateDBBegin(startDate) + "'");
      Double out_in = DB.getSum(conn, "Select Sum(c.price * c.drugCount) From Drug_Outs t, Drug_Out_Rows c Where t.id = c.doc_id And t.regDate < '" + Util.dateDBBegin(startDate) + "'");
      //
      Double income_period = DB.getSum(conn, "Select Sum(c.countprice * c.counter) From Drug_Acts t, Drug_Act_Drugs c Where t.id = c.act_id And t.regDate Between '" + Util.dateDBBegin(startDate) + "' And '" + Util.dateDBBegin(endDate) + "' ");
      Double out_period = DB.getSum(conn, "Select Sum(c.price * c.drugCount) From Drug_Outs t, Drug_Out_Rows c Where t.id = c.doc_id And t.regDate Between '" + Util.dateDBBegin(startDate) + "' And '" + Util.dateDBBegin(endDate) + "'");
      //
      model.addAttribute("saldo_in", income_in - out_in);
      model.addAttribute("income_sum", income_period);
      model.addAttribute("outcome_sum", out_period);
      model.addAttribute("saldo_out", income_in - out_in + income_period - out_period);
      //
      Double hnSaldoOut = DB.getSum(conn, "Select Sum((t.drugCount - t.rasxod) * c.price) From Hn_Drugs t, Drug_Out_Rows c Where c.id = t.outRow_Id And t.drugCount - t.rasxod > 0");
      Double hnDayOut = DB.getSum(conn, "Select sum(t.summ) From ( " +
        " Select ifnull(sum(t.rasxod * f.price), 0) summ From hn_date_patient_rows t, hn_drugs c, drug_out_rows f where c.id = t.drug_Id And f.id = c.outRow_Id And date(t.crOn) = CURRENT_DATE() " +
        " union all " +
        " Select ifnull(sum(t.rasxod * f.price), 0) summ From hn_date_rows t, hn_drugs c, drug_out_rows f where c.id = t.drug_Id And f.id = c.outRow_id And date(t.crOn) = CURRENT_DATE() " +
        " ) t ");
      Double hnDayIn = DB.getSum(conn, "Select ifnull(sum(c.drugCount) * f.price, 0) summ From hn_drugs c, drug_out_rows f where f.id = c.outRow_id And date(c.crOn) = CURRENT_DATE()");
      model.addAttribute("hn_saldo_in", hnSaldoOut - hnDayIn + hnDayOut);
      model.addAttribute("hn_day_in", hnDayIn);
      model.addAttribute("hn_day_out", hnDayOut);
      model.addAttribute("hn_saldo_out", hnSaldoOut);
      ps = conn.prepareStatement(
        "Select t.patient_id, c.surname, c.name, c.middlename, c.Date_Begin, c.Date_End, c.yearNum, c.birthyear, Sum(t.rasxod * w.price) Summ, count(*) " +
        "      From hn_date_patient_rows t, Patients c, hn_drugs d, drug_out_rows w " +
        "     Where t.patient_id = c.id " +
        "       and t.drug_Id = d.id " +
        "       and w.Id = d.outRow_id " +
        "       And c.paid != 'CLOSED' " +
        "  Group By t.patient_id, c.surname, c.name, c.middlename, c.Date_Begin, c.Date_End, c.yearNum, c.birthyear"
      );
      ps.execute();
      rs = ps.getResultSet();
      List<ObjList> list = new ArrayList<ObjList>();
      double summ = 0;
      while (rs.next()) {
        ObjList obj = new ObjList();
        obj.setC1(rs.getString("surname") + " " + rs.getString("name") + " " + rs.getString("middlename"));
        obj.setC2(Util.dateToString(rs.getDate("date_begin")));
        obj.setC3(Util.dateToString(rs.getDate("date_end")));
        obj.setC4(rs.getString("yearNum"));
        obj.setC5(rs.getString("birthyear"));
        obj.setC6(rs.getString("summ"));
        summ += rs.getDouble("summ");
        list.add(obj);
      }
      model.addAttribute("patients", list);
      model.addAttribute("summ", summ);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(conn);
    }
    //
    model.addAttribute("period_start", startDate);
    model.addAttribute("period_end", endDate);
    return "/med/mn/drugs";
  }

  @RequestMapping("drugs.s")
  protected String drugs(HttpServletRequest req, Model m) {
    session = SessionUtil.getUser(req);
    session.setCurUrl("/mn/drugs.s");
    Connection cn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String startDate = Util.get(req, "period_start", "01" + Util.getCurDate().substring(2));
    String endDate = Util.get(req, "period_end", Util.getCurDate());
    if(Util.stringToDate(startDate).after(Util.stringToDate(endDate)))
      startDate = endDate;
    try {
      cn = DB.getConnection();
      ps = cn.prepareStatement(
        "Select c.id, c.Name, " +
        "    Sum(f.saldo_in) saldo_in, " +
        "    Sum(f.saldo_in_sum) saldo_in_sum, " +
        "    Sum(f.cin) cin, " +
        "    Sum(f.sin) sin, " +
        "    Sum(f.cout) cout, " +
        "    Sum(f.sout) sout, " +
        "    Sum(f.saldo_in + f.cin - f.cout) saldo_out, " +
        "    Sum(f.saldo_in_sum + f.sin - f.sout) saldo_out_sum " +
        "From ( " +
        "Select f.drug_id, " +
        "       Round(Sum(f.counter), 2) saldo_in,  " +
        "       Round(Sum(f.summ), 2) saldo_in_sum, " +
        "       0 cin, 0 sin, 0 cout, 0 sout " +
        "  From (Select t.drug_id,   " +
        "               Sum(t.counter) counter,  " +
        "               Sum(t.counter * t.countprice) summ " +
        "     From drug_act_drugs t, drug_acts c " +
        "     Where c.id = t.act_Id  " +
        "       And date(c.regDate) <= ? " +
        "     Group By t.drug_id " +
        "    Union All " +
        "    Select f.drug_id, -Sum(c.rasxod) counter, -Sum(c.rasxod * a.price) summ " +
        "     From hn_date_patient_rows c, hn_drugs f, hn_dates d, drug_out_rows a  " +
        "     Where a.id = f.outRow_id  " +
        "       And d.Id = c.doc_Id  " +
        "       And c.drug_Id = f.id  " +
        "       And f.outRow_id > 0 " +
        "       And date(d.date) < ? " +
        "     Group By f.drug_id " +
        "    Union All " +
        "    Select f.drug_id, -Sum(c.rasxod) counter, -Sum(c.rasxod * a.price) summ " +
        "     From hn_date_rows c, hn_drugs f, hn_dates d, drug_out_rows a " +
        "     Where a.id = f.outRow_id " +
        "       And d.Id = c.doc_Id  " +
        "       And c.drug_Id = f.id  " +
        "       And f.outRow_id > 0 " +
        "       And date(d.date) < ? " +
        "     Group By f.drug_id) f " +
        "Group By f.drug_id " +
        "Union All " +
        "Select f.drug_id, " +
        "       0, 0, " +
        "       Round(Sum(f.cin), 2) cin,  " +
        "       Round(Sum(f.sin), 2) sin, " +
        "       Round(Sum(f.cout), 2) cout,  " +
        "       Round(Sum(f.sout), 2) sout  " +
        "  From (Select t.drug_id,   " +
        "        Sum(t.counter) cin,  " +
        "        Sum(t.counter * t.countprice) sin, " +
        "        0 cout, " +
        "        0 sout " +
        "     From drug_act_drugs t, drug_acts c " +
        "     Where c.id = t.act_Id  " +
        "       And date(c.regDate) Between ? And ? " +
        "     Group By t.drug_id " +
        "    Union All " +
        "    Select f.drug_id, 0, 0, Sum(c.rasxod) counter, Sum(c.rasxod * a.price) summ " +
        "     From hn_date_patient_rows c, hn_drugs f, hn_dates d, drug_out_rows a  " +
        "     Where a.id = f.outRow_id  " +
        "       And d.Id = c.doc_Id  " +
        "       And c.drug_Id = f.id  " +
        "       And f.outRow_id > 0 " +
        "       And date(d.date) Between ? And ? " +
        "     Group By f.drug_id " +
        "    Union All " +
        "    Select f.drug_id, 0, 0, Sum(c.rasxod) counter, Sum(c.rasxod * a.price) summ " +
        "     From hn_date_rows c, hn_drugs f, hn_dates d, drug_out_rows a " +
        "     Where a.id = f.outRow_id " +
        "       And d.Id = c.doc_Id  " +
        "       And c.drug_Id = f.id  " +
        "       And f.outRow_id > 0 " +
        "       And date(d.date) Between ? And ? " +
        "     Group By f.drug_id) f " +
        "Group By f.drug_id ) f, drug_s_names c " +
        "Where c.id = f.drug_id " +
        "  And c.state = 'A' " +
        "Group By c.id, c.name ");
      ps.setString(1, Util.dateDB(startDate));
      ps.setString(2, Util.dateDB(startDate));
      ps.setString(3, Util.dateDB(startDate));
      ps.setString(4, Util.dateDB(startDate));
      ps.setString(5, Util.dateDB(endDate));
      ps.setString(6, Util.dateDB(startDate));
      ps.setString(7, Util.dateDB(endDate));
      ps.setString(8, Util.dateDB(startDate));
      ps.setString(9, Util.dateDB(endDate));
      rs = ps.executeQuery();
      List<ObjList> rows = new ArrayList<ObjList>();
      while (rs.next()) {
        ObjList row = new ObjList();
        row.setC1(rs.getString("name"));
        row.setC2(rs.getString("saldo_in"));
        row.setC3(rs.getString("saldo_in_sum"));
        row.setC4(rs.getString("cin"));
        row.setC5(rs.getString("sin"));
        row.setC6(rs.getString("cout"));
        row.setC7(rs.getString("sout"));
        row.setC8(rs.getString("saldo_out"));
        row.setC9(rs.getString("saldo_out_sum"));
        row.setC10(rs.getString("id"));
        //
        rows.add(row);
      }
      m.addAttribute("rows", rows);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(cn);
    }
    m.addAttribute("period_start", startDate);
    m.addAttribute("period_end", endDate);
    return "med/mn/rating";
  }

  @RequestMapping("/services.s")
  protected String services(HttpServletRequest req, Model m) {
    session = SessionUtil.getUser(req);
    session.setCurUrl("/mn/services.s");
    Connection cn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String startDate = Util.get(req, "period_start", "01" + Util.getCurDate().substring(2));
    String endDate = Util.get(req, "period_end", Util.getCurDate());
    try {
      cn = DB.getConnection();
      List<Obj> kdoTypes = new ArrayList<Obj>();
      List<KdoTypes> types = dKdoType.getList("From KdoTypes Where state = 'A'");
      for(KdoTypes type: types) {
        Obj obj = new Obj();
        obj.setFio(type.getName());
        obj.setPrice(0D);
        ps = cn.prepareStatement(
          "Select c.id kdo_id, c.name, " +
            "  (Select Count(*) From lv_plans t Where t.kdo_id = c.id And t.result_date between '" + Util.dateDBBegin(startDate) + "' And '" + Util.dateDBEnd(endDate) + "') counter, " +
            "  ifnull((Select sum(t.price) From lv_plans t Where t.kdo_id = c.id And t.result_date between '" + Util.dateDBBegin(startDate) + "' And '" + Util.dateDBEnd(endDate) + "'), 0) total " +
            "  From kdos c " +
            " Where c.kdo_type = ? " +
            "   And c.state = 'A'");
        ps.setInt(1, type.getId());
        ps.execute();
        rs = ps.getResultSet();
        List<ObjList> stats = new ArrayList<ObjList>();
        while (rs.next()) {
          ObjList row = new ObjList();
          row.setC1(rs.getString("kdo_id"));
          row.setC2(rs.getString("name"));
          row.setC3(rs.getString("counter"));
          row.setC4(rs.getString("total"));
          stats.add(row);
          obj.setPrice(obj.getPrice() + rs.getDouble("total"));
        }
        obj.setList(stats);
        kdoTypes.add(obj);
      }
      m.addAttribute("rows", kdoTypes);
      List<Obj> ambGroups = new ArrayList<Obj>();
      List<AmbGroups> groups = dAmbGroup.getAll();
      for(AmbGroups group: groups) {
        Obj obj = new Obj();
        obj.setFio(group.getName());
        obj.setPrice(0D);
        ps = cn.prepareStatement(
          "Select c.id service_Id, c.name, " +
          " (Select count(*) From Amb_Patient_Services t Where t.crOn between '" + Util.dateDBBegin(startDate) + "' and '" + Util.dateDBEnd(endDate) + "' And t.service_Id = c.Id) counter, " +
          " ifnull((Select sum(t.price) From Amb_Patient_Services t Where t.crOn between '" + Util.dateDBBegin(startDate) + "' and '" + Util.dateDBEnd(endDate) + "' And t.service_Id = c.Id), 0) total " +
            "  From Amb_Services c " +
            " Where c.group_id = ? " +
            "   And c.state = 'A'");
        ps.setInt(1, group.getId());
        ps.execute();
        rs = ps.getResultSet();
        List<ObjList> amb = new ArrayList<ObjList>();
        while (rs.next()) {
          ObjList row = new ObjList();
          row.setC1(rs.getString("service_Id"));
          row.setC2(rs.getString("name"));
          row.setC3(rs.getString("counter"));
          row.setC4(rs.getString("total"));
          amb.add(row);
          obj.setPrice(obj.getPrice() + rs.getDouble("total"));
        }
        obj.setList(amb);
        ambGroups.add(obj);
      }
      m.addAttribute("amb", ambGroups);
      m.addAttribute("period_start", startDate);
      m.addAttribute("period_end", endDate);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(cn);
    }
    return "med/mn/kdos";
  }

  @RequestMapping("analys.s")
  protected String analys(HttpServletRequest req, Model m) {
    session = SessionUtil.getUser(req);
    session.setCurUrl("/mn/analys.s");
    Connection cn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      cn = DB.getConnection();
      ps = cn.prepareStatement(
        "Select a.id, a.name,    " +
          "       f.diff,  " +
          "       f.minDate,  " +
          "       f.out_count,  " +
          "       f.out_sum,  " +
          "       f.saldo_count,  " +
          "       f.saldo_sum,  " +
          "       Round(f.out_count / case when f.diff <=0 Then 1 Else f.diff End, 2) avgCount,  " +
          "       Round(f.out_sum / case when f.diff <=0 Then 1 Else f.diff End, 2) avgSum,  " +
          "       Case When f.out_count > 0 Then Round(ifnull(f.saldo_count, 0) / (f.out_count / case when ifnull(f.diff, 0) = 0 then 1 else ifnull(f.diff, 1) end), 2) else 0 End weekCount  " +
          "  From (Select f.drug_id,  " +
          "               (Select timestampdiff(WEEK, ifnull(min(c.regDate), '2020-12-01'), CURRENT_DATE()) From drug_acts c, drug_act_drugs t Where t.drug_id = f.drug_id And c.id = t.act_Id) diff,  " +
          "               (Select date(ifnull(min(c.regDate), '2020-12-01')) From drug_acts c, drug_act_drugs t Where t.drug_id = f.drug_id And c.id = t.act_Id) minDate,  " +
          "               Round(Sum(f.counter), 2) out_count,  " +
          "               Round(Sum(f.summ), 2) out_sum,  " +
          "               Round(Sum(f.saldo_count), 2) saldo_count,  " +
          "               Round(Sum(f.saldo_sum), 2) saldo_sum  " +
          "          From (Select f.drug_id, Sum(c.rasxod) counter, Sum(c.rasxod * a.price) summ, 0 saldo_count, 0 saldo_sum  " +
          "                  From hn_date_patient_rows c, hn_drugs f, hn_dates d, drug_out_rows a   " +
          "                  Where a.id = f.outRow_id   " +
          "                    And d.Id = c.doc_Id   " +
          "                    And c.drug_Id = f.id  " +
          "                    And f.outRow_id > 0  " +
          "                  Group By f.drug_id  " +
          "                Union All  " +
          "                Select f.drug_id, Sum(c.rasxod) counter, Sum(c.rasxod * a.price) summ, 0 saldo_count, 0 saldo_sum  " +
          "                  From hn_date_rows c, hn_drugs f, hn_dates d, drug_out_rows a  " +
          "                  Where a.id = f.outRow_id  " +
          "                    And d.Id = c.doc_Id   " +
          "                    And c.drug_Id = f.id  " +
          "                    And f.outRow_id > 0  " +
          "                  Group By f.drug_id  " +
          "                Union All  " +
          "                Select t.drug_id,  " +
          "                       0, 0,  " +
          "                       Sum(t.counter),   " +
          "                       Sum(t.counter * t.countprice)  " +
          "                  From drug_act_drugs t, drug_acts c  " +
          "                  Where c.id = t.act_Id   " +
          "                  Group By t.drug_id  " +
          "                Union All  " +
          "                Select f.drug_id, 0, 0, -Sum(c.rasxod) counter, -Sum(c.rasxod * a.price) summ  " +
          "                  From hn_date_patient_rows c, hn_drugs f, hn_dates d, drug_out_rows a   " +
          "                  Where a.id = f.outRow_id   " +
          "                    And d.Id = c.doc_Id   " +
          "                    And c.drug_Id = f.id   " +
          "                    And f.outRow_id > 0  " +
          "                  Group By f.drug_id  " +
          "                Union All  " +
          "                Select f.drug_id, 0, 0, -Sum(c.rasxod) counter, -Sum(c.rasxod * a.price) summ  " +
          "                  From hn_date_rows c, hn_drugs f, hn_dates d, drug_out_rows a  " +
          "                  Where a.id = f.outRow_id  " +
          "                    And d.Id = c.doc_Id   " +
          "                    And c.drug_Id = f.id   " +
          "                    And f.outRow_id > 0  " +
          "                  Group By f.drug_id) f  " +
          "          Group By f.drug_id) f, drug_s_names a  " +
          "  Where a.id = f.drug_id " +
          "    And a.state = 'A' " +
          "  Order By a.name ");
      rs = ps.executeQuery();
      List<ObjList> rows = new ArrayList<ObjList>();
      while (rs.next()) {
        ObjList row = new ObjList();
        row.setC10(rs.getString("name"));
        row.setC1(rs.getString("diff"));
        row.setC2(Util.dateToString(rs.getDate("minDate")));
        row.setC3(rs.getString("out_count"));
        row.setC4(rs.getString("out_sum"));
        row.setC5(rs.getString("saldo_count"));
        row.setC6(rs.getString("saldo_sum"));
        row.setC7(rs.getString("avgCount"));
        row.setC8(rs.getString("avgSum"));
        row.setC9(rs.getString("weekCount"));
        row.setIb(rs.getInt("id") + "");
        //
        rows.add(row);
      }
      m.addAttribute("rows", rows);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(cn);
    }
    return "med/mn/analys";
  }

  @RequestMapping("drugs/days.s")
  protected String drugDays(HttpServletRequest req, Model m) {
    session = SessionUtil.getUser(req);
    session.setCurUrl("/mn/drugs/days.s");
    Connection cn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String days = Util.get(req, "days", "14");
    try {
      cn = DB.getConnection();
      ps = cn.prepareStatement(
        "Select t.Drug_Id,  " +
          "    c.name, " +
          "    Round(Sum(t.Rasxod), 2) Rasxod, " +
          "    Round(Sum(t.Rasxod_Sum), 2) Rasxod_Sum, " +
          "    Round(Sum(t.Rasxod /  " + days + "), 2) Avg_Count, " +
          "    Round(Sum(t.Rasxod_Sum /  " + days + "), 2) Avg_Sum, " +
          "    Round(Sum(t.saldo_count), 2) Saldo_Count, " +
          "    Round(Sum(t.saldo_sum), 2) Saldo_Sum, " +
          "    Case When Sum(t.Rasxod /  " + days + ") != 0 Then Round(Sum(t.saldo_count) / Sum(t.Rasxod /  " + days + ")) Else 999 End days_count " +
          "  From ( " +
          "  Select f.drug_id, Sum(c.rasxod) rasxod, Sum(c.rasxod * a.price) rasxod_sum, 0 saldo_count, 0 saldo_sum   " +
          "    From hn_date_patient_rows c, hn_drugs f, hn_dates d, drug_out_rows a    " +
          "   Where a.id = f.outRow_Id    " +
          "     And d.Id = c.doc_Id    " +
          "     And c.drug_Id = f.id   " +
          "     And date(c.date) >= DATE_ADD(NOW(), INTERVAL -" + days + " DAY) " +
          "     And f.outRow_Id > 0   " +
          "   Group By f.drug_id " +
          "  Union All " +
          "  Select f.drug_id, Sum(c.rasxod) rasxod, Sum(c.rasxod * a.price) rasxod_sum, 0 saldo_count, 0 saldo_sum   " +
          "   From hn_date_rows c, hn_drugs f, hn_dates d, drug_out_rows a   " +
          "   Where a.id = f.outRow_Id   " +
          "    And d.Id = c.doc_Id    " +
          "    And c.drug_Id = f.id   " +
          "     And date(c.crOn) >= DATE_ADD(NOW(), INTERVAL -" + days + " DAY) " +
          "    And f.outRow_Id > 0   " +
          "   Group By f.drug_id " +
          "  Union All " +
          "  Select t.drug_id,   " +
          "      0, 0,   " +
          "      Sum(t.counter - t.rasxod),    " +
          "      Sum(t.counter * t.countprice - t.rasxod * t.countPrice)   " +
          "   From drug_act_drugs t, drug_acts c   " +
          "   Where c.id = t.act_Id " +
          "   Group By t.drug_id) t, drug_s_names c " +
          "  Where c.id = t.drug_id " +
          "    And c.state = 'A' " +
          "    And (t.Rasxod != 0 Or t.saldo_count != 0)" +
          "  Group By t.Drug_Id Order By c.name");
      rs = ps.executeQuery();
      List<ObjList> rows = new ArrayList<ObjList>();
      while (rs.next()) {
        ObjList row = new ObjList();
        row.setC1(rs.getString("drug_id"));
        row.setC2(rs.getString("name"));
        row.setC3(rs.getString("rasxod"));
        row.setC4(rs.getString("rasxod_sum"));
        row.setC5(rs.getString("Avg_Count"));
        row.setC6(rs.getString("Avg_Sum"));
        row.setC7(rs.getString("Saldo_Count"));
        row.setC8(rs.getString("Saldo_Sum"));
        row.setC9(rs.getString("days_count"));
        //
        rows.add(row);
      }
      m.addAttribute("rows", rows);
      m.addAttribute("days", days);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(cn);
    }
    return "med/mn/days";
  }

  @RequestMapping("drug/analys.s")
  protected String drugAnalys(HttpServletRequest req, Model m) {
    session = SessionUtil.getUser(req);
    session.setCurUrl("/mn/analys.s");
    Connection cn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    List<ObjList> rows = new ArrayList<ObjList>();
    double summ = 0D, cont = 0D;
    int id = Util.getInt(req, "id");
    try {
      cn = DB.getConnection();
      ps = cn.prepareStatement(
        "Select f.name, " +
          "         c.regDate,   " +
          "         t.counter,   " +
          "         t.countprice,   " +
          "         t.counter * t.countprice summ " +
          "    From drug_act_drugs t, drug_acts c, drug_s_contracts d, drug_s_partners f  " +
          "   Where c.id = t.act_Id   " +
          "     And f.id = d.partner_id " +
          "     And c.contract_id = d.id " +
          "     And t.drug_id = ?");
      ps.setInt(1, id);
      rs = ps.executeQuery();
      while (rs.next()) {
        ObjList r = new ObjList();
        r.setC1(rs.getString("counter"));
        r.setC2(rs.getString("countprice"));
        r.setC3(rs.getString("summ"));
        r.setC4(Util.dateToString(rs.getDate("regDate")));
        r.setC5(rs.getString("name"));
        //
        summ += rs.getDouble("summ");
        cont += rs.getDouble("counter");
        //
        rows.add(r);
      }
      m.addAttribute("inCount", cont);
      m.addAttribute("inSum", summ);
      m.addAttribute("ins", rows);
      rows = new ArrayList<ObjList>();
      summ = 0D;
      cont = 0D;
      ps = cn.prepareStatement(
        " Select ifnull(Sum(c.rasxod), 0) rasxod " +
          "   From patients ds, hn_date_patient_rows c, hn_drugs f, hn_dates d, drug_s_directions ff  " +
          "   Where d.Id = c.doc_Id   " +
          "     And ff.id = d.direction_id" +
          "     And c.drug_Id = f.id   " +
          "     And ds.id = c.patient_id   " +
          "     And c.rasxod > 0   " +
          "     And date(ds.Date_Begin) < DATE_ADD(NOW(), INTERVAL -14 DAY) " +
          "     And f.drug_id = ?");
      ps.setInt(1, id);
      rs = ps.executeQuery();
      while (rs.next()) {
        if(rs.getDouble("rasxod") > 0) {
          ObjList r = new ObjList();
          r.setC1("Предыдущий период ИТОГО");
          r.setC3(rs.getString("rasxod"));
          //
          cont += rs.getDouble("rasxod");
          //
          rows.add(r);
        }
      }
      ps = cn.prepareStatement(
        " Select concat(ds.surname, ' ', ds.name, ' ', ds.middlename) fio, " +
          "          ff.name, " +
          "          d.date, " +
          "          c.rasxod " +
          "   From patients ds, hn_date_patient_rows c, hn_drugs f, hn_dates d, drug_s_directions ff  " +
          "   Where d.Id = c.doc_Id   " +
          "     And ff.id = d.direction_id" +
          "     And c.drug_Id = f.id   " +
          "     And ds.id = c.patient_id   " +
          "     And c.rasxod > 0   " +
          "     And date(ds.Date_Begin) between DATE_ADD(NOW(), INTERVAL -14 DAY) And NOW()   " +
          "     And f.drug_id = ?" +
          "  Order By d.date Desc");
      ps.setInt(1, id);
      rs = ps.executeQuery();
      while (rs.next()) {
        ObjList r = new ObjList();
        r.setC5(rs.getString("name"));
        r.setC1(rs.getString("fio"));
        r.setC2(Util.dateToString(rs.getDate("date")));
        r.setC3(rs.getString("rasxod"));
        //
        cont += rs.getDouble("rasxod");
        //
        rows.add(r);
      }
      m.addAttribute("poutCount", cont);
      m.addAttribute("pouts", rows);
      rows = new ArrayList<ObjList>();
      cont = 0D;
      ps = cn.prepareStatement(
        "Select ff.name receiver, dd.name direction, d.date, c.rasxod  " +
          "    From hn_date_rows c, hn_drugs f, hn_dates d, hn_s_directions ff, drug_s_directions dd  " +
          "    Where d.Id = c.doc_Id   " +
          "      And ff.id = d.receiver_id" +
          "      And dd.id = d.direction_id" +
          "      And c.drug_Id = f.id  " +
          "      And f.drug_id = ?");
      ps.setInt(1, id);
      rs = ps.executeQuery();
      while (rs.next()) {
        ObjList r = new ObjList();
        r.setC5(rs.getString("direction"));
        r.setC4(rs.getString("receiver"));
        r.setC1(Util.dateToString(rs.getDate("date")));
        r.setC2(rs.getString("rasxod"));
        //
        cont += rs.getDouble("rasxod");
        //
        rows.add(r);
      }
      m.addAttribute("outCount", cont);
      m.addAttribute("outs", rows);
      rows = new ArrayList<ObjList>();
      cont = 0D;
      ps = cn.prepareStatement(
        "Select c.fio, t.crOn, t.drugCount, d.name  " +
          "    From hn_drugs t, users c, drug_s_directions d " +
          "   Where t.outRow_id is null " +
          "     And t.drug_id > 0 " +
          "     And d.id = t.direction_id " +
          "     And c.id = t.crBy  " +
          "     And t.drug_id = ?");
      ps.setInt(1, id);
      rs = ps.executeQuery();
      while (rs.next()) {
        ObjList r = new ObjList();
        r.setC5(rs.getString("name"));
        r.setC1(rs.getString("fio"));
        r.setC2(Util.dateToString(rs.getDate("crOn")));
        r.setC3(rs.getString("drugCount"));
        //
        cont += rs.getDouble("drugCount");
        //
        rows.add(r);
      }
      m.addAttribute("ssCount", cont);
      m.addAttribute("sss", rows);
      rows = new ArrayList<ObjList>();
      cont = 0D;
      ps = cn.prepareStatement(
        "Select d.name, Sum(t.drugCount - t.rasxod) counter  " +
          "    From hn_drugs t, drug_s_directions d " +
          "   Where d.id = t.direction_id " +
          "     And t.drugCount - t.rasxod > 0 " +
          "     And t.drug_id = ?" +
          "   Group By d.name");
      ps.setInt(1, id);
      rs = ps.executeQuery();
      while (rs.next()) {
        ObjList r = new ObjList();
        r.setC1(rs.getString("name"));
        r.setC2(rs.getString("counter"));
        //
        cont += rs.getDouble("counter");
        //
        rows.add(r);
      }
      m.addAttribute("ostCount", cont);
      m.addAttribute("osts", rows);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(cn);
    }
    return "med/mn/drug_analys";
  }

  @RequestMapping("/stores.s")
  protected String stores(HttpServletRequest req, Model model) {
    session = SessionUtil.getUser(req);
    session.setCurUrl("/mn/stores.s");
    Connection cn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String startDate = Util.get(req, "period_start", "01" + Util.getCurDate().substring(2));
    String endDate = Util.get(req, "period_end", Util.getCurDate());
    try {
      cn = DB.getConnection();
      List<DrugDirections> directions = dDrugDirection.getAll();
      List<Obj> stores = new ArrayList<Obj>();
      double tprixod = 0, trasxod = 0;
      for(DrugDirections direction: directions) {
        Obj o = new Obj();
        o.setFio(direction.getName());
        o.setPrice(0D);
        o.setClaimCount(0D);
        ps = cn.prepareStatement(
          "Select t.drug_id, " +
            "         c.name, " +
            "         sum(t.drugCount) prixod, " +
            "         sum(t.rasxod) rasxod, " +
            "         sum(t.drugCount - t.rasxod) diff, " +
            "         sum(f.price * t.drugCount) prixod_total, " +
            "         sum(f.price * t.rasxod)  rasxod_total " +
            "  From Hn_Drugs t, Drug_s_Names c, Drug_Out_Rows f  " +
            " Where t.direction_Id = ? " +
            "   And c.id = t.drug_id " +
            "   And f.income_Id > 0 " +
            "   And f.id = t.outRow_id " +
            " Group By t.drug_id");
        ps.setInt(1, direction.getId());
        ps.execute();
        rs = ps.getResultSet();
        List<ObjList> list = new ArrayList<ObjList>();
        while (rs.next()) {
          ObjList obj = new ObjList();
          obj.setC1(rs.getString("name"));
          obj.setC2(rs.getString("prixod"));
          obj.setC3(rs.getString("rasxod"));
          obj.setC4(rs.getString("diff"));
          obj.setC5(rs.getString("prixod_total"));
          obj.setC6(rs.getString("rasxod_total"));
          list.add(obj);
          o.setPrice(o.getPrice() + rs.getDouble("prixod_total"));
          o.setClaimCount(o.getClaimCount() + rs.getDouble("rasxod_total"));
        }
        tprixod += o.getPrice();
        trasxod += o.getClaimCount();
        o.setList(list);
        stores.add(o);
      }
      model.addAttribute("prixod", tprixod);
      model.addAttribute("rasxod", trasxod);
      model.addAttribute("rows", stores);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(cn);
    }
    return "med/mn/stores";
  }

}
