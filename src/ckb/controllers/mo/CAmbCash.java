package ckb.controllers.mo;

import ckb.dao.admin.countery.DCountry;
import ckb.dao.admin.region.DRegion;
import ckb.dao.med.amb.DAmbPatient;
import ckb.dao.med.amb.DAmbPatientPays;
import ckb.dao.med.amb.DAmbPatientService;
import ckb.dao.med.cashbox.discount.DCashDiscount;
import ckb.domains.admin.Clients;
import ckb.domains.med.amb.AmbPatientServices;
import ckb.domains.med.amb.AmbPatients;
import ckb.models.AmbService;
import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping(value = "/cash/amb/")
public class CAmbCash {

  @Autowired private DAmbPatient dAmbPatient;
  @Autowired private DAmbPatientService dAmbPatientService;
  @Autowired private DCountry dCountry;
  @Autowired private DRegion dRegion;
  @Autowired private DCashDiscount dCashDiscount;
  @Autowired private DAmbPatientPays dAmbPatientPay;

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

}
