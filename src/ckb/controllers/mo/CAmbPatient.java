package ckb.controllers.mo;

import ckb.dao.admin.country.DCountry;
import ckb.dao.admin.dicts.DLvPartner;
import ckb.dao.admin.region.DRegion;
import ckb.dao.admin.users.DUser;
import ckb.dao.med.amb.*;
import ckb.dao.med.client.DClient;
import ckb.domains.admin.Clients;
import ckb.domains.admin.Users;
import ckb.domains.med.amb.AmbPatientServices;
import ckb.domains.med.amb.AmbPatients;
import ckb.domains.med.amb.AmbServiceUsers;
import ckb.grid.AmbGrid;
import ckb.models.AmbService;
import ckb.services.admin.form.SForm;
import ckb.services.mo.amb.SMoAmb;
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
@RequestMapping(value = "/ambs/")
public class CAmbPatient {

  @Autowired private DLvPartner dLvPartner;
  @Autowired private DAmbPatient dAmbPatient;
  @Autowired private DClient dClient;
  @Autowired private SMoAmb sAmb;
  @Autowired private DCountry dCountry;
  @Autowired private DRegion dRegion;
  @Autowired private DAmbPatientService dAmbPatientService;
  @Autowired private DUser dUser;
  @Autowired private DAmbResult dAmbResult;
  @Autowired private SForm sForm;
  @Autowired private DAmbServiceUser dAmbServiceUser;

  @RequestMapping("patients.s")
  protected String patients(HttpServletRequest req, Model model) {
    try {
      Session session = SessionUtil.getUser(req);
      session.setCurUrl("/ambs/patients.s");
      AmbGrid grid = SessionUtil.getAmbGrid(req, "AMB_PATIENTS");
      grid.setGrid(req);
      Users u = dUser.get(session.getUserId());
      if(session.getRoleId() == 22)
        grid.setSql("From Amb_Patients t Where t.state != 'ARCH'");
      if(session.getRoleId() == 23) {
        String serviceWhere = "Exists (Select 1 From Amb_Patient_Services c Where t.id = c.patient And c.State Not In ('DEL', 'AUTO_DEL') And c.worker_id = " + session.getUserId() + ")";
        String fizioWhere = u.isAmbFizio() ? " Or t.fizio = 'Y'" : "";
        grid.setSql("From Amb_Patients t Where t.state in ('WORK', 'DONE') And (" + serviceWhere + fizioWhere + ")");
      }
      if(session.getRoleId() == 24) {
        grid.setSql("From Amb_Patients t Where t.state not in ('PRN', 'ARCH')");
      }
      grid.setOrder("Order By t.Id Desc");
      grid.setRowCount(sAmb.gridRowCount(grid));
      grid.initPages();
      grid.setStartPos((grid.getPage() - 1) * grid.getPageSize() + 1);
      model.addAttribute("grid", grid);
      model.addAttribute("patients", sAmb.gridRows(grid, session));
      // Регистрация
      if(session.getRoleId() == 22) model.addAttribute("view_url", "/ambs/reg.s?id=");
      // Амб услуги + Физиотерапия
      if(session.getRoleId() == 23 && u.isAmbFizio()) model.addAttribute("view_url", "/ambs/doctor/patient.s?id=");
      // Касса
      if(session.getRoleId() == 24) model.addAttribute("view_url", "/cash/amb/patient.s?id=");
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
      grid.setRowCount(sAmb.gridRowCount(grid));
      grid.initPages();
      grid.setStartPos((grid.getPage() - 1) * grid.getPageSize() + 1);
      model.addAttribute("grid", grid);
      model.addAttribute("patients", sAmb.gridRows(grid, session));
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
      if(session.getCurPat() > 0) model.addAttribute("patient_services", dAmbPatientService.getList("From AmbPatientServices Where patient = " + session.getCurPat()));
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
      List<AmbPatientServices> services = dAmbPatientService.getList("From AmbPatientServices Where patient = " + id);
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
        if("ENT".equals(s.getState()) || ("PAID".equals(s.getState()) && session.isReg() && s.isNoResult())) {
          List<Users> users = new ArrayList<>();
          List<AmbServiceUsers> serviceUsers = dAmbServiceUser.getList("From AmbServiceUsers t Where t.service = " + s.getService().getId());
          for(AmbServiceUsers serviceUser: serviceUsers) users.add(dUser.get(serviceUser.getUser()));
          d.setUsers(users);
        } else
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
      model.addAttribute("patient", patient);
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
      pat.setFizio(Util.nvl(req, "fizio", "N"));
      pat.setPassportInfo(Util.get(req, "passport"));
      pat.setAddress(Util.get(req, "address"));
      pat.setLvpartner(dLvPartner.get(Util.getInt(req, "lvpartner", 0)));
      if(id == 0) {
        pat.setState("PRN");
        pat.setRegDate(new Date());
        pat.setCard(0D);
        pat.setCash(0D);
        pat.setPaySum(0D);
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

  @RequestMapping(value = "/fizio.s", method = RequestMethod.POST)
  @ResponseBody
  protected String set_fizio(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    Session session = SessionUtil.getUser(req);
    try {
      AmbPatients patient = dAmbPatient.get(session.getCurPat());
      if(!patient.getFizio().equals("Y")) {
        patient.setFizio("Y");
        patient.setState("WORK");
        dAmbPatient.save(patient);
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/treatment.s", method = RequestMethod.POST)
  @ResponseBody
  protected String set_treatment(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    Session session = SessionUtil.getUser(req);
    try {
      AmbPatients patient = dAmbPatient.get(session.getCurPat());
      if(patient.getTreatment() == null || !"Y".equals(patient.getTreatment())) {
        patient.setTreatment("Y");
        dAmbPatient.save(patient);
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

}
