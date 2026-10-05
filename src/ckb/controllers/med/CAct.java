package ckb.controllers.med;

import ckb.dao.admin.users.DUser;
import ckb.dao.med.head_nurse.patient.DHNPatient;
import ckb.dao.med.head_nurse.patient.drugs.DHNPatientDrug;
import ckb.dao.med.head_nurse.patient.kdos.DHNPatientKdo;
import ckb.dao.med.lv.bio.DLvBio;
import ckb.dao.med.lv.coul.DLvCoul;
import ckb.dao.med.lv.epic.DLvEpic;
import ckb.dao.med.lv.garmon.DLvGarmon;
import ckb.dao.med.lv.plan.DLvPlan;
import ckb.dao.med.lv.torch.DLvTorch;
import ckb.dao.med.patient.DPatient;
import ckb.dao.med.patient.DPatientPays;
import ckb.dao.med.patient.DPatientPlan;
import ckb.dao.med.patient.DPatientWatchers;
import ckb.domains.med.head_nurse.HNPatientDrugs;
import ckb.domains.med.head_nurse.HNPatientKdos;
import ckb.domains.med.head_nurse.HNPatients;
import ckb.domains.med.lv.LvEpics;
import ckb.domains.med.patient.PatientPays;
import ckb.domains.med.patient.PatientWatchers;
import ckb.domains.med.patient.Patients;
import ckb.models.ActCalc;
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
import java.util.Calendar;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/act/")
public class CAct {

  @Autowired private DHNPatient dhnPatient;
  @Autowired private DHNPatientDrug dhnPatientDrug;
  @Autowired private DHNPatientKdo dhnPatientKdo;
  @Autowired private DPatientPays dPatientPay;
  @Autowired private SPatient sPatient;
  @Autowired private DPatient dPatient;
  @Autowired private DUser dUser;
  @Autowired private DPatientWatchers dPatientWatcher;
  @Autowired private DLvBio dLvBio;
  @Autowired private DLvCoul dLvCoul;
  @Autowired private DLvGarmon dLvGarmon;
  @Autowired private DLvTorch dLvTorch;
  @Autowired private DLvPlan dLvPlan;
  @Autowired private DPatientPlan dPatientPlan;
  @Autowired private DLvEpic dLvEpic;
  @Autowired private BeanUsers beanUsers;
  @Autowired private BeanSession beanSession;

  Date startDate = Util.stringToDate("31.03.2024");

