package ckb.controllers.med;

import ckb.dao.admin.users.DUser;
import ckb.dao.med.cashbox.discount.DCashDiscount;
import ckb.dao.med.head_nurse.patient.DHNPatient;
import ckb.dao.med.head_nurse.patient.drugs.DHNPatientDrug;
import ckb.dao.med.head_nurse.patient.kdos.DHNPatientKdo;
import ckb.dao.med.kdos.DKdos;
import ckb.dao.med.lv.bio.DLvBio;
import ckb.dao.med.lv.coul.DLvCoul;
import ckb.dao.med.lv.epic.DLvEpic;
import ckb.dao.med.lv.garmon.DLvGarmon;
import ckb.dao.med.lv.plan.DKdoChoosen;
import ckb.dao.med.lv.plan.DLvPlan;
import ckb.dao.med.lv.torch.DLvTorch;
import ckb.dao.med.patient.DPatient;
import ckb.dao.med.patient.DPatientPays;
import ckb.dao.med.patient.DPatientPlan;
import ckb.dao.med.patient.DPatientWatchers;
import ckb.domains.admin.Kdos;
import ckb.domains.med.head_nurse.HNPatientDrugs;
import ckb.domains.med.head_nurse.HNPatientKdos;
import ckb.domains.med.head_nurse.HNPatients;
import ckb.domains.med.lv.*;
import ckb.domains.med.patient.PatientPays;
import ckb.domains.med.patient.PatientWatchers;
import ckb.domains.med.patient.Patients;
import ckb.models.ObjList;
import ckb.services.med.patient.SPatient;
import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.BeanSession;
import ckb.utils.BeanUsers;
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
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.concurrent.TimeUnit;

@Controller
@RequestMapping("/act/")
public class CAct {

  private Session session = null;

  @Autowired private DHNPatient dhnPatient;
  @Autowired private DHNPatientDrug dhnPatientDrug;
  @Autowired private DHNPatientKdo dhnPatientKdo;
  @Autowired private DPatientPays dPatientPay;
  @Autowired private DKdos dKdo;
  @Autowired private SPatient sPatient;
  @Autowired private DPatient dPatient;
  @Autowired private DUser dUser;
  @Autowired private DPatientWatchers dPatientWatcher;
  @Autowired private DLvBio dLvBio;
  @Autowired private DKdoChoosen dKdoChoosen;
  @Autowired private DLvCoul dLvCoul;
  @Autowired private DLvGarmon dLvGarmon;
  @Autowired private DLvTorch dLvTorch;
  @Autowired private DLvPlan dLvPlan;
  @Autowired private DPatientPlan dPatientPlan;
  @Autowired private DLvEpic dLvEpic;
  @Autowired private DCashDiscount dCashDiscount;
  @Autowired private BeanUsers beanUsers;
  @Autowired private BeanSession beanSession;

  int lgotaDays = 10;
  Date startDate = Util.stringToDate("31.03.2024");

  @RequestMapping("index.s")
  protected String patients(HttpServletRequest req, Model m) {
    session = SessionUtil.getUser(req);
    session.setCurUrl("/act/index.s");
    Calendar start = Calendar.getInstance();
    start.setTime(new Date());
    start.add(Calendar.DATE, -4);
    Calendar end = Calendar.getInstance();
    end.setTime(new Date());
    end.add(Calendar.DATE, 2);
    String sd = session.getFilters("act_start_date", Util.dateToString(start.getTime()));
    String ed = session.getFilters("act_end_date", Util.dateToString(end.getTime()));
    String sw = session.getFilters("act_word", null);
    String startDate = Util.get(req, "period_start", sd);
    String endDate = Util.get(req, "period_end", ed);
    String filter = Util.get(req, "word", sw);
    session.setFilters("act_start_date", startDate);
    session.setFilters("act_end_date", endDate);
    session.setFilters("act_word", filter);
    //
    String where = "";
    if(filter != null) {
      where = " (patient.id like '" + filter + "' Or Upper(patient.surname) like '%" + filter.toUpperCase() + "%' Or Upper(patient.name) like '%" + filter.toUpperCase() + "%' Or Upper(patient.middlename) like '%" + filter.toUpperCase() + "%' Or patient.yearNum like '%" + filter.toUpperCase() + "%') And ";
    }
    m.addAttribute("rows", dhnPatient.getList("From HNPatients t Where " + where + " t.state != 'E' And (t.dateEnd = null Or t.dateEnd Between '" + Util.dateDB(startDate) + "' And '" + Util.dateDB(endDate) + "') Order By t.id Desc"));
    m.addAttribute("filter", filter);
    m.addAttribute("period_start", startDate);
    m.addAttribute("period_end", endDate);
    return "med/act/index";
  }

