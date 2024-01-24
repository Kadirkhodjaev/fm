package ckb.services.med.results;

import ckb.dao.admin.forms.fields.DFormField;
import ckb.dao.admin.users.DUser;
import ckb.dao.med.amb.DAmbPatientServices;
import ckb.dao.med.amb.DAmbResults;
import ckb.dao.med.amb.DAmbServiceFields;
import ckb.dao.med.kdos.forms.f1.DF1;
import ckb.dao.med.kdos.forms.f10.DF10;
import ckb.dao.med.kdos.forms.f11.DF11;
import ckb.dao.med.kdos.forms.f120.DF120;
import ckb.dao.med.kdos.forms.f121.DF121;
import ckb.dao.med.kdos.forms.f13.DF13;
import ckb.dao.med.kdos.forms.f15.DF15;
import ckb.dao.med.kdos.forms.f152.DF152;
import ckb.dao.med.kdos.forms.f16.DF16;
import ckb.dao.med.kdos.forms.f17.DF17;
import ckb.dao.med.kdos.forms.f174.DF174;
import ckb.dao.med.kdos.forms.f56.DF56;
import ckb.dao.med.kdos.forms.f6.DF6;
import ckb.dao.med.kdos.forms.f7.DF7;
import ckb.dao.med.kdos.forms.f8.DF8;
import ckb.dao.med.kdos.forms.f999.DF999;
import ckb.dao.med.lv.bio.DLvBio;
import ckb.dao.med.lv.consul.DLvConsul;
import ckb.dao.med.lv.plan.DLvPlan;
import ckb.dao.med.patient.DPatient;
import ckb.domains.admin.FormFields;
import ckb.domains.med.amb.AmbPatientServices;
import ckb.domains.med.amb.AmbResults;
import ckb.domains.med.amb.AmbServiceFields;
import ckb.domains.med.kdo.*;
import ckb.domains.med.lv.LvConsuls;
import ckb.domains.med.lv.LvPlans;
import ckb.models.result.FormRow;
import ckb.models.result.Result;
import ckb.services.admin.form.SForm;
import ckb.utils.Util;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class SRkdoImp implements SRkdo {

  @Autowired DUser dUser;
  @Autowired DLvPlan dLvPlan;
  @Autowired SForm sForm;
  @Autowired DPatient dPatient;
  @Autowired DFormField dFormField;
  @Autowired DLvBio dlvBio;
  @Autowired DLvConsul dLvConsul;
  @Autowired DF1 df1;
  @Autowired DF6 df6;
  @Autowired DF7 df7;
  @Autowired DF8 df8;
  @Autowired DF10 df10;
  @Autowired DF11 df11;
  @Autowired DF13 df13;
  @Autowired DF15 df15;
  @Autowired DF16 df16;
  @Autowired DF17 df17;
  @Autowired DF56 df56;
  @Autowired DF120 df120;
  @Autowired DF121 df121;
  @Autowired DF152 df152;
  @Autowired DF174 df174;
  @Autowired DF999 df999;
  @Autowired private DAmbPatientServices dAmbPatientServices;
  @Autowired private DAmbResults dAmbResults;
  @Autowired private DAmbServiceFields dAmbServiceFields;

  @Override
  public List<String> getResults(int curPat) {
    List<String> list = new ArrayList<String>();
    List<LvPlans> plans = dLvPlan.getByPatientId(curPat);
    List<LvConsuls> cons = dLvConsul.getByPat(curPat);
    for(LvPlans plan : plans) {
      if(plan.getDone().equals("Y") && plan.getResultId() > 0 && plan.getKdo().getFormId() != 889) {
        /**/
        if(plan.getKdo().getFormId() == 999 || plan.getKdo().getFormId() == 888 || plan.getKdo().getFormId() == 777) {
          String res = df999.get(plan.getResultId()).getC1();
          if(res != null && !res.equals(""))
            list.add("<p style='display: inline'><b>" + plan.getKdo().getShortName() + "</b>:" + res + "; " + "</p><br/>");
        } else {
          if (plan.getKdo().getId() == 1)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF1(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 6)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF6(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 7)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF7(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 8)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF8(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 10)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF10(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 11)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF11(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 13)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF13(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 15)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF15(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 16)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF16(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 17) {
            if(plan.getKdo().getFormId() == 75 && plan.getId() <= 27056) {
              String res = df999.get(plan.getResultId()).getC1();
              if(res != null && !res.equals(""))
                list.add("<p style='display: inline'><b>" + plan.getKdo().getShortName() + "</b>:" + res + "; " + "</p><br/>");
            } else {
              list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF17(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
            }
          }
          if (plan.getKdo().getId() == 56)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF56(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 120)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF120(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 121)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF121(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 152)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF152(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 153)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF13(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 174)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF174(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
        }
      }
    }
    for(LvConsuls con : cons) {
      if(con.getText() != null && !con.getText().equals(""))
        if(con.getLvId() != null)
          list.add("<b>Консультацияси: " + dUser.get(con.getLvId()).getProfil() + "</b>: " + con.getText() + ";" + con.getReq() + "<br/>");
        else
          list.add("<b>Консультацияси: " + con.getLvName() + " </b> " + con.getText() + "<br/>");
    }
    return list;
  }

  protected HashMap<String, String> getAmbHashResult(int id) {
    AmbResults r = dAmbResults.get(id);
    HashMap<String, String> hm = new HashMap<String, String>();
    hm.put("c1", r.getC1());
    hm.put("c2", r.getC2());
    hm.put("c3", r.getC3());
    hm.put("c4", r.getC4());
    hm.put("c5", r.getC5());
    hm.put("c6", r.getC6());
    hm.put("c7", r.getC7());
    hm.put("c8", r.getC8());
    hm.put("c9", r.getC9());
    hm.put("c10", r.getC10());
    hm.put("c11", r.getC11());
    hm.put("c12", r.getC12());
    hm.put("c13", r.getC13());
    hm.put("c14", r.getC14());
    hm.put("c15", r.getC15());
    hm.put("c16", r.getC16());
    hm.put("c17", r.getC17());
    hm.put("c18", r.getC18());
    hm.put("c19", r.getC19());
    hm.put("c20", r.getC20());
    hm.put("c21", r.getC21());
    hm.put("c22", r.getC22());
    hm.put("c23", r.getC23());
    hm.put("c24", r.getC24());
    hm.put("c25", r.getC25());
    hm.put("c26", r.getC26());
    hm.put("c27", r.getC27());
    hm.put("c28", r.getC28());
    hm.put("c29", r.getC29());
    hm.put("c30", r.getC30());
    hm.put("c31", r.getC31());
    hm.put("c32", r.getC32());
    hm.put("c33", r.getC33());
    hm.put("c34", r.getC34());
    hm.put("c35", r.getC35());
    hm.put("c36", r.getC36());
    hm.put("c37", r.getC37());
    hm.put("c38", r.getC38());
    hm.put("c39", r.getC39());
    hm.put("c40", r.getC40());
    hm.put("c41", r.getC41());
    hm.put("c42", r.getC42());
    hm.put("c43", r.getC43());
    hm.put("c44", r.getC44());
    hm.put("c45", r.getC45());
    hm.put("c46", r.getC46());
    hm.put("c47", r.getC47());
    hm.put("c48", r.getC48());
    hm.put("c49", r.getC49());
    hm.put("c50", r.getC50());
    hm.put("c51", r.getC51());
    hm.put("c52", r.getC52());
    hm.put("c53", r.getC53());
    hm.put("c54", r.getC54());
    hm.put("c55", r.getC55());
    hm.put("c56", r.getC56());
    hm.put("c57", r.getC57());
    hm.put("c58", r.getC58());
    hm.put("c59", r.getC59());
    hm.put("c60", r.getC60());
    return hm;
  }

  @Override
  public Result getAmbResult(int id) {
    Result res = new Result();
    AmbPatientServices ser = dAmbPatientServices.get(id);
    res.setPatientService(ser.getId());
    res.setServiceName(ser.getService().getName());
    HashMap<String, String> r = getAmbHashResult(ser.getResult());
    Integer form = ser.getService().getForm_id();
    res.setForm(form == null ? 0 : form);
    if(form != null && (form == 777 || form == 888 || form == 999)) {
      res.setNorma(ser.getService().getNormaFrom() + " " + ser.getService().getNormaTo());
      res.setEI(ser.getService().getEi());
      String val = r.get("c1");
      if (val == null || val.equals("") || val.equals("<br>") || val.equals("<br/>")) return null;
      res.setValue(val);
    } else if (form == null) {
      List<AmbServiceFields> fieds = dAmbServiceFields.byService(ser.getService().getId());
      List<String> colName = new ArrayList<String>();
      List<String> vals = new ArrayList<String>();
      if(fieds != null && fieds.size() > 0)
        for(AmbServiceFields field: fieds) {
          colName.add(field.getName());
          vals.add(r.get("c" + field.getField()));
        }
      res.setColName(colName);
      res.setVals(vals);
    } else if (form != null && (form == 1000 || form == 1001 || form == 1002 || form == 1003 || form == 1005 || form == 1006 || form == 1007 || form == 1008 || form == 1009)) {
      List<FormFields> fieds = dFormField.getFileds(ser.getService().getForm_id());
      List<FormRow> fs = new ArrayList<FormRow>();
      if(fieds != null && fieds.size() > 0)
        for(FormFields field: fieds) {
          FormRow f = new FormRow();
          f.setName(field.getField());
          f.setFieldType(field.getFieldType());
          f.setNorma(Util.nvl(field.getNormaFrom()) + " " + Util.nvl(field.getNormaTo()));
          f.setEI(field.getEI());
          f.setValue(r.get(field.getFieldCode()));
          fs.add(f);
        }
      res.setRows(fs);
    } else if (form != null && (form == 81 || form == 82 || form == 83 || form == 1004)) {
      List<FormFields> fieds = dFormField.getFileds(ser.getService().getForm_id());
      List<FormRow> fs = new ArrayList<FormRow>();
      if(fieds != null && fieds.size() > 0)
        for(FormFields field: fieds) {
          FormRow f = new FormRow();
          f.setName(field.getField());
          f.setFieldType(field.getFieldType());
          f.setValue(r.get(field.getFieldCode()));
          fs.add(f);
        }
      res.setRows(fs);
    }
    return res;
  }

  private String makeCell(List<FormFields> cols, Integer pos, String val){
    try {
      if (Util.nvl(cols.get(pos - 1).getResFlag(), "N").equals("Y") && !"".equals(val)) {
        return "<i>" + cols.get(pos - 1).getField() + "</i>: " + val + (Util.nvl(cols.get(pos - 1).getEI()).equals("") ? "" : " " + Util.nvl(cols.get(pos - 1).getEI())) + (cols.size() == pos ? "; " : ", ");
      } else
        return "";
    } catch (Exception e) {
      return "";
    }
  }
  private String getDF1(Integer formId, Integer resId) {
    F1 f = df1.get(resId);
    StringBuilder sb = new StringBuilder();
    List<FormFields> c = dFormField.getFileds(formId);
    //
    sb.append(makeCell(c, 1 , f.getC1 ()));
    sb.append(makeCell(c, 2 , f.getC2 ()));
    sb.append(makeCell(c, 3 , f.getC3 ()));
    sb.append(makeCell(c, 4 , f.getC4 ()));
    sb.append(makeCell(c, 5 , f.getC5 ()));
    sb.append(makeCell(c, 6 , f.getC6 ()));
    sb.append(makeCell(c, 7 , f.getC7 ()));
    sb.append(makeCell(c, 8 , f.getC8 ()));
    sb.append(makeCell(c, 9 , f.getC9 ()));
    sb.append(makeCell(c, 10, f.getC10()));
    //
    return sb.toString();
  }
  private String getDF6(Integer formId, Integer resId) {
    F6 f = df6.get(resId);
    StringBuilder sb = new StringBuilder();
    List<FormFields> c = dFormField.getFileds(formId);
    //
    sb.append(makeCell(c, 1 , f.getC1 ()));
    sb.append(makeCell(c, 2 , f.getC2 ()));
    sb.append(makeCell(c, 3 , f.getC3 ()));
    sb.append(makeCell(c, 4 , f.getC4 ()));
    sb.append(makeCell(c, 5 , f.getC5 ()));
    sb.append(makeCell(c, 6 , f.getC6 ()));
    sb.append(makeCell(c, 7 , f.getC7 ()));
    sb.append(makeCell(c, 8 , f.getC8 ()));
    sb.append(makeCell(c, 9 , f.getC9 ()));
    sb.append(makeCell(c, 10, f.getC10()));
    sb.append(makeCell(c, 11, f.getC11()));
    sb.append(makeCell(c, 12, f.getC12()));
    sb.append(makeCell(c, 13, f.getC13()));
    sb.append(makeCell(c, 14, f.getC14()));
    sb.append(makeCell(c, 15, f.getC15()));
    sb.append(makeCell(c, 16, f.getC16()));
    sb.append(makeCell(c, 17, f.getC17()));
    //
    return sb.toString();
  }
  private String getDF7(Integer formId, Integer resId) {
    F7 f = df7.get(resId);
    StringBuilder sb = new StringBuilder();
    List<FormFields> c = dFormField.getFileds(formId);
    //
    sb.append(makeCell(c, 1 , f.getC1 ()));
    sb.append(makeCell(c, 2 , f.getC2 ()));
    sb.append(makeCell(c, 3 , f.getC3 ()));
    sb.append(makeCell(c, 4 , f.getC4 ()));
    sb.append(makeCell(c, 5 , f.getC5 ()));
    sb.append(makeCell(c, 6 , f.getC6 ()));
    sb.append(makeCell(c, 7 , f.getC7 ()));
    sb.append(makeCell(c, 8 , f.getC8 ()));
    sb.append(makeCell(c, 9 , f.getC9 ()));
    sb.append(makeCell(c, 10, f.getC10()));
    sb.append(makeCell(c, 11, f.getC11()));
    sb.append(makeCell(c, 12, f.getC12()));
    sb.append(makeCell(c, 13, f.getC13()));
    sb.append(makeCell(c, 14, f.getC14()));
    sb.append(makeCell(c, 15, f.getC15()));
    //
    return sb.toString();
  }
  private String getDF8(Integer formId, Integer resId) {
    F8 f = df8.get(resId);
    StringBuilder sb = new StringBuilder();
    List<FormFields> c = dFormField.getFileds(formId);
    //
    sb.append(makeCell(c, 1 , f.getC1 ()));
    sb.append(makeCell(c, 2 , f.getC2 ()));
    sb.append(makeCell(c, 3 , f.getC3 ()));
    sb.append(makeCell(c, 4 , f.getC4 ()));
    sb.append(makeCell(c, 5 , f.getC5 ()));
    sb.append(makeCell(c, 6 , f.getC6 ()));
    sb.append(makeCell(c, 7 , f.getC7 ()));
    sb.append(makeCell(c, 8 , f.getC8 ()));
    sb.append(makeCell(c, 9 , f.getC9 ()));
    sb.append(makeCell(c, 10, f.getC10()));
    sb.append(makeCell(c, 11, f.getC11()));
    sb.append(makeCell(c, 12, f.getC12()));
    sb.append(makeCell(c, 13, f.getC13()));
    sb.append(makeCell(c, 14, f.getC14()));
    sb.append(makeCell(c, 15, f.getC15()));
    sb.append(makeCell(c, 16, f.getC16()));
    sb.append(makeCell(c, 17, f.getC17()));
    sb.append(makeCell(c, 18, f.getC18()));
    //
    return sb.toString();
  }
  private String getDF10(Integer formId, Integer resId) {
    F10 f = df10.get(resId);
    StringBuilder sb = new StringBuilder();
    List<FormFields> c = dFormField.getFileds(formId);
    //
    sb.append(makeCell(c, 1 , f.getC1 ()));
    sb.append(makeCell(c, 2 , f.getC2 ()));
    sb.append(makeCell(c, 3 , f.getC3 ()));
    sb.append(makeCell(c, 4 , f.getC4 ()));
    sb.append(makeCell(c, 5 , f.getC5 ()));
    sb.append(makeCell(c, 6 , f.getC6 ()));
    sb.append(makeCell(c, 7 , f.getC7 ()));
    sb.append(makeCell(c, 8 , f.getC8 ()));
    sb.append(makeCell(c, 9 , f.getC9 ()));
    sb.append(makeCell(c, 10, f.getC10()));
    sb.append(makeCell(c, 11, f.getC11()));
    sb.append(makeCell(c, 12, f.getC12()));
    sb.append(makeCell(c, 13, f.getC13()));
    sb.append(makeCell(c, 14, f.getC14()));
    sb.append(makeCell(c, 15, f.getC15()));
    sb.append(makeCell(c, 16, f.getC16()));
    sb.append(makeCell(c, 17, f.getC17()));
    sb.append(makeCell(c, 18, f.getC18()));
    sb.append(makeCell(c, 19, f.getC19()));
    sb.append(makeCell(c, 20, f.getC20()));
    sb.append(makeCell(c, 21, f.getC21()));
    sb.append(makeCell(c, 22, f.getC22()));
    sb.append(makeCell(c, 23, f.getC23()));
    sb.append(makeCell(c, 24, f.getC24()));
    sb.append(makeCell(c, 25, f.getC25()));
    sb.append(makeCell(c, 26, f.getC26()));
    sb.append(makeCell(c, 27, f.getC27()));
    sb.append(makeCell(c, 28, f.getC28()));
    sb.append(makeCell(c, 29, f.getC29()));
    //
    return sb.toString();
  }
  private String getDF11(Integer formId, Integer resId) {
    F11 f = df11.get(resId);
    StringBuilder sb = new StringBuilder();
    List<FormFields> c = dFormField.getFileds(formId);
    //
    sb.append(makeCell(c, 1 , f.getC1 ()));
    sb.append(makeCell(c, 2 , f.getC2 ()));
    sb.append(makeCell(c, 3 , f.getC3 ()));
    //
    return sb.toString();
  }
  private String getDF13(Integer formId, Integer resId) {
    F13 f = df13.get(resId);
    StringBuilder sb = new StringBuilder();
    List<FormFields> c = dFormField.getFileds(formId);
    //
    sb.append(makeCell(c, 1 , f.getC1 ()));
    sb.append(makeCell(c, 2 , f.getC2 ()));
    sb.append(makeCell(c, 3 , f.getC3 ()));
    sb.append(makeCell(c, 4 , f.getC4 ()));
    sb.append(makeCell(c, 5 , f.getC5 ()));
    sb.append(makeCell(c, 6 , f.getC6 ()));
    sb.append(makeCell(c, 7 , f.getC7 ()));
    sb.append(makeCell(c, 8 , f.getC8 ()));
    sb.append(makeCell(c, 9 , f.getC9 ()));
    sb.append(makeCell(c, 10, f.getC10()));
    sb.append(makeCell(c, 11, f.getC11()));
    sb.append(makeCell(c, 12, f.getC12()));
    sb.append(makeCell(c, 13, f.getC13()));
    sb.append(makeCell(c, 14, f.getC14()));
    sb.append(makeCell(c, 15, f.getC15()));
    sb.append(makeCell(c, 16, f.getC16()));
    sb.append(makeCell(c, 17, f.getC17()));
    sb.append(makeCell(c, 18, f.getC18()));
    sb.append(makeCell(c, 19, f.getC19()));
    sb.append(makeCell(c, 20, f.getC20()));
    sb.append(makeCell(c, 21, f.getC21()));
    sb.append(makeCell(c, 22, f.getC22()));
    sb.append(makeCell(c, 23, f.getC23()));
    sb.append(makeCell(c, 24, f.getC24()));
    sb.append(makeCell(c, 25, f.getC25()));
    sb.append(makeCell(c, 26, f.getC26()));
    sb.append(makeCell(c, 27, f.getC27()));
    sb.append(makeCell(c, 28, f.getC28()));
    sb.append(makeCell(c, 29, f.getC29()));
    //
    return sb.toString();
  }
  private String getDF15(Integer formId, Integer resId) {
    F15 f = df15.get(resId);
    StringBuilder sb = new StringBuilder();
    List<FormFields> c = dFormField.getFileds(formId);
    //
    sb.append(makeCell(c, 1 , f.getC1 ()));
    sb.append(makeCell(c, 2 , f.getC2 ()));
    sb.append(makeCell(c, 3 , f.getC3 ()));
    //
    return sb.toString();
  }
  private String getDF16(Integer formId, Integer resId) {
    F16 f = df16.get(resId);
    StringBuilder sb = new StringBuilder();
    List<FormFields> c = dFormField.getFileds(formId);
    //
    sb.append(makeCell(c, 1 , f.getC1 ()));
    sb.append(makeCell(c, 2 , f.getC2 ()));
    sb.append(makeCell(c, 3 , f.getC3 ()));
    sb.append(makeCell(c, 4 , f.getC4 ()));
    sb.append(makeCell(c, 5 , f.getC5 ()));
    sb.append(makeCell(c, 6 , f.getC6 ()));
    sb.append(makeCell(c, 7 , f.getC7 ()));
    //
    return sb.toString();
  }
  private String getDF17(Integer formId, Integer resId) {
    F17 f = df17.get(resId);
    StringBuilder sb = new StringBuilder();
    List<FormFields> c = dFormField.getFileds(formId);
    //
    sb.append(makeCell(c, 1 , f.getC1 ()));
    sb.append(makeCell(c, 2 , f.getC2 ()));
    sb.append(makeCell(c, 3 , f.getC3 ()));
    //
    return sb.toString();
  }
  private String getDF56(Integer formId, Integer resId) {
    F56 f = df56.get(resId);
    StringBuilder sb = new StringBuilder();
    List<FormFields> c = dFormField.getFileds(formId);
    //
    sb.append(makeCell(c, 1 , f.getC1 ()));
    sb.append(makeCell(c, 2 , f.getC2 ()));
    sb.append(makeCell(c, 3 , f.getC3 ()));
    sb.append(makeCell(c, 4 , f.getC4 ()));
    sb.append(makeCell(c, 5 , f.getC5 ()));
    sb.append(makeCell(c, 6 , f.getC6 ()));
    //
    return sb.toString();
  }
  private String getDF999(Integer resId) {
    try {
      return df999.get(resId).getC1() + "; ";
    } catch(Exception e) {
      return "; ";
    }
  }

  private String getDF120(Integer formId, Integer resId) {
    F120 f = df120.get(resId);
    StringBuilder sb = new StringBuilder();
    List<FormFields> c = dFormField.getFileds(formId);
    //
    sb.append(makeCell(c, 1 , f.getC1()));
    sb.append(makeCell(c, 2 , f.getC2()));
    sb.append(makeCell(c, 3 , f.getC3()));
    sb.append(makeCell(c, 4 , f.getC4()));
    sb.append(makeCell(c, 5 , f.getC5()));
    sb.append(makeCell(c, 6 , f.getC6()));
    sb.append(makeCell(c, 7 , f.getC7()));
    sb.append(makeCell(c, 8 , f.getC8()));
    sb.append(makeCell(c, 9 , f.getC9()));
    sb.append(makeCell(c, 10, f.getC10()));
    sb.append(makeCell(c, 11, f.getC11()));
    sb.append(makeCell(c, 12, f.getC12()));
    sb.append(makeCell(c, 13, f.getC13()));
    sb.append(makeCell(c, 14, f.getC14()));
    sb.append(makeCell(c, 15, f.getC15()));
    sb.append(makeCell(c, 16, f.getC16()));
    sb.append(makeCell(c, 17, f.getC17()));
    sb.append(makeCell(c, 18, f.getC18()));
    sb.append(makeCell(c, 19, f.getC19()));
    sb.append(makeCell(c, 20, f.getC20()));
    sb.append(makeCell(c, 21, f.getC21()));
    sb.append(makeCell(c, 22, f.getC22()));
    sb.append(makeCell(c, 23, f.getC23()));
    sb.append(makeCell(c, 24, f.getC24()));
    sb.append(makeCell(c, 25, f.getC25()));
    sb.append(makeCell(c, 26, f.getC26()));
    sb.append(makeCell(c, 27, f.getC27()));
    //
    return sb.toString();
  }

  private String getDF121(Integer formId, Integer resId) {
    F121 f = df121.get(resId);
    StringBuilder sb = new StringBuilder();
    List<FormFields> c = dFormField.getFileds(formId);
    //
    sb.append(makeCell(c, 1 , f.getC1()));
    sb.append(makeCell(c, 2 , f.getC2()));
    sb.append(makeCell(c, 3 , f.getC3()));
    sb.append(makeCell(c, 4 , f.getC4()));
    //
    return sb.toString();
  }

  private String getDF152(Integer formId, Integer resId) {
    F152 f = df152.get(resId);
    StringBuilder sb = new StringBuilder();
    List<FormFields> c = dFormField.getFileds(formId);
    //
    sb.append(makeCell(c, 1 , f.getC1()));
    sb.append(makeCell(c, 2 , f.getC2()));
    sb.append(makeCell(c, 3 , f.getC3()));
    //
    return sb.toString();
  }

  private String getDF174(Integer formId, Integer resId) {
    F174 f = df174.get(resId);
    StringBuilder sb = new StringBuilder();
    List<FormFields> c = dFormField.getFileds(formId);
    //
    sb.append(makeCell(c, 1 , f.getC1 ()));
    sb.append(makeCell(c, 2 , f.getC2 ()));
    sb.append(makeCell(c, 3 , f.getC3 ()));
    sb.append(makeCell(c, 4 , f.getC4 ()));
    sb.append(makeCell(c, 5 , f.getC5 ()));
    sb.append(makeCell(c, 6 , f.getC6 ()));
    sb.append(makeCell(c, 7 , f.getC7 ()));
    sb.append(makeCell(c, 8 , f.getC8 ()));
    sb.append(makeCell(c, 9 , f.getC9 ()));
    sb.append(makeCell(c, 10, f.getC10()));
    sb.append(makeCell(c, 11, f.getC11()));
    sb.append(makeCell(c, 12, f.getC12()));
    sb.append(makeCell(c, 13, f.getC13()));
    sb.append(makeCell(c, 14, f.getC14()));
    sb.append(makeCell(c, 15, f.getC15()));
    sb.append(makeCell(c, 16, f.getC16()));
    sb.append(makeCell(c, 17, f.getC17()));
    sb.append(makeCell(c, 18, f.getC18()));
    sb.append(makeCell(c, 19, f.getC19()));
    sb.append(makeCell(c, 20, f.getC20()));
    sb.append(makeCell(c, 21, f.getC21()));
    sb.append(makeCell(c, 22, f.getC22()));
    sb.append(makeCell(c, 23, f.getC23()));
    sb.append(makeCell(c, 24, f.getC24()));
    //
    return sb.toString();
  }
}
