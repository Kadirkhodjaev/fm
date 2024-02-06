package ckb.controllers.admin;

import ckb.dao.admin.forms.DForm;
import ckb.dao.admin.users.DUser;
import ckb.dao.med.amb.DAmbGroup;
import ckb.dao.med.amb.DAmbService;
import ckb.dao.med.amb.DAmbServiceField;
import ckb.dao.med.amb.DAmbServiceUser;
import ckb.dao.med.amb.form.DAmbFormField;
import ckb.dao.med.amb.form.DAmbFormFieldNorma;
import ckb.dao.med.amb.form.DAmbFormFieldOption;
import ckb.domains.admin.Users;
import ckb.domains.med.amb.*;
import ckb.models.AmbService;
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
  @Autowired private DAmbFormField dAmbFormField;
  @Autowired private DAmbFormFieldNorma dAmbFormFieldNorma;
  @Autowired private DAmbFormFieldOption dAmbFormFieldOption;
  @Autowired private SMoAmb dSMoAmb;

  @RequestMapping("index.s")
  protected String index(HttpServletRequest req) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("core/ambv2/index.s");
    if(session.getCurSubUrl().isEmpty() || !session.getCurSubUrl().contains("core/ambv2")) session.setCurSubUrl("/core/ambv2/services.s");
    return "core/ambv2/index";
  }

  @RequestMapping("/services.s")
  protected String amb(HttpServletRequest request, Model model){
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
    model.addAttribute("forms", dForm.getList("From Forms Where amb = 'Y'"));
    if(Util.isNotNull(req, "id")) {
      AmbServices ser = dAmbService.get(Util.getInt(req, "id"));
      model.addAttribute("ser", ser);
      model.addAttribute("fields", dSMoAmb.serviceFields(ser.getId()));
      model.addAttribute("rows", dAmbServiceField.byService(Util.getInt(req, "id")));
      StringBuilder users = new StringBuilder();
      for(AmbServiceUsers rw: dAmbServiceUser.getList("From AmbServiceUsers Where service = " + Util.get(req, "id"))) {
        Users u = dUser.get(rw.getUser());
        users.append(u.getFio()).append("; ");
      }
      model.addAttribute("users", users.toString());
    }
    return "/core/ambv2/services/add";
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
      String[] fields = req.getParameterValues("field_id");
      String[] field_labels = req.getParameterValues("field_label");
      String[] field_types = req.getParameterValues("field_type_code");
      String[] field_norms = req.getParameterValues("norm_type");
      String[] field_ei = req.getParameterValues("field_ei");
      for(int i=0; i<fields.length; i++) {
        AmbFormFields field = dAmbFormField.get(Integer.valueOf(fields[i]));
        field.setEi(field_ei[i]);
        field.setNormaType(field_norms[i]);
        field.setTypeCode(field_types[i]);
        field.setFieldLabel(field_labels[i]);
        dAmbFormField.save(field);
        if(field.getNormaType().equals("all")) {
          AmbFormFieldNormas norma = Util.isNull(req, "field_norma_" + field.getId()) ? new AmbFormFieldNormas() : dAmbFormFieldNorma.get(Util.getInt(req, "field_norma_" + field.getId()));
          if(Util.isNull(req, "field_norma_" + field.getId())) {
            if(dAmbFormFieldNorma.getCount("From AmbFormFieldNormas Where field = " + field.getId() + " And sex = 'all'") > 0)
              norma = dAmbFormFieldNorma.getObj("From AmbFormFieldNormas Where field = " + field.getId() + " And sex = 'all'");
          }
          norma.setNormaFrom(Util.getDouble(req, "field_norma_from_" + field.getId(), 0D));
          norma.setNormaTo(Util.getDouble(req, "field_norma_to_" + field.getId(), 0D));
          norma.setService(field.getService());
          norma.setField(field.getId());
          norma.setSex("all");
          dAmbFormFieldNorma.save(norma);
        }
        if(field.getNormaType().equals("sex_norm")) {
          AmbFormFieldNormas maleNorm = Util.isNull(req, "field_male_norma_" + field.getId()) ? new AmbFormFieldNormas() : dAmbFormFieldNorma.get(Util.getInt(req, "field_male_norma_" + field.getId()));
          if(Util.isNull(req, "field_male_norma_" + field.getId())) {
            if(dAmbFormFieldNorma.getCount("From AmbFormFieldNormas Where field = " + field.getId() + " And sex = 'male'") > 0)
              maleNorm = dAmbFormFieldNorma.getObj("From AmbFormFieldNormas Where field = " + field.getId() + " And sex = 'male'");
          }
          maleNorm.setNormaFrom(Util.getDouble(req, "field_male_norma_from_" + field.getId(), 0D));
          maleNorm.setNormaTo(Util.getDouble(req, "field_male_norma_to_" + field.getId(), 0D));
          maleNorm.setService(field.getService());
          maleNorm.setField(field.getId());
          maleNorm.setSex("male");
          dAmbFormFieldNorma.save(maleNorm);
          AmbFormFieldNormas femaleNorm = Util.isNull(req, "field_female_norma_" + field.getId()) ? new AmbFormFieldNormas() : dAmbFormFieldNorma.get(Util.getInt(req, "field_female_norma_" + field.getId()));
          if(Util.isNull(req, "field_female_norma_" + field.getId())) {
            if(dAmbFormFieldNorma.getCount("From AmbFormFieldNormas Where field = " + field.getId() + " And sex = 'female'") > 0)
              femaleNorm = dAmbFormFieldNorma.getObj("From AmbFormFieldNormas Where field = " + field.getId() + " And sex = 'female'");
          }
          femaleNorm.setNormaFrom(Util.getDouble(req, "field_female_norma_from_" + field.getId(), 0D));
          femaleNorm.setNormaTo(Util.getDouble(req, "field_female_norma_to_" + field.getId(), 0D));
          femaleNorm.setService(field.getService());
          femaleNorm.setField(field.getId());
          femaleNorm.setSex("female");
          dAmbFormFieldNorma.save(femaleNorm);
        }
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/service/field/add.s", method = RequestMethod.POST)
  @ResponseBody
  protected String add_service_field(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      AmbServices service = dAmbService.get(Util.getInt(req, "service"));
      AmbFormFields field = new AmbFormFields();
      field.setService(service.getId());
      field.setFieldLabel(Util.get(req, "label"));
      Long count = dAmbFormField.getCount("From AmbFormFields Where service = " + service.getId());
      field.setOrd(Integer.valueOf("" + count));
      field.setFieldName("c" + (count + 1));
      field.setTypeCode("float_norm");
      field.setNormaType("all");
      dAmbFormField.save(field);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/service/field/del.s", method = RequestMethod.POST)
  @ResponseBody
  protected String add_service_del(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      int field = Util.getInt(req, "id");
      dAmbFormFieldOption.delSql("From AmbFormFieldOptions Where field = " + field);
      dAmbFormFieldNorma.delSql("From AmbFormFieldNormas Where field = " + field);
      dAmbFormField.delete(field);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/service/field/option/add.s", method = RequestMethod.POST)
  @ResponseBody
  protected String add_service_field_option(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      AmbServices service = dAmbService.get(Util.getInt(req, "service"));
      AmbFormFieldOptions opt = new AmbFormFieldOptions();
      opt.setService(service.getId());
      opt.setOptName(Util.get(req, "name"));
      opt.setField(Util.getInt(req, "field"));
      opt.setOrd(Integer.valueOf(("" + (dAmbFormFieldOption.getCount("From AmbFormFieldOptions Where field = " + opt.getField()) + 1))));
      dAmbFormFieldOption.save(opt);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/service/field/option/del.s", method = RequestMethod.POST)
  @ResponseBody
  protected String del_service_field_option(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      dAmbFormFieldOption.delete(Util.getInt(req, "id"));
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
