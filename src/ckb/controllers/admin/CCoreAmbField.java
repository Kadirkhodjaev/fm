package ckb.controllers.admin;

import ckb.dao.med.amb.DAmbService;
import ckb.dao.med.amb.form.*;
import ckb.domains.med.amb.*;
import ckb.models.amb.AmbFormField;
import ckb.services.mo.amb.SMoAmb;
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
import java.util.List;

@Controller
@RequestMapping("/core/ambv2/service/field/")
public class CCoreAmbField {

  @Autowired private DAmbForm dAmbForm;
  @Autowired private DAmbFormField dAmbFormField;
  @Autowired private DAmbFormFieldNorma dAmbFormFieldNorma;
  @Autowired private DAmbFormFieldOption dAmbFormFieldOption;
  @Autowired private SMoAmb dSMoAmb;
  @Autowired private DAmbService dAmbService;
  @Autowired private DAmbFormCol dAmbFormCol;

  @RequestMapping("save.s")
  protected String field_form(HttpServletRequest req, Model model) {
    AmbFormField field = dSMoAmb.getServiceField(Util.getInt(req, "id"));
    model.addAttribute("f", field);
    model.addAttribute("form", dAmbForm.get(field.getForm()));
    model.addAttribute("text_exist", dAmbFormField.getCount("From AmbFormFields Where form = " + field.getForm() + " And typeCode = 'text'") > 0);
    return "/core/ambv2/services/field";
  }

