package ckb.controllers.med;

import ckb.dao.admin.depts.DDept;
import ckb.dao.admin.params.DParam;
import ckb.dao.admin.users.DUser;
import ckb.dao.admin.users.DUserDrugLine;
import ckb.dao.med.amb.DAmbDrug;
import ckb.dao.med.amb.DAmbDrugDate;
import ckb.dao.med.amb.DAmbDrugRow;
import ckb.dao.med.amb.DAmbPatient;
import ckb.dao.med.dicts.rooms.DRooms;
import ckb.dao.med.drug.dict.directions.DDrugDirection;
import ckb.dao.med.drug.dict.directions.DDrugDirectionDep;
import ckb.dao.med.drug.dict.drugs.DDrug;
import ckb.dao.med.drug.dict.drugs.counter.DDrugCount;
import ckb.dao.med.drug.dict.drugs.measure.DDrugDrugMeasure;
import ckb.dao.med.drug.out.DDrugOut;
import ckb.dao.med.drug.out.DDrugOutRow;
import ckb.dao.med.eat.dict.menuTypes.DEatMenuType;
import ckb.dao.med.eat.dict.table.DEatTable;
import ckb.dao.med.head_nurse.date.*;
import ckb.dao.med.head_nurse.direction.DHNDirection;
import ckb.dao.med.head_nurse.drug.DHNDrug;
import ckb.dao.med.head_nurse.patient.DHNPatient;
import ckb.dao.med.head_nurse.patient.drugs.DHNPatientDrug;
import ckb.dao.med.nurse.eat.DNurseEatPatient;
import ckb.dao.med.nurse.eat.DNurseEats;
import ckb.dao.med.patient.*;
import ckb.domains.admin.UserDrugLines;
import ckb.domains.admin.Users;
import ckb.domains.med.amb.AmbDrugDates;
import ckb.domains.med.amb.AmbDrugRows;
import ckb.domains.med.amb.AmbPatients;
import ckb.domains.med.dicts.Rooms;
import ckb.domains.med.drug.DrugOutRows;
import ckb.domains.med.drug.DrugOuts;
import ckb.domains.med.drug.dict.DrugDirectionDeps;
import ckb.domains.med.eat.dict.EatMenuTypes;
import ckb.domains.med.eat.dict.EatTables;
import ckb.domains.med.head_nurse.*;
import ckb.domains.med.nurse.eat.NurseEatPatients;
import ckb.domains.med.nurse.eat.NurseEats;
import ckb.domains.med.patient.*;
import ckb.models.Obj;
import ckb.models.ObjList;
import ckb.models.PatientList;
import ckb.models.eat.EatMenuTable;
import ckb.services.med.amb.SAmb;
import ckb.services.med.drug.SDrug;
import ckb.services.med.patient.SPatient;
import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.DB;
import ckb.utils.Req;
import ckb.utils.Util;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;
import java.util.concurrent.TimeUnit;

@Controller
@RequestMapping("/head_nurse/")
public class CHeadNurse {

  private Session session = null;

  //region AUTOWIREDS
  @Autowired private DDrug dDrug;
  @Autowired private DHNPatient dhnPatient;
  @Autowired private DHNPatientDrug dhnPatientDrug;
  @Autowired private DHNDateAmbRow dhnDateAmbRow;
  @Autowired private DDrugCount dDrugCount;
  @Autowired private DUserDrugLine dUserDrugLine;
  @Autowired private DPatient dPatient;
  @Autowired private DDrugOut dDrugOut;
  @Autowired private DDrugOutRow dDrugOutRow;
  @Autowired private DDrugDirection dDrugDirection;
  @Autowired private DPatientDrug dPatientDrug;
  @Autowired private DPatientDrugDate dPatientDrugDate;
  @Autowired private DPatientDrugRow dPatientDrugRow;
  @Autowired private DUser dUser;
  @Autowired private SPatient sPatient;
  @Autowired private DHNDate dhnDate;
  @Autowired private DHNDrug dhnDrug;
  @Autowired private DHNOper dhnOper;
  @Autowired private DHNDirection dhnDirection;
  @Autowired private DHNDatePatientRow dhnDatePatientRow;
  @Autowired private DHNDateRow dhnDateRow;
  @Autowired private DDrugDrugMeasure dDrugDrugMeasure;
  @Autowired private DHNDatePatient dhnDatePatient;
  @Autowired private DDrugDirectionDep dDrugDirectionDep;
  @Autowired private DAmbPatient dAmbPatient;
  @Autowired private SAmb sAmb;
  @Autowired private DAmbDrug dAmbDrug;
  @Autowired private DAmbDrugDate dAmbDrugDate;
  @Autowired private DAmbDrugRow dAmbDrugRow;

  @Autowired private DEatMenuType dEatMenuType;
  @Autowired private DNurseEats dNurseEat;
  @Autowired private DNurseEatPatient dNurseEatPatient;
  @Autowired private DEatTable dEatTable;
  @Autowired private DPatientEat dPatientEat;

  @Autowired private DDept dDept;
  @Autowired private DRooms dRoom;
  @Autowired private SDrug sDrug;
  @Autowired private DParam dParam;
  //endregion

  //region OUT_PATIENT
  @RequestMapping("out/patient.s")
  protected String outPatient(HttpServletRequest req, Model m) {
    session = SessionUtil.getUser(req);
    session.setCurUrl("/head_nurse/out/patient.s");
    //
    String s_dr = session.getFilters("out_patient_direction", "0");
    String dr = Util.get(req, "dr", s_dr);
    session.setFilters("out_patient_direction", dr);
    List<UserDrugLines> lines = dUserDrugLine.getList("From UserDrugLines Where user.id = " + session.getUserId() + (dr.equals("0") ? "" : " And direction.id = " + dr));
    StringBuilder arr = new StringBuilder("(");
    for(UserDrugLines line: lines) {
      arr.append(line.getDirection().getId()).append(",");
    }
    arr.append("0)");
    //
    Calendar end = Calendar.getInstance();
    end.setTime(new Date());
    end.add(Calendar.DATE, 2);
    //
    String db = session.getDateBegin().get("hn_pat_out");
    if(db == null) db = "01" + Util.getCurDate().substring(2);
    String de = session.getDateEnd().get("hn_pat_out");
    if(de == null) de = Util.dateToString(end.getTime());
    //
    String startDate = Util.get(req, "period_start", db);
    String endDate = Util.get(req, "period_end", de);
    //
    HashMap<String, String> dh = session.getDateBegin();
    dh.put("hn_pat_out", startDate);
    session.setDateBegin(dh);
    dh = session.getDateEnd();
    dh.put("hn_pat_out", endDate);
    session.setDateEnd(dh);
    //
    m.addAttribute("rows", dhnDate.getList("From HNDates Where direction.id in " + arr + " And typeCode = 'STAT' And date(date) Between '" + Util.dateDB(startDate) + "' And '" + Util.dateDB(endDate) + "' Order By date Desc"));
    //
    List<UserDrugLines> directions = dUserDrugLine.getList("From UserDrugLines Where user.id = " + session.getUserId());
    m.addAttribute("directions", directions);
    m.addAttribute("filter_direction", dr);
    m.addAttribute("period_start", startDate);
    m.addAttribute("period_end", endDate);
    return "/med/head_nurse/out/patient/index";
  }

  @RequestMapping("out/patient/save.s")
  protected String outPatientSave(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/head_nurse/out/patient/save.s?id=" + Util.getInt(req, "id"));
    //
    List<UserDrugLines> lines = dUserDrugLine.getList("From UserDrugLines Where user.id = " + session.getUserId());
    StringBuilder arr = new StringBuilder("(");
    for(UserDrugLines line: lines) {
      arr.append(line.getDirection().getId()).append(",");
    }
    arr.append("0)");
    try {
      //
      HNDates obj = Util.getInt(req, "id") > 0 ? dhnDate.get(Util.getInt(req, "id")) : new HNDates();
      if(Util.getInt(req, "id") == 0) { obj.setId(0); obj.setDate(new Date()); }
      if(Util.getInt(req, "id") > 0)
        model.addAttribute("drugs", dhnDrug.getList("From HNDrugs t Where t.drugCount - ifnull(t.rasxod, 0) > 0 And t.direction.id = " + obj.getDirection().getId() + " Order BY t.drug.name"));
      model.addAttribute("directions", dUserDrugLine.getList("From UserDrugLines Where user.id = " + session.getUserId()));
      model.addAttribute("rows", dhnDateRow.getList("From HNDatePatientRows Where doc.id = " + obj.getId()));
      List<PatientList> patients = new ArrayList<PatientList>();
      if(obj.getId() != 0) {
        List<HNDatePatients> list = dhnDatePatient.getList("From HNDatePatients Where date.id= " + obj.getId() + " Order By patient.surname");
        for(HNDatePatients pp: list) {
          Patients p = pp.getPatient();
          PatientList o = new PatientList();
          o.setCat(p.getId().toString());
          o.setId(pp.getId());
          o.setIbNum(p.getYearNum() == null ? "" : p.getYearNum() + "");
          o.setFio(p.getSurname() + " " + p.getName() + " " + p.getMiddlename());
          o.setDateBegin(Util.dateToString(p.getDateBegin()));
          o.setDateEnd(Util.dateToString(p.getDateEnd()));
          o.setShowCheckbox(dhnDatePatientRow.getCount("From HNDatePatientRows Where patient.id = " + p.getId() + " And doc.id = " + obj.getId()) > 0);
          if(p.getPalata() == null) {
            if(p.getDept() != null) {
              o.setOtdPal(p.getDept().getName());
            }
            if(p.getRoom() != null) {
              String palata = p.getRoom().getName();
              o.setOtdPal(o.getOtdPal() + ("".equals(o.getOtdPal()) ? "" : "/") + palata);
            }
          } else {
            o.setOtdPal(p.getDept() != null ? p.getDept().getName() + "/" + p.getPalata() : "");
          }
          try {
            o.setMetka(dhnPatient.getObj("From HNPatients Where patient.id = " + p.getId()).getClosed());
          } catch (Exception e) {
            o.setMetka("N");
          }
          patients.add(o);
        }
      }
      model.addAttribute("patients", patients);
      model.addAttribute("obj", obj);
      model.addAttribute("depts", dDept.getAll());
    } catch (Exception e) {
      e.printStackTrace();
    }
    //
    return "/med/head_nurse/out/patient/addEdit";
  }

