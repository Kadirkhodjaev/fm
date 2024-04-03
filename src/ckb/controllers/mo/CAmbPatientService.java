package ckb.controllers.mo;

import ckb.dao.admin.users.DUser;
import ckb.dao.med.amb.*;
import ckb.domains.med.amb.*;
import ckb.models.*;
import ckb.services.mo.amb.SMoAmb;
import ckb.session.Session;
import ckb.session.SessionUtil;
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
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping(value = "/ambs/patient/")
public class CAmbPatientService {

  @Autowired private DAmbPatient dAmbPatient;
  @Autowired private SMoAmb sMoAmb;
  @Autowired private DAmbService dAmbService;
  @Autowired private DAmbServiceUser dAmbServiceUser;
  @Autowired private DAmbPatientService dAmbPatientService;
  @Autowired private DUser dUser;
  @Autowired private DAmbGroup dAmbGroup;
  @Autowired private DAmbResult dAmbResult;
  @Autowired private DAmbPatientTreatment dAmbPatientTreatment;
  @Autowired private DAmbPatientTreatmentDate dAmbPatientTreatmentDate;

  //region Services
  @RequestMapping("services.s")
  protected String patient_services(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    int id = Util.getInt(req, "id");
    try {
      AmbPatients patient = dAmbPatient.get(id);
      double entSum = 0, total = 0;
      if(id > 0) {
        List<AmbService> ss = new ArrayList<AmbService>();
        List<AmbPatientServices> services = dAmbPatientService.getList("From AmbPatientServices Where patient = " + id + " Order By id desc");
        for(AmbPatientServices s: services) {
          if(!session.isReg() && session.getUserId() != s.getCrBy() && (s.getState().equals("ENT") || s.getState().equals("DEL"))) continue;
          AmbService d = new AmbService();
          d.setId(s.getId());
          d.setState(s.getState());
          d.setService(s.getService());
          d.setWorker(s.getWorker());
          d.setRepeat(false);
          d.setCanDelete(false);
          d.setPlanDate(s.getPlanDate());
          d.setToday(Util.dateToString(s.getPlanDate()).equals(Util.getCurDate()));
          d.setTreatment(s.getTreatmentId() != null && s.getTreatmentId() > 0);
          d.setResult(s.getResult() == null || s.getResult() == 0 ? null : dAmbResult.get(s.getResult()));
          d.setConfDate(s.getConfDate());
          if(session.isReg() && s.canRepeat()) {
            if((new Date().getTime() - patient.getRegDate().getTime()) / (1000*60*60*24) <= 5)
              d.setRepeat(true);
          }
          if("ENT".equals(s.getState()) && (session.isReg() || (!session.isReg() &&  s.getCrBy() == session.getUserId()))) {
            d.setCanDelete(true);
          }
          if("ENT".equals(s.getState()) || ("PAID".equals(s.getState()) && session.isReg() && s.isNoResult()))
            d.setUsers(dUser.getList("From Users t Where Exists (Select 1 From AmbServiceUsers c Where t.id = c.user And c.service = " + s.getService().getId() + ")"));
          else
            d.setUsers(dUser.getList("From Users t Where id = " + s.getWorker().getId()));
          d.setPrice(Util.sumFormat(s.getPrice()));
          ss.add(d);
          if("ENT".equals(s.getState()))
            entSum += s.getPrice();
          if("PAID".equals(s.getState()) || "DONE".equals(s.getState()))
            total += s.getPrice();
        }
        model.addAttribute("patient_services", ss);
        //
        List<AmbGroup> srs = new ArrayList<>();
        List<AmbGroups> groups = dAmbGroup.list("From AmbGroups t Where t.active = 1 And Exists (From AmbServices c Where ifnull(c.treatment, 'N') != 'Y' And c.state = 'A' And c.group.id = t.id)");
        //
        for(AmbGroups group: groups) {
          AmbGroup g = new AmbGroup();
          g.setGroup(group);
          g.setServices(dAmbService.list("From AmbServices Where ifnull(treatment, 'N') != 'Y' And newForm = 'Y' And state = 'A' And group.id = " + group.getId() + " Order By ord"));
          if(!g.getServices().isEmpty())
            srs.add(g);
        }
        model.addAttribute("services", srs);
      }
      patient.setPaySum(entSum);
      dAmbPatient.save(patient);
      model.addAttribute("paid_sum", total);
      model.addAttribute("ent_sum", entSum);
      model.addAttribute("patient", patient);
      model.addAttribute("isReg", session.isReg());
      model.addAttribute("is_grid", Util.isNull(req, "grid"));
    } catch (Exception e) {
      e.printStackTrace();
    }
    return "/mo/amb/patients/" + (Util.isNull(req, "grid") ? "patient_" : "") + "services";
  }

