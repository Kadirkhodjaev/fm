package ckb.controllers.med;


import ckb.dao.admin.depts.DDept;
import ckb.dao.admin.dicts.DDict;
import ckb.dao.admin.params.DParam;
import ckb.dao.admin.users.DUser;
import ckb.dao.med.dicts.rooms.DRooms;
import ckb.dao.med.drug.dict.directions.DDrugDirection;
import ckb.dao.med.drug.dict.drugs.DDrug;
import ckb.dao.med.drug.dict.drugs.counter.DDrugCount;
import ckb.dao.med.drug.dict.measures.DDrugMeasure;
import ckb.dao.med.eat.dict.menuTypes.DEatMenuType;
import ckb.dao.med.eat.dict.table.DEatTable;
import ckb.dao.med.head_nurse.drug.DHNDrug;
import ckb.dao.med.kdos.DKdos;
import ckb.dao.med.lv.bio.DLvBio;
import ckb.dao.med.lv.consul.DLvConsul;
import ckb.dao.med.lv.coul.DLvCoul;
import ckb.dao.med.lv.dairy.DLvDairy;
import ckb.dao.med.lv.drug.DLvDrug;
import ckb.dao.med.lv.drug.goal.DLvDrugGoal;
import ckb.dao.med.lv.epic.DLvEpic;
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
import ckb.dao.med.lv.plan.DKdoChoosen;
import ckb.dao.med.lv.plan.DLvPlan;
import ckb.dao.med.lv.torch.DLvTorch;
import ckb.dao.med.patient.*;
import ckb.dao.med.template.DDrugTemplate;
import ckb.domains.med.drug.dict.DrugDirections;
import ckb.domains.med.eat.dict.EatMenuTypes;
import ckb.domains.med.head_nurse.HNDrugs;
import ckb.domains.med.lv.*;
import ckb.domains.med.patient.*;
import ckb.models.Menu;
import ckb.models.ObjList;
import ckb.models.PatientList;
import ckb.models.drugs.PatientDrug;
import ckb.models.drugs.PatientDrugDate;
import ckb.models.drugs.PatientDrugRow;
import ckb.services.admin.form.SForm;
import ckb.services.admin.user.SUser;
import ckb.services.med.kdo.SKdo;
import ckb.services.med.patient.SPatient;
import ckb.services.med.results.SRkdo;
import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.Req;
import ckb.utils.Util;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.*;
import java.util.concurrent.TimeUnit;

@Controller
@RequestMapping("/lv")
public class CLv {

  //region AUTOWIRED
  @Autowired SPatient sPatient;
  @Autowired DPatient dPatient;
  @Autowired DLvForm1 dLvForm1;
  @Autowired DLvForm2 dLvForm2;
  @Autowired DLvForm3 dLvForm3;
  @Autowired DLvForm4 dLvForm4;
  @Autowired DLvForm5 dLvForm5;
  @Autowired DLvForm6 dLvForm6;
  @Autowired DLvForm7 dLvForm7;
  @Autowired DLvDairy dLvDairy;
  @Autowired DKdos dKdos;
  @Autowired SForm sForm;
  @Autowired SKdo sKdo;
  @Autowired SRkdo sRkdo;
  @Autowired DLvPlan dLvPlan;
  @Autowired SUser sUser;
  @Autowired DUser dUser;
  @Autowired DDept dDept;
  @Autowired DLvEpic dLvEpic;
  @Autowired DLvConsul dLvConsul;
  @Autowired DLvBio dLvBio;
  @Autowired DPatientEat dPatientEat;
  @Autowired DParam dParam;
  @Autowired DPatientPlan dPatientPlan;
  @Autowired DPatientLink dPatientLink;
  @Autowired DLvDrug dLvDrug;
  @Autowired DLvGarmon dLvGarmon;
  @Autowired DLvTorch dLvTorch;
  @Autowired DLvCoul dLvCoul;
  @Autowired DLvDrugGoal dLvDrugGoal;
  @Autowired DLvFizio dLvFizio;
  @Autowired DDrugTemplate dDrugTemplate;
  @Autowired private DDrug dDrug;
  @Autowired DRooms dRooms;
  @Autowired private DKdoChoosen dKdoChoosen;
  @Autowired private DPatientDrug dPatientDrug;
  @Autowired private DPatientDrugRow dPatientDrugRow;
  @Autowired private DPatientDrugDate dPatientDrugDate;
  @Autowired private DDrugCount dDrugCount;
  @Autowired private DEatTable dEatTable;
  @Autowired private DEatMenuType dEatMenuType;
  @Autowired private DDict dDict;
  @Autowired private DDrugMeasure dDrugMeasure;
  @Autowired private DPatientDrugTemp dPatientDrugTemp;
  @Autowired private DPatientDrugRowTemp dPatientDrugRowTemp;
  @Autowired private DDrugDirection dDrugDirection;
  @Autowired private DHNDrug dhnDrug;
  @Autowired private DPatientShock dPatientShock;
  @Autowired private DLvFizioDate dLvFizioDate;
  //endregion

  @RequestMapping("/index.s")
  protected String main(HttpServletRequest request, Model model) {
    Session session = SessionUtil.getUser(request);
    int id = Req.getInt(request, "id");
    session.setCurPat(id);
    session.setCurUrl("/lv/index.s?id=" + id);
    //
    List<Menu> m = new ArrayList<Menu>();
    session.setCurSubUrl(session.getCurSubUrl().contains("/lv/") ? (session.getCurSubUrl().contains("reg") ? "/view/reg.s" : session.getCurSubUrl()) : "/view/reg.s");
    m.add(new Menu(1,"Регистрация", "/view/reg.s", "fa fa-medkit fa-fw", false));
    m.add(new Menu(18,"Оплата", "/view/cashbox.s", "fa fa-money fa-fw", false));
    m.add(new Menu(2,"Питание", "/lv/eat.s", "fa fa-cutlery fa-fw", false));
    //m.add(new Menu(3,"Первичный осмотр", "/view/firstView.s", "fa fa-file-o fa-fw", false));
    m.add(new Menu(4,"Осмотр врача", "/lv/osm.s", "fa fa-stethoscope fa-fw", false));
    //m.add(new Menu(11,"Назначение", "/lv/drug/index.s", "fa fa-th-list fa-fw", false));
    m.add(new Menu(20,"Назначение", "/lv/drugs.s", "fa fa-th-list fa-fw", false));
    if(session.getRoleId() == 8)
      m.add(new Menu(21,"Экстренный", "/lv/shock.s", "fa fa-bars fa-fw", false));
    m.add(new Menu(10,"Обследования", "/lv/plan/index.s", "fa fa-flask fa-fw", false));
    m.add(new Menu(8,"Консультация", "/lv/consul.s", "fa fa-stethoscope fa-fw", false));
    m.add(new Menu(17,"Физиотерапия", "/lv/fizio/index.s", "fa fa-asterisk fa-fw", false));
    m.add(new Menu(6,"Дневник", "/lv/dairy.s", "fa fa-calendar fa-fw", false));
    m.add(new Menu(5,"Обоснование", "/lv/obos.s", "fa fa-retweet fa-fw", false));
    m.add(new Menu(9,"Выписка", "/lv/vypiska.s", "fa fa-check fa-fw", false));
    m.add(new Menu(14,"Дополнительные данные", "/lv/extra.s", "fa fa-plus-square fa-fw", false));
    m.add(new Menu(13,"Перевод", "/lv/epic.s", "fa fa-random fa-fw", false));
    if(dPatientLink.getCount("From PatientLinks Where parent = " + session.getCurPat()) > 0)
      m.add(new Menu(15, "История", "/lv/history.s", "fa fa-bars fa-fw", false));
    //m.add(new Menu(16, "Все документы", "/lv/docs.s", "fa fa-bars fa-fw", false));
    model.addAttribute("menuList", m);
    model.addAttribute("id", id);
    model.addAttribute("p", dPatient.get(session.getCurPat()));
    model.addAttribute("formUrl", session.getCurSubUrl());
    model.addAttribute("backUrl", session.getBackUrl());
    model.addAttribute("table", dPatientEat.getPatientTable(session.getCurPat()));
    return "/med/lv/index";
  }

  //region CODES
  // Осмотр леч врача
  @RequestMapping("/osm.s")
  protected String osm(@ModelAttribute("osm") LvForm1 osm, HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    session.setCurSubUrl("/lv/osm.s");
    LvForm1 o = dLvForm1.getByPatient(session.getCurPat());
    if(o != null) {
      osm.setId(o.getId());
      osm.setPatient(o.getPatient());
      osm.setC1(o.getC1());
      osm.setC2(o.getC2());
      osm.setC3(o.getC3());
      osm.setC4(o.getC4());
      osm.setC5(o.getC5());
      osm.setC6(o.getC6());
      osm.setC7(o.getC7());
      osm.setC8(o.getC8());
      osm.setC9(o.getC9());
      osm.setC10(o.getC10());
      osm.setC11(o.getC11());
      osm.setC12(o.getC12());
      osm.setC13(o.getC13());
      osm.setC14(o.getC14());
      osm.setC15(o.getC15());
      osm.setC16(o.getC16());
      osm.setC17(o.getC17());
      osm.setC18(o.getC18());
      osm.setC19(o.getC19());
      osm.setMkb(o.getMkb());
    } else {
      Patients p = dPatient.get(session.getCurPat());
      osm.setPatient(p);
      osm.setC1(p.getJaloby());
      osm.setC2(p.getAnamnez());
      osm.setC3("Умумий ахволи: . Тери копламлари: . Тери ости ег кавати: . Лимфа безлари: . Периферик шишлари: ");
      osm.setC8("Насл: . Ўтказилган касалликлар: . Турмуш шароитлари: . Зарарли одатлар: . Медикаментларга нохуш реакциялар борлиги: ");
      osm.setC9("1 мин. нафас олиш сони: . Кўкрак кафаси: . Перкутор товуш: . Аускультатив овоз: ");
      osm.setC10("Юрак чегараси: юкоридан: II-III к/о. Чап тарафдан: L. media clvikularis. Ўнг тарафдан: L. parasternalis dext. Аускультатив юрак тонлари: . Пульс:  марта 1 мин. КБ: мм сим уст");
      osm.setC11("Иштахаси: . Тили: . Корин: . Жигар: . Талок: . Ич келиши: ");
      osm.setC12("Пастернацкий симптоми: . Пешоб: ");
      osm.setC13("Бош мия нервлари: . Харакат системаси: . Сезувчанлик: . Харакат координацияси: ");
      osm.setC5(p.getStartDiagnoz());
      osm.setC18(p.getSopustDBolez());
      osm.setC19(p.getOslojn());
    }
    Util.getMsg(request, model);
    return "/med/lv/" + (session.isParamEqual("CLINIC_CODE", "fm") ? "fm/" : "") + "osm";
  }

