package ckb.controllers.med;


import ckb.dao.admin.country.DCountry;
import ckb.dao.admin.dicts.DDict;
import ckb.dao.admin.dicts.DLvPartner;
import ckb.dao.admin.region.DRegion;
import ckb.dao.admin.users.DUser;
import ckb.dao.med.dicts.rooms.DRooms;
import ckb.dao.med.kdos.DKdos;
import ckb.dao.med.lv.docs.DLvDoc;
import ckb.dao.med.lv.plan.DLvPlan;
import ckb.dao.med.patient.DPatient;
import ckb.dao.med.patient.DPatientLink;
import ckb.dao.med.patient.DPatientPlan;
import ckb.dao.med.patient.DPatientWatchers;
import ckb.domains.admin.Kdos;
import ckb.domains.med.dicts.Rooms;
import ckb.domains.med.lv.LvPlans;
import ckb.domains.med.patient.PatientPlans;
import ckb.domains.med.patient.PatientWatchers;
import ckb.domains.med.patient.Patients;
import ckb.services.admin.form.SForm;
import ckb.services.med.patient.SPatient;
import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.BeanSession;
import ckb.utils.BeanUsers;
import ckb.utils.Req;
import ckb.utils.Util;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/reg/")
public class CReg {

  private Session session = null;
  @Autowired SForm sForm;
  @Autowired SPatient sPatient;
  @Autowired DPatient dPatient;
  @Autowired DPatientLink dPatientLink;
  @Autowired BeanUsers beanUsers;
  @Autowired BeanSession beanSession;
  @Autowired DKdos dKdos;
  @Autowired DLvPlan dLvPlan;
  @Autowired DPatientPlan dPatientPlan;
  @Autowired DPatientWatchers dPatientWatchers;
  @Autowired DDict dDict;
  @Autowired private DLvPartner dLvPartner;
  @Autowired private DLvDoc dLvDoc;
  @Autowired private DRooms dRooms;
  @Autowired private DCountry dCountry;
  @Autowired private DRegion dRegion;
  @Autowired private DUser dUser;