  @RequestMapping(value = "service-search.s", method = RequestMethod.POST)
  @ResponseBody
  protected String service_search(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      String word = Util.nvl(req, "word");
      int patient = Util.getInt(req, "patient");
      JSONArray arr = new JSONArray();
      AmbPatients pat = dAmbPatient.get(patient);
      List<AmbServices> services = dAmbService.list("From AmbServices Where newForm = 'Y' And state = 'A' And upper(name) like '%" + word + "%' Order By ord");
      for(AmbServices ser: services) {
        JSONObject obj = new JSONObject();
        obj.put("id", ser.getId());
        obj.put("name", ser.getName());
        obj.put("price", Util.sumFormat(ser.getStatusPrice(pat)));
        arr.put(obj);
      }
      json.put("services", arr);
      json.put("success", true);
    } catch (Exception e) {
      e.printStackTrace();
      return Util.err(json, e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "add-service.s", method = RequestMethod.POST)
  @ResponseBody
  protected String add_service(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    Session session = SessionUtil.getUser(req);
    try {
      int id = Util.getInt(req, "id");
      int patient = Util.getInt(req, "patient");
      sMoAmb.createPatientService(patient, id, session.getUserId());
      sMoAmb.updatePaySum(patient);
      json.put("success", true);
    } catch (Exception e) {
      return Util.err(json, e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "add-services.s", method = RequestMethod.POST)
  @ResponseBody
  protected String add_services(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    Session session = SessionUtil.getUser(req);
    try {
      String[] ids = req.getParameterValues("id");
      int patient = Util.getInt(req, "patient");
      for(String id: ids)
        sMoAmb.createPatientService(patient, Integer.parseInt(id), session.getUserId());
      sMoAmb.updatePaySum(patient);
      json.put("success", true);
    } catch (Exception e) {
      return Util.err(json, e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "del-service.s", method = RequestMethod.POST)
  @ResponseBody
  protected String del_service(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      int id = Util.getInt(req, "id");
      AmbPatientServices ser = dAmbPatientService.get(id);
      if("ENT".equals(ser.getState())) {
        if(ser.getTreatmentId() != null && ser.getTreatmentId() != 0) {
          AmbPatientTreatmentDates dt = dAmbPatientTreatmentDate.get(ser.getTreatmentId());
          if(dt != null) {
            dt.setPatientService(0);
            dt.setState("N");
            dAmbPatientTreatmentDate.save(dt);
          }
        }
        dAmbPatientService.delete(ser.getId());
        sMoAmb.updatePaySum(ser.getPatient());
      }
      json.put("success", true);
    } catch (Exception e) {
      return Util.err(json, e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "set-service-lv.s", method = RequestMethod.POST)
  @ResponseBody
  protected String set_service_lv(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      AmbPatientServices ser = dAmbPatientService.get(Util.getInt(req, "service"));
      ser.setWorker(dUser.get(Util.getInt(req, "lv")));
      dAmbPatientService.save(ser);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "repeat-service.s", method = RequestMethod.POST)
  @ResponseBody
  protected String reiterativeConsul(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    Session session = SessionUtil.getUser(req);
    try {
      AmbPatientServices ser = dAmbPatientService.get(Req.getInt(req, "id"));
      ser.setAmb_repeat("D"); // Повторная консультация
      dAmbPatientService.save(ser);
      //
      AmbPatients pat = dAmbPatient.get(ser.getPatient());
      pat.setId(null);
      pat.setCrBy(session.getUserId());
      pat.setCrOn(new Date());
      pat.setRegDate(new Date());
      pat.setState("CASH");
      pat.setFizio("N");
      dAmbPatient.saveAndReturn(pat);
      //
      ser.setId(null);
      ser.setState("ENT");
      ser.setPatient(pat.getId());
      ser.setAmb_repeat("Y");
      ser.setCrOn(new Date());
      ser.setPrice(ser.getPrice() / 2);
      ser.setResult(0);
      ser.setCashDate(null);
      ser.setConfDate(null);
      ser.setDiagnoz(null);
      ser.setMsg(null);
      ser.setCrBy(session.getUserId());
      dAmbPatientService.save(ser);
      sMoAmb.updatePaySum(pat.getId());
      //
      json.put("success", true);
    } catch (Exception e) {
      return Util.err(json, e.getMessage());
    }
    return json.toString();
  }
  //endregion

  //region Treatment
  @RequestMapping("treatments.s")
  protected String patient_treatments(HttpServletRequest req, Model model) {
    int id = Util.getInt(req, "id");
    try {
      AmbPatients patient = dAmbPatient.get(id);
      boolean notSaved = false;
      if(id > 0) {
        List<AmbTreatmentDate> dts = new ArrayList<>();
        Date end = dAmbPatientTreatmentDate.getPatientMaxDate(patient);
        int i = 0;
        while(true) {
          AmbTreatmentDate date = new AmbTreatmentDate();
          Calendar cl = Calendar.getInstance();
          cl.setTime(patient.getRegDate());
          cl.add(Calendar.DATE, i++);
          //
          date.setDate(cl.getTime());
          date.setPaid("N");
          date.setState("N");
          //
          dts.add(date);
          if(cl.getTime().equals(end) || cl.getTime().after(end)) break;
        }
        model.addAttribute("dates", dts);
        List<AmbTreatment> ss = new ArrayList<>();
        List<AmbPatientTreatments> services = dAmbPatientTreatment.getList("From AmbPatientTreatments Where patient = " + id + " Order By id");
        for(AmbPatientTreatments s: services) {
          AmbTreatment d = new AmbTreatment();
          d.setId(s.getId());
          d.setService(s.getService().getId());
          d.setName(s.getService().getName());
          d.setWorker(s.getWorkerId());
          d.setWorkerFio(dUser.get(s.getWorkerId()).getFio());
          d.setSaved(dAmbPatientTreatmentDate.getCount("From AmbPatientTreatmentDates Where patientService > 0 And treatment = " + s.getId()) > 0 ? "Y" : "N");
          d.setUsers(dUser.getList("From Users t Where Exists (Select 1 From AmbServiceUsers c Where t.id = c.user And c.service = " + s.getService().getId() + ")"));
          List<AmbPatientTreatmentDates> ds = dAmbPatientTreatmentDate.list("From AmbPatientTreatmentDates Where treatment = " + s.getId());
          List<AmbTreatmentDate> dates = new ArrayList<>();
          if(ds.isEmpty()) {
            dates = dts;
          } else {
            for(AmbPatientTreatmentDates dd: ds) {
              AmbTreatmentDate rw = new AmbTreatmentDate();
              rw.setDate(dd.getActDate());
              if(dd.getState().equals("Y") && dd.getPatientService() > 0) {
                rw.setPaid(dAmbPatientService.getCount("From AmbPatientServices Where state = 'ENT' And id = " + dd.getPatientService()) == 1 ? "N" : "Y");
              } else {
                rw.setPaid("N");
              }
              rw.setPsState(dd.getPatientServiceState());
              rw.setState(dd.getState());
              dates.add(rw);
            }
          }
          d.setDates(dates);
          ss.add(d);
        }
        model.addAttribute("patient_treatments", ss);
        //
        List<AmbGroup> srs = new ArrayList<>();
        List<AmbGroups> groups = dAmbGroup.list("From AmbGroups t Where t.active = 1 And Exists (From AmbServices c Where c.treatment = 'Y' And c.state = 'A' And c.group.id = t.id)");
        //
        for(AmbGroups group: groups) {
          AmbGroup g = new AmbGroup();
          g.setGroup(group);
          g.setServices(dAmbService.list("From AmbServices Where treatment = 'Y' And state = 'A' And group.id = " + group.getId() + " Order By ord"));
          srs.add(g);
        }
        model.addAttribute("treatments", srs);
      }
      model.addAttribute("notSaved", notSaved);
      model.addAttribute("patient", patient);
    } catch (Exception e) {
      e.printStackTrace();
    }
    return "/mo/amb/patients/patient_treatments";
  }

  @RequestMapping(value = "treatment-search.s", method = RequestMethod.POST)
  @ResponseBody
  protected String treatment_search(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      String word = Util.nvl(req, "word");
      int patient = Util.getInt(req, "patient");
      JSONArray arr = new JSONArray();
      AmbPatients pat = dAmbPatient.get(patient);
      List<AmbServices> services = dAmbService.list("From AmbServices Where treatment = 'Y' And state = 'A' And upper(name) like '%" + word + "%' Order By ord");
      for(AmbServices ser: services) {
        JSONObject obj = new JSONObject();
        obj.put("id", ser.getId());
        obj.put("name", ser.getName());
        obj.put("price", Util.sumFormat(ser.getStatusPrice(pat)));
        arr.put(obj);
      }
      json.put("treatments", arr);
      json.put("success", true);
    } catch (Exception e) {
      e.printStackTrace();
      return Util.err(json, e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "add-treatment.s", method = RequestMethod.POST)
  @ResponseBody
  protected String add_treatment(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    Session session = SessionUtil.getUser(req);
    try {
      int id = Util.getInt(req, "id");
      int patient = Util.getInt(req, "patient");
      if(dAmbPatientTreatment.getCount("From AmbPatientTreatments Where patient = " + patient + " And service = " + id) == 0) {
        AmbPatients pat = dAmbPatient.get(patient);
        AmbPatientTreatments ser = new AmbPatientTreatments();
        AmbServices s = dAmbService.get(id);
        ser.setService(s);
        ser.setCrBy(session.getUserId());
        ser.setCrOn(new Date());
        ser.setPatient(pat.getId());
        ser.setPatient(patient);
        ser.setWorkerId(dAmbServiceUser.getFirstUser(s.getId()).getId());
        dAmbPatientTreatment.save(ser);
        if ("DONE".equals(pat.getState())) {
          pat.setState("WORK");
          dAmbPatient.save(pat);
        }
      }
      json.put("success", true);
    } catch (Exception e) {
      return Util.err(json, e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "add-treatments.s", method = RequestMethod.POST)
  @ResponseBody
  protected String add_treatments(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    Session session = SessionUtil.getUser(req);
    try {
      String[] ids = req.getParameterValues("id");
      int patient = Util.getInt(req, "patient");
      AmbPatients pat = dAmbPatient.get(patient);
      for(String id: ids) {
        if(dAmbPatientTreatment.getCount("From AmbPatientTreatments Where patient = " + patient + " And service = " + id) == 0) {
          AmbPatientTreatments ser = new AmbPatientTreatments();
          AmbServices s = dAmbService.get(Integer.parseInt(id));
          ser.setCrBy(session.getUserId());
          ser.setCrOn(new Date());
          ser.setPatient(pat.getId());
          ser.setService(s);
          ser.setWorkerId(dAmbServiceUser.getFirstUser(s.getId()).getId());
          dAmbPatientTreatment.save(ser);
        }
      }
      if("DONE".equals(pat.getState())) {
        pat.setState("WORK");
        dAmbPatient.save(pat);
      }
      json.put("success", true);
    } catch (Exception e) {
      return Util.err(json, e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "del-treatment.s", method = RequestMethod.POST)
  @ResponseBody
  protected String del_treatment(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      int id = Util.getInt(req, "id");
      AmbPatientTreatments ser = dAmbPatientTreatment.get(id);
      if(dAmbPatientTreatmentDate.getCount("From AmbPatientTreatmentDates Where patientService > 0 And treatment = " + ser.getId()) > 0)
        return Util.err(json, "Нельзя удалить запись! Есть подтвержденные услуги");
      dAmbPatientTreatment.delete(ser.getId());
      json.put("success", true);
    } catch (Exception e) {
      return Util.err(json, e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "set-treatment-lv.s", method = RequestMethod.POST)
  @ResponseBody
  protected String set_treatment_lv(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      AmbPatientTreatments ser = dAmbPatientTreatment.get(Util.getInt(req, "treatment"));
      ser.setWorkerId(Util.getInt(req, "lv"));
      dAmbPatientTreatment.save(ser);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/save-treatment.s", method = RequestMethod.POST)
  @ResponseBody
  protected String save_fizio(HttpServletRequest req) throws JSONException {
    Session session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      String[] ids = req.getParameterValues("id");
      for(int i=0;i<ids.length;i++) {
        AmbPatientTreatments ser = dAmbPatientTreatment.get(Integer.parseInt(ids[i]));
        String[] dates = req.getParameterValues("date_" + ser.getId());
        for(String date: dates) {
          AmbPatientTreatmentDates dd = new AmbPatientTreatmentDates();
          if(dAmbPatientTreatmentDate.getCount("From AmbPatientTreatmentDates Where treatment = " + ser.getId() + " And actDate = '" + Util.dateDB(date) + "'") > 0) {
            dd = dAmbPatientTreatmentDate.getObj("From AmbPatientTreatmentDates Where treatment = " + ser.getId() + " And actDate = '" + Util.dateDB(date) + "'");
          }
          dd.setState(Util.get(req, "treatment_" + ser.getId() + "_" + date) == null ? "N" : "Y");
          dd.setActDate(Util.stringToDate(date));
          if(dd.getId() == null) {
            dd.setPaid("N");
            dd.setTreatment(ser.getId());
            dd.setPatient(ser.getPatient());
            dd.setPatientService(0);
            dd.setPatientServiceState("ENT");
          }
          if(dd.getPatientService() != 0) {
            if(dd.getState().equals("N")) {
              AmbPatientServices s = dAmbPatientService.get(dd.getPatientService());
              if(s.getState().equals("ENT")) {
                dAmbPatientService.delete(dd.getPatientService());
                dd.setPatientService(0);
              } else {
                dd.setState("Y");
              }
            }
          }
          dAmbPatientTreatmentDate.saveAndReturn(dd);
          // Создаем услуги по лечению
          if(dd.getState().equals("Y") && dd.getPatientService() == 0) {
            int psid = sMoAmb.createPatientServiceId(ser.getPatient(), ser.getService().getId(), session.getUserId(), dd.getId());
            dd.setPatientService(psid);
            dAmbPatientTreatmentDate.saveAndReturn(dd);

          }
        }
        dAmbPatientTreatment.save(ser);
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }
  //endregion
}