  @RequestMapping(value = "out/patient/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String outPatientSave(HttpServletRequest req) throws JSONException {
    session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      String id = Util.nvl(req, "id", "0");
      HNDates obj = id.equals("0") || id.equals("") ? new HNDates() : dhnDate.get(Integer.parseInt(id));
      obj.setTypeCode("STAT");
      obj.setDirection(dDrugDirection.get(Util.getInt(req, "direction")));
      obj.setReceiver(null);
      if(obj.getId() == null) {
        obj.setCrBy(dUser.get(session.getUserId()));
        obj.setCrOn(new Date());
        obj.setDate(Util.stringToDate(Util.get(req, "doc_date")));
        obj.setState("ENT");
        if(obj.getDate().before(Util.stringToDate(Util.getCurDate()))) {
          json.put("success", false);
          json.put("msg", "Дата операции не может быть меньше текущей даты");
          return json.toString();
        }
      }
      dhnDate.saveAndReturn(obj);
      json.put("id", obj.getId());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "out/patient/delete.s", method = RequestMethod.POST)
  @ResponseBody
  protected String outPatientDelete(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      int id = Util.getInt(req, "id");
      List<HNDatePatientRows> rows = dhnDatePatientRow.getList("From HNDatePatientRows Where doc.id = " + id);
      if(rows.size() > 0)
        return Util.err(json, "Нельзя удалить документ! Документ имеет записи");
      dhnDate.delete(id);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("out/patient/drugs.s")
  protected String outPatientDrugs(HttpServletRequest req, Model m) {
    Date minDate = dPatientDrugDate.minDate(Util.getInt(req, "id"));
    Date maxDate = dPatientDrugDate.maxDate(Util.getInt(req, "id"));
    if(minDate != null) {
      long diffInMillies = Math.abs(maxDate.getTime() - minDate.getTime());
      long diff = TimeUnit.DAYS.convert(diffInMillies, TimeUnit.MILLISECONDS) + 2;
      m.addAttribute("dates", Util.getDateList(minDate, (int) (diff)));
    }
    m.addAttribute("doc", dhnDate.get(Util.getInt(req, "doc")));
    m.addAttribute("drugs", sPatient.getPatientDrugs(Util.getInt(req, "id")));
    return "/med/head_nurse/out/patient/drugs";
  }

  @RequestMapping(value = "out/row/patient/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String outPatientRowSave(HttpServletRequest req) throws JSONException {
    session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      double rasxod = Double.parseDouble(Util.get(req, "rasxod"));
      if(Util.isNull(req, "edit")) {
        HNDatePatientRows row = new HNDatePatientRows();
        row.setDrug(dhnDrug.get(Util.getInt(req, "id")));
        row.setDoc(dhnDate.get(Util.getInt(req, "doc")));
        row.setRasxod(rasxod);
        row.setDate(row.getDoc().getDate());
        row.setPatient(dPatient.get(Util.getInt(req, "patient")));
        row.setMeasure(row.getDrug().getMeasure());
        row.setCrBy(session.getUserId());
        row.setCrOn(new Date());
        sDrug.hndrug_rasxod(row.getDrug().getId(), row.getRasxod());
        dhnDatePatientRow.save(row);
      } else {
        HNDatePatientRows row = dhnDatePatientRow.get(Util.getInt(req, "id"));
        sDrug.hndrug_rasxod(row.getDrug().getId(), rasxod - row.getRasxod());
        if(rasxod == 0) {
          dhnDatePatientRow.delete(row.getId());
        } else {
          row.setRasxod(rasxod);
          dhnDatePatientRow.save(row);
        }
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "out/row/patient/saves.s", method = RequestMethod.POST)
  @ResponseBody
  protected String outPatientRowSaves(HttpServletRequest req) throws JSONException {
    session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      //
      String[] ids = req.getParameterValues("ids");
      if(ids != null) {
        for (String id : ids) {
          String hid = Util.get(req, "drug_" + id);
          String rasxod = Util.get(req, "drug_count_" + id);
          if (hid != null && rasxod != null && !hid.equals("") && !rasxod.equals("") && Double.parseDouble(rasxod) > 0) {
            HNDatePatientRows row = new HNDatePatientRows();
            row.setDrug(dhnDrug.get(Integer.parseInt(hid)));
            row.setDoc(dhnDate.get(Util.getInt(req, "doc")));
            row.setRasxod(Double.parseDouble(rasxod));
            row.setDate(row.getDoc().getDate());
            row.setPatient(dPatient.get(Util.getInt(req, "patient")));
            row.setMeasure(row.getDrug().getMeasure());
            row.setCrBy(session.getUserId());
            row.setCrOn(new Date());
            sDrug.hndrug_rasxod(row.getDrug().getId(), row.getRasxod());
            dhnDatePatientRow.save(row);
          }
        }
      }
      //
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("out/patient/list.s")
  protected String outPatientDrugsList(HttpServletRequest req, Model m) {
    session = SessionUtil.getUser(req);
    HNDates doc = dhnDate.get(Util.getInt(req, "id"));
    m.addAttribute("doc", doc);
    Patients pat = dPatient.get(Util.getInt(req, "patient"));
    m.addAttribute("pat", pat);
    Calendar end = Calendar.getInstance();
    end.setTime(new Date());
    end.add(Calendar.DATE, session.getUserId() == 1 ? -10 : -5);
    m.addAttribute("canReturn", (pat.getPaid() == null || !pat.getPaid().equals("CLOSED")) && "CON".equals(doc.getState()) && doc.getDate().after(end.getTime()));
    m.addAttribute("drugs", dhnDatePatientRow.getList("From HNDatePatientRows Where drug.direction.id = " + doc.getDirection().getId() + " And doc.id = " + doc.getId() + " And patient.id = " + Util.get(req, "patient")));
    //
    return "/med/head_nurse/out/patient/list";
  }

  @RequestMapping("out/patient/addDrug.s")
  protected String outPatientAddDrug(HttpServletRequest req, Model m) {
    m.addAttribute("drugs", dhnDrug.getList("From HNDrugs t Where direction.id = " + Util.getInt(req, "dr")+ " And t.drugCount - ifnull(t.rasxod, 0) > 0 And drug.id = " + Util.getInt(req, "id")));
    //
    PatientDrugs drug = dPatientDrug.get(Util.getInt(req, "pd"));
    PatientDrugRows row = dPatientDrugRow.get(Util.getInt(req, "row"));
    m.addAttribute("counter", (drug.isMorningTime() ? row.getExpanse() : 0) + (drug.isNoonTime() ? row.getExpanse() : 0) + (drug.isEveningTime() ? row.getExpanse() : 0));
    return "/med/head_nurse/out/patient/addDrug";
  }

  @RequestMapping("out/patient/addDateDrugs.s")
  protected String outPatientAddDrugs(HttpServletRequest req, Model m) {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      Date minDate = dPatientDrugDate.minDate(Util.getInt(req, "id"));
      Date maxDate = dPatientDrugDate.maxDate(Util.getInt(req, "id"));
      //
      long diffInMillies = Math.abs(maxDate.getTime() - minDate.getTime());
      long diff = TimeUnit.DAYS.convert(diffInMillies, TimeUnit.MILLISECONDS) + 2;
      List<String> dates = Util.getListDates(minDate, (int) (diff));
      String d = "";
      for (String dt : dates) {
        if (dt.contains(Util.get(req, "dt")))
          d = dt;
      }
      //
      List<PatientDrugDates> dds = dPatientDrugDate.getList("From PatientDrugDates Where checked = 1 And patientDrug.patient.id = " + Util.get(req, "id") + " And date = '" + Util.dateDB(d) + "'");
      List<Obj> drugs = new ArrayList<>();
      conn = DB.getConnection();
      ps = conn.prepareStatement(
        "Select g.drug_Id, " +
          "       d.Name Drug_Name, " +
          "       Sum((Case When t.morningTime = 1 Then g.expanse Else 0 End) + (Case When t.noonTime = 1 Then g.expanse Else 0 End) + (Case When t.eveningTime = 1 Then g.expanse Else 0 End)) Rasxod " +
          "  From Patient_Drugs t, Patient_Drug_Dates c, Patient_Drug_Rows g, Drug_s_Names d " +
          " Where t.patient_Id = " + Util.get(req, "id") +
          "   And c.patientDrug_Id = t.id " +
          "   And g.patientDrug_Id = t.id " +
          "   And date(c.date) = '" + Util.dateDB(d) + "' " +
          "   And c.checked = 1 " +
          "   And g.source != 'own' " +
          "   And d.id = g.drug_Id " +
          " Group By g.drug_Id, d.Name"
      );
      rs = ps.executeQuery();
      while (rs.next()) {
        Obj obj = new Obj();
        obj.setId(rs.getInt("drug_id"));
        obj.setName(rs.getString("drug_name"));
        List<HNDrugs> ffs = dhnDrug.getList("From HNDrugs t Where direction.id = " + Util.getInt(req, "dr") + " And t.drugCount - ifnull(t.rasxod, 0) > 0 And drug.id = " + obj.getId());
        List<ObjList> list = new ArrayList<ObjList>();
        for (HNDrugs ff : ffs) {
          ObjList o = new ObjList();
          o.setC1(ff.getId().toString());
          o.setC2(obj.getName() + " (Остаток: " + (ff.getDrugCount() - ff.getRasxod()) + ")");
          o.setC3(ff.getMeasure().getName());
          o.setC4((ff.getDrugCount() - ff.getRasxod()) + "");
          o.setC5("" + rs.getDouble("rasxod"));
          list.add(o);
        }
        obj.setList(list);
        drugs.add(obj);
      }
      m.addAttribute("drugs", drugs);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(conn);
    }
    //
    return "/med/head_nurse/out/patient/addDrugs";
  }

  @RequestMapping("out/patient/add/list.s")
  protected String outPatientAddList(HttpServletRequest req, Model m) {
    HNDates date = dhnDate.get(Util.getInt(req, "id"));
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      String dept = Util.get(req, "dept", "0");
      conn = DB.getConnection();
      session = SessionUtil.getUser(req);
      Users user = dUser.get(session.getUserId());
      List<DrugDirectionDeps> deps = dDrugDirectionDep.getList("From DrugDirectionDeps Where direction.id = " + date.getDirection().getId());
      String depIds = "0,";
      if(deps != null && deps.size() > 0) {
        for (DrugDirectionDeps dep : deps)
          depIds += dep.getDept().getId() + ",";
      }
      depIds = depIds.substring(0, depIds.length() - 1);
      ps = conn.prepareStatement("Select * From Patients t Where " + (dept.equals("0") ? "" : " t.dept_id = " + dept + " And ") + (depIds.equals("0") ? "" : " t.dept_id in (" + depIds + ") And") + " t.date_begin <= '" + Util.dateDB(Util.dateToString(date.getDate())) + "' And (t.date_end >= '" + Util.dateDB(Util.dateToString(date.getDate())) + "' Or t.date_end is null) And t.state in ('LV', 'ZGV', 'ARCH') And id not in (Select c.patient_id From HN_Date_Patients c Where c.date_id = ?) Order By surname");
      ps.setInt(1, date.getId());
      rs = ps.executeQuery();
      List<PatientList> pats = new ArrayList<PatientList>();
      while (rs.next()) {
        PatientList o = new PatientList();
        o.setId(rs.getInt("id"));
        o.setFio(rs.getString("surname") + " " + rs.getString("name") + " " + rs.getString("middlename"));
        o.setIbNum(rs.getString("yearNum"));
        o.setDateBegin(Util.dateToString(rs.getDate("date_begin")));
        o.setDateEnd(Util.dateToString(rs.getDate("date_end")));
        o.setLv(rs.getInt("lv_id") != 0 ? dUser.get(rs.getInt("lv_id")).getFio() : "");
        if(rs.getString("palata") == null) {
          if(rs.getString("Dept_Id") != null) {
            o.setOtdPal(dDept.get(rs.getInt("Dept_Id")).getName());
          }
          if(rs.getString("Room_Id") != null) {
            Rooms room = dRoom.get(rs.getInt("room_id"));
            String palata = room.getName() + "-" + room.getRoomType().getName();
            o.setOtdPal(o.getOtdPal() + ("".equals(o.getOtdPal()) ? "" : " / ") + palata);
          }
        } else {
          o.setOtdPal(rs.getInt("Dept_Id") != 0 ? dDept.get(rs.getInt("Dept_Id")).getName() + " / " + rs.getString("palata") : "");
        }
        pats.add(o);
      }
      m.addAttribute("rows", pats);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(conn);
    }
    //
    return "/med/head_nurse/out/patient/patientList";
  }

  @RequestMapping(value = "out/row/patient/add.s", method = RequestMethod.POST)
  @ResponseBody
  protected String outPatientAdd(HttpServletRequest req) throws JSONException {
    session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      if(dhnDatePatient.getCount("From HNDatePatients Where date.id = " + Util.get(req, "id") + " And patient.id = " + Util.get(req, "patient")) == 0) {
        HNDatePatients pat = new HNDatePatients();
        pat.setDate(dhnDate.get(Util.getInt(req, "id")));
        pat.setPatient(dPatient.get(Util.getInt(req, "patient")));
        dhnDatePatient.save(pat);
      }
      json.put("msg", "Данные успешно сохранены");
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "out/row/patient/del.s", method = RequestMethod.POST)
  @ResponseBody
  protected String outPatientDel(HttpServletRequest req) throws JSONException {
    session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      HNDatePatients dp = dhnDatePatient.get(Util.getInt(req, "id"));
      if(dhnDatePatientRow.getCount("From HNDatePatientRows Where doc.id = " + dp.getDate().getId() + " And patient.id = " + dp.getPatient().getId()) != 0)
        return Util.err(json, "Нельзя удалить данные! По данному пациенту существует списание препаратов");
      dhnDatePatient.delete(dp.getId());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "out/patient/row/delete.s", method = RequestMethod.POST)
  @ResponseBody
  protected String outPatientRowDelete(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      HNDatePatientRows row = dhnDatePatientRow.get(Util.getInt(req, "id"));
      sDrug.hndrug_rasxod(row.getDrug().getId(), -row.getRasxod());
      dhnDatePatientRow.delete(row.getId());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("out/patient/report.s")
  protected String outPatientReport(HttpServletRequest req, Model m) {
    session = SessionUtil.getUser(req);
    //
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      conn = DB.getConnection();
      ps = conn.prepareStatement(
        "Select d.name, m.name measure, Sum(t.rasxod) summ From Hn_Date_Patient_Rows t, HN_Drugs c, Drug_s_Names d, Drug_s_Measures m Where m.id = t.measure_id And t.drug_id = c.id And c.drug_id = d.id And t.doc_id = ? Group By d.Name Order By d.name, m.name"
      );
      ps.setInt(1, Util.getInt(req, "id"));
      rs = ps.executeQuery();
      List<ObjList> list = new ArrayList<ObjList>();
      while (rs.next()) {
        ObjList obj = new ObjList();
        obj.setC1(rs.getString("name"));
        obj.setC2(rs.getDouble("summ") + "");
        obj.setC3(rs.getString("measure"));
        list.add(obj);
      }
      m.addAttribute("rows", list);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(conn);
    }
    //
    return "/med/head_nurse/out/patient/report";
  }

  @RequestMapping("out/patient/info.s")
  protected String outPatientTotal(HttpServletRequest req, Model model){
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    List<ObjList> list = new ArrayList<ObjList>();
    try {
      int id = Util.getInt(req, "id");
      conn = DB.getConnection();
      ps = conn.prepareStatement(
        " Select d.name, m.name measure, Sum(t.rasxod) summ " +
          " From Hn_Date_Patient_Rows t, HN_Drugs c, Drug_s_Names d, Drug_s_Measures m " +
          " Where m.id = t.measure_id And t.drug_id = c.id And c.drug_id = d.id And t.patient_id = ? " +
          " Group By d.Name, m.name"
      );
      ps.setInt(1, id);
      rs = ps.executeQuery();
      while (rs.next()) {
        ObjList obj = new ObjList();
        obj.setC1(rs.getString("name"));
        obj.setC2(rs.getDouble("summ") + "");
        obj.setC3(rs.getString("measure"));
        list.add(obj);
      }
      model.addAttribute("rows", list);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(conn);
    }
    return "/med/head_nurse/out/patient/total";
  }
  //endregion

  //region OUT
  @RequestMapping("out.s")
  protected String out(HttpServletRequest req, Model m) {
    session = SessionUtil.getUser(req);
    session.setCurUrl("/head_nurse/out.s");
    String s_dr = session.getFilters("hn_out_direction", "0");
    String dr = Util.get(req, "dr", s_dr);
    session.setFilters("hn_out_direction", dr);
    List<UserDrugLines> lines = dUserDrugLine.getList("From UserDrugLines Where user.id = " + session.getUserId() + (dr.equals("0") ? "" : " And direction.id = " + dr));
    StringBuilder arr = new StringBuilder("(");
    for(UserDrugLines line: lines) {
      arr.append(line.getDirection().getId()).append(",");
    }
    arr.append("0)");
    //
    Calendar end = Calendar.getInstance();
    end.setTime(new Date());
    end.add(Calendar.DATE, 2);
    //
    String db = session.getDateBegin().get("hn_out");
    if(db == null) db = "01" + Util.getCurDate().substring(2);
    String de = session.getDateEnd().get("hn_out");
    if(de == null) de = Util.dateToString(end.getTime());
    //
    String startDate = Util.get(req, "period_start", db);
    String endDate = Util.get(req, "period_end", de);
    //
    HashMap<String, String> dh = session.getDateBegin();
    dh.put("hn_out", startDate);
    session.setDateBegin(dh);
    dh = session.getDateEnd();
    dh.put("hn_out", endDate);
    session.setDateEnd(dh);
    //
    m.addAttribute("rows", dhnDate.getList("From HNDates Where direction.id in " + arr + " And date(date) Between '" + Util.dateDB(startDate) + "' And '" + Util.dateDB(endDate) + "' And typeCode = 'OUT' Order By date Desc"));
    //
    List<UserDrugLines> directions = dUserDrugLine.getList("From UserDrugLines Where user.id = " + session.getUserId());
    m.addAttribute("directions", directions);
    m.addAttribute("filter_direction", dr);
    m.addAttribute("period_start", startDate);
    m.addAttribute("period_end", endDate);
    return "/med/head_nurse/out/index";
  }

  @RequestMapping("out/save.s")
  protected String outSave(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/head_nurse/out/save.s?id=" + Util.getInt(req, "id"));
    //
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    //
    List<UserDrugLines> lines = dUserDrugLine.getList("From UserDrugLines Where user.id = " + session.getUserId());
    StringBuilder arr = new StringBuilder("(");
    for(UserDrugLines line: lines) {
      arr.append(line.getDirection().getId()).append(",");
    }
    arr.append("0)");
    try {
      conn = DB.getConnection();
      //
      HNDates obj = Util.getInt(req, "id") > 0 ? dhnDate.get(Util.getInt(req, "id")) : new HNDates();
      if(Util.getInt(req, "id") == 0) {
        obj.setId(0);
        obj.setDate(new Date());
      }
      model.addAttribute("drugs", dhnDrug.getList("From HNDrugs t Where t.drugCount - ifnull(t.rasxod, 0) > 0 And direction.id = " + (obj.getId() == 0 ? 0 : obj.getDirection().getId())  + " Order By t.drug.name"));
      model.addAttribute("directions", dUserDrugLine.getList("From UserDrugLines Where user.id = " + session.getUserId()));

      model.addAttribute("receivers", dhnDirection.getList("From HNDirections t Where Exists (Select 1 From HNDirectionLinks c where c.rasxod = t.id And c.direction in " + arr + ")"));
      model.addAttribute("rows", dhnDateRow.getList("From HNDateRows Where doc.id = " + obj.getId()));
      model.addAttribute("obj", obj);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(conn);
    }
    //
    return "/med/head_nurse/out/addEdit";
  }

  @RequestMapping(value = "out/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String outSave(HttpServletRequest req) throws JSONException {
    session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      String id = Util.nvl(req, "id", "0");
      HNDates obj = id.equals("0") || id.equals("") ? new HNDates() : dhnDate.get(Integer.parseInt(id));
      obj.setDirection(dDrugDirection.get(Util.getInt(req, "direction")));
      obj.setReceiver(dhnDirection.get(Util.getInt(req, "receiver")));
      obj.setTypeCode("OUT");
      if(obj.getId() == null) {
        obj.setCrBy(dUser.get(session.getUserId()));
        obj.setCrOn(new Date());
        obj.setDate(Util.stringToDate(Util.get(req, "doc_date")));
        obj.setState("ENT");
      }
      dhnDate.saveAndReturn(obj);
      json.put("id", obj.getId());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "out/return.s", method = RequestMethod.POST)
  @ResponseBody
  protected String outReturn(HttpServletRequest req) throws JSONException {
    session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      String id = Util.nvl(req, "id", "0");
      HNDates obj = dhnDate.get(Integer.parseInt(id));
      obj.setState("ENT");
      dhnDate.saveAndReturn(obj);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "out/row/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String outRowSave(HttpServletRequest req) throws JSONException {
    session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      double rasxod = Double.parseDouble(Util.get(req, "rasxod"));
      if(Util.isNull(req, "edit")) {
        HNDateRows row = new HNDateRows();
        row.setDrug(dhnDrug.get(Util.getInt(req, "id")));
        row.setDoc(dhnDate.get(Util.getInt(req, "doc")));
        row.setRasxod(rasxod);
        row.setCrBy(session.getUserId());
        row.setCrOn(new Date());
        sDrug.hndrug_rasxod(row.getDrug().getId(), row.getRasxod());
        dhnDateRow.save(row);
      } else {
        HNDateRows row = dhnDateRow.get(Util.getInt(req, "id"));
        sDrug.hndrug_rasxod(row.getDrug().getId(), rasxod - row.getRasxod());
        row.setRasxod(rasxod);
        dhnDateRow.save(row);
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "out/row/delete.s", method = RequestMethod.POST)
  @ResponseBody
  protected String outRowDelete(HttpServletRequest req) throws JSONException {
    session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      HNDateRows row = dhnDateRow.get(Util.getInt(req, "id"));
      sDrug.hndrug_rasxod(row.getDrug().getId(), -row.getRasxod());
      dhnDateRow.delete(row.getId());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "out/delete.s", method = RequestMethod.POST)
  @ResponseBody
  protected String outDelete(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      int id = Util.getInt(req, "id");
      List<HNDateRows> rows = dhnDateRow.getList("From HNDateRows Where doc.id = " + id);
      for(HNDateRows row: rows) {
        sDrug.hndrug_rasxod(row.getDrug().getId(), -row.getRasxod());
        dhnDateRow.delete(row.getId());
      }
      dhnDate.delete(id);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "out/confirm.s", method = RequestMethod.POST)
  @ResponseBody
  protected String outConfirm(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      HNDates doc = dhnDate.get(Util.getInt(req, "id"));
      if(doc.getReceiver() == null) {
        if(doc.getPatient() == null) {
          if (dhnDatePatientRow.getCount("From HNDatePatientRows Where doc.id = " + doc.getId()) == 0) {
            json.put("success", false);
            json.put("msg", "Нельзя подтвердить документ без записи");
            return json.toString();
          }
        } else {
          if (dhnDateAmbRow.getCount("From HNDateAmbRows Where doc.id = " + doc.getId()) == 0) {
            json.put("success", false);
            json.put("msg", "Нельзя подтвердить документ без записи");
            return json.toString();
          }
        }
        conn = DB.getConnection();
        ps = conn.prepareStatement("Select t.id From Hn_Date_Patients t Where t.date_id = ? And t.patient_id not in (Select c.patient_id From Hn_Date_Patient_Rows c Where c.doc_id = ?)");
        ps.setInt(1, doc.getId());
        ps.setInt(2, doc.getId());
        rs = ps.executeQuery();
        while (rs.next()) {
          dhnDatePatient.delete(rs.getInt(1));
        }
      } else {
        if(dhnDateRow.getCount("From HNDateRows Where doc.id = " + doc.getId()) == 0) {
          json.put("success", false);
          json.put("msg", "Нельзя подтвердить документ без записи");
          return json.toString();
        }
      }
      doc.setState("CON");
      dhnDate.save(doc);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(conn);
    }
    return json.toString();
  }
  //endregion

  //region SALDO
  @RequestMapping("saldo.s")
  protected String saldo(HttpServletRequest req, Model m) {
    session = SessionUtil.getUser(req);
    session.setCurUrl("/head_nurse/saldo.s");
    String page_code = Util.get(req, "code", "saldo");
    String filter = Util.get(req, "filter", "");
    String direction = Util.get(req, "direction", "0");
    //
    List<UserDrugLines> lines = dUserDrugLine.getList("From UserDrugLines Where user.id = " + session.getUserId());
    StringBuilder arr = new StringBuilder("(");
    for(UserDrugLines line: lines) {
      if(direction.equals("0") || direction.equals(""))
        arr.append(line.getDirection().getId()).append(",");
      else if(direction.equals(line.getDirection().getId().toString()))
        arr.append(line.getDirection().getId()).append(",");
    }
    arr.append("0)");
    //
    List<HNDrugs> drugs = dhnDrug.getList("From HNDrugs Where " + (filter.equals("") ? "" : " Upper(drug.name) like '%" + filter.toUpperCase() + "%' And ") + " drugCount != 0 " + (page_code.equals("saldo") ? " And drugCount - ifnull(rasxod, 0) > 0" :"") + " And direction.id in " + arr + " Order By direction.id, drug.name");
    m.addAttribute("rows", drugs);
    m.addAttribute("drugs", dDrug.getList("From Drugs Order By name"));
    m.addAttribute("receivers", lines);
    m.addAttribute("filter_direction", direction);
    m.addAttribute("filter_word", filter);
    m.addAttribute("page_code", page_code);
    m.addAttribute("sysdate", new Date());
    return "/med/head_nurse/saldo/index";
  }

  @RequestMapping("saldo/excel.s")
  protected String saldo_excel(HttpServletRequest req, Model m) {
    Session session = SessionUtil.getUser(req);
    String page_code = Util.get(req, "code", "saldo");
    String filter = Util.get(req, "filter", "");
    String direction = Util.get(req, "direction", "0");
    //
    List<UserDrugLines> lines = dUserDrugLine.getList("From UserDrugLines Where user.id = " + session.getUserId());
    StringBuilder arr = new StringBuilder("(");
    for(UserDrugLines line: lines) {
      if(direction.equals("0") || direction.equals(""))
        arr.append(line.getDirection().getId()).append(",");
      else if(direction.equals(line.getDirection().getId().toString()))
        arr.append(line.getDirection().getId()).append(",");
    }
    arr.append("0)");
    //
    List<HNDrugs> drugs = dhnDrug.getList("From HNDrugs Where " + (filter.equals("") ? "" : " Upper(drug.name) like '%" + filter.toUpperCase() + "%' And ") + " drugCount != 0 " + (page_code.equals("saldo") ? " And drugCount - ifnull(rasxod, 0) > 0" :"") + " And direction.id in " + arr + " Order By direction.id, drug.name");
    m.addAttribute("rows", drugs);
    m.addAttribute("header_title", "Остаток на " + Util.getCurDate() + " " + Util.getCurTime());
    return "/med/head_nurse/saldo/excel";
  }
  //endregion

  //region INCOMES
  @RequestMapping("incomes.s")
  protected String incomes(HttpServletRequest req, Model m) {
    session = SessionUtil.getUser(req);
    session.setCurUrl("/head_nurse/incomes.s");
    //
    String s_dr = session.getFilters("income_direction", "0");
    String dr = Util.get(req, "dr", s_dr);
    session.setFilters("income_direction", dr);
    //
    String s_ins_flag = session.getFilters("income_ins_flag", "0");
    String ins_flag = Util.get(req, "ins_flag", s_ins_flag);
    session.setFilters("income_ins_flag", ins_flag);
    //
    List<UserDrugLines> lines = dUserDrugLine.getList("From UserDrugLines Where user.id = " + session.getUserId() + (dr.equals("0") ? "" : " And direction.id = " + dr));
    StringBuilder arr = new StringBuilder("(");
    for(UserDrugLines line: lines) {
      arr.append(line.getDirection().getId()).append(",");
    }
    arr.append("0)");
    //
    String db = session.getDateBegin().get("hn_income");
    if(db == null) db = "01" + Util.getCurDate().substring(2);
    String de = session.getDateEnd().get("hn_income");
    if(de == null) de = Util.getCurDate();
    //
    String startDate = Util.get(req, "period_start", db);
    String endDate = Util.get(req, "period_end", de);
    //
    HashMap<String, String> dh = session.getDateBegin();
    dh.put("hn_income", startDate);
    session.setDateBegin(dh);
    dh = session.getDateEnd();
    dh.put("hn_income", endDate);
    session.setDateEnd(dh);
    //
    List<DrugOuts> acts = dDrugOut.getList("From DrugOuts Where direction.id in " + arr + " And date(regDate) Between '" + Util.dateDB(startDate) + "' And '" + Util.dateDB(endDate) + "' " + (!ins_flag.equals("0") ? " And insFlag = '" + ins_flag + "'" : "") + " Order By id Desc");
    List<ObjList> list = new ArrayList<ObjList>();
    //
    for(DrugOuts act : acts) {
      ObjList obj = new ObjList();
      obj.setIb(act.getId().toString());
      obj.setC1("№" + act.getRegNum() + " от " + Util.dateToString(act.getRegDate()));
      obj.setC2(dDrugOutRow.getCount("From DrugOutRows Where doc.id = " + act.getId()).toString());
      if(act.getId() != null) {
        Double sum = dDrugOutRow.getActSum(act.getId());
        obj.setC3("" + (sum == null ? 0 : sum));
      } else {
        obj.setC3("0");
      }
      obj.setC5(act.getState());
      if(act.getDirection() != null)
        obj.setC6(act.getDirection().getName());
      else
        obj.setC6("");
      obj.setC7(Util.dateTimeToString(act.getCrOn()));
      obj.setC8(Util.dateTimeToString(act.getSendOn()));
      obj.setC9(Util.dateTimeToString(act.getConfirmOn()));
      obj.setC10(act.getInsFlag());
      list.add(obj);
    }
    //
    List<UserDrugLines> directions = dUserDrugLine.getList("From UserDrugLines Where user.id = " + session.getUserId());
    m.addAttribute("directions", directions);
    m.addAttribute("filter_direction", dr);
    m.addAttribute("ins_flag", ins_flag);
    m.addAttribute("rows", list);
    m.addAttribute("period_start", startDate);
    m.addAttribute("period_end", endDate);
    //
    return "/med/head_nurse/incomes/index";
  }

  @RequestMapping("incomes/save.s")
  protected String incomeSave(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/head_nurse/incomes/save.s?id=" + Util.getInt(req, "id"));
    //
    DrugOuts obj = Util.getInt(req, "id") > 0 ? dDrugOut.get(Util.getInt(req, "id")) : new DrugOuts();
    if(Util.getInt(req, "id") == 0) obj.setId(0);
    model.addAttribute("rows", dDrugOutRow.getList("From DrugOutRows t Where t.doc.id = " + obj.getId()));
    if(obj.getId() == 0) {
      obj.setRegDate(new Date());
    }
    List<UserDrugLines> lines = dUserDrugLine.getList("From UserDrugLines Where user.id = " + session.getUserId() + " And (direction.shock != 'Y' Or direction.shock = null)");
    model.addAttribute("directions", lines);
    model.addAttribute("measures", dDrugDrugMeasure.getList("From DrugDrugMeasures Order By measure.name"));
    model.addAttribute("drugs", dDrug.getList("From Drugs t Where Exists (Select 1 From DrugActDrugs c Where c.done = 'N' And c.counter - c.rasxod > 0 And c.act.state != 'E' And c.drug.id = t.id) Order By name"));
    model.addAttribute("obj", obj);
    Util.makeMsg(req, model);
    return "/med/head_nurse/incomes/addEdit";
  }

  @RequestMapping(value = "incomes/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String incomeSave(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      String id = Util.nvl(req, "id", "0");
      DrugOuts obj = id.equals("0") || id.equals("") ? new DrugOuts() : dDrugOut.get(Integer.parseInt(id));
      obj.setRegNum(Util.get(req, "reg_num"));
      obj.setDirection(dDrugDirection.get(Util.getInt(req, "direction")));
      obj.setRegDate(Util.getDate(req, "reg_date"));
      obj.setState("ENT");
      obj.setCrOn(obj.getId() == null ? new Date() : obj.getCrOn());
      obj.setInfo(Util.get(req, "info"));
      obj.setInsFlag("N");
      if(dDrugOut.getCount("From DrugOuts Where direction.id = " + obj.getDirection().getId() + " And insFlag = 'N' And id != " + obj.getId()) > 0)
        return Util.err(json, "Есть не принятые документы по данному Складу");
      dDrugOut.saveAndReturn(obj);
      json.put("id", obj.getId());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "incomes/drop.s", method = RequestMethod.POST)
  @ResponseBody
  protected String dropIncome(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    DrugOuts doc = dDrugOut.get( Util.getInt(req, "id"));
    try {
      List<DrugOutRows> rows = dDrugOutRow.getList("From DrugOutRows t Where t.doc.id = " + doc.getId());
      for(DrugOutRows row: rows) {
        if(row.getHndrug() == null || row.getHndrug() == 0) {
          if (row.getDrugCount() != null && row.getDrugCount() > 0) {
            HNDrugs drug = new HNDrugs();
            drug.setDrug(row.getDrug());
            drug.setDirection(row.getDoc().getDirection());
            drug.setOutRow(row);
            drug.setDrugCount(row.getDrugCount());
            drug.setMeasure(row.getMeasure());
            drug.setRasxod(0D);
            drug.setPrice(row.getPrice());
            drug.setNdsProc(row.getIncome().getNdsProc());
            drug.setNds(row.getIncome().getNds());
            drug.setCrBy(session.getUserId());
            drug.setCrOn(new Date());
            drug.setHistory(0);
            dhnDrug.saveAndReturn(drug);
            row.setHndrug(drug.getId());
            dDrugOutRow.save(row);
          }
        }
      }
      doc.setInsFlag("Y");
      dDrugOut.save(doc);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "incomes/del.s", method = RequestMethod.POST)
  @ResponseBody
  protected String incomeDel(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      List<DrugOutRows> rows = dDrugOutRow.getList("From DrugOutRows Where doc.id = " + Util.getInt(req, "id"));
      for(DrugOutRows row : rows)
        dDrugOutRow.delete(row.getId());
      dDrugOut.delete(Util.getInt(req, "id"));
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/incomes/row/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String incomeRowSave(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      DrugOutRows row = new DrugOutRows();
      row.setDoc(dDrugOut.get(Util.getInt(req, "doc")));
      row.setClaimCount(Double.parseDouble(Util.get(req, "drug_count")));
      row.setDrug(dDrug.get(Util.getInt(req, "drug_id")));
      row.setMeasure(row.getDrug().getMeasure());
      row.setCrBy(session.getUserId());
      row.setCrOn(new Date());
      dDrugOutRow.save(row);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/incomes/row/del.s", method = RequestMethod.POST)
  @ResponseBody
  protected String incomeRowDel(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      dDrugOutRow.delete(Util.getInt(req, "id"));
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/incomes/confirm.s", method = RequestMethod.POST)
  @ResponseBody
  protected String confirmIncome(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      DrugOuts income = dDrugOut.get(Util.getInt(req, "id"));
      long counter = dDrugOutRow.getCount("From DrugOutRows Where doc.id = " + income.getId());
      if(counter == 0) {
        json.put("success", false);
        json.put("msg", "Нельзя подтвердить пустую заявку!");
        return json.toString();
      }
      income.setState("SND");
      income.setSendOn(new Date());
      dDrugOut.save(income);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }
  //endregion

  //region Перевод
  @RequestMapping("transfer.s")
  protected String shock(HttpServletRequest req, Model m) {
    session = SessionUtil.getUser(req);
    session.setCurUrl("/head_nurse/transfer.s");
    String s_dr = session.getFilters("trasfer_direction", "0");
    String dr = Util.get(req, "dr", s_dr);
    session.setFilters("trasfer_direction", dr);
    //
    List<UserDrugLines> lines = dUserDrugLine.getList("From UserDrugLines Where user.id = " + session.getUserId() + (dr.equals("0") ? "" : " And direction.id = " + dr));
    StringBuilder arr = new StringBuilder("(");
    for(UserDrugLines line: lines) {
      arr.append(line.getDirection().getId()).append(",");
    }
    arr.append("0)");
    //
    Calendar end = Calendar.getInstance();
    end.setTime(new Date());
    end.add(Calendar.DATE, 2);
    //
    String db = session.getDateBegin().get("hn_shock");
    if(db == null) db = "01" + Util.getCurDate().substring(2);
    String de = session.getDateEnd().get("hn_shock");
    if(de == null) de = Util.dateToString(end.getTime());
    //
    String startDate = Util.get(req, "period_start", db);
    String endDate = Util.get(req, "period_end", de);
    //
    HashMap<String, String> dh = session.getDateBegin();
    dh.put("hn_shock", startDate);
    session.setDateBegin(dh);
    dh = session.getDateEnd();
    dh.put("hn_shock", endDate);
    session.setDateEnd(dh);
    //
    m.addAttribute("rows", dhnDate.getList("From HNOpers Where (parent.id in " + arr + " Or direction.id in " + arr + ") And date(date) Between '" + Util.dateDB(startDate) + "' And '" + Util.dateDB(endDate) + "' Order By crOn Desc"));
    //
    List<UserDrugLines> directions = dUserDrugLine.getList("From UserDrugLines Where user.id = " + session.getUserId());
    m.addAttribute("directions", directions);
    m.addAttribute("filter_direction", dr);
    m.addAttribute("period_start", startDate);
    m.addAttribute("period_end", endDate);
    return "/med/head_nurse/out/transfer/index";
  }

  @RequestMapping("transfer/save.s")
  protected String shockSave(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/head_nurse/transfer/save.s?id=" + Util.getInt(req, "id"));
    //
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    //
    List<UserDrugLines> lines = dUserDrugLine.getList("From UserDrugLines Where user.id = " + session.getUserId());
    StringBuilder arr = new StringBuilder("(");
    for(UserDrugLines line: lines) {
      arr.append(line.getDirection().getId()).append(",");
    }
    arr.append("0)");
    try {
      conn = DB.getConnection();
      //
      HNOpers obj = Util.getInt(req, "id") > 0 ? dhnOper.get(Util.getInt(req, "id")) : new HNOpers();
      if(Util.getInt(req, "id") == 0) { obj.setId(0); obj.setDate(new Date()); }
      model.addAttribute("drugs", dhnDrug.getList("From HNDrugs t Where t.drugCount - ifnull(t.rasxod, 0) > 0 And direction.id = " + (obj.getId() == 0 ? 0 : obj.getParent().getId())  + " Order By t.drug.name"));
      if(session.getUserId() == 1)
        model.addAttribute("directions", dUserDrugLine.getList("From UserDrugLines Where direction.state = 'A' And user.id = " + session.getUserId()));
      else
        model.addAttribute("directions", dUserDrugLine.getList("From UserDrugLines Where direction.state = 'A' And direction.transfer = 'Y' And user.id = " + session.getUserId()));
      if(session.getUserId() == 1)
        model.addAttribute("shocks", dDrugDirection.getList("From DrugDirections Where state = 'A'"));
      else
        model.addAttribute("shocks", dDrugDirection.getList("From DrugDirections Where state = 'A' And transfer = 'Y'"));
      model.addAttribute("rows", dhnDateRow.getList("From HNDrugs Where transfer = " + obj.getId()));
      model.addAttribute("obj", obj);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(conn);
    }
    //
    return "/med/head_nurse/out/transfer/addEdit";
  }

  @RequestMapping(value = "transfer/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String shockSave(HttpServletRequest req) throws JSONException {
    session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      String id = Util.nvl(req, "id", "0");
      HNOpers obj = id.equals("0") || id.equals("") ? new HNOpers() : dhnOper.get(Integer.parseInt(id));
      obj.setParent(dDrugDirection.get(Util.getInt(req, "parent")));
      obj.setDirection(dDrugDirection.get(Util.getInt(req, "direction")));
      if(obj.getParent().getId().equals(obj.getDirection().getId()))
        return Util.err(json, "Склад и получатель не может быть одинаковым");
      obj.setCrBy(dUser.get(session.getUserId()));
      obj.setCrOn(new Date());
      obj.setDate(Util.stringToDate(Util.get(req, "doc_date")));
      obj.setState("ENT");
      dhnOper.saveAndReturn(obj);
      json.put("id", obj.getId());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "transfer/row/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String shockRowSave(HttpServletRequest req) throws JSONException {
    session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      HNDrugs row = dhnDrug.get(Util.getInt(req, "id"));;
      row.setId(null);
      row.setTransfer_hndrug_id(Util.getInt(req, "id"));
      row.setTransfer(Util.getInt(req, "doc"));
      row.setDirection(dhnOper.get(Util.getInt(req, "doc")).getDirection());
      row.setDrugCount(Double.parseDouble(Util.get(req, "rasxod")));
      row.setRasxod(0D);
      row.setHistory(0);
      row.setCrBy(session.getUserId());
      row.setCrOn(new Date());
      sDrug.hndrug_rasxod(Util.getInt(req, "id"), row.getDrugCount());
      dhnDrug.save(row);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "transfer/row/delete.s", method = RequestMethod.POST)
  @ResponseBody
  protected String shockRowDelete(HttpServletRequest req) throws JSONException {
    session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      HNDrugs row = dhnDrug.get(Util.getInt(req, "id"));
      if(row.getRasxod() > 0)
        return Util.err(json, "Нельзя удалить запись существуют расходные операции");
      sDrug.hndrug_rasxod(row.getTransfer_hndrug_id(), -row.getDrugCount());
      dhnDrug.delete(row.getId());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "transfer/delete.s", method = RequestMethod.POST)
  @ResponseBody
  protected String shockDelete(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      int id = Util.getInt(req, "id");
      List<HNDrugs> rows = dhnDrug.getList("From HNDrugs Where transfer = " + id);
      if(rows.size() > 0)
        return Util.err(json, "Нельзя удалить документ. Сначала удалите детализацию");
      dhnOper.delete(id);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "transfer/confirm.s", method = RequestMethod.POST)
  @ResponseBody
  protected String shockConfirm(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      HNOpers doc = dhnOper.get(Util.getInt(req, "id"));
      if(dhnDrug.getCount("From HNDrugs Where transfer = " + doc.getId()) == 0)
        return Util.err(json, "Нельзя подтвердить документ без записи");
      doc.setState("CON");
      dhnOper.save(doc);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(conn);
    }
    return json.toString();
  }
  //endregion

  //region HN_PATIENTS
  @RequestMapping("total/patients.s")
  protected String totalPatients(HttpServletRequest req, Model m) {
    session = SessionUtil.getUser(req);
    session.setCurUrl("/head_nurse/total/patients.s");
    String setFilter = Util.get(req, "set");
    String filter = session.getFilters().get("hn_patient_filter");
    if(setFilter != null || filter == null || filter.equals("")) filter = Util.get(req, "filter", "").toUpperCase();
    HashMap<String, String> fl = session.getFilters();
    fl.put("hn_patient_filter", filter);
    session.setFilters(fl);
    String where = "";
    if(!filter.equals("")) {
      where = " (Upper(surname) like '%" + filter + "%' Or Upper(name) like '%" + filter + "%' Or Upper(middlename) like '%" + filter + "%' Or Upper(yearNum) like '%" + filter + "%') And ";
    }
    //
    Calendar start = Calendar.getInstance();
    start.setTime(new Date());
    start.add(Calendar.DATE, -20);
    //
    String db = session.getDateBegin().get("hn_patient");
    if(db == null) db = Util.dateToString(start.getTime());
    String de = session.getDateEnd().get("hn_patient");
    if(de == null) de = Util.getCurDate();
    //
    String startDate = Util.get(req, "period_start", db);
    String endDate = Util.get(req, "period_end", de);
    //
    HashMap<String, String> dh = session.getDateBegin();
    dh.put("hn_patient", startDate);
    session.setDateBegin(dh);
    dh = session.getDateEnd();
    dh.put("hn_patient", endDate);
    session.setDateEnd(dh);
    //
    List<UserDrugLines> drs = dUserDrugLine.getList("From UserDrugLines Where user.id = " + session.getUserId());
    String dirs = "0,";
    for(UserDrugLines dr: drs) {
      dirs += dr.getDirection().getId() + ",";
    }
    dirs = dirs.substring(0, dirs.length() - 1);
    //
    List<DrugDirectionDeps> deps = dDrugDirectionDep.getList("From DrugDirectionDeps Where direction.id in ( " + dirs + ")");
    String depIds = "0,";
    if(deps != null && deps.size() > 0) {
      for (DrugDirectionDeps dep : deps)
        depIds += dep.getDept().getId() + ",";
    }
    depIds = depIds.substring(0, depIds.length() - 1);
    List<Patients> patients = dPatient.getList("From Patients t Where t.state != 'ARCH' And " + where + " dept.id in (" + depIds + ") And  date(t.dateBegin) Between '" + Util.dateDB(startDate) + "' And '" + Util.dateDB(endDate) + "' Order By Id Desc");
    //
    List<Patients> rows = new ArrayList<Patients>();
    for(Patients patient: patients) {
      patient.setFizio(dhnPatient.getCount("From HNPatients Where patient.id = " + patient.getId()) > 0);
      rows.add(patient);
    }
    m.addAttribute("rows", rows);
    //
    m.addAttribute("period_start", startDate);
    m.addAttribute("period_end", endDate);
    m.addAttribute("filter_word", filter);
    //
    return "/med/head_nurse/total/index";
  }

  @RequestMapping("total/patients/info.s")
  protected String totalPatientInfo(HttpServletRequest req, Model m) {
    session = SessionUtil.getUser(req);
    session.setCurUrl("/head_nurse/total/patients/info.s?id=" + Util.getInt(req, "id"));
    //
    Patients patient = dPatient.get(Util.getInt(req, "id"));
    m.addAttribute("obj", patient);
    boolean isConf = true;
    HNPatients pat = new HNPatients();
    try {
      pat = dhnPatient.getObj("From HNPatients Where patient.id = " + patient.getId());
      m.addAttribute("parent", pat);
      isConf = true;
    } catch (Exception e) {
      m.addAttribute("parent", null);
      isConf = false;
    }
    //
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      conn = DB.getConnection();
      List<ObjList> list = new ArrayList<ObjList>();
      if(!isConf) {
        ps = conn.prepareStatement(
          " Select d.name, m.name measure, Sum(t.rasxod) summ " +
            " From Hn_Date_Patient_Rows t, HN_Drugs c, Drug_s_Names d, Drug_s_Measures m, Hn_Dates f " +
            " Where m.id = d.measure_id And t.drug_id = c.id And c.drug_id = d.id And t.patient_id = ? " +
            "   And f.id = t.doc_id " +
            "   And f.state = 'CON' " +
            " Group By d.Name, m.name" +
            " Order By d.Name "
        );
        ps.setInt(1, patient.getId());
        rs = ps.executeQuery();
        while (rs.next()) {
          ObjList obj = new ObjList();
          obj.setC1(rs.getString("name"));
          obj.setC2(rs.getDouble("summ") + "");
          obj.setC3(rs.getString("measure"));
          list.add(obj);
        }
      } else {
        List<HNPatientDrugs> rows = dhnPatientDrug.getList("From HNPatientDrugs Where parent.id = " + pat.getId() + " Order By drugName");
        for(HNPatientDrugs row: rows) {
          ObjList obj = new ObjList();
          if(row.getDrug() == null)
            obj.setC1(row.getDrugName());
          else
            obj.setC1(row.getDrug().getName());
          obj.setC2(row.getServiceCount() + "");
          if(row.getDrug() == null)
            obj.setC3("");
          else
            obj.setC3(row.getDrug().getMeasure().getName());
          list.add(obj);
        }
      }
      m.addAttribute("rows", list);
      //
      ps = conn.prepareStatement(
        " Select c.Id, d.name, c.date, c.state " +
          "  From Hn_Date_Patients t, Hn_Dates c, drug_s_directions d " +
          " Where c.Id = t.date_Id " +
          "   And d.Id = c.direction_Id " +
          "   And t.patient_Id = ?"
      );
      List<ObjList> dates = new ArrayList<ObjList>();
      ps.setInt(1, patient.getId());
      rs = ps.executeQuery();
      while (rs.next()) {
        ObjList obj = new ObjList();
        obj.setC1(rs.getString("id"));
        obj.setC2(rs.getString("name"));
        obj.setC3(Util.dateToString(rs.getDate("date")));
        obj.setC4(rs.getString("state"));
        dates.add(obj);
      }
      m.addAttribute("dates", dates);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(conn);
    }
    //
    return "/med/head_nurse/total/addEdit";
  }

  @RequestMapping(value = "total/patients/confirm.s", method = RequestMethod.POST)
  @ResponseBody
  protected String totalPatientConfirm(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      HNPatients hnPatient = new HNPatients();
      hnPatient.setPatient(dPatient.get(Util.getInt(req, "id")));
      hnPatient.setDateEnd(hnPatient.getPatient().getDateEnd());
      hnPatient.setDayCount(10);
      hnPatient.setState("C");
      hnPatient.setClosed("N");
      dhnPatient.saveAndReturn(hnPatient);
      Date startDate = Util.stringToDate("31.03.2024");
      Date chd = hnPatient.getDateEnd() == null ? new Date() : hnPatient.getDateEnd();
      Double ndsProc = chd.after(startDate) ? Double.parseDouble(dParam.byCode("NDS_PROC")) : 0;
      //
      Connection conn = null;
      PreparedStatement ps = null;
      ResultSet rs = null;
      try {
        conn = DB.getConnection();
        ps = conn.prepareStatement(
          "Select c.id hndrug, d.id drug_id, d.name, m.id measure_id, m.name measure, ifnull((Select fd.price From drug_out_rows fd where fd.Id = c.outRow_id), 0) price, Sum(t.rasxod) summ, ifnull(c.ndsProc, 0) ndsProc, ifnull(c.nds, 0) nds " +
            "     From Hn_Date_Patient_Rows t, HN_Drugs c, Drug_s_Names d, Drug_s_Measures m, Hn_Dates f " +
            "     Where m.id = d.measure_id And t.drug_id = c.id And c.drug_id = d.id And t.patient_id = ? " +
            "       And f.id = t.doc_id " +
            "       And f.state = 'CON' " +
            "     Group By d.Name " +
            "     Order By c.id, d.id, d.name, m.id, m.name"
        );
        ps.setInt(1, hnPatient.getPatient().getId());
        rs = ps.executeQuery();
        while (rs.next()) {
          HNPatientDrugs drug = new HNPatientDrugs();
          drug.setParent(hnPatient);
          drug.setDrugName(rs.getString("name"));
          drug.setDrug(dDrug.get(rs.getInt("drug_id")));
          drug.setDrugPrice(rs.getDouble("price"));
          drug.setPrice(drug.getDrug().getPrice() == null ? drug.getDrugPrice() : drug.getDrug().getPrice());
          drug.setServiceCount(rs.getDouble("summ"));
          drug.setNdsProc(ndsProc);
          drug.setNds(drug.getPrice() * ndsProc / 100);
          dhnPatientDrug.save(drug);
        }
      } catch (Exception e) {
        e.printStackTrace();
      } finally {
        DB.done(rs);
        DB.done(ps);
        DB.done(conn);
      }
      //
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "total/patients/update.s", method = RequestMethod.POST)
  @ResponseBody
  protected String totalPatientUpdate(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      HNPatients hnPatient = dhnPatient.get(Util.getInt(req, "id"));
      Date startDate = Util.stringToDate("31.03.2024");
      Date chd = hnPatient.getDateEnd() == null ? new Date() : hnPatient.getDateEnd();
      Double ndsProc = chd.after(startDate) ? Double.parseDouble(dParam.byCode("NDS_PROC")) : 0;
      //
      dhnPatientDrug.deletePatient(hnPatient.getId());
      //
      Connection conn = null;
      PreparedStatement ps = null;
      ResultSet rs = null;
      try {
        conn = DB.getConnection();
        ps = conn.prepareStatement(
          "Select c.id hndrug, d.id drug_id, d.name, m.id measure_id, m.name measure, ifnull((Select fd.price From drug_out_rows fd where fd.Id = c.outRow_id), 0) price, Sum(t.rasxod) summ, ifnull(c.ndsProc, 0) ndsProc, ifnull(c.nds, 0) nds " +
            "    From Hn_Date_Patient_Rows t, HN_Drugs c, Drug_s_Names d, Drug_s_Measures m, Hn_Dates f " +
            "   Where m.id = t.measure_id And t.drug_id = c.id And c.drug_id = d.id And t.patient_id = ? " +
            "     And f.id = t.doc_id " +
            "     And f.state = 'CON' " +
            "   Group By d.Name " +
            "   Order By c.id, d.id, d.name, m.id, m.name"
        );
        ps.setInt(1, hnPatient.getPatient().getId());
        rs = ps.executeQuery();
        while (rs.next()) {
          HNPatientDrugs drug = new HNPatientDrugs();
          drug.setParent(hnPatient);
          drug.setDrugName(rs.getString("name"));
          drug.setDrug(dDrug.get(rs.getInt("drug_id")));
          drug.setDrugPrice(rs.getDouble("price"));
          drug.setPrice(drug.getDrug().getPrice() == null ? drug.getDrugPrice() : drug.getDrug().getPrice());
          drug.setServiceCount(rs.getDouble("summ"));
          drug.setNdsProc(ndsProc);
          drug.setNds(drug.getPrice() * ndsProc / 100);
          dhnPatientDrug.save(drug);
        }
      } catch (Exception e) {
        e.printStackTrace();
      } finally {
        DB.done(rs);
        DB.done(ps);
        DB.done(conn);
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }
  //endregion

  //region EAT
  @RequestMapping("eats.s")
  public String home(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/head_nurse/eats.s");
    model.addAttribute("menuTypes", dEatMenuType.getList("From EatMenuTypes Where state = 'A'"));
    String deps = "0,";
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      con = DB.getConnection();
      ps = con.prepareStatement(
        "Select c.dept_Id" +
          "  From User_Drug_Lines t, Drug_s_Direction_Deps c " +
          " Where c.direction_Id = t.direction_Id And t.user_Id = ?" +
          " Group By c.dept_Id");
      ps.setInt(1, session.getUserId());
      ps.execute();
      rs = ps.getResultSet();
      while(rs.next()) {
        deps += rs.getInt(1) + ",";
      }
      deps = deps.substring(0, deps.length() - 1);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(con);
    }

    model.addAttribute("depts", dDept.getList("From Depts Where id in (" + deps + ")"));
    //
    Calendar end = Calendar.getInstance();
    end.setTime(new Date());
    end.add(Calendar.DATE, 2);
    //
    String db = session.getDateBegin().get("hn_eat");
    if(db == null) db = "01" + Util.getCurDate().substring(2);
    String de = session.getDateEnd().get("hn_eat");
    if(de == null) de = Util.dateToString(end.getTime());
    //
    String startDate = Util.get(req, "period_start", db);
    String endDate = Util.get(req, "period_end", de);
    //
    HashMap<String, String> dh = session.getDateBegin();
    dh.put("hn_eat", startDate);
    session.setDateBegin(dh);
    dh = session.getDateEnd();
    dh.put("hn_eat", endDate);
    session.setDateEnd(dh);
    List<NurseEats> list;
    if(session.getUserId() == 1)
      list = dNurseEat.getList("From NurseEats Where date(actDate) Between '" + Util.dateDBBegin(startDate) + "' And '" + Util.dateDBBegin(endDate) + "' Order By Id Desc");
    else
      list = dNurseEat.getList("From NurseEats Where date(actDate) Between '" + Util.dateDBBegin(startDate) + "' And '" + Util.dateDBBegin(endDate) + "' And crBy.id = " + session.getUserId() + " Order By Id Desc");
    List<ObjList> objLists = new ArrayList<ObjList>();
    for(NurseEats l : list) {
      ObjList obj = new ObjList();
      obj.setIb(l.getId().toString());
      obj.setDate(Util.dateToString(l.getActDate()));
      obj.setFio(l.getMenuType().getName());
      obj.setC1(l.getState());
      obj.setC2(dNurseEatPatient.getCount("From NurseEatPatients Where nurseEat.id = " + l.getId() + " And patient != null And patient.id > 0").toString());
      obj.setC3(dNurseEatPatient.getCount("From NurseEatPatients Where nurseEat.id = " + l.getId() + " And patient = null").toString());
      obj.setC4(l.getDept() != null ? l.getDept().getName() : "");
      objLists.add(obj);
    }
    model.addAttribute("list", objLists);
    model.addAttribute("period_start", startDate);
    model.addAttribute("period_end", endDate);
    return "med/head_nurse/eat/eat";
  }

  @RequestMapping(value = "eat/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String eatSave(HttpServletRequest req) throws JSONException {
    session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      NurseEats eat = new NurseEats();
      eat.setActDate(Util.getDate(req, "menu_date"));
      eat.setMenuType(dEatMenuType.get(Util.getInt(req, "menu_type")));
      eat.setDept(dDept.get(Util.getInt(req, "dept")));
      if(dNurseEat.check(eat)) {
        eat.setState("ENT");
        eat.setCrBy(dUser.get(session.getUserId()));
        eat.setCrOn(new Date());
        dNurseEat.saveAndReturn(eat);
        //
        List<PatientEats> patients = dPatientEat.getList("From PatientEats Where patient.dept.id = " + eat.getDept().getId() + " And actDate = '" + Util.dateDB(Util.dateToString(eat.getActDate())) + "' And menuType.id = " + eat.getMenuType().getId());
        for (PatientEats patient : patients) {
          if(patient.getPatient().getDateEnd() == null || (patient.getPatient().getDateEnd() != null && patient.getPatient().getDateEnd().equals(eat.getActDate())) || (patient.getPatient().getDateEnd() != null && patient.getPatient().getDateEnd().after(eat.getActDate()))) {
            NurseEatPatients pat = new NurseEatPatients();
            pat.setPatient(patient.getPatient());
            pat.setNurseEat(eat);
            pat.setTable(patient.getTable());
            dNurseEatPatient.save(pat);
          }
        }
        //
        json.put("id", eat.getId());
        json.put("success", true);
      } else {
        json.put("success", false);
        json.put("msg", "Такая запись уже существует в БД");
      }
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "eat/del.s", method = RequestMethod.POST)
  @ResponseBody
  protected String eatDel(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      dNurseEatPatient.delByEat(Util.getInt(req, "id"));
      dNurseEat.delete(Util.getInt(req, "id"));
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("eat.s")
  public String eatEdit(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    NurseEats eat = dNurseEat.get(Util.getInt(req, "id"));
    session.setCurUrl("/head_nurse/eat.s?id=" + eat.getId());
    //
    List<EatMenuTable> list = new ArrayList<EatMenuTable>();
    int newCount = 0;
    List<EatTables> tables = dEatTable.getList("From EatTables");
    for(EatTables table: tables) {
      EatMenuTable tb = new EatMenuTable();
      tb.setId(table.getId());
      tb.setName(table.getName());
      // Patients
      List<PatientList> pats = new ArrayList<PatientList>();
      List<NurseEatPatients> nurseEatPatients = dNurseEatPatient.getList("From NurseEatPatients Where nurseEat.id = " + eat.getId() + " And table.id = " + table.getId() + " Order By patient desc");
      for (NurseEatPatients patient : nurseEatPatients) {
        PatientList pat = new PatientList();
        pat.setId(patient.getId());
        if(patient.getPatient() != null) {
          pat.setDateEnd(patient.getPatient().getDate_End());
          pat.setIbNum(""+ patient.getPatient().getId());
          pat.setFio(patient.getPatient().getYearNum() + " - " + patient.getPatient().getSurname() + " " + patient.getPatient().getName() + " " + patient.getPatient().getMiddlename() + " - " + patient.getPatient().getDept().getName() + "/" + patient.getPatient().getRoom().getName() + "-" + patient.getPatient().getRoom().getRoomType().getName());
          pat.setDateBegin("" + (patient.getPatient().getDateBegin().equals(eat.getActDate())));
          if(patient.getPatient().getDateBegin().equals(eat.getActDate()))
            newCount++;
        } else {
          pat.setFio(patient.getComment());
        }
        pats.add(pat);
      }
      tb.setPatients(pats);
      list.add(tb);
    }
    model.addAttribute("newCount", newCount);
    model.addAttribute("eat", eat);
    model.addAttribute("list", list);
    model.addAttribute("tables", dEatTable.getList("From EatTables Where state = 'A'"));
    return "med/head_nurse/eat/eat_patients";
  }

  @RequestMapping(value = "eat/refresh.s", method = RequestMethod.POST)
  @ResponseBody
  protected String eatRefresh(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      NurseEats eat = dNurseEat.get(Util.getInt(req, "id"));
      dNurseEatPatient.delPatientsByEat(eat.getId());
      //
      List<PatientEats> patients = dPatientEat.getList("From PatientEats Where patient.dept.id in (" + eat.getDept().getId() + ") And table.id > 0 And actDate = '" + Util.dateDB(Util.dateToString(eat.getActDate())) + "' And menuType.id = " + eat.getMenuType().getId());
      for (PatientEats patient : patients) {
        if(patient.getPatient().getDateEnd() == null || (patient.getPatient().getDateEnd() != null && patient.getPatient().getDateEnd().equals(eat.getActDate())) || (patient.getPatient().getDateEnd() != null && patient.getPatient().getDateEnd().after(eat.getActDate()))) {
          NurseEatPatients pat = new NurseEatPatients();
          pat.setPatient(patient.getPatient());
          pat.setNurseEat(eat);
          pat.setTable(patient.getTable());
          dNurseEatPatient.save(pat);
        }
      }
      //
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "eat/table/refresh.s", method = RequestMethod.POST)
  @ResponseBody
  protected String eatTableRefresh(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      EatTables table = dEatTable.get(Util.getInt(req, "id"));
      NurseEats eat = dNurseEat.get(Util.getInt(req, "eat"));
      dNurseEatPatient.delByEatTable(eat.getId(), table.getId());
      //
      List<PatientEats> patients = dPatientEat.getList("From PatientEats Where patient.dept.id = " + eat.getDept().getId() + " And actDate = '" + Util.dateDB(Util.dateToString(eat.getActDate())) + "' And menuType.id = " + eat.getMenuType().getId() + " And table.id = " + table.getId());
      for (PatientEats patient : patients) {
        if(patient.getPatient().getDateEnd() == null || (patient.getPatient().getDateEnd() != null && patient.getPatient().getDateEnd().equals(eat.getActDate())) || (patient.getPatient().getDateEnd() != null && patient.getPatient().getDateEnd().after(eat.getActDate()))) {
          NurseEatPatients pat = new NurseEatPatients();
          pat.setPatient(patient.getPatient());
          pat.setNurseEat(eat);
          pat.setTable(patient.getTable());
          dNurseEatPatient.save(pat);
        }
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "eat/patient/del.s", method = RequestMethod.POST)
  @ResponseBody
  protected String eatPatientDel(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      dNurseEatPatient.delete(Util.getInt(req, "id"));
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "eat/patient/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String eatPatienSave(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      Integer count = Util.getInt(req, "counter");
      for(int i=0;i<count;i++) {
        NurseEatPatients pat = new NurseEatPatients();
        pat.setComment(Util.get(req, "text"));
        pat.setNurseEat(dNurseEat.get(Util.getInt(req, "eat_id")));
        pat.setTable(dEatTable.get(Util.getInt(req, "table_id")));
        dNurseEatPatient.save(pat);
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "eat/patient/edit.s")
  protected String eatPatientGet(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurSubUrl("/head_nurse/eat/patient/edit.s?id=" + Util.getInt(req, "id"));
    Patients patient = dPatient.get(Util.getInt(req, "id"));
    model.addAttribute("patient", patient);
    model.addAttribute("eat_id", Util.getInt(req, "eat_id"));
    List<PatientEats> eats = dPatientEat.getPatientEat(patient.getId());
    List<EatMenuTypes> menuTypes = dEatMenuType.getList("From EatMenuTypes Where state = 'A'");
    if(eats == null || eats.size() == 0) {
      eats = new ArrayList<PatientEats>();
      int count = patient.getDayCount();
      if(patient.getDateEnd() != null && patient.getDateEnd().after(patient.getDateBegin())) {
        count = Integer.parseInt("" + ((patient.getDateEnd().getTime() - patient.getDateBegin().getTime()) / (1000 * 60 * 60 * 24))) + 1;
      }
      List<Date> dates = Util.getDateArray(patient.getDateBegin(), count);
      for(Date date: dates) {
        for(EatMenuTypes menuType: menuTypes) {
          PatientEats eat = new PatientEats();
          eat.setActDate(date);
          eat.setPatient(patient);
          eat.setTable(null);
          eat.setMenuType(menuType);
          eat.setState("ENT");
          dPatientEat.save(eat);
          eats.add(eat);
        }
      }
    } else {
      if(patient.getDateEnd() != null && patient.getDateEnd().after(patient.getDateBegin())) {
        Date maxDate = eats.get(eats.size() - 1).getActDate();
        int count = Integer.parseInt("" + ((patient.getDateEnd().getTime() - patient.getDateBegin().getTime()) / (1000 * 60 * 60 * 24))) + 1;
        List<Date> dates = Util.getDateArray(maxDate, count - (eats.size() / menuTypes.size()) + 1);
        for (Date date : dates) {
          if (maxDate.getTime() != date.getTime()) {
            for (EatMenuTypes menuType : menuTypes) {
              PatientEats eat = new PatientEats();
              eat.setActDate(date);
              eat.setPatient(patient);
              eat.setTable(null);
              eat.setMenuType(menuType);
              eat.setState("ENT");
              dPatientEat.save(eat);
              eats.add(eat);
            }
          }
        }
      }
    }
    model.addAttribute("eats", eats);
    model.addAttribute("tables", dEatTable.getList("From EatTables Where state = 'A'"));
    //
    return "/med/head_nurse/eat/patient_eats_edit";
  }

  @RequestMapping(value = "eat/confirm.s", method = RequestMethod.POST)
  @ResponseBody
  protected String eatConfirm(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      NurseEats eat = dNurseEat.get(Util.getInt(req, "id"));
      if(dNurseEatPatient.getCount("From NurseEatPatients Where nurseEat.id = " + eat.getId()) > 0) {
        eat.setState("CON");
        dNurseEat.save(eat);
        json.put("success", true);
      } else {
        json.put("success", false);
        json.put("msg", "Нельзя подтвердить документ без записи");
      }
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("eat/print.s")
  public String nurseEatPrint(HttpServletRequest req, Model model){
    NurseEats eat = dNurseEat.get(Util.getInt(req, "id"));
    List<EatMenuTable> rows = new ArrayList<EatMenuTable>();
    List<NurseEatPatients> patients = dNurseEatPatient.list("From NurseEatPatients Where nurseEat.id = " + eat.getId() + " Order By table.id");
    int table = 0;
    EatMenuTable r = new EatMenuTable();
    List<PatientList> pats = new ArrayList<>();
    for(NurseEatPatients patient: patients) {
      if(table != patient.getTable().getId()) {
        r = new EatMenuTable();
        r.setName(patient.getTable().getName());
        pats = new ArrayList<>();
        r.setPatients(pats);
        rows.add(r);
      }
      PatientList p = new PatientList();
      if(patient.getPatient() != null) {
        p.setId(patient.getPatient().getId());
        p.setFio(patient.getPatient().getFio());
        p.setMetka(patient.getPatient().getRoom().getName());
      } else {
        p.setFio(patient.getComment());
      }
      pats.add(p);
      table = patient.getTable().getId();
    }
    model.addAttribute("eat", eat);
    model.addAttribute("rows", rows);
    return "med/head_nurse/eat/print";
  }
  //endregion








  //region OUT_AMB_PATIENT
  @RequestMapping("out/amb.s")
  protected String outAmbPatient(HttpServletRequest req, Model m) {
    session = SessionUtil.getUser(req);
    session.setCurUrl("/head_nurse/out/amb.s");
    //
    List<UserDrugLines> lines = dUserDrugLine.getList("From UserDrugLines Where user.id = " + session.getUserId());
    StringBuilder arr = new StringBuilder("(");
    for(UserDrugLines line: lines) {
      arr.append(line.getDirection().getId()).append(",");
    }
    arr.append("0)");
    //
    Calendar end = Calendar.getInstance();
    end.setTime(new Date());
    end.add(Calendar.DATE, 2);
    //
    String db = session.getDateBegin().get("hn_amb_out");
    if(db == null) db = "01" + Util.getCurDate().substring(2);
    String de = session.getDateEnd().get("hn_amb_out");
    if(de == null) de = Util.dateToString(end.getTime());
    //
    String startDate = Util.get(req, "period_start", db);
    String endDate = Util.get(req, "period_end", de);
    //
    HashMap<String, String> dh = session.getDateBegin();
    dh.put("hn_amb_out", startDate);
    session.setDateBegin(dh);
    dh = session.getDateEnd();
    dh.put("hn_amb_out", endDate);
    session.setDateEnd(dh);
    //
    m.addAttribute("rows", dhnDate.getList("From HNDates Where typeCode = 'AMB' And direction.id in " + arr + " And date(date) Between '" + Util.dateDBBegin(startDate) + "' And '" + Util.dateDBBegin(endDate) + "' Order By id Desc"));
    //
    m.addAttribute("period_start", startDate);
    m.addAttribute("period_end", endDate);
    return "/med/head_nurse/out/amb/index";
  }

  @RequestMapping("out/amb/save.s")
  protected String outAmbSave(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/head_nurse/out/amb/save.s?id=" + Util.getInt(req, "id"));
    //
    List<HNDateAmbRows> rows = new ArrayList<HNDateAmbRows>();
    List<UserDrugLines> lines = dUserDrugLine.getList("From UserDrugLines Where user.id = " + session.getUserId());
    StringBuilder arr = new StringBuilder("(");
    for(UserDrugLines line: lines) {
      arr.append(line.getDirection().getId()).append(",");
    }
    arr.append("0)");
    double drugSum = 0, drugSums = 0;
    try {
      //
      HNDates obj = Util.getInt(req, "id") > 0 ? dhnDate.get(Util.getInt(req, "id")) : new HNDates();
      if(Util.getInt(req, "id") == 0) { obj.setId(0); obj.setDate(new Date()); }
      if(Util.getInt(req, "id") > 0) {
        rows = dhnDateAmbRow.getList("From HNDateAmbRows Where doc.id = " + obj.getId());
        model.addAttribute("drugs", dhnDrug.getList("From HNDrugs t Where t.drugCount - ifnull(t.rasxod, 0) > 0 And t.direction.id = " + obj.getDirection().getId() + " Order BY t.drug.name"));
        model.addAttribute("drug_exist", dAmbDrug.getCount("From AmbDrugs Where patient.id = " + obj.getPatient().getId()) > 0);
        for(HNDateAmbRows drug: rows) {
          if(drug.getDoc().getPaid().equals("N"))
            drugSum += drug.getRasxod() * drug.getHndrug().getPrice();
          drugSums += drug.getRasxod() * drug.getHndrug().getPrice();
        }
      }
      model.addAttribute("directions", dUserDrugLine.getList("From UserDrugLines Where user.id = " + session.getUserId()));
      model.addAttribute("rows", rows);
      model.addAttribute("drugSum", drugSums);
      model.addAttribute("notPaidSum", drugSum);
      model.addAttribute("patients", dAmbPatient.getList("From AmbPatients Where state != 'ARCH' Order By surname"));
      model.addAttribute("obj", obj);
    } catch (Exception e) {
      e.printStackTrace();
    }
    //
    return "/med/head_nurse/out/amb/addEdit";
  }

  @RequestMapping(value = "out/amb/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String outAmbSave(HttpServletRequest req) throws JSONException {
    session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      String id = Util.nvl(req, "id", "0");
      HNDates obj = id.equals("0") || id.equals("") ? new HNDates() : dhnDate.get(Integer.parseInt(id));
      obj.setDirection(dDrugDirection.get(Util.getInt(req, "direction")));
      obj.setPatient(dAmbPatient.get(Util.getInt(req, "patient")));
      if(obj.getId() == null) {
        obj.setCrBy(dUser.get(session.getUserId()));
        obj.setCrOn(new Date());
        obj.setDate(Util.stringToDate(Util.get(req, "doc_date")));
        obj.setState("ENT");
        obj.setPaid("N");
        if(obj.getDate().before(Util.stringToDate(Util.getCurDate()))) {
          json.put("success", false);
          json.put("msg", "Дата операции не может быть меньше текущей даты");
          return json.toString();
        }
      }
      obj.setTypeCode("AMB");
      dhnDate.saveAndReturn(obj);
      json.put("id", obj.getId());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "out/amb/delete.s", method = RequestMethod.POST)
  @ResponseBody
  protected String outAmbDelete(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    Connection conn = null;
    try {
      conn = DB.getConnection();
      HNDates date = dhnDate.get(Util.getInt(req, "id"));
      List<HNDateAmbRows> rows = dhnDateAmbRow.getList("From HNDateAmbRows Where doc.id = " + date.getId());
      for(HNDateAmbRows row: rows) {
        sDrug.hndrug_rasxod(row.getHndrug().getId(), -row.getRasxod());
        dhnDateAmbRow.delete(row.getId());
      }
      AmbPatients patient = date.getPatient();
      Double summ = DB.getSum(conn, "Select Sum(t.price) From Amb_Patient_Services t Where t.patient = " + patient.getId() + " And t.state Not In ('PAID', 'DONE', 'DEL', 'AUTO_DEL')");
      Double count = DB.getSum(conn, "Select Count(*) From Amb_Patient_Services t Where t.patient = " + patient.getId() + " And t.state Not In ('DONE', 'DEL', 'AUTO_DEL')");
      if (summ > 0) {
        patient.setState("CASH");
      } else {
        if (count == 0) {
          patient.setState("DONE");
        } else {
          patient.setState("WORK");
        }
      }
      dAmbPatient.save(patient);
      dhnDate.delete(date.getId());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    } finally {
      DB.done(conn);
    }
    return json.toString();
  }

  @RequestMapping(value = "out/row/amb/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String outAmbRowSave(HttpServletRequest req) throws JSONException {
    session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      HNDateAmbRows row = new HNDateAmbRows();
      row.setHndrug(dhnDrug.get(Util.getInt(req, "id")));
      row.setDoc(dhnDate.get(Util.getInt(req, "doc")));
      row.setRasxod(Double.parseDouble(Util.get(req, "rasxod")));
      row.setDate(row.getDoc().getDate());
      row.setPatient(row.getDoc().getPatient());
      row.setDrug(row.getHndrug().getDrug());
      row.setCrBy(session.getUserId());
      row.setCrOn(new Date());
      sDrug.hndrug_rasxod(row.getHndrug().getId(), row.getRasxod());
      dhnDateAmbRow.save(row);
      AmbPatients patient = row.getPatient();
      patient.setState("CASH");
      dAmbPatient.save(patient);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "out/amb/row/delete.s", method = RequestMethod.POST)
  @ResponseBody
  protected String outAmbRowDelete(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    Connection conn = null;
    try {
      conn = DB.getConnection();
      HNDateAmbRows row = dhnDateAmbRow.get(Util.getInt(req, "id"));
      HNDates doc = row.getDoc();
      sDrug.hndrug_rasxod(row.getHndrug().getId(), -row.getRasxod());
      dhnDateAmbRow.delete(row.getId());
      if(dhnDateAmbRow.getCount("From HNDateAmbRows Where doc.id = " + doc.getId()) == 0) {
        AmbPatients patient = doc.getPatient();
        Double summ = DB.getSum(conn, "Select Sum(t.price) From Amb_Patient_Services t Where t.patient = " + patient.getId() + " And t.state Not In ('PAID', 'DONE', 'DEL', 'AUTO_DEL')");
        Double count = DB.getSum(conn, "Select Count(*) From Amb_Patient_Services t Where t.patient = " + patient.getId() + " And t.state Not In ('DONE', 'DEL', 'AUTO_DEL')");
        if (summ > 0) {
          patient.setState("CASH");
        } else {
          if (count == 0) {
            patient.setState("DONE");
          } else {
            patient.setState("WORK");
          }
        }
        dAmbPatient.save(patient);
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    } finally {
      DB.done(conn);
    }
    return json.toString();
  }

  @RequestMapping("out/amb/drugs.s")
  protected String outAmbDrugs(HttpServletRequest req, Model m) {
    HNDates doc = dhnDate.get(Util.getInt(req, "doc"));
    Date minDate = dAmbDrugDate.minDate(doc.getPatient().getId());
    Date maxDate = dAmbDrugDate.maxDate(doc.getPatient().getId());
    if(minDate != null) {
      long diffInMillies = Math.abs(maxDate.getTime() - minDate.getTime());
      long diff = TimeUnit.DAYS.convert(diffInMillies, TimeUnit.MILLISECONDS) + 2;
      m.addAttribute("dates", Util.getDateList(minDate, (int) (diff)));
    }
    m.addAttribute("doc", doc);
    m.addAttribute("drugs", sAmb.getDrugs(doc.getPatient().getId()));
    return "/med/head_nurse/out/amb/drugs";
  }

  @RequestMapping("out/amb/addDrug.s")
  protected String outAmbAddDrug(HttpServletRequest req, Model m) {
    m.addAttribute("drugs", dhnDrug.getList("From HNDrugs t Where direction.id = " + Util.getInt(req, "dr")+ " And t.drugCount - ifnull(t.rasxod, 0) > 0 And drug.id = " + Util.getInt(req, "id")));
    //
    return "/med/head_nurse/out/amb/addDrug";
  }

  @RequestMapping("out/amb/addDateDrugs.s")
  protected String outAmbAddDrugs(HttpServletRequest req, Model m) {
    Integer patient = Util.getInt(req, "id");
    Date minDate = dAmbDrugDate.minDate(patient);
    Date maxDate = dAmbDrugDate.maxDate(patient);
    //
    long diffInMillies = Math.abs(maxDate.getTime() - minDate.getTime());
    long diff = TimeUnit.DAYS.convert(diffInMillies, TimeUnit.MILLISECONDS) + 2;
    List<String> dates = Util.getListDates(minDate, (int) (diff));
    String d = "";
    for(String dt: dates) {
      if(dt.contains(Util.get(req, "dt")))
        d = dt;
    }
    //
    List<AmbDrugDates> dds = dAmbDrugDate.getList("From AmbDrugDates Where checked = 1 And ambDrug.patient.id = " + Util.get(req, "id") + " And date = '" + Util.dateDB(d) + "'");
    List<Obj> drugs = new ArrayList<Obj>();
    for(AmbDrugDates dd: dds) {
      List<AmbDrugRows> rows = dAmbDrugRow.getList("From AmbDrugRows Where ambDrug.id = " + dd.getAmbDrug().getId());
      for (AmbDrugRows row : rows) {
        if (!row.getSource().equals("own")) {
          Obj obj = new Obj();
          obj.setId(row.getDrug().getId());
          obj.setName(row.getDrug().getName());
          List<HNDrugs> ffs = dhnDrug.getList("From HNDrugs t Where direction.id = " + Util.getInt(req, "dr") + " And t.drugCount - ifnull(t.rasxod, 0) > 0 And drug.id = " + row.getDrug().getId());
          List<ObjList> list = new ArrayList<ObjList>();
          for (HNDrugs ff : ffs) {
            ObjList o = new ObjList();
            o.setC1(ff.getId().toString());
            o.setC2(ff.getDrug().getName() + " (Остаток: " + (ff.getDrugCount() - ff.getRasxod()) + ")");
            o.setC3(ff.getMeasure().getName());
            o.setC4((ff.getDrugCount() - ff.getRasxod()) + "");
            o.setC5(row.getRasxod().toString());
            list.add(o);
          }
          obj.setList(list);
          if(list.size() > 0)
            drugs.add(obj);
        }
      }
    }
    m.addAttribute("drugs", drugs);
    //
    return "/med/head_nurse/out/amb/addDrugs";
  }

  @RequestMapping(value = "out/row/amb/saves.s", method = RequestMethod.POST)
  @ResponseBody
  protected String outAmbRowSaves(HttpServletRequest req) throws JSONException {
    session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      //
      String[] ids = req.getParameterValues("ids");
      if(ids != null) {
        for (String id : ids) {
          String hid = Util.get(req, "drug_" + id);
          String rasxod = Util.get(req, "drug_count_" + id);
          if (hid != null && rasxod != null && !hid.equals("") && !rasxod.equals("") && Double.parseDouble(rasxod) > 0) {
            HNDateAmbRows row = new HNDateAmbRows();
            row.setHndrug(dhnDrug.get(Integer.parseInt(hid)));
            row.setDrug(row.getHndrug().getDrug());
            row.setDoc(dhnDate.get(Util.getInt(req, "doc")));
            row.setRasxod(Double.parseDouble(rasxod));
            row.setDate(row.getDoc().getDate());
            row.setPatient(row.getDoc().getPatient());
            row.setCrBy(session.getUserId());
            row.setCrOn(new Date());
            sDrug.hndrug_rasxod(row.getHndrug().getId(), row.getRasxod());
            dhnDateAmbRow.save(row);
          }
        }
      }
      //
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }
  //endregion

  //region PATIENT
  @RequestMapping("patients.s")
  protected String patients(HttpServletRequest req, Model m) {
    session = SessionUtil.getUser(req);
    session.setCurUrl("/head_nurse/patients.s");
    String setFilter = Util.get(req, "set");
    String filter = session.getFilters().get("hn_patient_filter");
    if(setFilter != null || filter == null || filter.equals("")) filter = Util.get(req, "filter", "").toUpperCase();
    Calendar start = Calendar.getInstance();
    start.setTime(new Date());
    start.add(Calendar.DATE, -4);
    Calendar end = Calendar.getInstance();
    end.setTime(new Date());
    end.add(Calendar.DATE, 2);
    //
    String db = session.getDateBegin().get("hn_pat");
    if(db == null) db = Util.dateToString(start.getTime());
    String de = session.getDateEnd().get("hn_pat");
    if(de == null) de = Util.dateToString(end.getTime());
    //
    String startDate = Util.get(req, "period_start", db);
    String endDate = Util.get(req, "period_end", de);
    //
    HashMap<String, String> dh = session.getDateBegin();
    dh.put("hn_pat", startDate);
    session.setDateBegin(dh);
    dh = session.getDateEnd();
    dh.put("hn_pat", endDate);
    session.setDateEnd(dh);
    HashMap<String, String> fl = session.getFilters();
    fl.put("hn_patient_filter", filter);
    session.setFilters(fl);
    String where = "";
    if(!filter.equals("")) {
      where = " (Upper(patient.surname) like '%" + filter + "%' Or Upper(patient.name) like '%" + filter + "%' Or Upper(patient.middlename) like '%" + filter + "%' Or Upper(patient.yearNum) like '%" + filter + "%') And ";
    }
    //
    m.addAttribute("list", dhnPatient.getList("From HNPatients t Where " + where + " (t.dateEnd = null Or t.dateEnd = '' Or date(t.dateEnd) Between '" + Util.dateDB(startDate) + "' And '" + Util.dateDB(endDate) + "') Order By t.id Desc"));
    m.addAttribute("period_start", startDate);
    m.addAttribute("period_end", endDate);
    m.addAttribute("filter_word", filter);
    //
    return "/med/head_nurse/patients/index";
  }

  @RequestMapping("patient/info.s")
  protected String addPatients(HttpServletRequest req, Model m) {
    session = SessionUtil.getUser(req);
    String id = Util.get(req, "id");
    session.setCurUrl("/head_nurse/patient/info.s?id=" + id);
    //
    m.addAttribute("drugs", dDrug.getList("From Drugs Order By name"));
    m.addAttribute("counters", dDrugCount.getAll());
    m.addAttribute("rows", dhnPatientDrug.getList("From HNPatientDrugs Where parent.id = " + id));
    m.addAttribute("obj", dhnPatient.get(Integer.parseInt(id)));
    //
    return "/med/head_nurse/patients/addEdit";
  }

  @RequestMapping(value = "patient/filter.s", method = RequestMethod.POST)
  @ResponseBody
  protected String patientFilter(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    JSONArray list = new JSONArray();
    try {
      String fio = Util.get(req, "fio");
      List<Patients> patients = dPatient.getList("From Patients Where lower(surname) like '%" + fio + "%' Or lower(name) like '%" + fio + "%' Or lower(middlename) like '%" + fio + "%'");
      for(Patients pat: patients) {
        JSONObject obj = new JSONObject();
        obj.put("id", pat.getId());
        obj.put("fio", pat.getSurname() + " " + pat.getName() + " " + pat.getMiddlename());
        obj.put("start_date", Util.dateToString(pat.getDateBegin()));
        obj.put("end_date", Util.dateToString(pat.getDateEnd()));
        obj.put("birth_year", pat.getBirthyear());
        obj.put("palata", pat.getRoom().getName());
        //
        list.put(obj);
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    json.put("patients", list);
    return json.toString();
  }

  @RequestMapping(value = "patient/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String patientSave(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      HNPatients hnPatient = new HNPatients();
      hnPatient.setPatient(dPatient.get(Util.getInt(req, "patient")));
      if(Util.isNotNull(req, "id")) {
        hnPatient = dhnPatient.get(Util.getInt(req, "id"));
      } else {
        hnPatient.setDateEnd(hnPatient.getPatient().getDateEnd());
        hnPatient.setDayCount(10);
        hnPatient.setState("E");
        hnPatient.setClosed("N");
      }
      //
      dhnPatient.saveAndReturn(hnPatient);
      json.put("id", hnPatient.getId());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "patient/delete.s", method = RequestMethod.POST)
  @ResponseBody
  protected String deletePatient(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      dhnPatientDrug.deletePatient(Util.getInt(req, "id"));
      dhnPatient.delete(Util.getInt(req, "id"));
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "patient/drug/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String patientDrugSave(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    Connection conn = null;
    try {
      conn = DB.getConnection();
      HNPatientDrugs drug = new HNPatientDrugs();
      drug.setParent(dhnPatient.get(Util.getInt(req, "parent")));
      drug.setDrug(dDrug.get(Util.getInt(req, "drug")));

      drug.setCounter(dDrugCount.get(Util.getInt(req, "counter")));
      drug.setDrugPrice(DB.getSum(conn, "Select Max(t.price) price From (Select Max(t.price) price From drug_act_drugs t Where t.drug_Id = " + drug.getDrug().getId() + ") t"));
      drug.setPrice(drug.getDrug().getPrice() == null ? drug.getDrugPrice() : drug.getDrug().getPrice());
      drug.setServiceCount(Double.parseDouble(Util.get(req, "drug_count")));
      dhnPatientDrug.save(drug);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    } finally {
      DB.done(conn);
    }
    return json.toString();
  }

  @RequestMapping(value = "patient/drug/delete.s", method = RequestMethod.POST)
  @ResponseBody
  protected String patientDrugDelete(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      if(session.getUserId() == 1)
        dhnPatientDrug.delete(Util.getInt(req, "id"));
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "patient/confirm.s", method = RequestMethod.POST)
  @ResponseBody
  protected String patientConfirm(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      HNPatients pat = dhnPatient.get(Util.getInt(req, "id"));
      pat.setState("C");
      dhnPatient.save(pat);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }
  //endregion

  @RequestMapping(value = "new_drugs.s")
  protected String patientNewDrugs(HttpServletRequest req, Model model) {
    session = SessionUtil.getUser(req);
    session.setCurUrl("/head_nurse/new_drugs.s");
    try {
      int dep = dUser.get(session.getUserId()).getDept().getId();
      model.addAttribute("list", sPatient.getPatientNewDrugs(dep));
    } catch (Exception e) {
      e.printStackTrace();
    }
    return "med/head_nurse/new_drugs";
  }

  @RequestMapping(value = "stat.s")
  protected String stat(HttpServletRequest req, Model model) throws JSONException {
    session = SessionUtil.getUser(req);
    session.setCurUrl("/head_nurse/stat.s");
    String deps = "0,";
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      con = DB.getConnection();
      ps = con.prepareStatement(
        "Select c.dept_Id" +
          "  From User_Drug_Lines t, Drug_s_Direction_Deps c " +
          " Where c.direction_Id = t.direction_Id And t.user_Id = ?" +
          " Group By c.dept_Id");
      ps.setInt(1, session.getUserId());
      ps.execute();
      rs = ps.getResultSet();
      while(rs.next()) {
        deps += rs.getInt(1) + ",";
      }
      deps = deps.substring(0, deps.length() - 1);
      model.addAttribute("curDate", Util.getCurDate());
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(con);
    }
    model.addAttribute("depts", dDept.getList("From Depts Where id in (" + deps + ")"));

    return "med/head_nurse/stat";
  }

  @RequestMapping("/print.s")
  protected String print(HttpServletRequest req, Model model){
    session = SessionUtil.getUser(req);
    String dep = Util.get(req, "dep", "");
    SessionUtil.addSession(req, "fontSize", Req.get(req, "font", "14"));
    model.addAttribute("printPage", "/view/stat/home.s?stat=" + Util.getInt(req, "stat") + "&dep=" + dep + "&date=" + Util.get(req, "date"));
    return "/med/lv/print/stat/print";
  }
}
