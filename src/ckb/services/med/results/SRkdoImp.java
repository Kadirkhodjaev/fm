package ckb.services.med.results;

import ckb.dao.admin.forms.fields.DFormField;
import ckb.dao.admin.users.DUser;
import ckb.dao.med.amb.DAmbPatientServices;
import ckb.dao.med.amb.DAmbResults;
import ckb.dao.med.amb.DAmbServiceFields;
import ckb.dao.med.kdos.forms.f1.DF1;
import ckb.dao.med.kdos.forms.f10.DF10;
import ckb.dao.med.kdos.forms.f11.DF11;
import ckb.dao.med.kdos.forms.f12.DF12;
import ckb.dao.med.kdos.forms.f120.DF120;
import ckb.dao.med.kdos.forms.f121.DF121;
import ckb.dao.med.kdos.forms.f13.DF13;
import ckb.dao.med.kdos.forms.f14.DF14;
import ckb.dao.med.kdos.forms.f15.DF15;
import ckb.dao.med.kdos.forms.f152.DF152;
import ckb.dao.med.kdos.forms.f16.DF16;
import ckb.dao.med.kdos.forms.f17.DF17;
import ckb.dao.med.kdos.forms.f174.DF174;
import ckb.dao.med.kdos.forms.f18.DF18;
import ckb.dao.med.kdos.forms.f19.DF19;
import ckb.dao.med.kdos.forms.f2.DF2;
import ckb.dao.med.kdos.forms.f20.DF20;
import ckb.dao.med.kdos.forms.f21.DF21;
import ckb.dao.med.kdos.forms.f22.DF22;
import ckb.dao.med.kdos.forms.f23.DF23;
import ckb.dao.med.kdos.forms.f24.DF24;
import ckb.dao.med.kdos.forms.f25.DF25;
import ckb.dao.med.kdos.forms.f26.DF26;
import ckb.dao.med.kdos.forms.f27.DF27;
import ckb.dao.med.kdos.forms.f28.DF28;
import ckb.dao.med.kdos.forms.f29.DF29;
import ckb.dao.med.kdos.forms.f30.DF30;
import ckb.dao.med.kdos.forms.f31.DF31;
import ckb.dao.med.kdos.forms.f32.DF32;
import ckb.dao.med.kdos.forms.f33.DF33;
import ckb.dao.med.kdos.forms.f34.DF34;
import ckb.dao.med.kdos.forms.f35.DF35;
import ckb.dao.med.kdos.forms.f36.DF36;
import ckb.dao.med.kdos.forms.f37.DF37;
import ckb.dao.med.kdos.forms.f38.DF38;
import ckb.dao.med.kdos.forms.f39.DF39;
import ckb.dao.med.kdos.forms.f4.DF4;
import ckb.dao.med.kdos.forms.f40.DF40;
import ckb.dao.med.kdos.forms.f41.DF41;
import ckb.dao.med.kdos.forms.f42.DF42;
import ckb.dao.med.kdos.forms.f43.DF43;
import ckb.dao.med.kdos.forms.f44.DF44;
import ckb.dao.med.kdos.forms.f45.DF45;
import ckb.dao.med.kdos.forms.f46.DF46;
import ckb.dao.med.kdos.forms.f47.DF47;
import ckb.dao.med.kdos.forms.f48.DF48;
import ckb.dao.med.kdos.forms.f49.DF49;
import ckb.dao.med.kdos.forms.f5.DF5;
import ckb.dao.med.kdos.forms.f54.DF54;
import ckb.dao.med.kdos.forms.f56.DF56;
import ckb.dao.med.kdos.forms.f6.DF6;
import ckb.dao.med.kdos.forms.f7.DF7;
import ckb.dao.med.kdos.forms.f8.DF8;
import ckb.dao.med.kdos.forms.f9.DF9;
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
  @Autowired DF2 df2;
  @Autowired DF5 df5;
  @Autowired DF4 df4;
  @Autowired DF6 df6;
  @Autowired DF7 df7;
  @Autowired DF8 df8;
  @Autowired DF9 df9;
  @Autowired DF10 df10;
  @Autowired DF11 df11;
  @Autowired DF12 df12;
  @Autowired DF13 df13;
  @Autowired DF14 df14;
  @Autowired DF15 df15;
  @Autowired DF16 df16;
  @Autowired DF17 df17;
  @Autowired DF18 df18;
  @Autowired DF19 df19;
  @Autowired DF21 df21;
  @Autowired DF22 df22;
  @Autowired DF23 df23;
  @Autowired DF24 df24;
  @Autowired DF27 df27;
  @Autowired DF28 df28;
  @Autowired DF29 df29;
  @Autowired DF34 df34;
  @Autowired DF37 df37;
  @Autowired DF44 df44;
  @Autowired DF26 df26;
  @Autowired DF46 df46;
  @Autowired DF47 df47;
  @Autowired DF48 df48;
  @Autowired DF49 df49;
  @Autowired DF56 df56;
  @Autowired DF20 df20;
  @Autowired DF25 df25;
  @Autowired DF30 df30;
  @Autowired DF31 df31;
  @Autowired DF32 df32;
  @Autowired DF33 df33;
  @Autowired DF35 df35;
  @Autowired DF36 df36;
  @Autowired DF38 df38;
  @Autowired DF39 df39;
  @Autowired DF40 df40;
  @Autowired DF41 df41;
  @Autowired DF42 df42;
  @Autowired DF43 df43;
  @Autowired DF45 df45;
  @Autowired DF54 df54;
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
          if (plan.getKdo().getId() == 2)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF2(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 4)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF4(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 5)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF5(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 6)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF6(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 7)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF7(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 8)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF8(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 9)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF9(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 10)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF10(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 11)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF11(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 12)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF12(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 13)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF13(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 14)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF14(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
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
          if (plan.getKdo().getId() == 18)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF18(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 19)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF19(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 20)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF20(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 21)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF21(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 22)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF22(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 23)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF23(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 24)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF24(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 25)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF25(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 26)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF26(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 27)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF27(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 28)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF28(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 29)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF29(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 30)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF30(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 31)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF31(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 32)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF32(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 33)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF33(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 34)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF34(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 35)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF35(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 36)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF36(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 37)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF37(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 38)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF38(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 39)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF39(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 40)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF40(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 41)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF41(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 42)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF42(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 43)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF43(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 44)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF44(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 45)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF45(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 46)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF46(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 47)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF47(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 48)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF48(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 49)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF49(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
          if (plan.getKdo().getId() == 54)
            list.add("<b>" + plan.getKdo().getShortName() + "</b>:" + getDF54(plan.getKdo().getFormId(), plan.getResultId()) + "<br/>");
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
    if(form == 777 || form == 888 || form == 999) {
      res.setNorma(ser.getService().getNormaFrom() + " " + ser.getService().getNormaTo());
      res.setEI(ser.getService().getEi());
      String val = r.get("c1");
      if (val == null || val.equals("") || val.equals("<br>") || val.equals("<br/>")) return null;
      res.setValue(val);
    } else if (ser.getService().getForm_id() == null) {
      List<AmbServiceFields> fieds = dAmbServiceFields.byService(ser.getService().getId());
      List<String> colName = new ArrayList<String>();
      List<String> vals = new ArrayList<String>();
      if(fieds != null && fieds.size() > 0)
        for(AmbServiceFields field: fieds) {
          colName.add(field.getName());
          vals.add(r.get("c" + field.getField()));
        }
      res.setVals(vals);
    } else if (form == 1000 || form == 1001 || form == 1002 || form == 1003 || form == 1005 || form == 1006 || form == 1007 || form == 1008 || form == 1009) {
      List<FormFields> fieds = dFormField.getFileds(ser.getService().getForm_id());
      List<FormRow> fs = new ArrayList<FormRow>();
      if(fieds != null && fieds.size() > 0)
        for(FormFields field: fieds) {
          FormRow f = new FormRow();
          f.setName(field.getField());
          f.setFieldType(field.getFieldType());
          f.setNorma(Util.nvl(field.getNormaFrom()) + " " + Util.nvl(field.getNormaTo()));
          f.setValue(r.get(field.getFieldCode()));
          f.setEI(field.getEI());
          fs.add(f);
        }
      res.setRows(fs);
    } else if (form == 81 || form == 82 || form == 83) {
      List<FormFields> fieds = dFormField.getFileds(ser.getService().getForm_id());
      List<FormRow> fs = new ArrayList<FormRow>();
      if(fieds != null && fieds.size() > 0)
        for(FormFields field: fieds) {
          FormRow f = new FormRow();
          f.setName(field.getField());
          f.setFieldType(field.getFieldType());
          f.setNorma(Util.nvl(field.getNormaFrom()) + " " + Util.nvl(field.getNormaTo()));
          f.setValue(r.get(field.getFieldCode()));
          f.setEI(field.getEI());
          fs.add(f);
        }
      res.setRows(fs);
    } /*else {
      List<FormCols> cols = dFormCol.getList("From FormCols Where form.id = " + res.getForm());
      List<String> colName = new ArrayList<String>();
      if(cols != null && cols.size() > 0)
        for(FormCols col: cols)
          colName.add(col.getName());
      res.setColName(colName);
      res.setIsei(ser.getService().getForm().isEi());
      res.setIsnorma(ser.getService().getForm().isNorma());
      List<FormColFields> colFields = dFormColField.getList("From FormColFields Where form.id = " + res.getForm());
      List<FormRow> rows = new ArrayList<FormRow>();
      for(FormColFields col: colFields) {
        FormRow row = new FormRow();
        row.setFieldType(col.getParent().getFieldType());
        row.setName(col.getParent().getField());
        row.setValue(r.get(col.getParent().getFieldCode()));
        row.setNorma(col.getParent().getNormaFrom() + " " + col.getParent().getNormaTo());
        row.setEI(col.getParent().getEI());
        if(col.getC2() != null) row.setC2(r.get(col.getC2().getFieldCode()));
        if(col.getC3() != null) row.setC2(r.get(col.getC3().getFieldCode()));
        if(col.getC4() != null) row.setC2(r.get(col.getC4().getFieldCode()));
        if(col.getC5() != null) row.setC2(r.get(col.getC5().getFieldCode()));
        if(col.getC6() != null) row.setC2(r.get(col.getC6().getFieldCode()));
        if(col.getC7() != null) row.setC2(r.get(col.getC7().getFieldCode()));
        if(col.getC8() != null) row.setC2(r.get(col.getC8().getFieldCode()));
        if(col.getC9() != null) row.setC2(r.get(col.getC9().getFieldCode()));
        rows.add(row);
      }
      res.setRows(rows);
    }*/
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
  private String getDF2(Integer formId, Integer resId) {
    F2 f = df2.get(resId);
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
    //
    return sb.toString();
  }
  private String getDF4(Integer formId, Integer resId) {
    F4 f = df4.get(resId);
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
  private String getDF5(Integer formId, Integer resId) {
    F5 f = df5.get(resId);
    StringBuilder sb = new StringBuilder();
    List<FormFields> c = dFormField.getFileds(formId);
    //
    sb.append(makeCell(c, 1 , f.getC1 ()));
    sb.append(makeCell(c, 2 , f.getC2 ()));
    sb.append(makeCell(c, 3 , f.getC3 ()));
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
  private String getDF9(Integer formId, Integer resId) {
    F9 f = df9.get(resId);
    StringBuilder sb = new StringBuilder();
    List<FormFields> c = dFormField.getFileds(formId);
    //
    sb.append(makeCell(c, 1 , f.getC1 ()));
    sb.append(makeCell(c, 2 , f.getC2 ()));
    sb.append(makeCell(c, 3 , f.getC3 ()));
    sb.append(makeCell(c, 4 , f.getC4 ()));
    sb.append(makeCell(c, 5 , f.getC5 ()));
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
  private String getDF12(Integer formId, Integer resId) {
    F12 f = df12.get(resId);
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
  private String getDF14(Integer formId, Integer resId) {
    F14 f = df14.get(resId);
    StringBuilder sb = new StringBuilder();
    List<FormFields> c = dFormField.getFileds(formId);
    //
    sb.append(makeCell(c, 1 , f.getC1 ()));
    sb.append(makeCell(c, 2 , f.getC2 ()));
    sb.append(makeCell(c, 3 , f.getC3 ()));
    sb.append(makeCell(c, 4 , f.getC4 ()));
    sb.append(makeCell(c, 5 , f.getC5 ()));
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
  private String getDF18(Integer formId, Integer resId) {
    F18 f = df18.get(resId);
    StringBuilder sb = new StringBuilder();
    List<FormFields> c = dFormField.getFileds(formId);
    //
    sb.append(makeCell(c, 1 , f.getC1 ()));
    sb.append(makeCell(c, 2 , f.getC2 ()));
    sb.append(makeCell(c, 3 , f.getC3 ()));
    //
    return sb.toString();
  }
  private String getDF19(Integer formId, Integer resId) {
    F19 f = df19.get(resId);
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
  private String getDF20(Integer formId, Integer resId) {
    F20 f = df20.get(resId);
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
    //
    return sb.toString();
  }
  private String getDF21(Integer formId, Integer resId) {
    F21 f = df21.get(resId);
    StringBuilder sb = new StringBuilder();
    List<FormFields> c = dFormField.getFileds(formId);
    //
    sb.append(makeCell(c, 1 , f.getC1 ()));
    sb.append(makeCell(c, 2 , f.getC2 ()));
    //
    return sb.toString();
  }
  private String getDF22(Integer formId, Integer resId) {
    F22 f = df22.get(resId);
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
    //
    return sb.toString();
  }
  private String getDF23(Integer formId, Integer resId) {
    F23 f = df23.get(resId);
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
    //
    return sb.toString();
  }
  private String getDF24(Integer formId, Integer resId) {
    F24 f = df24.get(resId);
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
    //
    return sb.toString();
  }
  private String getDF25(Integer formId, Integer resId) {
    F25 f = df25.get(resId);
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
    //
    return sb.toString();
  }
  private String getDF26(Integer formId, Integer resId) {
    F26 f = df26.get(resId);
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
    //
    return sb.toString();
  }
  private String getDF27(Integer formId, Integer resId) {
    F27 f = df27.get(resId);
    StringBuilder sb = new StringBuilder();
    List<FormFields> c = dFormField.getFileds(formId);
    //
    sb.append(makeCell(c, 1 , f.getC1 ()));
    sb.append(makeCell(c, 2 , f.getC2 ()));
    //
    return sb.toString();
  }
  private String getDF28(Integer formId, Integer resId) {
    F28 f = df28.get(resId);
    StringBuilder sb = new StringBuilder();
    List<FormFields> c = dFormField.getFileds(formId);
    //
    sb.append(makeCell(c, 1 , f.getC1 ()));
    sb.append(makeCell(c, 2 , f.getC2 ()));
    sb.append(makeCell(c, 3 , f.getC3 ()));
    sb.append(makeCell(c, 4 , f.getC4 ()));
    //
    return sb.toString();
  }
  private String getDF29(Integer formId, Integer resId) {
    F29 f = df29.get(resId);
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
    //
    return sb.toString();
  }
  private String getDF30(Integer formId, Integer resId) {
    F30 f = df30.get(resId);
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
    sb.append(makeCell(c, 30, f.getC30()));
    sb.append(makeCell(c, 31, f.getC31()));
    sb.append(makeCell(c, 32, f.getC32()));
    sb.append(makeCell(c, 33, f.getC33()));
    sb.append(makeCell(c, 34, f.getC34()));
    sb.append(makeCell(c, 35, f.getC35()));
    sb.append(makeCell(c, 36, f.getC36()));
    sb.append(makeCell(c, 37, f.getC37()));
    sb.append(makeCell(c, 38, f.getC38()));
    sb.append(makeCell(c, 39, f.getC39()));
    sb.append(makeCell(c, 40, f.getC40()));
    sb.append(makeCell(c, 41, f.getC41()));
    sb.append(makeCell(c, 42, f.getC42()));
    sb.append(makeCell(c, 43, f.getC43()));
    sb.append(makeCell(c, 44, f.getC44()));
    sb.append(makeCell(c, 45, f.getC45()));
    sb.append(makeCell(c, 46, f.getC46()));
    sb.append(makeCell(c, 47, f.getC47()));
    sb.append(makeCell(c, 48, f.getC48()));
    sb.append(makeCell(c, 49, f.getC49()));
    sb.append(makeCell(c, 50, f.getC50()));
    sb.append(makeCell(c, 51, f.getC51()));
    sb.append(makeCell(c, 52, f.getC52()));
    //
    return sb.toString();
  }
  private String getDF31(Integer formId, Integer resId) {
    F31 f = df31.get(resId);
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
  private String getDF32(Integer formId, Integer resId) {
    F32 f = df32.get(resId);
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
    //
    return sb.toString();
  }
  private String getDF33(Integer formId, Integer resId) {
    F33 f = df33.get(resId);
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
    sb.append(makeCell(c, 30, f.getC30()));
    sb.append(makeCell(c, 31, f.getC31()));
    sb.append(makeCell(c, 32, f.getC32()));
    sb.append(makeCell(c, 33, f.getC33()));
    sb.append(makeCell(c, 34, f.getC34()));
    sb.append(makeCell(c, 35, f.getC35()));
    //
    return sb.toString();
  }
  private String getDF34(Integer formId, Integer resId) {
    F34 f = df34.get(resId);
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
    //
    return sb.toString();
  }
  private String getDF35(Integer formId, Integer resId) {
    F35 f = df35.get(resId);
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
    sb.append(makeCell(c, 30, f.getC30()));
    sb.append(makeCell(c, 31, f.getC31()));
    sb.append(makeCell(c, 32, f.getC32()));
    sb.append(makeCell(c, 33, f.getC33()));
    sb.append(makeCell(c, 34, f.getC34()));
    sb.append(makeCell(c, 35, f.getC35()));
    sb.append(makeCell(c, 36, f.getC36()));
    sb.append(makeCell(c, 37, f.getC37()));
    sb.append(makeCell(c, 38, f.getC38()));
    sb.append(makeCell(c, 39, f.getC39()));
    sb.append(makeCell(c, 40, f.getC40()));
    sb.append(makeCell(c, 41, f.getC41()));
    sb.append(makeCell(c, 42, f.getC42()));
    sb.append(makeCell(c, 43, f.getC43()));
    sb.append(makeCell(c, 44, f.getC44()));
    sb.append(makeCell(c, 45, f.getC45()));
    sb.append(makeCell(c, 46, f.getC46()));
    sb.append(makeCell(c, 47, f.getC47()));
    //
    return sb.toString();
  }
  private String getDF36(Integer formId, Integer resId) {
    F36 f = df36.get(resId);
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
  private String getDF37(Integer formId, Integer resId) {
    F37 f = df37.get(resId);
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
  private String getDF38(Integer formId, Integer resId) {
    F38 f = df38.get(resId);
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
    //
    return sb.toString();
  }
  private String getDF39(Integer formId, Integer resId) {
    F39 f = df39.get(resId);
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
    sb.append(makeCell(c, 30, f.getC30()));
    sb.append(makeCell(c, 31, f.getC31()));
    sb.append(makeCell(c, 32, f.getC32()));
    sb.append(makeCell(c, 33, f.getC33()));
    //
    return sb.toString();
  }
  private String getDF40(Integer formId, Integer resId) {
    F40 f = df40.get(resId);
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
    sb.append(makeCell(c, 30, f.getC30()));
    sb.append(makeCell(c, 31, f.getC31()));
    sb.append(makeCell(c, 32, f.getC32()));
    sb.append(makeCell(c, 33, f.getC33()));
    sb.append(makeCell(c, 34, f.getC34()));
    sb.append(makeCell(c, 35, f.getC35()));
    sb.append(makeCell(c, 36, f.getC36()));
    sb.append(makeCell(c, 37, f.getC37()));
    sb.append(makeCell(c, 38, f.getC38()));
    sb.append(makeCell(c, 39, f.getC39()));
    sb.append(makeCell(c, 40, f.getC40()));
    sb.append(makeCell(c, 41, f.getC41()));
    //
    return sb.toString();
  }
  private String getDF41(Integer formId, Integer resId) {
    F41 f = df41.get(resId);
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
    sb.append(makeCell(c, 30, f.getC30()));
    sb.append(makeCell(c, 31, f.getC31()));
    sb.append(makeCell(c, 32, f.getC32()));
    sb.append(makeCell(c, 33, f.getC33()));
    sb.append(makeCell(c, 34, f.getC34()));
    sb.append(makeCell(c, 35, f.getC35()));
    sb.append(makeCell(c, 36, f.getC36()));
    sb.append(makeCell(c, 37, f.getC37()));
    //
    return sb.toString();
  }
  private String getDF42(Integer formId, Integer resId) {
    F42 f = df42.get(resId);
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
    sb.append(makeCell(c, 30, f.getC30()));
    sb.append(makeCell(c, 31, f.getC31()));
    sb.append(makeCell(c, 32, f.getC32()));
    sb.append(makeCell(c, 33, f.getC33()));
    sb.append(makeCell(c, 34, f.getC34()));
    sb.append(makeCell(c, 35, f.getC35()));
    sb.append(makeCell(c, 36, f.getC36()));
    sb.append(makeCell(c, 37, f.getC37()));
    sb.append(makeCell(c, 38, f.getC38()));
    sb.append(makeCell(c, 39, f.getC39()));
    sb.append(makeCell(c, 40, f.getC40()));
    sb.append(makeCell(c, 41, f.getC41()));
    //
    return sb.toString();
  }
  private String getDF43(Integer formId, Integer resId) {
    F43 f = df43.get(resId);
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
    sb.append(makeCell(c, 30, f.getC30()));
    sb.append(makeCell(c, 31, f.getC31()));
    sb.append(makeCell(c, 32, f.getC32()));
    sb.append(makeCell(c, 33, f.getC33()));
    sb.append(makeCell(c, 34, f.getC34()));
    sb.append(makeCell(c, 35, f.getC35()));
    sb.append(makeCell(c, 36, f.getC36()));
    sb.append(makeCell(c, 37, f.getC37()));
    sb.append(makeCell(c, 38, f.getC38()));
    sb.append(makeCell(c, 39, f.getC39()));
    sb.append(makeCell(c, 40, f.getC40()));
    sb.append(makeCell(c, 41, f.getC41()));
    sb.append(makeCell(c, 42, f.getC42()));
    sb.append(makeCell(c, 43, f.getC43()));
    sb.append(makeCell(c, 44, f.getC44()));
    //
    return sb.toString();
  }
  private String getDF44(Integer formId, Integer resId) {
    F44 f = df44.get(resId);
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
    //
    return sb.toString();
  }
  private String getDF45(Integer formId, Integer resId) {
    F45 f = df45.get(resId);
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
    sb.append(makeCell(c, 30, f.getC30()));
    sb.append(makeCell(c, 31, f.getC31()));
    sb.append(makeCell(c, 32, f.getC32()));
    sb.append(makeCell(c, 33, f.getC33()));
    sb.append(makeCell(c, 34, f.getC34()));
    sb.append(makeCell(c, 35, f.getC35()));
    sb.append(makeCell(c, 36, f.getC36()));
    sb.append(makeCell(c, 37, f.getC37()));
    sb.append(makeCell(c, 38, f.getC38()));
    sb.append(makeCell(c, 39, f.getC39()));
    sb.append(makeCell(c, 40, f.getC40()));
    //
    return sb.toString();
  }
  private String getDF46(Integer formId, Integer resId) {
    F46 f = df46.get(resId);
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
    //
    return sb.toString();
  }
  private String getDF47(Integer formId, Integer resId) {
    F47 f = df47.get(resId);
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
  private String getDF48(Integer formId, Integer resId) {
    F48 f = df48.get(resId);
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
  private String getDF49(Integer formId, Integer resId) {
    F49 f = df49.get(resId);
    StringBuilder sb = new StringBuilder();
    List<FormFields> c = dFormField.getFileds(formId);
    //
    sb.append(makeCell(c, 1 , f.getC1 ()));
    sb.append(makeCell(c, 2 , f.getC2 ()));
    sb.append(makeCell(c, 3 , f.getC3 ()));
    sb.append(makeCell(c, 4 , f.getC4 ()));
    //
    return sb.toString();
  }
  private String getDF54(Integer formId, Integer resId) {
    F54 f = df54.get(resId);
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
