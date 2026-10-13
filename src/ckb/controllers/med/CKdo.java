package ckb.controllers.med;

import ckb.dao.admin.forms.DForm;
import ckb.dao.admin.users.DUser;
import ckb.dao.med.kdos.forms.f999.DF999;
import ckb.dao.med.lv.plan.DLvPlan;
import ckb.dao.med.patient.DPatient;
import ckb.dao.med.patient.DPatientPlan;
import ckb.domains.admin.Forms;
import ckb.domains.med.kdo.F999;
import ckb.domains.med.lv.LvPlans;
import ckb.domains.med.patient.Patients;
import ckb.domains.med.patient.PatientPlans;
import ckb.models.ObjList;
import ckb.services.admin.form.SForm;
import ckb.services.med.kdo.SKdo;
import ckb.session.Session;
import ckb.session.SessionUtil;
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

import javax.persistence.NoResultException;
import javax.servlet.http.HttpServletRequest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Collections;
import java.util.Comparator;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
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
  @Autowired private DF999 df999;
  @Autowired private DUser dUser;

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
    confirmPlan(dLvPlan.get(planId));
    //
    return "/med/kdo/success";
  }

  // подтверждение результата: отметка в PatientPlans и в самом назначении
  private void confirmPlan(LvPlans p) {
    if (p.getResultId() != null && p.getResultId() > 0) {
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
      dLvPlan.save(p);
    }
  }

  // показатели с одним полем результата (бланки 777, 888): их можно вводить списком
  private static boolean isSingle(LvPlans p) {
    int f = p.getKdo().getFormId();
    return f == 777 || f == 888;
  }

  // ѕакетный ввод: все однопольные анализы пациента на одной странице, остальные бланки списком со ссылкой
  @RequestMapping("/batch.s")
  protected String batch(HttpServletRequest request, Model model) {
    Session session = SessionUtil.getUser(request);
    int id = Req.getInt(request, "id");
    Patients pat = dPatient.get(id);
    if(pat == null) return "redirect:/patients/list.s";
    session.setCurPat(id);
    session.setCurUrl("/kdo/batch.s?id=" + id);
    List<Integer> types = session.getKdoTypesIds();
    List<LvPlans> single = new ArrayList<LvPlans>(), other = new ArrayList<LvPlans>();
    for(LvPlans p : dLvPlan.getList("From LvPlans Where patientId = " + id + " Order By kdoType.id, actDate, id")) {
      if(!types.contains(p.getKdoType().getId())) continue;
      if(isSingle(p)) single.add(p); else other.add(p);
    }
    HashMap<Integer, String> vals = new HashMap<Integer, String>();
    if(!single.isEmpty())
      for(F999 f : df999.getList("From F999 Where patientId = " + id)) vals.put(f.getId(), f.getC1());
    model.addAttribute("p", pat);
    model.addAttribute("single", single);
    model.addAttribute("other", other);
    model.addAttribute("vals", vals);
    return "/med/kdo/batch";
  }

  // типы  ƒќ пользовател€ дл€ SQL: "1,2,18"; пусто Ч нет доступных типов
  private static String typeIds(Session session) {
    String ids = session.getKdoTypesIds().toString();
    return ids.substring(1, ids.length() - 1).replace(" ", "");
  }

  // ¬вод по услугам: лабораторные услуги, назначенные текущим пациентам (не в архиве), с количеством назначений.
  // «аключени€ (бланки 999, 889) сюда не вход€т.
  @RequestMapping("/services.s")
  protected String services(HttpServletRequest request, Model model) {
    Session session = SessionUtil.getUser(request);
    session.setCurPat(0); // вне карточки пациента: левое меню видно
    session.setCurUrl("/kdo/services.s");
    List<ObjList> rows = new ArrayList<ObjList>();
    String ids = typeIds(session);
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    if(!ids.isEmpty()) try {
      conn = DB.getConnection();
      ps = conn.prepareStatement(
        "Select k.id, k.name, k.formId, t.id, t.name, Count(*), " +
        "       Sum(Case When Coalesce(p.Done_Flag, 'N') = 'Y' Then 0 Else 1 End), " +
        "       Sum(Case When Coalesce(p.Done_Flag, 'N') != 'Y' And p.Result_Id > 0 Then 1 Else 0 End) " +
        "  From lv_plans p Join kdos k On k.id = p.Kdo_Id Join kdo_types t On t.id = p.Kdo_Type_Id Join patients c On c.id = p.patientId " +
        " Where c.state != 'ARCH' And p.actDate <= CURRENT_TIMESTAMP() And k.formId Not In (999, 889) And p.Kdo_Type_Id In (" + ids + ") " +
        " Group By k.id, k.name, k.formId, t.id, t.name Order By t.id, k.name");
      rs = ps.executeQuery();
      while(rs.next()) {
        ObjList o = new ObjList();
        o.setC1(rs.getString(1));
        o.setC2(rs.getString(2));
        o.setC3(rs.getString(3));
        o.setC4(rs.getString(4));
        o.setC5(rs.getString(5));
        o.setC6(rs.getString(6));
        o.setC7(rs.getString(7));
        o.setC8(rs.getString(8));
        rows.add(o);
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn, ps, rs);
    }
    model.addAttribute("rows", rows);
    return "/med/kdo/services";
  }

  // ¬вод по одной услуге: все текущие пациенты с этой услугой на одной странице (вид пакетного ввода).
  // all=Y Ч вместе с подтверждЄнными
  @RequestMapping("/service.s")
  protected String service(HttpServletRequest request, Model model) {
    Session session = SessionUtil.getUser(request);
    int kdoId = Req.getInt(request, "kdo");
    boolean all = "Y".equals(request.getParameter("all"));
    session.setCurPat(0);
    session.setCurUrl("/kdo/service.s?kdo=" + kdoId + (all ? "&all=Y" : ""));
    String ids = typeIds(session);
    List<LvPlans> plans = ids.isEmpty() ? new ArrayList<LvPlans>() : dLvPlan.getList("From LvPlans t Where t.kdo.id = " + kdoId +
      " And t.actDate <= current_timestamp() And t.kdoType.id In (" + ids + ")" +
      " And t.patientId In (Select c.id From Patients c Where c.state != 'ARCH')" +
      (all ? "" : " And (t.isDone Is Null Or t.isDone != 'Y')") + " Order By t.actDate, t.id");
    final HashMap<Integer, Patients> pats = new HashMap<Integer, Patients>();
    HashMap<Integer, String> vals = new HashMap<Integer, String>();
    if(!plans.isEmpty()) {
      StringBuilder pids = new StringBuilder(), plids = new StringBuilder();
      for(LvPlans p : plans) {
        pids.append(pids.length() > 0 ? "," : "").append(p.getPatientId());
        plids.append(plids.length() > 0 ? "," : "").append(p.getId());
      }
      for(Patients pt : dPatient.getList("From Patients Where id In (" + pids + ")")) pats.put(pt.getId(), pt);
      if(isSingle(plans.get(0)))
        for(F999 f : df999.getList("From F999 Where plan_id In (" + plids + ")")) vals.put(f.getId(), f.getC1());
      // по алфавиту пациентов
      Collections.sort(plans, new Comparator<LvPlans>() {
        public int compare(LvPlans a, LvPlans b) {
          Patients x = pats.get(a.getPatientId()), y = pats.get(b.getPatientId());
          return Util.nvl(x == null ? "" : x.getFio()).compareToIgnoreCase(Util.nvl(y == null ? "" : y.getFio()));
        }
      });
    }
    List<LvPlans> single = new ArrayList<LvPlans>(), other = new ArrayList<LvPlans>();
    for(LvPlans p : plans) if(isSingle(p)) single.add(p); else other.add(p);
    model.addAttribute("svc", plans.isEmpty() ? null : plans.get(0).getKdo());
    model.addAttribute("svcId", kdoId);
    model.addAttribute("all", all);
    model.addAttribute("pats", pats);
    model.addAttribute("single", single);
    model.addAttribute("other", other);
    model.addAttribute("vals", vals);
    return "/med/kdo/batch";
  }

  // —охранение одного бланка из пакетного ввода: пол€ c1..cN бланка, как в обычной форме; confirm=Y Ч сразу подтвердить
  @RequestMapping(value = "/batch/form.s", method = RequestMethod.POST)
  @ResponseBody
  protected String batchForm(HttpServletRequest request) throws JSONException {
    JSONObject json = new JSONObject();
    Session session = SessionUtil.getUser(request);
    try {
      LvPlans p = dLvPlan.get(Req.getInt(request, "planId"));
      if(p == null || !session.getKdoTypesIds().contains(p.getKdoType().getId()))
        return Util.err(json, "ќбследование не найдено");
      // подтверждЄнный результат мен€етс€ только €вно (кнопка Ђ»справитьї на странице бланка)
      if("Y".equals(p.getDone()) && !"Y".equals(request.getParameter("fix"))) return Util.err(json, "–езультат уже подтверждЄн: " + p.getKdo().getName());
      if(!"Y".equals(request.getParameter("only_confirm"))) sKdo.save(p, request);
      if("Y".equals(request.getParameter("confirm"))) confirmPlan(dLvPlan.get(p.getId()));
      return Util.success(json);
    } catch (Exception e) {
      e.printStackTrace();
      return Util.err(json, e.getMessage());
    }
  }

  // —охранение пакетного ввода: id[] и val[] по строкам; confirm=Y Ч заполненные строки сразу подтверждаютс€.
  // ѕодтверждЄнные строки не мен€ютс€.
  @RequestMapping(value = "/batch/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String batchSave(HttpServletRequest request) throws JSONException {
    JSONObject json = new JSONObject();
    Session session = SessionUtil.getUser(request);
    try {
      String[] ids = request.getParameterValues("id");
      String[] vals = request.getParameterValues("val");
      boolean confirm = "Y".equals(request.getParameter("confirm"));
      List<Integer> types = session.getKdoTypesIds();
      int saved = 0, confirmed = 0;
      for(int i = 0; ids != null && vals != null && i < ids.length && i < vals.length; i++) {
        LvPlans p = dLvPlan.get(Integer.parseInt(ids[i]));
        if(p == null || !isSingle(p) || !types.contains(p.getKdoType().getId()) || "Y".equals(p.getDone())) continue;
        String val = vals[i] == null ? "" : vals[i].trim();
        F999 f = null;
        if(p.getResultId() != null && p.getResultId() > 0) f = df999.get(p.getResultId());
        if(f == null) {
          List<F999> old = df999.getList("From F999 Where plan_id = " + p.getId());
          if(!old.isEmpty()) f = old.get(0);
        }
        if(f == null) {
          if(val.isEmpty()) continue;
          f = new F999();
          f.setPatientId(p.getPatientId());
          f.setPlan_id(p.getId());
          f.setKdoId(p.getKdo().getId());
        }
        if(f.getId() == null || !val.equals(f.getC1() == null ? "" : f.getC1().trim())) {
          f.setC1(val);
          df999.saveAndReturn(f);
          p.setResultId(f.getId());
          p.setConfUser(session.getUserId());
          dLvPlan.save(p);
          saved++;
        }
        if(confirm && !val.isEmpty()) {
          confirmPlan(p);
          confirmed++;
        }
      }
      json.put("saved", saved);
      json.put("confirmed", confirmed);
      return Util.success(json);
    } catch (Exception e) {
      e.printStackTrace();
      return Util.err(json, e.getMessage());
    }
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

  // Ѕланк обследовани€ Ч нова€ страница: анализы (сам бланк фрагментом из /kdo/obs.s?frag=1)
  // и заключени€ 999 и 889 (протокол с форматированием + заключение). јрхив Ч стара€ страница во фрейме
  @RequestMapping("/kdo.s")
  protected String kdo(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    int id = Req.getInt(request, "id");
    model.addAttribute("url", "/kdo/obs.s?id=" + id + "&kdo=" + Req.getInt(request, "kdo"));
    LvPlans plan = dLvPlan.get(id);
    if(plan == null || session.isArchive()) return "/med/kdo/kdo";
    int f = plan.getKdo().getFormId();
    if(f == 999 || f == 889) {
      // как в старом бланке: без результата заключение начинаетс€ с шаблона услуги
      F999 r = plan.getResultId() != null && plan.getResultId() > 0 ? df999.get(plan.getResultId()) : null;
      model.addAttribute("text", true);
      model.addAttribute("c1", r != null ? Util.nvl(r.getC1()) : Util.nvl(plan.getKdo().getTemplate()));
      model.addAttribute("c2", r != null ? Util.nvl(r.getC2()) : "");
    }
    session.setCurUrl("/kdo/kdo.s?id=" + id + "&kdo=" + Req.getInt(request, "kdo"));
    model.addAttribute("plan", plan);
    model.addAttribute("p", dPatient.get(plan.getPatientId()));
    model.addAttribute("confFio", plan.getConfUser() != null && plan.getConfUser() > 0 && dUser.get(plan.getConfUser()) != null ? dUser.get(plan.getConfUser()).getFio() : "");
    return "/med/kdo/form";
  }

  @RequestMapping("/obs.s")
  protected String obs(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    SessionUtil.addSession(request, "fontSize", Req.get(request, "font", "12"));
    int planId = Req.getInt(request, "id");
    int kdo = Req.getInt(request, "kdo");
    // frag: бланк фрагментом дл€ пакетного ввода Ч текуща€ страница пользовател€ не мен€етс€
    boolean frag = !Req.isNull(request, "frag");
    model.addAttribute("frag", frag);
    if(!frag) session.setCurUrl("/kdo/kdo.s?id=" + planId + "&kdo=" + kdo);
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
