package ckb.controllers.mo;

import ckb.dao.admin.countery.DCountry;
import ckb.dao.admin.region.DRegion;
import ckb.dao.admin.users.DUser;
import ckb.dao.med.amb.DAmbFizioDate;
import ckb.dao.med.amb.DAmbFizioTemplate;
import ckb.dao.med.amb.DAmbPatient;
import ckb.dao.med.amb.DAmbPatientService;
import ckb.domains.admin.Clients;
import ckb.domains.admin.Users;
import ckb.domains.med.amb.AmbFizioDates;
import ckb.domains.med.amb.AmbFizioTemplates;
import ckb.domains.med.amb.AmbPatientServices;
import ckb.domains.med.amb.AmbPatients;
import ckb.grid.AmbGrid;
import ckb.models.AmbFizio;
import ckb.services.mo.amb.SAmbGrid;
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
import java.util.Calendar;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping(value = "/ambs/doctor/")
public class CAmbDoctor {

  @Autowired private SAmbGrid sAmbGrid;
  @Autowired private DUser dUser;
  @Autowired private DAmbPatient dAmbPatient;
  @Autowired private DAmbPatientService dAmbPatientService;
  @Autowired private DCountry dCountry;
  @Autowired private DRegion dRegion;
  @Autowired private DAmbFizioDate dAmbFizioDate;
  @Autowired private DAmbFizioTemplate dAmbFizioTemplate;

  @RequestMapping("patients.s")
  protected String patients(HttpServletRequest req, Model model) {
    try {
      Session session = SessionUtil.getUser(req);
      session.setCurUrl("/ambs/doctor/patients.s");
      Users u = dUser.get(session.getUserId());
      AmbGrid grid = SessionUtil.getAmbGrid(req, "AMB_PATIENTS");
      grid.setGrid(req);
      grid.setSql("From Amb_Patients t Where t.state in ('WORK', 'DONE') And (Exists (Select 1 From Amb_Patient_Services c Where t.id = c.patient And c.State Not In ('DEL', 'AUTO_DEL') And c.worker_id = " + session.getUserId() + ")" + (u.isAmbFizio() ? " Or t.fizio = 'Y'" : "") + ")");
      grid.setOrder("Order By t.Id Desc");
      grid.setRowCount(sAmbGrid.rowCount(grid));
      grid.initPages();
      grid.setStartPos((grid.getPage() - 1) * grid.getPageSize() + 1);
      model.addAttribute("grid", grid);
      model.addAttribute("patients", sAmbGrid.rows(grid, session));
      model.addAttribute("is_fizio", u.isAmbFizio());
      model.addAttribute("view_url", "/ambs/doctor/fizio.s?id=");
      SessionUtil.addSession(req, "AMB_PATIENTS", grid);
    } catch (Exception e) {
      e.printStackTrace();
    }
    return "/mo/amb/doctor/patients";
  }

  @RequestMapping("archive.s")
  protected String archive(HttpServletRequest req, Model model) {
    try {
      Session session = SessionUtil.getUser(req);
      session.setCurUrl("/ambs/doctor/archive.s");
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
    return "/mo/amb/doctor/patients";
  }

  @RequestMapping("fizio.s")
  protected String fizio(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    int id = Util.getInt(req, "id", 0);
    session.setCurPat(id);
    session.setCurUrl("/ambs/doctor/fizio.s?id=" + id);
    try {
      AmbPatients patient = dAmbPatient.get(id);
      Clients client = patient.getClient() == null ? new Clients() : patient.getClient();
      client.setCountry(patient.getCounteryId() == null ? null : dCountry.get(patient.getCounteryId()));
      client.setRegion(patient.getRegionId() == null ? null : dRegion.get(patient.getRegionId()));
      client.setBirthyear(patient.getBirthyear() != null ? patient.getBirthyear() : client.getBirthyear());
      patient.setClient(client);
      List<AmbFizio> fizios = new ArrayList<>();
      Date end = dAmbFizioDate.getPatientMaxDate(patient);
      List<AmbFizioDates> dates = new ArrayList<>();
      int i = 0;
      while(true) {
        AmbFizioDates date = new AmbFizioDates();
        Calendar cl = Calendar.getInstance();
        cl.setTime(patient.getRegDate());
        cl.add(Calendar.DATE, i++);
        date.setDate(cl.getTime());
        date.setState("N");
        dates.add(date);
        if(cl.getTime().equals(end)) break;
      }
      model.addAttribute(dates);
      List<AmbPatientServices> services = dAmbPatientService.getList("From AmbPatientServices Where service.group.isFizio = 1 And patient = " + id);
      for(AmbPatientServices ser: services) {
        AmbFizio f = new AmbFizio();
        f.setFizio(ser);
        f.setName(ser.getService().getName());
        f.setOblast(ser.getFizioBodyPart());
        f.setOblast(ser.getFizioComment());
        List<AmbFizioDates> ds = dAmbFizioDate.list("From AmbFizioDates Where fizio.id = " + ser.getId() + " Order By date");
        f.setDates(ds.isEmpty() ? dates : ds);
        fizios.add(f);
      }
      model.addAttribute("dates", dates);
      model.addAttribute("fizios", fizios);
      //
      model.addAttribute("patient", patient);
      model.addAttribute("isReg", session.isReg());
    } catch (Exception e) {
      e.printStackTrace();
    }
    return "/mo/amb/doctor/fizio";
  }

  @RequestMapping(value = "/fizio/search_templates.s", method = RequestMethod.POST)
  @ResponseBody
  protected String search_templates(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    JSONArray arr = new JSONArray();
    try {
      String code = Util.get(req, "code");
      String word = Util.get(req, "word");
      String kdo = Util.get(req, "kdo");
      List<AmbFizioTemplates> temps = dAmbFizioTemplate.list("From AmbFizioTemplates Where service = " + kdo + " And code = '" + code + "' And lower(template) like lower('%" + word + "%')");
      for(AmbFizioTemplates t: temps) {
        arr.put(t.getTemplate());
      }
      json.put("rows", arr);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/fizio/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String save_fizio(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    Session session = SessionUtil.getUser(req);
    try {
      System.out.println(session.getCurPat());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }
}