  // Осмотр леч врача
  @RequestMapping(value = "/osm.s", method = RequestMethod.POST)
  protected String osm(@ModelAttribute("osm") LvForm1 osm){
    dLvForm1.save(osm);
    return "redirect:/lv/osm.s?msgState=1&msgCode=successSave";
  }

  // Обоснование
  @RequestMapping("/obos.s")
  protected String obos(@ModelAttribute("obos") LvForm2 obos, HttpServletRequest request, Model model) {
    Session session = SessionUtil.getUser(request);
    session.setCurSubUrl("/lv/obos.s");
    LvForm2 o = dLvForm2.getByPatient(session.getCurPat());
    if(o != null) {
      obos.setId(o.getId());
      obos.setPatient(o.getPatient());
      obos.setC1(o.getC1());
      obos.setC2(o.getC2());
      obos.setC3(o.getC3());
      obos.setC4(o.getC4());
      obos.setC5(o.getC5());
      obos.setC6(o.getC6());
      obos.setC7(o.getC7());
      obos.setC8(o.getC8());
      obos.setMkb(o.getMkb());
      obos.setMkb_id(o.getMkb_id());
    } else {
      LvForm1 osm = dLvForm1.getByPatient(session.getCurPat());
      obos.setPatient(dPatient.get(session.getCurPat()));
      if(osm != null) {
        obos.setC1(osm.getC1());
        obos.setC2(osm.getC2());
        obos.setC3(
          osm.getC3() +
          "<br/><b>Нафас олиш системаси:</b> " +  osm.getC9() +
          "<br/><b>Кон айланиш системаси:</b> " + osm.getC10() +
          "<br/><b>Хазм килиш cистемаси:</b> " + osm.getC11() +
          "<br/><b>Сийдик-таносил системаси:</b> " + osm.getC12() +
          "<br/><b>Нерв системаси:</b> " + osm.getC13()
        );
        obos.setC4(osm.getC4());
        obos.setC5(osm.getC5());
        obos.setMkb(osm.getPatient().getMkb());
        obos.setMkb_id(osm.getPatient().getMkb_id());
      }
    }
    Util.getMsg(request, model);
    return "/med/lv/" + (session.isParamEqual("CLINIC_CODE", "fm") ? "fm/" : "") + "obos";
  }

  // Обоснование
  @RequestMapping(value = "/obos.s", method = RequestMethod.POST)
  protected String obos(@ModelAttribute("obos") LvForm2 obos, Errors errors) {
    ValidationUtils.rejectIfEmpty(errors, "mkb_id", "МКБ 10 не выбран", "МКБ 10 не выбран");
    if (errors.hasErrors()) {
      obos.setMkb("");
      return "/med/lv/fm/obos";
    }
    dLvForm2.save(obos);
    return "redirect:/lv/obos.s?msgState=1&msgCode=successSave";
  }

  // Обоснование
  @RequestMapping("/predoper.s")
  protected String predOper(@ModelAttribute("predoper") LvForm7 predoper, HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    session.setCurSubUrl("/lv/predoper.s");
    LvForm7 o = dLvForm7.getByPatient(session.getCurPat());
    if(o != null) {
      predoper.setId(o.getId());
      predoper.setPatient(o.getPatient());
      predoper.setC1(o.getC1());
      predoper.setC2(o.getC2());
      predoper.setC3(o.getC3());
      predoper.setC4(o.getC4());
      predoper.setC5(o.getC5());
    } else {
      LvForm1 osm = dLvForm1.getByPatient(session.getCurPat());
      predoper.setPatient(dPatient.get(session.getCurPat()));
      if(osm != null) {
        predoper.setC1(osm.getC1());
        predoper.setC2(osm.getC2());
        predoper.setC3(osm.getC3());
        predoper.setC4(osm.getC4());
        predoper.setC5(osm.getC5());
      }
    }
    Util.getMsg(request, model);
    return "/med/lv/predoper";
  }

  // Обоснование
  @RequestMapping(value = "/predoper.s", method = RequestMethod.POST)
  protected String predOper(@ModelAttribute("predoper") LvForm7 predoper){
    dLvForm7.save(predoper);
    return "redirect:/lv/predoper.s?msgState=1&msgCode=successSave";
  }

  // Дневник
  @RequestMapping("/dairy.s")
  protected String dnevnikIndex(@ModelAttribute("dairy") LvDairies dairy, HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    session.setCurSubUrl("/lv/dairy.s");
    Patients m = dPatient.get(session.getCurPat());
    model.addAttribute("fio", Util.nvl(m.getSurname()) + " " + Util.nvl(m.getName()) + " " + Util.nvl(m.getMiddlename()));
    model.addAttribute("birthyear", m.getBirthyear());
    model.addAttribute("dairies", sPatient.getDairies(session.getCurPat()));
    // Creating model
    String dairyId = Util.get(request, "dairyId");
    if(!Util.nvl(dairyId).equals("")) {
      LvDairies d = dLvDairy.get(Integer.parseInt(dairyId));
      dairy.setId(Util.nvl(Util.get(request, "copy")).equals("") ? d.getId() : null);
      dairy.setPuls(d.getPuls());
      dairy.setTemp(d.getTemp());
      dairy.setDav1(d.getDav1());
      dairy.setDav2(d.getDav2());
      dairy.setText(d.getText());
      model.addAttribute("act_Date", Util.nvl(Util.get(request, "copy")).equals("") ? Util.dateToString(d.getActDate()) : null);
    } else {
      if(session.isParamEqual("CLINIC_CODE", "fm")) {
        StringBuffer sb = new StringBuffer();
        sb.append("Шикоятлари </br>");
        sb.append("Умумий ахволи </br>");
        sb.append("Териси </br>");
        sb.append("Упка </br>");
        sb.append("Юрак </br>");
        sb.append("Корин </br>");
        sb.append("Жигар </br>");
        sb.append("Пешоб </br>");
        sb.append("Ич келиши </br>");
        sb.append("Текширув ва тахлил натижалари </br>");
        sb.append("Тавсия </br>");
        dairy.setText(sb.toString());
      }
    }
    //
    return "/med/lv/dairy";
  }

  // Дневник
  @RequestMapping(value = "/dairy.s", method = RequestMethod.POST)
  protected String addDnevnik(@ModelAttribute("dairy") LvDairies dairy, Errors err, HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    String actDate = Util.get(request, "act_Date");
    dairy.setActDate(Util.toDate(Util.getCurDate()));
    // Validation
    if(Util.nvl(actDate).equals("") || dairy.getText().equals("<br>") || (!Util.nvl(actDate).equals("") && Util.toDate(actDate).after(Util.toDate(Util.getCurDate())))){
      Patients m = dPatient.get(session.getCurPat());
      model.addAttribute("fio", Util.nvl(m.getSurname()) + " " + Util.nvl(m.getName()) + " " + Util.nvl(m.getMiddlename()));
      model.addAttribute("birthyear", m.getBirthyear());
      model.addAttribute("dairies", sPatient.getDairies(session.getCurPat()));
      model.addAttribute("act_Date", Util.nvl(actDate));
      //
      if(Util.nvl(actDate).equals(""))
        err.rejectValue("actDate", "", "Поле 'Дата' не может быть пустым");
      if(Util.nvl(dairy.getText()).equals("<br>") || Util.nvl(dairy.getText()).equals(""))
        err.rejectValue("text", "", "Поле 'Состояние' не может быть пустым");
      if(!Util.nvl(actDate).equals("") && Util.toDate(actDate).after(Util.toDate(Util.getCurDate())))
        err.rejectValue("text", "", "Поле 'Дата' не может быть больше текущий даты");
      return "/med/lv/dairy";
    }
    if(!Req.isNull(request, "id"))
      dairy.setId(Req.getInt(request, "id"));
    dairy.setPatient(session.getCurPat());
    dairy.setActDate(Util.toDate(actDate));
    dairy.setUpdatedBy(session.getUserId());
    dairy.setUpdateDate(Util.toDate(Util.getCurDate()));
    if(dairy.getId() == null) {
      dairy.setCreatedBy(dairy.getUpdatedBy());
      dairy.setCreationDate(dairy.getUpdateDate());
    }
    dLvDairy.save(dairy);
    //
    return "redirect:/lv/dairy.s?msgState=1&msgCode=successSave";
  }

  // Совместный осмотр
  @RequestMapping("/sov.s")
  protected String sov(@ModelAttribute("sov") LvForm3 sov, HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    session.setCurSubUrl("/lv/sov.s");
    LvForm3 o = dLvForm3.getByPatient(session.getCurPat());
    if(o != null) {
      sov.setId(o.getId());
      sov.setPatient(o.getPatient());
      sov.setC1(o.getC1());
      sov.setC2(o.getC2());
      sov.setC3(o.getC3());
      sov.setC4(o.getC4());
      sov.setC5(o.getC5());
      sov.setC6(o.getC6());
    } else {
      LvForm2 osm = dLvForm2.getByPatient(session.getCurPat());
      sov.setPatient(dPatient.get(session.getCurPat()));
      if(osm != null) {
        sov.setC1(osm.getC1());
        sov.setC2(osm.getC2());
        sov.setC3(osm.getC3());
        sov.setC4(osm.getC4());
        sov.setC5(osm.getC5());
      }
    }
    Util.getMsg(request, model);
    return "/med/lv/sov";
  }

  // Совместный осмотр
  @RequestMapping(value = "/sov.s", method = RequestMethod.POST)
  protected String sov(@ModelAttribute("sov") LvForm3 sov){
    dLvForm3.save(sov);
    return "redirect:/lv/sov.s?msgState=1&msgCode=successSave";
  }