  private void importChoosenKdos(HNPatientKdos obj, Integer plan) {
    if(obj.getKdo().getId() == 153) {
      LvBios checker = dLvBio.getByPlan(plan);
      if (checker == null) return;
      List<KdoChoosens> choosens = dKdoChoosen.getList("From KdoChoosens Where kdo.id = " + obj.getKdo().getId());
      for(KdoChoosens choosen: choosens) {
        if(choosen.getOrd() == 1 && checker.getC1() != 1) continue;
        if(choosen.getOrd() == 2 && checker.getC2() != 1) continue;
        if(choosen.getOrd() == 3 && checker.getC3() != 1) continue;
        if(choosen.getOrd() == 4 && checker.getC4() != 1) continue;
        if(choosen.getOrd() == 5 && checker.getC5() != 1) continue;
        if(choosen.getOrd() == 6 && checker.getC6() != 1) continue;
        if(choosen.getOrd() == 7 && checker.getC7() != 1) continue;
        if(choosen.getOrd() == 8 && checker.getC8() != 1) continue;
        if(choosen.getOrd() == 9 && checker.getC9() != 1) continue;
        if(choosen.getOrd() == 10 && checker.getC10() != 1) continue;
        if(choosen.getOrd() == 11 && checker.getC11() != 1) continue;
        if(choosen.getOrd() == 12 && checker.getC12() != 1) continue;
        if(choosen.getOrd() == 13 && checker.getC13() != 1) continue;
        if(choosen.getOrd() == 14 && checker.getC14() != 1) continue;
        if(choosen.getOrd() == 15 && checker.getC15() != 1) continue;
        if(choosen.getOrd() == 16 && checker.getC16() != 1) continue;
        if(choosen.getOrd() == 17 && checker.getC17() != 1) continue;
        if(choosen.getOrd() == 18 && checker.getC18() != 1) continue;
        if(choosen.getOrd() == 19 && checker.getC19() != 1) continue;
        if(choosen.getOrd() == 20 && checker.getC20() != 1) continue;
        if(choosen.getOrd() == 21 && checker.getC21() != 1) continue;
        if(choosen.getOrd() == 22 && checker.getC22() != 1) continue;
        if(choosen.getOrd() == 23 && checker.getC23() != 1) continue;
        if(choosen.getOrd() == 24 && checker.getC24() != 1) continue;
        double price = choosen.getStatusPrice(obj.getParent().getPatient());
        double real_price = choosen.getStatusRealPrice(obj.getParent().getPatient());
        obj.setId(null);
        obj.setPrice(obj.getParent().getDayCount() < lgotaDays && price == 0 ? real_price : price);
        obj.setReal_price(real_price);
        obj.setNds(obj.getPrice() * obj.getNdsProc() / 100);
        obj.setServiceCount(1D);
        obj.setServiceName(choosen.getName());
        obj.setServiceType(0);
        dhnPatientKdo.save(obj);
      }
    }
    if(obj.getKdo().getId() == 56) { // Каулограмма
      LvCouls checker = dLvCoul.getByPlan(plan);
      if (checker == null) return;
      List<KdoChoosens> choosens = dKdoChoosen.getList("From KdoChoosens Where kdo.id = " + obj.getKdo().getId());
      for(KdoChoosens choosen: choosens) {
        if(choosen.getOrd() == 1 && !checker.isC4()) continue;
        if(choosen.getOrd() == 2 && !checker.isC1()) continue;
        if(choosen.getOrd() == 3 && !checker.isC2()) continue;
        if(choosen.getOrd() == 4 && !checker.isC3()) continue;
        double price = choosen.getStatusPrice(obj.getParent().getPatient());
        double real_price = choosen.getStatusRealPrice(obj.getParent().getPatient());
        obj.setId(null);
        obj.setPrice(obj.getParent().getDayCount() < lgotaDays && price == 0 ? real_price : price);
        obj.setReal_price(real_price);
        obj.setNds(obj.getPrice() * obj.getNdsProc() / 100);
        obj.setServiceCount(1D);
        obj.setServiceName(choosen.getName());
        obj.setServiceType(0);
        dhnPatientKdo.save(obj);
      }
    }
    if(obj.getKdo().getId() == 120) { // Garmon
      LvGarmons checker = dLvGarmon.getByPlan(plan);
      if (checker == null) return;
      List<KdoChoosens> choosens = dKdoChoosen.getList("From KdoChoosens Where kdo.id = " + obj.getKdo().getId());
      for(KdoChoosens choosen: choosens) {
        if(choosen.getOrd() == 1 && !checker.isC1()) continue;
        if(choosen.getOrd() == 2 && !checker.isC2()) continue;
        if(choosen.getOrd() == 3 && !checker.isC3()) continue;
        if(choosen.getOrd() == 4 && !checker.isC4()) continue;
        if(choosen.getOrd() == 5 && !checker.isC5()) continue;
        if(choosen.getOrd() == 6 && !checker.isC6()) continue;
        if(choosen.getOrd() == 7 && !checker.isC7()) continue;
        if(choosen.getOrd() == 8 && !checker.isC8()) continue;
        if(choosen.getOrd() == 9 && !checker.isC9()) continue;
        if(choosen.getOrd() == 10 && !checker.isC10()) continue;
        if(choosen.getOrd() == 11 && !checker.isC11()) continue;
        if(choosen.getOrd() == 12 && !checker.isC12()) continue;
        if(choosen.getOrd() == 13 && !checker.isC13()) continue;
        if(choosen.getOrd() == 14 && !checker.isC14()) continue;
        if(choosen.getOrd() == 15 && !checker.isC15()) continue;
        if(choosen.getOrd() == 16 && !checker.isC16()) continue;
        if(choosen.getOrd() == 17 && !checker.isC17()) continue;
        if(choosen.getOrd() == 18 && !checker.isC18()) continue;
        if(choosen.getOrd() == 19 && !checker.isC19()) continue;
        if(choosen.getOrd() == 20 && !checker.isC20()) continue;
        if(choosen.getOrd() == 21 && !checker.isC21()) continue;
        if(choosen.getOrd() == 22 && !checker.isC22()) continue;
        if(choosen.getOrd() == 23 && !checker.isC23()) continue;
        if(choosen.getOrd() == 24 && !checker.isC24()) continue;
        if(choosen.getOrd() == 25 && !checker.isC25()) continue;
        if(choosen.getOrd() == 26 && !checker.isC26()) continue;
        if(choosen.getOrd() == 27 && !checker.isC27()) continue;
        if(choosen.getOrd() == 28 && !checker.isC28()) continue;
        if(choosen.getOrd() == 29 && !checker.isC29()) continue;
        if(choosen.getOrd() == 30 && !checker.isC30()) continue;
        double price = choosen.getStatusPrice(obj.getParent().getPatient());
        double real_price = choosen.getStatusRealPrice(obj.getParent().getPatient());
        obj.setId(null);
        obj.setPrice(obj.getParent().getDayCount() < lgotaDays && price == 0 ? real_price : price);
        obj.setReal_price(real_price);
        obj.setNds(obj.getPrice() * obj.getNdsProc() / 100);
        obj.setServiceCount(1D);
        obj.setServiceName(choosen.getName());
        obj.setServiceType(0);
        dhnPatientKdo.save(obj);
      }
    }
    if(obj.getKdo().getId() == 121) { // Торч
      LvTorchs checker = dLvTorch.getByPlan(plan);
      if (checker == null) return;
      List<KdoChoosens> choosens = dKdoChoosen.getList("From KdoChoosens Where kdo.id = " + obj.getKdo().getId());
      for(KdoChoosens choosen: choosens) {
        if(choosen.getOrd() == 1 && !checker.isC1()) continue;
        if(choosen.getOrd() == 2 && !checker.isC2()) continue;
        if(choosen.getOrd() == 3 && !checker.isC3()) continue;
        if(choosen.getOrd() == 4 && !checker.isC4()) continue;
        double price = choosen.getStatusPrice(obj.getParent().getPatient());
        double real_price = choosen.getStatusRealPrice(obj.getParent().getPatient());
        obj.setId(null);
        obj.setPrice(obj.getParent().getDayCount() < lgotaDays && price == 0 ? real_price : price);
        obj.setReal_price(real_price);
        obj.setNds(obj.getPrice() * obj.getNdsProc() / 100);
        obj.setServiceCount(1D);
        obj.setServiceName(choosen.getName());
        obj.setServiceType(0);
        dhnPatientKdo.save(obj);
      }
    }
  }

