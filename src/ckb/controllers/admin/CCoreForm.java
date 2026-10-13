package ckb.controllers.admin;

import ckb.dao.admin.forms.DForm;
import ckb.dao.admin.forms.fields.DFormField;
import ckb.dao.admin.forms.opts.DOpt;
import ckb.domains.admin.FormFields;
import ckb.domains.admin.Forms;
import ckb.domains.admin.SelOpts;
import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.BeanSession;
import ckb.utils.DB;
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
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/core/form")
public class CCoreForm {

  @Autowired private DOpt dOpt;
  @Autowired private DForm dForm;
  @Autowired private DFormField dFormField;
  @Autowired private BeanSession beanSession;

  @RequestMapping("/list.s")
  protected String formList(HttpServletRequest request, Model model) {
    Session session = SessionUtil.getUser(request);
    session.setCurUrl("/core/form/list.s");
    model.addAttribute("forms", dForm.getAll());
    model.addAttribute("debug", beanSession.getParam("IS_DEBUG").equals("Y"));
    // number of fields and where each form is used (outpatient services / lab KDO)
    model.addAttribute("fieldCounts", counts("Select Form_Id, Count(*) From Form_Fields Group By Form_Id"));
    model.addAttribute("ambUse", counts("Select form_id, Count(*) From Amb_Services Where form_id Is Not Null Group By form_id"));
    model.addAttribute("kdoUse", counts("Select formId, Count(*) From Kdos Where formId Is Not Null Group By formId"));
    return "/core/forms/index";
  }

  private Map<Integer, Long> counts(String sql) {
    Map<Integer, Long> map = new HashMap<>();
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      conn = DB.getConnection();
      ps = conn.prepareStatement(sql);
      rs = ps.executeQuery();
      while (rs.next()) map.put(rs.getInt(1), rs.getLong(2));
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn, ps, rs);
    }
    return map;
  }

  // create (no id) or edit a form
  @RequestMapping(value = "/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String saveForm(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      String name = Util.nvl(req.getParameter("name")).trim();
      if (name.isEmpty()) return Util.err(json, "EMPTY_NAME");
      Forms form = Util.isNull(req, "id") ? new Forms() : dForm.get(Util.getInt(req, "id"));
      form.setName(name);
      form.setAmb("Y".equals(Util.get(req, "amb")) ? "Y" : null);
      form.setType(Util.isNull(req, "type") ? 1 : Util.getInt(req, "type"));
      form.setJsp(Util.nvl(req.getParameter("jsp")).trim().isEmpty() ? null : req.getParameter("jsp").trim());
      form.setResult(Util.nvl(req.getParameter("result")).trim().isEmpty() ? null : req.getParameter("result").trim());
      form.setNormaFlag("Y".equals(Util.get(req, "norma_flag")) ? "Y" : "N");
      form.setEiFlag("Y".equals(Util.get(req, "ei_flag")) ? "Y" : "N");
      form.setCodeFlag("Y".equals(Util.get(req, "code_flag")) ? "Y" : "N");
      form.setShapka("Y".equals(Util.get(req, "shapka")));
      form.setShapka_left(Util.nvl(req.getParameter("shapka_left")));
      form.setShapka_right(Util.nvl(req.getParameter("shapka_right")));
      form = dForm.saveAndReturn(form);
      json.put("id", form.getId());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
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
      json.put("code_flag", d.getCodeFlag());
      json.put("amb", d.getAmb());
      json.put("type", d.getType());
      json.put("jsp", Util.nvl(d.getJsp()));
      json.put("result", Util.nvl(d.getResult()));
      json.put("shapka", d.isShapka());
      json.put("shapka_left", Util.nvl(d.getShapka_left()));
      json.put("shapka_right", Util.nvl(d.getShapka_right()));
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
      form.setCodeFlag(Util.get(req, "code_flag", "N"));
      dForm.save(form);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  // form-level "Code" column: Y - shown in the input and print forms
  @RequestMapping(value = "/codeFlag.s", method = RequestMethod.POST)
  @ResponseBody
  protected String codeFlag(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      Forms form = dForm.get(Util.getInt(req, "id"));
      form.setCodeFlag("Y".equals(Util.get(req, "code_flag")) ? "Y" : "N");
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
    model.addAttribute("fields", dFormField.getList("From FormFields t Where t.form.id = " + formId + " Order By t.ord, t.id"));
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
      f.setCodes(Req.get(req, "codes"));
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