  // Консультация
  @RequestMapping("/consul.s")
  protected String konsulIndex(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    session.setCurSubUrl("/lv/consul.s");
    if(!Req.isNull(request, "del")) {
      dLvConsul.delete(Req.getInt(request, "id"));
      model.addAttribute("messageCode", "successDelete");
    }
    model.addAttribute("conDate", Util.getCurDate());
    if(!Req.isNull(request, "edit")) {
      LvConsuls con = dLvConsul.get(Req.getInt(request, "id"));
      model.addAttribute("id", con.getId());
      model.addAttribute("lvName", con.getLvName());
      model.addAttribute("conDate", con.getDate());
      model.addAttribute("conText", con.getText());
    }
    Patients patient = dPatient.get(session.getCurPat());
    model.addAttribute("patient", patient);
    model.addAttribute("lvs", sUser.getConsuls());
    model.addAttribute("consuls", dLvConsul.getByPat(session.getCurPat()));
    model.addAttribute("shortClinicName", dParam.byCode("SHORT_CLICNIC_NAME"));
    //
    Util.getMsg(request, model);
    return "/med/lv/consul";
  }

  // Консультация
  @RequestMapping(value = "/consul.s", method = RequestMethod.POST)
  protected String consul(HttpServletRequest request) {
    Session session = SessionUtil.getUser(request);
    LvConsuls con = new LvConsuls();
    if(!Req.isNull(request, "id"))
      con.setId(Req.getInt(request, "id"));
    con.setPatientId(session.getCurPat());
    con.setDate(Req.get(request, "conDate"));
    if(Req.isNull(request, "innerDoc")) {
      con.setState("OUT");
      con.setLvName(Req.get(request, "lvName"));
      con.setText(Req.get(request, "conText"));
    } else {
      con.setState("REQ");
      con.setLvId(Req.getInt(request, "lvId"));
      con.setLvName(sUser.getLv(con.getLvId()).getFio());
    }
    if(!"".equals(con.getLvName())) {
      con.setCrOn(new Date());
      dLvConsul.save(con);
    }
    //
    return "redirect:/lv/consul.s?msgState=1&msgCode=successSave";
  }

  // Консультация врача
  @RequestMapping(value = "/cls.s", method = RequestMethod.POST)
  protected String cls(HttpServletRequest request){
    String[] ids = request.getParameterValues("id");
    String[] texts = request.getParameterValues("comment");
    String[] reqs = request.getParameterValues("reqs");
    for(int i=0;i<ids.length;i++) {
      LvConsuls con = dLvConsul.get(Integer.parseInt(ids[i]));
      if(!"DONE".equals(con.getState()))
        con.setSaveDate(new Date());
      con.setState("DONE");
      con.setText(texts[i]);
      con.setReq(reqs[i]);
      dLvConsul.save(con);
    }
    //
    return "redirect:/view/consul.s?msgState=1&msgCode=successSave";
  }

  // Выписка
  @RequestMapping("/vypiska.s")
  protected String vypiska(@ModelAttribute("vyp") LvForm4 vyp, HttpServletRequest request, Model model) {
    Session session = SessionUtil.getUser(request);
    session.setCurSubUrl("/lv/vypiska.s");
    LvForm4 o = dLvForm4.getByPatient(session.getCurPat());
    model.addAttribute("dieFlag", dLvForm6.getByPatient(session.getCurPat()).getC4() != null);
    vyp.setPatient(dPatient.get(session.getCurPat()));
    if(o != null) {
      vyp.setId(o.getId());
      vyp.setC1(o.getC1());
      vyp.setC2(o.getC2());
      vyp.setC3(o.getC3());
      vyp.setC4(o.getC4());
      vyp.setC5(o.getC5());
      vyp.setC6(o.getC6());
      vyp.setC7(o.getC7());
      vyp.setC8(o.getC8());
      vyp.setC9(o.getC9());
      vyp.setMkb(o.getMkb());
      vyp.setMkb_id(o.getMkb_id());
      model.addAttribute("Date_End", Util.dateToString(o.getPatient().getDateEnd()));
    } else {
      if(session.isParamEqual("CLINIC_CODE", "fm")) {
        LvForm2 obos = dLvForm2.getByPatient(session.getCurPat());
        if(obos != null) {
          vyp.setC2(obos.getC1());
          vyp.setC3(obos.getC2());
          vyp.setC1(obos.getC5());
          vyp.setC8(obos.getC6());
          vyp.setC9(obos.getC7());
          vyp.setC4(obos.getC3());
          vyp.setMkb(obos.getMkb());
          vyp.setMkb_id(obos.getMkb_id());
        }
      } else {
        LvForm3 sov = dLvForm3.getByPatient(session.getCurPat());
        if (sov != null) {
          vyp.setC1(sov.getC5());
          vyp.setC2(sov.getC1());
          vyp.setC3(sov.getC2());
          vyp.setC4(sov.getC3());
          vyp.setC5(sov.getC4());
        }
      }
    }
    Util.getMsg(request, model);
    return "/med/lv/" + (session.isParamEqual("CLINIC_CODE", "fm") ? "fm/" : "") + "vypiska";
  }

  // Выписка
  @RequestMapping(value = "/vypiska.s", method = RequestMethod.POST)
  protected String vypiska(@ModelAttribute("vyp") LvForm4 vyp, Errors errors, HttpServletRequest request) {
    ValidationUtils.rejectIfEmpty(errors, "mkb_id", "МКБ 10 не выбран", "МКБ 10 не выбран");
    LvForm2 obos = dLvForm2.getByPatient(vyp.getPatient().getId());
    if(obos == null)
      errors.rejectValue("mkb_id", "По данному пациенту не заполнен документ 'Обоснование'", "По данному пациенту не заполнен документ 'Обоснование'");
    if (errors.hasErrors()) {
      return "/med/lv/fm/vypiska";
    }
    LvForm4 vp = dLvForm4.getByPatient(vyp.getPatient().getId());
    if(vp == null) {
      dLvForm4.save(vyp);
    } else {
      vp.setC1(vyp.getC1());
      vp.setC2(vyp.getC2());
      vp.setC3(vyp.getC3());
      vp.setC4(vyp.getC4());
      vp.setC5(vyp.getC5());
      vp.setC6(vyp.getC6());
      vp.setC7(vyp.getC7());
      vp.setC8(vyp.getC8());
      vp.setC9(vyp.getC9());
      vp.setPatient(vyp.getPatient());
      dLvForm4.save(vyp);
    }
    Patients pat = dPatient.get(vyp.getPatient().getId());
    pat.setDateEnd(Req.getDate(request, "Date_End"));
    dPatient.save(pat);
    return "redirect:/lv/vypiska.s?msgState=1&msgCode=successSave";
  }

  // Физиотерапия
  @RequestMapping("/fizio/index.s")
  protected String fizio(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    session.setCurSubUrl("/lv/fizio/index.s");
    Patients pat = dPatient.get(session.getCurPat());
    model.addAttribute("pat", pat);
    List<LvFizios> fizios = dLvFizio.getList("From LvFizios Where patientId = " + session.getCurPat());
    model.addAttribute("fizios", fizios);
    Date end = dLvFizioDate.getPatientMaxDay(pat.getId());
    if(end != null) {
      List<LvFizioDates> dates = new ArrayList<LvFizioDates>();
      int i = 0;
      while (true) {
        LvFizioDates date = new LvFizioDates();
        Calendar cl = Calendar.getInstance();
        cl.setTime(pat.getDateBegin());
        cl.add(Calendar.DATE, i++);
        date.setDate(cl.getTime());
        date.setDone("N");
        date.setState("N");
        dates.add(date);
        if (cl.getTime().equals(end)) break;
      }
      HashMap<Integer, List<LvFizioDates>> ds = new HashMap<Integer, List<LvFizioDates>>();
      for (LvFizios fizio : fizios) {
        if (dLvFizioDate.getCount("From LvFizioDates Where fizio.id = " + fizio.getId()) == 0)
          ds.put(fizio.getId(), dates);
        else
          ds.put(fizio.getId(), dLvFizioDate.getList("From LvFizioDates Where fizio.id = " + fizio.getId()));
      }
      model.addAttribute("dates", dates);
      model.addAttribute("ds", ds);
    }
    Util.getMsg(request, model);
    return "/med/lv/fizio/index";
  }

  @RequestMapping("/fizio/set.s")
  @ResponseBody
  protected String fizioSet(HttpServletRequest request, Model model) throws JSONException {
    Session session = SessionUtil.getUser(request);
    session.setCurSubUrl("/lv/fizio/index.s");
    JSONObject res = new JSONObject();
    Patients patients = dPatient.get(session.getCurPat());
    patients.setFizio(!patients.getFizio());
    dPatient.save(patients);
    res.put("msg", "Данные успешно сохранены");
    Util.getMsg(request, model);
    return res.toString();
  }

  // Протокол операции
  @RequestMapping("/prot.s")
  protected String prot(@ModelAttribute("prot") LvForm5 prot, HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    session.setCurSubUrl("/lv/prot.s");
    LvForm5 o = dLvForm5.getByPatient(session.getCurPat());
    if(o != null) {
      prot.setId(o.getId());
      prot.setPatient(o.getPatient());
      prot.setC1(o.getC1());
      prot.setC2(o.getC2());
      model.addAttribute("oper_Date", Util.dateToString(o.getOperDate()));
      prot.setC3(o.getC3());
      prot.setC4(o.getC4());
    } else {
      prot.setPatient(dPatient.get(session.getCurPat()));
    }
    Util.getMsg(request, model);
    return "/med/lv/prot";
  }

  // Выписка
  @RequestMapping(value = "/prot.s", method = RequestMethod.POST)
  protected String prot(@ModelAttribute("prot") LvForm5 prot, HttpServletRequest request){
    prot.setOperDate(Util.stringToDate(Req.get(request, "oper_Date")));
    dLvForm5.save(prot);
    return "redirect:/lv/prot.s?msgState=1&msgCode=successSave";
  }

  // Переводной эпикриз
  @RequestMapping("/epic.s")
  protected String epic(@ModelAttribute("epic") LvEpics epic, HttpServletRequest request, Model model) {
    Session session = SessionUtil.getUser(request);
    session.setCurSubUrl("/lv/epic.s");
    Patients patient = dPatient.get(session.getCurPat());
    epic.setPatientId(session.getCurPat());
    sPatient.createEpicModel(epic);
    List<ObjList> epics = sPatient.getEpicGrid(epic.getPatientId());
    model.addAttribute("epics", epics);
    model.addAttribute("patient", patient);
    model.addAttribute("lvs", sUser.getLvs());
    model.addAttribute("deps", dDept.getAll());
    model.addAttribute("sysDate", Util.getCurDate());
    model.addAttribute("rooms", dRooms.getAll());
    model.addAttribute("startDate", patient.getStartEpicDate() == null ? Util.dateToString(patient.getDateBegin()) : Util.dateToString(patient.getStartEpicDate()));
    Util.getMsg(request, model);
    return "/med/lv/epic";
  }

