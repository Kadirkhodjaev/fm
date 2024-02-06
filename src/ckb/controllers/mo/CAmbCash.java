package ckb.controllers.mo;

import ckb.dao.admin.country.DCountry;
import ckb.dao.admin.params.DParam;
import ckb.dao.admin.region.DRegion;
import ckb.dao.admin.users.DUser;
import ckb.dao.med.amb.DAmbPatient;
import ckb.dao.med.amb.DAmbPatientPay;
import ckb.dao.med.amb.DAmbPatientService;
import ckb.dao.med.cashbox.discount.DCashDiscount;
import ckb.domains.admin.Clients;
import ckb.domains.med.amb.AmbPatientPays;
import ckb.domains.med.amb.AmbPatientServices;
import ckb.domains.med.amb.AmbPatients;
import ckb.domains.med.cash.CashDiscounts;
import ckb.models.AmbService;
import ckb.services.mo.amb.SMoAmb;
import ckb.session.Session;
import ckb.session.SessionUtil;
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
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping(value = "/cash/amb/")
public class CAmbCash {

  @Autowired private DAmbPatient dAmbPatient;
  @Autowired private DAmbPatientService dAmbPatientService;
  @Autowired private DCountry dCountry;
  @Autowired private DRegion dRegion;
  @Autowired private DCashDiscount dCashDiscount;
  @Autowired private DAmbPatientPay dAmbPatientPay;
  @Autowired private DUser dUser;
  @Autowired private DParam dParam;
  @Autowired private SMoAmb sMoAmb;

  @RequestMapping("patient.s")
  protected String patient(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    int id = Util.getInt(req, "id", 0);
    session.setCurPat(id);
    session.setCurUrl("/cash/amb/patient.s?id=" + id);
    try {
      // Пациент
      AmbPatients patient = dAmbPatient.get(id);
      Clients client = patient.getClient() == null ? new Clients() : patient.getClient();
      client.setCountry(patient.getCounteryId() == null ? null : dCountry.get(patient.getCounteryId()));
      client.setRegion(patient.getRegionId() == null ? null : dRegion.get(patient.getRegionId()));
      client.setBirthyear(patient.getBirthyear() != null ? patient.getBirthyear() : client.getBirthyear());
      patient.setClient(client);
      // Услуги
      List<AmbService> ss = new ArrayList<AmbService>();
      List<AmbPatientServices> services = dAmbPatientService.getList("From AmbPatientServices Where patient = " + id);
      for(AmbPatientServices s: services) {
        AmbService d = new AmbService();
        d.setId(s.getId());
        d.setState(s.getState());
        d.setService(s.getService());
        d.setWorker(s.getWorker());
        d.setMsg(s.getMsg());
        d.setPlanDate(s.getPlanDate());
        d.setConfDate(s.getConfDate());
        d.setDprice(s.getPrice());

        d.setPrice(Util.sumFormat(s.getPrice()));
        ss.add(d);
      }
      model.addAttribute("patient_services", ss);
      // Сумма скидки
      Double discountSum = dCashDiscount.patientAmbDiscountSum(patient.getId());
      model.addAttribute("discount_sum", discountSum);
      model.addAttribute("discounts", dCashDiscount.amb(patient.getId()));
      // Оплаченная сумма
      Double paid = dAmbPatientPay.paidSum(patient.getId());
      model.addAttribute("paid_sum", paid);
      model.addAttribute("pays", dAmbPatientPay.byPatient(patient.getId()));
      // К оплате
      double entSum = dAmbPatientService.patientTotalSum(patient.getId());
      model.addAttribute("ent_sum", entSum);
      //
      model.addAttribute("patient", patient);
    } catch (Exception e) {
      e.printStackTrace();
    }
    return "/mo/amb/cash/patient";
  }

