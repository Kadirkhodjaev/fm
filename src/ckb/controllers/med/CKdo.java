package ckb.controllers.med;

import ckb.dao.admin.forms.DForm;
import ckb.dao.med.lv.plan.DLvPlan;
import ckb.dao.med.patient.DPatient;
import ckb.dao.med.patient.DPatientPlan;
import ckb.domains.admin.Forms;
import ckb.domains.med.lv.LvPlans;
import ckb.domains.med.patient.PatientPlans;
import ckb.models.ObjList;
import ckb.services.admin.form.SForm;
import ckb.services.med.kdo.SKdo;
import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.Req;
import ckb.utils.Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.persistence.NoResultException;
import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/kdo")
public class CKdo {

  @Autowired private DPatient dPatient;
  @Autowired private DLvPlan dLvPlan;
  @Autowired private SForm sForm;
  @Autowired private SKdo sKdo;
  @Autowired private DPatientPlan dPatientPlan;
  @Autowired private DForm dForm;

  @RequestMapping({"/index.s", "/"})
  protected String main(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    int id = Req.getInt(request, "id");
    session.setCurPat(id);
    model.addAttribute("plans", sKdo.getPatientPlans(id, session));
    //
    model.addAttribute("p", dPatient.get(id));
    return "/med/kdo/index";
  }

  @RequestMapping(value = "/save.s", method = RequestMethod.POST)
  protected String save(HttpServletRequest request){
    Session session = SessionUtil.getUser(request);
    LvPlans p = dLvPlan.get(Req.getInt(request, "planId"));
    sKdo.save(p, request);
    session.setCurUrl("/kdo/kdo.s?id=" + p.getId() + "&kdo=" + p.getKdo().getId());
    return "/med/kdo/success";
  }

  @RequestMapping("/conf.s")
  protected String confirm(HttpServletRequest request) {
    Session session = SessionUtil.getUser(request);
    int planId = Req.getInt(request, "id");
    session.setCurUrl("/patients/list.s");
    LvPlans p = dLvPlan.get(planId);
    if (p.getResultId() > 0) {
      PatientPlans plan;
      try {
        plan = dPatientPlan.byPlan(p.getId());
      } catch (NoResultException e) {
        plan = new PatientPlans();
        plan.setPlan_Id(p.getId());
        plan.setActDate(p.getActDate());
        plan.setKdo_type_id(p.getKdoType().getId());
        plan.setPatient_id(p.getPatientId());
      }
      plan.setDone("Y");
      dPatientPlan.save(plan);
      p.setResDate(new Date());
      p.setDone("Y");
      p.setCrOn(new Date());
      dLvPlan.save(p);
      //dPatientDao.delPlan(p.getId());
    }
    //
    return "/med/kdo/success";
  }
  @RequestMapping("/print.s")
  protected String print(HttpServletRequest request, Model model){
    int id = Req.getInt(request, "id");
    model.addAttribute("patFio", dPatient.getFio(dLvPlan.get(id).getPatientId()));
    SessionUtil.addSession(request, "fontSize", "16");
    model.addAttribute("id", id);
    model.addAttribute("kdoId", dLvPlan.get(id).getKdo().getId());
    //
    return "/med/kdo/print";
  }

  @RequestMapping("/printPlans.s")
  protected String printPlans(HttpServletRequest request, Model model) {
    SessionUtil.addSession(request, "fontSize", "16");
    String[] ids = request.getParameterValues("id");
    List<ObjList> plans = new ArrayList<ObjList>();
    for(String id : ids) {
      ObjList obj = new ObjList();
      if(plans.size() == 0)
        model.addAttribute("patFio", dPatient.getFio(dLvPlan.get(Integer.parseInt(id)).getPatientId()));
      obj.setC1(id);
      obj.setC2("" + dLvPlan.get(Integer.parseInt(id)).getKdo().getId());
      plans.add(obj);
    }
    model.addAttribute("plans", plans);
    //
    return "/med/kdo/printPlans";
  }

  @RequestMapping("/kdo.s")
  protected String kdo(HttpServletRequest request, Model model){
    model.addAttribute("url", "/kdo/obs.s?id=" + request.getParameter("id") + "&kdo=" + request.getParameter("kdo"));
    return "/med/kdo/kdo";
  }

  @RequestMapping("/obs.s")
  protected String obs(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    SessionUtil.addSession(request, "fontSize", Req.get(request, "font", "12"));
    int planId = Req.getInt(request, "id");
    int kdo = Req.getInt(request, "kdo");
    session.setCurUrl("/kdo/kdo.s?id=" + planId + "&kdo=" + kdo);
    boolean isPrint = Req.isNull(request, "print");
    sKdo.createKdoModel(planId, model);
    model.addAttribute("print", isPrint);
    model.addAttribute("isArchive", session.isArchive());
    model.addAttribute("idx", Req.get(request, "idx"));
    LvPlans plan = dLvPlan.get(planId);
    //
    Util.makeMsg(request, model);
    Forms form = dForm.get(plan.getKdo().getFormId());
    String jsp = plan.getKdo().getId().toString();
    if(!"".equals(form.getJsp()) && form.getJsp() != null) jsp = form.getJsp();
    return "/med/kdo/" + (isPrint && !session.isArchive() ? "forms/fm/" : "print/fm/") + jsp;
  }

}
