package ckb.controllers.admin;

import ckb.dao.admin.forms.DForm;
import ckb.dao.admin.users.DUser;
import ckb.dao.med.amb.DAmbGroup;
import ckb.dao.med.amb.DAmbService;
import ckb.dao.med.amb.DAmbServiceField;
import ckb.dao.med.amb.DAmbServiceUser;
import ckb.dao.med.amb.form.DAmbForm;
import ckb.dao.med.amb.form.DAmbFormCol;
import ckb.domains.admin.Users;
import ckb.domains.med.amb.*;
import ckb.models.AmbService;
import ckb.models.amb.AmbFormFieldRow;
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
import java.util.HashMap;
import java.util.List;

@Controller
@RequestMapping("/core/ambv2/")
public class CCoreAmbv2 {

  @Autowired private DAmbServiceField dAmbServiceField;
  @Autowired private DAmbService dAmbService;
  @Autowired private DAmbServiceUser dAmbServiceUser;
  @Autowired private DUser dUser;
  @Autowired private DForm dForm;
  @Autowired private DAmbGroup dAmbGroup;
  @Autowired private SMoAmb dSMoAmb;
  @Autowired private DAmbForm dAmbForm;
  @Autowired private DAmbFormCol dAmbFormCol;

  @RequestMapping("index.s")
  protected String index(HttpServletRequest req) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("core/ambv2/index.s");
    if(session.getCurSubUrl().isEmpty() || !session.getCurSubUrl().contains("core/ambv2")) session.setCurSubUrl("/core/ambv2/services.s");
    return "core/ambv2/index";
  }

  @RequestMapping("/services.s")
  protected String amb(HttpServletRequest request, Model model) {
    Session session = SessionUtil.getUser(request);
    session.setCurSubUrl("/core/ambv2/services.s");
    //
    String page = Util.get(request, "page");
    if(page == null) page = session.getDateBegin().get("admin_amb_index");
    if(page == null) page = "0";
    //
    HashMap<String, String> dh = session.getDateBegin();
    dh.put("admin_amb_index", page);
    session.setDateBegin(dh);
    //
    List<AmbService> services = new ArrayList<>();
    List<AmbServices> list = dAmbService.getList("From AmbServices t " + (page.equals("0") ? "" : " Where  group.id = " + page) + " Order By t.state, t.group.id");
    for(AmbServices l:list) {
      AmbService s = new AmbService();
      s.setId(l.getId());
      s.setService(l);
      s.setNewForm(l.getNewForm());
      services.add(s);
    }
    model.addAttribute("services", services);
    model.addAttribute("groups", dAmbGroup.getAll());
    model.addAttribute("page", page);
    return "/core/ambv2/services/index";
  }

  @RequestMapping("/service/save.s")
  protected String addAmb(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurSubUrl("/core/ambv2/service/save.s?id=" + Util.nvl(req, "id"));
    model.addAttribute("groups", dAmbGroup.getAll());
    if(Util.isNotNull(req, "id")) {
      AmbForms form = dAmbForm.get(Util.getInt(req, "form", 0));
      AmbServices ser = dAmbService.get(Util.getInt(req, "id"));
      model.addAttribute("ser", ser);
      List<AmbForms> forms = dAmbForm.list("From AmbForms Where service = " + ser.getId() + " Order By id Desc");
      model.addAttribute("forms", forms);
      if(form == null && !forms.isEmpty())
        form = forms.get(0);
      else {
        if(form == null) {
          form = new AmbForms();
          form.setId(0);
        }
      }
      model.addAttribute("form", form);
      List<AmbFormFieldRow> fields = dSMoAmb.serviceFields(ser.getId(), form.getId());
      model.addAttribute("fields", fields);
      model.addAttribute("code_exist", getFieldExist(fields, "code"));
      model.addAttribute("norma_exist", getFieldExist(fields, "norma"));
      model.addAttribute("ei_exist", getFieldExist(fields, "ei"));
      model.addAttribute("text_exist", getFieldExist(fields, "type"));
      List<AmbFormCols> cols = dAmbFormCol.list("From AmbFormCols Where form = " + form.getId() + " Order By ord");
      if(cols.isEmpty()) {
        AmbFormCols c = new AmbFormCols();
        c.setName("Значение");
        cols = new ArrayList<>();
        cols.add(c);
      }
      model.addAttribute("cols", cols);
      StringBuilder users = new StringBuilder();
      for(AmbServiceUsers rw: dAmbServiceUser.getList("From AmbServiceUsers Where service = " + Util.get(req, "id"))) {
        Users u = dUser.get(rw.getUser());
        users.append(u.getFio()).append("; ");
      }
      model.addAttribute("users", users.toString());
    }
    return "/core/ambv2/services/add";
  }

  private boolean getFieldExist(List<AmbFormFieldRow> fields, String code) {
    boolean flag = false;
    for(AmbFormFieldRow f: fields) {
      if(code.equals("code") && !f.getCode().isEmpty()) flag = true;
      if(code.equals("ei") && !f.getEi().isEmpty()) flag = true;
      if(code.equals("norma") && !f.getNorma().isEmpty()) flag = true;
      if(code.equals("type") && f.getTypeCode().equals("text")) flag = true;
    }
    return flag;
  }

  @RequestMapping(value = "/service/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String addAmb(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      AmbServices ser = Util.isNull(req, "id") ? new AmbServices() : dAmbService.get(Util.getInt(req, "id"));
      ser.setName(Util.get(req, "name"));
      ser.setConsul(Util.isNull(req, "consul") ? "N" : "Y");
      ser.setDiagnoz(Util.isNull(req, "diagnoz") ? "N" : "Y");
      ser.setTreatment(Util.isNull(req, "treatment") ? "N" : "Y");
      ser.setPrice(Double.parseDouble(Util.get(req, "price")));
      ser.setOrd(0);
      ser.setFor_price(Double.parseDouble(Util.get(req, "for_price")));
      ser.setGroup(dAmbGroup.get(Util.getInt(req, "group")));
      ser.setState(Util.isNull(req, "state") ? "P": "A");
      ser.setNewForm(Util.isNull(req, "new_form") ? "N": "Y");
      AmbServices ds = dAmbService.saveAndReturn(ser);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("/groups.s")
  protected String amb_groups(HttpServletRequest request, Model model) {
    Session session = SessionUtil.getUser(request);
    session.setCurSubUrl("/core/ambv2/groups.s");
    model.addAttribute("groups", dAmbGroup.getAll());
    return "/core/ambv2/groups/index";
  }

  @RequestMapping("/group/save.s")
  protected String addGroup(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurSubUrl("/core/ambv2/group/save.s?id=" + Util.nvl(req, "id"));
    if(Util.isNotNull(req, "id"))
      model.addAttribute("ser", dAmbGroup.get(Util.getInt(req, "id")));
    return "/core/ambv2/groups/add";
  }

  @RequestMapping(value = "/group/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String saveGroup(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      AmbGroups ser = Util.isNull(req, "id") ? new AmbGroups() : dAmbGroup.get(Util.getInt(req, "id"));
      ser.setName(Util.get(req, "name"));
      ser.setGroup(Util.isNotNull(req, "group"));
      ser.setFizio(Util.isNotNull(req, "fizio"));
      ser.setActive(Util.isNotNull(req, "active"));
      ser.setPartnerProc(Util.getDouble(req, "partnerProc", 0D));
      dAmbGroup.save(ser);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

}
