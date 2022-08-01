package ckb.controllers.med;

import ckb.dao.admin.depts.DDept;
import ckb.dao.admin.users.DUser;
import ckb.dao.admin.users.DUserDrugLine;
import ckb.dao.med.amb.DAmbDrug;
import ckb.dao.med.amb.DAmbDrugDate;
import ckb.dao.med.amb.DAmbDrugRow;
import ckb.dao.med.amb.DAmbPatients;
import ckb.dao.med.dicts.rooms.DRooms;
import ckb.dao.med.drug.dict.categories.DDrugCategory;
import ckb.dao.med.drug.dict.directions.DDrugDirection;
import ckb.dao.med.drug.dict.directions.DDrugDirectionDep;
import ckb.dao.med.drug.dict.drugs.DDrug;
import ckb.dao.med.drug.dict.drugs.category.DDrugDrugCategory;
import ckb.dao.med.drug.dict.drugs.counter.DDrugCount;
import ckb.dao.med.drug.dict.measures.DDrugMeasure;
import ckb.dao.med.drug.write_off.DDrugWriteOff;
import ckb.dao.med.drug.write_off.DDrugWriteOffRow;
import ckb.dao.med.eat.dict.menuTypes.DEatMenuType;
import ckb.dao.med.eat.dict.table.DEatTable;
import ckb.dao.med.head_nurse.date.*;
import ckb.dao.med.head_nurse.direction.DHNDirection;
import ckb.dao.med.head_nurse.drug.DHNDrug;
import ckb.dao.med.head_nurse.patient.DHNPatient;
import ckb.dao.med.head_nurse.patient.drugs.DHNPatientDrug;
import ckb.dao.med.nurse.eat.DNurseEatPatient;
import ckb.dao.med.nurse.eat.DNurseEats;
import ckb.dao.med.patient.DPatient;
import ckb.dao.med.patient.DPatientDrugDate;
import ckb.dao.med.patient.DPatientDrugRow;
import ckb.dao.med.patient.DPatientEat;
import ckb.domains.admin.UserDrugLines;
import ckb.domains.admin.Users;
import ckb.domains.med.amb.AmbDrugDates;
import ckb.domains.med.amb.AmbDrugRows;
import ckb.domains.med.amb.AmbPatients;
import ckb.domains.med.dicts.Rooms;
import ckb.domains.med.drug.DrugWriteOffRows;
import ckb.domains.med.drug.DrugWriteOffs;
import ckb.domains.med.drug.dict.DrugCount;
import ckb.domains.med.drug.dict.DrugDirectionDeps;
import ckb.domains.med.drug.dict.DrugDrugCategories;
import ckb.domains.med.drug.dict.Drugs;
import ckb.domains.med.eat.dict.EatMenuTypes;
import ckb.domains.med.eat.dict.EatTables;
import ckb.domains.med.head_nurse.*;
import ckb.domains.med.nurse.eat.NurseEatPatients;
import ckb.domains.med.nurse.eat.NurseEats;
import ckb.domains.med.patient.PatientDrugDates;
import ckb.domains.med.patient.PatientDrugRows;
import ckb.domains.med.patient.PatientEats;
import ckb.domains.med.patient.Patients;
import ckb.models.Obj;
import ckb.models.ObjList;
import ckb.models.PatientList;
import ckb.models.eat.EatMenuTable;
import ckb.services.med.amb.SAmb;
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
  @Autowired private DDrugMeasure dDrugMeasure;
  @Autowired private DDrugCount dDrugCount;
  @Autowired private DUserDrugLine dUserDrugLine;
  @Autowired private DPatient dPatient;
  @Autowired private DDrugWriteOff dDrugWriteOff;
  @Autowired private DDrugWriteOffRow dDrugWriteOffRow;
  @Autowired private DDrugDirection dDrugDirection;
  @Autowired private DPatientDrugDate dPatientDrugDate;
  @Autowired private DPatientDrugRow dPatientDrugRow;
  @Autowired private DUser dUser;
  @Autowired private SPatient sPatient;
  @Autowired private DHNDate dhnDate;
  @Autowired private DHNDrug dhnDrug;
  @Autowired private DHNDirection dhnDirection;
  @Autowired private DHNDatePatientRow dhnDatePatientRow;
  @Autowired private DHNDateRow dhnDateRow;
  @Autowired private DHNOper dhnOper;
  @Autowired private DHNDatePatient dhnDatePatient;
  @Autowired private DDrugDrugCategory dDrugDrugCategory;
  @Autowired private DDrugCategory dDrugCategory;
  @Autowired private DDrugDirectionDep dDrugDirectionDep;
  @Autowired private DAmbPatients dAmbPatient;
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
  //endregion

  //region OUT_AMB_PATIENT
  @RequestMapping("out/amb.s")
  protected String outAmbPatient(HttpServletRequest req, Model m) {
    session = SessionUtil.getUser(req);
    session.setCurUrl("/head_nurse/out/amb.s");
    Users user = dUser.get(session.getUserId());
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
    if(user.isMainNurse())
      m.addAttribute("rows", dhnDate.getList("From HNDates Where patient != null And date Between '" + Util.dateDBBegin(startDate) + "' And '" + Util.dateDBBegin(endDate) + "' Order By id Desc"));
    else
      m.addAttribute("rows", dhnDate.getList("From HNDates Where patient != null And direction.id in " + arr + " And date Between '" + Util.dateDBBegin(startDate) + "' And '" + Util.dateDBBegin(endDate) + "' Order By id Desc"));
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
            drugSum += drug.getRasxod() * drug.getHndrug().getWriteOffRows().getPrice() / drug.getHndrug().getDropCount();
          drugSums += drug.getRasxod() * drug.getHndrug().getWriteOffRows().getPrice() / drug.getHndrug().getDropCount();
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
          json.put("msg", "���� �������� �� ����� ���� ������ ������� ����");
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
        HNDrugs drug = row.getHndrug();
        drug.setRasxod(drug.getRasxod() - row.getRasxod());
        dhnDrug.save(drug);
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
      dhnDateAmbRow.save(row);
      HNDrugs drug = row.getHndrug();
      drug.setRasxod(drug.getRasxod() + row.getRasxod());
      dhnDrug.save(drug);
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
      HNDrugs drug = row.getHndrug();
      drug.setRasxod(drug.getRasxod() - row.getRasxod());
      dhnDrug.save(drug);
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
            o.setC2(ff.getDrug().getName() + " (�������: " + (ff.getDrugCount() - ff.getRasxod()) + ")");
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
            dhnDateAmbRow.save(row);
            HNDrugs drug = row.getHndrug();
            drug.setRasxod(drug.getRasxod() + row.getRasxod());
            dhnDrug.save(drug);
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

  //region OUT_PATIENT
  @RequestMapping("out/patient.s")
  protected String outPatient(HttpServletRequest req, Model m) {
    session = SessionUtil.getUser(req);
    session.setCurUrl("/head_nurse/out/patient.s");
    Users user = dUser.get(session.getUserId());
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
    if(user.isMainNurse())
      m.addAttribute("rows", dhnDate.getList("From HNDates Where receiver = null And date Between '" + Util.dateDBBegin(startDate) + "' And '" + Util.dateDBBegin(endDate) + "' Order By date Desc"));
    else
      m.addAttribute("rows", dhnDate.getList("From HNDates Where direction.id in " + arr + " And receiver = null And date Between '" + Util.dateDBBegin(startDate) + "' And '" + Util.dateDBBegin(endDate) + "' Order By date Desc"));
    //
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
      obj.setDirection(dDrugDirection.get(Util.getInt(req, "direction")));
      obj.setReceiver(null);
      if(obj.getId() == null) {
        obj.setCrBy(dUser.get(session.getUserId()));
        obj.setCrOn(new Date());
        obj.setDate(Util.stringToDate(Util.get(req, "doc_date")));
        obj.setState("ENT");
        if(obj.getDate().before(Util.stringToDate(Util.getCurDate()))) {
          json.put("success", false);
          json.put("msg", "���� �������� �� ����� ���� ������ ������� ����");
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
      for(HNDatePatientRows row: rows) {
        HNDrugs drug = row.getDrug();
        drug.setRasxod(drug.getRasxod() - row.getRasxod());
        dhnDrug.save(drug);
        dhnDatePatientRow.delete(row.getId());
      }
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
      if(Util.isNull(req, "edit")) {
        HNDatePatientRows row = new HNDatePatientRows();
        row.setDrug(dhnDrug.get(Util.getInt(req, "id")));
        row.setDoc(dhnDate.get(Util.getInt(req, "doc")));
        row.setRasxod(Double.parseDouble(Util.get(req, "rasxod")));
        row.setDate(row.getDoc().getDate());
        row.setPatient(dPatient.get(Util.getInt(req, "patient")));
        row.setMeasure(row.getDrug().getMeasure());
        row.setCrBy(session.getUserId());
        row.setCrOn(new Date());
        dhnDatePatientRow.save(row);
        HNDrugs drug = row.getDrug();
        drug.setRasxod(drug.getRasxod() + row.getRasxod());
        dhnDrug.save(drug);
      } else {
        HNDatePatientRows row = dhnDatePatientRow.get(Util.getInt(req, "id"));
        HNDrugs saldo = row.getDrug();
        saldo.setRasxod(saldo.getRasxod() - row.getRasxod() + Double.parseDouble(Util.get(req, "rasxod")));
        dhnDrug.save(saldo);
        row.setRasxod(Double.parseDouble(Util.get(req, "rasxod")));
        dhnDatePatientRow.save(row);
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
            dhnDatePatientRow.save(row);
            HNDrugs drug = row.getDrug();
            drug.setRasxod(drug.getRasxod() + row.getRasxod());
            dhnDrug.save(drug);
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
    m.addAttribute("pat", dPatient.get(Util.getInt(req, "patient")));
    Users user = dUser.get(session.getUserId());
    if(user.isMainNurse()) {
      m.addAttribute("drugs", dhnDatePatientRow.getList("From HNDatePatientRows Where doc.id = " + doc.getId() + " And patient.id = " + Util.get(req, "patient")));
    } else {
      m.addAttribute("drugs", dhnDatePatientRow.getList("From HNDatePatientRows Where drug.direction.id = " + doc.getDirection().getId() + " And doc.id = " + doc.getId() + " And patient.id = " + Util.get(req, "patient")));
    }
    //
    return "/med/head_nurse/out/patient/list";
  }

  @RequestMapping("out/patient/addDrug.s")
  protected String outPatientAddDrug(HttpServletRequest req, Model m) {
    m.addAttribute("drugs", dhnDrug.getList("From HNDrugs t Where direction.id = " + Util.getInt(req, "dr")+ " And t.drugCount - ifnull(t.rasxod, 0) > 0 And drug.id = " + Util.getInt(req, "id")));
    //
    return "/med/head_nurse/out/patient/addDrug";
  }

  @RequestMapping("out/patient/addDateDrugs.s")
  protected String outPatientAddDrugs(HttpServletRequest req, Model m) {
    Date minDate = dPatientDrugDate.minDate(Util.getInt(req, "id"));
    Date maxDate = dPatientDrugDate.maxDate(Util.getInt(req, "id"));
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
    List<PatientDrugDates> dds = dPatientDrugDate.getList("From PatientDrugDates Where checked = 1 And patientDrug.patient.id = " + Util.get(req, "id") + " And date = '" + Util.dateDB(d) + "'");
    List<Obj> drugs = new ArrayList<Obj>();
    for(PatientDrugDates dd: dds) {
      List<PatientDrugRows> rows = dPatientDrugRow.getList("From PatientDrugRows Where patientDrug.id = " + dd.getPatientDrug().getId());
      for(PatientDrugRows row: rows) {
        if(!row.getSource().equals("own")) {
          Obj obj = new Obj();
          obj.setId(row.getDrug().getId());
          obj.setName(row.getDrug().getName());
          List<HNDrugs> ffs = dhnDrug.getList("From HNDrugs t Where direction.id = " + Util.getInt(req, "dr")+ " And t.drugCount - ifnull(t.rasxod, 0) > 0 And drug.id = " + row.getDrug().getId());
          List<ObjList> list = new ArrayList<ObjList>();
          for(HNDrugs ff: ffs) {
            ObjList o = new ObjList();
            o.setC1(ff.getId().toString());
            o.setC2(ff.getDrug().getName() + " (�������: " + (ff.getDrugCount() - ff.getRasxod()) + ")");
            o.setC3(ff.getMeasure().getName());
            o.setC4((ff.getDrugCount() - ff.getRasxod()) + "");
            o.setC5(row.getExpanse().toString());
            list.add(o);
          }
          obj.setList(list);
          drugs.add(obj);
        }
      }
    }
    m.addAttribute("drugs", drugs);
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
      json.put("msg", "������ ������� ���������");
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
      if(dhnDatePatientRow.getCount("From HNDatePatientRows Where doc.id = " + dp.getDate().getId() + " And patient.id = " + dp.getPatient().getId()) == 0) {
        dhnDatePatient.delete(dp.getId());
        json.put("msg", "������ ������� ���������");
        json.put("success", true);
      } else {
        json.put("msg", "������ ������� ������! �� ������� �������� ���������� �������� ����������");
        json.put("success", false);
      }
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
      HNDrugs drug = row.getDrug();
      drug.setRasxod(drug.getRasxod() - row.getRasxod());
      dhnDrug.save(drug);
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
    m.addAttribute("rows", dhnDate.getList("From HNDates Where direction.id in " + arr + " And date Between '" + Util.dateDBBegin(startDate) + "' And '" + Util.dateDBBegin(endDate) + "' And receiver.id > 0 Order By date Desc"));
    //
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
      model.addAttribute("receivers", dhnDirection.getAll());
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
      if(Util.isNull(req, "edit")) {
        HNDateRows row = new HNDateRows();
        row.setDrug(dhnDrug.get(Util.getInt(req, "id")));
        row.setDoc(dhnDate.get(Util.getInt(req, "doc")));
        row.setRasxod(Double.parseDouble(Util.get(req, "rasxod")));
        row.setCrBy(session.getUserId());
        row.setCrOn(new Date());
        dhnDateRow.save(row);
        HNDrugs drug = row.getDrug();
        drug.setRasxod(drug.getRasxod() + row.getRasxod());
        dhnDrug.save(drug);
      } else {
        HNDateRows row = dhnDateRow.get(Util.getInt(req, "id"));
        HNDrugs saldo = row.getDrug();
        saldo.setRasxod(saldo.getRasxod() - row.getRasxod() + Double.parseDouble(Util.get(req, "rasxod")));
        dhnDrug.save(saldo);
        row.setRasxod(Double.parseDouble(Util.get(req, "rasxod")));
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
      HNDrugs saldo = row.getDrug();
      saldo.setRasxod(saldo.getRasxod() - row.getRasxod());
      dhnDrug.save(saldo);
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
        HNDrugs drug = row.getDrug();
        drug.setRasxod(drug.getRasxod() - row.getRasxod());
        dhnDrug.save(drug);
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
            json.put("msg", "������ ����������� �������� ��� ������");
            return json.toString();
          }
        } else {
          if (dhnDateAmbRow.getCount("From HNDateAmbRows Where doc.id = " + doc.getId()) == 0) {
            json.put("success", false);
            json.put("msg", "������ ����������� �������� ��� ������");
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
          json.put("msg", "������ ����������� �������� ��� ������");
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

  //region �������
  @RequestMapping("shock.s")
  protected String shock(HttpServletRequest req, Model m) {
    session = SessionUtil.getUser(req);
    session.setCurUrl("/head_nurse/shock.s");
    Users user = dUser.get(session.getUserId());
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
    if(user.isMainNurse())
      m.addAttribute("rows", dhnDate.getList("From HNOpers Where date Between '" + Util.dateDBBegin(startDate) + "' And '" + Util.dateDBBegin(endDate) + "' Order By crOn Desc"));
    else
      m.addAttribute("rows", dhnDate.getList("From HNOpers Where (parent.id in " + arr + " Or direction.id in " + arr + ") And date Between '" + Util.dateDBBegin(startDate) + "' And '" + Util.dateDBBegin(endDate) + "' Order By crOn Desc"));
    //
    m.addAttribute("period_start", startDate);
    m.addAttribute("period_end", endDate);
    return "/med/head_nurse/out/shock/index";
  }

  @RequestMapping("shock/save.s")
  protected String shockSave(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/head_nurse/shock/save.s?id=" + Util.getInt(req, "id"));
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
      model.addAttribute("directions", dUserDrugLine.getList("From UserDrugLines Where user.id = " + session.getUserId()));
      model.addAttribute("shocks", dDrugDirection.getAll());
      model.addAttribute("rows", dhnDateRow.getList("From HNDrugs Where parent_row > 0 And parent_id = " + obj.getId()));
      model.addAttribute("obj", obj);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(conn);
    }
    //
    return "/med/head_nurse/out/shock/addEdit";
  }

  @RequestMapping(value = "shock/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String shockSave(HttpServletRequest req) throws JSONException {
    session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      String id = Util.nvl(req, "id", "0");
      HNOpers obj = id.equals("0") || id.equals("") ? new HNOpers() : dhnOper.get(Integer.parseInt(id));
      obj.setParent(dDrugDirection.get(Util.getInt(req, "parent")));
      obj.setDirection(dDrugDirection.get(Util.getInt(req, "direction")));
      if(obj.getParent().getId().equals(obj.getDirection().getId())) {
        json.put("msg", "����� � ���������� �� ����� ���� ����������");
        json.put("success", false);
        return json.toString();
      }
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

  @RequestMapping(value = "shock/row/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String shockRowSave(HttpServletRequest req) throws JSONException {
    session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      HNDrugs row = dhnDrug.get(Util.getInt(req, "id"));;
      row.setId(null);
      row.setParent_row(Util.getInt(req, "id"));
      row.setParent_id(Util.getInt(req, "doc"));
      row.setDirection(dhnOper.get(Util.getInt(req, "doc")).getDirection());
      row.setDrugCount(Double.parseDouble(Util.get(req, "rasxod")));
      row.setRasxod(0D);
      dhnDrug.save(row);
      HNDrugs drug = dhnDrug.get(Util.getInt(req, "id"));
      drug.setRasxod(drug.getRasxod() + row.getDrugCount());
      dhnDrug.save(drug);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "shock/row/delete.s", method = RequestMethod.POST)
  @ResponseBody
  protected String shockRowDelete(HttpServletRequest req) throws JSONException {
    session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      HNDrugs row = dhnDrug.get(Util.getInt(req, "id"));
      if(row.getRasxod() > 0) {
        json.put("success", false);
        json.put("msg", "������ ������� ������ ���������� ��������� ��������");
        return json.toString();
      }
      HNDrugs saldo = dhnDrug.get(row.getParent_row());
      saldo.setRasxod(saldo.getRasxod() - row.getDrugCount());
      dhnDrug.save(saldo);
      dhnDrug.delete(row.getId());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "shock/delete.s", method = RequestMethod.POST)
  @ResponseBody
  protected String shockDelete(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      int id = Util.getInt(req, "id");
      List<HNDrugs> rows = dhnDrug.getList("From HNDrugs Where parent_id = " + id);
      for(HNDrugs row: rows) {
        if(row.getRasxod() > 0) {
          json.put("success", false);
          json.put("msg", "������ ������� ������ ���������� ��������� ��������");
          return json.toString();
        }
        HNDrugs drug = dhnDrug.get(row.getParent_row());
        drug.setRasxod(drug.getRasxod() - row.getDrugCount());
        dhnDrug.save(drug);
        dhnDrug.delete(row.getId());
      }
      dhnOper.delete(id);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "shock/confirm.s", method = RequestMethod.POST)
  @ResponseBody
  protected String shockConfirm(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      HNOpers doc = dhnOper.get(Util.getInt(req, "id"));
      if(dhnDrug.getCount("From HNDrugs Where parent_row > 0 And parent_id = " + doc.getId()) == 0) {
        json.put("success", false);
        json.put("msg", "������ ����������� �������� ��� ������");
        return json.toString();
      }
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

  //region SALDO
  @RequestMapping("saldo.s")
  protected String saldo(HttpServletRequest req, Model m) {
    session = SessionUtil.getUser(req);
    session.setCurUrl("/head_nurse/saldo.s");
    String page_code = Util.get(req, "code", "saldo");
    String filter = Util.toUTF8(Util.get(req, "filter", ""));
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
    for(HNDrugs drug: drugs) {
      drug.setParent_row(1);
      if(drug.getWriteOffRows() != null && drug.getWriteOffRows().getIncome() != null) {
        if(drug.getWriteOffRows().getIncome().getEndDate().before(new Date()))
          drug.setParent_row(-1);
        Calendar db = new GregorianCalendar();
        db.setTime(drug.getWriteOffRows().getIncome().getEndDate());
        Calendar de = new GregorianCalendar();
        de.setTime(new Date());
        int yb = db.get(Calendar.YEAR) - de.get(Calendar.YEAR);
        int mb = db.get(Calendar.MONTH) - de.get(Calendar.MONTH);
        if(yb*12+mb < 4)
          drug.setParent_row(0);
      }
    }
    m.addAttribute("rows", drugs);
    m.addAttribute("drugs", dDrug.getList("From Drugs Order By name"));
    m.addAttribute("receivers", lines);
    m.addAttribute("filter_direction", direction);
    m.addAttribute("filter_word", filter);
    m.addAttribute("page_code", page_code);
    m.addAttribute("sysdate", new Date());
    return "/med/head_nurse/saldo/index";
  }

  @RequestMapping(value = "saldo/counter.s", method = RequestMethod.POST)
  @ResponseBody
  protected String saldoCounter(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      JSONArray rows = new JSONArray();
      List<DrugCount> counts = dDrugCount.getList("From DrugCount Where drug.id = " + Util.getInt(req, "id"));
      for(DrugCount count: counts) {
        JSONObject obj = new JSONObject();
        obj.put("id", count.getId());
        obj.put("drug_count", count.getDrugCount());
        obj.put("measure_id", count.getMeasure().getId());
        obj.put("measure", count.getMeasure().getName());
        rows.put(obj);
      }
      json.put("rows", rows);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "saldo/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String saldoSave(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      HNDrugs drug = new HNDrugs();
      drug.setDrug(dDrug.get(Util.getInt(req, "id")));
      drug.setDirection(dDrugDirection.get(Util.getInt(req, "direction")));
      drug.setParent_id(0);
      drug.setWriteOffRows(null);
      drug.setCounter(dDrugCount.get(Util.getInt(req, "counter")));
      drug.setMeasure(drug.getCounter().getMeasure());
      drug.setParentCount(Double.parseDouble(Util.get(req, "saldo")));
      drug.setDropCount(drug.getCounter().getDrugCount());
      drug.setDrugCount(drug.getParentCount());
      drug.setRasxod(0D);
      drug.setCrBy(session.getUserId());
      drug.setCrOn(new Date());
      dhnDrug.save(drug);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "saldo/row/del.s", method = RequestMethod.POST)
  @ResponseBody
  protected String saldoRowDel(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      dhnDrug.delete(Util.getInt(req, "id"));
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }
  //endregion

  //region INCOMES
  @RequestMapping("incomes.s")
  protected String incomes(HttpServletRequest req, Model m) {
    session = SessionUtil.getUser(req);
    session.setCurUrl("/head_nurse/incomes.s");
    //
    List<UserDrugLines> lines = dUserDrugLine.getList("From UserDrugLines Where user.id = " + session.getUserId());
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
    List<DrugWriteOffs> acts = dDrugWriteOff.getList("From DrugWriteOffs Where direction.id in " + arr + " And regDate Between '" + Util.dateDBBegin(startDate) + "' And '" + Util.dateDBBegin(endDate) + "' Order By id Desc");
    List<ObjList> list = new ArrayList<ObjList>();
    //
    for(DrugWriteOffs act : acts) {
      ObjList obj = new ObjList();
      obj.setIb(act.getId().toString());
      obj.setC1("�" + act.getRegNum() + " �� " + Util.dateToString(act.getRegDate()));
      obj.setC2(dDrugWriteOffRow.getCount("From DrugWriteOffRows Where doc.id = " + act.getId()).toString());
      if(act.getId() != null) {
        Double sum = dDrugWriteOffRow.getActSum(act.getId());
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
      obj.setC10(act.getUnpack() == null ? "N" : act.getUnpack());
      list.add(obj);
    }
    //
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
    DrugWriteOffs obj = Util.getInt(req, "id") > 0 ? dDrugWriteOff.get(Util.getInt(req, "id")) : new DrugWriteOffs();
    if(Util.getInt(req, "id") == 0) obj.setId(0);
    model.addAttribute("rows", dDrugWriteOffRow.getList("From DrugWriteOffRows t Where t.doc.id = " + obj.getId()));
    List<HNDrugs> drugs = dhnDrug.getList("From HNDrugs Where writeOffRows.doc.id = " + obj.getId());
    if(obj.getId() == 0) {
      obj.setRegDate(new Date());
    }

    List<Obj> list = new ArrayList<Obj>();
    for(HNDrugs row: drugs) {
      Obj o = new Obj();
      o.setId(row.getId());
      o.setName(row.getDrug().getName());
      o.setDrugCount(row.getDrugCount());
      o.setClaimCount(row.getParentCount());
      List<ObjList> oo = new ArrayList<ObjList>();
      List<DrugCount> counts = dDrugCount.getList("From DrugCount Where drug.id = " + row.getDrug().getId());
      for(DrugCount count: counts) {
        ObjList od = new ObjList();
        od.setIb(count.getId().toString());
        od.setC1(count.getDrugCount().toString());
        od.setC2(count.getMeasure().getId().toString());
        od.setC3(count.getMeasure().getName());
        oo.add(od);
      }
      o.setExtraId(row.getCounter() == null ? 0 : row.getCounter().getId());
      o.setActive(row.getCounter() != null);
      o.setFio(row.getMeasure() != null ? row.getMeasure().getName() : "");
      o.setList(oo);
      list.add(o);
    }
    model.addAttribute("drops", list);
    //
    List<UserDrugLines> lines = dUserDrugLine.getList("From UserDrugLines Where user.id = " + session.getUserId() + " And (direction.shock != 'Y' Or direction.shock = null)");
    model.addAttribute("directions", lines);
    model.addAttribute("measures", dDrugMeasure.getList("From DrugMeasures Where incomeFlag = 1"));
    model.addAttribute("drugs", dDrug.getList("From Drugs Order By name"));
    model.addAttribute("obj", obj);
    Util.makeMsg(req, model);
    return "/med/head_nurse/incomes/addEdit";
  }

  @RequestMapping(value = "incomes/drop.s", method = RequestMethod.POST)
  @ResponseBody
  protected String dropIncome(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    DrugWriteOffs doc = dDrugWriteOff.get( Util.getInt(req, "id"));
    try {
      boolean isAll = true;
      List<DrugWriteOffRows> rows = dDrugWriteOffRow.getList("From DrugWriteOffRows t Where t.doc.id = " + doc.getId());
      for(DrugWriteOffRows row: rows) {
        if(row.getDrugCount() != null && row.getDrugCount() > 0) {
          HNDrugs drug;
          List<HNDrugs> dd = new ArrayList<HNDrugs>();
          try {
            dd = dhnDrug.getList("From HNDrugs t Where t.writeOffRows.id = " + row.getId());
            drug = dd.get(0);
          } catch (Exception e) {
            drug = new HNDrugs();
          }
          if(dd.size() > 1) {
            json.put("success", false);
            json.put("msg", "������ � ��������� ���� �������� ������������");
            return json.toString();
          }
          if (drug.getId() == null) {
            drug.setParent_id(row.getDoc().getId());
            drug.setParentCount(row.getDrugCount() == null ? 0 : row.getDrugCount());
            drug.setDrug(row.getDrug());
            drug.setRasxod(0D);
            drug.setWriteOffRows(row);
            drug.setDirection(row.getDoc().getDirection());
          }
          if (drug.getCounter() == null) {
            List<DrugCount> counts = dDrugCount.getList("From DrugCount Where drug.id = " + row.getDrug().getId());
            if (counts.size() == 1) {
              drug.setCounter(counts.get(0));
              drug.setMeasure(drug.getCounter().getMeasure());
              drug.setDropCount(drug.getCounter().getDrugCount());
              drug.setDrugCount(drug.getDropCount() * drug.getParentCount());
            } else isAll = false;
          }
          if (drug.getParentCount() > 0) {
            dhnDrug.save(drug);
          }
        }
      }
      if(isAll) {
        doc.setUnpack("Y");
      } else {
        doc.setUnpack("D");
      }
      dDrugWriteOff.save(doc);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "incomes/drop/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String dropRowSave(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      HNDrugs drug = dhnDrug.get(Util.getInt(req, "id"));
      DrugCount counter = dDrugCount.get(Util.getInt(req, "value"));
      drug.setCounter(counter);
      drug.setMeasure(counter.getMeasure());
      drug.setDropCount(counter.getDrugCount());
      drug.setDrugCount(drug.getParentCount() * drug.getDropCount());
      dhnDrug.save(drug);
      if(dDrugWriteOffRow.getCount("From HNDrugs t Where dropCount = null And parent_id = " + drug.getWriteOffRows().getDoc().getId()) == 0) {
        DrugWriteOffs doc = drug.getWriteOffRows().getDoc();
        doc.setUnpack("Y");
        dDrugWriteOff.save(doc);
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "incomes/row/copy.s", method = RequestMethod.POST)
  @ResponseBody
  protected String incomeRowCopy(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      HNDrugs fact = dhnDrug.get(Util.getInt(req, "id"));
      Double rc = Double.parseDouble(Util.get(req, "drug_count", "0"));
      if(fact.getParentCount() <= rc || rc <= 0) {
        json.put("msg", "���-�� ��� ���������� �� ������������� �����������");
        json.put("success", false);
      }
      fact.setParentCount(fact.getParentCount() - rc);
      if(fact.getCounter() != null) {
        fact.setDrugCount(fact.getParentCount() * fact.getCounter().getDrugCount());
      }
      dhnDrug.save(fact);
      fact.setId(null);
      fact.setParentCount(rc);
      fact.setRasxod(0D);
      fact.setDropCount(null);
      fact.setCounter(null);
      fact.setDrugCount(null);
      fact.setMeasure(null);
      dhnDrug.save(fact);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "incomes/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String incomeSave(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      String id = Util.nvl(req, "id", "0");
      DrugWriteOffs obj = id.equals("0") || id.equals("") ? new DrugWriteOffs() : dDrugWriteOff.get(Integer.parseInt(id));
      obj.setRegNum(Util.get(req, "reg_num"));
      obj.setDirection(dDrugDirection.get(Util.getInt(req, "direction")));
      obj.setRegDate(Util.getDate(req, "reg_date"));
      obj.setState("ENT");
      obj.setCrOn(obj.getId() == null ? new Date() : obj.getCrOn());
      obj.setInfo(Util.get(req, "info"));
      dDrugWriteOff.saveAndReturn(obj);
      json.put("id", obj.getId());
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
      List<DrugWriteOffRows> rows = dDrugWriteOffRow.getList("From DrugWriteOffRows Where doc.id = " + Util.getInt(req, "id"));
      for(DrugWriteOffRows row : rows)
        dDrugWriteOffRow.delete(row.getId());
      dDrugWriteOff.delete(Util.getInt(req, "id"));
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
    try {
      DrugWriteOffRows row = new DrugWriteOffRows();
      row.setDoc(dDrugWriteOff.get(Util.getInt(req, "doc")));
      row.setClaimCount(Double.parseDouble(Util.get(req, "drug_count")));
      row.setDrug(dDrug.get(Util.getInt(req, "drug_id")));
      row.setMeasure(Util.isNotNull(req, "measure_id") ? dDrugMeasure.get(Util.getInt(req, "measure_id")) : null);
      dDrugWriteOffRow.save(row);
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
      dDrugWriteOffRow.delete(Util.getInt(req, "id"));
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
      DrugWriteOffs income = dDrugWriteOff.get(Util.getInt(req, "id"));
      long counter = dDrugWriteOffRow.getCount("From DrugWriteOffRows Where doc.id = " + income.getId());
      if(counter == 0) {
        json.put("success", false);
        json.put("msg", "������ ����������� ������ ������!");
        return json.toString();
      }
      income.setState("SND");
      income.setSendOn(new Date());
      dDrugWriteOff.save(income);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }
  //endregion

  //region DICTS
  @RequestMapping("dicts.s")
  protected String dicts(HttpServletRequest req, Model m) {
    session = SessionUtil.getUser(req);
    session.setCurUrl("/head_nurse/dicts.s");
    if(!session.getCurSubUrl().contains("/head_nurse/dicts/"))
      session.setCurSubUrl("/head_nurse/dicts/measures.s");
    if(session.getCurSubUrl().contains("/head_nurse/dicts/drugs.s") && Util.isNotNull(req, "cat"))
      session.setCurSubUrl("/head_nurse/dicts/drugs.s?cat=" + Util.get(req, "cat"));
    //
    return "/med/head_nurse/dicts/index";
  }

  @RequestMapping("dicts/measures.s")
  protected String dicstMeasures(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    session.setCurSubUrl("/head_nurse/dicts/measures.s");
    //
    model.addAttribute("list", dDrugMeasure.getAll());
    return "/med/head_nurse/dicts/measures/index";
  }

  @RequestMapping("dicts/directions.s")
  protected String dicstDirection(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    session.setCurSubUrl("/head_nurse/dicts/directions.s");
    //
    model.addAttribute("list", dhnDirection.getAll());
    List<UserDrugLines> lines = dUserDrugLine.getList("From UserDrugLines Where user.id = " + session.getUserId());
    StringBuilder arr = new StringBuilder("(");
    for(UserDrugLines line: lines) {
      arr.append(line.getDirection().getId()).append(",");
    }
    arr.append("0)");
    model.addAttribute("directions", dDrugDirection.getList("From DrugDirections Where id in " + arr));
    return "/med/head_nurse/dicts/directions/index";
  }

  @RequestMapping("dicts/drugs.s")
  protected String dictDrugs(HttpServletRequest req, Model m) {
    session = SessionUtil.getUser(req);
    String ct = Util.get(req, "cat");
    session.setCurSubUrl("/head_nurse/dicts/drugs.s" + (Util.isNotNull(req, "cat") ? "?cat=" + ct : ""));
    //
    List<ObjList> list = new ArrayList<ObjList>();
    List<Drugs> drugs = dDrug.getList("From Drugs Order By name");
    for(Drugs drug: drugs) {
      ObjList obj = new ObjList();
      obj.setC1(drug.getId().toString());
      obj.setC2(drug.getName());
      obj.setC3("");
      List<DrugCount> counters = dDrugCount.getList("From DrugCount Where drug.id = " + drug.getId());
      for(DrugCount dg: counters) {
        obj.setC3(obj.getC3() + (obj.getC3().equals("") ? "" : " / ") + dg.getDrugCount() + " " + dg.getMeasure().getName());
      }
      List<DrugDrugCategories> cats = dDrugDrugCategory.getList("From DrugDrugCategories Where drug.id = " + drug.getId());
      int i=0;
      String ids = "";
      for(DrugDrugCategories cat: cats) {
        obj.setC5((i == 0 ? "" : obj.getC5() + " + ") + cat.getCategory().getName());
        ids += cat.getCategory().getId() + ",";
        i++;
      }
      obj.setC4(drug.getState());
      if(ct == null || ct.equals("0")) {
        list.add(obj);
      } else {
        if(ids.contains(ct + ","))
          list.add(obj);
      }
    }
    m.addAttribute("list", list);
    m.addAttribute("ct", ct == null ? 0 : Integer.parseInt(ct));
    m.addAttribute("categories", dDrugCategory.getList("From DrugCategories Order By Id Desc"));
    return "/med/head_nurse/dicts/drugs/index";
  }

  @RequestMapping("dicts/drug/info.s")
  protected String drugInfo(HttpServletRequest req, Model m) {
    session = SessionUtil.getUser(req);
    //
    m.addAttribute("obj", dDrug.get(Util.getInt(req, "id")));
    m.addAttribute("rows", dDrugCount.getList("From DrugCount Where drug.id = " + Util.get(req, "id")));
    m.addAttribute("measures", dDrugMeasure.getList("From DrugMeasures Order By Id Desc"));
    //
    return "/med/head_nurse/dicts/drugs/addEdit";
  }

  @RequestMapping(value = "dicts/drug/info.s", method = RequestMethod.POST)
  @ResponseBody
  protected String drugSave(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      String[] counters = req.getParameterValues("counter");
      String[] measures = req.getParameterValues("measure");
      String[] ids = req.getParameterValues("ids");
      for(int i=0;i<counters.length;i++) {
        //
        DrugCount count;
        if(ids[i].equals("0")) {
          count = new DrugCount();
        } else {
          count = dDrugCount.get(Integer.parseInt(ids[i]));
        }
        count.setDrug(dDrug.get(Util.getInt(req, "id")));
        count.setDrugCount(Double.parseDouble(counters[i]));
        count.setMeasure(dDrugMeasure.get(Integer.parseInt(measures[i])));
        //
        dDrugCount.save(count);
      }
      String res = "";
      List<DrugCount> cts = dDrugCount.getList("From DrugCount Where drug.id = " + Util.getInt(req, "id"));
      for(DrugCount dg: cts) {
        res += (res.equals("") ? "" : " / ") + dg.getDrugCount() + " " + dg.getMeasure().getName();
      }
      json.put("res", res);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "dicts/drug/del.s", method = RequestMethod.POST)
  @ResponseBody
  protected String drugDel(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      dDrugCount.delete(Util.getInt(req, "id"));
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/dict/delete.s", method = RequestMethod.POST)
  @ResponseBody
  protected String deleteDict(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      if(Util.get(req, "code").equals("direction")) dhnDirection.delete(Util.getInt(req, "id"));
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/dict/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String save(HttpServletRequest req) throws JSONException {
    Session session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      if(Util.get(req, "code").equals("direction")) {
        HNDirections obj = Util.isNull(req, "id") ? new HNDirections() : dhnDirection.get(Util.getInt(req, "id"));
        obj.setName(Util.get(req, "name"));
        obj.setState(Util.isNull(req, "state") ? "P" : "A");
        if (Util.isNull(req, "id")) {
          obj.setCrBy(session.getUserId());
          obj.setCrOn(new Date());
        }
        dhnDirection.save(obj);
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/dict/get.s", method = RequestMethod.POST)
  @ResponseBody
  protected String getDict(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      if(Util.get(req, "code").equals("direction")) {
        HNDirections obj = dhnDirection.get(Util.getInt(req, "id"));
        json.put("id", obj.getId());
        json.put("name", obj.getName());
        json.put("state", obj.getState());
      }
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
    if(setFilter != null || filter == null || filter.equals("")) filter = Util.toUTF8(Util.get(req, "filter", "")).toUpperCase();
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
    m.addAttribute("list", dhnPatient.getList("From HNPatients t Where " + where + " (t.dateEnd = null Or t.dateEnd = '' Or t.dateEnd Between '" + Util.dateDBBegin(startDate) + "' And '" + Util.dateDBBegin(endDate) + "') Order By t.id Desc"));
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
      drug.setDrugPrice(DB.getSum(conn, "Select Max(t.price) price From (Select Max(t.price) price From drug_act_drugs t Where t.drug_Id = " + drug.getDrug().getId() + " Union ALL Select Max(t.price) price From drug_saldos t Where t.drug_Id = " + drug.getDrug().getId() + ") t"));
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

  //region HN_PATIENTS
  @RequestMapping("total/patients.s")
  protected String totalPatients(HttpServletRequest req, Model m) {
    session = SessionUtil.getUser(req);
    session.setCurUrl("/head_nurse/total/patients.s");
    String setFilter = Util.get(req, "set");
    String filter = session.getFilters().get("hn_patient_filter");
    if(setFilter != null || filter == null || filter.equals("")) filter = Util.toUTF8(Util.get(req, "filter", "")).toUpperCase();
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
    List<Patients> patients = dPatient.getList("From Patients t Where " + where + " dept.id in (" + depIds + ") And  t.dateBegin Between '" + Util.dateDB(startDate) + "' And '" + Util.dateDB(endDate) + "' Order By Id Desc");
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
            " Where m.id = t.measure_id And t.drug_id = c.id And c.drug_id = d.id And t.patient_id = ? " +
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
            obj.setC3(row.getCounter().getMeasure().getName());
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
      //
      Connection conn = null;
      PreparedStatement ps = null;
      ResultSet rs = null;
      try {
        conn = DB.getConnection();
        ps = conn.prepareStatement(
          "Select c.id hndrug, d.id drug_id, d.name, m.id measure_id, m.name measure, ifnull((Select fd.price From drug_write_off_rows fd where fd.Id = c.writeOffRows_Id), 0) price, Sum(t.rasxod) summ " +
            "     From Hn_Date_Patient_Rows t, HN_Drugs c, Drug_s_Names d, Drug_s_Measures m, Hn_Dates f " +
            "     Where m.id = t.measure_id And t.drug_id = c.id And c.drug_id = d.id And t.patient_id = ? " +
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
          HNDrugs hndrug = dhnDrug.get(rs.getInt("hndrug"));
          drug.setCounter(hndrug.getCounter());
          drug.setDrugPrice(rs.getDouble("price"));
          drug.setPrice(drug.getDrug().getPrice() == null ? drug.getDrugPrice() : drug.getDrug().getPrice());
          drug.setServiceCount(rs.getDouble("summ"));
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
      //
      dhnPatientDrug.deletePatient(hnPatient.getId());
      //
      Connection conn = null;
      PreparedStatement ps = null;
      ResultSet rs = null;
      try {
        conn = DB.getConnection();
        ps = conn.prepareStatement(
          "Select c.id hndrug, d.id drug_id, d.name, m.id measure_id, m.name measure, ifnull((Select fd.price From drug_write_off_rows fd where fd.Id = c.writeOffRows_Id), 0) price, Sum(t.rasxod) summ " +
            "     From Hn_Date_Patient_Rows t, HN_Drugs c, Drug_s_Names d, Drug_s_Measures m, Hn_Dates f " +
            "     Where m.id = t.measure_id And t.drug_id = c.id And c.drug_id = d.id And t.patient_id = ? " +
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
          HNDrugs hndrug = dhnDrug.get(rs.getInt("hndrug"));
          drug.setCounter(hndrug.getCounter());
          drug.setDrugPrice(rs.getDouble("price"));
          drug.setPrice(drug.getDrug().getPrice() == null ? drug.getDrugPrice() : drug.getDrug().getPrice());
          drug.setServiceCount(rs.getDouble("summ"));
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
      list = dNurseEat.getList("From NurseEats Where actDate Between '" + Util.dateDBBegin(startDate) + "' And '" + Util.dateDBBegin(endDate) + "' Order By Id Desc");
    else
      list = dNurseEat.getList("From NurseEats Where actDate Between '" + Util.dateDBBegin(startDate) + "' And '" + Util.dateDBBegin(endDate) + "' And crBy.id = " + session.getUserId() + " Order By Id Desc");
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
        json.put("msg", "����� ������ ��� ���������� � ��");
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
  public String eatEdit(HttpServletRequest req, Model model){
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
        json.put("msg", "������ ����������� �������� ��� ������");
      }
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }
  //endregion

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