  @RequestMapping("info.s")
  protected String info(HttpServletRequest req, Model m) {
    //
    session = SessionUtil.getUser(req);
    session.setCurUrl("/act/info.s?id=" + Util.get(req, "id"));
    //
    HNPatients hnPatient = dhnPatient.get(Util.getInt(req, "id"));
    Date d = hnPatient.getDateEnd() == null ? new Date() : hnPatient.getDateEnd();
    Double ndsProc = d.after(startDate) ? beanSession.getNds() : 0;
    //
    if(hnPatient.getEatPrice() == null) hnPatient.setEatPrice(0D);
    if(hnPatient.getKoykoPrice() == null) {
      hnPatient.setKoykoPrice(hnPatient.getPatient().getRoomPrice());
      hnPatient.setKoykoPrice(hnPatient.getKoykoPrice() * (100 + ndsProc) / 100);
    }
    if(hnPatient.getNdsProc() == null) hnPatient.setNdsProc(ndsProc);
    if(hnPatient.getDayCount() == 0) {
      if(hnPatient.getDateEnd() != null) {
        long diffInMillies = Math.abs(hnPatient.getDateEnd().getTime() - hnPatient.getPatient().getDateBegin().getTime());
        long diff = TimeUnit.DAYS.convert(diffInMillies, TimeUnit.MILLISECONDS);
        hnPatient.setDayCount((int) (diff) + 1);
      }
    }
    dhnPatient.save(hnPatient);
    List<HNPatientDrugs> drugs = dhnPatientDrug.getList("From HNPatientDrugs Where parent.id = " + Util.getInt(req, "id"));
    //
    for(HNPatientDrugs drug: drugs) {
      if(drug.getDrugName() == null || drug.getPrice() == null || drug.getNds() == null) {
        drug.setNdsProc(ndsProc);
        if(drug.getDrugName() == null) drug.setDrugName(drug.getDrug().getName());
        if(drug.getDrugPrice() == null) drug.setDrugPrice(drug.getPrice());
        if(drug.getNds() == null) drug.setNds(drug.getPrice() * ndsProc / 100);
        dhnPatientDrug.save(drug);
      }
    }
    //
    m.addAttribute("drugs", drugs);
    //
    Connection conn = null;
    try {
      conn = DB.getConnection();
      Double drugSum = DB.getSum(conn, "Select Sum((t.price + t.nds) * t.serviceCount) From HN_Patient_Drugs t Where t.hn_patient = " + Util.getInt(req, "id"));
      m.addAttribute("drugSum", drugSum);
      //
      List<HNPatientKdos> services = dhnPatientKdo.getList("From HNPatientKdos Where parent.id = " + hnPatient.getId());
      double labSum = 0, consulSum = 0, kdoSum = 0, paidSum = 0, watcherSum = 0, epicSum = 0, totalSum, discountSum;
      // Дополнительное место
      List<PatientWatchers> watchers = dPatientWatcher.byPatient(hnPatient.getPatient().getId());
      for(PatientWatchers watcher: watchers) {
        if(watcher.getNds() == null || watcher.getNds() == 0) {
          watcher.setNdsProc(ndsProc);
          watcher.setNds(watcher.getPrice() * ndsProc / 100);
          dPatientWatcher.save(watcher);
        }
        watcherSum += watcher.getDayCount() * (watcher.getPrice() + watcher.getNds());
      }
      // Дополнительное место
      m.addAttribute("watchers", watchers);
      if(services.isEmpty()) {

        updateLabServices(conn, hnPatient); // Лабораторные исследования
        updateMedServices(conn, hnPatient); // Медицинские услуги
        updateCountServices(conn, hnPatient); // Узкие специалисты
      }
      List<HNPatientKdos> labs = new ArrayList<>();
      List<HNPatientKdos> consuls = new ArrayList<>();
      List<HNPatientKdos> kdos = new ArrayList<>();
      services = dhnPatientKdo.getList("From HNPatientKdos Where parent.id = " + hnPatient.getId());
      for(HNPatientKdos service: services) {
        if(service.getNds() == null) {
          service.setNdsProc(ndsProc);
          service.setNds(service.getPrice() * ndsProc / 100);
          dhnPatientKdo.save(service);
        }
        if(service.getServiceType() == 0) {
          labSum += (service.getPrice() + service.getNds()) * service.getServiceCount();
          labs.add(service);
        }
        if(service.getServiceType() == 1) {
          kdoSum += (service.getPrice() + service.getNds()) * service.getServiceCount();
          kdos.add(service);
        }
        if(service.getServiceType() == 2) {
          consulSum += (service.getPrice() + service.getNds()) * service.getServiceCount();
          consuls.add(service);
        }
      }
      //
      List<PatientPays> pays = dPatientPay.byPatient(hnPatient.getPatient().getId());
      for(PatientPays pay: pays) {
        paidSum += pay.getCash() + pay.getCard() + pay.getTransfer() + pay.getOnline();
      }
      discountSum = dCashDiscount.patientStatDiscountSum(hnPatient.getPatient().getId());
      //
      List<LvEpics> epics = dLvEpic.getPatientEpics(hnPatient.getPatient().getId());
      List<ObjList> epicRows = new ArrayList<>();
      Integer days = hnPatient.getDayCount();
      for(LvEpics epic: epics) {
        if(epic.getDateBegin() == null || epic.getKoyko() == null || epic.getPrice() == null) {
          continue;
        }
        ObjList obj = new ObjList();
        obj.setIb(epic.getId().toString());
        obj.setC1(beanSession.getDept(epic.getDeptId()).getName());
        obj.setC2(epic.getRoom().getFloor().getName() + " " + epic.getRoom().getName() + " " + epic.getRoom().getRoomType().getName());
        obj.setC3(Util.dateToString(epic.getDateBegin()));
        obj.setC4(Util.dateToString(epic.getDateEnd()));
        obj.setC5(epic.getPrice().toString());
        obj.setC6(epic.getKoyko() + "");
        if(epic.getNds() == null) {
          epic.setNdsProc(ndsProc);
          epic.setNds(epic.getPrice() * ndsProc / 100);
          dLvEpic.save(epic);
        }
        days -= epic.getKoyko();
        epicSum += (epic.getPrice() + epic.getNds()) * epic.getKoyko();
        epicRows.add(obj);
      }
      if(!epicRows.isEmpty()) {
        ObjList obj = new ObjList();
        obj.setIb("-1");
        obj.setC1(hnPatient.getPatient().getDept().getName());
        obj.setC2(hnPatient.getPatient().getRoom().getFloor().getName() + " " + hnPatient.getPatient().getRoom().getName() + " " + hnPatient.getPatient().getRoom().getRoomType().getName());
        obj.setC3(Util.dateToString(hnPatient.getPatient().getStartEpicDate()));
        obj.setC4(Util.dateToString(hnPatient.getDateEnd()));
        obj.setC5(hnPatient.getKoykoPrice().toString());
        obj.setC6(days + "");
        epicSum += hnPatient.getKoykoPrice() * days;
        epicRows.add(obj);
      }
      m.addAttribute("epics", epicRows);
      m.addAttribute("epicSum", epicSum);
      //
      Double disPerc = hnPatient.getPatient().getDis_perc();
      disPerc = (disPerc == null ? 0 : disPerc) / 100;
      double koyko = epicRows.isEmpty() ? hnPatient.getKoykoPrice() * hnPatient.getDayCount() : epicSum;
      totalSum = watcherSum + drugSum + labSum + kdoSum + consulSum + koyko * (1-disPerc) + (hnPatient.getEatPrice() * hnPatient.getDayCount()) - discountSum;
      hnPatient.setPaySum((double) Math.round((totalSum - paidSum) * 100) / 100);
      hnPatient.setTotalSum((double) Math.round(totalSum * 100) / 100);
      //
      dhnPatient.save(hnPatient);
      m.addAttribute("obj", hnPatient);
      m.addAttribute("labs", labs);
      m.addAttribute("kdos", kdos);
      m.addAttribute("consuls", consuls);
      //
      m.addAttribute("labSum", labSum);
      m.addAttribute("kdoSum", kdoSum);
      m.addAttribute("consulSum", consulSum);
      m.addAttribute("watcherSum", watcherSum);
      m.addAttribute("discountSum", discountSum + (koyko * disPerc));
      m.addAttribute("paidSum", paidSum);
      List<ObjList> plans = sPatient.getPlans(hnPatient.getPatient().getId());
      boolean isErr = false;
      for(ObjList plan: plans) {
        if(plan.getC7().equals("N")) {
          isErr = true;
          break;
        }
      }
      m.addAttribute("not_done", isErr);
      m.addAttribute("plans", plans);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
    }
    return "med/act/addEdit";
  }

