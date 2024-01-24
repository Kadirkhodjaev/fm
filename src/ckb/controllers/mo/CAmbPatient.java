package ckb.controllers.mo;

import ckb.dao.admin.countery.DCountry;
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
import ckb.services.admin.form.SForm;
import ckb.services.mo.amb.SAmbGrid;
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
@RequestMapping(value = "/ambs/")
public class CAmbPatient {

  @Autowired private DLvPartner dLvPartner;
  @Autowired private DAmbPatients dAmbPatient;
  @Autowired private DAmbServices dAmbService;
  @Autowired private DClient dClient;
  @Autowired private SAmbGrid sAmbGrid;
  @Autowired private DCountry dCountry;
  @Autowired private DRegion dRegion;
  @Autowired private DAmbServiceUsers dAmbServiceUser;
  @Autowired private DAmbPatientServices dAmbPatientService;
  @Autowired private DUser dUser;
  @Autowired private DAmbGroups dAmbGroup;
  @Autowired private DAmbResults dAmbResult;
  @Autowired private SForm sForm;

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
      grid.initPages();
      grid.setStartPos((grid.getPage() - 1) * grid.getPageSize() + 1);
      model.addAttribute("grid", grid);
      model.addAttribute("patients", sAmbGrid.rows(grid, session));
      model.addAttribute("view_url", "/ambs/reg.s?id=");
      SessionUtil.addSession(req, "AMB_PATIENTS", grid);
    } catch (Exception e) {
      e.printStackTrace();
    }
    return "/mo/amb/patients/patients";
  }

  @RequestMapping("archive.s")
  protected String archive(HttpServletRequest req, Model model) {
    try {
      Session session = SessionUtil.getUser(req);
      session.setCurUrl("/ambs/archive.s");
      AmbGrid grid = SessionUtil.getAmbGrid(req, "AMB_ARCHIVES");
      grid.setGrid(req);
      grid.setSql("From Amb_Patients t Where t.state = 'ARCH'");
      grid.setOrder("Order By t.Id Desc");
      grid.setRowCount(sAmbGrid.rowCount(grid));
      grid.initPages();
      grid.setStartPos((grid.getPage() - 1) * grid.getPageSize() + 1);
      model.addAttribute("grid", grid);
      model.addAttribute("patients", sAmbGrid.rows(grid, session));
      model.addAttribute("view_url", "/ambs/view.s?id=");
      SessionUtil.addSession(req, "AMB_ARCHIVES", grid);
    } catch (Exception e) {
      e.printStackTrace();
    }
    return "/mo/amb/patients/patients";
  }

  @RequestMapping("reg.s")
  protected String reg(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    int id = Util.getInt(req, "id", 0);
    session.setCurPat(id);
    session.setCurUrl("/ambs/reg.s?id=" + id);
    try {
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
      double entSum = 0, total = 0;
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
          d.setResult(s.getResult() == null || s.getResult() == 0 ? null : dAmbResult.get(s.getResult()));
          d.setConfDate(s.getConfDate());
          if(session.isReg() && s.canRepeat()) {
            if((new Date().getTime() - patient.getRegDate().getTime()) / (1000*60*60*24) <= 5)
              d.setRepeat(true);
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
        model.addAttribute("service_total", dAmbPatientService.patientTotalSum(session.getCurPat()));
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
      model.addAttribute("isReg", session.isReg());
      model.addAttribute("lvpartners", dLvPartner.getList("From LvPartners " + (session.getCurPat() > 0 ? "" : " Where state = 'A' ") + " Order By code"));
      // Клиент блок
      model.addAttribute("counteries", dCountry.getCounteries());
      model.addAttribute("regions", dRegion.getList("From Regions Order By ord, name"));
      sForm.setSelectOptionModel(model, 1, "sex");
    } catch (Exception e) {
      e.printStackTrace();
    }
    return "/mo/amb/patients/reg";
  }

  @RequestMapping("view.s")
  protected String view(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    int id = Util.getInt(req, "id", 0);
    session.setCurPat(id);
    session.setCurUrl("/ambs/view.s?id=" + id);
    try {
      AmbPatients patient = dAmbPatient.get(id);
      Clients client = patient.getClient() == null ? new Clients() : patient.getClient();
      client.setCountry(patient.getCounteryId() == null ? null : dCountry.get(patient.getCounteryId()));
      client.setRegion(patient.getRegionId() == null ? null : dRegion.get(patient.getRegionId()));
      client.setBirthyear(patient.getBirthyear() != null ? patient.getBirthyear() : client.getBirthyear());
      patient.setClient(client);
      List<AmbService> ss = new ArrayList<AmbService>();
      List<AmbPatientServices> services = dAmbPatientService.getList("From AmbPatientServices Where patient = " + session.getCurPat());
      double entSum = 0, total = 0;
      for(AmbPatientServices s: services) {
        AmbService d = new AmbService();
        d.setId(s.getId());
        d.setState(s.getState());
        d.setService(s.getService());
        d.setWorker(s.getWorker());
        d.setRepeat(false);
        d.setResult(s.getResult() == null || s.getResult() == 0 ? null : dAmbResult.get(s.getResult()));
        d.setConfDate(s.getConfDate());
        if(session.isReg() && s.canRepeat()) {
          if((new Date().getTime() - patient.getRegDate().getTime()) / (1000*60*60*24) <= 5)
            d.setRepeat(true);
        }
        if("ENT".equals(s.getState()) || ("PAID".equals(s.getState()) && session.isReg() && s.isNoResult()))
          d.setUsers(dUser.getList("From Users t Where Exists (Select 1 From AmbServiceUsers c Where t.id = c.user And c.service = " + s.getService().getId() + ")"));
        else
          d.setUsers(dUser.getList("From Users t Where id = " + s.getWorker().getId()));
        if("ENT".equals(s.getState()))
          entSum += s.getPrice();
        if("PAID".equals(s.getState()) || "DONE".equals(s.getState()))
          total += s.getPrice();
        d.setPrice(Util.sumFormat(s.getPrice()));
        ss.add(d);
      }
      model.addAttribute("patient_services", ss);
      model.addAttribute("paid_sum", total);
      model.addAttribute("ent_sum", entSum);
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
      model.addAttribute("patient", patient);
      model.addAttribute("isReg", session.isReg());
    } catch (Exception e) {
      e.printStackTrace();
    }
    return "/mo/amb/patients/view";
  }

  @RequestMapping(value = "reg.s", method = RequestMethod.POST)
  @ResponseBody
  protected String reg(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      Integer id = Util.getInt(req, "id", 0);
      AmbPatients pat = id == 0 ? new AmbPatients() : dAmbPatient.get(id);
      if(Util.isNull(req, "client_id")) return Util.err(json, "Клиент не выбран");
      pat.setClient(dClient.get(Util.getInt(req, "client_id")));
      Clients c = pat.getClient();
      if(c.getBirthdate() == null || c.getSex() == null || c.getCountry() == null || c.getSurname() == null || c.getName() == null) {
        String fields = (c.getBirthdate() == null ? "Дата рождения; " : "") +
                        (c.getSex() == null ? "Пол; " : "") +
                        (c.getCountry() == null ? "Резидентство; " : "") +
                        (c.getSurname() == null ? "Фамилия; " : "") +
                        (c.getSurname() == null ? "Имя; " : "");
        return Util.err(json, "Надо дополнить данные клиента по реквизитам: " + fields);
      }
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
      if("ENT".equals(ser.getState()))
        dAmbPatientService.delete(ser.getId());
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

  @RequestMapping(value = "/confirm.s", method = RequestMethod.POST)
  @ResponseBody
  protected String confirm_to_cash(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    Session session = SessionUtil.getUser(req);
    try {
      AmbPatients patient = dAmbPatient.get(session.getCurPat());
      if("PRN".equals(patient.getState())) patient.setState("CASH");
      if("DONE".equals(patient.getState())) patient.setState("ARCH");
      dAmbPatient.save(patient);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/set-service-lv.s", method = RequestMethod.POST)
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

  @RequestMapping(value = "/patient/repeat-service.s", method = RequestMethod.POST)
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

  @RequestMapping("/print.s")
  protected String print(HttpServletRequest req, Model m) {
    Session session = SessionUtil.getUser(req);
    AmbPatients pat = dAmbPatient.get(session.getCurPat());
    m.addAttribute("patient", pat);
    m.addAttribute("ids", req.getParameter("ids"));
    //
    return "med/amb/print";
  }

}
