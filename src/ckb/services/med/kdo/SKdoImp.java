package ckb.services.med.kdo;

import ckb.dao.admin.forms.DForm;
import ckb.dao.admin.users.DUser;
import ckb.dao.med.kdos.DKdoResult;
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
import ckb.dao.med.lv.coul.DLvCoul;
import ckb.dao.med.lv.garmon.DLvGarmon;
import ckb.dao.med.lv.plan.DLvPlan;
import ckb.dao.med.lv.torch.DLvTorch;
import ckb.dao.med.patient.DPatient;
import ckb.domains.admin.Forms;
import ckb.domains.admin.KdoTypes;
import ckb.domains.admin.Kdos;
import ckb.domains.med.kdo.*;
import ckb.domains.med.lv.LvPlans;
import ckb.domains.med.patient.Patients;
import ckb.models.ObjList;
import ckb.services.admin.form.SForm;
import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.Req;
import ckb.utils.Util;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 18.10.16
 * Time: 21:47
 * To change this template use File | Settings | File Templates.
 */
public class SKdoImp implements SKdo {

  @Autowired DUser dUser;
  @Autowired DLvPlan dLvPlan;
  @Autowired SForm sForm;
  @Autowired DPatient dPatient;
  @Autowired DLvBio dlvBio;
  @Autowired DLvGarmon dLvGarmon;
  @Autowired DLvTorch dLvTorch;
  @Autowired DLvCoul dLvCoul;
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
  @Autowired DForm dForm;
  @Autowired DKdoResult dKdoResult;

  @Override
  public String getKdoTypeIds(int userId) {
    String ids = "";
    for(KdoTypes t : dUser.getKdoTypes(userId))
      ids += t.getId() + ",";
    return ids + "0";
  }

  @Override
  public List<ObjList> getPatientPlans(int id, Session session) {
    List<LvPlans> plans = dLvPlan.getByPatientId(id);
    List<ObjList> list = new ArrayList<ObjList>();
    for(LvPlans p : plans) {
      if(session.getKdoTypesIds().contains(p.getKdoType().getId())) {
        ObjList l = new ObjList();
        l.setC1(p.getId().toString());
        l.setC2(p.getKdo().getFormId() == 999 || p.getKdo().getFormId() == 889 || p.getKdo().getFormId() == 888 || p.getKdo().getFormId() == 777 ? p.getKdo().getFormId() + "" : p.getKdo().getId().toString());
        l.setC3(p.getKdo().getName());
        l.setC4(Util.dateToString(p.getActDate()));
        l.setC5(p.getComment());
        l.setC6(p.getResultId().equals(0) ? "red" : ("Y".equals(p.getDone()) ? "yellow" : "green"));
        l.setC10(p.getPrice() != null && p.getPrice() > 0 ? p.getCashState() : "FREE");
        //
        list.add(l);
      }
    }
    return list;
  }

  @Override
  public void createKdoModel(int planId, Model model) {
    StringBuffer b = new StringBuffer();
    LvPlans plan = dLvPlan.get(planId);
    Patients p = dPatient.get(plan.getPatientId());
    Forms form = dForm.get(plan.getKdo().getFormId());
    b.append("<table width='100%' style='font-size:12px'>");
    b.append("<tr>");
    b.append("<td align=left style='padding:5px 10px'><b>ФИШ:</b><td align=left>").append(Util.nvl(p.getSurname())).append(" ").append(Util.nvl(p.getName())).append(" ").append(Util.nvl(p.getMiddlename()));
    b.append("<td align=left><b>Тугилган йили:</b><td align=left>").append(p.getBirthyear() != null ? p.getBirthyear() : "");
    b.append("<tr>");
    b.append("<td align=left style='padding:5px 10px'><b>Булим:</b><td align=left>").append(p.getDept() != null ? p.getDept().getName() : "");
    b.append("<td align=left><b>Хона №:</b><td align=left>").append(p.getRoom() != null ? p.getRoom().getName() + " - " + p.getRoom().getRoomType().getName() : p.getPalata());
    b.append("<tr>");
    b.append("<td align=left style='padding:5px 10px'><b>Жинси:</b><td align=left>").append(p.getSex() != null ? p.getSex().getName() : "");
    b.append("<td align=left><b>Ёши:</b><td align=left>").append(p.getBirthyear() != null ? 1900 + new Date().getYear() - p.getBirthyear() : "");
    b.append("<tr>");
    b.append("<td align=left style='padding:5px 10px'><b>Огирлиги:</b><td align=left>").append(Util.nvl(p.getVes()));
    b.append("<td align=left><b>Буйи:</b><td align=left>").append(Util.nvl(p.getRost()));
    b.append("<tr>");
    b.append("<td align=left style='padding:5px 10px'><b>Муолажа санаси:</b><td align=left>");
    b.append("<td align=left colspan=3>").append(Util.dateTimeToString(plan.getResDate()));
    b.append("</table>");
    model.addAttribute("patFio", Util.nvl(p.getSurname()) + " " + Util.nvl(p.getName()) + " " + Util.nvl(p.getMiddlename()));
    model.addAttribute("patInfo", b.toString());
    if(plan.getKdo().getId() == 17 && plan.getId() <= 27056) {
      Kdos kdo = plan.getKdo();
      kdo.setFormId(999);
      plan.setKdo(kdo);
    }
    model.addAttribute("plan", plan);
    model.addAttribute("conf_user_fio", plan.getConfUser() != null ? dUser.get(plan.getConfUser()).getFio() : "__________________________________");
    model.addAttribute("form", dForm.get(plan.getKdo().getFormId()));
    model.addAttribute("data", getFormJson(plan.getKdo(), plan.getResultId()));
    if(form.getResult() != null && !"".equals(form.getResult())) {
      model.addAttribute("f", dKdoResult.get(plan.getResultId()));
    }
    if(plan.getKdo().getFormId() == 999 || plan.getKdo().getFormId() == 889 || plan.getKdo().getFormId() == 888 || plan.getKdo().getFormId() == 777 || plan.getKdo().getFormId() == 1011) {
      model.addAttribute("f", df999.get(plan.getResultId()));
      model.addAttribute("fnorma", plan.getKdo().getNorma());
      model.addAttribute("fei", plan.getKdo().getEi());
    } else {
      if (plan.getKdo().getId().equals(1))
        model.addAttribute("f", df1.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(2))
        model.addAttribute("f", df2.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(4))
        model.addAttribute("f", df4.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(5))
        model.addAttribute("f", df5.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(6))
        model.addAttribute("f", df6.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(7))
        model.addAttribute("f", df7.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(8))
        model.addAttribute("f", df8.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(9))
        model.addAttribute("f", df9.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(10))
        model.addAttribute("f", df10.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(11))
        model.addAttribute("f", df11.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(12))
        model.addAttribute("f", df12.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(13)) {
        model.addAttribute("bio", dlvBio.getByPlan(planId));
        model.addAttribute("f", df13.get(plan.getResultId()));
      }
      if (plan.getKdo().getId().equals(14))
        model.addAttribute("f", df14.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(15))
        model.addAttribute("f", df15.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(16))
        model.addAttribute("f", df16.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(17))
        model.addAttribute("f", df17.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(18))
        model.addAttribute("f", df18.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(19))
        model.addAttribute("f", df19.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(20))
        model.addAttribute("f", df20.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(21))
        model.addAttribute("f", df21.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(22))
        model.addAttribute("f", df22.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(23))
        model.addAttribute("f", df23.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(24))
        model.addAttribute("f", df24.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(25))
        model.addAttribute("f", df25.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(26))
        model.addAttribute("f", df26.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(27))
        model.addAttribute("f", df27.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(28))
        model.addAttribute("f", df28.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(29))
        model.addAttribute("f", df29.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(30))
        model.addAttribute("f", df30.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(31))
        model.addAttribute("f", df31.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(32))
        model.addAttribute("f", df32.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(33))
        model.addAttribute("f", df33.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(34))
        model.addAttribute("f", df34.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(35))
        model.addAttribute("f", df35.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(37))
        model.addAttribute("f", df37.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(36))
        model.addAttribute("f", df36.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(38))
        model.addAttribute("f", df38.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(39))
        model.addAttribute("f", df39.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(40))
        model.addAttribute("f", df40.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(41))
        model.addAttribute("f", df41.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(42))
        model.addAttribute("f", df42.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(43))
        model.addAttribute("f", df43.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(44))
        model.addAttribute("f", df44.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(45))
        model.addAttribute("f", df45.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(46))
        model.addAttribute("f", df46.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(47))
        model.addAttribute("f", df47.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(48))
        model.addAttribute("f", df48.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(49))
        model.addAttribute("f", df49.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(54))
        model.addAttribute("f", df54.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(56)) {
        model.addAttribute("bio", dLvCoul.getByPlan(planId));
        model.addAttribute("f", df56.get(plan.getResultId()));
      }
      if (plan.getKdo().getId().equals(120)) {
        model.addAttribute("bio", dLvGarmon.getByPlan(planId));
        model.addAttribute("f", df120.get(plan.getResultId()));
      }
      if (plan.getKdo().getId().equals(121)) {
        model.addAttribute("bio", dLvTorch.getByPlan(planId));
        model.addAttribute("f", df121.get(plan.getResultId()));
      }
      if (plan.getKdo().getId().equals(152))
        model.addAttribute("f", df152.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(174))
        model.addAttribute("f", df174.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(153)) {
        model.addAttribute("bio", dlvBio.getByPlan(planId));
        model.addAttribute("f", df13.get(plan.getResultId()));
      }
    }
    //
    sForm.createFields(model, plan.getKdo().getFormId(), plan.getKdo());
  }