  @RequestMapping("excel.s")
  protected String excel(HttpServletRequest req, Model m) {
    //
    session = SessionUtil.getUser(req);
    session.setCurUrl("/act/info.s?id=" + Util.get(req, "id"));
    //
    HNPatients hnPatient = dhnPatient.get(Util.getInt(req, "id"));
    Date d = hnPatient.getDateEnd() == null ? new Date() : hnPatient.getDateEnd();
    Double ndsProc = d.after(startDate) ? beanSession.getNds() : 0;
    m.addAttribute("obj", hnPatient);
    m.addAttribute("lvFio", dUser.get(hnPatient.getPatient().getLv_id()).getFio());
    m.addAttribute("drugs", dhnPatientDrug.getList("From HNPatientDrugs Where parent.id = " + Util.getInt(req, "id")));
    //
    Connection conn = null;
    try {
      conn = DB.getConnection();
      Double drugSum =  DB.getSum(conn, "Select Sum((t.price + t.nds) * t.serviceCount) From HN_Patient_Drugs t Where t.hn_patient = " + Util.getInt(req, "id"));
      m.addAttribute("summ", drugSum);
      //
      List<HNPatientKdos> services = dhnPatientKdo.getList("From HNPatientKdos Where parent.id = " + hnPatient.getId());
      List<HNPatientKdos> labs = new ArrayList<>();
      List<HNPatientKdos> consuls = new ArrayList<>();
      List<HNPatientKdos> kdos = new ArrayList<>();
      double labSum = 0D, consulSum = 0D, kdoSum = 0D, discountSum = 0;
      for(HNPatientKdos service: services) {
        if(service.getServiceType() == 0) {
          labSum += (service.getPrice() + service.getNds()) * service.getServiceCount();
          labs.add(service);
          if(service.getPrice() == 0)
            discountSum += service.getReal_price() * service.getServiceCount();
        }
        if(service.getServiceType() == 1) {
          kdoSum += (service.getPrice() + service.getNds()) * service.getServiceCount();
          kdos.add(service);
          if(service.getPrice() == 0)
            discountSum += service.getReal_price() * service.getServiceCount();
        }
        if(service.getServiceType() == 2) {
          consulSum += (service.getPrice() + service.getNds()) * service.getServiceCount();
          consuls.add(service);
          if(service.getPrice() == 0)
            discountSum += service.getReal_price() * service.getServiceCount();
        }
      }
      // Дополнительное место
      List<PatientWatchers> watchers = dPatientWatcher.byPatient(hnPatient.getPatient().getId());
      m.addAttribute("watchers", watchers);
      //
      m.addAttribute("labs", labs);
      m.addAttribute("kdos", kdos);
      m.addAttribute("consuls", consuls);
      //
      m.addAttribute("labSum", labSum);
      m.addAttribute("kdoSum", kdoSum);
      m.addAttribute("consulSum", consulSum);
      //
      double cash = 0D, card = 0D, transfer = 0D, online = 0D;
      List<PatientPays> pays = dPatientPay.byPatient(hnPatient.getPatient().getId());
      for(PatientPays pay: pays) {
        cash += pay.getCash();
        card += pay.getCard();
        transfer += pay.getTransfer();
        online += pay.getOnline();
      }
      m.addAttribute("cashSum", cash);
      m.addAttribute("cardSum", card);
      m.addAttribute("transferSum", transfer);
      m.addAttribute("onlineSum", online);
      // Переводной эпикриз
      List<LvEpics> epics = dLvEpic.getPatientEpics(hnPatient.getPatient().getId());
      List<ObjList> epicRows = new ArrayList<>();
      Integer days = hnPatient.getDayCount();
      Double epicSum = 0D;
      for(LvEpics epic: epics) {
        if(epic.getDateBegin() == null || epic.getKoyko() == null || epic.getPrice() == null) {
          continue;
        }
        ObjList obj = new ObjList();
        obj.setIb(epic.getId().toString());
        obj.setC1(beanSession.getDept(epic.getDeptId()).getName());
        obj.setC2(epic.getRoom().getFloor().getName() + " " + epic.getRoom().getName() + " " + epic.getRoom().getRoomType().getName());
        obj.setC3(Util.dateToString(epic.getDateBegin()));
        obj.setC4(Util.dateToString(epic.getDateEnd()));
        obj.setC5(epic.getPrice().toString());
        obj.setC6(epic.getKoyko() + "");
        obj.setC7(epic.getNds() + "");
        days -= epic.getKoyko();
        epicSum += epic.getKoyko() * (epic.getPrice() + epic.getNds());
        epicRows.add(obj);
      }
      if(!epicRows.isEmpty()) {
        ObjList obj = new ObjList();
        obj.setIb("-1");
        obj.setC1(hnPatient.getPatient().getDept().getName());
        obj.setC2(hnPatient.getPatient().getRoom().getFloor().getName() + " " + hnPatient.getPatient().getRoom().getName() + " " + hnPatient.getPatient().getRoom().getRoomType().getName());
        obj.setC3(Util.dateToString(hnPatient.getPatient().getStartEpicDate()));
        obj.setC4(Util.dateToString(hnPatient.getDateEnd()));
        obj.setC5(hnPatient.getKoykoPrice().toString());
        obj.setC6(days + "");
        obj.setC7("0");
        epicRows.add(obj);
      }
      m.addAttribute("epics", epicRows);
      Double disPerc = hnPatient.getPatient().getDis_perc();
      disPerc = disPerc == null ? 0 : disPerc;
      double koyko = epicRows.isEmpty() ? hnPatient.getKoykoPrice() * hnPatient.getDayCount() : epicSum;
      //
      m.addAttribute("ndsProc", ndsProc);
      m.addAttribute("dis_sum", koyko);
      m.addAttribute("dis_perc", disPerc);
      m.addAttribute("discount_sum", discountSum);
      String sum_in_word = Util.inwords(hnPatient.getTotalSum());
      m.addAttribute("sum_in_word", sum_in_word.substring(0, 1).toUpperCase() + sum_in_word.substring(1));
      m.addAttribute("clinic_name", beanSession.getParam("CLINIC_NAME"));
      m.addAttribute("boss", beanUsers.getBoss());
      m.addAttribute("glv", beanUsers.getGlb());
      m.addAttribute("glavbuh", beanUsers.getGlavbuh());
      m.addAttribute("head_nurse", hnPatient.getPatient().getDept().getNurse().getFio());

      //
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn);
    }
    return "med/act/excel";
  }

  @RequestMapping(value = "confirm.s", method = RequestMethod.POST)
  @ResponseBody
  protected String confirmPatient(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      HNPatients pat = dhnPatient.get(Util.getInt(req, "id"));
      pat.setState("D");
      pat.setClosed("Y");
      dhnPatient.save(pat);
      Patients p = pat.getPatient();
      if(!p.getState().equals("LV") && pat.getPaySum() == 0) {
        p.setPaid("CLOSED");
        dPatient.save(p);
      }
      //
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "patient/open.s", method = RequestMethod.POST)
  @ResponseBody
  protected String openPatient(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      HNPatients pat = dhnPatient.get(Util.getInt(req, "id"));
      pat.setClosed("N");
      dhnPatient.save(pat);
      //
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "patient/cash.s", method = RequestMethod.POST)
  @ResponseBody
  protected String openCash(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      HNPatients pat = dhnPatient.get(Util.getInt(req, "id"));
      Patients p = pat.getPatient();
      p.setPaid(null);
      dPatient.save(p);
      pat.setClosed("N");
      dhnPatient.save(pat);
      //
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "patient/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String savePatient(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      HNPatients obj = dhnPatient.get(Util.getInt(req, "id"));
      obj.setDayCount(Util.getInt(req, "days"));
      obj.setDateEnd(Util.getDate(req, "date_end"));
      obj.setActNum(Util.get(req, "act"));
      obj.setKoykoPrice(Double.parseDouble(Util.get(req, "koyko")));
      obj.setEatPrice(Double.parseDouble(Util.get(req, "eat")));
      dhnPatient.save(obj);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "patient/row/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String savePatientRow(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      if(session.getUserId() == 1) {
        if (Util.get(req, "cat").equals("drug")) {
          HNPatientDrugs obj = dhnPatientDrug.get(Util.getInt(req, "id"));
          if (Util.get(req, "type").equals("price")) {
            obj.setPrice(Double.parseDouble(Util.get(req, "value")));
            obj.setNds(obj.getPrice() * obj.getNdsProc() / 100);
          }
          if (Util.get(req, "type").equals("counter")) {
            obj.setServiceCount(Double.parseDouble(Util.get(req, "value")));
          }
          dhnPatientDrug.save(obj);
        }
        if (Util.get(req, "cat").equals("epic")) {
          int id = Util.getInt(req, "id");
          if(id > 0) {
            LvEpics epic = dLvEpic.get(id);
            if (Util.get(req, "type").equals("price")) {
              epic.setPrice(Double.parseDouble(Util.get(req, "value")));
              epic.setNds(epic.getPrice() * epic.getNdsProc() / 100);
            }
            if (Util.get(req, "type").equals("koyko")) {
              epic.setKoyko(Integer.parseInt(Util.get(req, "value")));
            }
            dLvEpic.save(epic);
          }
        }
        if (Util.get(req, "cat").equals("watcher")) {
          int id = Util.getInt(req, "id");
          if(id > 0) {
            PatientWatchers obj = dPatientWatcher.get(id);
            if (Util.get(req, "type").equals("price")) {
              obj.setPrice(Double.parseDouble(Util.get(req, "value")));
              obj.setNds(obj.getPrice() * obj.getNdsProc() / 100);
            }
            if (Util.get(req, "type").equals("counter")) {
              obj.setDayCount(Integer.parseInt(Util.get(req, "value")));
            }
            dPatientWatcher.save(obj);
          }
        }
      }
      if (Util.get(req, "cat").equals("service")) {
        HNPatientKdos obj = dhnPatientKdo.get(Util.getInt(req, "id"));
        if (Util.get(req, "type").equals("price")) {
          obj.setPrice(Double.parseDouble(Util.get(req, "value")));
          obj.setNds(obj.getPrice() * obj.getNdsProc() / 100);
        }
        if (Util.get(req, "type").equals("counter")) {
          obj.setServiceCount(Double.parseDouble(Util.get(req, "value")));
        }
        dhnPatientKdo.save(obj);
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "patient/service/del.s", method = RequestMethod.POST)
  @ResponseBody
  protected String delPatientRow(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      if(session.getUserId() == 1)
        dhnPatientKdo.delete(Util.getInt(req, "id"));
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "patient/service/restore.s", method = RequestMethod.POST)
  @ResponseBody
  protected String restorePatientRow(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    //
    Connection conn = null;
    try {
      conn = DB.getConnection();
      HNPatients pat = dhnPatient.get(Util.getInt(req, "id"));
      dhnPatientKdo.delSql("From HNPatientKdos Where parent.id = " + pat.getId() + " And serviceType = " + Util.get(req, "type"));
      // Лабораторные исследования
      if(Util.get(req, "type").equals("0")) updateLabServices(conn, pat);
      // Медицинские услуги
      if(Util.get(req, "type").equals("1")) updateMedServices(conn, pat);
      // Консультация
      if(Util.get(req, "type").equals("2")) updateCountServices(conn, pat);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    } finally {
      DB.done(conn);
    }
    return json.toString();
  }

  protected void updateLabServices(Connection conn, HNPatients pat) {
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      Date d = pat.getDateEnd() == null ? new Date() : pat.getDateEnd();
      Double ndsProc = d.after(startDate) ? beanSession.getNds() : 0;
      ps = conn.prepareStatement(
        "Select t.id, t.Kdo_Id, c.`Name` Kdo_Name, 1 Kdo_Count, t.conf_user " +
          "  From lv_plans t, Kdos c " +
          " Where t.patientId = ? " +
          "    And t.Kdo_Id = c.Id " +
          "    And t.result_id > 0 " +
          "    And t.Kdo_Type_Id in (1, 2, 3, 19, 20) "
      );
      ps.setInt(1, pat.getPatient().getId());
      rs = ps.executeQuery();
      while (rs.next()) {
        HNPatientKdos obj = new HNPatientKdos();
        obj.setParent(pat);
        obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
        obj.setWorker(rs.getInt("conf_user"));
        obj.setServiceType(0);
        obj.setNdsProc(ndsProc);
        if(dKdoChoosen.getCount("From KdoChoosens Where kdo.id = " + obj.getKdo().getId()) > 0) {
          importChoosenKdos(obj, rs.getInt("id"));
        } else {
          Kdos kdo = dKdo.get(obj.getKdo().getId());
          double price = kdo.getStatusPrice(pat.getPatient());
          double real_price = kdo.getStatusRealPrice(pat.getPatient());
          obj.setPrice(pat.getDayCount() < lgotaDays && price == 0 ? real_price : price);
          obj.setReal_price(real_price);
          obj.setNds(obj.getPrice() * ndsProc / 100);
          obj.setServiceCount(rs.getDouble("kdo_count"));
          obj.setServiceName(rs.getString("Kdo_Name"));
          obj.setServiceType(0);
          dhnPatientKdo.save(obj);
        }
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
  }

  protected void updateMedServices(Connection conn, HNPatients pat) {
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      Date d = pat.getDateEnd() == null ? new Date() : pat.getDateEnd();
      Double ndsProc = d.after(startDate) ? beanSession.getNds() : 0;
      ps = conn.prepareStatement(
        "Select t.Kdo_Id, Max(c.`Name`) Kdo_Name, Count(*) Kdo_Count, t.conf_user, sum(t.counter) needlecount " +
          "  From lv_plans t, Kdos c " +
          " Where t.patientId = ? " +
          "    And t.Kdo_Id = c.Id " +
          "    And t.result_id > 0 " +
          "    And t.Kdo_Type_Id not in (1, 2, 3, 8, 19, 20) " +
          "  Group By t.Kdo_Id, t.conf_user "
      );
      ps.setInt(1, pat.getPatient().getId());
      rs = ps.executeQuery();
      while (rs.next()) {
        HNPatientKdos obj = new HNPatientKdos();
        obj.setParent(pat);
        obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
        obj.setPrice(obj.getKdo().getStatusPrice(pat.getPatient()));
        obj.setReal_price(obj.getKdo().getStatusRealPrice(pat.getPatient()));
        obj.setNdsProc(ndsProc);
        obj.setNds(obj.getPrice() * ndsProc / 100);
        if(rs.getInt("kdo_id") == 288)
          obj.setServiceCount(rs.getDouble("needlecount"));
        else
          obj.setServiceCount(rs.getDouble("kdo_count"));
        obj.setServiceName(rs.getString("Kdo_Name"));
        obj.setServiceType(1);
        obj.setWorker(rs.getInt("conf_user"));
        dhnPatientKdo.save(obj);
      }
      // Физиотерапия
      ps = conn.prepareStatement(
        "Select t.Kdo_Id, " +
          "         c.`Name` Kdo_Name, " +
          "         (Select Count(*) From Lv_Fizio_Dates d Where d.fizio_Id = t.Id And d.state = 'Y' And d.done = 'Y') Kdo_Count, " +
          "         t.userId " +
          "    From lv_fizios t, Kdos c " +
          "   Where t.patientId = ? " +
          "     And t.Kdo_Id = c.Id " +
          "     And c.kdo_Type = 8 "
      );
      ps.setInt(1, pat.getPatient().getId());
      rs = ps.executeQuery();
      while (rs.next()) {
        HNPatientKdos obj = new HNPatientKdos();
        obj.setParent(pat);
        obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
        obj.setPrice(obj.getKdo().getStatusPrice(pat.getPatient()));
        obj.setReal_price(obj.getKdo().getStatusRealPrice(pat.getPatient()));
        obj.setNdsProc(ndsProc);
        obj.setNds(obj.getPrice() * ndsProc / 100);
        obj.setServiceCount(rs.getDouble("kdo_count"));
        obj.setServiceName(rs.getString("Kdo_Name"));
        obj.setServiceType(1);
        obj.setWorker(rs.getInt("userId"));
        dhnPatientKdo.save(obj);
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
  }

  protected void updateCountServices(Connection conn, HNPatients pat) {
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      Date d = pat.getDateEnd() == null ? new Date() : pat.getDateEnd();
      Double ndsProc = d.after(startDate) ? beanSession.getNds() : 0;
      ps = conn.prepareStatement(
        "Select c.profil, Count(*) counter, ifnull(c.consul_price, 0) price, ifnull(c.for_consul_price, 0) for_price, ifnull(c.real_consul_price, 0) real_price, ifnull(c.for_real_consul_price, 0) for_real_price, t.lvid" +
          "  From lv_consuls t, Users c " +
          " Where t.patientId = ? " +
          "    And c.Id = t.lvId " +
          "  Group By c.profil "
      );
      ps.setInt(1, pat.getPatient().getId());
      rs = ps.executeQuery();
      while (rs.next()) {
        HNPatientKdos obj = new HNPatientKdos();
        obj.setParent(pat);
        obj.setPrice(0D);
        if(pat.getPatient().getCounteryId() == 199) {
          obj.setPrice(rs.getDouble("price"));
          obj.setReal_price(rs.getDouble("real_price"));
        } else {
          obj.setPrice(rs.getDouble("for_price"));
          obj.setReal_price(rs.getDouble("for_real_price"));
        }
        obj.setNdsProc(ndsProc);
        obj.setNds(obj.getPrice() * ndsProc / 100);
        obj.setServiceCount(rs.getDouble("counter"));
        obj.setServiceName(rs.getString("profil"));
        obj.setServiceType(2);
        obj.setWorker(rs.getInt("lvid"));
        dhnPatientKdo.save(obj);
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
  }

  @RequestMapping(value = "service/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String saveService(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      HNPatients pat = dhnPatient.get(Util.getInt(req, "id"));
      Date d = pat.getDateEnd() == null ? new Date() : pat.getDateEnd();
      Double ndsProc = d.after(startDate) ? beanSession.getNds() : 0;
      HNPatientKdos kdo = new HNPatientKdos();
      if(Util.get(req, "type").equals("lab")) kdo.setServiceType(0);
      if(Util.get(req, "type").equals("kdo")) kdo.setServiceType(1);
      if(Util.get(req, "type").equals("consul")) kdo.setServiceType(2);
      kdo.setPrice(Double.parseDouble(Util.get(req, "price")));
      kdo.setNdsProc(ndsProc);
      kdo.setNds(kdo.getPrice() * ndsProc / 100);
      kdo.setServiceCount(Double.parseDouble(Util.get(req, "counter")));
      kdo.setServiceName(Util.get(req, "name"));
      kdo.setParent(pat);
      dhnPatientKdo.save(kdo);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "drug/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String saveDrug(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      HNPatients pat = dhnPatient.get(Util.getInt(req, "id"));
      HNPatientDrugs drug = new HNPatientDrugs();
      drug.setParent(pat);
      //
      drug.setPrice(Double.parseDouble(Util.get(req, "price")));
      drug.setServiceCount(Double.parseDouble(Util.get(req, "drug_count")));
      drug.setDrugName(Util.get(req, "name"));
      drug.setDrugPrice(drug.getPrice());
      //
      dhnPatientDrug.save(drug);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "stat/del/obs.s", method = RequestMethod.POST)
  @ResponseBody
  protected String statObs(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      Integer id = Util.getInt(req, "id");
      dLvBio.deletePlan(id);
      dLvCoul.deletePlan(id);
      dLvTorch.deletePlan(id);
      dLvGarmon.deletePlan(id);
      try {
        dPatientPlan.delPlan(id);
        dLvPlan.delete(id);
      } catch(Exception e) {
        json.put("success", false);
        json.put("msg", "Нельзя удалить обследования. Существует связь с другими таблицами");
        return json.toString();
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }
}