  @RequestMapping("nurse/index.s")
  protected String view(@ModelAttribute("patient") Patients p, HttpServletRequest req, Model m) {
    //if(!Util.getCurDate().substring(6, 10).equals("2018")) return "redirect:/out.s";
    session = SessionUtil.getUser(req);
    if (!Req.isNull(req, "id"))
      session.setCurPat(Req.getInt(req, "id"));
    session.setCurUrl("/reg/nurse/index.s" + (Req.isNull(req, "id") ? "" : "?id=" + Req.get(req, "id")));
    sForm.setSelectOptionModel(m, 1, "cat");
    sForm.setSelectOptionModel(m, 1, "pitanie");
    sForm.setSelectOptionModel(m, 1, "sex");
    sForm.setSelectOptionModel(m, 1, "redirect");
    sForm.setSelectOptionModel(m, 1, "vidPer");
    sForm.setSelectOptionModel(m, 1, "metka");
    sForm.setSelectOptionModel(m, 1, "lgotaType");
    sForm.setSelectOptionModel(m, 1, "bloodGroup");
    sForm.setSelectOptionModel(m, 1, "pay_type");
    if(session.getCurPat() > 0) {
      if(p.getLvpartner() != null) {
        m.addAttribute("lvpartners", dLvPartner.getList("From LvPartners Where id = " + p.getLvpartner().getId()));
      } else {
        m.addAttribute("lvpartners", beanSession.getLvPartners());
      }
    } else {
      m.addAttribute("lvpartners", beanSession.getLvPartners());
    }
    m.addAttribute("watcherPrice", session.getParam("WATCHER_PRICE"));
    m.addAttribute("watchers", dPatientWatchers.byPatient(p.getId()));
    m.addAttribute("curDate", Util.getCurDate());
    sPatient.createModel(req, p);
    m.addAttribute("watcherTypes", dDict.getByTypeList("WATCHER_TYPE"));
    m.addAttribute("deps", beanSession.getDepts());
    m.addAttribute("lvs", beanUsers.getLvs());
    //
    List<Rooms> list = dRooms.getActives();
    List<Rooms> rooms = new ArrayList<>();
    for(Rooms room: list) {
      Long count = dPatient.getCount("From Patients Where state Not In ('ARCH', 'ZGV') And room.id = " + room.getId());
      if(count < room.getKoykoLimit() || room.getAccess().equals("Y"))
        rooms.add(room);
    }
    m.addAttribute("rooms", rooms);
    //
    m.addAttribute("countries", beanSession.getCounteries());
    m.addAttribute("regions", beanSession.getRegions());
    m.addAttribute("countryName", p.getCounteryId() != null ? dCountry.get(p.getCounteryId()).getName() : "");
    m.addAttribute("regionName", p.getRegionId() != null ? dRegion.get(p.getRegionId()).getName() : "");
    m.addAttribute("reg", Util.nvl(Util.get(req, "reg")).equals("Y") ? session.getCurPat() : "");
    m.addAttribute("booking", Util.get(req, "booking", ""));
    List<Kdos> kdos = dKdos.getList("From Kdos Where necKdo = 'Y'");
    List<Kdos> kkk = new ArrayList<>();
    for(Kdos kdo: kdos) {
      kdo.setShortName("_" + kdo.getId() + "_");
      kkk.add(kdo);
    }
    m.addAttribute("kdos", kkk);
    String planIds = "";
    if (!Req.isNull(req, "id")) {
      List<PatientPlans> plans = dPatientPlan.getList("From PatientPlans Where patient_id = " + session.getCurPat());
      for(PatientPlans plan: plans) {
        planIds += "_" + dLvPlan.get(plan.getPlan_Id()).getKdo().getId() + "_";
      }
    }
    m.addAttribute("planIds", planIds);
    if (p.getId() == null)
      p.setTarDate(Util.getCurDate());
    Util.makeMsg(req, m);
    return "med/registration/nurse/fm/index";
  }

