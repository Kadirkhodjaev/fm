package ckb.controllers.med;

import ckb.dao.admin.users.DUser;
import ckb.dao.med.dicts.rooms.DRooms;
import ckb.dao.med.patient.DPatient;
import ckb.domains.admin.Users;
import ckb.domains.med.dicts.Rooms;
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
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/proc/")
public class CProc {

  @Autowired private DUser dUser;
  @Autowired private DRooms dRoom;
  @Autowired private DPatient dPatient;
  @Autowired private SPatient sPatient;

  @RequestMapping("palatas.s")
  protected String palatas(HttpServletRequest req, Model m) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/proc/palatas.s");
    Users user = dUser.get(session.getUserId());
    m.addAttribute("dep_name", user.getDept().getName());
    List<Rooms> rs = dRoom.getList("From Rooms Where dept.id = " + user.getDept().getId());
    List<Obj> rooms = new ArrayList<>();
    for(Rooms r: rs) {
      Obj room = new Obj();
      room.setId(r.getId());
      room.setName(r.getName());
      List<ObjList> list = new ArrayList<>();
      List<Patients> patients = dPatient.getList("From Patients Where state = 'LV' And room.id = " + r.getId());
      for(Patients pat: patients) {
        ObjList l = new ObjList();
        l.setC1(pat.getSex().getId() == 12 ? "fa-male" : "fa-female");
        list.add(l);
      }
      room.setList(list);
      if(!room.getList().isEmpty())
        rooms.add(room);
    }
    m.addAttribute("rooms", rooms);
    return "proc/palatas";
  }

  @RequestMapping("palata.s")
  protected String palata(HttpServletRequest req, Model m) {
    Session session = SessionUtil.getUser(req);
    Integer roomId = Util.getInt(req, "id");
    Date operDay = Util.getDate(req, "oper_day");
    if(operDay == null) operDay = new Date();
    session.setCurUrl("/proc/palata.s?id=" + roomId);
    Users user = dUser.get(session.getUserId());
    m.addAttribute("dep_name", user.getDept().getName());
    m.addAttribute("room", dRoom.get(roomId));
    List<Patients> patients = dPatient.getList("From Patients Where state = 'LV' And room.id = " + roomId);
    m.addAttribute("first_one", patients.get(0).getId());
    m.addAttribute("patients", patients);
    m.addAttribute("oper_day", Util.dateToString(operDay));
    return "proc/palata";
  }

  @RequestMapping("patient/drugs.s")
  protected String patient_drugs(HttpServletRequest req, Model m) {
    Integer patId = Util.getInt(req, "id");
    Date operDay = Util.getDate(req, "oper_day");
    if(operDay == null) operDay = new Date();
    m.addAttribute("tabs", sPatient.getDrugsByTypeToDate(patId, operDay, 15));
    m.addAttribute("ines", sPatient.getDrugsByTypeToDate(patId, operDay, 16));
    Patients pat = dPatient.get(patId);
    m.addAttribute("pat", pat);
    m.addAttribute("oper_day", Util.dateToString(operDay));
    return "proc/drugs";
  }

  @RequestMapping(value = "get.s", method = RequestMethod.POST)
  @ResponseBody
  protected String getBooking(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    Session session = SessionUtil.getUser(req);
    try {

      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }
}
