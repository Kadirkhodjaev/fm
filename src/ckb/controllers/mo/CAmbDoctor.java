package ckb.controllers.mo;

import ckb.dao.admin.country.DCountry;
import ckb.dao.admin.region.DRegion;
import ckb.dao.med.amb.*;
import ckb.domains.admin.Clients;
import ckb.domains.med.amb.*;
import ckb.models.AmbFizio;
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

  @Autowired private DAmbPatient dAmbPatient;
  @Autowired private DAmbPatientService dAmbPatientService;
  @Autowired private DCountry dCountry;
  @Autowired private DRegion dRegion;
  @Autowired private DAmbFizioDate dAmbFizioDate;
  @Autowired private DAmbFizioTemplate dAmbFizioTemplate;
  @Autowired private DAmbPatientTreatmentDate dAmbPatientTreatmentDate;

  @RequestMapping("patient.s")
  protected String patient(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    int id = Util.getInt(req, "id", 0);
    session.setCurPat(id);
    session.setCurUrl("/ambs/doctor/patient.s?id=" + id);
    try {
      AmbPatients patient = dAmbPatient.get(id);
      Clients client = patient.getClient() == null ? new Clients() : patient.getClient();
      client.setCountry(patient.getCounteryId() == null ? null : dCountry.get(patient.getCounteryId()));
      client.setRegion(patient.getRegionId() == null ? null : dRegion.get(patient.getRegionId()));
      client.setBirthyear(patient.getBirthyear() != null ? patient.getBirthyear() : client.getBirthyear());
      patient.setClient(client);
      model.addAttribute("patient", patient);
      model.addAttribute("isReg", session.isReg());
    } catch (Exception e) {
      e.printStackTrace();
    }
    return "/mo/amb/doctor/patient";
  }

  @RequestMapping("fizio.s")
  protected String fizio(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    int id = Util.getInt(req, "id", 0);
    session.setCurPat(id);
    try {
      AmbPatients patient = dAmbPatient.get(id);
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
        if(cl.getTime().equals(end) || cl.getTime().after(end)) break;
      }
      model.addAttribute(dates);
      List<AmbPatientServices> services = dAmbPatientService.getList("From AmbPatientServices Where service.group.isFizio = 1 And patient = " + id);
      for(AmbPatientServices ser: services) {
        AmbFizio f = new AmbFizio();
        f.setFizio(ser);
        f.setName(ser.getService().getName());
        f.setOblast(ser.getFizioBodyPart());
        f.setComment(ser.getFizioComment());
        List<AmbFizioDates> ds = dAmbFizioDate.list("From AmbFizioDates Where fizio.id = " + ser.getId() + " Order By date");
        f.setDates(ds.isEmpty() ? dates : ds);
        fizios.add(f);
      }
      model.addAttribute("dates", dates);
      model.addAttribute("fizios", fizios);
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
    try {
      String[] ids = req.getParameterValues("id");
      String[] bps = req.getParameterValues("oblast");
      String[] cms = req.getParameterValues("comment");
      for(int i=0;i<ids.length;i++) {
        AmbPatientServices ser = dAmbPatientService.get(Integer.parseInt(ids[i]));
        if(ser == null) continue;
        ser.setFizioBodyPart(bps[i]);
        ser.setFizioComment(cms[i]);
        dAmbPatientService.save(ser);
        String[] dates = req.getParameterValues("date_" + ser.getId());
        for(String date: dates) {
          AmbFizioDates dd = new AmbFizioDates();
          if(dAmbFizioDate.getCount("From AmbFizioDates Where fizio.id = " + ser.getId() + " And date = '" + Util.dateDB(date) + "'") > 0) {
            dd = dAmbFizioDate.getObj("From AmbFizioDates Where fizio.id = " + ser.getId() + " And date = '" + Util.dateDB(date) + "'");
          }
          dd.setState(Util.get(req, "fizio_" + ser.getId() + "_" + date) == null ? "N" : "Y");
          dd.setDate(Util.stringToDate(date));
          dd.setFizio(ser);
          dAmbFizioDate.save(dd);
        }
        if(dAmbFizioTemplate.getCount("From AmbFizioTemplates Where service.id = " + ser.getService().getId() + " And code = 'oblast' And template='" + bps[i] + "'") == 0) {
          AmbFizioTemplates ft = new AmbFizioTemplates();
          ft.setService(ser.getService());
          ft.setCode("oblast");
          ft.setTemplate(bps[i]);
          dAmbFizioTemplate.save(ft);
        }
        if(dAmbFizioTemplate.getCount("From AmbFizioTemplates Where service.id = " + ser.getService().getId() + " And code = 'comment' And template='" + bps[i] + "'") == 0) {
          AmbFizioTemplates ft = new AmbFizioTemplates();
          ft.setService(ser.getService());
          ft.setCode("comment");
          ft.setTemplate(cms[i]);
          dAmbFizioTemplate.save(ft);
        }
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/treatment/confirm.s", method = RequestMethod.POST)
  @ResponseBody
  protected String treatment_confirm(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      AmbPatientServices ser = dAmbPatientService.get(Util.getInt(req, "id"));
      ser.setConfDate(new Date());
      ser.setState("DONE");
      dAmbPatientService.save(ser);
      AmbPatientTreatmentDates td = dAmbPatientTreatmentDate.get(ser.getTreatmentId());
      td.setPatientServiceState("DONE");
      dAmbPatientTreatmentDate.save(td);
      if(dAmbPatientService.getCount("From AmbPatientServices Where state != 'DONE' And patient = " + td.getPatient()) == 0) {
        AmbPatients pat = dAmbPatient.get(td.getPatient());
        pat.setState("DONE");
        dAmbPatient.save(pat);
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("service.s")
  protected String work(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    int patient = Util.getInt(req, "patient", 0);
    int id = Util.getInt(req, "id", 0);
    session.setCurPat(patient);
    session.setCurUrl("/ambs/doctor/service.s?patient=" + patient + "&id=" + id);
    AmbPatients pat = dAmbPatient.get(patient);
    List<AmbPatientServices> services = dAmbPatientService.getList("From AmbPatientServices Where state In ('PAID', 'DONE') And patient = " + pat.getId() + " And worker.id = " + session.getUserId() + " Order By id desc");
    AmbPatientServices service = dAmbPatientService.get(id);
    model.addAttribute("service", service);
    model.addAttribute("services", services);
    model.addAttribute("patient", pat);
    return "/mo/amb/doctor/service";
  }

  @RequestMapping("form.s")
  protected String form(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    int patient = Util.getInt(req, "patient", 0);
    int id = Util.getInt(req, "id", 0);
    session.setCurPat(patient);
    session.setCurUrl("/ambs/doctor/service.s?patient=" + patient + "&id=" + id);
    AmbPatients pat = dAmbPatient.get(patient);
    AmbPatientServices service = dAmbPatientService.get(id);
    model.addAttribute("service", service);
    model.addAttribute("patient", pat);
    return "/mo/amb/doctor/service";
  }

}
