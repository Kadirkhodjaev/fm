package ckb.controllers.med;

import ckb.dao.admin.countery.DCountery;
import ckb.dao.admin.depts.DDept;
import ckb.dao.admin.params.DParam;
import ckb.dao.admin.region.DRegion;
import ckb.dao.admin.users.DUser;
import ckb.dao.med.eat.dict.table.DEatTable;
import ckb.dao.med.head_nurse.patient.DHNPatient;
import ckb.dao.med.kdos.DKdoTypes;
import ckb.dao.med.kdos.DKdos;
import ckb.dao.med.kdos.forms.f13.DF13;
import ckb.dao.med.lv.bio.DLvBio;
import ckb.dao.med.lv.consul.DLvConsul;
import ckb.dao.med.lv.coul.DLvCoul;
import ckb.dao.med.lv.drug.DLvDrug;
import ckb.dao.med.lv.fizio.DLvFizio;
import ckb.dao.med.lv.fizio.DLvFizioDate;
import ckb.dao.med.lv.form1.DLvForm1;
import ckb.dao.med.lv.form2.DLvForm2;
import ckb.dao.med.lv.form3.DLvForm3;
import ckb.dao.med.lv.form4.DLvForm4;
import ckb.dao.med.lv.form5.DLvForm5;
import ckb.dao.med.lv.form6.DLvForm6;
import ckb.dao.med.lv.form7.DLvForm7;
import ckb.dao.med.lv.garmon.DLvGarmon;
import ckb.dao.med.lv.plan.DLvPlan;
import ckb.dao.med.lv.torch.DLvTorch;
import ckb.dao.med.patient.*;
import ckb.domains.admin.KdoTypes;
import ckb.domains.admin.Kdos;
import ckb.domains.med.head_nurse.HNPatients;
import ckb.domains.med.kdo.F13;
import ckb.domains.med.lv.*;
import ckb.domains.med.patient.PatientPays;
import ckb.domains.med.patient.PatientWatchers;
import ckb.domains.med.patient.Patients;
import ckb.models.Menu;
import ckb.models.ObjList;
import ckb.services.med.patient.SPatient;
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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;
import java.util.concurrent.TimeUnit;

@Controller
@RequestMapping("/view")
public class CView {

  @Autowired DPatient dPatient;
  @Autowired DLvForm1 dLvForm1;
  @Autowired DLvForm2 dLvForm2;
  @Autowired DLvForm3 dLvForm3;
  @Autowired DLvForm4 dLvForm4;
  @Autowired DLvForm5 dLvForm5;
  @Autowired DLvForm6 dLvForm6;
  @Autowired DLvForm7 dLvForm7;
  @Autowired DLvPlan  dLvPlan;
  @Autowired DLvConsul dLvConsul;
  @Autowired SPatient sPatient;
  @Autowired DParam dParam;
  @Autowired DUser dUser;
  @Autowired DLvDrug dLvDrug;
  @Autowired DKdos dKdos;
  @Autowired DKdoTypes dKdoType;
  @Autowired DLvFizio dLvFizio;
  @Autowired DLvBio dLvBio;
  @Autowired DLvCoul dLvCoul;
  @Autowired DLvGarmon dLvGarmon;
  @Autowired DLvTorch dLvTorch;
  @Autowired DPatientWatchers dPatientWatchers;
  @Autowired DPatientPays dPatientPays;
  @Autowired DEatTable dEatTable;
  @Autowired DPatientEat dPatientEat;
  @Autowired private DPatientDrugDate dPatientDrugDate;
  @Autowired private DDept dDep;
  @Autowired private DLvFizioDate dLvFizioDate;
  @Autowired private DCountery dCountery;
  @Autowired private DRegion dRegion;
  @Autowired private DF13 df13;
  @Autowired private DHNPatient dhnPatient;

  @RequestMapping("/index.s")
  protected String main(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    int id = Req.getInt(request, "id");
    session.setCurPat(id);
    Patients pat = dPatient.get(session.getCurPat());
    session.setCurUrl("/view/index.s?id=" + id);
    //
    List<Menu> m = new ArrayList<Menu>();
    session.setCurSubUrl("/view/reg.s");
    m.add(new Menu("Регистация", "/view/reg.s", "fa fa-medkit fa-fw", false));
    //m.add(new Menu("Оплата", "/view/cashbox.s", "fa fa-money fa-fw", false));
    m.add(new Menu("Осмотр врача", "/view/osm.s", "fa fa-stethoscope fa-fw", false));
    if(dLvDrug.getPatientDrugs(session.getCurPat()).size() > 0)
      m.add(new Menu("Назначение", "/view/drug/index.s", "fa fa-th-list fa-fw", false));
    else
      m.add(new Menu("Назначение", "/view/drugs.s", "fa fa-th-list fa-fw", false));
    if(!pat.getState().equals("ARCH")) {
      m.add(new Menu(session.getRoleId() == 7 || session.getRoleId() == 9 || session.getRoleId() == 5 ? 10 : null, "Обследования", "/view/plan/index.s", "fa fa-flask fa-fw", false));
    } else {
      m.add(new Menu("Обследования", "/view/plan/index.s", "fa fa-flask fa-fw", false));
    }
    m.add(new Menu("Консультация", "/view/consul.s", "fa fa-stethoscope fa-fw", false));
    m.add(new Menu("Физиотерапия", "/view/fizio/index.s", "fa fa-asterisk fa-fw", false));
    m.add(new Menu("Дневник", "/view/dairy.s", "fa fa-calendar fa-fw", false));
    m.add(new Menu("Обоснование", "/view/obos.s", "fa fa-retweet fa-fw", false));
    m.add(new Menu("Выписка", "/view/vypiska.s", "fa fa-check fa-fw", false));
    m.add(new Menu("Переводной эпикриз", "/view/epic.s", "fa fa-random fa-fw", false));
    m.add(new Menu("Дополнительные данные", "/view/extra.s", "fa fa-plus-square fa-fw", false));
    model.addAttribute("menuList", m);
    model.addAttribute("id", id);
    model.addAttribute("p", dPatient.get(session.getCurPat()));
    model.addAttribute("formUrl", session.getCurSubUrl());
    model.addAttribute("backUrl", session.getBackUrl());
    model.addAttribute("roleId", session.getRoleId());
    return "/med/lv/index";
  }

  @RequestMapping("/reg.s")
  protected String reg(HttpServletRequest request){
    Session session = SessionUtil.getUser(request);
    session.setCurSubUrl("/view/reg.s");
    return "/med/lv/reg";
  }

  @RequestMapping("/firstView.s")
  protected String firstView(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    session.setCurSubUrl("/lv/firstView.s");
    Patients pat = dPatient.get(session.getCurPat());
    model.addAttribute("p", pat);
    model.addAttribute("lvFio", dUser.get(pat.getLv_id()).getFio());
    return "/med/lv/" + (Req.isNull(request, "print") ? "" : "print/" + (session.isParamEqual("CLINIC_CODE", "fm") ? "fm/" : "")) + "firstView";
  }

