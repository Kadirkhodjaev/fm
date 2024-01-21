package ckb.controllers.med;

import ckb.dao.med.drug.actdrug.DDrugActDrug;
import ckb.dao.med.drug.out.DDrugOutRow;
import ckb.dao.med.head_nurse.date.DHNDatePatientRow;
import ckb.dao.med.head_nurse.date.DHNDateRow;
import ckb.dao.med.head_nurse.drug.DHNDrug;
import ckb.domains.med.drug.DrugActDrugs;
import ckb.domains.med.drug.DrugOutRows;
import ckb.domains.med.head_nurse.HNDatePatientRows;
import ckb.domains.med.head_nurse.HNDateRows;
import ckb.domains.med.head_nurse.HNDrugs;
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
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("dch/")
public class CDrugChecker {

  @Autowired private DHNDrug dhnDrug;
  @Autowired private DHNDateRow dhnDateRow;
  @Autowired private DHNDatePatientRow dhnDatePatientRow;

  @Autowired private DDrugActDrug dDrugInDrug;
  @Autowired private DDrugOutRow dDrugOutRow;
  
  @RequestMapping("checker.s")
  protected String checker(Model model) {
    List<DrugActDrugs> drugList = new ArrayList<DrugActDrugs>();
    List<DrugActDrugs> DrugActDrugs = dDrugInDrug.getList("From DrugActDrugs Where rasxod > 0 And rasxod != drugCount");
    for(DrugActDrugs drugInDrug: DrugActDrugs) {
      double outRasxod = dDrugOutRow.getIncomeRasxod(drugInDrug.getId());
      if(outRasxod != drugInDrug.getRasxod()) {
        drugInDrug.setPrice(outRasxod);
        drugList.add(drugInDrug);
      }
    }
    model.addAttribute("drug_rows", drugList);
    List<HNDrugs> hnList = new ArrayList<HNDrugs>();
    List<HNDrugs> hnDrugs = dhnDrug.getList("From HNDrugs Where history is null Order By direction.id");
    for(HNDrugs hnDrug: hnDrugs) {
      int hndrug = hnDrug.getId();
      BigDecimal r1 = BigDecimal.valueOf(dhnDateRow.getHDRasxod(hndrug));
      BigDecimal r2 = BigDecimal.valueOf(dhnDatePatientRow.getHDRasxod(hndrug));
      BigDecimal r3 = BigDecimal.valueOf(dhnDrug.getTransferRasxod(hndrug));
      double rasxod = Double.parseDouble(String.valueOf(r1.add(r2).add(r3)));
      if(rasxod != hnDrug.getRasxod()) {
        hnDrug.setPrice(rasxod);
        hnList.add(hnDrug);
      } else {
        if(rasxod > 0 && hnDrug.getRasxod() > 0 && hnDrug.getDrugCount() > 0) {
          if (hnDrug.getRasxod().equals(hnDrug.getDrugCount()) && rasxod == hnDrug.getDrugCount()) {
            hnDrug.setHistory(1);
            dhnDrug.save(hnDrug);
          }
          if (hnDrug.getDrugCount() < hnDrug.getRasxod()) {
            hnDrug.setPrice(rasxod);
            hnList.add(hnDrug);
          }
        }
      }
    }
    model.addAttribute("hn_rows", hnList);
    return "med/mn/drugs/drug_checker";
  }

  @RequestMapping(value = "repair.s", method = RequestMethod.POST)
  @ResponseBody
  protected String incomeRowSave(HttpServletRequest req) throws JSONException {
    Session session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      if(session == null)
        return Util.err(json, "Войдите в систему заново");
      if(session.getUserId() != 1)
        return Util.err(json, "Только администратор системы может исправить данные");
      String code = Util.get(req, "code");
      int id = Util.getInt(req, "id");
      if(code.equals("drug")) {
        DrugActDrugs d = dDrugInDrug.get(id);
        double rasxod = dDrugOutRow.getIncomeRasxod(d.getId());
        if(rasxod > d.getCounter())
          return Util.err(json, "Уже поздно реально куп ишлатворишибди");
        d.setRasxod(rasxod);
        dDrugInDrug.save(d);
      }
      if(code.equals("hn")) {
        HNDrugs d = dhnDrug.get(id);
        int hndrug = d.getId();
        BigDecimal r1 = BigDecimal.valueOf(dhnDateRow.getHDRasxod(hndrug));
        BigDecimal r2 = BigDecimal.valueOf(dhnDatePatientRow.getHDRasxod(hndrug));
        BigDecimal r3 = BigDecimal.valueOf(dhnDrug.getTransferRasxod(hndrug));
        double rasxod = Double.parseDouble(String.valueOf(r1.add(r2).add(r3)));
        if(rasxod > d.getDrugCount())
          return Util.err(json, "Уже поздно реально куп ишлатворишибди");
        d.setRasxod(rasxod);
        dhnDrug.save(d);
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("details.s")
  protected String details(HttpServletRequest req, Model model) {
    String code = Util.get(req, "code");
    int id = Util.getInt(req, "id");
    if(code.equals("drug")) {
      List<DrugOutRows> drugs = dDrugOutRow.getList("From DrugOutRows Where income.id = " + id);
      DrugActDrugs main = dDrugInDrug.get(id);
      double rasxod = dDrugOutRow.getIncomeRasxod(id);
      main.setPrice(rasxod);
      model.addAttribute("main", main);
      model.addAttribute("drugs", drugs);
    }
    if(code.equals("hn")) {
      HNDrugs main = dhnDrug.get(id);
      List<HNDateRows> dateRows = dhnDateRow.getList("From HNDateRows Where drug.id = " + id);
      List<HNDatePatientRows> datePatientRows = dhnDatePatientRow.getList("From HNDatePatientRows Where drug.id = " + id);
      List<HNDrugs> transfer = dhnDrug.getList("From HNDrugs Where transfer_hndrug_id = " + id);
      double rasxod = dhnDateRow.getHDRasxod(id);
      rasxod += dhnDatePatientRow.getHDRasxod(id);
      rasxod += dhnDrug.getTransferRasxod(id);
      main.setPrice(rasxod);
      model.addAttribute("main", main);
      model.addAttribute("dateRows", dateRows);
      model.addAttribute("datePatientRows", datePatientRows);
      model.addAttribute("transfers", transfer);
    }
    model.addAttribute("code", code);
    return "med/mn/drugs/drug_rasxod_details";
  }

  @RequestMapping(value = "delete.s", method = RequestMethod.POST)
  @ResponseBody
  protected String deleteRow(HttpServletRequest req) throws JSONException {
    Session session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      if(session == null)
        return Util.err(json, "Войдите в систему заново");
      if(session.getUserId() != 1)
        return Util.err(json, "Только администратор системы может исправить данные");
      String code = Util.get(req, "code");
      int id = Util.getInt(req, "id");
      if(code.equals("date")) dhnDateRow.delete(id);
      if(code.equals("patient")) dhnDatePatientRow.delete(id);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

}
