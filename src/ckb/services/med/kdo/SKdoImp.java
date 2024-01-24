package ckb.services.med.kdo;

import ckb.dao.admin.forms.DForm;
import ckb.dao.admin.users.DUser;
import ckb.dao.med.kdos.DKdoResult;
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
      if (plan.getKdo().getId().equals(6))
        model.addAttribute("f", df6.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(7))
        model.addAttribute("f", df7.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(8))
        model.addAttribute("f", df8.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(10))
        model.addAttribute("f", df10.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(11))
        model.addAttribute("f", df11.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(13)) {
        model.addAttribute("bio", dlvBio.getByPlan(planId));
        model.addAttribute("f", df13.get(plan.getResultId()));
      }
      if (plan.getKdo().getId().equals(15))
        model.addAttribute("f", df15.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(16))
        model.addAttribute("f", df16.get(plan.getResultId()));
      if (plan.getKdo().getId().equals(17))
        model.addAttribute("f", df17.get(plan.getResultId()));
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
