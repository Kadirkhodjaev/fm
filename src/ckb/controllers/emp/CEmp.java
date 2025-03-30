package ckb.controllers.emp;

import ckb.dao.admin.country.DCountry;
import ckb.dao.admin.region.DRegion;
import ckb.dao.admin.users.DUser;
import ckb.dao.emp.DEmp;
import ckb.dao.emp.DEmpDoctor;
import ckb.dao.med.client.DClient;
import ckb.domains.emp.Emps;
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
    //
    model.addAttribute("emp", emp);
    sForm.setSelectOptionModel(model, 1, "sex");
    model.addAttribute("countries", dCountry.getCounteries());
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

}
