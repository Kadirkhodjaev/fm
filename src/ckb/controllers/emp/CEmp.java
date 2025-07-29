package ckb.controllers.emp;

import ckb.dao.admin.country.DCountry;
import ckb.dao.admin.region.DRegion;
import ckb.dao.admin.users.DUser;
import ckb.dao.emp.DEmp;
import ckb.dao.emp.DEmpDoctor;
import ckb.dao.med.amb.DAmbPatient;
import ckb.dao.med.client.DClient;
import ckb.domains.admin.Clients;
import ckb.domains.emp.EmpDoctors;
import ckb.domains.emp.Emps;
import ckb.domains.med.amb.AmbPatients;
import ckb.services.admin.form.SForm;
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
import java.util.Date;

@Controller
@RequestMapping("/emp")
public class CEmp {

  @Autowired private DEmp dEmp;
  @Autowired private DEmpDoctor dEmpDoctor;
  @Autowired private DUser dUser;
  @Autowired private DClient dClient;
  @Autowired private DCountry dCountry;
  @Autowired private DRegion dRegion;
  @Autowired private SForm sForm;
  @Autowired private DAmbPatient dAmbPatient;

  @RequestMapping("/index.s")
  protected String changePass(HttpServletRequest req, Model model){
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("emp/index.s");
    model.addAttribute("rows", dEmp.list("From Emps Order By id desc"));
    return "/emp/index";
  }

  @RequestMapping("/addEdit.s")
  protected String addEdit(HttpServletRequest req, Model model){
    Session session = SessionUtil.getUser(req);
    int id = Util.getInt(req, "id");
    session.setCurUrl("emp/addEdit.s?id=" + id);
    Emps emp = id == 0 ? new Emps() : dEmp.get(id);
    if(id == 0) emp.setState("A");
    //
    model.addAttribute("emp", emp);
    sForm.setSelectOptionModel(model, 1, "sex");
    model.addAttribute("countries", dCountry.getCounteries());
    model.addAttribute("lvs", dUser.list("From Users Where active = 1 And glavbuh = 0 And glb = 0 And boss = 0 And mainNurse = 0 And statExp = 0 And procUser = 0 And needleDoc = 0 Order By fio"));
    model.addAttribute("emp_lvs", dEmpDoctor.list("From EmpDoctors Where emp.id = " + id));
    model.addAttribute("regions", dRegion.getList("From Regions Order By ord, name"));
    return "/emp/addEdit";
  }

  @RequestMapping(value = "/addEdit.s", method = RequestMethod.POST)
  @ResponseBody
  protected String addEdit_(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    Session session = SessionUtil.getUser(req);
    try {
      Integer id = Util.getNullInt(req, "id");
      Emps emp = id == null ? new Emps() : dEmp.get(id);
      emp.setClient(dClient.get(Util.getInt(req, "client_id")));
      if(id == null && dEmp.getCount("From Emps Where client.id = " + emp.getClient().getId()) > 0)
        return Util.err(json, "¬ыбранный клиент уже добавлен");
      emp.setText(Util.get(req, "text"));
      emp.setState(Util.isNull(req, "state") ? "P" : "A");
      if(id == null) {
        emp.setCrBy(session.getUserId());
        emp.setCrOn(new Date());
      }
      dEmp.saveAndReturn(emp);
      json.put("id", emp.getId());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/del.s", method = RequestMethod.POST)
  @ResponseBody
  protected String delEmp(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      dEmp.delete(Util.getNullInt(req, "id"));
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/doctor/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String addEditDoctor(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    Session session = SessionUtil.getUser(req);
    try {
      Integer id = Util.getNullInt(req, "id");
      EmpDoctors d = new EmpDoctors();
      d.setEmp(dEmp.get(id));
      d.setDoctor(dUser.get(Util.getInt(req, "doctor")));
      if(dEmpDoctor.getCount("From EmpDoctors Where emp.id = " + id + " And doctor.id = " + d.getDoctor().getId()) > 0)
        return Util.err(json, "¬ыбранный врач уже в списке");
      d.setCrBy(session.getUserId());
      d.setCrOn(new Date());
      dEmpDoctor.save(d);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/doctor/del.s", method = RequestMethod.POST)
  @ResponseBody
  protected String delDoctor(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      dEmpDoctor.delete(Util.getNullInt(req, "id"));
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("/doctor/emps.s")
  protected String doctorEmps(HttpServletRequest req, Model model){
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("emp/doctor/emps.s");
    model.addAttribute("rows", dEmp.list("From Emps t Where Exists (Select 1 From EmpDoctors c Where c.emp.id = t.id And c.doctor.id =" + session.getUserId() + ") Order By id desc"));
    return "/emp/doctor/index";
  }

  @RequestMapping("/doctor/emp.s")
  protected String doctorEmp(HttpServletRequest req, Model model){
    Session session = SessionUtil.getUser(req);
    int id = Util.getInt(req, "id");
    session.setCurUrl("emp/doctor/emp.s?id=" + id);
    Emps emp = id == 0 ? new Emps() : dEmp.get(id);
    model.addAttribute("emp", emp);
    model.addAttribute("rows", dAmbPatient.list("From AmbPatients Where emp = " + emp.getId() + " Order By id Desc"));
    return "/emp/doctor/emp";
  }

  @RequestMapping(value = "/doctor/emp/reg.s", method = RequestMethod.POST)
  @ResponseBody
  protected String regEmp(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    Session session = SessionUtil.getUser(req);
    try {
      Emps emp = dEmp.get(Util.getInt(req, "id"));
      if(dAmbPatient.getCount("From AmbPatients Where emp = " + emp.getId() + " And state != 'ARCH'") > 0) {
        return Util.err(json, "ѕо данному сотруднику уже существует не завершенна€ запись");
      }
      AmbPatients pat = new AmbPatients();
      pat.setClient(emp.getClient());
      Clients c = emp.getClient();
      pat.setSurname(c.getSurname());
      pat.setBirthday(c.getBirthdate());
      pat.setName(c.getName());
      pat.setMiddlename(c.getMiddlename());
      pat.setBirthyear(c.getBirthyear());
      pat.setCounteryId(c.getCountry().getId());
      pat.setRegionId(c.getRegion() == null ? null : c.getRegion().getId());
      pat.setPassportInfo(c.getDocSeria() + " " + c.getDocNum() + " " + c.getDocInfo());
      pat.setSex(c.getSex());
      pat.setAddress(c.getAddress());
      pat.setTel(c.getTel());
      pat.setState("PRN");
      pat.setRegDate(new Date());
      pat.setCard(0D);
      pat.setCash(0D);
      pat.setCrOn(new Date());
      pat.setCrBy(session.getUserId());
      pat.setEmp(emp.getId());
      dAmbPatient.saveAndReturn(pat);
      json.put("id", pat.getId());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

}