  private String getFormJson(Kdos kdo, Integer id) {
    Integer kdoId = kdo.getId();
    JSONObject json = new JSONObject();
    try {
      Forms form = dForm.get(kdo.getFormId());
      if(form.getResult() != null && !"".equals(form.getResult())) {
        KdoResults f = dKdoResult.get(id);
        if(f != null) {
          json.put("c1", f.getC1());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
          json.put("c10", f.getC10());
          json.put("c11", f.getC11());
          json.put("c12", f.getC12());
          json.put("c13", f.getC13());
          json.put("c14", f.getC14());
          json.put("c15", f.getC15());
          json.put("c16", f.getC16());
          json.put("c17", f.getC17());
          json.put("c18", f.getC18());
          json.put("c19", f.getC19());
          json.put("c20", f.getC20());
          json.put("c21", f.getC21());
          json.put("c22", f.getC22());
          json.put("c23", f.getC23());
          json.put("c24", f.getC24());
          json.put("c25", f.getC25());
          json.put("c26", f.getC26());
          json.put("c27", f.getC27());
          json.put("c28", f.getC28());
          json.put("c29", f.getC29());
          json.put("c30", f.getC30());
          json.put("c31", f.getC31());
          json.put("c32", f.getC32());
          json.put("c33", f.getC33());
          json.put("c34", f.getC34());
          json.put("c35", f.getC35());
          json.put("c36", f.getC36());
          json.put("c37", f.getC37());
          json.put("c38", f.getC38());
          json.put("c39", f.getC39());
          json.put("c40", f.getC40());
          json.put("c41", f.getC41());
          json.put("c42", f.getC42());
          json.put("c43", f.getC43());
          json.put("c44", f.getC44());
          json.put("c45", f.getC45());
          json.put("c46", f.getC46());
          json.put("c47", f.getC47());
          json.put("c48", f.getC48());
          json.put("c49", f.getC49());
          json.put("c50", f.getC50());
          json.put("c51", f.getC51());
          json.put("c52", f.getC52());
          json.put("c53", f.getC53());
          json.put("c54", f.getC54());
          json.put("c55", f.getC55());
          json.put("c56", f.getC56());
          json.put("c57", f.getC57());
          json.put("c58", f.getC58());
          json.put("c59", f.getC59());
          json.put("c60", f.getC60());
        }
      }
      if(kdoId.equals(1)){
        F1 f = df1.get(id);
        if(f != null) {
          json.put("c1", f.getC1());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
          json.put("c10", f.getC10());
        }
      }
      if(kdoId.equals(2)){
        F2 f = df2.get(id);
        if(f != null) {
          json.put("c1", f.getC1());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
        }
      }
      if(kdoId.equals(4)){
        F4 f = df4.get(id);
        if(f != null) {
          json.put("c1", f.getC1());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
          json.put("c10", f.getC10());
          json.put("c11", f.getC11());
          json.put("c12", f.getC12());
          json.put("c13", f.getC13());
          json.put("c14", f.getC14());
          json.put("c15", f.getC15());
          json.put("c16", f.getC16());
          json.put("c17", f.getC17());
        }
      }
      if(kdoId.equals(5)){
        F5 f = df5.get(id);
        if(f != null) {
          json.put("c1", f.getC1());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
        }
      }
      if(kdoId.equals(6)){
        F6 f = df6.get(id);
        if(f != null) {
          json.put("c1", f.getC1());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
          json.put("c10", f.getC10());
          json.put("c11", f.getC11());
          json.put("c12", f.getC12());
          json.put("c13", f.getC13());
          json.put("c14", f.getC14());
          json.put("c15", f.getC15());
          json.put("c16", f.getC16());
          json.put("c17", f.getC17());
        }
      }
      if(kdoId.equals(7)){
        F7 f = df7.get(id);
        if(f != null) {
          json.put("c1", f.getC1());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
          json.put("c10", f.getC10());
          json.put("c11", f.getC11());
          json.put("c12", f.getC12());
          json.put("c13", f.getC13());
          json.put("c14", f.getC14());
          json.put("c15", f.getC15());
        }
      }
      if(kdoId.equals(8)){
        F8 f = df8.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
          json.put("c10", f.getC10());
          json.put("c11", f.getC11());
          json.put("c12", f.getC12());
          json.put("c13", f.getC13());
          json.put("c14", f.getC14());
          json.put("c15", f.getC15());
          json.put("c16", f.getC16());
          json.put("c17", f.getC17());
          json.put("c18", f.getC18());
        }
      }
      if(kdoId.equals(9)){
        F9 f = df9.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
        }
      }
      if(kdoId.equals(10)){
        F10 f = df10.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
          json.put("c10", f.getC10());
          json.put("c11", f.getC11());
          json.put("c12", f.getC12());
          json.put("c13", f.getC13());
          json.put("c14", f.getC14());
          json.put("c15", f.getC15());
          json.put("c16", f.getC16());
          json.put("c17", f.getC17());
          json.put("c18", f.getC18());
          json.put("c19", f.getC19());
          json.put("c20", f.getC20());
          json.put("c21", f.getC21());
          json.put("c22", f.getC22());
          json.put("c23", f.getC23());
          json.put("c24", f.getC24());
          json.put("c25", f.getC25());
          json.put("c26", f.getC26());
          json.put("c27", f.getC27());
          json.put("c28", f.getC28());
          json.put("c29", f.getC29());
        }
      }
      if(kdoId.equals(11)){
        F11 f = df11.get(id);
        if(f != null) {
          json.put("c1", f.getC1());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
        }
      }
      if(kdoId.equals(12)){
        F12 f = df12.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
          json.put("c10", f.getC10());
          json.put("c11", f.getC11());
          json.put("c12", f.getC12());
          json.put("c13", f.getC13());
          json.put("c14", f.getC14());
          json.put("c15", f.getC15());
        }
      }
      if(kdoId.equals(13)){
        F13 f = df13.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
          json.put("c10", f.getC10());
          json.put("c11", f.getC11());
          json.put("c12", f.getC12());
          json.put("c13", f.getC13());
          json.put("c14", f.getC14());
          json.put("c15", f.getC15());
          json.put("c16", f.getC16());
          json.put("c17", f.getC17());
          json.put("c18", f.getC18());
          json.put("c19", f.getC19());
          json.put("c20", f.getC20());
          json.put("c21", f.getC21());
          json.put("c22", f.getC22());
          json.put("c23", f.getC23());
          json.put("c24", f.getC24());
          json.put("c25", f.getC25());
          json.put("c26", f.getC26());
          json.put("c27", f.getC27());
          json.put("c28", f.getC28());
          json.put("c29", f.getC29());
        }
      }
      if(kdoId.equals(14)){
        F14 f = df14.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
        }
      }
      if(kdoId.equals(15)){
        F15 f = df15.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
        }
      }
      if(kdoId.equals(16)){
        F16 f = df16.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
        }
      }
      if(kdoId.equals(17)){
        F17 f = df17.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
        }
      }
      if(kdoId.equals(18)){
        F18 f = df18.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
        }
      }
      if(kdoId.equals(19)){
        F19 f = df19.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
        }
      }
      if(kdoId.equals(20)){
        F20 f = df20.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
          json.put("c10", f.getC10());
          json.put("c11", f.getC11());
          json.put("c12", f.getC12());
          json.put("c13", f.getC13());
          json.put("c14", f.getC14());
          json.put("c15", f.getC15());
          json.put("c16", f.getC16());
          json.put("c17", f.getC17());
          json.put("c18", f.getC18());
          json.put("c19", f.getC19());
          json.put("c20", f.getC20());
        }
      }
      if(kdoId.equals(21)){
        F21 f = df21.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
        }
      }
      if(kdoId.equals(22)){
        F22 f = df22.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
        }
      }
      if(kdoId.equals(23)){
        F23 f = df23.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
        }
      }
      if(kdoId.equals(24)){
        F24 f = df24.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
          json.put("c10", f.getC10());
          json.put("c11", f.getC11());
          json.put("c12", f.getC12());
        }
      }
      if(kdoId.equals(25)){
        F25 f = df25.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
          json.put("c10", f.getC10());
          json.put("c11", f.getC11());
          json.put("c12", f.getC12());
          json.put("c13", f.getC13());
        }
      }
      if(kdoId.equals(26)){
        F26 f = df26.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
          json.put("c10", f.getC10());
          json.put("c11", f.getC11());
          json.put("c12", f.getC12());
        }
      }
      if(kdoId.equals(27)){
        F27 f = df27.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
        }
      }
      if(kdoId.equals(29)){
        F29 f = df29.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
        }
      }
      if(kdoId.equals(30)){
        F30 f = df30.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
          json.put("c10", f.getC10());
          json.put("c11", f.getC11());
          json.put("c12", f.getC12());
          json.put("c13", f.getC13());
          json.put("c14", f.getC14());
          json.put("c15", f.getC15());
          json.put("c16", f.getC16());
          json.put("c17", f.getC17());
          json.put("c18", f.getC18());
          json.put("c19", f.getC19());
          json.put("c20", f.getC20());
          json.put("c21", f.getC21());
          json.put("c22", f.getC22());
          json.put("c23", f.getC23());
          json.put("c24", f.getC24());
          json.put("c25", f.getC25());
          json.put("c26", f.getC26());
          json.put("c27", f.getC27());
          json.put("c28", f.getC28());
          json.put("c29", f.getC29());
          json.put("c30", f.getC30());
          json.put("c31", f.getC31());
          json.put("c32", f.getC32());
          json.put("c33", f.getC33());
          json.put("c34", f.getC34());
          json.put("c35", f.getC35());
          json.put("c36", f.getC36());
          json.put("c37", f.getC37());
          json.put("c38", f.getC38());
          json.put("c39", f.getC39());
          json.put("c40", f.getC40());
          json.put("c41", f.getC41());
          json.put("c42", f.getC42());
          json.put("c43", f.getC43());
          json.put("c44", f.getC44());
          json.put("c45", f.getC45());
          json.put("c46", f.getC46());
          json.put("c47", f.getC47());
          json.put("c48", f.getC48());
          json.put("c49", f.getC49());
          json.put("c50", f.getC50());
          json.put("c51", f.getC51());
          json.put("c52", f.getC52());
        }
      }
      if(kdoId.equals(31)){
        F31 f = df31.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
          json.put("c10", f.getC10());
          json.put("c11", f.getC11());
          json.put("c12", f.getC12());
          json.put("c13", f.getC13());
          json.put("c14", f.getC14());
          json.put("c15", f.getC15());
          json.put("c16", f.getC16());
          json.put("c17", f.getC17());
        }
      }
      if(kdoId.equals(32)){
        F32 f = df32.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
          json.put("c10", f.getC10());
          json.put("c11", f.getC11());
          json.put("c12", f.getC12());
          json.put("c13", f.getC13());
          json.put("c14", f.getC14());
          json.put("c15", f.getC15());
          json.put("c16", f.getC16());
          json.put("c17", f.getC17());
          json.put("c18", f.getC18());
          json.put("c19", f.getC19());
          json.put("c20", f.getC20());
          json.put("c21", f.getC21());
        }
      }
      if(kdoId.equals(33)){
        F33 f = df33.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
          json.put("c10", f.getC10());
          json.put("c11", f.getC11());
          json.put("c12", f.getC12());
          json.put("c13", f.getC13());
          json.put("c14", f.getC14());
          json.put("c15", f.getC15());
          json.put("c16", f.getC16());
          json.put("c17", f.getC17());
          json.put("c18", f.getC18());
          json.put("c19", f.getC19());
          json.put("c25", f.getC25());
          json.put("c21", f.getC21());
          json.put("c22", f.getC22());
          json.put("c23", f.getC23());
          json.put("c24", f.getC24());
          json.put("c25", f.getC25());
          json.put("c26", f.getC26());
          json.put("c27", f.getC27());
          json.put("c28", f.getC28());
          json.put("c29", f.getC29());
          json.put("c30", f.getC30());
          json.put("c31", f.getC31());
          json.put("c32", f.getC32());
          json.put("c33", f.getC33());
          json.put("c34", f.getC34());
          json.put("c35", f.getC35());
        }
      }
      if(kdoId.equals(34)){
        F34 f = df34.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
          json.put("c10", f.getC10());
          json.put("c11", f.getC11());
          json.put("c12", f.getC12());
          json.put("c13", f.getC13());
          json.put("c14", f.getC14());
        }
      }
      if(kdoId.equals(35)){
        F35 f = df35.get(id);
        if(f != null) {
          json.put("c1", f.getC1());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
          json.put("c10", f.getC10());
          json.put("c11", f.getC11());
          json.put("c12", f.getC12());
          json.put("c13", f.getC13());
          json.put("c14", f.getC14());
          json.put("c15", f.getC15());
          json.put("c16", f.getC16());
          json.put("c17", f.getC17());
          json.put("c18", f.getC18());
          json.put("c19", f.getC19());
          json.put("c20", f.getC20());
          json.put("c21", f.getC21());
          json.put("c22", f.getC22());
          json.put("c23", f.getC23());
          json.put("c24", f.getC24());
          json.put("c25", f.getC25());
          json.put("c26", f.getC26());
          json.put("c27", f.getC27());
          json.put("c28", f.getC28());
          json.put("c29", f.getC29());
          json.put("c30", f.getC30());
          json.put("c31", f.getC31());
          json.put("c32", f.getC32());
          json.put("c33", f.getC33());
          json.put("c34", f.getC34());
          json.put("c35", f.getC35());
          json.put("c36", f.getC36());
          json.put("c37", f.getC37());
          json.put("c38", f.getC38());
          json.put("c39", f.getC39());
          json.put("c40", f.getC40());
          json.put("c41", f.getC41());
          json.put("c42", f.getC42());
          json.put("c43", f.getC43());
          json.put("c44", f.getC44());
          json.put("c45", f.getC45());
          json.put("c46", f.getC46());
          json.put("c47", f.getC47());
        }
      }
      if(kdoId.equals(36)){
        F36 f = df36.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
          json.put("c10", f.getC10());
          json.put("c11", f.getC11());
          json.put("c12", f.getC12());
          json.put("c13", f.getC13());
          json.put("c14", f.getC14());
          json.put("c15", f.getC15());
          json.put("c16", f.getC16());
          json.put("c17", f.getC17());
          json.put("c18", f.getC18());
          json.put("c19", f.getC19());
          json.put("c20", f.getC20());
          json.put("c21", f.getC21());
          json.put("c22", f.getC22());
          json.put("c23", f.getC23());
          json.put("c24", f.getC24());
        }
      }
      if(kdoId.equals(37)){
        F37 f = df37.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
        }
      }
      if(kdoId.equals(38)){
        F38 f = df38.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
          json.put("c10", f.getC10());
          json.put("c11", f.getC11());
          json.put("c12", f.getC12());
          json.put("c13", f.getC13());
          json.put("c14", f.getC14());
          json.put("c15", f.getC15());
          json.put("c16", f.getC16());
          json.put("c17", f.getC17());
          json.put("c18", f.getC18());
          json.put("c19", f.getC19());
        }
      }
      if(kdoId.equals(39)){
        F39 f = df39.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
          json.put("c10", f.getC10());
          json.put("c11", f.getC11());
          json.put("c12", f.getC12());
          json.put("c13", f.getC13());
          json.put("c14", f.getC14());
          json.put("c15", f.getC15());
          json.put("c16", f.getC16());
          json.put("c17", f.getC17());
          json.put("c18", f.getC18());
          json.put("c19", f.getC19());
          json.put("c20", f.getC20());
          json.put("c21", f.getC21());
          json.put("c22", f.getC22());
          json.put("c23", f.getC23());
          json.put("c24", f.getC24());
          json.put("c25", f.getC25());
          json.put("c26", f.getC26());
          json.put("c27", f.getC27());
          json.put("c28", f.getC28());
          json.put("c29", f.getC29());
          json.put("c30", f.getC30());
          json.put("c31", f.getC31());
          json.put("c32", f.getC32());
          json.put("c33", f.getC33());
        }
      }
      if(kdoId.equals(40)){
        F40 f = df40.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
          json.put("c10", f.getC10());
          json.put("c11", f.getC11());
          json.put("c12", f.getC12());
          json.put("c13", f.getC13());
          json.put("c14", f.getC14());
          json.put("c15", f.getC15());
          json.put("c16", f.getC16());
          json.put("c17", f.getC17());
          json.put("c18", f.getC18());
          json.put("c19", f.getC19());
          json.put("c20", f.getC20());
          json.put("c21", f.getC21());
          json.put("c22", f.getC22());
          json.put("c23", f.getC23());
          json.put("c24", f.getC24());
          json.put("c25", f.getC25());
          json.put("c26", f.getC26());
          json.put("c27", f.getC27());
          json.put("c28", f.getC28());
          json.put("c29", f.getC29());
          json.put("c30", f.getC30());
          json.put("c31", f.getC31());
          json.put("c32", f.getC32());
          json.put("c33", f.getC33());
          json.put("c34", f.getC34());
          json.put("c35", f.getC35());
          json.put("c36", f.getC36());
          json.put("c37", f.getC37());
          json.put("c38", f.getC38());
          json.put("c39", f.getC39());
          json.put("c40", f.getC40());
          json.put("c41", f.getC41());
        }
      }
      if(kdoId.equals(41)){
        F41 f = df41.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
          json.put("c10", f.getC10());
          json.put("c11", f.getC11());
          json.put("c12", f.getC12());
          json.put("c13", f.getC13());
          json.put("c14", f.getC14());
          json.put("c15", f.getC15());
          json.put("c16", f.getC16());
          json.put("c17", f.getC17());
          json.put("c18", f.getC18());
          json.put("c19", f.getC19());
          json.put("c20", f.getC20());
          json.put("c21", f.getC21());
          json.put("c22", f.getC22());
          json.put("c23", f.getC23());
          json.put("c24", f.getC24());
          json.put("c25", f.getC25());
          json.put("c26", f.getC26());
          json.put("c27", f.getC27());
          json.put("c28", f.getC28());
          json.put("c29", f.getC29());
          json.put("c30", f.getC30());
          json.put("c31", f.getC31());
          json.put("c32", f.getC32());
          json.put("c33", f.getC33());
          json.put("c34", f.getC34());
          json.put("c35", f.getC35());
          json.put("c36", f.getC36());
          json.put("c37", f.getC37());
        }
      }
      if(kdoId.equals(42)){
        F42 f = df42.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
          json.put("c10", f.getC10());
          json.put("c11", f.getC11());
          json.put("c12", f.getC12());
          json.put("c13", f.getC13());
          json.put("c14", f.getC14());
          json.put("c15", f.getC15());
          json.put("c16", f.getC16());
          json.put("c17", f.getC17());
          json.put("c18", f.getC18());
          json.put("c19", f.getC19());
          json.put("c20", f.getC20());
          json.put("c21", f.getC21());
          json.put("c22", f.getC22());
          json.put("c23", f.getC23());
          json.put("c24", f.getC24());
          json.put("c25", f.getC25());
          json.put("c26", f.getC26());
          json.put("c27", f.getC27());
          json.put("c28", f.getC28());
          json.put("c29", f.getC29());
          json.put("c30", f.getC30());
          json.put("c31", f.getC31());
          json.put("c32", f.getC32());
          json.put("c33", f.getC33());
          json.put("c34", f.getC34());
          json.put("c35", f.getC35());
          json.put("c36", f.getC36());
          json.put("c37", f.getC37());
          json.put("c38", f.getC38());
          json.put("c39", f.getC39());
          json.put("c40", f.getC40());
          json.put("c41", f.getC41());
        }
      }
      if(kdoId.equals(43)){
        F43 f = df43.get(id);
        if(f != null) {
          json.put("c1", f.getC1());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
          json.put("c10", f.getC10());
          json.put("c11", f.getC11());
          json.put("c12", f.getC12());
          json.put("c13", f.getC13());
          json.put("c14", f.getC14());
          json.put("c15", f.getC15());
          json.put("c16", f.getC16());
          json.put("c17", f.getC17());
          json.put("c18", f.getC18());
          json.put("c19", f.getC19());
          json.put("c20", f.getC20());
          json.put("c21", f.getC21());
          json.put("c22", f.getC22());
          json.put("c23", f.getC23());
          json.put("c24", f.getC24());
          json.put("c25", f.getC25());
          json.put("c26", f.getC26());
          json.put("c27", f.getC27());
          json.put("c28", f.getC28());
          json.put("c29", f.getC29());
          json.put("c30", f.getC30());
          json.put("c31", f.getC31());
          json.put("c32", f.getC32());
          json.put("c33", f.getC33());
          json.put("c34", f.getC34());
          json.put("c35", f.getC35());
          json.put("c36", f.getC36());
          json.put("c37", f.getC37());
          json.put("c38", f.getC38());
          json.put("c39", f.getC39());
          json.put("c40", f.getC40());
          json.put("c41", f.getC41());
          json.put("c42", f.getC42());
          json.put("c43", f.getC43());
          json.put("c44", f.getC44());
        }
      }
      if(kdoId.equals(44)){
        F44 f = df44.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
          json.put("c10", f.getC10());
          json.put("c11", f.getC11());
        }
      }
      if(kdoId.equals(45)){
        F45 f = df45.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
          json.put("c10", f.getC10());
          json.put("c11", f.getC11());
          json.put("c12", f.getC12());
          json.put("c13", f.getC13());
          json.put("c14", f.getC14());
          json.put("c15", f.getC15());
          json.put("c16", f.getC16());
          json.put("c17", f.getC17());
          json.put("c18", f.getC18());
          json.put("c19", f.getC19());
          json.put("c20", f.getC20());
          json.put("c21", f.getC21());
          json.put("c22", f.getC22());
          json.put("c23", f.getC23());
          json.put("c24", f.getC24());
          json.put("c25", f.getC25());
          json.put("c26", f.getC26());
          json.put("c27", f.getC27());
          json.put("c28", f.getC28());
          json.put("c29", f.getC29());
          json.put("c30", f.getC30());
          json.put("c31", f.getC31());
          json.put("c32", f.getC32());
          json.put("c33", f.getC33());
          json.put("c34", f.getC34());
          json.put("c35", f.getC35());
          json.put("c36", f.getC36());
          json.put("c37", f.getC37());
          json.put("c38", f.getC38());
          json.put("c39", f.getC39());
          json.put("c40", f.getC40());
        }
      }
      if(kdoId.equals(46)){
        F46 f = df46.get(id);
        if(f != null) {
          json.put("c1", f.getC1());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
          json.put("c10", f.getC10());
          json.put("c11", f.getC11());
          json.put("c12", f.getC12());
        }
      }
      if(kdoId.equals(47)){
        F47 f = df47.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
          json.put("c10", f.getC10());
          json.put("c11", f.getC11());
          json.put("c12", f.getC12());
          json.put("c13", f.getC13());
          json.put("c14", f.getC14());
          json.put("c15", f.getC15());
        }
      }
      if(kdoId.equals(48)){
        F48 f = df48.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
          json.put("c10", f.getC10());
          json.put("c11", f.getC11());
          json.put("c12", f.getC12());
          json.put("c13", f.getC13());
          json.put("c14", f.getC14());
          json.put("c15", f.getC15());
        }
      }
      if(kdoId.equals(49)){
        F49 f = df49.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
        }
      }
      if(kdoId.equals(54)){
        F54 f = df54.get(id);
        if(f != null) {
          json.put("c1", f.getC1());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
          json.put("c10", f.getC10());
          json.put("c11", f.getC11());
          json.put("c12", f.getC12());
          json.put("c13", f.getC13());
          json.put("c14", f.getC14());
          json.put("c15", f.getC15());
          json.put("c16", f.getC16());
          json.put("c17", f.getC17());
          json.put("c18", f.getC18());
          json.put("c19", f.getC19());
          json.put("c20", f.getC20());
          json.put("c21", f.getC21());
          json.put("c22", f.getC22());
          json.put("c23", f.getC23());
          json.put("c24", f.getC24());
          json.put("c25", f.getC25());
          json.put("c26", f.getC26());
          json.put("c27", f.getC27());
          json.put("c28", f.getC28());
          json.put("c29", f.getC29());
          json.put("c30", f.getC30());
          json.put("c31", f.getC31());
          json.put("c32", f.getC32());
          json.put("c33", f.getC33());
          json.put("c34", f.getC34());
          json.put("c35", f.getC35());
          json.put("c36", f.getC36());
          json.put("c37", f.getC37());
          json.put("c38", f.getC38());
          json.put("c39", f.getC39());
          json.put("c40", f.getC40());
          json.put("c41", f.getC41());
          json.put("c42", f.getC42());
          json.put("c43", f.getC43());
        }
      }
      if(kdoId.equals(56)){
        F56 f = df56.get(id);
        if(f != null) {
          json.put("c1", f.getC1());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
        }
      }
      if(kdoId.equals(120)){
        F120 f = df120.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
          json.put("c10", f.getC10());
          json.put("c11", f.getC11());
          json.put("c12", f.getC12());
          json.put("c13", f.getC13());
          json.put("c14", f.getC14());
          json.put("c15", f.getC15());
          json.put("c16", f.getC16());
          json.put("c17", f.getC17());
          json.put("c18", f.getC18());
          json.put("c19", f.getC19());
          json.put("c20", f.getC20());
          json.put("c21", f.getC21());
          json.put("c22", f.getC22());
          json.put("c23", f.getC23());
          json.put("c24", f.getC24());
          json.put("c25", f.getC25());
          json.put("c26", f.getC26());
          json.put("c27", f.getC27());
        }
      }
      if(kdoId.equals(121)){
        F121 f = df121.get(id);
        if(f != null) {
          json.put("c1", f.getC1());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
        }
      }
      if(kdoId.equals(152)){
        F152 f = df152.get(id);
        if(f != null) {
          json.put("c1", f.getC1());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
        }
      }
      if(kdoId.equals(153)){
        F13 f = df13.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
          json.put("c10", f.getC10());
          json.put("c11", f.getC11());
          json.put("c12", f.getC12());
          json.put("c13", f.getC13());
          json.put("c14", f.getC14());
          json.put("c15", f.getC15());
          json.put("c16", f.getC16());
          json.put("c17", f.getC17());
          json.put("c18", f.getC18());
          json.put("c19", f.getC19());
          json.put("c20", f.getC20());
          json.put("c21", f.getC21());
          json.put("c22", f.getC22());
          json.put("c23", f.getC23());
          json.put("c24", f.getC24());
          json.put("c25", f.getC25());
          json.put("c26", f.getC26());
        }
      }
      if(kdoId.equals(174)){
        F174 f = df174.get(id);
        if(f != null) {
          json.put("c1", f.getC1 ());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
          json.put("c10", f.getC10());
          json.put("c11", f.getC11());
          json.put("c12", f.getC12());
          json.put("c13", f.getC13());
          json.put("c14", f.getC14());
          json.put("c15", f.getC15());
          json.put("c16", f.getC16());
          json.put("c17", f.getC17());
          json.put("c18", f.getC18());
          json.put("c19", f.getC19());
          json.put("c20", f.getC20());
          json.put("c21", f.getC21());
          json.put("c22", f.getC22());
          json.put("c23", f.getC23());
          json.put("c24", f.getC24());
        }
      }
      ///////////////////////////////////////////////////////////////////
      if(kdo.getFormId() == 999 || kdo.getFormId() == 889 || kdo.getFormId() == 888 || kdo.getFormId() == 777 || kdo.getFormId() == 1011){
        F999 f = df999.get(id);
        if(f != null) {
          json.put("c1", f.getC1());
          json.put("c2", f.getC2());
        } else {
          json.put("c1", kdo.getTemplate());
        }
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
    return json.toString();
  }

  @Override
  public Integer save(LvPlans p, HttpServletRequest request) {
    Integer resId = 0;
    Forms form = dForm.get(p.getKdo().getFormId());
    if(form.getResult() != null && !"".equals(form.getResult())) {
      KdoResults f = p.getResultId().equals(0) ? new KdoResults() : dKdoResult.get(p.getResultId());
      f.setId(f.getId());
      f.setPatient(dPatient.get(p.getPatientId()));
      f.setPlan(p);
      f.setKdo(p.getKdo());
      f.setC1(Req.get(request, "c1"));
      f.setC2(Req.get(request, "c2"));
      f.setC3(Req.get(request, "c3"));
      f.setC4(Req.get(request, "c4"));
      f.setC5(Req.get(request, "c5"));
      f.setC6(Req.get(request, "c6"));
      f.setC7(Req.get(request, "c7"));
      f.setC8(Req.get(request, "c8"));
      f.setC9(Req.get(request, "c9"));
      f.setC10(Req.get(request, "c10"));
      f.setC11(Req.get(request, "c11"));
      f.setC12(Req.get(request, "c12"));
      f.setC13(Req.get(request, "c13"));
      f.setC14(Req.get(request, "c14"));
      f.setC15(Req.get(request, "c15"));
      f.setC16(Req.get(request, "c16"));
      f.setC17(Req.get(request, "c17"));
      f.setC18(Req.get(request, "c18"));
      f.setC19(Req.get(request, "c19"));
      f.setC20(Req.get(request, "c20"));
      f.setC21(Req.get(request, "c21"));
      f.setC22(Req.get(request, "c22"));
      f.setC23(Req.get(request, "c23"));
      f.setC24(Req.get(request, "c24"));
      f.setC25(Req.get(request, "c25"));
      f.setC26(Req.get(request, "c26"));
      f.setC27(Req.get(request, "c27"));
      f.setC28(Req.get(request, "c28"));
      f.setC29(Req.get(request, "c29"));
      f.setC30(Req.get(request, "c30"));
      f.setC31(Req.get(request, "c31"));
      f.setC32(Req.get(request, "c32"));
      f.setC33(Req.get(request, "c33"));
      f.setC34(Req.get(request, "c34"));
      f.setC35(Req.get(request, "c35"));
      f.setC36(Req.get(request, "c36"));
      f.setC37(Req.get(request, "c37"));
      f.setC38(Req.get(request, "c38"));
      f.setC39(Req.get(request, "c39"));
      f.setC40(Req.get(request, "c40"));
      f.setC41(Req.get(request, "c41"));
      f.setC42(Req.get(request, "c42"));
      f.setC43(Req.get(request, "c43"));
      f.setC44(Req.get(request, "c44"));
      f.setC45(Req.get(request, "c45"));
      f.setC46(Req.get(request, "c46"));
      f.setC47(Req.get(request, "c47"));
      f.setC48(Req.get(request, "c48"));
      f.setC49(Req.get(request, "c49"));
      f.setC50(Req.get(request, "c50"));
      f.setC51(Req.get(request, "c51"));
      f.setC52(Req.get(request, "c52"));
      f.setC53(Req.get(request, "c53"));
      f.setC54(Req.get(request, "c54"));
      f.setC55(Req.get(request, "c55"));
      f.setC56(Req.get(request, "c56"));
      f.setC57(Req.get(request, "c57"));
      f.setC58(Req.get(request, "c58"));
      f.setC59(Req.get(request, "c59"));
      f.setC60(Req.get(request, "c60"));
      dKdoResult.saveAndReturn(f);
      resId = f.getId();
    }
    /////////////////////////////////////////////////////////////////////////////////
    if(p.getKdo().getFormId() == 999 || p.getKdo().getFormId() == 889 || p.getKdo().getFormId() == 888 || p.getKdo().getFormId() == 777 || p.getKdo().getFormId() == 1011) {
      F999 f = p.getResultId().equals(0) ? new F999() : df999.get(p.getResultId());
      f.setId(f.getId());
      f.setPatientId(p.getPatientId());
      f.setPlan_id(p.getId());
      f.setKdoId(p.getKdo().getId());
      f.setC1(Req.get(request, "c1"));
      f.setC2(Req.get(request, "c2"));
      resId = df999.saveAndReturn(f).getId();
    } else {
      if (p.getKdo().getId().equals(1)) {
        F1 f = p.getResultId().equals(0) ? new F1() : df1.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        f.setC9(Req.get(request, "c9"));
        f.setC10(Req.get(request, "c10"));
        resId = df1.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(2)) {
        F2 f = p.getResultId().equals(0) ? new F2() : df2.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        resId = df2.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(4)) {
        F4 f = p.getResultId().equals(0) ? new F4() : df4.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        f.setC9(Req.get(request, "c9"));
        f.setC10(Req.get(request, "c10"));
        f.setC11(Req.get(request, "c11"));
        f.setC12(Req.get(request, "c12"));
        f.setC13(Req.get(request, "c13"));
        f.setC14(Req.get(request, "c14"));
        f.setC15(Req.get(request, "c15"));
        f.setC16(Req.get(request, "c16"));
        f.setC17(Req.get(request, "c17"));
        resId = df4.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(5)) {
        F5 f = p.getResultId().equals(0) ? new F5() : df5.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        resId = df5.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(6)) {
        F6 f = p.getResultId().equals(0) ? new F6() : df6.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        f.setC9(Req.get(request, "c9"));
        f.setC10(Req.get(request, "c10"));
        f.setC11(Req.get(request, "c11"));
        f.setC12(Req.get(request, "c12"));
        f.setC13(Req.get(request, "c13"));
        f.setC14(Req.get(request, "c14"));
        f.setC15(Req.get(request, "c15"));
        f.setC16(Req.get(request, "c16"));
        f.setC17(Req.get(request, "c17"));
        resId = df6.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(7)) {
        F7 f = p.getResultId().equals(0) ? new F7() : df7.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        f.setC9(Req.get(request, "c9"));
        f.setC10(Req.get(request, "c10"));
        f.setC11(Req.get(request, "c11"));
        f.setC12(Req.get(request, "c12"));
        f.setC13(Req.get(request, "c13"));
        f.setC14(Req.get(request, "c14"));
        f.setC15(Req.get(request, "c15"));
        resId = df7.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(8)) {
        F8 f = p.getResultId().equals(0) ? new F8() : df8.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        f.setC9(Req.get(request, "c9"));
        f.setC10(Req.get(request, "c10"));
        f.setC11(Req.get(request, "c11"));
        f.setC12(Req.get(request, "c12"));
        f.setC13(Req.get(request, "c13"));
        f.setC14(Req.get(request, "c14"));
        f.setC15(Req.get(request, "c15"));
        f.setC16(Req.get(request, "c16"));
        f.setC17(Req.get(request, "c17"));
        f.setC18(Req.get(request, "c18"));
        resId = df8.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(9)) {
        F9 f = p.getResultId().equals(0) ? new F9() : df9.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        resId = df9.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(10)) {
        F10 f = p.getResultId().equals(0) ? new F10() : df10.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        f.setC9(Req.get(request, "c9"));
        f.setC10(Req.get(request, "c10"));
        f.setC11(Req.get(request, "c11"));
        f.setC12(Req.get(request, "c12"));
        f.setC13(Req.get(request, "c13"));
        f.setC14(Req.get(request, "c14"));
        f.setC15(Req.get(request, "c15"));
        f.setC16(Req.get(request, "c16"));
        f.setC17(Req.get(request, "c17"));
        f.setC18(Req.get(request, "c18"));
        f.setC19(Req.get(request, "c19"));
        f.setC20(Req.get(request, "c20"));
        f.setC21(Req.get(request, "c21"));
        f.setC22(Req.get(request, "c22"));
        f.setC23(Req.get(request, "c23"));
        f.setC24(Req.get(request, "c24"));
        f.setC25(Req.get(request, "c25"));
        f.setC26(Req.get(request, "c26"));
        f.setC27(Req.get(request, "c27"));
        f.setC28(Req.get(request, "c28"));
        f.setC29(Req.get(request, "c29"));
        resId = df10.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(11)) {
        F11 f = p.getResultId().equals(0) ? new F11() : df11.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        resId = df11.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(12)) {
        F12 f = p.getResultId().equals(0) ? new F12() : df12.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        f.setC9(Req.get(request, "c9"));
        f.setC10(Req.get(request, "c10"));
        f.setC11(Req.get(request, "c11"));
        f.setC12(Req.get(request, "c12"));
        f.setC13(Req.get(request, "c13"));
        f.setC14(Req.get(request, "c14"));
        f.setC15(Req.get(request, "c15"));
        resId = df12.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(13)) {
        F13 f = p.getResultId().equals(0) ? new F13() : df13.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        f.setC9(Req.get(request, "c9"));
        f.setC10(Req.get(request, "c10"));
        f.setC11(Req.get(request, "c11"));
        f.setC12(Req.get(request, "c12"));
        f.setC13(Req.get(request, "c13"));
        f.setC14(Req.get(request, "c14"));
        f.setC15(Req.get(request, "c15"));
        f.setC16(Req.get(request, "c16"));
        f.setC17(Req.get(request, "c17"));
        f.setC18(Req.get(request, "c18"));
        f.setC19(Req.get(request, "c19"));
        f.setC20(Req.get(request, "c20"));
        f.setC21(Req.get(request, "c21"));
        f.setC22(Req.get(request, "c22"));
        f.setC23(Req.get(request, "c23"));
        f.setC24(Req.get(request, "c24"));
        f.setC25(Req.get(request, "c25"));
        f.setC26(Req.get(request, "c26"));
        f.setC27(Req.get(request, "c27"));
        f.setC28(Req.get(request, "c28"));
        f.setC29(Req.get(request, "c29"));
        resId = df13.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(14)) {
        F14 f = p.getResultId().equals(0) ? new F14() : df14.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        resId = df14.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(15)) {
        F15 f = p.getResultId().equals(0) ? new F15() : df15.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        resId = df15.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(16)) {
        F16 f = p.getResultId().equals(0) ? new F16() : df16.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        resId = df16.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(17)) {
        F17 f = p.getResultId().equals(0) ? new F17() : df17.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        resId = df17.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(18)) {
        F18 f = p.getResultId().equals(0) ? new F18() : df18.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c3"));
        f.setC3(Req.get(request, "c2"));
        resId = df18.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(19)) {
        F19 f = p.getResultId().equals(0) ? new F19() : df19.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        resId = df19.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(20)) {
        F20 f = p.getResultId().equals(0) ? new F20() : df20.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        f.setC9(Req.get(request, "c9"));
        f.setC10(Req.get(request, "c10"));
        f.setC11(Req.get(request, "c11"));
        f.setC12(Req.get(request, "c12"));
        f.setC13(Req.get(request, "c13"));
        f.setC14(Req.get(request, "c14"));
        f.setC15(Req.get(request, "c15"));
        f.setC16(Req.get(request, "c16"));
        f.setC17(Req.get(request, "c17"));
        f.setC18(Req.get(request, "c18"));
        f.setC19(Req.get(request, "c19"));
        f.setC20(Req.get(request, "c20"));
        resId = df20.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(21)) {
        F21 f = p.getResultId().equals(0) ? new F21() : df21.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        resId = df21.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(22)) {
        F22 f = p.getResultId().equals(0) ? new F22() : df22.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        resId = df22.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(23)) {
        F23 f = p.getResultId().equals(0) ? new F23() : df23.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        resId = df23.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(24)) {
        F24 f = p.getResultId().equals(0) ? new F24() : df24.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        f.setC9(Req.get(request, "c9"));
        f.setC10(Req.get(request, "c10"));
        f.setC11(Req.get(request, "c11"));
        f.setC12(Req.get(request, "c12"));
        resId = df24.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(25)) {
        F25 f = p.getResultId().equals(0) ? new F25() : df25.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        f.setC9(Req.get(request, "c9"));
        f.setC10(Req.get(request, "c10"));
        f.setC11(Req.get(request, "c11"));
        f.setC12(Req.get(request, "c12"));
        f.setC13(Req.get(request, "c13"));
        resId = df25.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(26)) {
        F26 f = p.getResultId().equals(0) ? new F26() : df26.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        f.setC9(Req.get(request, "c9"));
        f.setC10(Req.get(request, "c10"));
        f.setC11(Req.get(request, "c11"));
        f.setC12(Req.get(request, "c12"));
        resId = df26.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(27)) {
        F27 f = p.getResultId().equals(0) ? new F27() : df27.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        resId = df27.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(28)) {
        F28 f = p.getResultId().equals(0) ? new F28() : df28.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        resId = df28.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(29)) {
        F29 f = p.getResultId().equals(0) ? new F29() : df29.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        f.setC9(Req.get(request, "c9"));
        resId = df29.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(30)) {
        F30 f = p.getResultId().equals(0) ? new F30() : df30.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        f.setC9(Req.get(request, "c9"));
        f.setC10(Req.get(request, "c10"));
        f.setC11(Req.get(request, "c11"));
        f.setC12(Req.get(request, "c12"));
        f.setC13(Req.get(request, "c13"));
        f.setC14(Req.get(request, "c14"));
        f.setC15(Req.get(request, "c15"));
        f.setC16(Req.get(request, "c16"));
        f.setC17(Req.get(request, "c17"));
        f.setC18(Req.get(request, "c18"));
        f.setC19(Req.get(request, "c19"));
        f.setC20(Req.get(request, "c20"));
        f.setC21(Req.get(request, "c21"));
        f.setC22(Req.get(request, "c22"));
        f.setC23(Req.get(request, "c23"));
        f.setC24(Req.get(request, "c24"));
        f.setC25(Req.get(request, "c25"));
        f.setC26(Req.get(request, "c26"));
        f.setC27(Req.get(request, "c27"));
        f.setC28(Req.get(request, "c28"));
        f.setC29(Req.get(request, "c29"));
        f.setC30(Req.get(request, "c30"));
        f.setC31(Req.get(request, "c31"));
        f.setC32(Req.get(request, "c32"));
        f.setC33(Req.get(request, "c33"));
        f.setC34(Req.get(request, "c34"));
        f.setC35(Req.get(request, "c35"));
        f.setC36(Req.get(request, "c36"));
        f.setC37(Req.get(request, "c37"));
        f.setC38(Req.get(request, "c38"));
        f.setC39(Req.get(request, "c39"));
        f.setC40(Req.get(request, "c40"));
        f.setC41(Req.get(request, "c41"));
        f.setC42(Req.get(request, "c42"));
        f.setC43(Req.get(request, "c43"));
        f.setC44(Req.get(request, "c44"));
        f.setC45(Req.get(request, "c45"));
        f.setC46(Req.get(request, "c46"));
        f.setC47(Req.get(request, "c47"));
        f.setC48(Req.get(request, "c48"));
        f.setC49(Req.get(request, "c49"));
        f.setC50(Req.get(request, "c50"));
        f.setC51(Req.get(request, "c51"));
        f.setC52(Req.get(request, "c52"));
        resId = df30.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(31)) {
        F31 f = p.getResultId().equals(0) ? new F31() : df31.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        f.setC9(Req.get(request, "c9"));
        f.setC10(Req.get(request, "c10"));
        f.setC11(Req.get(request, "c11"));
        f.setC12(Req.get(request, "c12"));
        f.setC13(Req.get(request, "c13"));
        f.setC14(Req.get(request, "c14"));
        f.setC15(Req.get(request, "c15"));
        f.setC16(Req.get(request, "c16"));
        f.setC17(Req.get(request, "c17"));
        resId = df31.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(32)) {
        F32 f = p.getResultId().equals(0) ? new F32() : df32.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        f.setC9(Req.get(request, "c9"));
        f.setC10(Req.get(request, "c10"));
        f.setC11(Req.get(request, "c11"));
        f.setC12(Req.get(request, "c12"));
        f.setC13(Req.get(request, "c13"));
        f.setC14(Req.get(request, "c14"));
        f.setC15(Req.get(request, "c15"));
        f.setC16(Req.get(request, "c16"));
        f.setC17(Req.get(request, "c17"));
        f.setC18(Req.get(request, "c18"));
        f.setC19(Req.get(request, "c19"));
        f.setC20(Req.get(request, "c20"));
        f.setC21(Req.get(request, "c21"));
        resId = df32.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(33)) {
        F33 f = p.getResultId().equals(0) ? new F33() : df33.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        f.setC9(Req.get(request, "c9"));
        f.setC10(Req.get(request, "c10"));
        f.setC11(Req.get(request, "c11"));
        f.setC12(Req.get(request, "c12"));
        f.setC13(Req.get(request, "c13"));
        f.setC14(Req.get(request, "c14"));
        f.setC15(Req.get(request, "c15"));
        f.setC16(Req.get(request, "c16"));
        f.setC17(Req.get(request, "c17"));
        f.setC18(Req.get(request, "c18"));
        f.setC19(Req.get(request, "c19"));
        f.setC20(Req.get(request, "c20"));
        f.setC21(Req.get(request, "c21"));
        f.setC22(Req.get(request, "c22"));
        f.setC23(Req.get(request, "c23"));
        f.setC24(Req.get(request, "c24"));
        f.setC25(Req.get(request, "c25"));
        f.setC26(Req.get(request, "c26"));
        f.setC27(Req.get(request, "c27"));
        f.setC28(Req.get(request, "c28"));
        f.setC29(Req.get(request, "c29"));
        f.setC30(Req.get(request, "c30"));
        f.setC31(Req.get(request, "c31"));
        f.setC32(Req.get(request, "c32"));
        f.setC33(Req.get(request, "c33"));
        f.setC34(Req.get(request, "c34"));
        f.setC35(Req.get(request, "c35"));
        resId = df33.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(34)) {
        F34 f = p.getResultId().equals(0) ? new F34() : df34.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        f.setC9(Req.get(request, "c9"));
        f.setC10(Req.get(request, "c10"));
        f.setC11(Req.get(request, "c11"));
        f.setC12(Req.get(request, "c12"));
        f.setC13(Req.get(request, "c13"));
        f.setC14(Req.get(request, "c14"));
        resId = df34.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(35)) {
        F35 f = p.getResultId().equals(0) ? new F35() : df35.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        f.setC9(Req.get(request, "c9"));
        f.setC10(Req.get(request, "c10"));
        f.setC11(Req.get(request, "c11"));
        f.setC12(Req.get(request, "c12"));
        f.setC13(Req.get(request, "c13"));
        f.setC14(Req.get(request, "c14"));
        f.setC15(Req.get(request, "c15"));
        f.setC16(Req.get(request, "c16"));
        f.setC17(Req.get(request, "c17"));
        f.setC18(Req.get(request, "c18"));
        f.setC19(Req.get(request, "c19"));
        f.setC20(Req.get(request, "c20"));
        f.setC21(Req.get(request, "c21"));
        f.setC22(Req.get(request, "c22"));
        f.setC23(Req.get(request, "c23"));
        f.setC24(Req.get(request, "c24"));
        f.setC25(Req.get(request, "c25"));
        f.setC26(Req.get(request, "c26"));
        f.setC27(Req.get(request, "c27"));
        f.setC28(Req.get(request, "c28"));
        f.setC29(Req.get(request, "c29"));
        f.setC30(Req.get(request, "c30"));
        f.setC31(Req.get(request, "c31"));
        f.setC32(Req.get(request, "c32"));
        f.setC33(Req.get(request, "c33"));
        f.setC34(Req.get(request, "c34"));
        f.setC35(Req.get(request, "c35"));
        f.setC36(Req.get(request, "c36"));
        f.setC37(Req.get(request, "c37"));
        f.setC38(Req.get(request, "c38"));
        f.setC39(Req.get(request, "c39"));
        f.setC40(Req.get(request, "c40"));
        f.setC41(Req.get(request, "c41"));
        f.setC42(Req.get(request, "c42"));
        f.setC43(Req.get(request, "c43"));
        f.setC44(Req.get(request, "c44"));
        f.setC45(Req.get(request, "c45"));
        f.setC46(Req.get(request, "c46"));
        f.setC47(Req.get(request, "c47"));
        resId = df35.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(36)) {
        F36 f = p.getResultId().equals(0) ? new F36() : df36.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        f.setC9(Req.get(request, "c9"));
        f.setC10(Req.get(request, "c10"));
        f.setC11(Req.get(request, "c11"));
        f.setC12(Req.get(request, "c12"));
        f.setC13(Req.get(request, "c13"));
        f.setC14(Req.get(request, "c14"));
        f.setC15(Req.get(request, "c15"));
        f.setC16(Req.get(request, "c16"));
        f.setC17(Req.get(request, "c17"));
        f.setC18(Req.get(request, "c18"));
        f.setC19(Req.get(request, "c19"));
        f.setC20(Req.get(request, "c20"));
        f.setC21(Req.get(request, "c21"));
        f.setC22(Req.get(request, "c22"));
        f.setC23(Req.get(request, "c23"));
        f.setC24(Req.get(request, "c24"));
        resId = df36.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(37)) {
        F37 f = p.getResultId().equals(0) ? new F37() : df37.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        resId = df37.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(38)) {
        F38 f = p.getResultId().equals(0) ? new F38() : df38.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        f.setC9(Req.get(request, "c9"));
        f.setC10(Req.get(request, "c10"));
        f.setC11(Req.get(request, "c11"));
        f.setC12(Req.get(request, "c12"));
        f.setC13(Req.get(request, "c13"));
        f.setC14(Req.get(request, "c14"));
        f.setC15(Req.get(request, "c15"));
        f.setC16(Req.get(request, "c16"));
        f.setC17(Req.get(request, "c17"));
        f.setC18(Req.get(request, "c18"));
        f.setC19(Req.get(request, "c19"));
        resId = df38.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(39)) {
        F39 f = p.getResultId().equals(0) ? new F39() : df39.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        f.setC9(Req.get(request, "c9"));
        f.setC10(Req.get(request, "c10"));
        f.setC11(Req.get(request, "c11"));
        f.setC12(Req.get(request, "c12"));
        f.setC13(Req.get(request, "c13"));
        f.setC14(Req.get(request, "c14"));
        f.setC15(Req.get(request, "c15"));
        f.setC16(Req.get(request, "c16"));
        f.setC17(Req.get(request, "c17"));
        f.setC18(Req.get(request, "c18"));
        f.setC19(Req.get(request, "c19"));
        f.setC20(Req.get(request, "c20"));
        f.setC21(Req.get(request, "c21"));
        f.setC22(Req.get(request, "c22"));
        f.setC23(Req.get(request, "c23"));
        f.setC24(Req.get(request, "c24"));
        f.setC25(Req.get(request, "c25"));
        f.setC26(Req.get(request, "c26"));
        f.setC27(Req.get(request, "c27"));
        f.setC28(Req.get(request, "c28"));
        f.setC29(Req.get(request, "c29"));
        f.setC30(Req.get(request, "c30"));
        f.setC31(Req.get(request, "c31"));
        f.setC32(Req.get(request, "c32"));
        f.setC33(Req.get(request, "c33"));
        resId = df39.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(40)) {
        F40 f = p.getResultId().equals(0) ? new F40() : df40.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        f.setC9(Req.get(request, "c9"));
        f.setC10(Req.get(request, "c10"));
        f.setC11(Req.get(request, "c11"));
        f.setC12(Req.get(request, "c12"));
        f.setC13(Req.get(request, "c13"));
        f.setC14(Req.get(request, "c14"));
        f.setC15(Req.get(request, "c15"));
        f.setC16(Req.get(request, "c16"));
        f.setC17(Req.get(request, "c17"));
        f.setC18(Req.get(request, "c18"));
        f.setC19(Req.get(request, "c19"));
        f.setC20(Req.get(request, "c20"));
        f.setC21(Req.get(request, "c21"));
        f.setC22(Req.get(request, "c22"));
        f.setC23(Req.get(request, "c23"));
        f.setC24(Req.get(request, "c24"));
        f.setC25(Req.get(request, "c25"));
        f.setC26(Req.get(request, "c26"));
        f.setC27(Req.get(request, "c27"));
        f.setC28(Req.get(request, "c28"));
        f.setC29(Req.get(request, "c29"));
        f.setC30(Req.get(request, "c30"));
        f.setC31(Req.get(request, "c31"));
        f.setC32(Req.get(request, "c32"));
        f.setC33(Req.get(request, "c33"));
        f.setC34(Req.get(request, "c34"));
        f.setC35(Req.get(request, "c35"));
        f.setC36(Req.get(request, "c36"));
        f.setC37(Req.get(request, "c37"));
        f.setC38(Req.get(request, "c38"));
        f.setC39(Req.get(request, "c39"));
        f.setC40(Req.get(request, "c40"));
        f.setC41(Req.get(request, "c41"));
        resId = df40.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(41)) {
        F41 f = p.getResultId().equals(0) ? new F41() : df41.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        f.setC9(Req.get(request, "c9"));
        f.setC10(Req.get(request, "c10"));
        f.setC11(Req.get(request, "c11"));
        f.setC12(Req.get(request, "c12"));
        f.setC13(Req.get(request, "c13"));
        f.setC14(Req.get(request, "c14"));
        f.setC15(Req.get(request, "c15"));
        f.setC16(Req.get(request, "c16"));
        f.setC17(Req.get(request, "c17"));
        f.setC18(Req.get(request, "c18"));
        f.setC19(Req.get(request, "c19"));
        f.setC20(Req.get(request, "c20"));
        f.setC21(Req.get(request, "c21"));
        f.setC22(Req.get(request, "c22"));
        f.setC23(Req.get(request, "c23"));
        f.setC24(Req.get(request, "c24"));
        f.setC25(Req.get(request, "c25"));
        f.setC26(Req.get(request, "c26"));
        f.setC27(Req.get(request, "c27"));
        f.setC28(Req.get(request, "c28"));
        f.setC29(Req.get(request, "c29"));
        f.setC30(Req.get(request, "c30"));
        f.setC31(Req.get(request, "c31"));
        f.setC32(Req.get(request, "c32"));
        f.setC33(Req.get(request, "c33"));
        f.setC34(Req.get(request, "c34"));
        f.setC35(Req.get(request, "c35"));
        f.setC36(Req.get(request, "c36"));
        f.setC37(Req.get(request, "c37"));
        resId = df41.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(42)) {
        F42 f = p.getResultId().equals(0) ? new F42() : df42.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        f.setC9(Req.get(request, "c9"));
        f.setC10(Req.get(request, "c10"));
        f.setC11(Req.get(request, "c11"));
        f.setC12(Req.get(request, "c12"));
        f.setC13(Req.get(request, "c13"));
        f.setC14(Req.get(request, "c14"));
        f.setC15(Req.get(request, "c15"));
        f.setC16(Req.get(request, "c16"));
        f.setC17(Req.get(request, "c17"));
        f.setC18(Req.get(request, "c18"));
        f.setC19(Req.get(request, "c19"));
        f.setC20(Req.get(request, "c20"));
        f.setC21(Req.get(request, "c21"));
        f.setC22(Req.get(request, "c22"));
        f.setC23(Req.get(request, "c23"));
        f.setC24(Req.get(request, "c24"));
        f.setC25(Req.get(request, "c25"));
        f.setC26(Req.get(request, "c26"));
        f.setC27(Req.get(request, "c27"));
        f.setC28(Req.get(request, "c28"));
        f.setC29(Req.get(request, "c29"));
        f.setC30(Req.get(request, "c30"));
        f.setC31(Req.get(request, "c31"));
        f.setC32(Req.get(request, "c32"));
        f.setC33(Req.get(request, "c33"));
        f.setC34(Req.get(request, "c34"));
        f.setC35(Req.get(request, "c35"));
        f.setC36(Req.get(request, "c36"));
        f.setC37(Req.get(request, "c37"));
        f.setC38(Req.get(request, "c38"));
        f.setC39(Req.get(request, "c39"));
        f.setC40(Req.get(request, "c40"));
        f.setC41(Req.get(request, "c41"));
        resId = df42.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(43)) {
        F43 f = p.getResultId().equals(0) ? new F43() : df43.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        f.setC9(Req.get(request, "c9"));
        f.setC10(Req.get(request, "c10"));
        f.setC11(Req.get(request, "c11"));
        f.setC12(Req.get(request, "c12"));
        f.setC13(Req.get(request, "c13"));
        f.setC14(Req.get(request, "c14"));
        f.setC15(Req.get(request, "c15"));
        f.setC16(Req.get(request, "c16"));
        f.setC17(Req.get(request, "c17"));
        f.setC18(Req.get(request, "c18"));
        f.setC19(Req.get(request, "c19"));
        f.setC20(Req.get(request, "c20"));
        f.setC21(Req.get(request, "c21"));
        f.setC22(Req.get(request, "c22"));
        f.setC23(Req.get(request, "c23"));
        f.setC24(Req.get(request, "c24"));
        f.setC25(Req.get(request, "c25"));
        f.setC26(Req.get(request, "c26"));
        f.setC27(Req.get(request, "c27"));
        f.setC28(Req.get(request, "c28"));
        f.setC29(Req.get(request, "c29"));
        f.setC30(Req.get(request, "c30"));
        f.setC31(Req.get(request, "c31"));
        f.setC32(Req.get(request, "c32"));
        f.setC33(Req.get(request, "c33"));
        f.setC34(Req.get(request, "c34"));
        f.setC35(Req.get(request, "c35"));
        f.setC36(Req.get(request, "c36"));
        f.setC37(Req.get(request, "c37"));
        f.setC38(Req.get(request, "c38"));
        f.setC39(Req.get(request, "c39"));
        f.setC40(Req.get(request, "c40"));
        f.setC41(Req.get(request, "c41"));
        f.setC42(Req.get(request, "c42"));
        f.setC43(Req.get(request, "c43"));
        f.setC44(Req.get(request, "c44"));
        resId = df43.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(44)) {
        F44 f = p.getResultId().equals(0) ? new F44() : df44.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        f.setC9(Req.get(request, "c9"));
        f.setC10(Req.get(request, "c10"));
        f.setC11(Req.get(request, "c11"));
        resId = df44.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(45)) {
        F45 f = p.getResultId().equals(0) ? new F45() : df45.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        f.setC9(Req.get(request, "c9"));
        f.setC10(Req.get(request, "c10"));
        f.setC11(Req.get(request, "c11"));
        f.setC12(Req.get(request, "c12"));
        f.setC13(Req.get(request, "c13"));
        f.setC14(Req.get(request, "c14"));
        f.setC15(Req.get(request, "c15"));
        f.setC16(Req.get(request, "c16"));
        f.setC17(Req.get(request, "c17"));
        f.setC18(Req.get(request, "c18"));
        f.setC19(Req.get(request, "c19"));
        f.setC20(Req.get(request, "c20"));
        f.setC21(Req.get(request, "c21"));
        f.setC22(Req.get(request, "c22"));
        f.setC23(Req.get(request, "c23"));
        f.setC24(Req.get(request, "c24"));
        f.setC25(Req.get(request, "c25"));
        f.setC26(Req.get(request, "c26"));
        f.setC27(Req.get(request, "c27"));
        f.setC28(Req.get(request, "c28"));
        f.setC29(Req.get(request, "c29"));
        f.setC30(Req.get(request, "c30"));
        f.setC31(Req.get(request, "c31"));
        f.setC32(Req.get(request, "c32"));
        f.setC33(Req.get(request, "c33"));
        f.setC34(Req.get(request, "c34"));
        f.setC35(Req.get(request, "c35"));
        f.setC36(Req.get(request, "c36"));
        f.setC37(Req.get(request, "c37"));
        f.setC38(Req.get(request, "c38"));
        f.setC39(Req.get(request, "c39"));
        f.setC40(Req.get(request, "c40"));
        resId = df45.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(46)) {
        F46 f = p.getResultId().equals(0) ? new F46() : df46.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        f.setC9(Req.get(request, "c9"));
        f.setC10(Req.get(request, "c10"));
        f.setC11(Req.get(request, "c11"));
        f.setC12(Req.get(request, "c12"));
        resId = df46.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(47)) {
        F47 f = p.getResultId().equals(0) ? new F47() : df47.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        f.setC9(Req.get(request, "c9"));
        f.setC10(Req.get(request, "c10"));
        f.setC11(Req.get(request, "c11"));
        f.setC12(Req.get(request, "c12"));
        f.setC13(Req.get(request, "c13"));
        f.setC14(Req.get(request, "c14"));
        f.setC15(Req.get(request, "c15"));
        resId = df47.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(48)) {
        F48 f = p.getResultId().equals(0) ? new F48() : df48.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        f.setC9(Req.get(request, "c9"));
        f.setC10(Req.get(request, "c10"));
        f.setC11(Req.get(request, "c11"));
        f.setC12(Req.get(request, "c12"));
        f.setC13(Req.get(request, "c13"));
        f.setC14(Req.get(request, "c14"));
        f.setC15(Req.get(request, "c15"));
        resId = df48.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(49)) {
        F49 f = p.getResultId().equals(0) ? new F49() : df49.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        resId = df49.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(54)) {
        F54 f = p.getResultId().equals(0) ? new F54() : df54.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        f.setC9(Req.get(request, "c9"));
        f.setC10(Req.get(request, "c10"));
        f.setC11(Req.get(request, "c11"));
        f.setC12(Req.get(request, "c12"));
        f.setC13(Req.get(request, "c13"));
        f.setC14(Req.get(request, "c14"));
        f.setC15(Req.get(request, "c15"));
        f.setC16(Req.get(request, "c16"));
        f.setC17(Req.get(request, "c17"));
        f.setC18(Req.get(request, "c18"));
        f.setC19(Req.get(request, "c19"));
        f.setC20(Req.get(request, "c20"));
        f.setC21(Req.get(request, "c21"));
        f.setC22(Req.get(request, "c22"));
        f.setC23(Req.get(request, "c23"));
        f.setC24(Req.get(request, "c24"));
        f.setC25(Req.get(request, "c25"));
        f.setC26(Req.get(request, "c26"));
        f.setC27(Req.get(request, "c27"));
        f.setC28(Req.get(request, "c28"));
        f.setC29(Req.get(request, "c29"));
        f.setC30(Req.get(request, "c30"));
        f.setC31(Req.get(request, "c31"));
        f.setC32(Req.get(request, "c32"));
        f.setC33(Req.get(request, "c33"));
        f.setC34(Req.get(request, "c34"));
        f.setC35(Req.get(request, "c35"));
        f.setC36(Req.get(request, "c36"));
        f.setC37(Req.get(request, "c37"));
        f.setC38(Req.get(request, "c38"));
        f.setC39(Req.get(request, "c39"));
        f.setC40(Req.get(request, "c40"));
        f.setC41(Req.get(request, "c41"));
        f.setC42(Req.get(request, "c42"));
        f.setC43(Req.get(request, "c43"));
        resId = df54.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(56)) {
        F56 f = p.getResultId().equals(0) ? new F56() : df56.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        resId = df56.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(120)) {
        F120 f = p.getResultId().equals(0) ? new F120() : df120.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        f.setC9(Req.get(request, "c9"));
        f.setC10(Req.get(request, "c10"));
        f.setC11(Req.get(request, "c11"));
        f.setC12(Req.get(request, "c12"));
        f.setC13(Req.get(request, "c13"));
        f.setC14(Req.get(request, "c14"));
        f.setC15(Req.get(request, "c15"));
        f.setC16(Req.get(request, "c16"));
        f.setC17(Req.get(request, "c17"));
        f.setC18(Req.get(request, "c18"));
        f.setC19(Req.get(request, "c19"));
        f.setC20(Req.get(request, "c20"));
        f.setC21(Req.get(request, "c21"));
        f.setC22(Req.get(request, "c22"));
        f.setC23(Req.get(request, "c23"));
        f.setC24(Req.get(request, "c24"));
        f.setC25(Req.get(request, "c25"));
        f.setC26(Req.get(request, "c26"));
        f.setC27(Req.get(request, "c27"));
        resId = df120.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(121)) {
        F121 f = p.getResultId().equals(0) ? new F121() : df121.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        resId = df121.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(152)) {
        F152 f = p.getResultId().equals(0) ? new F152() : df152.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        resId = df152.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(153)) {
        F13 f = p.getResultId().equals(0) ? new F13() : df13.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        f.setC9(Req.get(request, "c9"));
        f.setC10(Req.get(request, "c10"));
        f.setC11(Req.get(request, "c11"));
        f.setC12(Req.get(request, "c12"));
        f.setC13(Req.get(request, "c13"));
        f.setC14(Req.get(request, "c14"));
        f.setC15(Req.get(request, "c15"));
        f.setC16(Req.get(request, "c16"));
        f.setC17(Req.get(request, "c17"));
        f.setC18(Req.get(request, "c18"));
        f.setC19(Req.get(request, "c19"));
        f.setC20(Req.get(request, "c20"));
        f.setC21(Req.get(request, "c21"));
        f.setC22(Req.get(request, "c22"));
        f.setC23(Req.get(request, "c23"));
        f.setC24(Req.get(request, "c24"));
        f.setC25(Req.get(request, "c25"));
        f.setC26(Req.get(request, "c26"));
        resId = df13.saveAndReturn(f).getId();
      }
      if (p.getKdo().getId().equals(174)) {
        F174 f = p.getResultId().equals(0) ? new F174() : df174.get(p.getResultId());
        f.setId(f.getId());
        f.setPatientId(p.getPatientId());
        f.setPlan_id(p.getId());
        f.setC1(Req.get(request, "c1"));
        f.setC2(Req.get(request, "c2"));
        f.setC3(Req.get(request, "c3"));
        f.setC4(Req.get(request, "c4"));
        f.setC5(Req.get(request, "c5"));
        f.setC6(Req.get(request, "c6"));
        f.setC7(Req.get(request, "c7"));
        f.setC8(Req.get(request, "c8"));
        f.setC9(Req.get(request, "c9"));
        f.setC10(Req.get(request, "c10"));
        f.setC11(Req.get(request, "c11"));
        f.setC12(Req.get(request, "c12"));
        f.setC13(Req.get(request, "c13"));
        f.setC14(Req.get(request, "c14"));
        f.setC15(Req.get(request, "c15"));
        f.setC16(Req.get(request, "c16"));
        f.setC17(Req.get(request, "c17"));
        f.setC18(Req.get(request, "c18"));
        f.setC19(Req.get(request, "c19"));
        f.setC20(Req.get(request, "c20"));
        f.setC21(Req.get(request, "c21"));
        f.setC22(Req.get(request, "c22"));
        f.setC23(Req.get(request, "c23"));
        f.setC24(Req.get(request, "c24"));
        resId = df174.saveAndReturn(f).getId();
      }
    }
    p.setResultId(resId);
    p.setConfUser(SessionUtil.getUser(request).getUserId());
    dLvPlan.save(p);
    //
    return resId;
  }
}