  @RequestMapping(value = "discount.s", method = RequestMethod.POST)
  @ResponseBody
  protected String save_discount(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    Session session = SessionUtil.getUser(req);
    try {
      double sum = Util.getDouble(req, "sum");
      String text = Util.get(req, "text");
      int id = Util.getInt(req, "id");
      CashDiscounts d = new CashDiscounts();
      d.setAmbStat("AMB");
      d.setPatient(id);
      d.setText(text);
      d.setSumm(sum);
      d.setCrBy(dUser.get(session.getUserId()));
      d.setCrOn(new Date());
      dCashDiscount.save(d);
      sMoAmb.updatePaySum(d.getPatient());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "discount/del.s", method = RequestMethod.POST)
  @ResponseBody
  protected String del_discount(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      CashDiscounts discount = dCashDiscount.get(Util.getInt(req, "id"));
      dCashDiscount.delete(discount.getId());
      sMoAmb.updatePaySum(discount.getPatient());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "pay.s", method = RequestMethod.POST)
  @ResponseBody
  protected String save_pay(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    Session session = SessionUtil.getUser(req);
    try {
      String[] ss = req.getParameterValues("ss");
      String ids = "";
      if(ss != null) {
        for(String s: ss) {
          ids += s + ",";
        }
        ids = ids.substring(0, ids.length() - 1);
      }
      int cash_del_service = Util.getInt(req, "service", 0);
      AmbPatients patient = dAmbPatient.get(Util.getInt(req, "id"));
      AmbPatientPays pay = new AmbPatientPays();
      pay.setPatient(patient.getId());
      //
      pay.setPayType(Util.get(req, "pay_type"));
      pay.setCard(Double.parseDouble(Util.get(req, "card", "0")));
      pay.setCash(Double.parseDouble(Util.get(req, "cash", "0")));
      pay.setTransfer(0D);
      if(pay.getPayType().equals("ret"))
        pay.setCash(pay.getCash() > 0 ? -1*pay.getCash() : 0D);
      //
      pay.setCrBy(session.getUserId());
      pay.setCrOn(new Date());
      dAmbPatientPay.save(pay);
      //
      if(pay.getPayType().equals("pay")) {
        if ("CASH".equals(patient.getState())) patient.setState("WORK");
        dAmbPatient.save(patient);
        List<AmbPatientServices> services = dAmbPatientService.getList("From AmbPatientServices Where state = 'ENT' And patient = " + patient.getId() + (ids.isEmpty() ? "" : " And id not in (" + ids + ")"));
        for (AmbPatientServices service : services) {
          service.setPay(pay.getId());
          service.setState("PAID");
          service.setCashDate(new Date());
          dAmbPatientService.save(service);
        }
      }
      if(cash_del_service > 0) {
        AmbPatientServices sr = dAmbPatientService.get(cash_del_service);
        sr.setState("DEL");
        sr.setPay(pay.getId());
        sr.setMsg(Util.get(req, "msg"));
        dAmbPatientService.save(sr);
      }
      sMoAmb.updatePaySum(patient.getId());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/pay/del.s", method = RequestMethod.POST)
  @ResponseBody
  protected String del_pay(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      int patient = Util.getInt(req, "patient");
      int id = Util.getInt(req, "id");
      List<AmbPatientServices> rows = dAmbPatientService.getList("From AmbPatientServices Where patient = " + patient + " And pay = " + id);
      for(AmbPatientServices r: rows) {
        if(r.getConfDate() != null || r.getState().equals("AUTO_DEL")) {
          return Util.err(json, "Нельзя удалить оплату! Существуют уже утвержденные услуги по оплате");
        }
      }
      for(AmbPatientServices row: rows) {
        if(row.getState().equals("PAID") || row.getState().equals("DEL")) {
          row.setState("ENT");
          row.setCashDate(null);
          row.setPay(null);
          row.setMsg(null);
          dAmbPatientService.save(row);
        }
      }
      dAmbPatientPay.delete(id);
      sMoAmb.updatePaySum(patient);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
      e.printStackTrace();
    }
    return json.toString();
  }

  @RequestMapping("/print/check.s")
  protected String printCheck(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    AmbPatients pat = dAmbPatient.get(session.getCurPat());
    model.addAttribute("pat", pat);
    int id = Util.getInt(req, "check");
    List<AmbPatientServices> rows = dAmbPatientService.getList("From AmbPatientServices Where state In ('PAID', 'DONE') And patient = " + pat.getId() + (id > 0 ? " And pay = " + id : ""));
    double sum = 0;
    for(AmbPatientServices row: rows) {
      sum += row.getPrice();
    }
    if(pat.getQrcode() == null || pat.getQrcode().isEmpty()) {
      pat.setQrcode(Util.md5(pat.getId().toString()));
      dAmbPatient.save(pat);
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
    return "mo/amb/cash/check";
  }


}
