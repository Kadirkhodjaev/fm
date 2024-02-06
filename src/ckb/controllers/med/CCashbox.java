package ckb.controllers.med;

import ckb.dao.admin.country.DCountry;
import ckb.dao.admin.params.DParam;
import ckb.dao.admin.region.DRegion;
import ckb.dao.admin.users.DUser;
import ckb.dao.med.amb.DAmbPatientPay;
import ckb.dao.med.amb.DAmbPatientService;
import ckb.dao.med.amb.DAmbPatient;
import ckb.dao.med.cashbox.discount.DCashDiscount;
import ckb.dao.med.head_nurse.date.DHNDate;
import ckb.dao.med.head_nurse.date.DHNDateAmbRow;
import ckb.dao.med.head_nurse.patient.DHNPatient;
import ckb.dao.med.lv.bio.DLvBio;
import ckb.dao.med.lv.coul.DLvCoul;
import ckb.dao.med.lv.epic.DLvEpic;
import ckb.dao.med.lv.fizio.DLvFizio;
import ckb.dao.med.lv.fizio.DLvFizioDate;
import ckb.dao.med.lv.garmon.DLvGarmon;
import ckb.dao.med.lv.plan.DKdoChoosen;
import ckb.dao.med.lv.plan.DLvPlan;
import ckb.dao.med.lv.torch.DLvTorch;
import ckb.dao.med.patient.DPatient;
import ckb.dao.med.patient.DPatientPays;
import ckb.dao.med.patient.DPatientWatchers;
import ckb.domains.med.amb.AmbPatientPays;
import ckb.domains.med.amb.AmbPatientServices;
import ckb.domains.med.amb.AmbPatients;
import ckb.domains.med.amb.AmbResults;
import ckb.domains.med.cash.CashDiscounts;
import ckb.domains.med.head_nurse.HNDateAmbRows;
import ckb.domains.med.head_nurse.HNDates;
import ckb.domains.med.head_nurse.HNPatients;
import ckb.domains.med.lv.*;
import ckb.domains.med.patient.PatientPays;
import ckb.domains.med.patient.PatientWatchers;
import ckb.domains.med.patient.Patients;
import ckb.models.AmbService;
import ckb.models.ObjList;
import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.DB;
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
import javax.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/cashbox")
public class CCashbox {

  private Session session = null;
  @Autowired private DCountry dCountery;
  @Autowired private DRegion dRegion;
  @Autowired private DAmbPatient dAmbPatients;
  @Autowired private DAmbPatientService dAmbPatientServices;
  @Autowired private DUser dUser;
  @Autowired private DAmbPatientPay dAmbPatientPay;
  // Stat buyicha
  @Autowired private DPatient dPatient;
  @Autowired private DPatientWatchers dPatientWatchers;
  @Autowired private DPatientPays dPatientPays;
  @Autowired private DLvPlan dLvPlan;
  @Autowired private DCashDiscount dCashDiscount;
  @Autowired private DLvFizio dLvFizio;
  @Autowired private DLvFizioDate dLvFizioDate;
  @Autowired private DHNPatient dhnPatient;
  //
  @Autowired private DLvBio dLvBio;
  @Autowired private DLvGarmon dLvGarmon;
  @Autowired private DLvTorch dLvTorch;
  @Autowired private DLvCoul dLvCoul;
  @Autowired private DKdoChoosen dKdoChoosen;
  @Autowired private DLvEpic dLvEpic;
  @Autowired private DHNDateAmbRow dhnDateAmbRow;
  @Autowired private DHNDate dhnDate;
  @Autowired private DParam dParam;

  @RequestMapping(value = "/setServicePayState.s", method = RequestMethod.POST)
  @ResponseBody
  protected String setServicePayState(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      AmbPatientServices service = dAmbPatientServices.get(Util.getInt(req, "id"));
      service.setState(Util.get(req, "code").equals("pay") ? "PAID" : "ENT");
      dAmbPatientServices.save(service);
      Long counter = dAmbPatientServices.getCount("From AmbPatientServices Where patient = " + Util.getInt(req, "id") + " And state = 'ENT'");
      if(counter == 0) {
        AmbPatients pat = dAmbPatients.get(service.getPatient());
        pat.setState("WORK");
        dAmbPatients.save(pat);
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
      e.printStackTrace();
    }
    return json.toString();
  }

