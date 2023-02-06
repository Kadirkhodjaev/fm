package ckb.controllers.med;

import ckb.dao.admin.depts.DDept;
import ckb.dao.admin.params.DParam;
import ckb.dao.admin.users.DUser;
import ckb.dao.med.drug.dict.drugs.DDrug;
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
import ckb.domains.med.head_nurse.HNPatientDrugs;
import ckb.domains.med.head_nurse.HNPatientKdos;
import ckb.domains.med.head_nurse.HNPatients;
import ckb.domains.med.lv.*;
import ckb.domains.med.patient.PatientPays;
import ckb.domains.med.patient.PatientWatchers;
import ckb.models.ObjList;
import ckb.services.med.patient.SPatient;
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
  @Autowired private DDrug dDrug;
  @Autowired private DKdos dKdo;
  @Autowired private SPatient sPatient;
  @Autowired private DPatient dPatient;
  @Autowired private DUser dUser;
  @Autowired private DPatientWatchers dPatientWatcher;
  @Autowired private DParam dParam;
  @Autowired private DLvBio dLvBio;
  @Autowired private DKdoChoosen dKdoChoosen;
  @Autowired private DLvCoul dLvCoul;
  @Autowired private DLvGarmon dLvGarmon;
  @Autowired private DLvTorch dLvTorch;
  @Autowired private DLvPlan dLvPlan;
  @Autowired private DPatientPlan dPatientPlan;
  @Autowired private DLvEpic dLvEpic;
  @Autowired private DDept dDept;

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
    String startDate = Util.get(req, "period_start", Util.dateToString(start.getTime()));
    String endDate = Util.get(req, "period_end", Util.dateToString(end.getTime()));
    String filter = Util.toUTF8(Util.get(req, "word"));
    //
    String where = "";
    if(filter != null) {
      where = " (Upper(patient.surname) like '%" + filter.toUpperCase() + "%' Or Upper(patient.name) like '%" + filter.toUpperCase() + "%' Or Upper(patient.middlename) like '%" + filter.toUpperCase() + "%' Or patient.yearNum like '%" + filter.toUpperCase() + "%') And ";
    }
    m.addAttribute("rows", dhnPatient.getList("From HNPatients t Where " + where + " t.state != 'E' And (t.dateEnd = null Or t.dateEnd Between '" + Util.dateDBBegin(startDate) + "' And '" + Util.dateDBBegin(endDate) + "') Order By t.id Desc"));
    m.addAttribute("filter", filter);
    m.addAttribute("period_start", startDate);
    m.addAttribute("period_end", endDate);
    return "med/act/index";
  }

  @RequestMapping("info.s")
  protected String info(HttpServletRequest req, Model m) {
    //
    session = SessionUtil.getUser(req);
    session.setCurUrl("/act/info.s?id=" + Util.get(req, "id"));
    //
    HNPatients hnPatient = dhnPatient.get(Util.getInt(req, "id"));
    //
    if(hnPatient.getEatPrice() == null) hnPatient.setEatPrice(0D);
    if(hnPatient.getKoykoPrice() == null) hnPatient.setKoykoPrice(sPatient.getPatientKoykoPrice(hnPatient.getPatient()));
    if(hnPatient.getDayCount() == 0) {
      if(hnPatient.getDateEnd() != null) {
        long diffInMillies = Math.abs(hnPatient.getDateEnd().getTime() - hnPatient.getPatient().getDateBegin().getTime());
        long diff = TimeUnit.DAYS.convert(diffInMillies, TimeUnit.MILLISECONDS);
        hnPatient.setDayCount((int) (diff));
      }
    }
    dhnPatient.save(hnPatient);
    m.addAttribute("obj", hnPatient);
    List<HNPatientDrugs> drugs = dhnPatientDrug.getList("From HNPatientDrugs Where parent.id = " + Util.getInt(req, "id"));
    //
    for(HNPatientDrugs drug: drugs) {
      if(drug.getDrugName() == null || drug.getPrice() == null) {
        if(drug.getDrugName() == null) drug.setDrugName(drug.getDrug().getName());
        if(drug.getDrugPrice() == null) drug.setDrugPrice(drug.getPrice());
        dhnPatientDrug.save(drug);
      }
    }
    //
    m.addAttribute("drugs", drugs);
    //
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      conn = DB.getConnection();
      Double drugSum = DB.getSum(conn, "Select Sum(t.price * t.serviceCount) From HN_Patient_Drugs t Where t.hn_patient = " + Util.getInt(req, "id"));
      m.addAttribute("drugSum", drugSum);
      //
      List<HNPatientKdos> services = dhnPatientKdo.getList("From HNPatientKdos Where parent.id = " + hnPatient.getId());
      List<HNPatientKdos> labs = new ArrayList<HNPatientKdos>();
      List<HNPatientKdos> consuls = new ArrayList<HNPatientKdos>();
      List<HNPatientKdos> kdos = new ArrayList<HNPatientKdos>();
      double labSum = 0, consulSum = 0, kdoSum = 0, paidSum = 0, watcherSum = 0, epicSum = 0, totalSum = 0;
      // Дополнительное место
      List<PatientWatchers> watchers = dPatientWatcher.byPatient(hnPatient.getPatient().getId());
      for(PatientWatchers watcher: watchers)
        watcherSum += watcher.getDayCount() * watcher.getPrice();
      // Дополнительное место
      m.addAttribute("watchers", watchers);
      if(services.size() == 0) {
        // Лабораторные исследования
        ps = conn.prepareStatement(
          "Select t.id, t.Kdo_Id, c.`Name` Kdo_Name, 1 kdo_count, ifnull(c.Price, 0) Price, ifnull(c.real_price, 0) real_price, ifnull(c.for_real_price, 0) for_real_price " +
            "  From lv_plans t, Kdos c " +
            " Where t.patientId = ? " +
            "    And t.Kdo_Id = c.Id " +
            "    And t.result_id > 0 " +
            "    And t.Kdo_Type_Id in (1, 2, 3, 19, 20) "
        );
        ps.setInt(1, hnPatient.getPatient().getId());
        rs = ps.executeQuery();
        while (rs.next()) {
          if(rs.getInt("kdo_id") == 121 || rs.getInt("kdo_id") == 120 || rs.getInt("kdo_id") == 56 || rs.getInt("kdo_id") == 153) {
            if (rs.getInt("kdo_id") == 153) {
              LvBios bio = dLvBio.getByPlan(rs.getInt("id"));
              if (bio != null) {
                if (bio.getC1() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(hnPatient);
                  obj.setPrice(dKdoChoosen.getPrice(hnPatient.getPatient().getCounteryId(), 153, 1));
                  obj.setReal_price(dKdoChoosen.getRealPrice(hnPatient.getPatient().getCounteryId(), 153, 1));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Умумий оксил");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                  labSum += obj.getPrice() * obj.getServiceCount();
                  labs.add(obj);
                }
                if (bio.getC2() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(hnPatient);
                  obj.setPrice(dKdoChoosen.getPrice(hnPatient.getPatient().getCounteryId(), 153, 2));
                  obj.setReal_price(dKdoChoosen.getRealPrice(hnPatient.getPatient().getCounteryId(), 153, 2));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Холестерин");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                  labSum += obj.getPrice() * obj.getServiceCount();
                  labs.add(obj);
                }
                if (bio.getC3() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(hnPatient);
                  obj.setPrice(dKdoChoosen.getPrice(hnPatient.getPatient().getCounteryId(), 153, 3));
                  obj.setReal_price(dKdoChoosen.getRealPrice(hnPatient.getPatient().getCounteryId(), 153, 3));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Глюкоза");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                  labSum += obj.getPrice() * obj.getServiceCount();
                  labs.add(obj);
                }
                if (bio.getC4() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(hnPatient);
                  obj.setPrice(dKdoChoosen.getPrice(hnPatient.getPatient().getCounteryId(), 153, 4));
                  obj.setReal_price(dKdoChoosen.getRealPrice(hnPatient.getPatient().getCounteryId(), 153, 4));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Мочевина");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                  labSum += obj.getPrice() * obj.getServiceCount();
                  labs.add(obj);
                }
                if (bio.getC5() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(hnPatient);
                  obj.setPrice(dKdoChoosen.getPrice(hnPatient.getPatient().getCounteryId(), 153, 5));
                  obj.setReal_price(dKdoChoosen.getRealPrice(hnPatient.getPatient().getCounteryId(), 153, 5));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Креатинин");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                  labSum += obj.getPrice() * obj.getServiceCount();
                  labs.add(obj);
                }
                if (bio.getC6() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(hnPatient);
                  obj.setPrice(dKdoChoosen.getPrice(hnPatient.getPatient().getCounteryId(), 153, 6));
                  obj.setReal_price(dKdoChoosen.getRealPrice(hnPatient.getPatient().getCounteryId(), 153, 6));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Билирубин");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                  labSum += obj.getPrice() * obj.getServiceCount();
                  labs.add(obj);
                }
                if (bio.getC7() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(hnPatient);
                  obj.setPrice(dKdoChoosen.getPrice(hnPatient.getPatient().getCounteryId(), 153, 7));
                  obj.setReal_price(dKdoChoosen.getRealPrice(hnPatient.getPatient().getCounteryId(), 153, 7));
                  obj.setServiceCount(1D);
                  obj.setServiceName("АЛТ");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                  labSum += obj.getPrice() * obj.getServiceCount();
                  labs.add(obj);
                }
                if (bio.getC8() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(hnPatient);
                  obj.setPrice(dKdoChoosen.getPrice(hnPatient.getPatient().getCounteryId(), 153, 8));
                  obj.setReal_price(dKdoChoosen.getRealPrice(hnPatient.getPatient().getCounteryId(), 153, 8));
                  obj.setServiceCount(1D);
                  obj.setServiceName("АСТ");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                  labSum += obj.getPrice() * obj.getServiceCount();
                  labs.add(obj);
                }
                if (bio.getC9() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(hnPatient);
                  obj.setPrice(dKdoChoosen.getPrice(hnPatient.getPatient().getCounteryId(), 153, 9));
                  obj.setReal_price(dKdoChoosen.getRealPrice(hnPatient.getPatient().getCounteryId(), 153, 9));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Альфа амилаза");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                  labSum += obj.getPrice() * obj.getServiceCount();
                  labs.add(obj);
                }
                if (bio.getC10() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(hnPatient);
                  obj.setPrice(dKdoChoosen.getPrice(hnPatient.getPatient().getCounteryId(), 153, 10));
                  obj.setReal_price(dKdoChoosen.getRealPrice(hnPatient.getPatient().getCounteryId(), 153, 10));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Кальций");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                  labSum += obj.getPrice() * obj.getServiceCount();
                  labs.add(obj);
                }
                if (bio.getC11() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(hnPatient);
                  obj.setPrice(dKdoChoosen.getPrice(hnPatient.getPatient().getCounteryId(), 153, 11));
                  obj.setReal_price(dKdoChoosen.getRealPrice(hnPatient.getPatient().getCounteryId(), 153, 11));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Сийдик кислотаси");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                  labSum += obj.getPrice() * obj.getServiceCount();
                  labs.add(obj);
                }
                if (bio.getC12() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(hnPatient);
                  obj.setPrice(dKdoChoosen.getPrice(hnPatient.getPatient().getCounteryId(), 153, 12));
                  obj.setReal_price(dKdoChoosen.getRealPrice(hnPatient.getPatient().getCounteryId(), 153, 12));
                  obj.setServiceCount(1D);
                  obj.setServiceName("K – калий");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                  labSum += obj.getPrice() * obj.getServiceCount();
                  labs.add(obj);
                }
                if (bio.getC13() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(hnPatient);
                  obj.setPrice(dKdoChoosen.getPrice(hnPatient.getPatient().getCounteryId(), 153, 13));
                  obj.setReal_price(dKdoChoosen.getRealPrice(hnPatient.getPatient().getCounteryId(), 153, 13));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Na – натрий");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                  labSum += obj.getPrice() * obj.getServiceCount();
                  labs.add(obj);
                }
                if (bio.getC14() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(hnPatient);
                  obj.setPrice(dKdoChoosen.getPrice(hnPatient.getPatient().getCounteryId(), 153, 14));
                  obj.setReal_price(dKdoChoosen.getRealPrice(hnPatient.getPatient().getCounteryId(), 153, 14));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Fe – темир");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                  labSum += obj.getPrice() * obj.getServiceCount();
                  labs.add(obj);
                }
                if (bio.getC15() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(hnPatient);
                  obj.setPrice(dKdoChoosen.getPrice(hnPatient.getPatient().getCounteryId(), 153, 15));
                  obj.setReal_price(dKdoChoosen.getRealPrice(hnPatient.getPatient().getCounteryId(), 153, 15));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Mg – магний");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                  labSum += obj.getPrice() * obj.getServiceCount();
                  labs.add(obj);
                }
                if (bio.getC16() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(hnPatient);
                  obj.setPrice(dKdoChoosen.getPrice(hnPatient.getPatient().getCounteryId(), 153, 16));
                  obj.setReal_price(dKdoChoosen.getRealPrice(hnPatient.getPatient().getCounteryId(), 153, 16));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Ишкорий фасфотаза");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                  labSum += obj.getPrice() * obj.getServiceCount();
                  labs.add(obj);
                }
                if (bio.getC17() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(hnPatient);
                  obj.setPrice(dKdoChoosen.getPrice(hnPatient.getPatient().getCounteryId(), 153, 17));
                  obj.setReal_price(dKdoChoosen.getRealPrice(hnPatient.getPatient().getCounteryId(), 153, 17));
                  obj.setServiceCount(1D);
                  obj.setServiceName("ГГТ");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                  labSum += obj.getPrice() * obj.getServiceCount();
                  labs.add(obj);
                }
                if (bio.getC18() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(hnPatient);
                  obj.setPrice(dKdoChoosen.getPrice(hnPatient.getPatient().getCounteryId(), 153, 18));
                  obj.setReal_price(dKdoChoosen.getRealPrice(hnPatient.getPatient().getCounteryId(), 153, 18));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Гликирланган гемоглобин");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                  labSum += obj.getPrice() * obj.getServiceCount();
                  labs.add(obj);
                }
                if (bio.getC19() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(hnPatient);
                  obj.setPrice(dKdoChoosen.getPrice(hnPatient.getPatient().getCounteryId(), 153, 19));
                  obj.setReal_price(dKdoChoosen.getRealPrice(hnPatient.getPatient().getCounteryId(), 153, 19));
                  obj.setServiceCount(1D);
                  obj.setServiceName("РФ");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                  labSum += obj.getPrice() * obj.getServiceCount();
                  labs.add(obj);
                }
                if (bio.getC20() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(hnPatient);
                  obj.setPrice(dKdoChoosen.getPrice(hnPatient.getPatient().getCounteryId(), 153, 20));
                  obj.setReal_price(dKdoChoosen.getRealPrice(hnPatient.getPatient().getCounteryId(), 153, 20));
                  obj.setServiceCount(1D);
                  obj.setServiceName("АСЛО");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                  labSum += obj.getPrice() * obj.getServiceCount();
                  labs.add(obj);
                }
                if (bio.getC21() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(hnPatient);
                  obj.setPrice(dKdoChoosen.getPrice(hnPatient.getPatient().getCounteryId(), 153, 21));
                  obj.setReal_price(dKdoChoosen.getRealPrice(hnPatient.getPatient().getCounteryId(), 153, 21));
                  obj.setServiceCount(1D);
                  obj.setServiceName("СРБ");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                  labSum += obj.getPrice() * obj.getServiceCount();
                  labs.add(obj);
                }
                if (bio.getC22() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(hnPatient);
                  obj.setPrice(dKdoChoosen.getPrice(hnPatient.getPatient().getCounteryId(), 153, 22));
                  obj.setReal_price(dKdoChoosen.getRealPrice(hnPatient.getPatient().getCounteryId(), 153, 22));
                  obj.setServiceCount(1D);
                  obj.setServiceName("RW");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                  labSum += obj.getPrice() * obj.getServiceCount();
                  labs.add(obj);
                }
                if (bio.getC23() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(hnPatient);
                  obj.setPrice(dKdoChoosen.getPrice(hnPatient.getPatient().getCounteryId(), 153, 23));
                  obj.setReal_price(dKdoChoosen.getRealPrice(hnPatient.getPatient().getCounteryId(), 153, 23));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Hbs Ag");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                  labSum += obj.getPrice() * obj.getServiceCount();
                  labs.add(obj);
                }
                if (bio.getC24() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(hnPatient);
                  obj.setPrice(dKdoChoosen.getPrice(hnPatient.getPatient().getCounteryId(), 153, 24));
                  obj.setReal_price(dKdoChoosen.getRealPrice(hnPatient.getPatient().getCounteryId(), 153, 24));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Гепатит «С» ВГС");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                  labSum += obj.getPrice() * obj.getServiceCount();
                  labs.add(obj);
                }
              }
            }
            if (rs.getInt("kdo_id") == 56) { // Каулограмма
              LvCouls bio = dLvCoul.getByPlan(rs.getInt("id"));
              if (bio != null) {
                if (bio.isC4()) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(hnPatient);
                  obj.setPrice(dKdoChoosen.getPrice(hnPatient.getPatient().getCounteryId(), 56, 4));
                  obj.setReal_price(dKdoChoosen.getRealPrice(hnPatient.getPatient().getCounteryId(), 56, 4));
                  obj.setServiceCount(1D);
                  obj.setServiceName("ПТИ");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                  labSum += obj.getPrice() * obj.getServiceCount();
                  labs.add(obj);
                }
                if (bio.isC1()) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(hnPatient);
                  obj.setPrice(dKdoChoosen.getPrice(hnPatient.getPatient().getCounteryId(), 56, 1));
                  obj.setReal_price(dKdoChoosen.getRealPrice(hnPatient.getPatient().getCounteryId(), 56, 1));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Фибриноген");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                  labSum += obj.getPrice() * obj.getServiceCount();
                  labs.add(obj);
                }
                if (bio.isC2()) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(hnPatient);
                  obj.setPrice(dKdoChoosen.getPrice(hnPatient.getPatient().getCounteryId(), 56, 2));
                  obj.setReal_price(dKdoChoosen.getRealPrice(hnPatient.getPatient().getCounteryId(), 56, 2));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Тромбин вакти");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                  labSum += obj.getPrice() * obj.getServiceCount();
                  labs.add(obj);
                }
                if (bio.isC3()) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(hnPatient);
                  obj.setPrice(dKdoChoosen.getPrice(hnPatient.getPatient().getCounteryId(), 56, 3));
                  obj.setReal_price(dKdoChoosen.getRealPrice(hnPatient.getPatient().getCounteryId(), 56, 3));
                  obj.setServiceCount(1D);
                  obj.setServiceName("А.Ч.Т.В. (сек)");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                  labSum += obj.getPrice() * obj.getServiceCount();
                  labs.add(obj);
                }
              }
            }
            if (rs.getInt("kdo_id") == 120) { // Garmon
              LvGarmons bio = dLvGarmon.getByPlan(rs.getInt("id"));
              if (bio != null) {
                if (bio.isC1()) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(hnPatient);
                  obj.setPrice(dKdoChoosen.getPrice(hnPatient.getPatient().getCounteryId(), 120, 1));
                  obj.setReal_price(dKdoChoosen.getRealPrice(hnPatient.getPatient().getCounteryId(), 120, 1));
                  obj.setServiceCount(1D);
                  obj.setServiceName("ТТГ");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                  labSum += obj.getPrice() * obj.getServiceCount();
                  labs.add(obj);
                }
                if (bio.isC2()) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(hnPatient);
                  obj.setPrice(dKdoChoosen.getPrice(hnPatient.getPatient().getCounteryId(), 120, 2));
                  obj.setReal_price(dKdoChoosen.getRealPrice(hnPatient.getPatient().getCounteryId(), 120, 2));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Т4");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                  labSum += obj.getPrice() * obj.getServiceCount();
                  labs.add(obj);
                }
                if (bio.isC3()) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(hnPatient);
                  obj.setPrice(dKdoChoosen.getPrice(hnPatient.getPatient().getCounteryId(), 120, 3));
                  obj.setReal_price(dKdoChoosen.getRealPrice(hnPatient.getPatient().getCounteryId(), 120, 3));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Т3");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                  labSum += obj.getPrice() * obj.getServiceCount();
                  labs.add(obj);
                }
                if (bio.isC4()) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(hnPatient);
                  obj.setPrice(dKdoChoosen.getPrice(hnPatient.getPatient().getCounteryId(), 120, 4));
                  obj.setReal_price(dKdoChoosen.getRealPrice(hnPatient.getPatient().getCounteryId(), 120, 4));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Анти-ТРО");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                  labSum += obj.getPrice() * obj.getServiceCount();
                  labs.add(obj);
                }
              }
            }
            if (rs.getInt("kdo_id") == 121) { // Торч
              LvTorchs bio = dLvTorch.getByPlan(rs.getInt("id"));
              if (bio != null) {
                if (bio.isC1()) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(hnPatient);
                  obj.setPrice(dKdoChoosen.getPrice(hnPatient.getPatient().getCounteryId(), 121, 1));
                  obj.setReal_price(dKdoChoosen.getRealPrice(hnPatient.getPatient().getCounteryId(), 121, 1));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Хламидия");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                  labSum += obj.getPrice() * obj.getServiceCount();
                  labs.add(obj);
                }
                if (bio.isC2()) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(hnPatient);
                  obj.setPrice(dKdoChoosen.getPrice(hnPatient.getPatient().getCounteryId(), 121, 2));
                  obj.setReal_price(dKdoChoosen.getRealPrice(hnPatient.getPatient().getCounteryId(), 121, 2));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Токсоплазма");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                  labSum += obj.getPrice() * obj.getServiceCount();
                  labs.add(obj);
                }
                if (bio.isC3()) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(hnPatient);
                  obj.setPrice(dKdoChoosen.getPrice(hnPatient.getPatient().getCounteryId(), 121, 3));
                  obj.setReal_price(dKdoChoosen.getRealPrice(hnPatient.getPatient().getCounteryId(), 121, 3));
                  obj.setServiceCount(1D);
                  obj.setServiceName("ЦМВ");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                  labSum += obj.getPrice() * obj.getServiceCount();
                  labs.add(obj);
                }
                if (bio.isC4()) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(hnPatient);
                  obj.setPrice(dKdoChoosen.getPrice(hnPatient.getPatient().getCounteryId(), 121, 4));
                  obj.setReal_price(dKdoChoosen.getRealPrice(hnPatient.getPatient().getCounteryId(), 121, 4));
                  obj.setServiceCount(1D);
                  obj.setServiceName("ВПГ");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                  labSum += obj.getPrice() * obj.getServiceCount();
                  labs.add(obj);
                }
              }
            }
          } else {
            HNPatientKdos obj = new HNPatientKdos();
            obj.setParent(hnPatient);
            obj.setPrice(dKdo.getKdoPrice(hnPatient.getPatient().getCounteryId(), rs.getInt("kdo_id")));
            if(obj.getParent().getPatient().getCounteryId() == 199)
              obj.setReal_price(rs.getDouble("real_price"));
            else
              obj.setReal_price(rs.getDouble("for_real_price"));
            obj.setServiceCount(rs.getDouble("kdo_count"));
            obj.setServiceName(rs.getString("Kdo_Name"));
            obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
            obj.setServiceType(0);
            dhnPatientKdo.save(obj);
            labSum += obj.getPrice() * obj.getServiceCount();
            labs.add(obj);
          }
          //
        }
        // Медицинские услуги
        ps = conn.prepareStatement(
          "Select t.Kdo_Id, Max(c.`Name`) Kdo_Name, Count(*) Kdo_Count, ifnull(Max(c.Price), 0) Price, ifnull(Max(c.real_price), 0) real_price, ifnull(Max(c.for_real_price), 0) for_real_price " +
            "  From lv_plans t, Kdos c " +
            " Where t.patientId = ? " +
            "    And t.Kdo_Id = c.Id " +
            "    And t.result_id > 0 " +
            "    And t.Kdo_Type_Id not in (1, 2, 3, 8, 19, 20) " +
            "  Group By t.Kdo_Id"
        );
        ps.setInt(1, hnPatient.getPatient().getId());
        rs = ps.executeQuery();
        while (rs.next()) {
          HNPatientKdos obj = new HNPatientKdos();
          obj.setParent(hnPatient);
          obj.setPrice(dKdo.getKdoPrice(hnPatient.getPatient().getCounteryId(), rs.getInt("kdo_id")));
          if(obj.getParent().getPatient().getCounteryId() == 199)
            obj.setReal_price(rs.getDouble("real_price"));
          else
            obj.setReal_price(rs.getDouble("for_real_price"));
          obj.setServiceCount(rs.getDouble("kdo_count"));
          obj.setServiceName(rs.getString("Kdo_Name"));
          obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
          obj.setServiceType(1);
          dhnPatientKdo.save(obj);
          kdoSum += obj.getPrice() * obj.getServiceCount();
          //
          kdos.add(obj);
        }
        // Физиотерапия
        ps = conn.prepareStatement(
          "Select t.Kdo_Id, " +
            "         c.`Name` Kdo_Name, " +
            "         (Select Count(*) From Lv_Fizio_Dates d Where d.fizio_Id = t.Id And d.state = 'Y' And d.done = 'Y') Kdo_Count, " +
            "         ifnull(c.Price, 0) Price, " +
            "         ifnull(c.Real_Price, 0) real_Price, " +
            "         ifnull(c.for_real_price, 0) for_real_price " +
            "    From lv_fizios t, Kdos c " +
            "   Where t.patientId = ? " +
            "     And t.Kdo_Id = c.Id " +
            "     And c.kdo_Type = 8 "
        );
        ps.setInt(1, hnPatient.getPatient().getId());
        rs = ps.executeQuery();
        while (rs.next()) {
          HNPatientKdos obj = new HNPatientKdos();
          obj.setParent(hnPatient);
          obj.setPrice(rs.getDouble("price"));
          //
          if(obj.getParent().getPatient().getCounteryId() == 199)
            obj.setReal_price(rs.getDouble("real_price"));
          else
            obj.setReal_price(rs.getDouble("for_real_price"));
          //
          obj.setServiceCount(rs.getDouble("kdo_count"));
          obj.setServiceName(rs.getString("Kdo_Name"));
          obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
          obj.setServiceType(1);
          dhnPatientKdo.save(obj);
          kdoSum += obj.getPrice() * obj.getServiceCount();
          //
          kdos.add(obj);
        }
        // Консультация
        ps = conn.prepareStatement(
          "Select c.profil, Count(*) counter, ifnull(c.consul_price, 0) price, ifnull(c.for_consul_price, 0) for_price, ifnull(c.real_consul_price, 0) real_price, ifnull(c.for_real_consul_price, 0) for_real_price " +
            "  From lv_consuls t, Users c " +
            " Where t.patientId = ? " +
            "    And c.Id = t.lvId " +
            "  Group By c.profil "
        );
        ps.setInt(1, hnPatient.getPatient().getId());
        rs = ps.executeQuery();
        while (rs.next()) {
          HNPatientKdos obj = new HNPatientKdos();
          obj.setParent(hnPatient);
          if(hnPatient.getPatient().getCounteryId() == 199)
            obj.setPrice(rs.getDouble("price"));
          else
            obj.setPrice(rs.getDouble("for_price"));
          //
          if(hnPatient.getPatient().getCounteryId() == 199)
            obj.setReal_price(rs.getDouble("real_price"));
          else
            obj.setReal_price(rs.getDouble("for_real_price"));
          obj.setServiceCount(rs.getDouble("counter"));
          obj.setServiceName(rs.getString("profil"));
          obj.setServiceType(2);
          dhnPatientKdo.save(obj);
          consulSum += obj.getPrice() * obj.getServiceCount();
          //
          consuls.add(obj);
        }
      } else {
        for(HNPatientKdos service: services) {
          if(service.getServiceType() == 0) { labSum += service.getPrice() * service.getServiceCount(); labs.add(service); }
          if(service.getServiceType() == 1) { kdoSum += service.getPrice() * service.getServiceCount(); kdos.add(service); }
          if(service.getServiceType() == 2) { consulSum += service.getPrice() * service.getServiceCount(); consuls.add(service); }
        }
      }
      //
      List<PatientPays> pays = dPatientPay.byPatient(hnPatient.getPatient().getId());
      for(PatientPays pay: pays) {
        paidSum += pay.getCash() + pay.getCard() + pay.getTransfer();
      }
      //
      List<LvEpics> epics = dLvEpic.getPatientEpics(hnPatient.getPatient().getId());
      List<ObjList> epicRows = new ArrayList<ObjList>();
      Integer days = hnPatient.getDayCount();
      for(LvEpics epic: epics) {
        if(epic.getDateBegin() == null || epic.getKoyko() == null || epic.getPrice() == null) {
          continue;
        }
        ObjList obj = new ObjList();
        obj.setIb(epic.getId().toString());
        obj.setC1(dDept.get(epic.getDeptId()).getName());
        obj.setC2(epic.getRoom().getFloor().getName() + " " + epic.getRoom().getName() + " " + epic.getRoom().getRoomType().getName());
        obj.setC3(Util.dateToString(epic.getDateBegin()));
        obj.setC4(Util.dateToString(epic.getDateEnd()));
        obj.setC5(epic.getPrice().toString());
        obj.setC6(epic.getKoyko() + "");
        days -= epic.getKoyko();
        epicSum += (epic.getPrice() * epic.getKoyko());
        epicRows.add(obj);
      }
      if(epicRows.size() > 0) {
        ObjList obj = new ObjList();
        obj.setIb("-1");
        obj.setC1(hnPatient.getPatient().getDept().getName());
        obj.setC2(hnPatient.getPatient().getRoom().getFloor().getName() + " " + hnPatient.getPatient().getRoom().getName() + " " + hnPatient.getPatient().getRoom().getRoomType().getName());
        obj.setC3(Util.dateToString(hnPatient.getPatient().getStartEpicDate()));
        obj.setC4(Util.dateToString(hnPatient.getDateEnd()));
        obj.setC5(hnPatient.getKoykoPrice().toString());
        obj.setC6(days + "");
        epicSum += (Double.parseDouble(obj.getC6()) * Double.parseDouble(obj.getC5()));
        epicRows.add(obj);
      }
      m.addAttribute("epics", epicRows);
      m.addAttribute("epicSum", epicSum);
      //
      Double disPerc = hnPatient.getPatient().getDis_perc();
      disPerc = (disPerc == null ? 0 : disPerc) / 100;
      Double koyko = hnPatient.getKoykoPrice() * hnPatient.getDayCount();
      if(epicRows.size() > 0) {
        totalSum = watcherSum + drugSum + labSum + kdoSum + consulSum + (epicSum - epicSum * disPerc) + (hnPatient.getEatPrice() * hnPatient.getDayCount());
      } else {
        totalSum = watcherSum + drugSum + labSum + kdoSum + consulSum + (koyko - koyko * disPerc) + (hnPatient.getEatPrice() * hnPatient.getDayCount());
      }
      hnPatient.setPaySum((double) Math.round((totalSum - paidSum) * 100) / 100);
      hnPatient.setTotalSum((double) Math.round(totalSum * 100) / 100);
      //
      dhnPatient.save(hnPatient);
      m.addAttribute("labs", labs);
      m.addAttribute("kdos", kdos);
      m.addAttribute("consuls", consuls);
      //
      m.addAttribute("labSum", labSum);
      m.addAttribute("kdoSum", kdoSum);
      m.addAttribute("consulSum", consulSum);
      m.addAttribute("watcherSum", watcherSum);
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
      DB.done(rs);
      DB.done(ps);
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
    m.addAttribute("obj", hnPatient);
    m.addAttribute("lvFio", dUser.get(hnPatient.getPatient().getLv_id()).getFio());
    m.addAttribute("drugs", dhnPatientDrug.getList("From HNPatientDrugs Where parent.id = " + Util.getInt(req, "id")));
    //
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      conn = DB.getConnection();
      Double drugSum =  DB.getSum(conn, "Select Sum(t.price * t.serviceCount) From HN_Patient_Drugs t Where t.hn_patient = " + Util.getInt(req, "id"));
      m.addAttribute("summ", drugSum);
      //
      List<HNPatientKdos> services = dhnPatientKdo.getList("From HNPatientKdos Where parent.id = " + hnPatient.getId());
      List<HNPatientKdos> labs = new ArrayList<HNPatientKdos>();
      List<HNPatientKdos> consuls = new ArrayList<HNPatientKdos>();
      List<HNPatientKdos> kdos = new ArrayList<HNPatientKdos>();
      double labSum = 0D, consulSum = 0D, kdoSum = 0D, watcherSum = 0D, discountSum = 0;
      for(HNPatientKdos service: services) {
        if(service.getServiceType() == 0) {
          labSum += service.getPrice() * service.getServiceCount();
          labs.add(service);
          if(service.getPrice() == 0)
            discountSum += service.getReal_price() * service.getServiceCount();
        }
        if(service.getServiceType() == 1) {
          kdoSum += service.getPrice() * service.getServiceCount();
          kdos.add(service);
          if(service.getPrice() == 0)
            discountSum += service.getReal_price() * service.getServiceCount();
        }
        if(service.getServiceType() == 2) {
          consulSum += service.getPrice() * service.getServiceCount();
          consuls.add(service);
          if(service.getPrice() == 0)
            discountSum += service.getReal_price() * service.getServiceCount();
        }
      }
      // Дополнительное место
      List<PatientWatchers> watchers = dPatientWatcher.byPatient(hnPatient.getPatient().getId());
      for(PatientWatchers watcher: watchers)
        watcherSum += watcher.getDayCount() * watcher.getPrice();
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
      double cash = 0D, card = 0D, transfer = 0D;
      List<PatientPays> pays = dPatientPay.byPatient(hnPatient.getPatient().getId());
      for(PatientPays pay: pays) {
        cash += pay.getCash();
        card += pay.getCard();
        transfer += pay.getTransfer();
      }
      m.addAttribute("cashSum", cash);
      m.addAttribute("cardSum", card);
      m.addAttribute("transferSum", transfer);
      // Переводной эпикриз
      List<LvEpics> epics = dLvEpic.getPatientEpics(hnPatient.getPatient().getId());
      List<ObjList> epicRows = new ArrayList<ObjList>();
      Integer days = hnPatient.getDayCount();
      Double epicSum = 0D;
      for(LvEpics epic: epics) {
        if(epic.getDateBegin() == null || epic.getKoyko() == null || epic.getPrice() == null) {
          continue;
        }
        ObjList obj = new ObjList();
        obj.setIb(epic.getId().toString());
        obj.setC1(dDept.get(epic.getDeptId()).getName());
        obj.setC2(epic.getRoom().getFloor().getName() + " " + epic.getRoom().getName() + " " + epic.getRoom().getRoomType().getName());
        obj.setC3(Util.dateToString(epic.getDateBegin()));
        obj.setC4(Util.dateToString(epic.getDateEnd()));
        obj.setC5(epic.getPrice().toString());
        obj.setC6(epic.getKoyko() + "");
        days -= epic.getKoyko();
        epicSum += epic.getKoyko() * epic.getPrice();
        epicRows.add(obj);
      }
      if(epicRows.size() > 0) {
        ObjList obj = new ObjList();
        obj.setIb("-1");
        obj.setC1(hnPatient.getPatient().getDept().getName());
        obj.setC2(hnPatient.getPatient().getRoom().getFloor().getName() + " " + hnPatient.getPatient().getRoom().getName() + " " + hnPatient.getPatient().getRoom().getRoomType().getName());
        obj.setC3(Util.dateToString(hnPatient.getPatient().getStartEpicDate()));
        obj.setC4(Util.dateToString(hnPatient.getDateEnd()));
        obj.setC5(hnPatient.getKoykoPrice().toString());
        obj.setC6(days + "");
        epicRows.add(obj);
      }
      m.addAttribute("epics", epicRows);
      Double disPerc = hnPatient.getPatient().getDis_perc();
      disPerc = disPerc == null ? 0 : disPerc;
      double koyko;
      if(epicRows.size() > 0)
        koyko = epicSum;
      else
        koyko = hnPatient.getKoykoPrice() * hnPatient.getDayCount();
      //
      m.addAttribute("dis_sum", koyko);
      m.addAttribute("dis_perc", disPerc);
      m.addAttribute("discount_sum", discountSum);
      String sum_in_word = Util.inwords(hnPatient.getTotalSum());
      m.addAttribute("sum_in_word", sum_in_word.substring(0, 1).toUpperCase() + sum_in_word.substring(1));
      m.addAttribute("clinic_name", dParam.byCode("CLINIC_NAME"));
      m.addAttribute("boss", dUser.getBoss(0));
      m.addAttribute("glv", dUser.getGlb(0));
      m.addAttribute("glavbuh", dUser.getGlavbuh(0));
      m.addAttribute("clinic_name", dParam.byCode("CLINIC_NAME"));
      m.addAttribute("head_nurse", hnPatient.getPatient().getDept().getNurse().getFio());

      //
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
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
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      conn = DB.getConnection();
      HNPatients pat = dhnPatient.get(Util.getInt(req, "id"));
      List<HNPatientKdos> kdos = dhnPatientKdo.getList("From HNPatientKdos Where parent.id = " + pat.getId() + " And serviceType = " + Util.get(req, "type"));
      for(HNPatientKdos kdo: kdos) {
        dhnPatientKdo.delete(kdo.getId());
      }
      if(Util.get(req, "type").equals("0")) {
        // Лабораторные исследования
        ps = conn.prepareStatement(
          "Select t.id, t.Kdo_Id, c.`Name` Kdo_Name, 1 Kdo_Count, ifnull(c.Price, 0) Price, ifnull(c.Real_Price, 0) real_Price, ifnull(c.for_real_price, 0) for_real_price " +
            "  From lv_plans t, Kdos c " +
            " Where t.patientId = ? " +
            "    And t.Kdo_Id = c.Id " +
            "    And t.result_id > 0 " +
            "    And t.Kdo_Type_Id in (1, 2, 3, 19, 20) "
        );
        ps.setInt(1, pat.getPatient().getId());
        rs = ps.executeQuery();
        while (rs.next()) {
          if(rs.getInt("kdo_id") == 121 || rs.getInt("kdo_id") == 120 || rs.getInt("kdo_id") == 56 || rs.getInt("kdo_id") == 153) {
            if (rs.getInt("kdo_id") == 153) {
              LvBios bio = dLvBio.getByPlan(rs.getInt("id"));
              if (bio != null) {
                if (bio.getC1() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(pat);
                  obj.setPrice(dKdoChoosen.getPrice(pat.getPatient().getCounteryId(), 153, 1));
                  obj.setReal_price(dKdoChoosen.getRealPrice(pat.getPatient().getCounteryId(), 153, 1));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Умумий оксил");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                }
                if (bio.getC2() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(pat);
                  obj.setPrice(dKdoChoosen.getPrice(pat.getPatient().getCounteryId(), 153, 2));
                  obj.setReal_price(dKdoChoosen.getRealPrice(pat.getPatient().getCounteryId(), 153, 2));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Холестерин");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                }
                if (bio.getC3() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(pat);
                  obj.setPrice(dKdoChoosen.getPrice(pat.getPatient().getCounteryId(), 153, 3));
                  obj.setReal_price(dKdoChoosen.getRealPrice(pat.getPatient().getCounteryId(), 153, 3));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Глюкоза");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                }
                if (bio.getC4() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(pat);
                  obj.setPrice(dKdoChoosen.getPrice(pat.getPatient().getCounteryId(), 153, 4));
                  obj.setReal_price(dKdoChoosen.getRealPrice(pat.getPatient().getCounteryId(), 153, 4));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Мочевина");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                }
                if (bio.getC5() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(pat);
                  obj.setPrice(dKdoChoosen.getPrice(pat.getPatient().getCounteryId(), 153, 5));
                  obj.setReal_price(dKdoChoosen.getRealPrice(pat.getPatient().getCounteryId(), 153, 5));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Креатинин");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                }
                if (bio.getC6() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(pat);
                  obj.setPrice(dKdoChoosen.getPrice(pat.getPatient().getCounteryId(), 153, 6));
                  obj.setReal_price(dKdoChoosen.getRealPrice(pat.getPatient().getCounteryId(), 153, 6));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Билирубин");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                }
                if (bio.getC7() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(pat);
                  obj.setPrice(dKdoChoosen.getPrice(pat.getPatient().getCounteryId(), 153, 7));
                  obj.setReal_price(dKdoChoosen.getRealPrice(pat.getPatient().getCounteryId(), 153, 7));
                  obj.setServiceCount(1D);
                  obj.setServiceName("АЛТ");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                }
                if (bio.getC8() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(pat);
                  obj.setPrice(dKdoChoosen.getPrice(pat.getPatient().getCounteryId(), 153, 8));
                  obj.setReal_price(dKdoChoosen.getRealPrice(pat.getPatient().getCounteryId(), 153, 8));
                  obj.setServiceCount(1D);
                  obj.setServiceName("АСТ");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                }
                if (bio.getC9() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(pat);
                  obj.setPrice(dKdoChoosen.getPrice(pat.getPatient().getCounteryId(), 153, 9));
                  obj.setReal_price(dKdoChoosen.getRealPrice(pat.getPatient().getCounteryId(), 153, 9));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Альфа амилаза");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                }
                if (bio.getC10() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(pat);
                  obj.setPrice(dKdoChoosen.getPrice(pat.getPatient().getCounteryId(), 153, 10));
                  obj.setReal_price(dKdoChoosen.getRealPrice(pat.getPatient().getCounteryId(), 153, 10));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Кальций");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                }
                if (bio.getC11() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(pat);
                  obj.setPrice(dKdoChoosen.getPrice(pat.getPatient().getCounteryId(), 153, 11));
                  obj.setReal_price(dKdoChoosen.getRealPrice(pat.getPatient().getCounteryId(), 153, 11));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Сийдик кислотаси");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                }
                if (bio.getC12() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(pat);
                  obj.setPrice(dKdoChoosen.getPrice(pat.getPatient().getCounteryId(), 153, 12));
                  obj.setReal_price(dKdoChoosen.getRealPrice(pat.getPatient().getCounteryId(), 153, 12));
                  obj.setServiceCount(1D);
                  obj.setServiceName("K – калий");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                }
                if (bio.getC13() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(pat);
                  obj.setPrice(dKdoChoosen.getPrice(pat.getPatient().getCounteryId(), 153, 13));
                  obj.setReal_price(dKdoChoosen.getRealPrice(pat.getPatient().getCounteryId(), 153, 13));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Na – натрий");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                }
                if (bio.getC14() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(pat);
                  obj.setPrice(dKdoChoosen.getPrice(pat.getPatient().getCounteryId(), 153, 14));
                  obj.setReal_price(dKdoChoosen.getRealPrice(pat.getPatient().getCounteryId(), 153, 14));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Fe – темир");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                }
                if (bio.getC15() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(pat);
                  obj.setPrice(dKdoChoosen.getPrice(pat.getPatient().getCounteryId(), 153, 15));
                  obj.setReal_price(dKdoChoosen.getRealPrice(pat.getPatient().getCounteryId(), 153, 15));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Mg – магний");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                }
                if (bio.getC16() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(pat);
                  obj.setPrice(dKdoChoosen.getPrice(pat.getPatient().getCounteryId(), 153, 16));
                  obj.setReal_price(dKdoChoosen.getRealPrice(pat.getPatient().getCounteryId(), 153, 16));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Ишкорий фасфотаза");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                }
                if (bio.getC17() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(pat);
                  obj.setPrice(dKdoChoosen.getPrice(pat.getPatient().getCounteryId(), 153, 17));
                  obj.setReal_price(dKdoChoosen.getRealPrice(pat.getPatient().getCounteryId(), 153, 17));
                  obj.setServiceCount(1D);
                  obj.setServiceName("ГГТ");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                }
                if (bio.getC18() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(pat);
                  obj.setPrice(dKdoChoosen.getPrice(pat.getPatient().getCounteryId(), 153, 18));
                  obj.setReal_price(dKdoChoosen.getRealPrice(pat.getPatient().getCounteryId(), 153, 18));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Гликирланган гемоглобин");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                }
                if (bio.getC19() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(pat);
                  obj.setPrice(dKdoChoosen.getPrice(pat.getPatient().getCounteryId(), 153, 19));
                  obj.setReal_price(dKdoChoosen.getRealPrice(pat.getPatient().getCounteryId(), 153, 19));
                  obj.setServiceCount(1D);
                  obj.setServiceName("РФ");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                }
                if (bio.getC20() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(pat);
                  obj.setPrice(dKdoChoosen.getPrice(pat.getPatient().getCounteryId(), 153, 20));
                  obj.setReal_price(dKdoChoosen.getRealPrice(pat.getPatient().getCounteryId(), 153, 20));
                  obj.setServiceCount(1D);
                  obj.setServiceName("АСЛО");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                }
                if (bio.getC21() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(pat);
                  obj.setPrice(dKdoChoosen.getPrice(pat.getPatient().getCounteryId(), 153, 21));
                  obj.setReal_price(dKdoChoosen.getRealPrice(pat.getPatient().getCounteryId(), 153, 21));
                  obj.setServiceCount(1D);
                  obj.setServiceName("СРБ");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                }
                if (bio.getC22() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(pat);
                  obj.setPrice(dKdoChoosen.getPrice(pat.getPatient().getCounteryId(), 153, 22));
                  obj.setReal_price(dKdoChoosen.getRealPrice(pat.getPatient().getCounteryId(), 153, 22));
                  obj.setServiceCount(1D);
                  obj.setServiceName("RW");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                }
                if (bio.getC23() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(pat);
                  obj.setPrice(dKdoChoosen.getPrice(pat.getPatient().getCounteryId(), 153, 23));
                  obj.setReal_price(dKdoChoosen.getRealPrice(pat.getPatient().getCounteryId(), 153, 23));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Hbs Ag");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                }
                if (bio.getC24() == 1) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(pat);
                  obj.setPrice(dKdoChoosen.getPrice(pat.getPatient().getCounteryId(), 153, 24));
                  obj.setReal_price(dKdoChoosen.getRealPrice(pat.getPatient().getCounteryId(), 153, 24));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Гепатит «С» ВГС");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                }
              }
            }
            if (rs.getInt("kdo_id") == 56) { // Каулограмма
              LvCouls bio = dLvCoul.getByPlan(rs.getInt("id"));
              if (bio != null) {
                if (bio.isC4()) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(pat);
                  obj.setPrice(dKdoChoosen.getPrice(pat.getPatient().getCounteryId(), 56, 4));
                  obj.setReal_price(dKdoChoosen.getRealPrice(pat.getPatient().getCounteryId(), 56, 4));
                  obj.setServiceCount(1D);
                  obj.setServiceName("ПТИ");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                }
                if (bio.isC1()) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(pat);
                  obj.setPrice(dKdoChoosen.getPrice(pat.getPatient().getCounteryId(), 56, 1));
                  obj.setReal_price(dKdoChoosen.getRealPrice(pat.getPatient().getCounteryId(), 56, 1));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Фибриноген");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                }
                if (bio.isC2()) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(pat);
                  obj.setPrice(dKdoChoosen.getPrice(pat.getPatient().getCounteryId(), 56, 2));
                  obj.setReal_price(dKdoChoosen.getRealPrice(pat.getPatient().getCounteryId(), 56, 2));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Тромбин вакти");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                }
                if (bio.isC3()) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(pat);
                  obj.setPrice(dKdoChoosen.getPrice(pat.getPatient().getCounteryId(), 56, 3));
                  obj.setReal_price(dKdoChoosen.getRealPrice(pat.getPatient().getCounteryId(), 56, 3));
                  obj.setServiceCount(1D);
                  obj.setServiceName("А.Ч.Т.В. (сек)");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                }
              }
            }
            if (rs.getInt("kdo_id") == 120) { // Garmon
              LvGarmons bio = dLvGarmon.getByPlan(rs.getInt("id"));
              if (bio != null) {
                if (bio.isC1()) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(pat);
                  obj.setPrice(dKdoChoosen.getPrice(pat.getPatient().getCounteryId(), 120, 1));
                  obj.setReal_price(dKdoChoosen.getRealPrice(pat.getPatient().getCounteryId(), 120, 1));
                  obj.setServiceCount(1D);
                  obj.setServiceName("ТТГ");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                }
                if (bio.isC2()) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(pat);
                  obj.setPrice(dKdoChoosen.getPrice(pat.getPatient().getCounteryId(), 120, 2));
                  obj.setReal_price(dKdoChoosen.getRealPrice(pat.getPatient().getCounteryId(), 120, 2));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Т4");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                }
                if (bio.isC3()) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(pat);
                  obj.setPrice(dKdoChoosen.getPrice(pat.getPatient().getCounteryId(), 120, 3));
                  obj.setReal_price(dKdoChoosen.getRealPrice(pat.getPatient().getCounteryId(), 120, 3));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Т3");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                }
                if (bio.isC4()) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(pat);
                  obj.setPrice(dKdoChoosen.getPrice(pat.getPatient().getCounteryId(), 120, 4));
                  obj.setReal_price(dKdoChoosen.getRealPrice(pat.getPatient().getCounteryId(), 120, 4));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Анти-ТРО");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                }
              }
            }
            if (rs.getInt("kdo_id") == 121) { // Торч
              LvTorchs bio = dLvTorch.getByPlan(rs.getInt("id"));
              if (bio != null) {
                if (bio.isC1()) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(pat);
                  obj.setPrice(dKdoChoosen.getPrice(pat.getPatient().getCounteryId(), 121, 1));
                  obj.setReal_price(dKdoChoosen.getRealPrice(pat.getPatient().getCounteryId(), 121, 1));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Хламидия");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                }
                if (bio.isC2()) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(pat);
                  obj.setPrice(dKdoChoosen.getPrice(pat.getPatient().getCounteryId(), 121, 2));
                  obj.setReal_price(dKdoChoosen.getRealPrice(pat.getPatient().getCounteryId(), 121, 2));
                  obj.setServiceCount(1D);
                  obj.setServiceName("Токсоплазма");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                }
                if (bio.isC3()) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(pat);
                  obj.setPrice(dKdoChoosen.getPrice(pat.getPatient().getCounteryId(), 121, 3));
                  obj.setReal_price(dKdoChoosen.getRealPrice(pat.getPatient().getCounteryId(), 121, 3));
                  obj.setServiceCount(1D);
                  obj.setServiceName("ЦМВ");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                }
                if (bio.isC4()) {
                  HNPatientKdos obj = new HNPatientKdos();
                  obj.setParent(pat);
                  obj.setPrice(dKdoChoosen.getPrice(pat.getPatient().getCounteryId(), 121, 4));
                  obj.setReal_price(dKdoChoosen.getRealPrice(pat.getPatient().getCounteryId(), 121, 4));
                  obj.setServiceCount(1D);
                  obj.setServiceName("ВПГ");
                  obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
                  obj.setServiceType(0);
                  dhnPatientKdo.save(obj);
                }
              }
            }
          } else {
            HNPatientKdos obj = new HNPatientKdos();
            obj.setParent(pat);
            obj.setPrice(dKdo.getKdoPrice(pat.getPatient().getCounteryId(), rs.getInt("kdo_id")));
            obj.setReal_price(dKdo.getKdoRealPrice(pat.getPatient().getCounteryId(), rs.getInt("kdo_id")));
            obj.setServiceCount(rs.getDouble("kdo_count"));
            obj.setServiceName(rs.getString("Kdo_Name"));
            obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
            obj.setServiceType(0);
            dhnPatientKdo.save(obj);
          }
        }
      }
      // Медицинские услуги
      if(Util.get(req, "type").equals("1")) {
        ps = conn.prepareStatement(
          "Select t.Kdo_Id, Max(c.`Name`) Kdo_Name, Count(*) Kdo_Count, ifnull(Max(c.Price), 0) Price " +
            "  From lv_plans t, Kdos c " +
            " Where t.patientId = ? " +
            "    And t.Kdo_Id = c.Id " +
            "    And t.result_id > 0 " +
            "    And t.Kdo_Type_Id not in (1, 2, 3, 8, 19, 20) " +
            "  Group By t.Kdo_Id"
        );
        ps.setInt(1, pat.getPatient().getId());
        rs = ps.executeQuery();
        while (rs.next()) {
          HNPatientKdos obj = new HNPatientKdos();
          obj.setParent(pat);
          obj.setPrice(dKdo.getKdoPrice(pat.getPatient().getCounteryId(), rs.getInt("kdo_id")));
          obj.setReal_price(dKdo.getKdoRealPrice(pat.getPatient().getCounteryId(), rs.getInt("kdo_id")));
          obj.setServiceCount(rs.getDouble("kdo_count"));
          obj.setServiceName(rs.getString("Kdo_Name"));
          obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
          obj.setServiceType(1);
          dhnPatientKdo.save(obj);
        }
        // Физиотерапия
        ps = conn.prepareStatement(
          "Select t.Kdo_Id, " +
            "         c.`Name` Kdo_Name, " +
            "         (Select Count(*) From Lv_Fizio_Dates d Where d.fizio_Id = t.Id And d.state = 'Y' And d.done = 'Y') Kdo_Count, " +
            "         ifnull(c.Price, 0) Price, " +
            "         ifnull(c.Real_Price, 0) real_Price, " +
            "         ifnull(c.for_real_price, 0) for_real_price " +
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
          obj.setPrice(dKdo.getKdoPrice(pat.getPatient().getCounteryId(), rs.getInt("kdo_id")));
          obj.setReal_price(dKdo.getKdoRealPrice(pat.getPatient().getCounteryId(), rs.getInt("kdo_id")));
          obj.setServiceCount(rs.getDouble("kdo_count"));
          obj.setServiceName(rs.getString("Kdo_Name"));
          obj.setKdo(dKdo.get(rs.getInt("kdo_id")));
          obj.setServiceType(1);
          dhnPatientKdo.save(obj);
        }
      }
      // Консультация
      if(Util.get(req, "type").equals("2")) {
        ps = conn.prepareStatement(
          "Select c.profil, Count(*) counter, ifnull(c.consul_price, 0) price, ifnull(c.for_consul_price, 0) for_price, ifnull(c.real_consul_price, 0) real_price, ifnull(c.for_real_consul_price, 0) for_real_price" +
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
          if(pat.getPatient().getCounteryId() == 199)
            obj.setPrice(rs.getDouble("price"));
          else
            obj.setPrice(rs.getDouble("for_price"));
          //
          if(pat.getPatient().getCounteryId() == 199)
            obj.setReal_price(rs.getDouble("real_price"));
          else
            obj.setReal_price(rs.getDouble("for_real_price"));
          obj.setServiceCount(rs.getDouble("counter"));
          obj.setServiceName(rs.getString("profil"));
          obj.setServiceType(2);
          dhnPatientKdo.save(obj);
        }
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(conn);
    }
    return json.toString();
  }

  @RequestMapping(value = "service/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String saveService(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      HNPatients pat = dhnPatient.get(Util.getInt(req, "id"));
      HNPatientKdos kdo = new HNPatientKdos();
      if(Util.get(req, "type").equals("lab")) kdo.setServiceType(0);
      if(Util.get(req, "type").equals("kdo")) kdo.setServiceType(1);
      if(Util.get(req, "type").equals("consul")) kdo.setServiceType(2);
      kdo.setPrice(Double.parseDouble(Util.get(req, "price")));
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
