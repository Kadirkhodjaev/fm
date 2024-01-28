package ckb.controllers.mo;

import ckb.dao.admin.users.DUser;
import ckb.dao.med.amb.*;
import ckb.domains.med.amb.AmbGroups;
import ckb.domains.med.amb.AmbPatientServices;
import ckb.domains.med.amb.AmbPatients;
import ckb.domains.med.amb.AmbServices;
import ckb.models.AmbGroup;
import ckb.models.AmbService;
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
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping(value = "/ambs/patient/")
public class CAmbPatientService {

  @Autowired private DAmbPatient dAmbPatient;
  @Autowired private DAmbService dAmbService;
  @Autowired private DAmbServiceUsers dAmbServiceUser;
  @Autowired private DAmbPatientService dAmbPatientService;
  @Autowired private DUser dUser;
  @Autowired private DAmbGroup dAmbGroup;
  @Autowired private DAmbResult dAmbResult;

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
          AmbService d = new AmbService();
          d.setId(s.getId());
          d.setState(s.getState());
          d.setService(s.getService());
          d.setWorker(s.getWorker());
          d.setRepeat(false);
          d.setCanDelete(false);
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
        model.addAttribute("service_total", dAmbPatientService.patientTotalSum(id));
        //
        List<AmbGroup> srs = new ArrayList<>();
        List<AmbGroups> groups = dAmbGroup.list("From AmbGroups t Where t.active = 1 And Exists (From AmbServices c Where c.state = 'A' And c.group.id = t.id)");
        //
        for(AmbGroups group: groups) {
          AmbGroup g = new AmbGroup();
          g.setGroup(group);
          g.setServices(dAmbService.list("From AmbServices Where state = 'A' And group.id = " + group.getId() + " Order By ord"));
          srs.add(g);
        }
        model.addAttribute("services", srs);
      }
      model.addAttribute("paid_sum", total);
      model.addAttribute("ent_sum", entSum);
      model.addAttribute("patient", patient);
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
      List<AmbServices> services = dAmbService.list("From AmbServices Where state = 'A' And upper(name) like '%" + word + "%' Order By ord");
      for(AmbServices ser: services) {
        JSONObject obj = new JSONObject();
        obj.put("id", ser.getId());
        obj.put("name", ser.getName());
        obj.put("price", Util.sumFormat(pat.isResident() ? ser.getPrice() : ser.getFor_price()));
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
      AmbPatients pat = dAmbPatient.get(patient);
      AmbPatientServices ser = new AmbPatientServices();
      AmbServices s = dAmbService.get(id);
      ser.setCrBy(session.getUserId());
      ser.setCrOn(new Date());
      ser.setPatient(pat.getId());
      ser.setService(s);
      ser.setPrice(pat.isResident() ? s.getPrice() : s.getFor_price());
      ser.setState("ENT");
      ser.setResult(0);
      ser.setAmb_repeat("N");
      ser.setWorker(dAmbServiceUser.getFirstUser(s.getId()));
      dAmbPatientService.save(ser);
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

  @RequestMapping(value = "add-services.s", method = RequestMethod.POST)
  @ResponseBody
  protected String add_services(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    Session session = SessionUtil.getUser(req);
    try {
      String[] ids = req.getParameterValues("id");
      int patient = Util.getInt(req, "patient");
      AmbPatients pat = dAmbPatient.get(patient);
      for(String id: ids) {
        AmbPatientServices ser = new AmbPatientServices();
        AmbServices s = dAmbService.get(Integer.parseInt(id));
        ser.setCrBy(session.getUserId());
        ser.setCrOn(new Date());
        ser.setPatient(pat.getId());
        ser.setService(s);
        ser.setPrice(pat.isResident() ? s.getPrice() : s.getFor_price());
        ser.setState("ENT");
        ser.setResult(0);
        ser.setAmb_repeat("N");
        ser.setWorker(dAmbServiceUser.getFirstUser(s.getId()));
        dAmbPatientService.save(ser);
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

  @RequestMapping(value = "del-service.s", method = RequestMethod.POST)
  @ResponseBody
  protected String del_service(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      int id = Util.getInt(req, "id");
      AmbPatientServices ser = dAmbPatientService.get(id);
      if("ENT".equals(ser.getState()))
        dAmbPatientService.delete(ser.getId());
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
      //
      json.put("success", true);
    } catch (Exception e) {
      return Util.err(json, e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("print.s")
  protected String print(HttpServletRequest req, Model m) {
    Session session = SessionUtil.getUser(req);
    AmbPatients pat = dAmbPatient.get(session.getCurPat());
    m.addAttribute("patient", pat);
    m.addAttribute("ids", req.getParameter("ids"));
    //
    return "med/amb/print";
  }

}