  @RequestMapping(value = "nurse/index.s", method = RequestMethod.POST)
  @ResponseBody
  protected String addEdit(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      Patients p = sPatient.save(req);
      dPatientLink.saveLink(Util.getNullInt(req, "reg"), p.getId());
      json.put("id", p.getId());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "lvpartner.s", method = RequestMethod.POST)
  @ResponseBody
  protected String lvpartner(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      Patients p = dPatient.get(Util.getInt(req, "id"));
      p.setLvpartner(dLvPartner.get(Util.getInt(req, "lvpartner")));
      dPatient.save(p);
      json.put("id", p.getId());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "nurse/kdo/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String nurseNecKdoSave(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      Patients pat = dPatient.get(session.getCurPat());
      String[] ids = req.getParameterValues("id");
      String planIds = "";
      List<PatientPlans> plans = dPatientPlan.getList("From PatientPlans Where patient_id = " + session.getCurPat());
      for(PatientPlans plan: plans) {
        planIds += "_" + dLvPlan.get(plan.getPlan_Id()).getKdo().getId() + "_";
      }
      for(String id: ids) {
        if(Util.get(req,"kdo" + id) == null) {
          List<PatientPlans> kdos = dPatientPlan.getList("From PatientPlans t Where Exists (Select 1 From LvPlans c where c.resultId = 0 And c.id = t.plan_Id And c.kdo.id = " + id + ") And t.patient_id = " + session.getCurPat());
          for(PatientPlans k: kdos) {
            dPatientPlan.delete(k.getId());
            dLvPlan.delete(k.getPlan_Id());
          }
        }
        if(Util.get(req, "kdo" + id, "N").equals("Y")) {
          if(!planIds.contains("_" + id + "_")) {
            LvPlans p = new LvPlans();
            Kdos kdo = dKdos.get(Integer.parseInt(id));
            p.setKdo(kdo);
            p.setKdoType(kdo.getKdoType());
            p.setDone("N");
            p.setPatientId(session.getCurPat());
            p.setResultId(0);
            p.setPrice(pat.getCounteryId() == 199 ? kdo.getPrice() : kdo.getFor_price());
            p.setCashState(p.getPrice() == null || p.getPrice() == 0 ? "FREE" : "ENT");
            if (p.getPrice() == null || p.getPrice() == 0) p.setPayDate(new Date());
            p.setUserId(session.getUserId());
            p.setCrOn(new Date());
            p.setActDate(Util.stringToDate(Util.getCurDate()));
            dLvPlan.save(p);

            PatientPlans pp = new PatientPlans();
            pp.setPlan_Id(p.getId());
            pp.setKdo_type_id(p.getKdoType().getId());
            pp.setActDate(p.getActDate());
            pp.setPatient_id(p.getPatientId());
            dPatientPlan.save(pp);
          }
        }
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "nurse/del.s", method = RequestMethod.POST)
  @ResponseBody
  protected String delPatient(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      session = SessionUtil.getUser(req);
      if(dPatient.get(session.getCurPat()).getState().equals("PRN")) {
        dPatientLink.deletePatient(session.getCurPat());
        dPatient.delete(session.getCurPat());
      } else {
        return Util.err(json, "Пациент не в состоянии Введен");
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("nurse/view.s")
  protected String nursePrint(HttpServletRequest request, Model model) {
    session = SessionUtil.getUser(request);
    Patients pat = dPatient.get(session.getCurPat());
    model.addAttribute("pat", pat);
    if(pat.getLv_id() != null)
      model.addAttribute("lv", dUser.get(pat.getLv_id()));
    model.addAttribute("lvs", beanUsers.getLvs());
    model.addAttribute("zavs", beanUsers.getZavLvs());
    model.addAttribute("country", pat.getCounteryId() != null ? dCountry.get(pat.getCounteryId()).getName() : "");
    model.addAttribute("region", pat.getRegionId() != null ? dRegion.get(pat.getRegionId()).getName() : "");
    model.addAttribute("lvpartners", dLvPartner.getList("From LvPartners Where state = 'A' Order By code"));
    sForm.setSelectOptionModel(model, 1, "sex");
    model.addAttribute("countries", beanSession.getCounteries());
    model.addAttribute("regions", beanSession.getRegions());
    return "med/registration/nurse/" + (session.isParamEqual("CLINIC_CODE", "fm") ? "fm/" : "") + "view";
  }

  @RequestMapping(value = "nurse/watcher.s", method = RequestMethod.POST)
  @ResponseBody
  protected String saveWatcher(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      Patients pat = dPatient.get(Util.getInt(req, "id"));
      if(pat.getRoom().getRoomType().getId() == 7) {
        json.put("success", false);
        json.put("msg", "Нельзя добавить дополнительное спальное место. Полулюкс является одноместной палатой");
        return json.toString();
      }
      //
      PatientWatchers watcher = new PatientWatchers();
      watcher.setDayCount(Util.getInt(req, "days"));
      watcher.setPatient_id(pat.getId());
      watcher.setType(dDict.get(Util.getInt(req, "type")));

      if(pat.getCounteryId() == 199) {
        if(watcher.getType().getId() == 8)
          watcher.setPrice(pat.getRoom().getBron_price());
        else
          watcher.setPrice(pat.getRoom().getExtra_price());
      } else {
        if(watcher.getType().getId() == 8)
          watcher.setPrice(pat.getRoom().getFor_bron_price());
        else
          watcher.setPrice(pat.getRoom().getFor_extra_price());
      }
      watcher.setTotal(watcher.getPrice()*watcher.getDayCount());
      watcher.setState("ENT");
      watcher.setCrBy(session.getUserId());
      watcher.setCrOn(new Date());
      dPatientWatchers.save(watcher);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "nurse/watcher/day.s", method = RequestMethod.POST)
  protected @ResponseBody String setWatcherDay(HttpServletRequest req) throws JSONException {
    JSONObject data = new JSONObject();
    try {
      PatientWatchers watcher = dPatientWatchers.get(Util.getInt(req, "id"));
      watcher.setDayCount(Util.getInt(req, "day"));
      dPatientWatchers.save(watcher);
      data.put("success", true);
    } catch (Exception e) {
      data.put("success", false);
      data.put("msg", e.getMessage());
    }
    return data.toString();
  }

  @RequestMapping("doctor/index.s")
  protected String regDoc(@ModelAttribute("patient") Patients patient, HttpServletRequest req, Model model) {
    session = SessionUtil.getUser(req);
    session.setCurPat(Req.getInt(req, "id"));
    Patients pat = dPatient.get(Req.getInt(req, "id"));
    session.setCurUrl("/reg/doctor/index.s?id=" + pat.getId());
    model.addAttribute("fio", pat.getSurname() + " " + pat.getName());
    model.addAttribute("lvs", beanUsers.getLvs());
    model.addAttribute("deps", beanSession.getDepts());
    sPatient.createDocModel(pat, patient);
    model.addAttribute("date_Begin", Util.dateToString(pat.getDateBegin()));
    model.addAttribute("Date_End", Util.dateToString(pat.getDateEnd()));
    model.addAttribute("diagnos_Date", Util.dateToString(pat.getDiagnosDate()));
    model.addAttribute("bioCount", dLvPlan.getCount("From LvPlans Where kdo.id = 153 And patientId = " + pat.getId()));
    Util.makeMsg(req, model);
    return "med/registration/doctor/fm/index";
  }

  @RequestMapping(value = "doctor/index.s", method = RequestMethod.POST)
  @ResponseBody
  protected String regDoc(HttpServletRequest req, HttpServletResponse res) throws JSONException {
    JSONObject data = new JSONObject();
    res.setContentType("text/plain;charset=UTF-8");
    try {
      String msg = "";
      msg += Req.isNull(req, "date_Begin") ? "Не заполнено поле - Дата поступление\n" : "";
      msg += Req.isNull(req, "yearNum") ? "Не заполнено поле - Номер история болезни\n" : "";
      Patients pat = dPatient.get(Util.getInt(req, "id"));
      if (msg.isEmpty() && pat.getYearNum() != null && pat.getYearNum() != Util.getInt(req, "yearNum"))
        if (dPatient.existIbNum(Util.getInt(req, "id"), Util.getInt(req, "yearNum")))
          msg += "Номер история болезни - такой номер уже существует\n";
      //
      if (msg.isEmpty()) {
        Patients p = sPatient.docSave(req);
        data.put("success", true);
        data.put("id", p.getId());
      } else {
        data.put("success", false);
        data.put("msg", msg);
      }
    } catch (Exception e) {
      data.put("success", false);
      data.put("msg", e.getMessage());
    }
    return data.toString();
  }

  @RequestMapping("doctor/view.s")
  protected String docPrint(HttpServletRequest req, Model model) {
    session = SessionUtil.getUser(req);
    Patients pat = dPatient.get(session.getCurPat());
    model.addAttribute("pat", pat);
    if(pat.getLv_id() != null)
      model.addAttribute("lv", dUser.get(pat.getLv_id()).getFio());
    model.addAttribute("page", Util.get(req, "page"));
    return "med/registration/doctor/" + (session.isParamEqual("CLINIC_CODE", "fm") ? "fm/" : "") + "view";
  }

  @RequestMapping(value = "stat/removeRow.s", method = RequestMethod.POST)
  protected @ResponseBody String removeRow(HttpServletRequest req, HttpServletResponse res) throws JSONException {
    JSONObject data = new JSONObject();
    res.setContentType("text/plain;charset=UTF-8");
    try {
      if(Util.isNotNull(req,"code") && Util.isNotNull(req,"id")) {
        if(Util.get(req, "code").equals("watcher")) {
          dPatientWatchers.delete(Util.getInt(req, "id"));
        }
      }
      data.put("success", true);
    } catch (Exception e) {
      data.put("success", false);
      data.put("msg", e.getMessage());
    }
    return data.toString();
  }

  @RequestMapping(value = "doctor/archive.s", method = RequestMethod.POST)
  protected @ResponseBody String doctor_archive(HttpServletRequest req) throws JSONException {
    JSONObject data = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      if(dLvDoc.hasOSM(session.getCurPat()))
        return Util.err(data, "Данный пациент уже в процессе обработке нельзя Архивировать");
      Patients pat = dPatient.get(session.getCurPat());
      pat.setState("ARCH");
      pat.setYearNum(0);
      pat.setDateEnd(new Date());
      dPatient.save(pat);
      data.put("success", true);
    } catch (Exception e) {
      data.put("success", false);
      data.put("msg", e.getMessage());
    }
    return data.toString();
  }

  @RequestMapping(value = "stat/cashPlanState.s", method = RequestMethod.POST)
  @ResponseBody
  protected String cashPlanState(HttpServletRequest req, HttpServletResponse res) throws JSONException {
    JSONObject data = new JSONObject();
    res.setContentType("text/plain;charset=UTF-8");
    try {
     LvPlans plan = dLvPlan.get(Util.getInt(req, "id"));
     if(Util.get(req, "code").equals("C")) {
       plan.setCashState("PAID");
       plan.setPayDate(new Date());
     } else {
       plan.setCashState("ENT");
       plan.setPayDate(null);
     }
     dLvPlan.save(plan);
     data.put("success", true);
    } catch (Exception e) {
      data.put("success", false);
      data.put("msg", e.getMessage());
    }
    return data.toString();
  }

  @RequestMapping(value = "doctor/getIbNum.s", method = RequestMethod.POST)
  protected @ResponseBody String getNum(HttpServletRequest req) {
    session = SessionUtil.getUser(req);
    Patients p = dPatient.get(session.getCurPat());
    return "{\"y\":" + (p.getYearNum() == null ? dPatient.getNextYearNum() : p.getYearNum()) + "}";
  }

  @RequestMapping(value = "lvConf.s", method = RequestMethod.POST)
  protected @ResponseBody String lvConf(HttpServletRequest req) throws JSONException {
    session = SessionUtil.getUser(req);
    Patients p = dPatient.get(session.getCurPat());
    JSONObject data = new JSONObject();
    try {
      if (Util.isNotNull(req, "lv")) {
        p.setLv_id(Util.getInt(req, "lv"));
        p.setLv_dept_id(dUser.get(p.getLv_id()).getDept().getId());
      }
      p.setZavlv(dUser.get(Util.getInt(req, "zavlv")));
      dPatient.save(p);
      data.put("success", true);
      return data.toString();
    } catch (Exception e) {
      data.put("msg", e.getMessage());
      data.put("success", false);
      return data.toString();
    }
  }

  @RequestMapping("print.s")
  protected String regPrint(HttpServletRequest request, Model model) {
    session = SessionUtil.getUser(request);
    model.addAttribute("p", dPatient.get(session.getCurPat()));
    return "med/registration/print";
  }

  @RequestMapping("ekg.s")
  protected String regEkg(HttpServletRequest req, Model model) {
     session = SessionUtil.getUser(req);
    if(session.getCurPat() != 0)
      model.addAttribute("patFio", dPatient.getFio(session.getCurPat()));
    Integer id = Util.getInt(req, "id");
    model.addAttribute("printPage", "");
    if(id > 0) {
      try {
        LvPlans plan = dLvPlan.getObj("Select t From LvPlans t Where t.id in (Select Min(c.id) From LvPlans c Where c.isDone = 'Y' And c.kdo.id = 50 And c.patientId = " + id + ") And t.kdo.id = 50 And t.patientId = " + id);
        model.addAttribute("printPage", "/kdo/obs.s?print=Y&id=" + plan.getId() + "&kdo=" + plan.getKdo().getId());
      } catch (Exception ignored) {}
    }
    return "med/registration/doctor/fm/ekg";
  }

}