  @RequestMapping(value = "/amb/delPay.s", method = RequestMethod.POST)
  @ResponseBody
  protected String ambDelPay(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      dAmbPatientPay.delete(Util.getInt(req, "id"));
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
      e.printStackTrace();
    }
    return json.toString();
  }

  @RequestMapping("/amb.s")
  protected String cash(HttpServletRequest req, Model m) {
    session = SessionUtil.getUser(req);
    session.setCurPat(Util.getInt(req, "id"));
    session.setCurUrl("/cashbox/amb.s?id=" + session.getCurPat());
    AmbPatients pat = dAmbPatients.get(session.getCurPat());
    m.addAttribute("patient", pat);
    if(pat.getCounteryId() != null)
      m.addAttribute("country", dCountery.get(pat.getCounteryId()).getName());
    if(pat.getRegionId() != null)
      m.addAttribute("region", dRegion.get(pat.getRegionId()).getName());
    //
    List<HNDateAmbRows> ds = dhnDateAmbRow.getList("From HNDateAmbRows Where doc.state = 'ENT' And patient.id = " + pat.getId());
    List<HNDateAmbRows> drugs = dhnDateAmbRow.getList("From HNDateAmbRows Where doc.state = 'CON' And patient.id = " + pat.getId());
    Double drugSum = 0D, drugSums = 0D;
    for(HNDateAmbRows drug: drugs) {
      if(drug.getDoc().getPaid().equals("N")) {
        drugSum += drug.getRasxod() * drug.getHndrug().getPrice();
      }
      drugSums += drug.getRasxod() * drug.getHndrug().getPrice();
    }
    //
    Double discountSum = dCashDiscount.patientAmbDiscountSum(pat.getId());
    Double paySum = dAmbPatientServices.patientTotalSum(session.getCurPat());
    m.addAttribute("serviceTotal", dAmbPatientServices.patientTotal(session.getCurPat()));
    m.addAttribute("serviceTotalSum", Math.floor((paySum + drugSum - discountSum) * 100) / 100);
    List<AmbPatientServices> services = dAmbPatientServices.getList("From AmbPatientServices Where patient = " + session.getCurPat());
    List<AmbService> ss = new ArrayList<AmbService>();
    for(AmbPatientServices s: services) {
      AmbService d = new AmbService();
      d.setId(s.getId());
      d.setState(s.getState());
      d.setService(s.getService());
      AmbResults res = new AmbResults();
      res.setId(s.getResult() == null ? 0 : s.getResult());
      d.setResult(res);
      d.setWorker(s.getWorker());
      d.setUsers(dUser.getList("From Users t Where id = " + s.getWorker().getId()));
      if(s.getPrice() != 0) {
        String sum = new DecimalFormat("###,###,###,###,###,###.##").format(s.getPrice());
        if(sum.indexOf(",") == -1)
          sum = sum + ",00";
        d.setPrice(sum);
      }
      ss.add(d);
    }
    m.addAttribute("is_admin", dUser.get(session.getUserId()).isAmbAdmin());
    m.addAttribute("services", ss);
    m.addAttribute("drugs", drugs);
    m.addAttribute("ds", ds);
    m.addAttribute("discounts", dCashDiscount.amb(pat.getId()));
    m.addAttribute("discountSum", discountSum);
    m.addAttribute("drugSum", drugSum);
    m.addAttribute("drugSums", Math.floor(drugSums * 100) / 100);
    List<AmbPatientPays> pays = dAmbPatientPay.byPatient(session.getCurPat());
    Double paid = 0D;
    for(AmbPatientPays pay: pays) {
      paid += pay.getCard() + pay.getCash() + pay.getTransfer();
    }
    m.addAttribute("paidSum", paid);
    m.addAttribute("pays", pays);
    return "med/cashbox/amb";
  }

  @RequestMapping(value = "/delDiscount.s", method = RequestMethod.POST)
  @ResponseBody
  protected String delDiscount(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      dCashDiscount.delete(Util.getInt(req, "id"));
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/discount.s", method = RequestMethod.POST)
  @ResponseBody
  protected String saveAmbDiscount(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      CashDiscounts discount = Util.isNull(req, "id") ? new CashDiscounts() : dCashDiscount.get(Util.getInt(req, "id"));
      discount.setAmbStat(Util.get(req, "code"));
      discount.setPatient(Util.getInt(req, "patient"));
      discount.setSumm(Double.parseDouble(Util.get(req, "summ")));
      discount.setText(Util.get(req, "text"));
      // Добавление
      if(Util.isNull(req, "id")) {
        discount.setCrBy(dUser.get(session.getUserId()));
        discount.setCrOn(new Date());
      }
      //
      dCashDiscount.save(discount);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("/amb/check.s")
  protected String printCheck(HttpServletRequest req, Model model) {
    session = SessionUtil.getUser(req);
    AmbPatients pat = dAmbPatients.get(session.getCurPat());
    model.addAttribute("pat", pat);
    int id = Util.getInt(req, "id");
    List<AmbPatientServices> rows = dAmbPatientServices.getList("From AmbPatientServices Where state In ('PAID', 'DONE') And patient = " + pat.getId() + (id > 0 ? " And pay = " + id : ""));
    double sum = 0;
    for(AmbPatientServices row: rows) {
      sum += row.getPrice();
    }
    if(pat.getQrcode() == null || pat.getQrcode().equals("")) {
      pat.setQrcode(Util.md5(pat.getId().toString()));
      dAmbPatients.save(pat);
    }
    model.addAttribute("cur_time", Util.getCurTime());
    model.addAttribute("rows", rows);
    model.addAttribute("sum", sum);
    model.addAttribute("sale", dCashDiscount.ambDiscountSum(pat.getId()));
    model.addAttribute("address", dParam.byCode("CHECK_ADDRESS"));
    model.addAttribute("inn", dParam.byCode("ORG_INN"));
    model.addAttribute("org_name", dParam.byCode("CHECK_ORG_NAME"));
    model.addAttribute("deviz", dParam.byCode("DEVIZ"));
    model.addAttribute("qrcode", dParam.byCode("QRCODE"));
    model.addAttribute("qrcodeurl", dParam.byCode("QRCODEURL"));
    model.addAttribute("casher", session.getUserName());
    return "med/cashbox/check";
  }

  @RequestMapping(value = "/getDiscount.s", method = RequestMethod.POST)
  @ResponseBody
  protected String getDiscount(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      CashDiscounts discount = dCashDiscount.get(Util.getInt(req, "id"));
      //
      json.put("id", discount.getId());
      json.put("summ", discount.getSumm());
      json.put("text", discount.getText());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/amb.s", method = RequestMethod.POST)
  @ResponseBody
  protected String cashSave(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      AmbPatients patient = dAmbPatients.get(session.getCurPat());
      AmbPatientPays pay = new AmbPatientPays();
      pay.setPatient(patient.getId());
      //
      pay.setPayType(Util.get(req, "pay_type"));
      pay.setCard(Double.parseDouble(Util.get(req, "card", "0")));
      pay.setCash(Double.parseDouble(Util.get(req, "cash", "0")));
      pay.setTransfer(Double.parseDouble(Util.get(req, "transfer", "0")));
      if(!pay.getPayType().equals("pay")) {
        pay.setCard(pay.getCard() > 0 ? -1*pay.getCard() : 0D);
        pay.setCash(pay.getCash() > 0 ? -1*pay.getCash() : 0D);
        pay.setTransfer(pay.getTransfer() > 0 ? -1*pay.getTransfer() : 0D);
      }
      //
      pay.setCrBy(session.getUserId());
      pay.setCrOn(new Date());
      dAmbPatientPay.save(pay);
      //
      if(pay.getPayType().equals("pay")) {
        if ("CASH".equals(patient.getState())) patient.setState("WORK");
        dAmbPatients.save(patient);
        List<AmbPatientServices> services = dAmbPatientServices.getList("From AmbPatientServices Where patient = " + session.getCurPat());
        for (AmbPatientServices service : services) {
          if ("ENT".equals(service.getState())) {
            service.setPay(pay.getId());
            service.setState("PAID");
            service.setCashDate(new Date());
            dAmbPatientServices.save(service);
          }
        }
      }
      List<HNDateAmbRows> drugs = dhnDateAmbRow.getList("From HNDateAmbRows Where doc.state = 'CON' And doc.paid != 'Y' And patient.id = " + patient.getId());
      if(drugs.size() > 0) {
        HNDates date = drugs.get(0).getDoc();
        date.setPaid("Y");
        dhnDate.save(date);
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/cashFizioState.s", method = RequestMethod.POST)
  @ResponseBody
  protected String cashPlanState(HttpServletRequest req, HttpServletResponse res) throws JSONException {
    JSONObject data = new JSONObject();
    res.setContentType("text/plain;charset=UTF-8");
    try {
      LvFizios fizio = dLvFizio.get(Util.getInt(req, "id"));
      if(Util.get(req, "code").equals("C")) {
        Long counter = dLvFizioDate.getStateCount(fizio.getId());
        fizio.setPaidSum(fizio.getPrice() * counter);
        fizio.setPaidCount(Integer.parseInt(counter.toString()));
        fizio.setPaid("Y");
        fizio.setPayDate(new Date());
      } else {
        fizio.setPaidSum(0D);
        fizio.setPaidCount(0);
        fizio.setPaid("N");
        fizio.setPayDate(null);
      }
      dLvFizio.save(fizio);
      data.put("success", true);
    } catch (Exception e) {
      data.put("success", false);
      data.put("msg", e.getMessage());
    }
    return data.toString();
  }

  @RequestMapping("stat.s")
  protected String statCash(HttpServletRequest request, Model model) {
    session = SessionUtil.getUser(request);
    if(!(session.getCurPat() > 0)) session.setCurPat(Util.getInt(request, "id"));
    session.setCurUrl("/cashbox/stat.s?id=" + session.getCurPat());
    Patients pat = dPatient.get(session.getCurPat());
    model.addAttribute("pat", pat);
    if(pat.getLv_id() != null)
      model.addAttribute("lv", dUser.get(pat.getLv_id()));
    //
    Double KOYKA_PRICE_LUX_UZB = Double.parseDouble(session.getParam("KOYKA_PRICE_LUX_UZB"));
    Double KOYKA_PRICE_SIMPLE_UZB = Double.parseDouble(session.getParam("KOYKA_PRICE_SIMPLE_UZB"));
    Double KOYKA_SEMILUX_UZB = Double.parseDouble(session.getParam("KOYKA_SEMILUX_UZB"));
    Double KOYKA_PRICE_LUX = Double.parseDouble(session.getParam("KOYKA_PRICE_LUX"));
    Double KOYKA_PRICE_SIMPLE = Double.parseDouble(session.getParam("KOYKA_PRICE_SIMPLE"));
    Double KOYKA_SEMILUX = Double.parseDouble(session.getParam("KOYKA_SEMILUX"));
    Double discountSum = dCashDiscount.patientStatDiscountSum(pat.getId());
    Double total = 0D;
    //
    List<LvEpics> epics = dLvEpic.getPatientEpics(pat.getId());
    List<ObjList> eps = new ArrayList<ObjList>();
    Long minusDays = 0L;
    for(LvEpics epic: epics) {
      ObjList obj = new ObjList();
      if(epic.getDateBegin() == null) {
        epic.setDateBegin(pat.getDateBegin());
      }
      Long days = (epic.getDateEnd().getTime() - epic.getDateBegin().getTime()) / (1000*60*60*24);
      obj.setC1("" + days);
      minusDays += days;
      // 5 - Люкс, 6 - Простой, 7 - Полулюкс
      obj.setC2(epic.getRoom().getRoomType().getName());
      if(pat.getCounteryId() == 199) { // Узбекистан
        if(epic.getRoom().getRoomType().getId() == 5)  // Люкс
          obj.setC3(((pat.getDayCount() == null ? 0 : days) * KOYKA_PRICE_LUX_UZB) + "");
        else if(epic.getRoom().getRoomType().getId() == 6) // Протая
          obj.setC3(((pat.getDayCount() == null ? 0 : days) * KOYKA_PRICE_SIMPLE_UZB) + "");
        else // Полулюкс
          obj.setC3(((pat.getDayCount() == null ? 0 : days) * KOYKA_SEMILUX_UZB) + "");
      } else {
        if(epic.getRoom().getRoomType().getId() == 5)  // Люкс
          obj.setC3(((pat.getDayCount() == null ? 0 : days) * KOYKA_PRICE_LUX) + "");
        else if(epic.getRoom().getRoomType().getId() == 6) // Протая
          obj.setC3(((pat.getDayCount() == null ? 0 : days) * KOYKA_PRICE_SIMPLE) + "");
        else // Полулюкс
          obj.setC3(((pat.getDayCount() == null ? 0 : days) * KOYKA_SEMILUX) + "");
      }
      total += Double.parseDouble(obj.getC3());
      eps.add(obj);
    }
    model.addAttribute("epics", eps);
    //
    if(pat.getCounteryId() == 199) { // Узбекистан
      if(pat.getRoom().getRoomType().getId() == 5)  // Люкс
        total += (pat.getDayCount() == null ? 0 : pat.getDayCount() - minusDays) * KOYKA_PRICE_LUX_UZB;
      else if(pat.getRoom().getRoomType().getId() == 6) // Протая
        total += (pat.getDayCount() == null ? 0 : pat.getDayCount() - minusDays) * KOYKA_PRICE_SIMPLE_UZB;
      else // Полулюкс
        total += (pat.getDayCount() == null ? 0 : pat.getDayCount() - minusDays) * KOYKA_SEMILUX_UZB;
    } else {
      if(pat.getRoom().getRoomType().getId() == 5)  // Люкс
        total += (pat.getDayCount() == null ? 0 : pat.getDayCount() - minusDays) * KOYKA_PRICE_LUX;
      else if(pat.getRoom().getRoomType().getId() == 6) // Протая
        total += (pat.getDayCount() == null ? 0 : pat.getDayCount() - minusDays) * KOYKA_PRICE_SIMPLE;
      else // Полулюкс
        total += (pat.getDayCount() == null ? 0 : pat.getDayCount() - minusDays) * KOYKA_SEMILUX;
    }
    model.addAttribute("minusDays", minusDays);
    model.addAttribute("koykoTotal", total);
    List<PatientWatchers> watchers = dPatientWatchers.byPatient(pat.getId());
    for(PatientWatchers watcher: watchers) {
      total += watcher.getTotal();
    }
    model.addAttribute("watchers", watchers);
    //
    List<LvFizios> fizios = dLvFizio.getPaidServices(pat.getId());
    List<ObjList> pfizios = new ArrayList<ObjList>();
    for(LvFizios fizio: fizios) {
      ObjList ds = new ObjList();
      ds.setC1(fizio.getKdo().getName());
      ds.setC2(Util.dateToString(fizio.getActDate()));
      ds.setPrice(fizio.getPrice());
      ds.setCounter(dLvFizioDate.getStateCount(fizio.getId()));
      pfizios.add(ds);
      if(fizio.getPaid().equals("N")) {
        Long counter = dLvFizioDate.getStateCount(fizio.getId());
        total += fizio.getPrice() * (counter == null ? 0 : counter) - (fizio.getPaidSum() != null ? fizio.getPaidSum() : 0);
      }
    }
    model.addAttribute("fizios", pfizios);
    // Услуги
    List<LvPlans> plans = dLvPlan.getByPatientId(pat.getId());
    List<LvPlans> plns = new ArrayList<LvPlans>();
    List<ObjList> planDetails = new ArrayList<ObjList>();
    for(LvPlans plan: plans) {
      if(plan.getPrice() != null)
        total += plan.getPrice();
      // Торч - Garmon - Каулограмма - Биохимия
      if(plan.getKdo().getId() == 121 || plan.getKdo().getId() == 120 || plan.getKdo().getId() == 56 || plan.getKdo().getId() == 153) {
        if (plan.getKdo().getId() == 153) {
          LvBios bio = dLvBio.getByPlan(plan.getId());
          if (bio != null) {
            if (bio.getC1() == 1) {
              ObjList ll = new ObjList();
              ll.setC1("Умумий оксил");
              ll.setPrice(dKdoChoosen.getPrice(pat.getCounteryId(), 153, 1));
              ll.setDate(Util.dateToString(plan.getActDate()));
              planDetails.add(ll);
            }
            if (bio.getC2() == 1) {
              ObjList ll = new ObjList();
              ll.setC1("Холестерин");
              ll.setPrice(dKdoChoosen.getPrice(pat.getCounteryId(), 153, 2));
              ll.setDate(Util.dateToString(plan.getActDate()));
              planDetails.add(ll);
            }
            if (bio.getC3() == 1) {
              ObjList ll = new ObjList();
              ll.setC1("Глюкоза");
              ll.setPrice(dKdoChoosen.getPrice(pat.getCounteryId(), 153, 3));
              ll.setDate(Util.dateToString(plan.getActDate()));
              planDetails.add(ll);
            }
            if (bio.getC4() == 1) {
              ObjList ll = new ObjList();
              ll.setC1("Мочевина");
              ll.setPrice(dKdoChoosen.getPrice(pat.getCounteryId(), 153, 4));
              ll.setDate(Util.dateToString(plan.getActDate()));
              planDetails.add(ll);
            }
            if (bio.getC5() == 1) {
              ObjList ll = new ObjList();
              ll.setC1("Креатинин");
              ll.setPrice(dKdoChoosen.getPrice(pat.getCounteryId(), 153, 5));
              ll.setDate(Util.dateToString(plan.getActDate()));
              planDetails.add(ll);
            }
            if (bio.getC6() == 1) {
              ObjList ll = new ObjList();
              ll.setC1("Билирубин");
              ll.setPrice(dKdoChoosen.getPrice(pat.getCounteryId(), 153, 6));
              ll.setDate(Util.dateToString(plan.getActDate()));
              planDetails.add(ll);
            }
            if (bio.getC7() == 1) {
              ObjList ll = new ObjList();
              ll.setC1("АЛТ");
              ll.setPrice(dKdoChoosen.getPrice(pat.getCounteryId(), 153, 7));
              ll.setDate(Util.dateToString(plan.getActDate()));
              planDetails.add(ll);
            }
            if (bio.getC8() == 1) {
              ObjList ll = new ObjList();
              ll.setC1("АСТ");
              ll.setPrice(dKdoChoosen.getPrice(pat.getCounteryId(), 153, 8));
              ll.setDate(Util.dateToString(plan.getActDate()));
              planDetails.add(ll);
            }
            if (bio.getC9() == 1) {
              ObjList ll = new ObjList();
              ll.setC1("Альфа амилаза");
              ll.setPrice(dKdoChoosen.getPrice(pat.getCounteryId(), 153, 9));
              ll.setDate(Util.dateToString(plan.getActDate()));
              planDetails.add(ll);
            }
            if (bio.getC10() == 1) {
              ObjList ll = new ObjList();
              ll.setC1("Кальций");
              ll.setPrice(dKdoChoosen.getPrice(pat.getCounteryId(), 153, 10));
              ll.setDate(Util.dateToString(plan.getActDate()));
              planDetails.add(ll);
            }
            if (bio.getC11() == 1) {
              ObjList ll = new ObjList();
              ll.setC1("Сийдик кислотаси");
              ll.setPrice(dKdoChoosen.getPrice(pat.getCounteryId(), 153, 11));
              ll.setDate(Util.dateToString(plan.getActDate()));
              planDetails.add(ll);
            }
            if (bio.getC12() == 1) {
              ObjList ll = new ObjList();
              ll.setC1("K – калий");
              ll.setPrice(dKdoChoosen.getPrice(pat.getCounteryId(), 153, 12));
              ll.setDate(Util.dateToString(plan.getActDate()));
              planDetails.add(ll);
            }
            if (bio.getC13() == 1) {
              ObjList ll = new ObjList();
              ll.setC1("Na – натрий");
              ll.setPrice(dKdoChoosen.getPrice(pat.getCounteryId(), 153, 13));
              ll.setDate(Util.dateToString(plan.getActDate()));
              planDetails.add(ll);
            }
            if (bio.getC14() == 1) {
              ObjList ll = new ObjList();
              ll.setC1("Fe – темир");
              ll.setPrice(dKdoChoosen.getPrice(pat.getCounteryId(), 153, 14));
              ll.setDate(Util.dateToString(plan.getActDate()));
              planDetails.add(ll);
            }
            if (bio.getC15() == 1) {
              ObjList ll = new ObjList();
              ll.setC1("Mg – магний");
              ll.setPrice(dKdoChoosen.getPrice(pat.getCounteryId(), 153, 15));
              ll.setDate(Util.dateToString(plan.getActDate()));
              planDetails.add(ll);
            }
            if (bio.getC16() == 1) {
              ObjList ll = new ObjList();
              ll.setC1("Ишкорий фасфотаза");
              ll.setPrice(dKdoChoosen.getPrice(pat.getCounteryId(), 153, 16));
              ll.setDate(Util.dateToString(plan.getActDate()));
              planDetails.add(ll);
            }
            if (bio.getC17() == 1) {
              ObjList ll = new ObjList();
              ll.setC1("ГГТ");
              ll.setPrice(dKdoChoosen.getPrice(pat.getCounteryId(), 153, 17));
              ll.setDate(Util.dateToString(plan.getActDate()));
              planDetails.add(ll);
            }
            if (bio.getC18() == 1) {
              ObjList ll = new ObjList();
              ll.setC1("Гликирланган гемоглобин");
              ll.setPrice(dKdoChoosen.getPrice(pat.getCounteryId(), 153, 18));
              ll.setDate(Util.dateToString(plan.getActDate()));
              planDetails.add(ll);
            }
            if (bio.getC19() == 1) {
              ObjList ll = new ObjList();
              ll.setC1("РФ");
              ll.setPrice(dKdoChoosen.getPrice(pat.getCounteryId(), 153, 19));
              ll.setDate(Util.dateToString(plan.getActDate()));
              planDetails.add(ll);
            }
            if (bio.getC20() == 1) {
              ObjList ll = new ObjList();
              ll.setC1("АСЛО");
              ll.setPrice(dKdoChoosen.getPrice(pat.getCounteryId(), 153, 20));
              ll.setDate(Util.dateToString(plan.getActDate()));
              planDetails.add(ll);
            }
            if (bio.getC21() == 1) {
              ObjList ll = new ObjList();
              ll.setC1("СРБ");
              ll.setPrice(dKdoChoosen.getPrice(pat.getCounteryId(), 153, 21));
              ll.setDate(Util.dateToString(plan.getActDate()));
              planDetails.add(ll);
            }
            if (bio.getC22() == 1) {
              ObjList ll = new ObjList();
              ll.setC1("RW");
              ll.setPrice(dKdoChoosen.getPrice(pat.getCounteryId(), 153, 22));
              ll.setDate(Util.dateToString(plan.getActDate()));
              planDetails.add(ll);
            }
            if (bio.getC23() == 1) {
              ObjList ll = new ObjList();
              ll.setC1("Hbs Ag");
              ll.setPrice(dKdoChoosen.getPrice(pat.getCounteryId(), 153, 23));
              ll.setDate(Util.dateToString(plan.getActDate()));
              planDetails.add(ll);
            }
            if (bio.getC24() == 1) {
              ObjList ll = new ObjList();
              ll.setC1("Гепатит «С» ВГС");
              ll.setPrice(dKdoChoosen.getPrice(pat.getCounteryId(), 153, 24));
              ll.setDate(Util.dateToString(plan.getActDate()));
              planDetails.add(ll);
            }
          }
        }
        if (plan.getKdo().getId() == 56) { // Каулограмма
          LvCouls bio = dLvCoul.getByPlan(plan.getId());
          if (bio != null) {
            if (bio.isC4()) {
              ObjList ll = new ObjList();
              ll.setC1("ПТИ");
              ll.setPrice(dKdoChoosen.getPrice(pat.getCounteryId(), 56, 4));
              ll.setDate(Util.dateToString(plan.getActDate()));
              planDetails.add(ll);
            }
            if (bio.isC1()) {
              ObjList ll = new ObjList();
              ll.setC1("Фибриноген");
              ll.setPrice(dKdoChoosen.getPrice(pat.getCounteryId(), 56, 1));
              ll.setDate(Util.dateToString(plan.getActDate()));
              planDetails.add(ll);
            }
            if (bio.isC2()) {
              ObjList ll = new ObjList();
              ll.setC1("Тромбин вакти");
              ll.setPrice(dKdoChoosen.getPrice(pat.getCounteryId(), 56, 2));
              ll.setDate(Util.dateToString(plan.getActDate()));
              planDetails.add(ll);
            }
            if (bio.isC3()) {
              ObjList ll = new ObjList();
              ll.setC1("А.Ч.Т.В. (сек)");
              ll.setPrice(dKdoChoosen.getPrice(pat.getCounteryId(), 56, 3));
              ll.setDate(Util.dateToString(plan.getActDate()));
              planDetails.add(ll);
            }
          }
        }
        if (plan.getKdo().getId() == 120) { // Garmon
          LvGarmons bio = dLvGarmon.getByPlan(plan.getId());
          if (bio != null) {
            if (bio.isC1()) {
              ObjList ll = new ObjList();
              ll.setC1("ТТГ");
              ll.setPrice(dKdoChoosen.getPrice(pat.getCounteryId(), 120, 1));
              ll.setDate(Util.dateToString(plan.getActDate()));
              planDetails.add(ll);
            }
            if (bio.isC2()) {
              ObjList ll = new ObjList();
              ll.setC1("Т4");
              ll.setPrice(dKdoChoosen.getPrice(pat.getCounteryId(), 120, 2));
              ll.setDate(Util.dateToString(plan.getActDate()));
              planDetails.add(ll);
            }
            if (bio.isC3()) {
              ObjList ll = new ObjList();
              ll.setC1("Т3");
              ll.setPrice(dKdoChoosen.getPrice(pat.getCounteryId(), 120, 3));
              ll.setDate(Util.dateToString(plan.getActDate()));
              planDetails.add(ll);
            }
            if (bio.isC4()) {
              ObjList ll = new ObjList();
              ll.setC1("Анти-ТРО");
              ll.setPrice(dKdoChoosen.getPrice(pat.getCounteryId(), 120, 4));
              ll.setDate(Util.dateToString(plan.getActDate()));
              planDetails.add(ll);
            }
          }
        }
        if (plan.getKdo().getId() == 121) { // Торч
          LvTorchs bio = dLvTorch.getByPlan(plan.getId());
          if (bio != null) {
            if (bio.isC1()) {
              ObjList ll = new ObjList();
              ll.setC1("Хламидия");
              ll.setPrice(dKdoChoosen.getPrice(pat.getCounteryId(), 121, 1));
              ll.setDate(Util.dateToString(plan.getActDate()));
              planDetails.add(ll);
            }
            if (bio.isC2()) {
              ObjList ll = new ObjList();
              ll.setC1("Токсоплазма");
              ll.setPrice(dKdoChoosen.getPrice(pat.getCounteryId(), 121, 2));
              ll.setDate(Util.dateToString(plan.getActDate()));
              planDetails.add(ll);
            }
            if (bio.isC3()) {
              ObjList ll = new ObjList();
              ll.setC1("ЦМВ");
              ll.setPrice(dKdoChoosen.getPrice(pat.getCounteryId(), 121, 3));
              ll.setDate(Util.dateToString(plan.getActDate()));
              planDetails.add(ll);
            }
            if (bio.isC4()) {
              ObjList ll = new ObjList();
              ll.setC1("ВПГ");
              ll.setPrice(dKdoChoosen.getPrice(pat.getCounteryId(), 121, 4));
              ll.setDate(Util.dateToString(plan.getActDate()));
              planDetails.add(ll);
            }
          }
        }
      } else {
        plns.add(plan);
      }
    }
    model.addAttribute("planDetails", planDetails);
    model.addAttribute("plans", plns);
    //
    List<PatientPays> pays = dPatientPays.byPatient(pat.getId());
    for(PatientPays pay: pays) {
      total = total - (pay.getCard() + pay.getCash() + pay.getTransfer());
    }
    model.addAttribute("pays", pays);
    model.addAttribute("discountSum", discountSum);
    model.addAttribute("lvs", dUser.getLvs());
    model.addAttribute("country", pat.getCounteryId() != null ? dCountery.get(pat.getCounteryId()).getName() : "");
    model.addAttribute("region", pat.getRegionId() != null ? dRegion.get(pat.getRegionId()).getName() : "");
    model.addAttribute("discounts", dCashDiscount.stat(pat.getId()));
    double paid = 0D;
    for(PatientPays pay: pays) {
      paid += pay.getCard() + pay.getCash() + pay.getTransfer();
    }
    model.addAttribute("paidSum", paid);
    try {
      HNPatients hnPatient = dhnPatient.getObj("From HNPatients Where state = 'D' And patient.id = " + pat.getId());
      if(hnPatient != null) {
        model.addAttribute("actExist", true);
        model.addAttribute("actSum", hnPatient.getPaySum());
        if(Math.abs(paid - hnPatient.getTotalSum()) <= 1) {
          model.addAttribute("serviceTotal", 0);
        } else {
          model.addAttribute("serviceTotal", hnPatient.getTotalSum() - paid - discountSum);
        }
      }
    } catch (Exception e) {
      model.addAttribute("actExist", false);
      model.addAttribute("actSum", 0);
      model.addAttribute("serviceTotal", total - discountSum);
    }
    return "med/cashbox/stat";
  }

  @RequestMapping(value = "stat.s", method = RequestMethod.POST)
  protected @ResponseBody String statCashSave(HttpServletRequest req, HttpServletResponse res) throws JSONException {
    JSONObject data = new JSONObject();
    res.setContentType("text/plain;charset=UTF-8");
    try {
      PatientPays pay = new PatientPays();
      pay.setPatient_id(Util.getInt(req, "id"));
      pay.setCrBy(session.getUserId());
      pay.setCrOn(new Date());
      pay.setCard(Double.parseDouble(Util.nvl(req, "card", "0")));
      pay.setTransfer(Double.parseDouble(Util.nvl(req, "transfer", "0")));
      pay.setCash(Double.parseDouble(Util.nvl(req, "cash", "0")));
      pay.setPayType(Util.get(req, "pay_type"));
      if(!pay.getPayType().equals("pay")) {
        pay.setCard(pay.getCard() > 0 ? -1*pay.getCard() : pay.getCard());
        pay.setCash(pay.getCash() > 0 ? -1*pay.getCash() : pay.getCash());
        pay.setTransfer(pay.getTransfer() > 0 ? -1*pay.getTransfer() : pay.getTransfer());
      }
      dPatientPays.save(pay);
      List<PatientWatchers> watchers = dPatientWatchers.byPatient(pay.getPatient_id());
      for(PatientWatchers watcher: watchers) {
        if(watcher.getState().equalsIgnoreCase("ent")) {
          watcher.setState("PAID");
          dPatientWatchers.save(watcher);
        }
      }
      Patients pat = dPatient.get(Util.getInt(req, "id"));
      Double KOYKA_PRICE_LUX_UZB = Double.parseDouble(session.getParam("KOYKA_PRICE_LUX_UZB"));
      Double KOYKA_PRICE_SIMPLE_UZB = Double.parseDouble(session.getParam("KOYKA_PRICE_SIMPLE_UZB"));
      Double KOYKA_PRICE_LUX = Double.parseDouble(session.getParam("KOYKA_PRICE_LUX"));
      Double KOYKA_PRICE_SIMPLE = Double.parseDouble(session.getParam("KOYKA_PRICE_SIMPLE"));
      Double KOYKA_SEMILUX = Double.parseDouble(session.getParam("KOYKA_SEMILUX"));
      Double KOYKA_SEMILUX_UZB = Double.parseDouble(session.getParam("KOYKA_SEMILUX_UZB"));
      //
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
      Double paid = 0D;
      List<PatientPays> pays = dPatientPays.getList("From PatientPays t Where t.patient_id = " + pat.getId());
      for(PatientPays py: pays)
        paid += py.getCard() + py.getTransfer() + py.getCash();
      for(PatientWatchers watcher: watchers) {
        total += watcher.getTotal();
      }
      if(paid.equals(total))
        pat.setPaid("Y");
      if(!paid.equals(total))
        pat.setPaid("C");
      dPatient.save(pat);
      data.put("success", true);
    } catch (Exception e) {
      data.put("success", false);
      data.put("msg", e.getMessage());
    }
    return data.toString();
  }

  @RequestMapping(value = "closeib.s", method = RequestMethod.POST)
  protected @ResponseBody String closeIb(HttpServletRequest req, HttpServletResponse res) throws JSONException {
    JSONObject data = new JSONObject();
    res.setContentType("text/plain;charset=UTF-8");
    try {
      Patients pat = dPatient.get(Util.getInt(req, "id"));
      pat.setPaid("CLOSED");
      dPatient.save(pat);
      data.put("success", true);
    } catch (Exception e) {
      data.put("success", false);
      data.put("msg", e.getMessage());
    }
    return data.toString();
  }

  @RequestMapping(value = "setKoyko.s", method = RequestMethod.POST)
  protected @ResponseBody String setKoyko(HttpServletRequest req, HttpServletResponse res) throws JSONException {
    JSONObject data = new JSONObject();
    res.setContentType("text/plain;charset=UTF-8");
    try {
      Patients pat = dPatient.get(Util.getInt(req, "id"));
      pat.setDayCount(Util.getInt(req, "koyko"));
      dPatient.save(pat);
      data.put("success", true);
    } catch (Exception e) {
      data.put("success", false);
      data.put("msg", e.getMessage());
    }
    return data.toString();
  }

  @RequestMapping(value = "/stat/delPay.s", method = RequestMethod.POST)
  @ResponseBody
  protected String statDelPay(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      dPatientPays.delete(Util.getInt(req, "id"));
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
      e.printStackTrace();
    }
    return json.toString();
  }

  @RequestMapping(value = "/stat/delWatcher.s", method = RequestMethod.POST)
  @ResponseBody
  protected String statDelWatcher(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      dPatientWatchers.delete(Util.getInt(req, "id"));
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
      e.printStackTrace();
    }
    return json.toString();
  }

  @RequestMapping("/statistic.s")
  protected String cashStat(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/cashbox/statistic.s");
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      conn = DB.getConnection();
      String startDate = Util.get(req, "period_start", Util.getCurDate());
      String endDate = Util.get(req, "period_end", Util.getCurDate());
      ps = conn.prepareStatement("SELECT Sum(t.card + t.transfer + t.cash) total, Sum(t.card) card, Sum(t.transfer) transfer, Sum(t.cash) cash FROM Amb_Patient_Pays t Where t.crOn between ? and ? ");
      ps.setString(1, Util.dateDBBegin(startDate));
      ps.setString(2, Util.dateDBEnd(endDate));
      rs = ps.executeQuery();
      ObjList obj = new ObjList();
      if(rs.next()){
        obj.setC1(rs.getString("card") == null ? "0" : rs.getString("card"));
        obj.setC3(rs.getString("transfer") == null ? "0" : rs.getString("transfer"));
        obj.setC4(rs.getString("cash") == null ? "0" : rs.getString("cash"));
        obj.setC20(rs.getString("total") == null ? "0" : rs.getString("total"));
      } else {
        obj.setC1("0");
        obj.setC2("0");
        obj.setC3("0");
        obj.setC4("0");
      }
      ps = conn.prepareStatement("SELECT Sum(t.card + t.transfer + t.cash) total, Sum(t.card) card, Sum(t.transfer) transfer, Sum(t.cash) cash FROM Patient_Pays t WHERE date(t.crOn) between ? and ? ");
      ps.setString(1, Util.dateDB(startDate));
      ps.setString(2, Util.dateDB(endDate));
      rs = ps.executeQuery();
      if(rs.next()){
        obj.setC5(rs.getString("card") == null ? "0" : rs.getString("card"));
        obj.setC7(rs.getString("transfer") == null ? "0" : rs.getString("transfer"));
        obj.setC8(rs.getString("cash") == null ? "0" : rs.getString("cash"));
        obj.setC10(rs.getString("total") == null ? "0" : rs.getString("total"));
      } else {
        obj.setC5("0");
        obj.setC6("0");
        obj.setC7("0");
        obj.setC8("0");
      }
      model.addAttribute("obj", obj);
      model.addAttribute("period_start", startDate);
      model.addAttribute("period_end", endDate);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(conn);
    }
    return "med/cashbox/statistic";
  }

  @RequestMapping(value = "stat/setDisPerc.s", method = RequestMethod.POST)
  @ResponseBody
  protected String statDisPerc(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      Patients p = dPatient.get(Util.getInt(req, "id"));
      p.setDis_perc(Double.parseDouble(Util.get(req, "perc", "0")));
      dPatient.save(p);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

}
