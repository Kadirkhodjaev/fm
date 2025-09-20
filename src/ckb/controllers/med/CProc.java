package ckb.controllers.med;

import ckb.dao.admin.users.DUser;
import ckb.dao.med.dicts.rooms.DRooms;
import ckb.dao.med.patient.*;
import ckb.domains.admin.Users;
import ckb.domains.med.dicts.Rooms;
import ckb.domains.med.patient.PatientDrugDates;
import ckb.domains.med.patient.PatientDrugExps;
import ckb.domains.med.patient.PatientTabExps;
import ckb.domains.med.patient.Patients;
import ckb.models.Obj;
import ckb.models.ObjList;
import ckb.services.med.patient.SPatient;
import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.Util;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.*;

@Controller
@RequestMapping("/proc/")
public class CProc {

  @Autowired private DUser dUser;
  @Autowired private DRooms dRoom;
  @Autowired private DPatient dPatient;
  @Autowired private SPatient sPatient;
  @Autowired private DPatientDrug dPatientDrug;
  @Autowired private DPatientDrugDate dPatientDrugDate;
  @Autowired private DPatientDrugExp dPatientDrugExp;
  @Autowired private DPatientTabExp dPatientTabExp;

  @RequestMapping("palatas.s")
  protected String palatas(HttpServletRequest req, Model m) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/proc/palatas.s");
    Users user = dUser.get(session.getUserId());
    m.addAttribute("dep_name", user.getDept().getName());
    String time = Util.get(req, "time");
    String sTime = session.getFilters().get("NURSE_TIME");
    HashMap<String, String> filters = session.getFilters();
    time = time == null ? sTime != null ? sTime : "1" : time;
    filters.put("NURSE_TIME", time);
    session.setFilters(filters);
    List<Rooms> rs = dRoom.getList("From Rooms Where dept.id = " + user.getDept().getId());
    List<Obj> rooms = new ArrayList<>();
    String dbDate = Util.dateDB("19.09.2025");
    for(Rooms r: rs) {
      Obj room = new Obj();
      room.setId(r.getId());
      room.setName(r.getName());
      List<ObjList> list = new ArrayList<>();
      List<Patients> patients = dPatient.getList("From Patients Where state = 'LV' And room.id = " + r.getId());
      for(Patients pat: patients) {
        ObjList l = new ObjList();
        if(dPatientDrug.getCount("From PatientDrugDates Where checked=1 And date='" + dbDate + "' And patientDrug.patient.id = " + pat.getId() + " And " + (time.equals("1") ? "patientDrug.morningTime = 1" : time.equals("2") ? "patientDrug.noonTime = 1" : "patientDrug.eveningTime = 1")) > 0) {
          l.setC1(pat.getSex() == null ? "fa-asterisk" : pat.getSex().getId() == 12 ? "fa-male" : "fa-female");
          l.setC2(dPatientDrug.getCount("From PatientDrugDates Where checked=1 And date='" + dbDate + "' And patientDrug.patient.id = " + pat.getId() + " And " + (time.equals("1") ? "patientDrug.morningTime = 1 And morningTimeDone !=1 " : time.equals("2") ? "patientDrug.noonTime = 1 And noonTimeDone!=1" : "patientDrug.eveningTime = 1 And eveningTimeDone!=1")) > 0 ? "text-danger" : "text-success");
          list.add(l);
        }
      }
      room.setList(list);
      if(!room.getList().isEmpty())
        rooms.add(room);
    }
    m.addAttribute("rooms", rooms);
    m.addAttribute("time", time);
    return "proc/palatas";
  }

  @RequestMapping("palata.s")
  protected String palata(HttpServletRequest req, Model m) {
    Session session = SessionUtil.getUser(req);
    //
    String time = Util.get(req, "time");
    String sTime = session.getFilters().get("NURSE_TIME");
    HashMap<String, String> filters = session.getFilters();
    time = time == null ? sTime != null ? sTime : "1" : time;
    filters.put("NURSE_TIME", time);
    session.setFilters(filters);
    //
    Integer roomId = Util.getInt(req, "id");
    Date operDay = Util.getDate(req, "oper_day");
    if(operDay == null) operDay = new Date();
    session.setCurUrl("/proc/palata.s?id=" + roomId);
    Users user = dUser.get(session.getUserId());
    m.addAttribute("dep_name", user.getDept().getName());
    m.addAttribute("room", dRoom.get(roomId));
    List<Patients> patients = dPatient.getList("From Patients Where state = 'LV' And room.id = " + roomId);
    List<Patients> pats = new ArrayList<>();
    for(Patients pat: patients) {
      if(dPatientDrug.getCount("From PatientDrugDates Where checked=1 And date='" + Util.dateDB(new Date()) + "' And patientDrug.patient.id = " + pat.getId() + " And " + (time.equals("1") ? "patientDrug.morningTime = 1" : time.equals("2") ? "patientDrug.noonTime = 1" : "patientDrug.eveningTime = 1")) > 0) {
        pats.add(pat);
      }
    }
    m.addAttribute("first_one", pats.get(0).getId());
    m.addAttribute("patients", pats);
    m.addAttribute("oper_day", Util.dateToString(operDay));
    m.addAttribute("time", time);
    return "proc/palata";
  }

  @RequestMapping("patient/drugs.s")
  protected String patient_drugs(HttpServletRequest req, Model m) {
    Session session = SessionUtil.getUser(req);
    Integer patId = Util.getInt(req, "id");
    Date operDay = Util.getDate(req, "oper_day");
    //
    String time = Util.get(req, "time");
    String sTime = session.getFilters().get("NURSE_TIME");
    HashMap<String, String> filters = session.getFilters();
    time = time == null ? sTime != null ? sTime : "1" : time;
    filters.put("NURSE_TIME", time);
    session.setFilters(filters);
    //
    if(operDay == null) operDay = new Date();
    m.addAttribute("tabs", sPatient.getDrugsByTypeToDate(patId, operDay, 15, time));
    m.addAttribute("ines", sPatient.getDrugsByTypeToDate(patId, operDay, 16, time));
    Patients pat = dPatient.get(patId);
    m.addAttribute("pat", pat);
    m.addAttribute("oper_day", Util.dateToString(operDay));
    m.addAttribute("time", time);
    LinkedHashMap<String, Double> rasxod = new LinkedHashMap<>();
    List<PatientDrugExps> exps = dPatientDrugExp.getList("From PatientDrugExps Where patient.id = " + patId);
    for(PatientDrugExps exp: exps) {
      if(time.equals("1")) rasxod.put(exp.getCode(), exp.getMorningExp() == null ? 0D : exp.getMorningExp());
      if(time.equals("2")) rasxod.put(exp.getCode(), exp.getNoonExp() == null ? 0D : exp.getNoonExp());
      if(time.equals("3")) rasxod.put(exp.getCode(), exp.getEveningExp() == null ? 0D : exp.getEveningExp());
    }
    m.addAttribute("exps", rasxod);

    LinkedHashMap<Integer, Double> tab_rasxod = new LinkedHashMap<>();
    List<PatientTabExps> tab_exps = dPatientTabExp.getList("From PatientTabExps Where patient.id = " + patId);
    for(PatientTabExps exp: tab_exps) {
      if(time.equals("1")) tab_rasxod.put(exp.getDrug().getId(), exp.getMorningExp() == null ? 0D : exp.getMorningExp());
      if(time.equals("2")) tab_rasxod.put(exp.getDrug().getId(), exp.getNoonExp() == null ? 0D : exp.getNoonExp());
      if(time.equals("3")) tab_rasxod.put(exp.getDrug().getId(), exp.getEveningExp() == null ? 0D : exp.getEveningExp());
    }
    m.addAttribute("tab_exps", tab_rasxod);
    return "proc/drugs";
  }

  @RequestMapping(value = "patient/drug/done.s", method = RequestMethod.POST)
  @ResponseBody
  protected String setDrugState(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    Session session = SessionUtil.getUser(req);
    try {
      String time = Util.get(req, "time");
      PatientDrugDates drug = dPatientDrugDate.get(Util.getInt(req, "id"));
      if(time.equals("1")) {
        drug.setMorningTimeDone(true);
        drug.setMorningTimeDoneBy(session.getUserId());
        drug.setMorningTimeDoneOn(new Date());
      }
      if(time.equals("2")) {
        drug.setNoonTimeDone(true);
        drug.setNoonTimeDoneBy(session.getUserId());
        drug.setNoonTimeDoneOn(new Date());
      }
      if(time.equals("3")) {
        drug.setEveningTimeDone(true);
        drug.setEveningTimeDoneBy(session.getUserId());
        drug.setEveningTimeDoneOn(new Date());
      }
      dPatientDrugDate.save(drug);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "patient/drug/exp.s", method = RequestMethod.POST)
  @ResponseBody
  protected String setExp(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      Integer patient = Util.getInt(req, "patient");
      String time = Util.get(req, "time");
      String code = Util.get(req, "code");
      Date dt = Util.getDate(req, "oper_day");
      Double val = Util.getDouble(req, "val");
      if(code.contains("tab_")) {
        Integer did = Integer.valueOf(code.replace("tab_", ""));
        PatientTabExps obj = dPatientTabExp.obj("From PatientTabExps Where patient.id = " + patient + " And drug.id = " + did + " And operDay = '" + Util.dateDB(Util.dateToString(dt)) + "'");
        if(obj == null) {
          obj = new PatientTabExps();
          obj.setPatient(dPatient.get(patient));
          obj.setDrug(dPatientDrug.get(did));
          obj.setOperDay(dt);
        }
        if(time.equals("1")) obj.setMorningExp(val);
        if(time.equals("2")) obj.setNoonExp(val);
        if(time.equals("3")) obj.setEveningExp(val);
        //
        dPatientTabExp.save(obj);
      } else {
        PatientDrugExps obj = dPatientDrugExp.obj("From PatientDrugExps Where patient.id = " + patient + " And code='" + code + "' And operDay = '" + Util.dateDB(Util.dateToString(dt)) + "'");
        if(obj == null) {
          obj = new PatientDrugExps();
          obj.setPatient(dPatient.get(patient));
          obj.setCode(code);
          obj.setOperDay(dt);
        }
        if(time.equals("1")) obj.setMorningExp(val);
        if(time.equals("2")) obj.setNoonExp(val);
        if(time.equals("3")) obj.setEveningExp(val);
        //
        dPatientDrugExp.save(obj);
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }
}