  // Переводной эпикриз
  @RequestMapping(value = "/epic.s", method = RequestMethod.POST)
  protected String saveEpic(@ModelAttribute("epic") LvEpics epic, HttpServletRequest request){
    Session session = SessionUtil.getUser(request);
    epic.setPatientId(session.getCurPat());
    epic.setDateBegin(Req.getDate(request, "Date_Begin"));
    epic.setDateEnd(Req.getDate(request, "Date_End"));
    Patients pat = dPatient.get(session.getCurPat());
    epic.setPrice(sPatient.getPatientKoykoPrice(pat));
    //
    if(epic.getDateBegin() == null)
      epic.setDateBegin(dPatient.get(session.getCurPat()).getDateBegin());
    long diffInMillies = Math.abs(epic.getDateEnd().getTime() - epic.getDateBegin().getTime());
    long diff = TimeUnit.DAYS.convert(diffInMillies, TimeUnit.MILLISECONDS);
    epic.setKoyko((int) diff);
    epic.setRoom(dRooms.get(Util.getInt(request, "room_id")));
    //
    sPatient.saveEpic(epic);
    return "redirect:/lv/epic.s?msgState=1&msgCode=successSave";
  }

  // Дополнительные данные
  @RequestMapping("/extra.s")
  protected String extra(@ModelAttribute("edt") LvForm6 edt, HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    edt = dLvForm6.getByPatient(session.getCurPat());
    edt.setPatient(dPatient.get(session.getCurPat()));
    session.setCurSubUrl("/lv/extra.s");
    sForm.setSelectOptionModel(model, 3, "c5");
    sForm.setSelectOptionModel(model, 3, "c6");
    sForm.setSelectOptionModel(model, 3, "c7");
    sForm.setSelectOptionModel(model, 3, "c8");
    model.addAttribute("C2_Date", Util.dateToString(edt.getC2()));
    model.addAttribute("C3_Date", Util.dateToString(edt.getC3()));
    model.addAttribute("C4_Date", Util.dateToString(edt.getC4()));
    model.addAttribute("edt", edt);
    Util.getMsg(request, model);
    return "/med/lv/extra";
  }

  // Дополнительные данные
  @RequestMapping(value = "/extra.s", method = RequestMethod.POST)
  protected String saveExtra(@ModelAttribute("edt") LvForm6 edt, HttpServletRequest request){
    edt.setC2(Req.getDate(request, "C2_Date"));
    edt.setC3(Req.getDate(request, "C3_Date"));
    edt.setC4(Req.getDate(request, "C4_Date"));
    edt.setC5(edt.getC5().getId() == null ? null : edt.getC5());
    edt.setC6(edt.getC6().getId() == null ? null : edt.getC6());
    edt.setC7(edt.getC7().getId() == null ? null : edt.getC7());
    edt.setC8(edt.getC8().getId() == null ? null : edt.getC8());
    dLvForm6.save(edt);
    return "redirect:/lv/extra.s?msgState=1&msgCode=successSave";
  }

  // Печать
  @RequestMapping("/print.s")
  protected String print(HttpServletRequest req, Model model){
    Session session = SessionUtil.getUser(req);
    SessionUtil.addSession(req, "dairyId", Req.get(req, "dairyId"));
    SessionUtil.addSession(req, "consulId", Req.get(req, "consul"));
    SessionUtil.addSession(req, "fontSize", Req.get(req, "font", "14"));
    SessionUtil.addSession(req, "dairyIds", Util.nvl(req.getParameter("dairyIds")));
    if(session.getCurPat() != 0)
      model.addAttribute("patFio", dPatient.getFio(session.getCurPat()));
    model.addAttribute("printPage", session.getCurSubUrl().replace("/lv", "/view"));
    if(!Util.isNull(req, "diagnoz"))
      model.addAttribute("printPage", "/view/vypiska.s?diagnoz=Y");
    if(session.getCurSubUrl().contains("reg") || session.getCurUrl().contains("reg"))
      model.addAttribute("printPage", "/reg/print.s");
    if(req.getParameterValues("obos") != null)
      model.addAttribute("printPage", "/view/drug/obos.s");
    if(req.getParameterValues("statcard") != null)
      model.addAttribute("printPage", "/view/stat_card.s");
    return "/med/lv/print";
  }

  // Печать
  @RequestMapping("/stat.s")
  protected String stat(HttpServletRequest req, Model model){
    Session session = SessionUtil.getUser(req);
    SessionUtil.addSession(req, "fontSize", Req.get(req, "font", "14"));
    int type = Util.getInt(req, "stat");
    model.addAttribute("printPage", "/view/stat/home.s?stat=" + type);
    return "/med/lv/print/stat/print";
  }
  // История
  @RequestMapping(value = "/history.s")
  protected String history(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    session.setCurSubUrl("/lv/history.s");
    List<PatientLinks> patients= dPatientLink.getList("From PatientLinks Where parent = " + session.getCurPat());
    List<PatientList> list = new ArrayList<PatientList>();
    for(PatientLinks patient : patients){
      PatientList p = new PatientList();
      Patients pat = dPatient.get(patient.getChild());
      p.setId(pat.getId());
      p.setFio(Util.nvl(pat.getSurname()) + " " + Util.nvl(pat.getName()) + " " + Util.nvl(pat.getMiddlename()));
      p.setDateBegin(Util.dateToString(pat.getDateBegin()));
      p.setIbNum(pat.getYearNum().toString());
      p.setOtdPal(pat.getDept().getName() + " / " + pat.getPalata());
      p.setCat(pat.getCat().getName());
      p.setMetka(pat.getMetka().getName());
      p.setLv(dUser.get(pat.getLv_id()).getFio());
      list.add(p);
    }
    model.addAttribute("patients", list);
    return "/med/lv/history";
  }

  // Документы
  @RequestMapping(value = "/docs.s")
  protected String docs(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    session.setCurSubUrl("/lv/docs.s");
    model.addAttribute("dairies", dLvDairy.getByPatientId(session.getCurPat()));
    return "/med/lv/docs";
  }

  @RequestMapping(value = "/results.s", method = RequestMethod.POST)
  @ResponseBody
  protected String results(HttpServletRequest req) throws JSONException {
    Session session = SessionUtil.getUser(req);
    JSONObject res = new JSONObject();
    List<String> list = sRkdo.getResults(session.getCurPat());
    StringBuilder sb = new StringBuilder();
    for(String l : list) sb.append(l);
    res.put("results", sb.toString());
    return res.toString();
  }
  //endregion

  //region PLAN
  // Результаты всех обследования
  @RequestMapping("/plan.s")
  protected String plan(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    //session.setCurSubUrl("/lv/plan.s");
    Patients m = dPatient.get(session.getCurPat());
    model.addAttribute("pat", m);
    model.addAttribute("newWindow", !Req.get(request, "new").equals(""));
    model.addAttribute("fio", Util.nvl(m.getSurname()) + " " + Util.nvl(m.getName()) + " " + Util.nvl(m.getMiddlename()));
    model.addAttribute("birthyear", m.getBirthyear());
    model.addAttribute("results", sRkdo.getResults(session.getCurPat()));
    return "/med/lv/plan/results";
  }

  // План обследования
  @RequestMapping("/plan/index.s")
  protected String planIndex(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    session.setCurSubUrl("/lv/plan/index.s");
    if(request.getParameter("delPlan") != null) {
      Integer id = Integer.parseInt(request.getParameter("id"));
      dLvBio.deletePlan(id);
      dLvCoul.deletePlan(id);
      dLvTorch.deletePlan(id);
      dLvGarmon.deletePlan(id);
      try {
        dPatientPlan.delPlan(id);
        dLvPlan.delete(id);
      } catch(Exception e) {
        return "redirect:/lv/plan/index.s?msgState=0&msgCode=lvPlanDelErr";
      }
    }
    Patients m = dPatient.get(session.getCurPat());
    model.addAttribute("fio", Util.nvl(m.getSurname()) + " " + Util.nvl(m.getName()) + " " + Util.nvl(m.getMiddlename()));
    model.addAttribute("birthyear", m.getBirthyear());
    model.addAttribute("plans", sPatient.getPlans(session.getCurPat()));
    Util.getMsg(request, model);
    return "/med/lv/plan/index";
  }

  // План обследования - Сохранить и отправить в КДО
  @RequestMapping(value = "/plan/index.s", method = RequestMethod.POST)
  protected String savePlan(HttpServletRequest request){
    String[] ids = request.getParameterValues("ids");
    String[] dates = request.getParameterValues("dates");
    String[] comments = request.getParameterValues("comments");
    if(ids != null)
      for(int i=0; i<ids.length;i++) {
        LvPlans p = dLvPlan.get(Integer.parseInt(ids[i]));
        PatientPlans pp = new PatientPlans();
        p.setActDate(Util.stringToDate(dates[i]));
        p.setComment(comments[i]);
        if(p.getUserId() == null)
          p.setUserId(SessionUtil.getUser(request).getUserId());
        //
        dPatientPlan.delPlan(p.getId());
        pp.setPlan_Id(p.getId());
        pp.setKdo_type_id(p.getKdoType().getId());
        pp.setActDate(p.getActDate());
        pp.setPatient_id(p.getPatientId());
        dPatientPlan.save(pp);
        //
        dLvPlan.save(p);
      }
    return "redirect:/lv/plan/index.s?msgState=1&msgCode=successSave";
  }

  // План обследования
  @RequestMapping("/plan/kdos.s")
  protected String kdos(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    //session.setCurSubUrl("/lv/plan/kdos.s");
    model.addAttribute("labs",  dKdos.getLabKdos());
    model.addAttribute("uzis",  dKdos.getTypeKdos(4));
    model.addAttribute("rens",  dKdos.getTypeKdos(3));
    model.addAttribute("vems",  dKdos.getTypeKdos(5));
    model.addAttribute("sms",   dKdos.getTypeKdos(6));
    model.addAttribute("mskt",  dKdos.getTypeKdos(7));
    model.addAttribute("fizio", dKdos.getTypeKdos(8));
    model.addAttribute("endos", dKdos.getTypeKdos(9));
    model.addAttribute("neyros", dKdos.getTypeKdos(10));
    model.addAttribute("xolters", dKdos.getTypeKdos(11));
    model.addAttribute("gineks", dKdos.getTypeKdos(12));
    model.addAttribute("lors", dKdos.getTypeKdos(13));
    model.addAttribute("okulists", dKdos.getTypeKdos(14));
    model.addAttribute("consuls", dKdos.getTypeKdos(16));
    return "/med/lv/plan/kdos";
  }