  @RequestMapping("index.s")
  protected String patients(HttpServletRequest req, Model m) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/act/index.s");
    Calendar start = Calendar.getInstance();
    start.setTime(new Date());
    start.add(Calendar.DATE, -4);
    Calendar end = Calendar.getInstance();
    end.setTime(new Date());
    end.add(Calendar.DATE, 2);
    String sd = session.getSessionFilter("s_act_start_date", "period_start", req, Util.dateToString(start.getTime()));
    String ed = session.getSessionFilter("s_act_end_date", "period_end", req, Util.dateToString(end.getTime()));
    String filter = session.getSessionFilter("s_act_word", "word", req, null);
    String pay_sum_type = session.getSessionFilter("s_act_pay_sum_type", "pay_sum_type", req, "0");
    //
    String where = "";
    if(filter != null) {
      where = " (patient.id like '" + filter + "' Or Upper(patient.surname) like '%" + filter.toUpperCase() + "%' Or Upper(patient.name) like '%" + filter.toUpperCase() + "%' Or Upper(patient.middlename) like '%" + filter.toUpperCase() + "%' Or patient.yearNum like '%" + filter.toUpperCase() + "%') And ";
    }
    m.addAttribute("rows", dhnPatient.getList("From HNPatients t Where " + where + " t.state != 'E' " + (pay_sum_type.equals("0") ? "" : pay_sum_type.equals("1") ? " And paySum < -1 " : " And paySum > 1 ") + " And ifnull(t.dateEnd, CURRENT_DATE()) Between '" + Util.dateDB(sd) + "' And '" + Util.dateDB(ed) + "' Order By t.id Desc"));
    m.addAttribute("filter", filter);
    m.addAttribute("period_start", sd);
    m.addAttribute("period_end", ed);
    m.addAttribute("pay_sum_type", pay_sum_type);
    return "med/act/index";
  }

  @RequestMapping("info.s")
  protected String info(HttpServletRequest req, Model m) throws Exception {
    //
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/act/info.s?id=" + Util.get(req, "id"));
    //
    ActCalc c = sPatient.act_calc(Util.getInt(req, "id"));
    HNPatients hnPatient = c.hnPatient;
    //
    m.addAttribute("obj", hnPatient);
    m.addAttribute("labs", c.labs);
    m.addAttribute("kdos", c.kdos);
    m.addAttribute("consuls", c.consuls);
    m.addAttribute("drugs", c.drugs);
    m.addAttribute("drugSum", c.drugSum);
    m.addAttribute("epics", c.epicRows);
    m.addAttribute("epicSum", c.epicSum);
    //
    m.addAttribute("labSum", c.labSum);
    m.addAttribute("kdoSum", c.kdoSum);
    m.addAttribute("consulSum", c.consulSum);
    m.addAttribute("watcherSum", c.watcherSum);
    m.addAttribute("discountSum_discount", c.discountSum);
    m.addAttribute("discountSum_koyko", c.koyko * c.disPerc);
    m.addAttribute("dis_perc", c.disPerc);
    m.addAttribute("paidSum", c.paidSum);
    m.addAttribute("watchers", c.watchers);
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
    return "med/act/addEdit";
  }

  @RequestMapping("excel.s")
  protected String excel(HttpServletRequest req, Model m) throws Exception {
    //
    ActCalc c = sPatient.act_calc(Util.getInt(req, "id"));
    HNPatients hnPatient = c.hnPatient;
    //
    double discountSum = 0;
    for(HNPatientKdos service: c.labs)
      if(service.getPrice() == 0) discountSum += service.getReal_price() * service.getServiceCount();
    for(HNPatientKdos service: c.kdos)
      if(service.getPrice() == 0) discountSum += service.getReal_price() * service.getServiceCount();
    for(HNPatientKdos service: c.consuls)
      if(service.getPrice() == 0) discountSum += service.getReal_price() * service.getServiceCount();
    //
    double cash = 0D, card = 0D, transfer = 0D, online = 0D;
    List<PatientPays> pays = dPatientPay.byPatient(hnPatient.getPatient().getId());
    for(PatientPays pay: pays) {
      cash += pay.getCash();
      card += pay.getCard();
      transfer += pay.getTransfer();
      online += pay.getOnline();
    }
    //
    String sum_in_word = Util.inwords(hnPatient.getTotalSum());
    //
    m.addAttribute("obj", hnPatient);
    m.addAttribute("lvFio", dUser.get(hnPatient.getPatient().getLv_id()).getFio());
    m.addAttribute("drugs", c.drugs);
    m.addAttribute("cashSum", cash);
    m.addAttribute("cardSum", card);
    m.addAttribute("transferSum", transfer);
    m.addAttribute("onlineSum", online);
    m.addAttribute("watchers", c.watchers);
    m.addAttribute("labs", c.labs);
    m.addAttribute("kdos", c.kdos);
    m.addAttribute("consuls", c.consuls);
    m.addAttribute("disSum", c.discountSum);
    m.addAttribute("epics", c.epicRows);
    m.addAttribute("ndsProc", hnPatient.getNdsProc());
    m.addAttribute("discount_sum", discountSum);
    m.addAttribute("sum_in_word", sum_in_word.substring(0, 1).toUpperCase() + sum_in_word.substring(1));
    m.addAttribute("clinic_name", beanSession.getParam("CLINIC_NAME"));
    m.addAttribute("boss", beanUsers.getBoss());
    m.addAttribute("glv", beanUsers.getGlb());
    m.addAttribute("glavbuh", beanUsers.getGlavbuh());
    m.addAttribute("head_nurse", hnPatient.getPatient().getDept().getNurse().getFio());
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
    try {
      HNPatients obj = dhnPatient.get(Util.getInt(req, "id"));
      obj.setDayCount(Util.getInt(req, "days"));
      obj.setDateEnd(Util.getDate(req, "date_end"));
      obj.setActNum(Util.get(req, "act"));
      obj.setKoykoPrice(Double.parseDouble(Util.get(req, "koyko_price", "0")));
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
    Session session = SessionUtil.getUser(req);
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
    Session session = SessionUtil.getUser(req);
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
    //
    Connection conn = null;
    try {
      conn = DB.getConnection();
      HNPatients pat = dhnPatient.get(Util.getInt(req, "id"));
      dhnPatientKdo.delSql("From HNPatientKdos Where parent.id = " + pat.getId() + " And serviceType = " + Util.get(req, "type"));
      // Лабораторные исследования
      if(Util.get(req, "type").equals("0")) sPatient.updateLabServices(conn, pat);
      // Медицинские услуги
      if(Util.get(req, "type").equals("1")) sPatient.updateMedServices(conn, pat);
      // Консультация
      if(Util.get(req, "type").equals("2")) sPatient.updateCountServices(conn, pat);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    } finally {
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
      int id = Util.getInt(req, "id");
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
