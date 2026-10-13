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
import ckb.utils.DB;
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
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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

  /** Время приёма: 1 - утро, 2 - день, 3 - вечер (запоминается в сессии) */
  private String nurseTime(HttpServletRequest req, Session session) {
    String time = Util.get(req, "time");
    String sTime = session.getFilters().get("NURSE_TIME");
    HashMap<String, String> filters = session.getFilters();
    time = time == null ? sTime != null ? sTime : "1" : time;
    if (!time.equals("1") && !time.equals("2") && !time.equals("3")) time = "1";
    filters.put("NURSE_TIME", time);
    session.setFilters(filters);
    return time;
  }

  /**
   * Пациенты отделения на лечении с отметками по выбранному времени приёма на дату:
   * meds - есть назначения на это время, pending - есть ещё не отмеченные медсестрой.
   */
  private List<Map<String, Object>> nursePatients(int deptId, Integer roomId, String time, String dbDate) {
    String slot = time.equals("1") ? "morning" : time.equals("2") ? "noon" : "evening";
    List<Map<String, Object>> list = new ArrayList<>();
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      conn = DB.getConnection();
      ps = conn.prepareStatement(
        "Select p.id, p.surname, p.name, p.middlename, p.yearNum, p.birthyear, p.Sex_Id, p.Room_Id, r.name room_name, rt.name room_type, u.fio lv_fio, " +
        "       Exists(Select 1 From patient_drug_dates dd Join patient_drugs d On d.id = dd.patientDrug_Id " +
        "               Where d.patient_Id = p.id And dd.checked = 1 And dd.date = ? And d." + slot + "Time = 1) meds, " +
        "       (Select Count(*) From patient_drug_dates dd Join patient_drugs d On d.id = dd.patientDrug_Id " +
        "               Where d.patient_Id = p.id And dd.checked = 1 And dd.date = ? And d." + slot + "Time = 1 And IfNull(dd." + slot + "TimeDone, 0) != 1) pending " +
        "  From Patients p Join Rooms r On r.id = p.Room_Id Left Join Dicts rt On rt.id = r.roomType Left Join Users u On u.id = p.lv_id " +
        " Where p.state = 'LV' And r.dept_Id = ?" + (roomId != null ? " And r.id = ?" : "") +
        " Order By r.name, p.surname, p.name");
      ps.setString(1, dbDate);
      ps.setString(2, dbDate);
      ps.setInt(3, deptId);
      if (roomId != null) ps.setInt(4, roomId);
      rs = ps.executeQuery();
      while (rs.next()) {
        Map<String, Object> m = new HashMap<>();
        m.put("id", rs.getInt("id"));
        m.put("fio", (Util.nvl(rs.getString("surname")) + " " + Util.nvl(rs.getString("name")) + " " + Util.nvl(rs.getString("middlename"))).trim());
        m.put("yearNum", rs.getInt("yearNum") == 0 ? "" : rs.getInt("yearNum") + "");
        m.put("birthyear", rs.getInt("birthyear") == 0 ? "" : rs.getInt("birthyear") + "");
        m.put("sex", rs.getInt("Sex_Id") == 12 ? "M" : rs.getInt("Sex_Id") == 13 ? "F" : "");
        m.put("roomId", rs.getInt("Room_Id"));
        m.put("room", Util.nvl(rs.getString("room_name")));
        m.put("roomType", Util.nvl(rs.getString("room_type")));
        m.put("lv", Util.nvl(rs.getString("lv_fio")));
        m.put("meds", rs.getBoolean("meds"));
        m.put("pending", rs.getInt("pending"));
        list.add(m);
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn, ps, rs);
    }
    return list;
  }

  // Палаты отделения: плитки палат с пациентами и отметкой, у кого остались не сделанные процедуры
  @RequestMapping("palatas.s")
  protected String palatas(HttpServletRequest req, Model m) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/proc/palatas.s");
    Users user = dUser.get(session.getUserId());
    m.addAttribute("dep_name", user.getDept() == null ? "" : user.getDept().getName());
    String time = nurseTime(req, session);
    List<Map<String, Object>> rooms = new ArrayList<>();
    int pendingAll = 0, patientsAll = 0;
    if (user.getDept() != null) {
      Map<Integer, Map<String, Object>> byRoom = new LinkedHashMap<>();
      for (Map<String, Object> p : nursePatients(user.getDept().getId(), null, time, Util.dateDB(new Date()))) {
        Integer rid = (Integer) p.get("roomId");
        Map<String, Object> r = byRoom.get(rid);
        if (r == null) {
          r = new HashMap<>();
          r.put("id", rid);
          r.put("name", p.get("room"));
          r.put("type", p.get("roomType"));
          r.put("patients", new ArrayList<Map<String, Object>>());
          r.put("pending", 0);
          r.put("withMeds", 0);
          byRoom.put(rid, r);
        }
        ((List<Map<String, Object>>) r.get("patients")).add(p);
        int pend = (Integer) p.get("pending");
        if (pend > 0) r.put("pending", (Integer) r.get("pending") + 1);
        if ((Boolean) p.get("meds")) r.put("withMeds", (Integer) r.get("withMeds") + 1);
        patientsAll++;
        if (pend > 0) pendingAll++;
      }
      rooms.addAll(byRoom.values());
    }
    m.addAttribute("rooms", rooms);
    m.addAttribute("patientsAll", patientsAll);
    m.addAttribute("pendingAll", pendingAll);
    m.addAttribute("time", time);
    return "proc/palatas";
  }

  // Палата: выбор пациента (крупные карточки для планшета), под ним назначения на выбранное время
  @RequestMapping("palata.s")
  protected String palata(HttpServletRequest req, Model m) {
    Session session = SessionUtil.getUser(req);
    String time = nurseTime(req, session);
    Integer roomId = Util.getInt(req, "id");
    Date operDay = Util.getDate(req, "oper_day");
    if (operDay == null) operDay = new Date();
    session.setCurUrl("/proc/palata.s?id=" + roomId);
    Users user = dUser.get(session.getUserId());
    m.addAttribute("dep_name", user.getDept() == null ? "" : user.getDept().getName());
    m.addAttribute("room", dRoom.get(roomId));
    List<Map<String, Object>> pats = user.getDept() == null ? new ArrayList<Map<String, Object>>()
      : nursePatients(user.getDept().getId(), roomId, time, Util.dateDB(operDay));
    // открыт пациент из параметра, иначе первый, у кого есть не сделанные процедуры, иначе первый
    Integer sel = Util.isNotNull(req, "pat") ? Util.getInt(req, "pat") : null;
    if (sel == null) for (Map<String, Object> p : pats) if ((Integer) p.get("pending") > 0) { sel = (Integer) p.get("id"); break; }
    if (sel == null && !pats.isEmpty()) sel = (Integer) pats.get(0).get("id");
    m.addAttribute("first_one", sel);
    m.addAttribute("patients", pats);
    m.addAttribute("oper_day", Util.dateToString(operDay));
    m.addAttribute("time", time);
    m.addAttribute("tgEnabled", ckb.utils.tg.TgPatientBot.isEnabled());
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
    Session session =  SessionUtil.getUser(req);
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