  @RequestMapping(value = "save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String save_service_field(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      String[] fields = req.getParameterValues("id");
      String[] codes = req.getParameterValues("code");
      String[] field_labels = req.getParameterValues("field_label");
      String[] field_types = req.getParameterValues("field_type_code");
      String[] field_norms = req.getParameterValues("norm_type");
      String[] field_ei = req.getParameterValues("field_ei");
      for (int i = 0; i < fields.length; i++) {
        AmbFormFields field = dAmbFormField.get(Integer.valueOf(fields[i]));
        field.setEi(field_ei[i]);
        field.setCode(codes[i]);
        field.setNormaType(field_norms[i]);
        field.setTypeCode(field_types[i]);
        field.setFieldLabel(field_labels[i]);
        dAmbFormField.save(field);
        if (field.getNormaType().equals("all")) {
          AmbFormFieldNormas norma = Util.isNull(req, "field_norma") ? new AmbFormFieldNormas() : dAmbFormFieldNorma.get(Util.getInt(req, "field_norma"));
          if (Util.isNull(req, "field_norma")) {
            if (dAmbFormFieldNorma.getCount("From AmbFormFieldNormas Where field = " + field.getId() + " And normType = 'all'") > 0)
              norma = dAmbFormFieldNorma.getObj("From AmbFormFieldNormas Where field = " + field.getId() + " And normType = 'all'");
          }
          norma.setNormaFrom(Util.getDouble(req, "field_norma_from", 0D));
          norma.setNormaTo(Util.getDouble(req, "field_norma_to", 0D));
          norma.setService(field.getService());
          norma.setField(field.getId());
          norma.setSex("");
          norma.setNormType("all");
          dAmbFormFieldNorma.save(norma);
        }
        if (field.getNormaType().equals("sex_norm")) {
          AmbFormFieldNormas maleNorm = Util.isNull(req, "field_male_norma") ? new AmbFormFieldNormas() : dAmbFormFieldNorma.get(Util.getInt(req, "field_male_norma"));
          if (Util.isNull(req, "field_male_norma")) {
            if (dAmbFormFieldNorma.getCount("From AmbFormFieldNormas Where field = " + field.getId() + " And sex = 'male'") > 0)
              maleNorm = dAmbFormFieldNorma.getObj("From AmbFormFieldNormas Where field = " + field.getId() + " And sex = 'male'");
          }
          maleNorm.setNormaFrom(Util.getDouble(req, "field_male_norma_from", 0D));
          maleNorm.setNormaTo(Util.getDouble(req, "field_male_norma_to", 0D));
          maleNorm.setService(field.getService());
          maleNorm.setField(field.getId());
          maleNorm.setSex("male");
          maleNorm.setNormType("sex_norm");
          dAmbFormFieldNorma.save(maleNorm);
          AmbFormFieldNormas femaleNorm = Util.isNull(req, "field_female_norma") ? new AmbFormFieldNormas() : dAmbFormFieldNorma.get(Util.getInt(req, "field_female_norma"));
          if (Util.isNull(req, "field_female_norma")) {
            if (dAmbFormFieldNorma.getCount("From AmbFormFieldNormas Where field = " + field.getId() + " And sex = 'female'") > 0)
              femaleNorm = dAmbFormFieldNorma.getObj("From AmbFormFieldNormas Where field = " + field.getId() + " And sex = 'female'");
          }
          femaleNorm.setNormaFrom(Util.getDouble(req, "field_female_norma_from", 0D));
          femaleNorm.setNormaTo(Util.getDouble(req, "field_female_norma_to", 0D));
          femaleNorm.setService(field.getService());
          femaleNorm.setField(field.getId());
          femaleNorm.setSex("female");
          femaleNorm.setNormType("sex_norm");
          dAmbFormFieldNorma.save(femaleNorm);
        }
        if (field.getNormaType().equals("cat_norm")) {
          String[] normaIds = req.getParameterValues(field.getNormaType() + "_id");
          if(normaIds != null)
            for(String normId: normaIds) {
              AmbFormFieldNormas norm = dAmbFormFieldNorma.get(Integer.parseInt(normId));
              norm.setCatName(Util.get(req, field.getNormaType() + "_name_" + normId, ""));
              norm.setNormaFrom(Util.getDouble(req, field.getNormaType() + "_norm_from_" + normId, 0D));
              norm.setNormaTo(Util.getDouble(req, field.getNormaType() + "_norm_to_" + normId, 0D));
              //if(dAmbFormFieldNorma.getCount("From AmbFormFieldNormas Where field = " + norm.getField() + " And id != " + normId + " And ()") > 0)
              dAmbFormFieldNorma.save(norm);
            }
        }
        if (field.getNormaType().equals("cat_sex_norm")) {
          String[] normaIds = req.getParameterValues(field.getNormaType() + "_id");
          if(normaIds != null)
            for(String normId: normaIds) {
              AmbFormFieldNormas norm = dAmbFormFieldNorma.get(Integer.parseInt(normId));
              norm.setCatName(Util.get(req, field.getNormaType() + "_name_" + normId, ""));
              norm.setNormaFrom(Util.getDouble(req, field.getNormaType() + "_norm_from_" + normId, 0D));
              norm.setNormaTo(Util.getDouble(req, field.getNormaType() + "_norm_to_" + normId, 0D));
              //if(dAmbFormFieldNorma.getCount("From AmbFormFieldNormas Where field = " + norm.getField() + " And id != " + normId + " And ()") > 0)
              dAmbFormFieldNorma.save(norm);
            }
        }
        if (field.getNormaType().equals("year_norm") || field.getNormaType().equals("sex_year_norm")) {
          String[] normaIds = req.getParameterValues(field.getNormaType() + "_id");
          if(normaIds != null)
            for(String normId: normaIds) {
              AmbFormFieldNormas norm = dAmbFormFieldNorma.get(Integer.parseInt(normId));
              if(field.getNormaType().equals("sex_year_norm")) norm.setSex(Util.get(req, field.getNormaType() + "_sex_" + normId, "male"));
              norm.setYearFrom(Util.getInt(req, field.getNormaType() + "_year_from_" + normId, 0));
              norm.setYearTo(Util.getInt(req, field.getNormaType() + "_year_to_" + normId, 0));
              norm.setNormaFrom(Util.getDouble(req, field.getNormaType() + "_norm_from_" + normId, 0D));
              norm.setNormaTo(Util.getDouble(req, field.getNormaType() + "_norm_to_" + normId, 0D));
              //if(dAmbFormFieldNorma.getCount("From AmbFormFieldNormas Where field = " + norm.getField() + " And id != " + normId + " And ()") > 0)
              dAmbFormFieldNorma.save(norm);
            }
        }
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "add.s", method = RequestMethod.POST)
  @ResponseBody
  protected String add_service_field(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      AmbServices service = dAmbService.get(Util.getInt(req, "service"));
      Integer formId = Util.getInt(req, "form");
      AmbForms form = formId > 0 ? dAmbForm.get(formId) : new AmbForms();
      if(formId == 0) {
        form.setActDate(new Date());
        form.setState("N");
        form.setService(service.getId());
        dAmbForm.saveAndReturn(form);
      }
      List<AmbFormCols> cols = dAmbFormCol.list("From AmbFormCols Where form = " + form.getId());
      if(cols.isEmpty()) {
        AmbFormFields field = new AmbFormFields();
        field.setService(service.getId());
        field.setFieldLabel(Util.get(req, "label"));
        Long count = dAmbFormField.getCount("From AmbFormFields Where form = " + form.getId());
        field.setOrd(Integer.valueOf("" + count));
        field.setFieldName("c" + (count + 1));
        field.setTypeCode("float_nonorm");
        field.setNormaType("all");
        field.setCol(1);
        field.setRow(dAmbFormField.getMaxRow(service.getId(), form.getId()) + 1);
        field.setForm(form.getId());
        dAmbFormField.save(field);
      } else {
        Integer maxRow = dAmbFormField.getMaxRow(service.getId(), form.getId());
        for(AmbFormCols col: cols) {
          AmbFormFields field = new AmbFormFields();
          field.setService(service.getId());
          field.setFieldLabel(Util.get(req, "label"));
          Long count = dAmbFormField.getCount("From AmbFormFields Where form = " + form.getId());
          field.setOrd(Integer.valueOf("" + count));
          field.setFieldName("c" + (count + 1));
          field.setTypeCode("float_nonorm");
          field.setNormaType("all");
          field.setCol(col.getOrd());
          field.setRow(maxRow + 1);
          field.setForm(form.getId());
          dAmbFormField.save(field);
        }
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "del.s", method = RequestMethod.POST)
  @ResponseBody
  protected String form_field_del(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      int id = Util.getInt(req, "id");
      AmbFormFields field = dAmbFormField.get(id);
      if(dAmbFormCol.getCount("From AmbFormCols Where form = " + field.getForm()) > 1) {
        dAmbFormFieldOption.delSql("From AmbFormFieldOptions t Where Exists (Select 1 From AmbFormFields c Where t.field = c.id And c.form = " + field.getForm() + " And c.row = " + field.getRow() + ")");
        dAmbFormFieldNorma.delSql("From AmbFormFieldNormas t Where Exists (Select 1 From AmbFormFields c Where t.field = c.id And c.form = " + field.getForm() + " And c.row = " + field.getRow() + ")");
        dAmbFormField.delSql("From AmbFormFields Where form = " + field.getForm() + " And row = " + field.getRow());
      } else {
        dAmbFormFieldOption.delSql("From AmbFormFieldOptions Where field = " + id);
        dAmbFormFieldNorma.delSql("From AmbFormFieldNormas Where field = " + id);
        dAmbFormField.delete(field.getId());
      }
      if(dAmbFormField.getCount("From AmbFormFields Where form = " + field.getForm()) == 0) dAmbForm.delete(field.getForm());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "norm/set.s", method = RequestMethod.POST)
  @ResponseBody
  protected String set_service_field_norm(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      AmbFormFields field = dAmbFormField.get(Util.getInt(req, "id"));
      field.setNormaType(Util.get(req, "norm"));
      dAmbFormField.save(field);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "type/set.s", method = RequestMethod.POST)
  @ResponseBody
  protected String set_service_field_type(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      AmbFormFields field = dAmbFormField.get(Util.getInt(req, "id"));
      field.setTypeCode(Util.get(req, "type"));
      dAmbFormField.save(field);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "option/add.s", method = RequestMethod.POST)
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
      AmbFormFields f = dAmbFormField.get(opt.getField());
      f.setTypeCode("select");
      dAmbFormField.save(f);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "option/del.s", method = RequestMethod.POST)
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

  @RequestMapping(value = "norma/add.s", method = RequestMethod.POST)
  @ResponseBody
  protected String add_service_field_norma(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      AmbServices service = dAmbService.get(Util.getInt(req, "service"));
      AmbFormFieldNormas obj = new AmbFormFieldNormas();
      obj.setService(service.getId());
      obj.setField(Util.getInt(req, "field"));
      obj.setNormType(Util.get(req, "type"));
      obj.setSex("male");
      dAmbFormFieldNorma.save(obj);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "norma/del.s", method = RequestMethod.POST)
  @ResponseBody
  protected String del_service_field_norma(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      dAmbFormFieldNorma.delete(Util.getInt(req, "id"));
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "column/add.s", method = RequestMethod.POST)
  @ResponseBody
  protected String add_column(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      AmbServices service = dAmbService.get(Util.getInt(req, "service"));
      AmbForms form = dAmbForm.get(Util.getInt(req, "form"));
      if(dAmbFormCol.getCount("From AmbFormCols Where form = " + + form.getId()) == 0) {
        AmbFormCols col = new AmbFormCols();
        col.setForm(form.getId());
        col.setService(service.getId());
        col.setOrd(1);
        col.setName("Значение");
        dAmbFormCol.save(col);
      }
      AmbFormCols col = new AmbFormCols();
      col.setForm(form.getId());
      col.setService(service.getId());
      col.setId(null);
      col.setOrd(Integer.parseInt("" + dAmbFormCol.getCount("From AmbFormCols Where service = " + service.getId())) + 1);
      col.setName("Значение");
      dAmbFormCol.saveAndReturn(col);
      List<AmbFormFields> fields = dAmbFormField.list("From AmbFormFields Where col = 1 And form = " + form.getId());
      for(AmbFormFields f: fields) {
        f.setId(null);
        f.setCol(col.getOrd());
        Long count = dAmbFormField.getCount("From AmbFormFields Where col = 1 And form = " + form.getId());
        f.setOrd(Integer.valueOf("" + count));
        f.setFieldName("c" + (count + 1));
        dAmbFormField.save(f);
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "column/delete.s", method = RequestMethod.POST)
  @ResponseBody
  protected String del_column(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      AmbForms form = dAmbForm.get(Util.getInt(req, "form"));
      AmbFormCols col = dAmbFormCol.get(Util.getInt(req, "col"));
      dAmbFormFieldNorma.delSql("From AmbFormFieldNormas t Where Exists (Select 1 From AmbFormFields c Where c.id = t.field And c.form = " + form.getId() + " And c.col = " + col.getId() + ")");
      dAmbFormFieldOption.delSql("From AmbFormFieldOptions t Where Exists (Select 1 From AmbFormFields c Where c.id = t.field And c.form = " + form.getId() + " And c.col = " + col.getId() + ")");
      dAmbFormField.delSql("From AmbFormFields Where form = " + form.getId() + " And col = " + col.getOrd());
      dAmbFormCol.delete(col.getId());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "form/copy.s", method = RequestMethod.POST)
  @ResponseBody
  protected String copy_form(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      AmbServices service = dAmbService.get(Util.getInt(req, "service"));
      AmbForms form = dAmbForm.get(Util.getInt(req, "form"));
      List<AmbFormFields> fields = dAmbFormField.list("From AmbFormFields Where form = " + form.getId());
      AmbForms newForm = new AmbForms();
      newForm.setService(service.getId());
      newForm.setActDate(new Date());
      newForm.setState("N");
      dAmbForm.saveAndReturn(newForm);
      for(AmbFormFields f: fields) {
        AmbFormFields a = f;
        a.setId(null);
        a.setForm(newForm.getId());
        dAmbFormField.saveAndReturn(a);
        List<AmbFormFieldNormas> norms = dAmbFormFieldNorma.list("From AmbFormFieldNormas Where field = " + f.getId());
        List<AmbFormFieldOptions> options = dAmbFormFieldOption.list("From AmbFormFieldOptions Where field = " + f.getId());
        for(AmbFormFieldNormas n: norms) {
          n.setId(null);
          n.setField(a.getId());
          dAmbFormFieldNorma.save(n);
        }
        for(AmbFormFieldOptions o: options) {
          o.setId(null);
          o.setField(a.getId());
          dAmbFormFieldOption.save(o);
        }
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "column/name.s", method = RequestMethod.POST)
  @ResponseBody
  protected String set_col_name(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      AmbFormCols col = dAmbFormCol.get(Util.getInt(req, "id"));
      col.setName(Util.get(req, "name"));
      dAmbFormCol.save(col);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }
}