  // План обследования
  @RequestMapping("/plan/selBioFields.s")
  protected String selBioFields(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    if(!Req.isNull(request, "save")) {
      LvBios bio = dLvBio.getByPlan(Req.getInt(request, "planId"));
      bio.setPlanId(Req.getInt(request, "planId"));
      bio.setPatientId(session.getCurPat());
      bio.setC1(Req.getInt(request, "c1"));
      bio.setC2(Req.getInt(request, "c2"));
      bio.setC3(Req.getInt(request, "c3"));
      bio.setC4(Req.getInt(request, "c4"));
      bio.setC5(Req.getInt(request, "c5"));
      bio.setC6(Req.getInt(request, "c6"));
      bio.setC7(Req.getInt(request, "c7"));
      bio.setC8(Req.getInt(request, "c8"));
      bio.setC9(Req.getInt(request, "c9"));
      bio.setC10(Req.getInt(request, "c10"));
      bio.setC11(Req.getInt(request, "c11"));
      bio.setC12(Req.getInt(request, "c12"));
      bio.setC13(Req.getInt(request, "c13"));
      bio.setC14(Req.getInt(request, "c14"));
      bio.setC15(Req.getInt(request, "c15"));
      bio.setC16(Req.getInt(request, "c16"));
      bio.setC17(Req.getInt(request, "c17"));
      bio.setC18(Req.getInt(request, "c18"));
      bio.setC19(Req.getInt(request, "c19"));
      bio.setC20(Req.getInt(request, "c20"));
      bio.setC21(Req.getInt(request, "c21"));
      bio.setC22(Req.getInt(request, "c22"));
      bio.setC23(Req.getInt(request, "c23"));
      bio.setC24(Req.getInt(request, "c24"));
      bio.setC25(Req.getInt(request, "c25"));
      bio.setC26(Req.getInt(request, "c26"));
      bio.setC27(Req.getInt(request, "c27"));
      bio.setC28(Req.getInt(request, "c28"));
      bio.setC29(Req.getInt(request, "c29"));
      Double price = 0D;
      LvPlans plan = dLvPlan.get(Req.getInt(request, "planId"));
      Patients pat = dPatient.get(plan.getPatientId());
      if(bio.getC1() == 1) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 1);
      if(bio.getC2() == 1) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 2);
      if(bio.getC3() == 1) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 3);
      if(bio.getC4() == 1) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 4);
      if(bio.getC5() == 1) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 5);
      if(bio.getC6() == 1) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 6);
      if(bio.getC7() == 1) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 7);
      if(bio.getC8() == 1) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 8);
      if(bio.getC9() == 1) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 9);
      if(bio.getC10() == 1) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 10);
      if(bio.getC11() == 1) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 11);
      if(bio.getC12() == 1) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 12);
      if(bio.getC13() == 1) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 13);
      if(bio.getC14() == 1) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 14);
      if(bio.getC15() == 1) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 15);
      if(bio.getC16() == 1) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 16);
      if(bio.getC17() == 1) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 17);
      if(bio.getC18() == 1) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 18);
      if(bio.getC19() == 1) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 19);
      if(bio.getC20() == 1) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 20);
      if(bio.getC21() == 1) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 21);
      if(bio.getC22() == 1) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 22);
      if(bio.getC23() == 1) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 23);
      if(bio.getC24() == 1) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 24);
      if(bio.getC25() == 1) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 25);
      if(bio.getC26() == 1) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 26);
      if(bio.getC27() == 1) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 27);
      if(bio.getC28() == 1) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 28);
      if(bio.getC29() == 1) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 29);
      plan.setPrice(price);
      if(price == 0)
        plan.setCashState("FREE");
      dLvPlan.save(plan);
      //
      dLvBio.save(bio);
      return "redirect:/lv/plan/index.s?msgState=1&msgCode=successSave";
    }
    model.addAttribute("bio", dLvBio.getByPlan(Req.getInt(request, "planId")));
    return "/med/lv/plan/" + (session.isParamEqual("CLINIC_CODE", "fm") ? "fm/" : "") + "selBioFields";
  }

  @RequestMapping("/plan/setGarmonFields.s")
  protected String setGarmonFields(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    if(!Req.isNull(request, "save")) {
      LvGarmons garmon = dLvGarmon.getByPlan(Req.getInt(request, "planId"));
      garmon.setPlanId(Req.getInt(request, "planId"));
      garmon.setPatientId(session.getCurPat());
      garmon.setC1(!Util.isNull(request, "c1"));
      garmon.setC2(!Util.isNull(request, "c2"));
      garmon.setC3(!Util.isNull(request, "c3"));
      garmon.setC4(!Util.isNull(request, "c4"));
      garmon.setC5(!Util.isNull(request, "c5"));
      garmon.setC6(!Util.isNull(request, "c6"));
      garmon.setC7(!Util.isNull(request, "c7"));
      garmon.setC8(!Util.isNull(request, "c8"));
      garmon.setC9(!Util.isNull(request, "c9"));
      garmon.setC10(!Util.isNull(request, "c10"));
      garmon.setC11(!Util.isNull(request, "c11"));
      garmon.setC12(!Util.isNull(request, "c12"));
      garmon.setC13(!Util.isNull(request, "c13"));
      garmon.setC14(!Util.isNull(request, "c14"));
      garmon.setC15(!Util.isNull(request, "c15"));
      garmon.setC16(!Util.isNull(request, "c16"));
      garmon.setC17(!Util.isNull(request, "c17"));
      garmon.setC18(!Util.isNull(request, "c18"));
      garmon.setC19(!Util.isNull(request, "c19"));
      garmon.setC20(!Util.isNull(request, "c20"));
      garmon.setC21(!Util.isNull(request, "c21"));
      garmon.setC22(!Util.isNull(request, "c22"));
      garmon.setC23(!Util.isNull(request, "c23"));
      garmon.setC24(!Util.isNull(request, "c24"));
      garmon.setC25(!Util.isNull(request, "c25"));
      garmon.setC26(!Util.isNull(request, "c26"));
      garmon.setC27(!Util.isNull(request, "c27"));
      //
      Double price = 0D;
      LvPlans plan = dLvPlan.get(Req.getInt(request, "planId"));
      Patients pat = dPatient.get(plan.getPatientId());
      if(garmon.isC1()) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 1);
      if(garmon.isC2()) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 2);
      if(garmon.isC3()) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 3);
      if(garmon.isC4()) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 4);
      if(garmon.isC5()) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 5);
      if(garmon.isC6()) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 6);
      if(garmon.isC7()) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 7);
      if(garmon.isC8()) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 8);
      if(garmon.isC9()) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 9);
      if(garmon.isC10()) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 10);
      if(garmon.isC11()) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 11);
      if(garmon.isC12()) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 12);
      if(garmon.isC13()) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 13);
      if(garmon.isC14()) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 14);
      if(garmon.isC15()) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 15);
      if(garmon.isC16()) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 16);
      if(garmon.isC17()) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 17);
      if(garmon.isC18()) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 18);
      if(garmon.isC19()) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 19);
      if(garmon.isC20()) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 20);
      if(garmon.isC21()) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 21);
      if(garmon.isC22()) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 22);
      if(garmon.isC23()) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 23);
      if(garmon.isC24()) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 24);
      if(garmon.isC25()) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 25);
      if(garmon.isC26()) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 26);
      if(garmon.isC27()) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 27);
      plan.setPrice(price);
      if(price == 0)
        plan.setCashState("FREE");
      dLvPlan.save(plan);
      //
      dLvGarmon.save(garmon);
      return "redirect:/lv/plan/index.s?msgState=1&msgCode=successSave";
    }
    model.addAttribute("bio", dLvGarmon.getByPlan(Req.getInt(request, "planId")));
    return "/med/lv/plan/fm/setGarmonFields";
  }

  @RequestMapping("/plan/setCoulFields.s")
  protected String setCoulFields(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    if(!Req.isNull(request, "save")) {
      LvCouls coul = dLvCoul.getByPlan(Req.getInt(request, "planId"));
      coul.setPlanId(Req.getInt(request, "planId"));
      coul.setPatientId(session.getCurPat());
      coul.setC1(!Util.isNull(request, "c1"));
      coul.setC2(!Util.isNull(request, "c2"));
      coul.setC3(!Util.isNull(request, "c3"));
      coul.setC4(!Util.isNull(request, "c4"));
      //
      Double price = 0D;
      LvPlans plan = dLvPlan.get(Req.getInt(request, "planId"));
      Patients pat = dPatient.get(plan.getPatientId());
      if(coul.isC1()) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 1);
      if(coul.isC2()) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 2);
      if(coul.isC3()) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 3);
      if(coul.isC4()) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 4);
      plan.setPrice(price);
      if(price == 0)
        plan.setCashState("FREE");
      dLvPlan.save(plan);
      //
      dLvCoul.save(coul);
      return "redirect:/lv/plan/index.s?msgState=1&msgCode=successSave";
    }
    model.addAttribute("bio", dLvCoul.getByPlan(Req.getInt(request, "planId")));
    return "/med/lv/plan/fm/setCoulFields";
  }

  @RequestMapping("/plan/setTorchFields.s")
  protected String setTorchFields(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    if(!Req.isNull(request, "save")) {
      LvTorchs obj = dLvTorch.getByPlan(Req.getInt(request, "planId"));
      obj.setPlanId(Req.getInt(request, "planId"));
      obj.setPatientId(session.getCurPat());
      obj.setC1(!Util.isNull(request, "c1"));
      obj.setC2(!Util.isNull(request, "c2"));
      obj.setC3(!Util.isNull(request, "c3"));
      obj.setC4(!Util.isNull(request, "c4"));
      //
      Double price = 0D;
      LvPlans plan = dLvPlan.get(Req.getInt(request, "planId"));
      Patients pat = dPatient.get(plan.getPatientId());
      if(obj.isC1()) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 1);
      if(obj.isC2()) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 2);
      if(obj.isC3()) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 3);
      if(obj.isC4()) price += dKdoChoosen.getPrice(pat.getCounteryId(), plan.getKdo().getId(), 4);
      plan.setPrice(price);
      if(price == 0)
        plan.setCashState("FREE");
      dLvPlan.save(plan);
      //
      dLvTorch.save(obj);
      return "redirect:/lv/plan/index.s?msgState=1&msgCode=successSave";
    }
    model.addAttribute("bio", dLvTorch.getByPlan(Req.getInt(request, "planId")));
    return "/med/lv/plan/fm/setTorchFields";
  }

  // План обследования
  @RequestMapping(value = "/plan/kdos.s", method = RequestMethod.POST)
  protected String saveKdos(HttpServletRequest request){
    Session session = SessionUtil.getUser(request);
    String[] ids = request.getParameterValues("ids");
    sPatient.saveKdos(session, ids);
    return "redirect:/lv/plan/index.s?msgState=1&msgCode=successSave";
  }
  //endregion

  //region EAT
  @RequestMapping(value = "/eat.s")
  protected String eat(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    session.setCurSubUrl("/lv/eat.s");
    Patients patient = dPatient.get(session.getCurPat());
    model.addAttribute("patient", patient);
    List<PatientEats> eats = dPatientEat.getPatientEat(patient.getId());
    List<EatMenuTypes> menuTypes = dEatMenuType.getList("From EatMenuTypes Where state = 'A'");
    if(eats == null || eats.size() == 0) {
      eats = new ArrayList<PatientEats>();
      int count = patient.getDayCount();
      if(patient.getDateEnd() != null && patient.getDateEnd().after(patient.getDateBegin())) {
        count = Integer.parseInt("" + ((patient.getDateEnd().getTime() - patient.getDateBegin().getTime()) / (1000 * 60 * 60 * 24))) + 1;
      }
      List<Date> dates = Util.getDateArray(patient.getDateBegin(), count);
      for(Date date: dates) {
        for(EatMenuTypes menuType: menuTypes) {
          PatientEats eat = new PatientEats();
          eat.setActDate(date);
          eat.setPatient(patient);
          eat.setTable(null);
          eat.setMenuType(menuType);
          eat.setState("ENT");
          dPatientEat.save(eat);
          eats.add(eat);
        }
      }
    } else {
      if(patient.getDateEnd() != null && patient.getDateEnd().after(patient.getDateBegin())) {
        Date maxDate = eats.get(eats.size() - 1).getActDate();
        int count = Integer.parseInt("" + ((patient.getDateEnd().getTime() - patient.getDateBegin().getTime()) / (1000 * 60 * 60 * 24))) + 1;
        List<Date> dates = Util.getDateArray(maxDate, count - (eats.size() / menuTypes.size()) + 1);
        for (Date date : dates) {
          if (maxDate.getTime() != date.getTime()) {
            for (EatMenuTypes menuType : menuTypes) {
              PatientEats eat = new PatientEats();
              eat.setActDate(date);
              eat.setPatient(patient);
              eat.setTable(null);
              eat.setMenuType(menuType);
              eat.setState("ENT");
              dPatientEat.save(eat);
              eats.add(eat);
            }
          }
        }
      }
    }
    model.addAttribute("eats", eats);
    model.addAttribute("tables", dEatTable.getList("From EatTables Where state = 'A'"));
    return "/med/lv/eat";
  }

  @RequestMapping(value = "/eat.s", method = RequestMethod.POST)
  @ResponseBody
  protected String saveEat(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      String[] ids = req.getParameterValues("id");
      String[] tables = req.getParameterValues("table");
      for(int i=0;i<ids.length;i++) {
        PatientEats eat = dPatientEat.get(Integer.parseInt(ids[i]));
        if(!tables[i].equals("")) {
          if(tables[i].equals("-1")) {
            eat.setTable(null);
            eat.setState("REF");
          } else
            eat.setTable(dEatTable.get(Integer.parseInt(tables[i])));
        } else {
          eat.setTable(null);
        }
        dPatientEat.save(eat);
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/eat/del.s", method = RequestMethod.POST)
  @ResponseBody
  protected String delEat(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      dPatientEat.delete(Util.getInt(req, "id"));
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }
  //endregion

  //region DRUGS
  // Назначение
  @RequestMapping("/drug/index.s")
  protected String naznachIndex(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    Patients m = dPatient.get(session.getCurPat());
    session.setCurSubUrl("/lv/drug/index.s");
    model.addAttribute("pat", m);
    model.addAttribute("drugs", dLvDrug.getPatientDrugs(session.getCurPat()));
    model.addAttribute("fio", Util.nvl(m.getSurname()) + " " + Util.nvl(m.getName()) + " " + Util.nvl(m.getMiddlename()));
    model.addAttribute("birthyear", m.getBirthyear());
    model.addAttribute("goals", dLvDrugGoal.getAll());
    model.addAttribute("templates", dDrugTemplate.byUser(session.getUserId()));
    Util.makeMsg(request, model);
    return "/med/lv/drug/index";
  }

  // Удаление
  @RequestMapping(value = "/drug/delete.s", method = RequestMethod.POST)
  @ResponseBody
  protected String delIndex(HttpServletRequest request, Model model){
    dLvDrug.delete(Util.getInt(request, "id"));
    return "{}";
  }

  // Удаление
  @RequestMapping(value = "/drug/addgoal.s", method = RequestMethod.POST)
  @ResponseBody
  protected String addgoal(HttpServletRequest request, Model model) throws JSONException {
    LvDrugGoals goals = new LvDrugGoals();
    JSONObject res = new JSONObject();
    if(Util.isNotNull(request, "goal")) {
      goals.setName(request.getParameter("goal"));
      goals.setCode("999");
      goals.setState("A");
      goals = dLvDrugGoal.saveAndReturn(goals);
      res.put("id", goals.getId());
    } else {
      res.put("id", 0);
    }
    return res.toString();
  }

  // Назначение
  @RequestMapping(value = "/drug/index.s", method = RequestMethod.POST)
  protected String naznachSave(HttpServletRequest req, Model model){
    Session session = SessionUtil.getUser(req);
    String[] ids = req.getParameterValues("id");
    String[] idx = req.getParameterValues("idx");
    String[] types = req.getParameterValues("type");
    String[] cats = req.getParameterValues("cat");
    String[] goals = req.getParameterValues("goal");
    String[] drugNames = req.getParameterValues("drugName");
    String[] startDates = req.getParameterValues("startDate");
    String[] endDates = req.getParameterValues("endDate");
    String[] notes = req.getParameterValues("note");
    Set<LvDrugs> drugsList = new HashSet<LvDrugs>();
    //
    if(idx != null) {
      for(int i=0;i<idx.length;i++) {
        LvDrugs lvDrug = ids[i].equals("") ? new LvDrugs() : dLvDrug.get(Integer.parseInt(ids[i]));
        lvDrug.setPatient(session.getCurPat());
        lvDrug.setDrugName(drugNames[i]);
        lvDrug.setType(types[i]);
        lvDrug.setCat(cats[i]);
        lvDrug.setGoal(dLvDrugGoal.get(Integer.parseInt(goals[i])));
        lvDrug.setMorningTime(Util.get(req, "morningTime" + idx[i]) != null);
        lvDrug.setNoonTime(Util.get(req, "noonTime" + idx[i]) != null);
        lvDrug.setEveningTime(Util.get(req, "eveningTime" + idx[i]) != null);
        lvDrug.setStartDate(startDates[i] != null ? Util.stringToDate(startDates[i]) : null);
        lvDrug.setEndDate(endDates[i] != null ? Util.stringToDate(endDates[i]) : null);
        lvDrug.setNote(notes[i]);
        //
        drugsList.add(lvDrug);
      }
    }
    dLvDrug.save(drugsList);
    return "redirect:/lv/drug/index.s?msgState=1&msgCode=successSave";
  }

  // Назначение - список препаратов
  @RequestMapping("/drug/home.s")
  protected String drugHome(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    Patients m = dPatient.get(session.getCurPat());
    session.setCurSubUrl("/lv/drug/home.s");
    return "/med/lv/drug/home";
  }

  // Лист назначения
  @RequestMapping(value = "/drugs.s")
  protected String patientDrugs(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurSubUrl("/lv/drugs.s");
    model.addAttribute("goals", dLvDrugGoal.getList("From LvDrugGoals Order By name"));
    //
    model.addAttribute("counters", dDrugCount.getList("From DrugCount"));
    model.addAttribute("drugs", dDrug.getList("From Drugs t Where t.id in (Select c.drug.id From DrugActDrugs c Where c.counter - rasxod > 0) Or t.id In (Select f.drug.id From HNDrugs f Where f.drugCount - f.rasxod > 0 And f.direction.shock = 'N') Order By name"));
    Patients pat = dPatient.get(session.getCurPat());
    //
    int temp = Integer.parseInt(Util.get(req, "temp", "0"));

    if(Util.isNotNull(req, "id")) {
      model.addAttribute("drug", sPatient.getDrug(Util.getInt(req, "id")));
    } else {
      PatientDrug drug = new PatientDrug();
      if(temp > 0) {
        PatientDrugTemps tm = dPatientDrugTemp.get(temp);
        drug.setDrugType(tm.getDrugType());
        drug.setInjectionType(tm.getInjectionType());
        drug.setGoal(tm.getGoal());
        drug.setNote(tm.getNote());
        drug.setMorningTime(tm.isMorningTime());
        drug.setNoonTime(tm.isNoonTime());
        drug.setEveningTime(tm.isEveningTime());
        drug.setMorningTimeAfter(tm.isMorningTimeAfter());
        drug.setMorningTimeBefore(tm.isMorningTimeBefore());
        drug.setNoonTimeAfter(tm.isNoonTimeAfter());
        drug.setNoonTimeBefore(tm.isNoonTimeBefore());
        drug.setEveningTimeAfter(tm.isEveningTimeAfter());
        drug.setEveningTimeBefore(tm.isEveningTimeBefore());
        //
        List<PatientDrugRowTemps> tempRows = dPatientDrugRowTemp.getList("From PatientDrugRowTemps Where patientDrug.id = " + tm.getId());
        List<PatientDrugRow> rws = new ArrayList<PatientDrugRow>();
        for(PatientDrugRowTemps tempRow : tempRows) {
          PatientDrugRow rw = new PatientDrugRow();
          rw.setSource(tempRow.getSource());
          if(tempRow.getSource().equals("own"))
            rw.setName(tempRow.getName());
          else {
            rw.setDrug(tempRow.getDrug());
            rw.setName(tempRow.getDrug().getName());
          }
          rw.setExpanse(tempRow.getExpanse());
          rw.setMeasure(tempRow.getMeasure());
          rws.add(rw);
        }
        drug.setRows(rws);
      }

      drug.setDateBegin(pat.getDateBegin());
      //
      Calendar cal = Calendar.getInstance();
      cal.setTime(pat.getDateBegin());
      cal.add(Calendar.DATE, 10);
      List<PatientDrugDate> dates = new ArrayList<PatientDrugDate>();
      for(int i=0;i<=10;i++) {
        PatientDrugDate date = new PatientDrugDate();
        Calendar cl = Calendar.getInstance();
        cl.setTime(pat.getDateBegin());
        cl.add(Calendar.DATE, i);
        date.setDate(cl.getTime());
        date.setState("ENT");
        date.setId(0);
        dates.add(date);
      }
      drug.setDateEnd(cal.getTime());
      drug.setDates(dates);
      model.addAttribute("drug", drug);
    }
    model.addAttribute("drugTypes", dDict.getList("From Dicts Where typeCode = 'drugTypes'"));
    model.addAttribute("injectionTypes", dDict.getList("From Dicts Where typeCode = 'injectionTypes'"));
    model.addAttribute("list", sPatient.getPatientDrugs(session.getCurPat()));
    model.addAttribute("shocks", dPatientShock.getList("From PatientShocks Where patient.id = " + session.getCurPat()));
    return "/med/lv/drugs/index";
  }

  @RequestMapping(value = "/drugs/setPeriod.s")
  @ResponseBody
  protected String patientDrugPeriod(HttpServletRequest req) throws JSONException {
    Session session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      Patients pat = dPatient.get(session.getCurPat());
      Date begin = Util.getDate(req, "begin");
      Date end = Util.getDate(req, "end");
      if(begin != null) {
        if(begin.before(pat.getDateBegin())) throw new Exception("Дата начала периода не может быть меньше Даты регистраций пациента");
      }
      if(end == null) {
        json.put("success", true);
        json.put("dates", new JSONArray());
        return json.toString();
      }
      if(begin.after(end)) throw new Exception("Конец периода не может быть больще начала");
      JSONArray dates = new JSONArray();
      int i = 0;
      while(true) {
        JSONObject date = new JSONObject();
        Calendar cl = Calendar.getInstance();
        cl.setTime(begin);
        cl.add(Calendar.DATE, i++);
        date.put("date", Util.dateToString(cl.getTime()));
        date.put("state", false);
        dates.put(date);
        if(cl.getTime().equals(end)) break;
      }
      json.put("success", true);
      json.put("dates", dates);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/drugs/removeDrug.s")
  @ResponseBody
  protected String removeDrug(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      dPatientDrugRow.delete(Util.getInt(req, "id"));
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/drug_results.s", method = RequestMethod.POST)
  @ResponseBody
  protected String drug_results(HttpServletRequest req) throws JSONException {
    Session session = SessionUtil.getUser(req);
    StringBuffer sb = new StringBuffer();
    JSONObject res = new JSONObject();
    // Инъекции
    List<PatientDrug> ines = sPatient.getDrugsByType(session.getCurPat(), 16, true);
    if(ines.size() > 0) sb.append("<b>Инъекции:</b> ");
    for(PatientDrug drug : ines) {
      for(PatientDrugRow d : drug.getRows())
        sb.append(d.getName() + "; ");
    }
    // Таблетки
    if(ines.size() > 0) sb.append("<br/>");
    List<PatientDrug> tabs = sPatient.getDrugsByType(session.getCurPat(), 15, true);
    if(tabs.size() > 0) sb.append("<b>Таблетки:</b> ");
    for(PatientDrug drug : tabs) {
      for(PatientDrugRow d : drug.getRows())
        sb.append(d.getName() + "; ");
    }
    if(tabs.size() > 0) sb.append("<br/>");
    // Физиотерапия
    List<LvFizios> fizios = dLvFizio.getList("From LvFizios Where patientId = " + session.getCurPat());
    if(fizios != null && fizios.size() > 0) {
      sb.append("<b>Физиотерапия: </b>");
      for(LvFizios fizio : fizios) sb.append(fizio.getKdo().getName() + "; ");
    }
    res.put("results", sb.toString());
    return res.toString();
  }

  @RequestMapping(value = "/drugs/save.s", method = RequestMethod.POST) @ResponseBody
  protected String patientDrugSave(HttpServletRequest req) throws JSONException {
    Session session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    Integer id = Util.getNullInt(req, "id");
    List<PatientDrugRows> rows = new ArrayList<PatientDrugRows>();
    try {
      //
      String[] row_ids = req.getParameterValues("row_id");
      String[] date_ids = req.getParameterValues("date_id");
      String[] sources = req.getParameterValues("source_code");
      String[] drugs = req.getParameterValues("drug_drug");
      String[] names = req.getParameterValues("drug_name");
      String[] expenses = req.getParameterValues("out_count");
      String[] drug_measures = req.getParameterValues("drug_measure");
      String[] dates = req.getParameterValues("dates");
      String[] dateStates = req.getParameterValues("date_state");
      String[] date_states = req.getParameterValues("dt_state");
      //
      for(int i=0;i<sources.length;i++) {
        PatientDrugRows row = new PatientDrugRows();
        if(!row_ids[i].equals("0") && !row_ids[i].equals("")) row.setId(Integer.parseInt(row_ids[i]));
        row.setSource(sources[i]);
        if(sources[i].equals("own")) {
          row.setName(names[i]);
          if(!names[i].equals("")) {
            rows.add(row);
          }
        } else {
          if(row_ids[i].equals("0") || row_ids[i].equals("")) {
            row.setDrug(dDrug.get(Integer.parseInt(drugs[i])));
            row.setMeasure(row.getDrug().getMeasure());
          }
          row.setExpanse(Double.parseDouble(expenses[i]));
          if(!row_ids[i].equals("0") || (row.getDrug() != null && row.getExpanse() > 0))
            rows.add(row);
        }
      }
      //
      List<String> states = new ArrayList<String>();
      if(dateStates != null && dateStates.length > 0) Collections.addAll(states, dateStates);
      //
      if(id == null || id == 0) {
        if(dateStates == null || dateStates.length == 0) {
          json.put("msg", "Даты назначении не выбраны");
          json.put("success", false);
          return json.toString();
        }
        if(rows.size() == 0) {
          json.put("msg", "Список препаратов не может быть пустым");
          json.put("success", false);
          return json.toString();
        }
        PatientDrugs drug = new PatientDrugs();
        drug.setDrugType(dDict.get(Util.getInt(req, "drug_type")));
        if(Util.getInt(req, "drug_type") == 16)
          drug.setInjectionType(dDict.get(Util.getInt(req, "injection_type")));
        drug.setPatient(dPatient.get(session.getCurPat()));
        drug.setDateBegin(Util.getDate(req, "dateBegin"));
        drug.setDateEnd(Util.getDate(req, "dateEnd"));
        drug.setGoal(dLvDrugGoal.get(Util.getInt(req, "goal")));
        drug.setMorningTime(Util.isNotNull(req, "morningTime"));
        drug.setNoonTime(Util.isNotNull(req, "noonTime"));
        drug.setEveningTime(Util.isNotNull(req, "eveningTime"));
        //
        if(!drug.isMorningTime() && !drug.isNoonTime() && !drug.isEveningTime()) {
          json.put("msg", "Выбирите время приема");
          json.put("success", false);
          return json.toString();
        }
        drug.setMorningTimeBefore(Util.isNotNull(req, "morningTimeBefore"));

        drug.setMorningTimeAfter(Util.isNotNull(req, "morningTimeAfter"));
        drug.setNoonTimeBefore(Util.isNotNull(req, "noonTimeBefore"));
        drug.setNoonTimeAfter(Util.isNotNull(req, "noonTimeAfter"));
        drug.setEveningTimeBefore(Util.isNotNull(req, "eveningTimeBefore"));
        drug.setEveningTimeAfter(Util.isNotNull(req, "eveningTimeAfter"));
        //
        drug.setNote(Util.get(req, "note"));
        drug.setState("ENT");
        //
        drug.setCrBy(session.getUserId());
        drug.setCrOn(new Date());
        //
        dPatientDrug.saveAndReturn(drug);
        for (String date : dates) {
          PatientDrugDates drugDate = new PatientDrugDates();
          drugDate.setPatientDrug(drug);
          drugDate.setDate(Util.stringToDate(date));
          drugDate.setChecked(states.contains(date));
          drugDate.setState("ENT");
          dPatientDrugDate.saveAndReturn(drugDate);
        }
        for(PatientDrugRows row: rows) {
          row.setPatientDrug(drug);
          row.setState("ENT");
          dPatientDrugRow.save(row);
        }
      } else {
        PatientDrugs drug = dPatientDrug.get(Util.getInt(req, "id"));
        drug.setDrugType(dDict.get(Util.getInt(req, "drug_type")));
        if(Util.getInt(req, "drug_type") == 16)
          drug.setInjectionType(dDict.get(Util.getInt(req, "injection_type")));
        else
          drug.setInjectionType(null);
        drug.setDateBegin(Util.getDate(req, "dateBegin"));
        drug.setDateEnd(Util.getDate(req, "dateEnd"));
        drug.setGoal(dLvDrugGoal.get(Util.getInt(req, "goal")));
        //
        drug.setMorningTime(Util.isNotNull(req, "morningTime"));
        drug.setNoonTime(Util.isNotNull(req, "noonTime"));
        drug.setEveningTime(Util.isNotNull(req, "eveningTime"));
        //
        if(!drug.isMorningTime() && !drug.isNoonTime() && !drug.isEveningTime()) {
          json.put("msg", "Выбирите время приема");
          json.put("success", false);
          return json.toString();
        }
        //
        drug.setMorningTimeBefore(Util.isNotNull(req, "morningTimeBefore"));
        drug.setMorningTimeAfter(Util.isNotNull(req, "morningTimeAfter"));
        drug.setNoonTimeBefore(Util.isNotNull(req, "noonTimeBefore"));
        drug.setNoonTimeAfter(Util.isNotNull(req, "noonTimeAfter"));
        drug.setEveningTimeBefore(Util.isNotNull(req, "eveningTimeBefore"));
        drug.setEveningTimeAfter(Util.isNotNull(req, "eveningTimeAfter"));
        //
        drug.setNote(Util.get(req, "note"));
        //
        if(rows.size() == 0) {
          json.put("msg", "Список препаратов не может быть пустым");
          json.put("success", false);
          return json.toString();
        }
        List<PatientDrugDates> dbDates = dPatientDrugDate.getList("From PatientDrugDates Where patientDrug.id = " + drug.getId());
        for(PatientDrugDates dd: dbDates) dPatientDrugDate.delete(dd.getId());
        for (int i=0;i<date_ids.length;i++) {
          PatientDrugDates drugDate = new PatientDrugDates();
          drugDate.setPatientDrug(drug);
          drugDate.setDate(Util.stringToDate(dates[i]));
          if(date_ids[i].equals("0")) {
            drugDate.setChecked(states.contains(dates[i]));
            drugDate.setState("ENT");
          } else {
            drugDate.setId(Integer.parseInt(date_ids[i]));
            drugDate.setState(date_states[i]);
            if(date_states[i].equals("ENT"))
              drugDate.setChecked(states.contains(dates[i]));
          }
          dPatientDrugDate.save(drugDate);
        }
        for(PatientDrugRows row: rows) {
          if(row.getId() != null) {
            PatientDrugRows rw = dPatientDrugRow.get(row.getId());
            rw.setExpanse(row.getExpanse());
          } else {
            row.setPatientDrug(drug);
            row.setState("ENT");
            dPatientDrugRow.save(row);
          }
        }
        dPatientDrug.save(drug);
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/drugs/template/save.s", method = RequestMethod.POST) @ResponseBody
  protected String drugTemplateSave(HttpServletRequest req) throws JSONException {
    Session session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    List<PatientDrugRowTemps> rows = new ArrayList<PatientDrugRowTemps>();
    try {
      PatientDrugs d = dPatientDrug.get(Util.getInt(req, "id"));
      List<PatientDrugRows> rws = dPatientDrugRow.getList("From PatientDrugRows Where patientDrug.id = " + d.getId());
      if(rws.size() == 0) {
        json.put("success", false);
        json.put("msg", "Нельзя сохранить шаблон с пустой детализацией");
        return json.toString();
      }
      PatientDrugTemps drug = new PatientDrugTemps();
      drug.setDrugType(d.getDrugType());
      drug.setInjectionType(d.getInjectionType());
      drug.setMorningTime(d.isMorningTime());
      drug.setNoonTime(d.isNoonTime());
      drug.setEveningTime(d.isEveningTime());
      drug.setMorningTimeAfter(d.isMorningTimeAfter());
      drug.setMorningTimeBefore(d.isMorningTimeBefore());
      drug.setNoonTimeAfter(d.isNoonTimeAfter());
      drug.setNoonTimeBefore(d.isNoonTimeBefore());
      drug.setEveningTimeAfter(d.isEveningTimeAfter());
      drug.setEveningTimeBefore(d.isEveningTimeBefore());
      drug.setNote(d.getNote());
      drug.setGoal(d.getGoal());
      drug.setCrBy(session.getUserId());
      dPatientDrugTemp.saveAndReturn(drug);
      for(PatientDrugRows rw: rws) {
        PatientDrugRowTemps r = new PatientDrugRowTemps();
        r.setDrug(rw.getDrug());
        r.setExpanse(rw.getExpanse());
        r.setMeasure(rw.getMeasure());
        r.setName(rw.getName());
        r.setPatientDrug(drug);
        r.setSource(rw.getSource());
        dPatientDrugRowTemp.save(r);
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/drug/temps.s")
  protected String userDrugTemps(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    String filter = Util.toUTF8(Util.get(req, "filter", ""));
    List<PatientDrug> rows = new ArrayList<PatientDrug>();
    List<PatientDrugTemps> list = dPatientDrugTemp.getList("From PatientDrugTemps Where crBy = " + session.getUserId());
    boolean isOK;
    for(PatientDrugTemps l: list) {
      isOK = false;
      PatientDrug r = new PatientDrug();
      r.setId(l.getId());
      r.setDrugType(l.getDrugType());
      r.setInjectionType(l.getInjectionType());
      r.setNote(l.getNote());
      r.setGoal(l.getGoal());
      r.setMorningTime(l.isMorningTime());
      r.setNoonTime(l.isNoonTime());
      r.setEveningTime(l.isEveningTime());
      //
      r.setMorningTimeBefore(l.isMorningTimeBefore());
      r.setMorningTimeAfter(l.isMorningTimeAfter());
      r.setNoonTimeBefore(l.isNoonTimeBefore());
      r.setNoonTimeAfter(l.isNoonTimeAfter());
      r.setEveningTimeBefore(l.isEveningTimeBefore());
      r.setEveningTimeAfter(l.isEveningTimeAfter());
      List<PatientDrugRowTemps> tempRows = dPatientDrugRowTemp.getList("From PatientDrugRowTemps Where patientDrug.id = " + l.getId());
      List<PatientDrugRow> rws = new ArrayList<PatientDrugRow>();
      for(PatientDrugRowTemps tempRow : tempRows) {
        PatientDrugRow rw = new PatientDrugRow();
        rw.setId(0);
        if(tempRow.getSource().equals("own"))
          rw.setName(tempRow.getName());
        else
          rw.setName(tempRow.getDrug().getName());
        if(!filter.equals("") && rw.getName().toUpperCase().contains(filter.toUpperCase())) {
          isOK = true;
        }
        rw.setExpanse(tempRow.getExpanse());
        rw.setMeasure(tempRow.getMeasure());
        rws.add(rw);
      }
      r.setRows(rws);
      String time = "";
      if(r.isMorningTime()) time += "Утром" + (r.isMorningTimeBefore() ? " до еды" : "") + (r.isMorningTimeAfter() ? " после еды" : "");
      if(r.isNoonTime()) time += (time.equals("") ? "" : ", ") + "Днем" + (r.isNoonTimeBefore() ? " до еды" : "") + (r.isNoonTimeAfter() ? " после еды" : "");
      if(r.isEveningTime()) time += (time.equals("") ? "" : ", ") + "Вечером" + (r.isEveningTimeBefore() ? " до еды" : "") + (r.isEveningTimeAfter() ? " после еды" : "");
      r.setNote((time.equals("") ? "" : time + "; ") + " " + r.getNote());
      if(filter.equals("") || isOK)
        rows.add(r);
    }
    model.addAttribute("rows", rows);
    return "/med/lv/drugs/temps";
  }

  @RequestMapping(value = "/drug/temp/delete.s")
  @ResponseBody
  protected String userDrugTempDelete(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      List<PatientDrugRowTemps> rows = dPatientDrugRowTemp.getList("From PatientDrugRowTemps Where patientDrug.id = " + Util.getInt(req, "id"));
      for(PatientDrugRowTemps row: rows)
        dPatientDrugRowTemp.delete(row.getId());
      dPatientDrugTemp.delete(Util.getInt(req, "id"));
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/drugs/removePatientDrug.s", method = RequestMethod.POST)
  @ResponseBody
  protected String removePatientDrug(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    Integer id = Util.getNullInt(req, "id");
    try {
      boolean isOk = true;
      List<PatientDrugRows> rows = dPatientDrugRow.getList("From PatientDrugRows Where patientDrug.id = " + id);
      List<PatientDrugDates> dates = dPatientDrugDate.getList("From PatientDrugDates Where patientDrug.id = " + id);
      for(PatientDrugRows row: rows) {
        if(!row.getState().equals("ENT")) {
          isOk = false;
        }
      }
      for(PatientDrugDates date: dates) {
        if(!date.getState().equals("ENT")) {
          isOk = false;
        }
      }
      if(isOk) {
        for(PatientDrugRows row: rows) dPatientDrugRow.delete(row.getId());
        for(PatientDrugDates date: dates) dPatientDrugDate.delete(date.getId());
        dPatientDrug.delete(id);
        json.put("success", true);
      } else {
        json.put("msg", "Есть уже утвержденные заявки");
        json.put("success", false);
      }
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }
  //endregion

  //region SHOCK
  @RequestMapping(value = "/shock.s")
  protected String shock(HttpServletRequest request, Model model) {
    Session session = SessionUtil.getUser(request);
    Patients pat = dPatient.get(session.getCurPat());
    session.setCurSubUrl("/lv/shock.s");
    List<DrugDirections> directions = dDrugDirection.getList("From DrugDirections t Where t.shock = 'Y' And Exists (From DrugDirectionDeps c Where c.direction.id = t.id And dept.id = " + pat.getDept().getId() + ")");
    List<HNDrugs> drugs = dhnDrug.getList("From HNDrugs t Where t.drugCount - t.rasxod > 0 And Exists (From DrugDirections c Where c.id = t.direction.id And c.shock = 'Y' And Exists (From DrugDirectionDeps d Where d.direction.id = c.id And d.dept.id = " + pat.getDept().getId() + "))");
    model.addAttribute("directions", directions);
    model.addAttribute("drugs", drugs);
    model.addAttribute("rows", dPatientShock.getList("From PatientShocks Where patient.id = " + pat.getId()));
    return "/med/lv/shock";
  }

  @RequestMapping(value = "/shock/row/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String saveUser(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    Session session = SessionUtil.getUser(req);
    try {
      Patients pat = dPatient.get(session.getCurPat());
      PatientShocks shock = new PatientShocks();
      shock.setHndrug(dhnDrug.get(Util.getInt(req, "id")));
      shock.setDrug(shock.getHndrug().getDrug());
      shock.setRasxod(Double.parseDouble(Util.get(req, "rasxod")));
      shock.setPatient(pat);
      shock.setCrBy(dUser.get(session.getUserId()));
      shock.setCrOn(new Date());
      dPatientShock.save(shock);
      HNDrugs drug = shock.getHndrug();
      drug.setRasxod(drug.getRasxod() + shock.getRasxod());
      dhnDrug.save(drug);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/shock/row/delete.s", method = RequestMethod.POST)
  @ResponseBody
  protected String deleteShockRow(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      PatientShocks shock = dPatientShock.get(Util.getInt(req, "id"));
      HNDrugs drug = shock.getHndrug();
      drug.setRasxod(drug.getRasxod() - shock.getRasxod());
      dhnDrug.save(drug);
      dPatientShock.delete(shock.getId());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }
  //endregion
}
