package ckb.controllers.mo;

import ckb.dao.med.amb.DAmbPatient;
import ckb.dao.med.amb.DAmbPatientService;
import ckb.dao.med.amb.DAmbResult;
import ckb.dao.med.amb.form.DAmbForm;
import ckb.dao.med.amb.form.DAmbFormCol;
import ckb.dao.med.amb.form.DAmbFormField;
import ckb.dao.med.amb.form.DAmbFormFieldNorma;
import ckb.domains.med.amb.*;
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
import java.util.Date;
import java.util.HashMap;
import java.util.List;

@Controller
@RequestMapping(value = "/ambs/work/")
public class CAmbWork {

  @Autowired private DAmbPatientService dAmbPatientService;
  @Autowired private DAmbFormCol dAmbFormCol;
  @Autowired private SMoAmb dSMoAmb;
  @Autowired private DAmbForm dAmbForm;
  @Autowired private DAmbResult dAmbResult;
  @Autowired private DAmbFormField dAmbFormField;
  @Autowired private DAmbPatient dAmbPatient;
  @Autowired private DAmbFormFieldNorma dAmbFormFieldNorma;

  @RequestMapping("form.s")
  protected String patient_service(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    int id = Util.getInt(req, "id");
    AmbPatientServices service = dAmbPatientService.get(id);
    AmbPatients patient = dAmbPatient.get(service.getPatient());
    if(session.getCurUrl().contains("/ambs/doctor/service.s"))
      session.setCurUrl("/ambs/doctor/service.s?patient=" + service.getPatient() + "&id=" + id);
    model.addAttribute("service", service);
    if(service.getAmbForm() == null) {
      service.setAmbForm(dAmbForm.maxForm(service.getService().getId()));
      dAmbPatientService.save(service);
    }
    List<AmbFormFieldRow> fields = dSMoAmb.serviceFields(service.getService().getId(), service.getAmbForm());
    model.addAttribute("fields", fields);
    model.addAttribute("code_exist", getFieldExist(fields, "code"));
    model.addAttribute("norma_exist", getFieldExist(fields, "norma"));
    model.addAttribute("ei_exist", getFieldExist(fields, "ei"));
    model.addAttribute("text_exist", getFieldExist(fields, "type"));
    List<AmbFormCols> cols = dAmbFormCol.list("From AmbFormCols Where form = " + service.getAmbForm() + " Order By ord");
    if(cols.isEmpty()) {
      AmbFormCols c = new AmbFormCols();
      c.setName("Значение");
      cols = new ArrayList<>();
      cols.add(c);
    }
    model.addAttribute("res", getResult(patient, service, false));
    model.addAttribute("cols", cols);
    return "/mo/amb/doctor/form";
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

  @RequestMapping(value = "save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String save_form(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      AmbPatientServices ser = dAmbPatientService.get(Util.getInt(req, "ps_id"));
      AmbResults r = ser.getResult() == null || ser.getResult() == 0 ? new AmbResults() : dAmbResult.get(ser.getResult());
      r.setPatient(ser.getPatient());
      r.setService(ser.getId());
      r.setForm(ser.getAmbForm());
      r.setC1(Util.get(req, "c1"));
      r.setC2(Util.get(req, "c2"));
      r.setC3(Util.get(req, "c3"));
      r.setC4(Util.get(req, "c4"));
      r.setC5(Util.get(req, "c5"));
      r.setC6(Util.get(req, "c6"));
      r.setC7(Util.get(req, "c7"));
      r.setC8(Util.get(req, "c8"));
      r.setC9(Util.get(req, "c9"));
      r.setC10(Util.get(req, "c10"));
      r.setC11(Util.get(req, "c11"));
      r.setC12(Util.get(req, "c12"));
      r.setC13(Util.get(req, "c13"));
      r.setC14(Util.get(req, "c14"));
      r.setC15(Util.get(req, "c15"));
      r.setC16(Util.get(req, "c16"));
      r.setC17(Util.get(req, "c17"));
      r.setC18(Util.get(req, "c18"));
      r.setC19(Util.get(req, "c19"));
      r.setC20(Util.get(req, "c20"));
      r.setC21(Util.get(req, "c21"));
      r.setC22(Util.get(req, "c22"));
      r.setC23(Util.get(req, "c23"));
      r.setC24(Util.get(req, "c24"));
      r.setC25(Util.get(req, "c25"));
      r.setC26(Util.get(req, "c26"));
      r.setC27(Util.get(req, "c27"));
      r.setC28(Util.get(req, "c28"));
      r.setC29(Util.get(req, "c29"));
      r.setC30(Util.get(req, "c30"));
      r.setC31(Util.get(req, "c31"));
      r.setC32(Util.get(req, "c32"));
      r.setC33(Util.get(req, "c33"));
      r.setC34(Util.get(req, "c34"));
      r.setC35(Util.get(req, "c35"));
      r.setC36(Util.get(req, "c36"));
      r.setC37(Util.get(req, "c37"));
      r.setC38(Util.get(req, "c38"));
      r.setC39(Util.get(req, "c39"));
      r.setC40(Util.get(req, "c40"));
      r.setC41(Util.get(req, "c41"));
      r.setC42(Util.get(req, "c42"));
      r.setC43(Util.get(req, "c43"));
      r.setC44(Util.get(req, "c44"));
      r.setC45(Util.get(req, "c45"));
      r.setC46(Util.get(req, "c46"));
      r.setC47(Util.get(req, "c47"));
      r.setC48(Util.get(req, "c48"));
      r.setC49(Util.get(req, "c49"));
      r.setC50(Util.get(req, "c50"));
      r.setC51(Util.get(req, "c51"));
      r.setC52(Util.get(req, "c52"));
      r.setC53(Util.get(req, "c53"));
      r.setC54(Util.get(req, "c54"));
      r.setC55(Util.get(req, "c55"));
      r.setC56(Util.get(req, "c56"));
      r.setC57(Util.get(req, "c57"));
      r.setC58(Util.get(req, "c58"));
      r.setC59(Util.get(req, "c59"));
      r.setC60(Util.get(req, "c60"));
      dAmbResult.saveAndReturn(r);
      ser.setResult(r.getId());
      AmbForms form = dAmbForm.get(ser.getAmbForm());
      form.setState("Y");
      dAmbForm.save(form);
      dAmbPatientService.save(ser);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  protected String getCellResult(AmbPatients patient, AmbFormFields field, String val, boolean view) {
    if(!view) return val;
    if(field.getTypeCode().equals("float_norm")) {
      Double v = Double.parseDouble(val);
      AmbFormFieldNormas norma = null;
      if(field.getNormaType().equals("all")) {
        norma = dAmbFormFieldNorma.obj("From AmbFormFieldNormas Where normType = 'all' And field = " + field.getId());
      }
      if(field.getNormaType().equals("sex_norm")) {
        norma = dAmbFormFieldNorma.obj("From AmbFormFieldNormas Where normType = 'sex_norm' And sex = '" + (patient.getSex().getId() == 13 ? "fe" : "") + "male' And field = " + field.getId());
      }
      if(field.getNormaType().equals("year_norm")) {
        norma = dAmbFormFieldNorma.obj("From AmbFormFieldNormas Where normType = 'year_norm' And " + (1900 + patient.getCrOn().getYear() - patient.getBirthyear()) +  " Between yearFrom And yearTo And field = " + field.getId());
      }
      if(field.getNormaType().equals("sex_year_norm")) {
        norma = dAmbFormFieldNorma.obj("From AmbFormFieldNormas Where normType = 'sex_year_norm' And sex = '" + (patient.getSex().getId() == 13 ? "fe" : "") + "male' And " + (1900 + patient.getCrOn().getYear() - patient.getBirthyear()) +  " Between yearFrom And yearTo And field = " + field.getId());
      }
      if(norma != null) {
        if(v < norma.getNormaFrom()) return "<b style='color:red'>" + val + " <span style='font-size:14px'>&#8681;</span></b>";
        if(v > norma.getNormaTo()) return "<b style='color:red'>" + val + " <span style='font-size:14px'>&#8679;</span></b>";
      }
    }
    return val;
  }

  protected HashMap<String, String> getResult(AmbPatients patient, AmbPatientServices ser, boolean view) {
    HashMap<String, String> res = new HashMap<>();
    if(ser.getResult() == null || ser.getResult() == 0) return new HashMap<>();
    List<AmbFormFields> fields = dAmbFormField.list("From AmbFormFields Where form = " + ser.getAmbForm());
    AmbResults r = dAmbResult.get(ser.getResult());
    for(AmbFormFields field: fields) {
      if(field.getFieldName().equals("c1")) res.put("c1", getCellResult(patient, field, r.getC1(), view));
      if(field.getFieldName().equals("c2")) res.put("c2", getCellResult(patient, field, r.getC2(), view));
      if(field.getFieldName().equals("c3")) res.put("c3", getCellResult(patient, field, r.getC3(), view));
      if(field.getFieldName().equals("c4")) res.put("c4", getCellResult(patient, field, r.getC4(), view));
      if(field.getFieldName().equals("c5")) res.put("c5", getCellResult(patient, field, r.getC5(), view));
      if(field.getFieldName().equals("c6")) res.put("c6", getCellResult(patient, field, r.getC6(), view));
      if(field.getFieldName().equals("c7")) res.put("c7", getCellResult(patient, field, r.getC7(), view));
      if(field.getFieldName().equals("c8")) res.put("c8", getCellResult(patient, field, r.getC8(), view));
      if(field.getFieldName().equals("c9")) res.put("c9", getCellResult(patient, field, r.getC9(), view));
      if(field.getFieldName().equals("c10")) res.put("c10", getCellResult(patient, field, r.getC10(), view));
      if(field.getFieldName().equals("c11")) res.put("c11", getCellResult(patient, field, r.getC11(), view));
      if(field.getFieldName().equals("c12")) res.put("c12", getCellResult(patient, field, r.getC12(), view));
      if(field.getFieldName().equals("c13")) res.put("c13", getCellResult(patient, field, r.getC13(), view));
      if(field.getFieldName().equals("c14")) res.put("c14", getCellResult(patient, field, r.getC14(), view));
      if(field.getFieldName().equals("c15")) res.put("c15", getCellResult(patient, field, r.getC15(), view));
      if(field.getFieldName().equals("c16")) res.put("c16", getCellResult(patient, field, r.getC16(), view));
      if(field.getFieldName().equals("c17")) res.put("c17", getCellResult(patient, field, r.getC17(), view));
      if(field.getFieldName().equals("c18")) res.put("c18", getCellResult(patient, field, r.getC18(), view));
      if(field.getFieldName().equals("c19")) res.put("c19", getCellResult(patient, field, r.getC19(), view));
      if(field.getFieldName().equals("c20")) res.put("c20", getCellResult(patient, field, r.getC20(), view));
      if(field.getFieldName().equals("c21")) res.put("c21", getCellResult(patient, field, r.getC21(), view));
      if(field.getFieldName().equals("c22")) res.put("c22", getCellResult(patient, field, r.getC22(), view));
      if(field.getFieldName().equals("c23")) res.put("c23", getCellResult(patient, field, r.getC23(), view));
      if(field.getFieldName().equals("c24")) res.put("c24", getCellResult(patient, field, r.getC24(), view));
      if(field.getFieldName().equals("c25")) res.put("c25", getCellResult(patient, field, r.getC25(), view));
      if(field.getFieldName().equals("c26")) res.put("c26", getCellResult(patient, field, r.getC26(), view));
      if(field.getFieldName().equals("c27")) res.put("c27", getCellResult(patient, field, r.getC27(), view));
      if(field.getFieldName().equals("c28")) res.put("c28", getCellResult(patient, field, r.getC28(), view));
      if(field.getFieldName().equals("c29")) res.put("c29", getCellResult(patient, field, r.getC29(), view));
      if(field.getFieldName().equals("c30")) res.put("c30", getCellResult(patient, field, r.getC30(), view));
      if(field.getFieldName().equals("c31")) res.put("c31", getCellResult(patient, field, r.getC31(), view));
      if(field.getFieldName().equals("c32")) res.put("c32", getCellResult(patient, field, r.getC32(), view));
      if(field.getFieldName().equals("c33")) res.put("c33", getCellResult(patient, field, r.getC33(), view));
      if(field.getFieldName().equals("c34")) res.put("c34", getCellResult(patient, field, r.getC34(), view));
      if(field.getFieldName().equals("c35")) res.put("c35", getCellResult(patient, field, r.getC35(), view));
      if(field.getFieldName().equals("c36")) res.put("c36", getCellResult(patient, field, r.getC36(), view));
      if(field.getFieldName().equals("c37")) res.put("c37", getCellResult(patient, field, r.getC37(), view));
      if(field.getFieldName().equals("c38")) res.put("c38", getCellResult(patient, field, r.getC38(), view));
      if(field.getFieldName().equals("c39")) res.put("c39", getCellResult(patient, field, r.getC39(), view));
      if(field.getFieldName().equals("c40")) res.put("c40", getCellResult(patient, field, r.getC40(), view));
      if(field.getFieldName().equals("c41")) res.put("c41", getCellResult(patient, field, r.getC41(), view));
      if(field.getFieldName().equals("c42")) res.put("c42", getCellResult(patient, field, r.getC42(), view));
      if(field.getFieldName().equals("c43")) res.put("c43", getCellResult(patient, field, r.getC43(), view));
      if(field.getFieldName().equals("c44")) res.put("c44", getCellResult(patient, field, r.getC44(), view));
      if(field.getFieldName().equals("c45")) res.put("c45", getCellResult(patient, field, r.getC45(), view));
      if(field.getFieldName().equals("c46")) res.put("c46", getCellResult(patient, field, r.getC46(), view));
      if(field.getFieldName().equals("c47")) res.put("c47", getCellResult(patient, field, r.getC47(), view));
      if(field.getFieldName().equals("c48")) res.put("c48", getCellResult(patient, field, r.getC48(), view));
      if(field.getFieldName().equals("c49")) res.put("c49", getCellResult(patient, field, r.getC49(), view));
      if(field.getFieldName().equals("c50")) res.put("c50", getCellResult(patient, field, r.getC50(), view));
      if(field.getFieldName().equals("c51")) res.put("c51", getCellResult(patient, field, r.getC51(), view));
      if(field.getFieldName().equals("c52")) res.put("c52", getCellResult(patient, field, r.getC52(), view));
      if(field.getFieldName().equals("c53")) res.put("c53", getCellResult(patient, field, r.getC53(), view));
      if(field.getFieldName().equals("c54")) res.put("c54", getCellResult(patient, field, r.getC54(), view));
      if(field.getFieldName().equals("c55")) res.put("c55", getCellResult(patient, field, r.getC55(), view));
      if(field.getFieldName().equals("c56")) res.put("c56", getCellResult(patient, field, r.getC56(), view));
      if(field.getFieldName().equals("c57")) res.put("c57", getCellResult(patient, field, r.getC57(), view));
      if(field.getFieldName().equals("c58")) res.put("c58", getCellResult(patient, field, r.getC58(), view));
      if(field.getFieldName().equals("c59")) res.put("c59", getCellResult(patient, field, r.getC59(), view));
      if(field.getFieldName().equals("c60")) res.put("c60", getCellResult(patient, field, r.getC60(), view));

    }
    return res;
  }

  @RequestMapping(value = "confirm.s", method = RequestMethod.POST)
  @ResponseBody
  protected String confirm_form(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      AmbPatientServices ser = dAmbPatientService.get(Util.getInt(req, "id"));
      if(ser.getResult() > 0) {
        ser.setConfDate(new Date());
        ser.setState("DONE");
        dAmbPatientService.save(ser);
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("view.s")
  protected String view_form(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    int id = Util.getInt(req, "id");
    AmbPatientServices service = dAmbPatientService.get(id);
    AmbPatients patient = dAmbPatient.get(service.getPatient());
    if(session.getCurUrl().contains("/ambs/doctor/service.s"))
      session.setCurUrl("/ambs/doctor/service.s?patient=" + service.getPatient() + "&id=" + id);
    model.addAttribute("service", service);
    List<AmbFormFieldRow> fields = dSMoAmb.serviceFields(service.getService().getId(), service.getAmbForm());
    model.addAttribute("fields", fields);
    model.addAttribute("code_exist", getFieldExist(fields, "code"));
    model.addAttribute("norma_exist", getFieldExist(fields, "norma"));
    model.addAttribute("ei_exist", getFieldExist(fields, "ei"));
    model.addAttribute("text_exist", getFieldExist(fields, "type"));
    List<AmbFormCols> cols = dAmbFormCol.list("From AmbFormCols Where form = " + service.getAmbForm() + " Order By ord");
    if(cols.isEmpty()) {
      AmbFormCols c = new AmbFormCols();
      c.setName("Значение");
      cols = new ArrayList<>();
      cols.add(c);
    }
    model.addAttribute("res", getResult(patient, service, true));
    model.addAttribute("cols", cols);
    return "/mo/amb/doctor/view_form";
  }

  @RequestMapping("print.s")
  protected String print_form(HttpServletRequest req, Model model) {
    int id = Util.getInt(req, "patient");
    AmbPatients patient = dAmbPatient.get(id);
    model.addAttribute("patient", patient);
    String[] services = req.getParameterValues("service");
    model.addAttribute("services", services);
    model.addAttribute("now", Util.getCurDate() + " " + Util.getCurTime());
    return "/mo/amb/doctor/print_form";
  }

  @RequestMapping("print/service.s")
  protected String print_service(HttpServletRequest req, Model model) {
    int id = Util.getInt(req, "id");
    AmbPatientServices service = dAmbPatientService.get(id);
    AmbPatients patient = dAmbPatient.get(service.getPatient());
    model.addAttribute("service", service);
    List<AmbFormFieldRow> fields = dSMoAmb.serviceFields(service.getService().getId(), service.getAmbForm());
    model.addAttribute("fields", fields);
    model.addAttribute("code_exist", getFieldExist(fields, "code"));
    model.addAttribute("norma_exist", getFieldExist(fields, "norma"));
    model.addAttribute("ei_exist", getFieldExist(fields, "ei"));
    model.addAttribute("text_exist", getFieldExist(fields, "type"));
    List<AmbFormCols> cols = dAmbFormCol.list("From AmbFormCols Where form = " + service.getAmbForm() + " Order By ord");
    if(cols.isEmpty()) {
      AmbFormCols c = new AmbFormCols();
      c.setName("Значение");
      cols = new ArrayList<>();
      cols.add(c);
    }
    model.addAttribute("res", getResult(patient, service, true));
    model.addAttribute("cols", cols);
    return "/mo/amb/doctor/print_service";
  }
}