  @RequestMapping("/osm.s")
  protected String osm(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    if(Req.isNull(request, "print"))
      session.setCurSubUrl("/view/osm.s");
    //
    LvForm1 f = dLvForm1.getByPatient(session.getCurPat());
    if(f != null) {
      f.setC1(Util.nvl(f.getC1()).replaceAll("&nbsp;"," "));
      f.setC2(Util.nvl(f.getC2()).replaceAll("&nbsp;"," "));
      f.setC3(Util.nvl(f.getC3()).replaceAll("&nbsp;"," "));
      f.setC4(Util.nvl(f.getC4()).replaceAll("&nbsp;"," "));
      f.setC5(Util.nvl(f.getC5()).replaceAll("&nbsp;"," "));
      f.setC6(Util.nvl(f.getC6()).replaceAll("&nbsp;"," "));
      f.setC7(Util.nvl(f.getC7()).replaceAll("&nbsp;"," "));
      f.setC8(Util.nvl(f.getC8()).replaceAll("&nbsp;"," "));
      f.setC9(Util.nvl(f.getC9()).replaceAll("&nbsp;"," "));
      f.setC10(Util.nvl(f.getC10()).replaceAll("&nbsp;"," "));
      f.setC11(Util.nvl(f.getC11()).replaceAll("&nbsp;"," "));
      f.setC12(Util.nvl(f.getC12()).replaceAll("&nbsp;"," "));
      f.setC13(Util.nvl(f.getC13()).replaceAll("&nbsp;"," "));
      f.setC14(Util.nvl(f.getC14()).replaceAll("&nbsp;"," "));
      f.setC15(Util.nvl(f.getC15()).replaceAll("&nbsp;"," "));
      f.setC16(Util.nvl(f.getC16()).replaceAll("&nbsp;"," "));
      f.setC17(Util.nvl(f.getC17()).replaceAll("&nbsp;"," "));
      f.setC18(Util.nvl(f.getC18()).replaceAll("&nbsp;"," "));
      f.setC19(Util.nvl(f.getC19()).replaceAll("&nbsp;"," "));
      model.addAttribute("lvFio", dUser.get(f.getPatient().getLv_id()).getFio());
    }
    model.addAttribute("form", f);
    return "/med/lv/" + (Req.isNull(request, "print") ? "view" : "print"  + (session.isParamEqual("CLINIC_CODE", "fm") ? "/fm" : "")) + "/osm";
  }
  // Обоснование
  @RequestMapping("/obos.s")
  protected String obos(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    if(Req.isNull(request, "print"))
      session.setCurSubUrl("/view/obos.s");
    //
    LvForm2 f = dLvForm2.getByPatient(session.getCurPat());
    if(f != null) {
      f.setC1(f.getC1().replaceAll("&nbsp;"," "));
      f.setC2(f.getC2().replaceAll("&nbsp;"," "));
      f.setC3(f.getC3().replaceAll("&nbsp;"," "));
      f.setC4(f.getC4().replaceAll("&nbsp;"," "));
      f.setC5(f.getC5().replaceAll("&nbsp;"," "));
      f.setC6(Util.nvl(f.getC6()).replaceAll("&nbsp;"," "));
      f.setC7(Util.nvl(f.getC7()).replaceAll("&nbsp;"," "));
      f.setC8(Util.nvl(f.getC8()).replaceAll("&nbsp;"," "));
      model.addAttribute("lvFio", dUser.get(f.getPatient().getLv_id()).getFio());
    }
    //
    model.addAttribute("form", f);
    model.addAttribute("zavOtdel", dUser.getZavOtdel(dPatient.get(session.getCurPat()).getDept().getId()));
    return "/med/lv/" + (Req.isNull(request, "print") ? "view" : "print" + (session.isParamEqual("CLINIC_CODE", "fm") ? "/fm" : "")) + "/obos";
  }
  // Предоперационный эпикрез
  @RequestMapping("/predoper.s")
  protected String predoper(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    if(Req.isNull(request, "print"))
      session.setCurSubUrl("/view/predoper.s");
    //
    LvForm7 f = dLvForm7.getByPatient(session.getCurPat());
    if(f != null) {
      f.setC1(f.getC1().replaceAll("&nbsp;"," "));
      f.setC2(f.getC2().replaceAll("&nbsp;"," "));
      f.setC3(f.getC3().replaceAll("&nbsp;"," "));
      f.setC4(f.getC4().replaceAll("&nbsp;"," "));
      f.setC5(f.getC5().replaceAll("&nbsp;"," "));
      model.addAttribute("lvFio", dUser.get(f.getPatient().getLv_id()).getFio());
    }
    //
    model.addAttribute("form", f);
    return "/med/lv/" + (Req.isNull(request, "print") ? "view" : "print" + (session.isParamEqual("CLINIC_CODE", "fm") ? "/fm" : "")) + "/predoper";
  }
  // Дневник
  @RequestMapping("/dairy.s")
  protected String dnevnikIndex(HttpServletRequest request, Model model) {
    Session session = SessionUtil.getUser(request);
    List<ObjList> dairies = sPatient.getDairies(session.getCurPat());
    List<ObjList> list = dairies;

    String dairyId = Util.nvl(SessionUtil.getSession(request, "dairyId"));
    String dairyIds = Util.nvl(SessionUtil.getSession(request, "dairyIds"));
    if(!"".equals(dairyId)) {
      list = new ArrayList<ObjList>();
      for(ObjList obj : dairies)
        if(obj.getC1().equals(dairyId))
           list.add(obj);
    }
    if(!"".equals(Util.nvl(dairyIds))) {
      list = new ArrayList<ObjList>();
      for(ObjList obj : dairies)
        if(dairyIds.contains(obj.getC1() + ","))
          list.add(obj);
    }
    if(Req.isNull(request, "print"))
      session.setCurSubUrl("/view/dairy.s");
    model.addAttribute("pat", dPatient.get(session.getCurPat()));
    model.addAttribute("dairies", list);
    return "/med/lv/" + (Req.isNull(request, "print") ? "view" : ("print" + (session.isParamEqual("CLINIC_CODE", "fm") ? "/fm" : ""))) + "/dairy";
  }
  // Совместный осмотр
  @RequestMapping("/sov.s")
  protected String sov(@ModelAttribute("sov") LvForm3 sov, HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    if(Req.isNull(request, "print"))
      session.setCurSubUrl("/view/sov.s");
    //
    LvForm3 f = dLvForm3.getByPatient(session.getCurPat());
    if(f != null) {
      f.setC1(f.getC1().replaceAll("&nbsp;"," "));
      f.setC2(f.getC2().replaceAll("&nbsp;"," "));
      f.setC3(f.getC3().replaceAll("&nbsp;"," "));
      f.setC4(f.getC4().replaceAll("&nbsp;"," "));
      f.setC5(f.getC5().replaceAll("&nbsp;"," "));
      f.setC6(f.getC6().replaceAll("&nbsp;"," "));
      model.addAttribute("zavOtdel", dUser.getZavOtdel(f.getPatient().getDept().getId()));
      model.addAttribute("lvFio", dUser.get(f.getPatient().getLv_id()).getFio());
    }
    model.addAttribute("glb", dParam.byCode("GLB"));
    model.addAttribute("zamGlb", dParam.byCode("GLB_NEXT"));
    //
    model.addAttribute("form", f);
    return "/med/lv/" + (Req.isNull(request, "print") ? "view" : "print" + (session.isParamEqual("CLINIC_CODE", "fm") ? "/fm" : "")) + "/sov";
  }
  // Консультация
  @RequestMapping("/consul.s")
  protected String konsulIndex(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    if(Req.isNull(request, "print"))
      session.setCurSubUrl("/view/consul.s");
    // Копируем консультацию
    if(!Req.isNull(request, "copy")) {
      LvConsuls c = dLvConsul.get(Req.getInt(request, "id"));
      c.setId(null);
      c.setDate(Util.getCurDate());
      c.setText("");
      c.setCopied("Y");
      dLvConsul.save(c);
    }
    // Удаляем консультацию
    if(!Req.isNull(request, "del")) {
      if(dLvConsul.get(Req.getInt(request, "id")).getCopied().equals("Y"))
        dLvConsul.delete(Req.getInt(request, "id"));
    }
    model.addAttribute("pat", dPatient.get(session.getCurPat()));
    List<LvConsuls> cls = dLvConsul.getUserConsul(session.getUserId(), session.getCurPat());
    List<LvConsuls> consuls = dLvConsul.getByPat(session.getCurPat());
    List<LvConsuls> list = new ArrayList<LvConsuls>();
    String consulId = SessionUtil.getSession(request, "consulId");

    if (!Req.isNull(request, "print") && !consulId.equals("")) {
      for (LvConsuls consul : consuls) {
        if (consul.getId().toString().equals(consulId)) {
          list.add(consul);
          break;
        }
      }
    } else {
      if (cls.size() > 0 && Req.isNull(request, "print")) {
        for (LvConsuls consul : consuls) {
          boolean isExist = true;
          for (LvConsuls cl : cls)
            if (cl.getId().equals(consul.getId())) {
              isExist = false;
              break;
            }
          if (isExist)
            list.add(consul);
        }
      } else {
        list = consuls;
      }
    }
    model.addAttribute("consulFlag", cls.size() > 0);
    model.addAttribute("cls", cls);
    model.addAttribute("consuls", list);
    Util.getMsg(request, model);
    return "/med/lv/" + (Req.isNull(request, "print") ? "view" : "print" + (session.isParamEqual("CLINIC_CODE", "fm") ? "/fm" : "")) + "/consul";
  }
  // Выписка
  @RequestMapping("/vypiska.s")
  protected String vypiska(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    if(Req.isNull(request, "print"))
      session.setCurSubUrl("/view/vypiska.s");
    //
    LvForm4 f = dLvForm4.getByPatient(session.getCurPat());
    //
    if(f != null) {
      //
      f.setC1(f.getC1().replaceAll("&nbsp;"," "));
      f.setC2(f.getC2().replaceAll("&nbsp;"," "));
      f.setC3(f.getC3().replaceAll("&nbsp;"," "));
      f.setC4(f.getC4().replaceAll("&nbsp;"," "));
      f.setC5(f.getC5().replaceAll("&nbsp;"," "));
      f.setC6(f.getC6().replaceAll("&nbsp;"," "));
      f.setC7(f.getC7().replaceAll("&nbsp;"," "));
      f.setC8(Util.nvl(f.getC8()).replaceAll("&nbsp;"," "));
      f.setC9(Util.nvl(f.getC9()).replaceAll("&nbsp;"," "));
      //
      model.addAttribute("form", f);
      model.addAttribute("lvFio", dUser.get(f.getPatient().getLv_id()).getFio());
      model.addAttribute("dateBegin", Util.dateToString(f.getPatient().getDateBegin()));
      model.addAttribute("dateEnd", Util.dateToString(f.getPatient().getDateEnd()));
      model.addAttribute("zavOtdel", dUser.getZavOtdel(f.getPatient().getDept().getId()));
    }
    model.addAttribute("dieFlag", dLvForm6.getByPatient(session.getCurPat()).getC4() != null);
    model.addAttribute("zamGlb", dParam.byCode("GLB_NEXT"));
    if(Util.get(request, "diagnoz") != null)
      return "/med/lv/view/diagnoz";
    return "/med/lv/" + (Req.isNull(request, "print") ? "view" : "print" + (session.isParamEqual("CLINIC_CODE", "fm") ? "/fm" : "")) + "/vypiska";
  }

