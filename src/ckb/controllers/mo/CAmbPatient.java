package ckb.controllers.mo;

import ckb.dao.admin.countery.DCountery;
import ckb.dao.admin.dicts.DLvPartner;
import ckb.dao.admin.region.DRegion;
import ckb.dao.admin.users.DUser;
import ckb.dao.med.amb.*;
import ckb.dao.med.client.DClient;
import ckb.domains.admin.Clients;
import ckb.domains.med.amb.AmbGroups;
import ckb.domains.med.amb.AmbPatientServices;
import ckb.domains.med.amb.AmbPatients;
import ckb.domains.med.amb.AmbServices;
import ckb.grid.AmbGrid;
import ckb.models.AmbGroup;
import ckb.models.AmbService;
import ckb.services.mo.SAmbGrid;
import ckb.session.Session;
import ckb.session.SessionUtil;
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
@RequestMapping(value = "/ambs/")
public class CAmbPatient {

  @Autowired private DLvPartner dLvPartner;
  @Autowired private DAmbPatients dAmbPatient;
  @Autowired private DAmbServices dAmbService;
  @Autowired private DClient dClient;
  @Autowired private SAmbGrid sAmbGrid;
  @Autowired private DCountery dCountry;
  @Autowired private DRegion dRegion;
  @Autowired private DAmbServiceUsers dAmbServiceUser;
  @Autowired private DAmbPatientServices dAmbPatientService;
  @Autowired private DUser dUser;
  @Autowired private DAmbGroups dAmbGroup;

  @RequestMapping("patients.s")
  protected String patients(HttpServletRequest req, Model model) {
    try {
      Session session = SessionUtil.getUser(req);
      session.setCurUrl("/ambs/patients.s");
      AmbGrid grid = SessionUtil.getAmbGrid(req, "AMB_PATIENTS");
      grid.setGrid(req);
      grid.setSql("From Amb_Patients t Where t.state != 'ARCH'");
      grid.setOrder("Order By t.Id Desc");
      grid.setRowCount(sAmbGrid.rowCount(grid));
      Long tail = grid.getRowCount() % grid.getPageSize();
      grid.setMaxPage(tail == 0 ? Math.round(grid.getRowCount() / grid.getPageSize()) : Math.round(grid.getRowCount() / grid.getPageSize()) + 1);
      grid.setStartPos((grid.getPage() - 1) * grid.getPageSize() + 1);
      model.addAttribute("grid", grid);
      model.addAttribute("patients", sAmbGrid.rows(grid, session));
      SessionUtil.addSession(req, "AMB_PATIENTS", grid);
    } catch (Exception e) {
      e.printStackTrace();
    }
    return "/mo/amb/patients/patients";
  }

