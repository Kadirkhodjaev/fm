package ckb.controllers.admin;

import ckb.dao.admin.forms.DForm;
import ckb.dao.admin.forms.fields.DFormField;
import ckb.dao.admin.forms.opts.DOpt;
import ckb.dao.admin.params.DParam;
import ckb.domains.admin.FormFields;
import ckb.domains.admin.Forms;
import ckb.domains.admin.SelOpts;
import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.Req;
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
import java.util.List;

@Controller
@RequestMapping("/core/form")
public class CCoreForm {

  @Autowired private DOpt dOpt;
  @Autowired private DForm dForm;
  @Autowired private DFormField dFormField;
  @Autowired private DParam dParam;

  @RequestMapping("/list.s")
  protected String formList(HttpServletRequest request, Model model) {
    Session session = SessionUtil.getUser(request);
    session.setCurUrl("/core/form/list.s");
    model.addAttribute("forms", dForm.getAll());
    model.addAttribute("debug", dParam.byCode("IS_DEBUG").equals("Y"));
    return "/core/forms/index";
  }

  @RequestMapping(value = "/get.s", method = RequestMethod.POST)
  @ResponseBody
  protected String getForm(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      Forms d = dForm.get(Util.getInt(req, "id"));
      json.put("id", d.getId());
      json.put("form_name", d.getName());
      json.put("ei_flag", d.getEiFlag());
      json.put("norma_flag", d.getNormaFlag());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/add.s", method = RequestMethod.POST)
  @ResponseBody
  protected String addForm(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      Forms form = new Forms();
      form.setAmb("Y");
      form.setName(Util.get(req, "name"));
      form.setType(1);
      form.setEiFlag(Util.get(req, "ei_flag", "N"));
      form.setNormaFlag(Util.get(req, "norma_flag", "N"));
      dForm.save(form);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("/fields.s")
  protected String formFields(HttpServletRequest request, Model model){
    int formId = Req.getInt(request, "formId");
    Session session = SessionUtil.getUser(request);
    session.setCurUrl("/core/form/fields.s?formId=" + formId);
    model.addAttribute("fields", dFormField.getFiledsByForm(formId));
    model.addAttribute("form", dForm.get(formId));
    return "/core/forms/fields";
  }

  @RequestMapping(value = "/fields/removeVal.s", method = RequestMethod.POST)
  @ResponseBody
  protected String removeSelVal(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      int fieldId = Req.getInt(req, "fieldId");
      int id = Req.getInt(req, "id");
      FormFields field = dFormField.get(fieldId);
      List<SelOpts> opts = field.getOpts();
      List<SelOpts> list = new ArrayList<>();
      for(SelOpts opt : opts)
        if(!opt.getId().equals(id))
          list.add(opt);
      field.setOpts(list);
      dFormField.save(field);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/fields/add.s", method = RequestMethod.POST)
  @ResponseBody
  protected String fieldAdd(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      Long count = dFormField.getCount("From FormFields Where form.id = " + Req.getInt(req, "formId"));
      FormFields f = new FormFields();
      f.setForm(dForm.get(Req.getInt(req, "formId")));
      f.setField(Req.get(req, "field"));
      f.setCssClass("form-control");
      f.setFieldType("text");
      f.setMaxLength(255);
      f.setResFlag("Y");
      f.setTextCols(60);
      f.setTextRows(4);
      f.setOrd(Integer.parseInt(String.valueOf(count + 1)));
      f.setFieldCode(dFormField.getNextFieldCode(Req.getInt(req, "formId")));
      dFormField.save(f);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/fields/upd.s", method = RequestMethod.POST)
  @ResponseBody
  protected String fieldUpd(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      FormFields f = dFormField.get(Req.getInt(req, "id"));
      f.setField(Req.get(req, "field"));
      f.setCssClass(Req.get(req, "cssClass"));
      f.setFieldCode(Req.get(req, "fieldCode"));
      f.setFieldType(Req.get(req, "fieldType"));
      f.setDefVal(Req.get(req, "defVal"));
      f.setCssStyle(Req.get(req, "cssStyle"));
      f.setEI(Req.get(req, "EI"));
      f.setNormaFrom(Req.get(req, "normaFrom"));
      f.setNormaTo(Req.get(req, "normaTo"));
      f.setMaxLength(Req.getInt(req, "maxLength"));
      f.setTextCols(Req.getInt(req, "textCols"));
      f.setTextRows(Req.getInt(req, "textRows"));
      f.setOrd(Util.isNull(req, "ord") ? null : Util.getInt(req, "ord"));
      f.setResFlag(Util.nvl(Req.get(req, "resFlag"), "N"));
      dFormField.save(f);
      List<SelOpts> opts = f.getOpts();
      SelOpts val = new SelOpts();
      val.setName(Req.get(req, "selVal"));
      if(!val.getName().equals("")) {
        val = dOpt.saveAndReturn(val);
        opts.add(val);
        f.setOpts(opts);
        dFormField.save(f);
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("/fields/vals.s")
  protected String vals(HttpServletRequest request, Model model){
    int fieldId = Req.getInt(request, "fieldId");
    model.addAttribute("fieldId", fieldId);
    model.addAttribute("opts", dOpt.getAll());
    return "/core/forms/vals";
  }

  @RequestMapping(value = "/fields/addVals.s", method = RequestMethod.POST)
  @ResponseBody
  protected String addVal(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      int fieldId = Req.getInt(req, "fieldId");
      FormFields field = dFormField.get(fieldId);
      List<SelOpts> opts = field.getOpts();
      String[] ids = req.getParameterValues("val");
      for(String id : ids)
        opts.add(dOpt.get(Integer.parseInt(id)));
      field.setOpts(opts);
      dFormField.save(field);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/fields/saveVal.s", method = RequestMethod.POST)
  @ResponseBody
  protected String saveVals(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      int fieldId = Req.getInt(req, "id");
      FormFields field = dFormField.get(fieldId);
      List<SelOpts> opts = field.getOpts();
      SelOpts val = new SelOpts();
      val.setName(Req.get(req, "val"));
      if(!val.getName().equals("")) {
        val = dOpt.saveAndReturn(val);
        opts.add(val);
        field.setOpts(opts);
        dFormField.save(field);
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/addField.s", method = RequestMethod.POST)
  @ResponseBody
  protected String addFields(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      int formId = Req.getInt(req, "formId");
      FormFields field = new FormFields();
      field.setField(Req.get(req, "field"));
      field.setForm(dForm.get(formId));
      dFormField.save(field);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/removeField.s", method = RequestMethod.POST)
  @ResponseBody
  protected String removeFields(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      int id = Req.getInt(req, "id");
      FormFields field = dFormField.get(id);
      field.setOpts(null);
      dFormField.save(field);
      dFormField.delete(id);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }
}