  // План обследовании
  @RequestMapping("/plan/index.s")
  protected String planIndex(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    if(Req.isNull(request, "print"))
      session.setCurSubUrl("/view/plan/index.s");
    model.addAttribute("pat", dPatient.get(session.getCurPat()));
    model.addAttribute("plans", sPatient.getPlans(session.getCurPat()));
    List<LvConsuls> list = new ArrayList<LvConsuls>();
    List<LvConsuls> cons = dLvConsul.getByPat(session.getCurPat());
    for(LvConsuls con : cons) {
      if(con.getText() == null || con.getText().equals("")) {
        try {
          con.setCopied(dUser.get(con.getLvId()).getProfil());
          list.add(con);
        } catch (Exception e) {
          con.setCopied("");
          list.add(con);
        }
      }
    }
    model.addAttribute("consuls", list);
    if(session.getRoleId() == 7) {
      return "redirect:/lv/plan/index.s";
    }
    return "/med/lv/" + (Req.isNull(request, "print") ? "view" : "print" + (session.isParamEqual("CLINIC_CODE", "fm") ? "/fm" : "")) + "/plan";
  }
  // Физиотерапия
  @RequestMapping("/fizio/index.s")
  protected String fizio(HttpServletRequest req, Model model){
    Session session = SessionUtil.getUser(req);
    session.setCurSubUrl("/view/fizio/index.s");
    Date end;
    String action = Util.get(req, "action");
    Patients pat = dPatient.get(session.getCurPat());
    List<LvFizios> fizios = dLvFizio.getList("From LvFizios Where patientId = " + pat.getId());
    List<ObjList> printFizio = new ArrayList<ObjList>();
    for(LvFizios fizio: fizios) {
      ObjList d = new ObjList();
      d.setC1(fizio.getKdo().getName());
      d.setC2(fizio.getOblast());
      d.setC3(fizio.getComment());
      d.setCounter(dLvFizioDate.getStateCount(fizio.getId()));
      d.setC4(d.getCounter().toString());
      fizio.setCount(Integer.parseInt(d.getCounter().toString()));
      d.setPrice(fizio.getPrice());
      d.setId(fizio.getId());
      printFizio.add(d);
    }
    model.addAttribute("pfizios", printFizio);
    model.addAttribute("fizios", fizios);
    model.addAttribute("pat", pat);
    //
    end = dLvFizioDate.getPatientMaxDay(pat.getId());
    if(action != null && end != null) {
      if(action.equals("add")) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(end);
        cal.add(Calendar.DATE, 1);
        end = cal.getTime();
        for(LvFizios fizio: fizios) {
          LvFizioDates dd = new LvFizioDates();
          dd.setFizio(fizio);
          dd.setDone("N");
          dd.setState("N");
          dd.setDate(end);
          dLvFizioDate.save(dd);
        }
      } else {
        for(LvFizios fizio: fizios)
          dLvFizioDate.delDateFizio(Util.dateDB(Util.dateToString(end)), fizio.getId());
        Calendar cal = Calendar.getInstance();
        cal.setTime(end);
        cal.add(Calendar.DATE, -1);
        end = cal.getTime();
      }
    }
    if(end == null) {
      Calendar cal = Calendar.getInstance();
      cal.setTime(pat.getDateBegin());
      cal.add(Calendar.DATE, 10);
      end = cal.getTime();
    }
    if(pat.getDateBegin().after(end) || pat.getDateBegin().equals(end)) {
      return "redirect:/view/fizio/index.s";
    }
    List<LvFizioDates> dates = new ArrayList<LvFizioDates>();
    int i = 0;
    while(true) {
      LvFizioDates date = new LvFizioDates();
      Calendar cl = Calendar.getInstance();
      cl.setTime(pat.getDateBegin());
      cl.add(Calendar.DATE, i++);
      date.setDate(cl.getTime());
      date.setDone("N");
      date.setState("N");
      dates.add(date);
      if(cl.getTime().equals(end)) break;
    }
    model.addAttribute("dates", dates);
    HashMap<Integer, List<LvFizioDates>> ds = new HashMap<Integer, List<LvFizioDates>>();
    for(LvFizios fizio: fizios) {
      if(dLvFizioDate.getCount("From LvFizioDates Where fizio.id = " + fizio.getId()) == 0)
        ds.put(fizio.getId(), dates);
       else
        ds.put(fizio.getId(), dLvFizioDate.getList("From LvFizioDates Where fizio.id = " + fizio.getId()));
    }
    model.addAttribute("ds", ds);
    return "/med/lv/" + (Req.isNull(req, "print") ? "view" : "print") + "/fizio_date";
  }
  // Физиотерапия список
  @RequestMapping("/fizio/list.s")
  protected String fizioList(HttpServletRequest request, Model model) {
    model.addAttribute("fizios", dKdos.getTypeKdos(8));
    return "/med/lv/fizio/list";
  }
  // Добавить
  @RequestMapping(value = "/fizio/set.s", method = RequestMethod.POST)
  @ResponseBody
  protected String addFizio(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    String[] ids = request.getParameterValues("ids");
    Patients patient = dPatient.get(session.getCurPat());
    for(String id : ids) {
      LvFizios fizios = new LvFizios();
      Kdos kdo = dKdos.get(Integer.parseInt(id));
      fizios.setPatientId(session.getCurPat());
      fizios.setKdo(kdo);
      fizios.setUserId(session.getUserId());
      fizios.setActDate(new Date());
      fizios.setPaid("N");
      fizios.setCount(0);
      fizios.setPaidSum(0D);
      fizios.setPaidCount(0);
      fizios.setPrice(patient.getCounteryId() == 199 ? kdo.getPrice() : kdo.getFor_price());
      fizios.setFizei(kdo.getFizei() != null ? Double.parseDouble(kdo.getFizei().replace(",", ".")) : null);
      dLvFizio.save(fizios);
    }
    return "{}";
  }
  // Удалить
  @RequestMapping(value = "/fizio/delete.s", method = RequestMethod.POST)
  @ResponseBody
  protected String delFizio(HttpServletRequest request) throws JSONException {
    LvFizios fizio = dLvFizio.get(Util.getInt(request, "id"));
    Integer patId = fizio.getPatientId();
    dLvFizioDate.delFizio(fizio.getId());
    dLvFizio.delete(fizio.getId());
    JSONObject res = new JSONObject();
    res.put("counter", dLvFizio.getCount("From LvFizios Where patientId = " + patId));
    res.put("msg", "Данные успешно удалены");
    return res.toString();
  }
  // Сохранить
  @RequestMapping(value = "/fizio/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String saveFizio(HttpServletRequest request) throws JSONException {
    String[] ids = request.getParameterValues("id");
    String[] fizeis = request.getParameterValues("fizei");
    String[] oblast = request.getParameterValues("oblast");
    String[] comments = request.getParameterValues("comment");
    for(int i = 0;i<ids.length;i++) {
      LvFizios fizios = dLvFizio.get(Integer.parseInt(ids[i]));
      //dLvFizioDate.delFizio(fizios.getId());
      //fizios.setCount(Integer.parseInt(counts[i]));
      fizios.setOblast(oblast[i]);
      fizios.setComment(comments[i]);
      fizios.setFizei(Double.parseDouble(fizeis[i]));
      dLvFizio.save(fizios);
      String[] dates = request.getParameterValues("date_" + fizios.getId());
      int counter = 0;
      for(String date: dates) {
        LvFizioDates dd = new LvFizioDates();
        dd.setDone("N");
        if(dLvFizioDate.getCount("From LvFizioDates Where fizio.id = " + fizios.getId() + " And date = '" + Util.dateDB(date) + "'") > 0) {
          dd = dLvFizioDate.getObj("From LvFizioDates Where fizio.id = " + fizios.getId() + " And date = '" + Util.dateDB(date) + "'");
        }
        dd.setState(Util.get(request, "fizio_" + fizios.getId() + "_" + date) == null ? "N" : "Y");
        if (dd.getState().equals("Y")) counter++;
        if(dd.getDone().equals("N")) {
          dd.setDate(Util.stringToDate(date));
          dd.setFizio(fizios);
          dLvFizioDate.save(dd);
        }
      }
      fizios.setCount(counter);
      dLvFizio.save(fizios);
    }
    JSONObject res = new JSONObject();
    res.put("msg", "Данные успешно сохранены");
    return res.toString();
  }
  @RequestMapping("/drugs.s")
  protected String drugs(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    model.addAttribute("tabs", sPatient.getDrugsByType(session.getCurPat(), 15));
    model.addAttribute("ines", sPatient.getDrugsByType(session.getCurPat(), 16));
    Date minDate = dPatientDrugDate.minDate(session.getCurPat());
    Date maxDate = dPatientDrugDate.maxDate(session.getCurPat());
    if(minDate != null) {
      long diffInMillies = Math.abs(maxDate.getTime() - minDate.getTime());
      long diff = TimeUnit.DAYS.convert(diffInMillies, TimeUnit.MILLISECONDS) + 2;
      model.addAttribute("dates", Util.getDateList(minDate, (int) (diff)));
    }
    Patients pat = dPatient.get(session.getCurPat());
    model.addAttribute("pat", pat);
    model.addAttribute("lv", dUser.get(pat.getLv_id()).getFio());
    model.addAttribute("tableNum", dPatientEat.minTable(pat.getId()));
    return "/med/lv/" + (Req.isNull(request, "print") ? "view" : "print") + "/drugs";
  }
  // Назначение
  @RequestMapping("/drug/index.s")
  protected String naznachIndex(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    List<LvDrugs> list = dLvDrug.getPatientTabs(session.getCurPat());
    List<LvDrugs> drugs = new ArrayList<LvDrugs>();
    for(LvDrugs drug : list) {
      drug.setCat("Таблетка");
      drugs.add(drug);
    }
    model.addAttribute("tabs", drugs);
    list = dLvDrug.getPatientInes(session.getCurPat());
    drugs = new ArrayList<LvDrugs>();
    for(LvDrugs drug : list) {
      if(drug.getCat().equals("ine-ven")) drug.setCat("Вена ичига");
      if(drug.getCat().equals("ine-mus")) drug.setCat("Мускул орасига");
      if(drug.getCat().equals("ine-ter")) drug.setCat("Тери остига");
      if(drug.getCat().equals("ine-tic")) drug.setCat("Тери ичига");
      if(drug.getCat().equals("ine-suy")) drug.setCat("Суяк ичига");
      if(drug.getCat().equals("ine-art")) drug.setCat("Артерия ичига");
      drugs.add(drug);
    }
    model.addAttribute("ines", drugs);
    Date minDate = dLvDrug.minDate(session.getCurPat());
    if(minDate != null)
      model.addAttribute("dates", Util.getDateList(minDate, 12));
    Patients pat = dPatient.get(session.getCurPat());
    model.addAttribute("pat", pat);
    model.addAttribute("lv", dUser.get(pat.getLv_id()).getFio());
    return "/med/lv/" + (Req.isNull(request, "print") ? "view" : "print" + (session.isParamEqual("CLINIC_CODE", "fm") ? "/fm" : "")) + "/drug";
  }
  // Назначение
  @RequestMapping("/drug/obos.s")
  protected String naznachObos(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    model.addAttribute("list", sPatient.getPatientDrugs(session.getCurPat()));
    Patients pat = dPatient.get(session.getCurPat());
    model.addAttribute("lvFio", dUser.get(pat.getLv_id()).getFio());
    model.addAttribute("zavOtdel", dUser.getZavOtdel(pat.getDept().getId()).getFio());
    model.addAttribute("pat", pat);
    return "/med/lv/" + (Req.isNull(request, "print") ? "view" : "print") + "/drugObos";
  }
  // Протокол операции
  @RequestMapping("/prot.s")
  protected String prot(@ModelAttribute("prot") LvForm5 prot, HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    if(Req.isNull(request, "print"))
      session.setCurSubUrl("/view/prot.s");
    LvForm5 form = dLvForm5.getByPatient(session.getCurPat());
    model.addAttribute("form", form);
    if(form != null) {
      model.addAttribute("operDate", Util.dateToString(form.getOperDate()));
      model.addAttribute("lvFio", dUser.get(form.getPatient().getLv_id()).getFio());
    }
    return "/med/lv/" + (Req.isNull(request, "print") ? "view" : "print" + (session.isParamEqual("CLINIC_CODE", "fm") ? "/fm" : "")) + "/prot";
  }
  // Переводной эпикриз
  @RequestMapping("/epic.s")
  protected String epic(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    if(Req.isNull(request, "print"))
      session.setCurSubUrl("/view/epic.s");
    model.addAttribute("epics", sPatient.getEpicGrid(session.getCurPat()));
    model.addAttribute("patient", dPatient.get(session.getCurPat()));
    return "/med/lv/" + (Req.isNull(request, "print") ? "view" : "print" + (session.isParamEqual("CLINIC_CODE", "fm") ? "/fm" : "")) + "/epic";
  }
  // Дополнительные данные
  @RequestMapping("/extra.s")
  protected String extra(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    if(Req.isNull(request, "print"))
      session.setCurSubUrl("/view/extra.s");
    Patients pat = dPatient.get(session.getCurPat());
    model.addAttribute("obos", dLvForm2.getByPatient(session.getCurPat()));
    model.addAttribute("vyp", dLvForm4.getByPatient(session.getCurPat()));
    model.addAttribute("lv", dUser.get(pat.getLv_id()).getFio());
    model.addAttribute("zavOtdel", dUser.getZavOtdel(pat.getLv_dept_id()).getFio());
    return "/med/lv/" + (Req.isNull(request, "print") ? "view" : "print" + (session.isParamEqual("CLINIC_CODE", "fm") ? "/fm" : "")) + "/extra";
  }
  // Статистика отделения
  @RequestMapping("/stat.s")
  protected String stat(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    session.setCurUrl("/view/stat.s");
    session.setCurSubUrl("");
    model.addAttribute("c1", dPatient.getCount("From Patients Where state = 'LV' And lv_id = " + session.getUserId()));
    model.addAttribute("c2", dPatient.getCount("From Patients Where YEAR(dateEnd) = YEAR(CURRENT_TIMESTAMP()) And MONTH(dateEnd) = MONTH(CURRENT_TIMESTAMP()) And lv_id = " + session.getUserId()));
    model.addAttribute("c3", dPatient.getCount("From Patients Where YEAR(dateEnd) = YEAR(CURRENT_TIMESTAMP()) And MONTH(dateEnd) = MONTH(CURRENT_TIMESTAMP()) - 1 And lv_id = " + session.getUserId()));
    model.addAttribute("c4", dPatient.getCount("From Patients Where YEAR(dateEnd) = YEAR(CURRENT_TIMESTAMP()) And lv_id = " + session.getUserId()));
    model.addAttribute("c5", dPatient.getCount("From Patients Where YEAR(dateEnd) = YEAR(CURRENT_TIMESTAMP()) - 1 And lv_id = " + session.getUserId()));
    model.addAttribute("c6", dPatient.getCount("From Patients Where DATE(dateEnd) = DATE(CURRENT_TIMESTAMP()) And lv_id = " + session.getUserId()));
    model.addAttribute("c7", dPatient.getCount("From Patients Where DATE(dateBegin) = DATE(current_date()) And lv_id = " + session.getUserId()));

    model.addAttribute("c8", dPatient.getCount("From Patients Where room.roomType.id = 5 And YEAR(dateEnd) = YEAR(CURRENT_TIMESTAMP()) And MONTH(dateEnd) = MONTH(CURRENT_TIMESTAMP()) And lv_id = " + session.getUserId()));
    model.addAttribute("c9", dPatient.getCount("From Patients Where room.roomType.id = 6 And YEAR(dateEnd) = YEAR(CURRENT_TIMESTAMP()) And MONTH(dateEnd) = MONTH(CURRENT_TIMESTAMP()) And lv_id = " + session.getUserId()));
    model.addAttribute("c10", dPatient.getCount("From Patients Where room.roomType.id = 7 And YEAR(dateEnd) = YEAR(CURRENT_TIMESTAMP()) And MONTH(dateEnd) = MONTH(CURRENT_TIMESTAMP()) And lv_id = " + session.getUserId()));

    model.addAttribute("c11", dPatient.getKoykoCount("From Patients Where room.roomType.id = 5 And YEAR(dateEnd) = YEAR(CURRENT_TIMESTAMP()) And MONTH(dateEnd) = MONTH(CURRENT_TIMESTAMP()) And lv_id = " + session.getUserId()));
    model.addAttribute("c12", dPatient.getKoykoCount("From Patients Where room.roomType.id = 6 And YEAR(dateEnd) = YEAR(CURRENT_TIMESTAMP()) And MONTH(dateEnd) = MONTH(CURRENT_TIMESTAMP()) And lv_id = " + session.getUserId()));
    model.addAttribute("c13", dPatient.getKoykoCount("From Patients Where room.roomType.id = 7 And YEAR(dateEnd) = YEAR(CURRENT_TIMESTAMP()) And MONTH(dateEnd) = MONTH(CURRENT_TIMESTAMP()) And lv_id = " + session.getUserId()));

    model.addAttribute("c11_UZB", dPatient.getKoykoCount("From Patients Where counteryId = 199 And room.roomType.id = 5 And YEAR(dateEnd) = YEAR(CURRENT_TIMESTAMP()) And MONTH(dateEnd) = MONTH(CURRENT_TIMESTAMP()) And lv_id = " + session.getUserId()));
    model.addAttribute("c12_UZB", dPatient.getKoykoCount("From Patients Where counteryId = 199 And room.roomType.id = 6 And YEAR(dateEnd) = YEAR(CURRENT_TIMESTAMP()) And MONTH(dateEnd) = MONTH(CURRENT_TIMESTAMP()) And lv_id = " + session.getUserId()));
    model.addAttribute("c13_UZB", dPatient.getKoykoCount("From Patients Where counteryId = 199 And room.roomType.id = 7 And YEAR(dateEnd) = YEAR(CURRENT_TIMESTAMP()) And MONTH(dateEnd) = MONTH(CURRENT_TIMESTAMP()) And lv_id = " + session.getUserId()));

    model.addAttribute("c28", dPatient.getCount("From Patients Where room.roomType.id = 5 And YEAR(dateEnd) = YEAR(CURRENT_TIMESTAMP()) And MONTH(dateEnd) = MONTH(CURRENT_TIMESTAMP()) - 1 And lv_id = " + session.getUserId()));
    model.addAttribute("c29", dPatient.getCount("From Patients Where room.roomType.id = 6 And YEAR(dateEnd) = YEAR(CURRENT_TIMESTAMP()) And MONTH(dateEnd) = MONTH(CURRENT_TIMESTAMP()) - 1 And lv_id = " + session.getUserId()));
    model.addAttribute("c30", dPatient.getCount("From Patients Where room.roomType.id = 7 And YEAR(dateEnd) = YEAR(CURRENT_TIMESTAMP()) And MONTH(dateEnd) = MONTH(CURRENT_TIMESTAMP()) - 1 And lv_id = " + session.getUserId()));

    model.addAttribute("c31", dPatient.getKoykoCount("From Patients Where room.roomType.id = 5 And YEAR(dateEnd) = YEAR(CURRENT_TIMESTAMP()) And MONTH(dateEnd) = MONTH(CURRENT_TIMESTAMP()) - 1 And lv_id = " + session.getUserId()));
    model.addAttribute("c32", dPatient.getKoykoCount("From Patients Where room.roomType.id = 6 And YEAR(dateEnd) = YEAR(CURRENT_TIMESTAMP()) And MONTH(dateEnd) = MONTH(CURRENT_TIMESTAMP()) - 1 And lv_id = " + session.getUserId()));
    model.addAttribute("c33", dPatient.getKoykoCount("From Patients Where room.roomType.id = 7 And YEAR(dateEnd) = YEAR(CURRENT_TIMESTAMP()) And MONTH(dateEnd) = MONTH(CURRENT_TIMESTAMP()) - 1 And lv_id = " + session.getUserId()));

    model.addAttribute("c31_UZB", dPatient.getKoykoCount("From Patients Where counteryId = 199 And room.roomType.id = 5 And YEAR(dateEnd) = YEAR(CURRENT_TIMESTAMP()) And MONTH(dateEnd) = MONTH(CURRENT_TIMESTAMP()) - 1 And lv_id = " + session.getUserId()));
    model.addAttribute("c32_UZB", dPatient.getKoykoCount("From Patients Where counteryId = 199 And room.roomType.id = 6 And YEAR(dateEnd) = YEAR(CURRENT_TIMESTAMP()) And MONTH(dateEnd) = MONTH(CURRENT_TIMESTAMP()) - 1 And lv_id = " + session.getUserId()));
    model.addAttribute("c33_UZB", dPatient.getKoykoCount("From Patients Where counteryId = 199 And room.roomType.id = 7 And YEAR(dateEnd) = YEAR(CURRENT_TIMESTAMP()) And MONTH(dateEnd) = MONTH(CURRENT_TIMESTAMP()) - 1 And lv_id = " + session.getUserId()));
    return "/med/lv/stat";
  }

  @RequestMapping("/stat/home.s")
  protected String statHome(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    Integer type = Util.getInt(req, "stat");
    String dep = Util.get(req, "dep");
    String date = Util.get(req, "date");
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null, rc = null;
    try {
      Calendar calendar = Calendar.getInstance();
      int day = calendar.get(Calendar.DAY_OF_WEEK);
      List<ObjList> list = new ArrayList<ObjList>();
      String dt = date;
      if(type == 2 || type == 4) {
        Calendar c = Calendar.getInstance();
        c.setTime(new Date());
        c.add(Calendar.DATE, day == 7 ? 2 : 1);
        dt = Util.dateToString(c.getTime());
      }
      if (type == 1 || type == 2) {
        //
        model.addAttribute("deptName", dep == null ? dUser.get(session.getUserId()).getDept().getName() : dDep.get(Integer.parseInt(dep)).getName());
        conn = DB.getConnection();
        List<Integer> kdoIds = new ArrayList<Integer>();
        ps = conn.prepareStatement(
          "Select t.Id, t.Name " +
            "From Kdo_Types t " +
            "Where t.Id IN (SELECT c.kdo_type_id FROM Lv_Plans c, Patients d WHERE c.patientId = d.id And d.dept_id = ? And date(actDate) = ?)");
        ps.setInt(1, dep == null ? session.getDeptId() : Integer.parseInt(dep));
        ps.setString(2, Util.dateDB(dt));
        rs = ps.executeQuery();
        List<String> kdos = new ArrayList<String>();
        while(rs.next()){
          kdoIds.add(rs.getInt(1));
          kdos.add(rs.getString(2));
        }
        for(int i = 0;i<kdos.size();i++) {
          List<ObjList> patients = new ArrayList<ObjList>();
          ps = conn.prepareStatement(
            "SELECT Concat(d.surname, ' ', d.name, ' ', d.middlename) fio," +
              "         c.id, " +
              "         c.kdo_id, " +
              "         k.Name Kdo_Name, " +
              "         c.actDate, "+
              "         c.comment " +
              "  FROM Lv_Plans c, Patients d, Kdos k " +
              "  WHERE k.id = c.kdo_id " +
              "    And c.patientid = d.id " +
              "    And d.dept_id = ? " +
              "    And c.kdo_type_id = ?" +
              "    And date(actDate) = ?");
          ps.setInt(1, dep == null ? session.getDeptId() : Integer.parseInt(dep));
          ps.setInt(2, kdoIds.get(i));
          ps.setString(3, Util.dateDB(dt));
          rs = ps.executeQuery();
          while(rs.next()) {
            ObjList obj = new ObjList();
            obj.setC1(rs.getString("fio"));
            String name = rs.getString("kdo_name");
            if(rs.getInt("kdo_id") == 13) { // Биохимия
                String st = "";
                LvBios bio = dLvBio.getByPlan(rs.getInt("id"));
                if(bio != null) {
                  if (bio.getC1() == 1) st += "Глюкоза крови,";
                  if (bio.getC2() == 1) st += "Холестерин,";
                  if (bio.getC3() == 1) st += "Бетта липопротеиды,";
                  if (bio.getC4() == 1) st += "Общий белок,";
                  if (bio.getC5() == 1) st += "Мочевина,";
                  if (bio.getC23() == 1) st += "Fе (железо),";
                  if (bio.getC8() == 1) st += "Билирубин,";
                  if (bio.getC7() == 1) st += "Креатинин,";
                  if (bio.getC13() == 1) st += "Амилаза крови,";
                  if (bio.getC12() == 1) st += "Трансаминазы-АЛТ,";
                  if (bio.getC14() == 1) st += "Мочевая кислота,";
                  if (bio.getC11() == 1) st += "Трансаминазы-АСТ,";
                  if (bio.getC15() == 1) st += "Сывороточное железо,";
                  if (bio.getC16() == 1) st += "К-калий,";
                  if (bio.getC17() == 1) st += "Na - натрий,";
                  if (bio.getC18() == 1) st += "Са - кальций,";
                  if (bio.getC19() == 1) st += "Cl - хлор,";
                  if (bio.getC20() == 1) st += "Phos - фосфор,";
                  if (bio.getC21() == 1) st += "Mg - магний,";
                  if (bio.getC24() == 1) st += "Альбумин,";
                  if (bio.getC25() == 1) st += "Лактатдегидрогеноза,";
                  if (bio.getC26() == 1) st += "Гамма-глутамилтрансфераза,";
                  if (bio.getC27() == 1) st += "Шелочная фосфотаза,";
                  if (bio.getC28() == 1) st += "Тимоловая проба,";
                  if (bio.getC29() == 1) st += "Креотенин киназа,";
                  if(st != "") {
                    st = st.substring(0, st.length() - 1);
                    name = name + "<br/>" + st;
                  }
                }
              }
              if(rs.getInt("kdo_id") == 153) { // Биохимия
                String st = "";
                LvBios bio = dLvBio.getByPlan(rs.getInt("id"));
                if(bio != null) {
                  if (bio.getC1() == 1) st += "Умумий оксил,";
                  if (bio.getC2() == 1) st += "Холестерин,";
                  if (bio.getC3() == 1) st += "Глюкоза,";
                  if (bio.getC4() == 1) st += "Мочевина,";
                  if (bio.getC5() == 1) st += "Креатинин,";
                  if (bio.getC6() == 1) st += "Билирубин,";
                  if (bio.getC7() == 1) st += "АЛТ,";
                  if (bio.getC8() == 1) st += "АСТ,";
                  if (bio.getC9() == 1) st += "Альфа амилаза,";
                  if (bio.getC10() == 1) st += "Кальций,";
                  if (bio.getC11() == 1) st += "Сийдик кислотаси,";
                  if (bio.getC12() == 1) st += "K – калий,";
                  if (bio.getC13() == 1) st += "Na – натрий,";
                  if (bio.getC14() == 1) st += "Fe – темир,";
                  if (bio.getC15() == 1) st += "Mg – магний,";
                  if (bio.getC16() == 1) st += "Ишкорий фасфотаза,";
                  if (bio.getC17() == 1) st += "ГГТ,";
                  if (bio.getC18() == 1) st += "Гликирланган гемоглобин,";
                  if (bio.getC19() == 1) st += "РФ,";
                  if (bio.getC20() == 1) st += "АСЛО,";
                  if (bio.getC21() == 1) st += "СРБ,";
                  if (bio.getC22() == 1) st += "RW,";
                  if (bio.getC23() == 1) st += "Hbs Ag,";
                  if (bio.getC24() == 1) st += "Гепатит «С» ВГС,";
                  if(st != "") {
                    st = st.substring(0, st.length() - 1);
                    name = name + "<br/>" + st;
                  }
                }
              }
              if(rs.getInt("kdo_id") == 56) { // Каулограмма
                String st = "";
                LvCouls bio = dLvCoul.getByPlan(rs.getInt("id"));
                if(bio != null) {
                  if (bio.isC4()) st += "ПТИ,";
                  if (bio.isC1()) st += "Фибриноген,";
                  if (bio.isC2()) st += "Тромбин вакти,";
                  if (bio.isC3()) st += "А.Ч.Т.В. (сек),";
                  if(st != "") {
                    st = st.substring(0, st.length() - 1);
                    name = name + "<br/>" + st;
                  }
                }
              }
              if(rs.getInt("kdo_id") == 120) { // Garmon
                String st = "";
                LvGarmons bio = dLvGarmon.getByPlan(rs.getInt("id"));
                if(bio != null) {
                  if (bio.isC1()) st += "ТТГ,";
                  if (bio.isC2()) st += "Т4,";
                  if (bio.isC3()) st += "Т3,";
                  if (bio.isC4()) st += "Анти-ТРО,";
                  if(st != "") {
                    st = st.substring(0, st.length() - 1);
                    name = name + "<br/>" + st;
                  }
                }
              }
              if(rs.getInt("kdo_id") == 121) { // Торч
                String st = "";
                LvTorchs bio = dLvTorch.getByPlan(rs.getInt("id"));
                if(bio != null) {
                  if (bio.isC1()) st += "Хламидия,";
                  if (bio.isC2()) st += "Токсоплазма,";
                  if (bio.isC3()) st += "ЦМВ,";
                  if (bio.isC4()) st += "ВПГ,";
                  if(st != "") {
                    st = st.substring(0, st.length() - 1);
                    name = name + "<br/>" + st;
                  }
                }
            }
            obj.setC3(name);
            obj.setC4(rs.getString("actdate"));
            obj.setC5(rs.getString("comment"));
            patients.add(obj);
          }
          if(patients.size() > 0) {
            ObjList obj = new ObjList();
            obj.setC1(kdos.get(i));
            obj.setC30("Y");
            list.add(obj);
            list.addAll(patients);
          }
        }
        ps = conn.prepareStatement(
          "SELECT Concat(d.surname, ' ', d.name, ' ', d.middlename) fio," +
            "         t.lvName, " +
            "         u.profil, " +
            "         t.date actdate  " +
            "   FROM Lv_Consuls t, Patients d, Users u " +
            "   Where t.patientid = d.id " +
            "     And t.state = 'REQ' " +
            "     And t.lvId > 0 " +
            "     And u.id = t.lvid " +
            "     And d.dept_id = ? " +
            "     And t.date = ? "
        );
        ps.setInt(1, dep == null ? session.getDeptId() : Integer.parseInt(dep));
        ps.setString(2, dt);
        rs = ps.executeQuery();
        List<ObjList> patients = new ArrayList<ObjList>();
        while(rs.next()){
          ObjList obj = new ObjList();
          obj.setC1(rs.getString("fio"));
          obj.setC4(rs.getString("actdate"));
          if(rs.getString("profil") != null)
            obj.setC3("Консультация " + rs.getString("profil").toLowerCase() + "a");
          obj.setC5(rs.getString("lvName"));
          patients.add(obj);
        }
        if(patients.size() > 0) {
          ObjList obj = new ObjList();
          obj.setC1("Консультация");
          obj.setC30("Y");
          list.add(obj);
          list.addAll(patients);
        }
        model.addAttribute("plans", list);
        model.addAttribute("currTime", Util.getCurDate() + " " + Util.getCurTime());
        return "/med/lv/print/stat/page1";
      } else {
        List<ObjList> rows = new ArrayList<ObjList>();
        List<KdoTypes> types = dKdoType.getList("From KdoTypes Where state = 'A'");
        conn = DB.getConnection();
        ps = conn.prepareStatement(
          "Select t.id " +
            "    From Patients t, Lv_Plans c " +
            "   Where c.actDate = ? " +
            "     And c.patientId = t.id " +
            "     And t.dept_id = ? " +
            "   Group By t.id "
        );
        ps.setString(1, Util.dateDB(dt));
        ps.setInt(2, dep == null ? session.getDeptId() : Integer.parseInt(dep));
        rs = ps.executeQuery();
        //
        while(rs.next()) {
          ObjList row = new ObjList();
          Patients d = dPatient.get(rs.getInt("id"));
          row.setC1(d.getSurname() + " " + d.getName() + " " + d.getMiddlename());
          row.setC2(d.getBirthyear() + "");
          row.setC3(Util.dateToString(d.getDateBegin()));
          row.setC4(d.getYearNum() + "");
          row.setC30(d.getRoom().getName() + "-" + d.getRoom().getRoomType().getName());
          int k=0;
          for(KdoTypes tt : types) {
            k++;
            ps = conn.prepareStatement(
              "Select c.name," +
                "         t.id, " +
                "         t.comment, " +
                "         c.id kdo_id " +
                "    From Lv_Plans t, Kdos c, Patients d " +
                "   Where t.kdo_id = c.id " +
                "     And t.patientId = d.id " +
                "     And t.patientId = ? " +
                "     And t.actDate = ? " +
                "     And t.kdo_type_id = ? " +
                "     And d.dept_id = ?"
            );
            ps.setInt(1, d.getId());
            ps.setString(2, Util.dateDB(dt));
            ps.setInt(3, tt.getId());
            ps.setInt(4, dep == null ? session.getDeptId() : Integer.parseInt(dep));
            rc = ps.executeQuery();
            int i = 1;
            while (rc.next()) {
              String name = rc.getString("name");
              if(rc.getInt("kdo_id") == 13) { // Биохимия
                String st = "";
                LvBios bio = dLvBio.getByPlan(rc.getInt("id"));
                if(bio != null) {
                  if (bio.getC1() == 1) st += "Глюкоза крови, ";
                  if (bio.getC2() == 1) st += "Холестерин, ";
                  if (bio.getC3() == 1) st += "Бетта липопротеиды, ";
                  if (bio.getC4() == 1) st += "Общий белок, ";
                  if (bio.getC5() == 1) st += "Мочевина, ";
                  if (bio.getC23() == 1) st += "Fе (железо), ";
                  if (bio.getC8() == 1) st += "Билирубин, ";
                  if (bio.getC7() == 1) st += "Креатинин, ";
                  if (bio.getC13() == 1) st += "Амилаза крови, ";
                  if (bio.getC12() == 1) st += "Трансаминазы-АЛТ, ";
                  if (bio.getC14() == 1) st += "Мочевая кислота, ";
                  if (bio.getC11() == 1) st += "Трансаминазы-АСТ, ";
                  if (bio.getC15() == 1) st += "Сывороточное железо, ";
                  if (bio.getC16() == 1) st += "К-калий, ";
                  if (bio.getC17() == 1) st += "Na - натрий, ";
                  if (bio.getC18() == 1) st += "Са - кальций, ";
                  if (bio.getC19() == 1) st += "Cl - хлор, ";
                  if (bio.getC20() == 1) st += "Phos - фосфор, ";
                  if (bio.getC21() == 1) st += "Mg - магний, ";
                  if (bio.getC24() == 1) st += "Альбумин, ";
                  if (bio.getC25() == 1) st += "Лактатдегидрогеноза, ";
                  if (bio.getC26() == 1) st += "Гамма-глутамилтрансфераза, ";
                  if (bio.getC27() == 1) st += "Шелочная фосфотаза, ";
                  if (bio.getC28() == 1) st += "Тимоловая проба, ";
                  if (bio.getC29() == 1) st += "Креотенин киназа, ";
                  if(st != "") {
                    st = st.substring(0, st.length() - 1);
                    name = name + "<br/>" + st;
                  }
                }
              }
              if(rc.getInt("kdo_id") == 153) { // Биохимия
                String st = "";
                LvBios bio = dLvBio.getByPlan(rc.getInt("id"));
                if(bio != null) {
                  if (bio.getC1() == 1) st += "Умумий оксил, ";
                  if (bio.getC2() == 1) st += "Холестерин, ";
                  if (bio.getC3() == 1) st += "Глюкоза, ";
                  if (bio.getC4() == 1) st += "Мочевина, ";
                  if (bio.getC5() == 1) st += "Креатинин, ";
                  if (bio.getC6() == 1) st += "Билирубин, ";
                  if (bio.getC7() == 1) st += "АЛТ, ";
                  if (bio.getC8() == 1) st += "АСТ, ";
                  if (bio.getC9() == 1) st += "Альфа амилаза, ";
                  if (bio.getC10() == 1) st += "Кальций, ";
                  if (bio.getC11() == 1) st += "Сийдик кислотаси, ";
                  if (bio.getC12() == 1) st += "K – калий, ";
                  if (bio.getC13() == 1) st += "Na – натрий, ";
                  if (bio.getC14() == 1) st += "Fe – темир, ";
                  if (bio.getC15() == 1) st += "Mg – магний, ";
                  if (bio.getC16() == 1) st += "Ишкорий фасфотаза, ";
                  if (bio.getC17() == 1) st += "ГГТ, ";
                  if (bio.getC18() == 1) st += "Гликирланган гемоглобин, ";
                  if (bio.getC19() == 1) st += "РФ, ";
                  if (bio.getC20() == 1) st += "АСЛО, ";
                  if (bio.getC21() == 1) st += "СРБ, ";
                  if (bio.getC22() == 1) st += "RW, ";
                  if (bio.getC23() == 1) st += "Hbs Ag, ";
                  if (bio.getC24() == 1) st += "Гепатит «С» ВГС, ";
                  if(st != "") {
                    st = st.substring(0, st.length() - 1);
                    name = name + ": <b>" + st + "</b>";
                  }
                }
              }
              if(rc.getInt("kdo_id") == 56) { // Каулограмма
                String st = "";
                LvCouls bio = dLvCoul.getByPlan(rc.getInt("id"));
                if(bio != null) {
                  if (bio.isC4()) st += "ПТИ, ";
                  if (bio.isC1()) st += "Фибриноген, ";
                  if (bio.isC2()) st += "Тромбин вакти, ";
                  if (bio.isC3()) st += "А.Ч.Т.В. (сек), ";
                  if(st != "") {
                    st = st.substring(0, st.length() - 1);
                    name = name + ": <b>" + st + "</b>";
                  }
                }
              }
              if(rc.getInt("kdo_id") == 120) { // Garmon
                String st = "";
                LvGarmons bio = dLvGarmon.getByPlan(rc.getInt("id"));
                if(bio != null) {
                  if (bio.isC1()) st += "ТТГ, ";
                  if (bio.isC2()) st += "Т4, ";
                  if (bio.isC3()) st += "Т3, ";
                  if (bio.isC4()) st += "Анти-ТРО, ";
                  if(st != "") {
                    st = st.substring(0, st.length() - 1);
                    name = name + ": <b>" + st + "</b>";
                  }
                }
              }
              if(rc.getInt("kdo_id") == 121) { // Торч
                String st = "";
                LvTorchs bio = dLvTorch.getByPlan(rc.getInt("id"));
                if(bio != null) {
                  if (bio.isC1()) st += "Хламидия, ";
                  if (bio.isC2()) st += "Токсоплазма, ";
                  if (bio.isC3()) st += "ЦМВ, ";
                  if (bio.isC4()) st += "ВПГ, ";
                  if(st != "") {
                    st = st.substring(0, st.length() - 1);
                    name = name + ": <b>" + st + "</b>";
                  }
                }
              }
              if(rc.getInt("kdo_id") == 17) { // Торч
                name += ":" + rc.getString("comment");
              }
              if(tt.getId() == 1)  row.setC11((row.getC11() == null ? "" : row.getC11() + "<br/>") + " " + i + "." + name);
              if(tt.getId() == 2)  row.setC12((row.getC12() == null ? "" : row.getC12() + "<br/>") + " " + i + "." + name);
              if(tt.getId() == 3)  row.setC13((row.getC13() == null ? "" : row.getC13() + "<br/>") + " " + i + "." + name);
              if(tt.getId() == 4)  row.setC14((row.getC14() == null ? "" : row.getC14() + "<br/>") + " " + i + "." + name);
              if(tt.getId() == 6)  row.setC16((row.getC16() == null ? "" : row.getC16() + "<br/>") + " " + i + "." + name);
              if(tt.getId() == 10) row.setC20((row.getC20() == null ? "" : row.getC20() + "<br/>") + " " + i + "." + name);
              if(tt.getId() == 11) row.setC21((row.getC21() == null ? "" : row.getC21() + "<br/>") + " " + i + "." + name);
              if(tt.getId() == 12) row.setC22((row.getC22() == null ? "" : row.getC22() + "<br/>") + " " + i + "." + name);
              if(tt.getId() == 13) row.setC23((row.getC23() == null ? "" : row.getC23() + "<br/>") + " " + i + "." + name);
              if(tt.getId() == 14) row.setC24((row.getC24() == null ? "" : row.getC24() + "<br/>") + " " + i + "." + name);
              i++;
            }
            DB.done(rc);
            if(k == types.size()) {
              ps = conn.prepareStatement(
                "Select t.lvname " +
                  "    From Lv_Consuls t, Patients d " +
                  "   Where t.patientId = d.id " +
                  "     And t.patientId = ? " +
                  "     And t.date = ? " +
                  "     And d.dept_id = ?"
              );
              ps.setInt(1, d.getId());
              ps.setString(2, dt);
              ps.setInt(3, dep == null ? session.getDeptId() : Integer.parseInt(dep));
              rc = ps.executeQuery();
              //
              i=1;
              while (rc.next()) {
                row.setC25((row.getC25() == null ? "" : row.getC25() + "<br/>") + " " + i + "." + rc.getString("lvname"));
                i++;
              }
            }
          }
          rows.add(row);
          //
        }
        //

        //
        model.addAttribute("deptName", dDep.get(dep == null ? session.getDeptId() : Integer.parseInt(dep)).getName());
        model.addAttribute("date", dt);
        model.addAttribute("types", types);
        model.addAttribute("rows", rows);
        return "/med/lv/print/stat/page2";
      }
    } catch (Exception e) {
      e.printStackTrace();
      return "";
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(conn);
    }
  }

  // Документы
  @RequestMapping(value = "/docs.s")
  protected String docPrint(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    Patients pat = dPatient.get(session.getCurPat());
    // Reg Forma
    model.addAttribute("p", pat);
    // Extra form
    model.addAttribute("obos", dLvForm2.getByPatient(session.getCurPat()));
    model.addAttribute("vyp", dLvForm4.getByPatient(session.getCurPat()));
    model.addAttribute("lv", dUser.get(pat.getLv_id()).getFio());
    model.addAttribute("zavOtdel", dUser.getZavOtdel(pat.getDept().getId()).getFio());
    // OSM
    LvForm1 f = dLvForm1.getByPatient(session.getCurPat());
    if(f != null) {
      f.setC1(f.getC1().replaceAll("&nbsp;"," "));
      f.setC2(f.getC2().replaceAll("&nbsp;"," "));
      f.setC3(f.getC3().replaceAll("&nbsp;"," "));
      f.setC4(f.getC4().replaceAll("&nbsp;"," "));
      f.setC5(f.getC5().replaceAll("&nbsp;"," "));
      f.setC6(f.getC6().replaceAll("&nbsp;"," "));
      f.setC7(Util.nvl(f.getC7()).replaceAll("&nbsp;"," "));
      f.setC8(Util.nvl(f.getC8()).replaceAll("&nbsp;"," "));
      f.setC9(Util.nvl(f.getC9()).replaceAll("&nbsp;"," "));
      f.setC10(Util.nvl(f.getC10()).replaceAll("&nbsp;"," "));
      f.setC11(Util.nvl(f.getC11()).replaceAll("&nbsp;"," "));
      f.setC12(Util.nvl(f.getC12()).replaceAll("&nbsp;"," "));
      f.setC13(Util.nvl(f.getC13()).replaceAll("&nbsp;"," "));
      f.setC14(Util.nvl(f.getC14()).replaceAll("&nbsp;"," "));
      f.setC15(Util.nvl(f.getC15()).replaceAll("&nbsp;"," "));
      f.setC16(Util.nvl(f.getC16()).replaceAll("&nbsp;"," "));
      f.setC17(Util.nvl(f.getC17()).replaceAll("&nbsp;"," "));
      f.setC18(Util.nvl(f.getC18()).replaceAll("&nbsp;"," "));
      f.setC19(Util.nvl(f.getC19()).replaceAll("&nbsp;"," "));
      model.addAttribute("lvFio", dUser.get(f.getPatient().getLv_id()).getFio());
    }
    model.addAttribute("form", f);
    // Obos
    /*LvForm2 f = dLvForm2.getByPatient(session.getCurPat());
    if(f != null) {
      f.setC1(f.getC1().replaceAll("&nbsp;"," "));
      f.setC2(f.getC2().replaceAll("&nbsp;"," "));
      f.setC3(f.getC3().replaceAll("&nbsp;"," "));
      f.setC4(f.getC4().replaceAll("&nbsp;"," "));
      f.setC5(f.getC5().replaceAll("&nbsp;"," "));
      f.setC6(Util.nvl(f.getC6()).replaceAll("&nbsp;"," "));
      f.setC7(Util.nvl(f.getC7()).replaceAll("&nbsp;"," "));
      f.setC8(Util.nvl(f.getC8()).replaceAll("&nbsp;"," "));
      model.addAttribute("lvFio", dUser.get(f.getPatient().getLv_id()).getFio());
    }
    //
    model.addAttribute("form", f);*/
    return "/med/lv/print/docs";
  }

  // Статистика отделения
  @RequestMapping("/cashbox.s")
  protected String cashBox(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    session.setCurSubUrl("/view/cashbox.s");
    List<ObjList> list = new ArrayList<ObjList>();
    //
    Patients pat = dPatient.get(session.getCurPat());
    Double KOYKA_PRICE_LUX_UZB = Double.parseDouble(session.getParam("KOYKA_PRICE_LUX_UZB"));
    Double KOYKA_PRICE_SIMPLE_UZB = Double.parseDouble(session.getParam("KOYKA_PRICE_SIMPLE_UZB"));
    Double KOYKA_SEMILUX_UZB = Double.parseDouble(session.getParam("KOYKA_SEMILUX_UZB"));
    Double KOYKA_PRICE_LUX = Double.parseDouble(session.getParam("KOYKA_PRICE_LUX"));
    Double KOYKA_PRICE_SIMPLE = Double.parseDouble(session.getParam("KOYKA_PRICE_SIMPLE"));
    Double KOYKA_SEMILUX = Double.parseDouble(session.getParam("KOYKA_SEMILUX"));
    Double total;
    if(pat.getCounteryId() == 199) { // Узбекистан
      if(pat.getRoom().getRoomType().getId() == 5)  // Люкс
        total = (pat.getDayCount() == null ? 0 : pat.getDayCount()) * KOYKA_PRICE_LUX_UZB;
      else if(pat.getRoom().getRoomType().getId() == 6) // Протая
        total = (pat.getDayCount() == null ? 0 : pat.getDayCount()) * KOYKA_PRICE_SIMPLE_UZB;
      else // Полулюкс
        total = (pat.getDayCount() == null ? 0 : pat.getDayCount()) * KOYKA_SEMILUX_UZB;
    } else {
      if(pat.getRoom().getRoomType().getId() == 5)  // Люкс
        total = (pat.getDayCount() == null ? 0 : pat.getDayCount()) * KOYKA_PRICE_LUX;
      else if(pat.getRoom().getRoomType().getId() == 6) // Протая
        total = (pat.getDayCount() == null ? 0 : pat.getDayCount()) * KOYKA_PRICE_SIMPLE;
      else // Полулюкс
        total = (pat.getDayCount() == null ? 0 : pat.getDayCount()) * KOYKA_SEMILUX;
    }
    ObjList obj = new ObjList();
    obj.setC1("Оплата за койку: Кол-во дней: " + pat.getDayCount());
    obj.setC2(total + "");
    list.add(obj);
    List<PatientWatchers> watchers = dPatientWatchers.byPatient(pat.getId());
    for(PatientWatchers watcher: watchers) {
      obj = new ObjList();
      total += watcher.getTotal();
      obj.setC1("Дополнительное спальное место по типу: " + watcher.getType().getName() + ". Кол-во дней: " + watcher.getDayCount());
      obj.setC2(watcher.getTotal() + "");
      list.add(obj);
    }
    List<PatientPays> pays = dPatientPays.byPatient(pat.getId());
    Double paid = 0D;
    for(PatientPays pay: pays) {
      paid += pay.getCard() + pay.getTransfer() + pay.getCash();
    }
    List<LvPlans> plans = dLvPlan.getByPatientId(pat.getId());
    for(LvPlans plan: plans) {
      total += plan.getPrice() != null ? plan.getPrice() : 0D;
      obj = new ObjList();
      obj.setC1(plan.getKdo().getName());
      obj.setC2((plan.getPrice() != null ? plan.getPrice() : 0D) + "");
      list.add(obj);
    }
    model.addAttribute("paid", paid);
    model.addAttribute("total", total);
    model.addAttribute("services", list);
    return "/med/lv/cashbox";
  }

  // Статистика отделения
  @RequestMapping("/stat_card.s")
  protected String stat_card(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    Patients pat = dPatient.get(session.getCurPat());
    model.addAttribute("country", dCountery.get(pat.getCounteryId()));
    if(pat.getRegionId() != null)
      model.addAttribute("region", dRegion.get(pat.getRegionId()));
    model.addAttribute("lvfio", dUser.get(pat.getLv_id()).getFio());
    List<LvPlans> plan = dLvPlan.getList("From LvPlans Where patientId = " + session.getCurPat() + " And kdo.id = 153"); // RW
    if(plan.size() > 0) {
      F13 rw = df13.get(plan.get(0).getResultId());
      model.addAttribute("rw", rw);
      model.addAttribute("plan", plan.get(0));
    }
    List<HNPatients> patients = dhnPatient.getList("From HNPatients Where patient.id = " + session.getCurPat());
    if(patients.size() > 0)
      model.addAttribute("days", patients.get(0).getDayCount());
    model.addAttribute("vypiska", dLvForm4.getByPatient(session.getCurPat()));
    model.addAttribute("pat", pat);
    return "/med/lv/print/stat_card";
  }
}