  @RequestMapping("reg.s")
  protected String reg(HttpServletRequest req, Model model) {
    try {
      Session session = SessionUtil.getUser(req);
      int id = Util.getInt(req, "id", 0);
      boolean isDone = true;
      session.setCurPat(id);
      session.setCurUrl("/ambs/reg.s?id=" + id);
      AmbPatients patient = dAmbPatient.get(id);
      if(patient != null && patient.getClient() == null) {
        Clients client = new Clients();
        client.setCountry(dCountry.get(patient.getCounteryId()));
        client.setRegion(dRegion.get(patient.getRegionId()));
        client.setBirthyear(patient.getBirthyear());
        patient.setClient(client);
      }
      if(patient != null && patient.getClient() != null) {
        Clients client = patient.getClient();
        client.setBirthyear(client.getBirthyear() == null ? patient.getBirthyear() : client.getBirthyear());
        client.setCountry(dCountry.get(patient.getCounteryId()));
        client.setRegion(dRegion.get(patient.getRegionId()));
        patient.setClient(client);
      }
      if(session.getCurPat() > 0) {
        List<AmbService> ss = new ArrayList<AmbService>();
        List<AmbPatientServices> services = dAmbPatientService.getList("From AmbPatientServices Where patient = " + session.getCurPat());
        for(AmbPatientServices s: services) {
          AmbService d = new AmbService();
          d.setId(s.getId());
          d.setState(s.getState());
          d.setService(s.getService());
          d.setWorker(s.getWorker());
          d.setRepeat(false);
          d.setConfDate(s.getConfDate());
          if(session.isReg() && s.canRepeat()) {
            if((new Date().getTime() - patient.getRegDate().getTime()) / (1000*60*60*24) <= 5)
              d.setRepeat(true);
          }
          isDone = s.isClosed();
          if("ENT".equals(s.getState()) || ("PAID".equals(s.getState()) && session.isReg() && s.isNoResult()))
            d.setUsers(dUser.getList("From Users t Where Exists (Select 1 From AmbServiceUsers c Where t.id = c.user And c.service = " + s.getService().getId() + ")"));
          else
            d.setUsers(dUser.getList("From Users t Where id = " + s.getWorker().getId()));
          d.setPrice(Util.sumFormat(s.getPrice()));
          ss.add(d);
        }
        model.addAttribute("patient_services", ss);
        model.addAttribute("serviceTotal", dAmbPatientService.patientTotalSum(session.getCurPat()));
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
      model.addAttribute("patient", patient);
      model.addAttribute("lvpartners", dLvPartner.getList("From LvPartners " + (session.getCurPat() > 0 ? "" : " Where state = 'A' ") + " Order By code"));
    } catch (Exception e) {
      e.printStackTrace();
    }
    return "/mo/amb/patients/reg";
  }

  @RequestMapping(value = "reg.s", method = RequestMethod.POST)
  @ResponseBody
  protected String reg(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      Integer id = Util.getInt(req, "id", 0);
      AmbPatients pat = id == 0 ? new AmbPatients() : dAmbPatient.get(id);
      pat.setClient(dClient.get(Util.getInt(req, "client_id")));
      Clients c = pat.getClient();
      pat.setSurname(c.getSurname());
      pat.setName(c.getName());
      pat.setMiddlename(c.getMiddlename());
      pat.setBirthyear(c.getBirthyear());
      pat.setSex(c.getSex());
      pat.setTel(Util.get(req, "tel"));
      pat.setCounteryId(c.getCountry().getId());
      pat.setRegionId(c.getRegion().getId());
      pat.setPassportInfo(Util.get(req, "passport"));
      pat.setAddress(Util.get(req, "address"));
      pat.setLvpartner(dLvPartner.get(Util.getInt(req, "lvpartner", 0)));
      if(id == 0) {
        pat.setState("PRN");
        pat.setRegDate(new Date());
        pat.setCard(0D);
        pat.setCash(0D);
        pat.setCrOn(new Date());
        pat.setCrBy(SessionUtil.getUser(req).getUserId());
      }
      dAmbPatient.saveAndReturn(pat);
      json.put("id", pat.getId());
      json.put("success", true);
    } catch (Exception e) {
      e.printStackTrace();
      return Util.err(json, e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "del.s", method = RequestMethod.POST)
  @ResponseBody
  protected String del(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    Session session = SessionUtil.getUser(req);
    try {
      AmbPatients pat = dAmbPatient.get(session.getCurPat());
      if(!pat.getState().equals("PRN"))
        return Util.err(json, "Нельзя удалить запись! Удалить можно запись только в состоянии 'Введен'");
      if(dAmbPatientService.getCount("From AmbPatientServices Where patient = " + session.getCurPat()) > 0)
        return Util.err(json, "Нельзя удалить пациента с услугами! Удалить все услуги");
      dAmbPatient.delete(session.getCurPat());
      json.put("success", true);
    } catch (Exception e) {
      e.printStackTrace();
      return Util.err(json, e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "service-search.s", method = RequestMethod.POST)
  @ResponseBody
  protected String service_search(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    Session session = SessionUtil.getUser(req);
    try {
      String word = Util.nvl(req, "word");
      JSONArray arr = new JSONArray();
      AmbPatients pat = dAmbPatient.get(session.getCurPat());
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

  @RequestMapping(value = "patient/add-service.s", method = RequestMethod.POST)
  @ResponseBody
  protected String add_service(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    Session session = SessionUtil.getUser(req);
    try {
      int id = Util.getInt(req, "id");
      AmbPatients pat = dAmbPatient.get(session.getCurPat());
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
      /*if(dAmbPatientService.getCount("From AmbPatientServices t Where t.service.id = " + ser.getService().getId() + " And t.patient = " + ser.getPatient() + " And t.state = 'ENT' And t.worker.id = " + ser.getWorker().getId()) > 0) {
        return Util.err(json, "Данная услуга уже добавлена и в состоянии Введен!");
      }*/
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

  @RequestMapping(value = "patient/add-services.s", method = RequestMethod.POST)
  @ResponseBody
  protected String add_services(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    Session session = SessionUtil.getUser(req);
    try {
      String[] ids = req.getParameterValues("id");
      AmbPatients pat = dAmbPatient.get(session.getCurPat());
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

  @RequestMapping(value = "patient/del-service.s", method = RequestMethod.POST)
  @ResponseBody
  protected String del_service(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      int id = Util.getInt(req, "id");
      AmbPatientServices ser = dAmbPatientService.get(id);
      if("ENT".equals(ser.getState())) {
        dAmbPatientService.delete(ser.getId());
      }
      json.put("success", true);
    } catch (Exception e) {
      return Util.err(json, e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "patient/repeat-consul.s", method = RequestMethod.POST)
  @ResponseBody
  protected String repeat_consul(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      int id = Util.getInt(req, "id");
      AmbPatientServices ser = dAmbPatientService.get(id);
      json.put("success", true);
    } catch (Exception e) {
      return Util.err(json, e.getMessage());
    }
    return json.toString();
  }

}
