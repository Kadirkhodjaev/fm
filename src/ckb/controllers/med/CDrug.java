package ckb.controllers.med;

import ckb.dao.admin.depts.DDept;
import ckb.dao.med.drug.act.DDrugAct;
import ckb.dao.med.drug.actdrug.DDrugActDrug;
import ckb.dao.med.drug.dict.categories.DDrugCategory;
import ckb.dao.med.drug.dict.contracts.DDrugContract;
import ckb.dao.med.drug.dict.cupboards.DDrugCupboard;
import ckb.dao.med.drug.dict.directions.DDrugDirection;
import ckb.dao.med.drug.dict.directions.DDrugDirectionDep;
import ckb.dao.med.drug.dict.drugs.DDrug;
import ckb.dao.med.drug.dict.drugs.category.DDrugDrugCategory;
import ckb.dao.med.drug.dict.drugs.counter.DDrugCount;
import ckb.dao.med.drug.dict.manufacturer.DDrugManufacturer;
import ckb.dao.med.drug.dict.measures.DDrugMeasure;
import ckb.dao.med.drug.dict.partners.DDrugPartner;
import ckb.dao.med.drug.dict.storages.DDrugStorage;
import ckb.dao.med.drug.drugsaldo.DDrugSaldo;
import ckb.dao.med.drug.write_off.DDrugWriteOff;
import ckb.dao.med.drug.write_off.DDrugWriteOffRow;
import ckb.domains.med.drug.*;
import ckb.domains.med.drug.dict.*;
import ckb.models.Obj;
import ckb.models.ObjList;
import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.DB;
import ckb.utils.Util;
import org.codehaus.jettison.json.JSONArray;
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
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/drugs")
public class CDrug {

  @Autowired private DDrug dDrug;
  @Autowired private DDrugDrugCategory dDrugDrugCategory;
  @Autowired private DDrugCategory dDrugCategory;
  @Autowired private DDrugContract dDrugContract;
  @Autowired private DDrugCupboard dDrugCupboard;
  @Autowired private DDrugMeasure dDrugMeasure;
  @Autowired private DDrugPartner dDrugPartner;
  @Autowired private DDrugStorage dDrugStorage;
  @Autowired private DDrugDirection dDrugDirection;
  @Autowired private DDrugAct dDrugAct;
  @Autowired private DDrugActDrug dDrugActDrug;
  @Autowired private DDrugSaldo dDrugSaldo;
  @Autowired private DDrugWriteOff dDrugWriteOff;
  @Autowired private DDrugWriteOffRow dDrugWriteOffRow;
  @Autowired private DDrugCount dDrugCount;
  @Autowired private DDept dDept;
  @Autowired private DDrugDirectionDep dDrugDirectionDep;
  @Autowired private DDrugManufacturer dDrugManufacturer;

  //region INCOMES
  @RequestMapping("/acts.s")
  protected String income(HttpServletRequest request, Model model) {
    Session session = SessionUtil.getUser(request);
    session.setCurUrl("/drugs/acts.s");
    String startDate = Util.get(request, "period_start", "01" + Util.getCurDate().substring(2));
    String endDate = Util.get(request, "period_end", Util.getCurDate());
    //
    List<DrugActs> acts = dDrugAct.getList("From DrugActs Where regDate Between '" + Util.dateDBBegin(startDate) + "' And '" + Util.dateDBBegin(endDate) + "' Order By regDate Desc");
    List<ObjList> list = new ArrayList<ObjList>();
    for(DrugActs act : acts) {
      ObjList obj = new ObjList();
      obj.setIb(act.getId().toString());
      obj.setC1(act.getContract().getPartner().getName());
      obj.setC2("�" + act.getRegNum() + " �� " + Util.dateToString(act.getRegDate()));
      obj.setC3(dDrugActDrug.getCount("From DrugActDrugs Where act.id = " + act.getId()).toString());
      if(act != null && act.getId() != null) {
        Double sum = dDrugActDrug.getActSum(act.getId());
        obj.setC4("" + (sum == null ? 0 : sum));
      } else {
        obj.setC4("0");
      }
      obj.setC5(act.getState());
      obj.setC6(Util.dateTimeToString(act.getCrOn()));
      list.add(obj);
    }
    model.addAttribute("acts", list);
    model.addAttribute("period_start", startDate);
    model.addAttribute("period_end", endDate);
    return "/med/drugs/incomes/index";
  }

  @RequestMapping("/act/addEdit.s")
  protected String addEditAct(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/drugs/act/addEdit.s?id=" + Util.get(req, "id"));
    //
    DrugActs act = Util.getInt(req, "id") > 0 ? dDrugAct.get(Util.getInt(req, "id")) : new DrugActs();
    if(Util.getInt(req, "id") == 0)
      act.setRegDate(new Date());
    model.addAttribute("obj", act);
    model.addAttribute("contracts", dDrugContract.getAll());
    // Add Edit Act Drug models
    model.addAttribute("drug_names", dDrug.getList("From Drugs Where state = 'A' Order By Name"));
    model.addAttribute("measures", dDrugMeasure.getList("From DrugMeasures Where state = 'A'"));
    model.addAttribute("categories", dDrugCategory.getList("From DrugCategories Where state = 'A' Order By Name"));
    model.addAttribute("mans", dDrugManufacturer.getAll());
    // List Of Act Drugs
    model.addAttribute("drugs", dDrugActDrug.getList("From DrugActDrugs Where act.id = " + Util.getInt(req, "id") + " Order By Id Desc"));
    Util.makeMsg(req, model);
    return "/med/drugs/incomes/addEdit";
  }

  @RequestMapping(value = "/act/addEdit.s", method = RequestMethod.POST)
  @ResponseBody
  protected String addEditAct(HttpServletRequest req) throws JSONException {
    Session session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      DrugActs act = Util.isNull(req, "id") ? new DrugActs() : dDrugAct.get(Util.getInt(req, "id"));
      act.setContract(dDrugContract.get(Util.getInt(req, "contract")));
      act.setRegNum(Util.get(req, "reg_num"));
      act.setRegDate(Util.stringToDate(Util.get(req, "reg_date")));
      act.setExtraInfo(Util.get(req, "extra_info"));
      if(Util.isNull(req, "id")) {
        act.setCrBy(session.getUserId());
        act.setCrOn(new Date());
        act.setState("E");
      }
      dDrugAct.saveAndReturn(act);
      json.put("id", act.getId());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/act/action.s", method = RequestMethod.POST)
  @ResponseBody
  protected String actAction(HttpServletRequest req) throws JSONException {
    Session session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      if(Util.get(req, "code").equals("delete")) {
        dDrugActDrug.deleteByAct(Util.getInt(req, "id"));
        dDrugAct.delete(Util.getInt(req, "id"));
      } else {
        DrugActs act = dDrugAct.get(Util.getInt(req, "id"));
        act.setState("O");
        dDrugAct.save(act);
        json.put("id", act.getId());
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/act/drug/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String actDrugSave(HttpServletRequest req) throws JSONException {
    Session session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      Date endDate = Util.stringToDate(Util.get(req, "end_date"));
      boolean isErr = false;
      if(Util.isNotDouble(req, "price")) {
        isErr = true;
        json.put("msg", "���� ���� ����� �� ���������� ������");
      }
      if(Util.isNotDouble(req, "drug_count")) {
        json.put("msg", (isErr ? json.get("msg") + "\n" : "") + "���� ���-�� ����� �� ���������� ������");
        isErr = true;
      }
      if(endDate.before(new Date()) || endDate.equals(new Date())) {
        json.put("msg", (isErr ? json.get("msg") + "\n" : "") + "���� �������� �� ����� ���� ������ ������� ����");
        isErr = true;
      }
      if(Util.isNull(req, "man")) {
        json.put("msg", (isErr ? json.get("msg") + "\n" : "") + "������������� �� ����� ���� ������");
        isErr = true;
      }
      if(isErr) {
        json.put("success", false);
        return json.toString();
      }
      DrugActDrugs drug = new DrugActDrugs();
      drug.setAct(dDrugAct.get(Util.getInt(req, "act")));
      drug.setDrug(dDrug.get(Util.getInt(req, "drug")));
      drug.setManufacturer(dDrugManufacturer.get(Util.getInt(req, "man")));
      drug.setPrice(Double.parseDouble(Util.get(req, "price")));
      drug.setBlockCount(Double.parseDouble(Util.get(req, "drug_count")));
      drug.setEndDate(endDate);
      drug.setRasxod(0D);
      drug.setUnlead(0D);
      drug.setCrBy(session.getUserId());
      drug.setCrOn(new Date());
      dDrugActDrug.save(drug);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/act/drug/delete.s", method = RequestMethod.POST)
  @ResponseBody
  protected String actDrugDelete(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      dDrugActDrug.delete(Util.getInt(req, "id"));
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }
  //endregion

  //region SKLAD
  @RequestMapping("/sklad.s")
  protected String sklad(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/drugs/sklad.s");
    String startDate = Util.get(req, "period_start", "01" + Util.getCurDate().substring(2));
    String endDate = Util.get(req, "period_end", Util.getCurDate());
    //
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      conn = DB.getConnection();
      Double saldo = DB.getSum(conn, "Select Sum(price * drugCount) From Drug_Saldos");
      //
      Double income_in = DB.getSum(conn, "Select Sum(c.price * c.blockCount) From Drug_Acts t, Drug_Act_Drugs c Where t.id = c.act_id And t.regDate < '" + Util.dateDBBegin(startDate) + "'");
      Double out_in = DB.getSum(conn, "Select Sum(c.price * c.drugCount) From Drug_Write_Offs t, Drug_Write_Off_Rows c Where t.id = c.doc_id And t.regDate < '" + Util.dateDBBegin(startDate) + "'");
      //
      Double income_period = DB.getSum(conn, "Select Sum(c.price * c.blockCount) From Drug_Acts t, Drug_Act_Drugs c Where t.id = c.act_id And t.regDate Between '" + Util.dateDBBegin(startDate) + "' And '" + Util.dateDBBegin(endDate) + "' ");
      Double out_period = DB.getSum(conn, "Select Sum(c.price * c.drugCount) From Drug_Write_Offs t, Drug_Write_Off_Rows c Where t.id = c.doc_id And t.regDate Between '" + Util.dateDBBegin(startDate) + "' And '" + Util.dateDBBegin(endDate) + "'");
      //
      model.addAttribute("saldo_in", saldo + income_in - out_in);
      model.addAttribute("income_sum", income_period);
      model.addAttribute("outcome_sum", out_period);
      model.addAttribute("saldo_out", saldo + income_in - out_in + income_period - out_period);
      //
      List<ObjList> rows = new ArrayList<ObjList>();
      ps = conn.prepareStatement(
        "Select t.drug_id, t.summ, t.counter, t.price, c.name From (" +
          " Select t.drug_Id, t.price * (t.drugCount - t.rasxod) summ, t.drugCount - t.rasxod counter, t.price Price From Drug_Saldos t Where t.drugCount - t.rasxod > 0 " +
          " Union ALL " +
          " Select t.Drug_Id, t.price * (t.blockCount - t.rasxod) summ, t.blockCount - t.rasxod counter, t.price Price From drug_act_drugs t Where t.blockCount - t.rasxod > 0 " +
          " ) t, drug_s_names c " +
          " Where c.Id = t.drug_Id " +
          " Order By c.Name" );
      rs = ps.executeQuery();
      while (rs.next()) {
        ObjList obj = new ObjList();
        obj.setIb(rs.getString("drug_id"));
        obj.setC1(rs.getString("name"));
        obj.setC2(rs.getString("counter"));
        obj.setC3(rs.getString("summ"));
        obj.setC4(rs.getString("price"));
        //
        rows.add(obj);
      }
      model.addAttribute("rows", rows);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(conn);
    }
    //
    model.addAttribute("period_start", startDate);
    model.addAttribute("period_end", endDate);
    return "/med/drugs/sklad/index";
  }

  @RequestMapping("/sklad/excel.s")
  protected String skladDetails(Model model) {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      conn = DB.getConnection();
      //
      List<ObjList> rows = new ArrayList<ObjList>();
      ps = conn.prepareStatement(
        "Select t.drug_id, t.summ, t.counter, t.price, c.name From (" +
          " Select t.drug_Id, t.price * (t.count - t.rasxod) summ, t.count - t.rasxod counter, t.price Price From Drug_Saldos t Where t.count - t.rasxod > 0 " +
          " Union ALL " +
          " Select t.Drug_Id, t.price * (t.blockCount - t.rasxod) summ, t.blockCount - t.rasxod counter, t.price Price From drug_act_drugs t Where t.blockCount - t.rasxod > 0 " +
          " ) t, drug_s_names c " +
          " Where c.Id = t.drug_Id " +
          " Order By c.Name" );
      rs = ps.executeQuery();
      while (rs.next()) {
        ObjList obj = new ObjList();
        obj.setIb(rs.getString("drug_id"));
        obj.setC1(rs.getString("name"));
        obj.setC2(rs.getString("counter"));
        obj.setC3(rs.getString("summ"));
        obj.setC4(rs.getString("price"));
        //
        rows.add(obj);
      }
      model.addAttribute("header_title", "������� �� ����: " + Util.getCurDate() + " " + Util.getCurTime());
      model.addAttribute("rows", rows);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(conn);
    }
    return "/med/drugs/sklad/excel";
  }
  //endregion

  //region DETAILS
  @RequestMapping("/details.s")
  protected String details(HttpServletRequest request, Model model) {
    Session session = SessionUtil.getUser(request);
    String code = Util.get(request, "code", "all");
    session.setCurUrl("/drugs/details.s?code=" + code);
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      conn = DB.getConnection();
      List<ObjList> rows = new ArrayList<ObjList>();
      ps = conn.prepareStatement(
        "Select t.id, t.drug_id, c.name, t.in_type, t.summ, t.counter, t.price, t.rasxod From ( " +
          " Select t.id, t.drug_Id, 'saldo' in_type, t.price * t.drugCount summ, t.drugCount counter, t.price, t.rasxod From Drug_Saldos t " + (code.equals("write_off") ? " Where t.drugCount - t.rasxod = 0 " : "") + (code.equals("saldo") ? " Where t.drugCount - t.rasxod != 0 " : "") + (code.equals("rasxod") ? " Where t.rasxod > 0 " : "") +
          " Union ALL " +
          " Select t.id, t.drug_id, 'act' in_type, t.price * t.blockCount summ, t.blockCount counter, t.price, t.rasxod From drug_act_drugs t" + (code.equals("write_off") ? " Where t.drugCount - t.rasxod = 0 " : "") + (code.equals("saldo") ? " Where t.drugCount - t.rasxod != 0 " : "") + (code.equals("rasxod") ? " Where t.rasxod > 0 " : "") +
          ") t, drug_s_names c " +
          " Where c.Id = t.drug_Id " +
          " Order By c.Name");
      rs = ps.executeQuery();
      while (rs.next()) {
        ObjList obj = new ObjList();
        obj.setIb(rs.getString("id"));
        obj.setC1(rs.getString("name"));
        obj.setC2(rs.getString("in_type"));
        obj.setC3(rs.getString("price"));
        obj.setC4(rs.getString("counter"));
        obj.setC5(rs.getString("summ"));
        obj.setC6(rs.getString("rasxod"));
        //
        rows.add(obj);
      }
      model.addAttribute("page_code", code);
      model.addAttribute("rows", rows);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(conn);
    }
    //
    return "/med/drugs/details/index";
  }

  @RequestMapping(value = "/details.s", method = RequestMethod.POST)
  @ResponseBody
  protected String getDetailInfo(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    //
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      conn = DB.getConnection();
      JSONArray rows = new JSONArray();
      Double counter = 0D;
      if(Util.get(req, "type").equals("saldo")) {
        ps = conn.prepareStatement(
          "Select t.*, d.name direction_name, c.regDate, c.regNum, c.id act_id From Drug_Write_Off_Rows t, Drug_Write_Offs c, Drug_s_Directions d Where d.id = c.direction_id And c.id = t.doc_id And t.saldo_id = ? Order By c.regDate"
        );
        ps.setInt(1, Util.getInt(req, "id"));
        rs = ps.executeQuery();
        while (rs.next()) {
          JSONObject obj = new JSONObject();
          obj.put("direction_name", rs.getString("direction_name"));
          obj.put("reg_num", rs.getString("regNum"));
          obj.put("reg_date", Util.dateToString(rs.getDate("regDate")));
          obj.put("drug_count", rs.getDouble("drugCount"));
          obj.put("doc_id", rs.getInt("act_id"));
          obj.put("id", rs.getInt("id"));
          counter += rs.getDouble("drugCount");
          //
          rows.put(obj);
        }
        DrugSaldos saldo = dDrugSaldo.get(Util.getInt(req, "id"));
        json.put("name", saldo.getDrug().getName() + "(ID: " + Util.get(req, "id") + ")");
        json.put("drug_count", saldo.getDrugCount());
        json.put("rasxod", saldo.getRasxod());
        json.put("price", saldo.getPrice());
      }
      if(Util.get(req, "type").equals("act")) {
        ps = conn.prepareStatement(
          "Select t.*, d.name direction_name, c.regDate, c.regNum, c.id act_id From Drug_Write_Off_Rows t, Drug_Write_Offs c, Drug_s_Directions d Where d.id = c.direction_id And c.id = t.doc_id And t.income_id = ? Order By c.regDate"
        );
        ps.setInt(1, Util.getInt(req, "id"));
        rs = ps.executeQuery();
        while (rs.next()) {
          JSONObject obj = new JSONObject();
          obj.put("direction_name", rs.getString("direction_name"));
          obj.put("reg_num", rs.getString("regNum"));
          obj.put("reg_date", Util.dateToString(rs.getDate("regDate")));
          obj.put("drug_count", rs.getDouble("drugCount"));
          obj.put("doc_id", rs.getInt("act_id"));
          obj.put("id", rs.getInt("id"));
          counter += rs.getDouble("drugCount");
          //
          rows.put(obj);
        }
        DrugActDrugs actDrug = dDrugActDrug.get(Util.getInt(req, "id"));
        json.put("name", actDrug.getDrug().getName() + "(ID: " + Util.get(req, "id") + ")");
        json.put("drug_count", actDrug.getDrugCount());
        json.put("rasxod", actDrug.getRasxod());
        json.put("price", actDrug.getPrice());
      }
      json.put("rows", rows);
      json.put("counter", counter);
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
  //endregion

  //region SALDO
  @RequestMapping("/saldo.s")
  protected String saldo(HttpServletRequest request, Model model) {
    Session session = SessionUtil.getUser(request);
    session.setCurUrl("/drugs/saldo.s");
    model.addAttribute("list", dDrugSaldo.getList("From DrugSaldos Order By drug.name"));
    model.addAttribute("drugs", dDrug.getList("From Drugs Order By name"));
    model.addAttribute("categories", dDrugCategory.getList("From DrugCategories Where state = 'A' Order By Name"));
    //
    return "/med/drugs/saldo/index";
  }

  @RequestMapping(value = "/saldo/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String saveSaldo(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      System.out.println("DDD = " + Util.get(req, "id"));
      if(Util.isNotNull(req, "drug") && !Util.get(req, "drug").equals("") && Util.isNotNull(req, "count") && Util.isNotNull(req, "price")) {
        DrugSaldos saldo = new DrugSaldos();
        if (Util.isNotNull(req, "id"))
          saldo = dDrugSaldo.get(Util.getInt(req, "id"));
        else {
          saldo.setRasxod(0D);
          saldo.setUnlead(0D);
        }
        saldo.setDrug(dDrug.get(Util.getInt(req, "drug")));
        saldo.setDrugCount(Double.parseDouble(Util.get(req, "count")));
        saldo.setPrice(Double.parseDouble(Util.get(req, "price")));
        dDrugSaldo.save(saldo);
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/saldo/delete.s", method = RequestMethod.POST)
  @ResponseBody
  protected String deleteSaldo(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      dDrugSaldo.delete(Util.getInt(req, "id"));
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }
  //endregion

  //region DICTS
  @RequestMapping("/dicts.s")
  protected String dicsts(HttpServletRequest request, Model model) {
    Session session = SessionUtil.getUser(request);
    session.setCurUrl("/drugs/dicts.s");
    if(!session.getCurSubUrl().contains("/drugs/dict/"))
      session.setCurSubUrl("/drugs/dict/contracts.s");
    if(session.getCurSubUrl().contains("/drugs/dict/drugs.s") && Util.isNotNull(request, "cat"))
      session.setCurSubUrl("/drugs/dict/drugs.s?cat=" + Util.get(request, "cat"));
    //
    return "/med/drugs/dicts/index";
  }

  @RequestMapping(value = "/dict/delete.s", method = RequestMethod.POST)
  @ResponseBody
  protected String deleteDict(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      if(Util.get(req, "code").equals("category")) dDrugCategory.delete(Util.getInt(req, "id"));
      if(Util.get(req, "code").equals("contract")) dDrugContract.delete(Util.getInt(req, "id"));
      if(Util.get(req, "code").equals("cupboard")) dDrugCupboard.delete(Util.getInt(req, "id"));
      if(Util.get(req, "code").equals("measure")) dDrugMeasure.delete(Util.getInt(req, "id"));
      if(Util.get(req, "code").equals("partner")) dDrugPartner.delete(Util.getInt(req, "id"));
      if(Util.get(req, "code").equals("manufacturer")) dDrugManufacturer.delete(Util.getInt(req, "id"));
      if(Util.get(req, "code").equals("drug")) {
        List<DrugDrugCategories> list = dDrugDrugCategory.getList("From DrugDrugCategories Where drug.id = " + Util.getInt(req, "id"));
        for(DrugDrugCategories d: list) dDrugDrugCategory.delete(d.getId());
        List<DrugCount> lst = dDrugCount.getList("From DrugCount Where drug.id = " + Util.getInt(req, "id"));
        for(DrugCount d: lst) dDrugCount.delete(d.getId());
        dDrug.delete(Util.getInt(req, "id"));
      }
      if(Util.get(req, "code").equals("storage")) dDrugStorage.delete(Util.getInt(req, "id"));
      if(Util.get(req, "code").equals("direction")) dDrugDirection.delete(Util.getInt(req, "id"));
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/dict/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String save(HttpServletRequest req) throws JSONException {
    Session session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      if(Util.get(req, "code").equals("category")) {
        DrugCategories obj = Util.isNull(req, "id") ? new DrugCategories() : dDrugCategory.get(Util.getInt(req, "id"));
        obj.setName(Util.get(req, "name"));
        obj.setState(Util.isNull(req, "state") ? "P" : "A");
        if (Util.isNull(req, "id")) {
          obj.setCrBy(session.getUserId());
          obj.setCrOn(new Date());
        }
        dDrugCategory.save(obj);
      }
      if(Util.get(req, "code").equals("manufacturer")) {
        DrugManufacturers obj = Util.isNull(req, "id") ? new DrugManufacturers() : dDrugManufacturer.get(Util.getInt(req, "id"));
        obj.setName(Util.get(req, "name"));
        obj.setState(Util.isNull(req, "state") ? "P" : "A");
        if (Util.isNull(req, "id")) {
          obj.setCrBy(session.getUserId());
          obj.setCrOn(new Date());
        }
        dDrugManufacturer.saveAndReturn(obj);
        json.put("id", obj.getId());
        json.put("name", obj.getName());
      }
      if(Util.get(req, "code").equals("direction")) {
        DrugDirections obj = Util.isNull(req, "id") ? new DrugDirections() : dDrugDirection.get(Util.getInt(req, "id"));
        obj.setName(Util.get(req, "name"));
        obj.setState(Util.isNull(req, "state") ? "P" : "A");
        obj.setShock(Util.isNull(req, "shock") ? "N" : "Y");
        if (Util.isNull(req, "id")) {
          obj.setCrBy(session.getUserId());
          obj.setCrOn(new Date());
        }
        dDrugDirection.save(obj);

        List<DrugDirectionDeps> list = dDrugDirectionDep.getList("From DrugDirectionDeps Where direction.id = " + obj.getId());
        for(DrugDirectionDeps d: list) dDrugDirectionDep.delete(d.getId());
        String[] deps = req.getParameterValues("dep");
        if(deps != null)
          for(String dep: deps) {
            DrugDirectionDeps ct = new DrugDirectionDeps();
            ct.setDirection(obj);
            ct.setDept(dDept.get(Integer.parseInt(dep)));
            dDrugDirectionDep.save(ct);
          }
      }
      if(Util.get(req, "code").equals("contract")) {
        DrugContracts obj = Util.isNull(req, "id") ? new DrugContracts() : dDrugContract.get(Util.getInt(req, "id"));
        obj.setPartner(dDrugPartner.get(Util.getInt(req, "partner")));
        obj.setRegNum(Util.get(req, "reg_num"));
        obj.setRegDate(Util.stringToDate(Util.get(req, "reg_date")));
        obj.setStartDate(Util.isNull(req, "start_date") ? null : Util.stringToDate(Util.get(req, "start_date")));
        obj.setEndDate(Util.isNull(req, "end_date") ? null : Util.stringToDate(Util.get(req, "end_date")));
        obj.setExtraInfo(Util.get(req, "extra_info"));
        if (Util.isNull(req, "id")) {
          obj.setCrBy(session.getUserId());
          obj.setCrOn(new Date());
        }
        dDrugContract.save(obj);
      }
      if(Util.get(req, "code").equals("cupboard")) {
        DrugCupboards obj = Util.isNull(req, "id") ? new DrugCupboards() : dDrugCupboard.get(Util.getInt(req, "id"));
        obj.setName(Util.get(req, "name"));
        obj.setStorage(dDrugStorage.get(Util.getInt(req, "storage")));
        obj.setState(Util.isNull(req, "state") ? "P" : "A");
        if (Util.isNull(req, "id")) {
          obj.setCrBy(session.getUserId());
          obj.setCrOn(new Date());
        }
        dDrugCupboard.save(obj);
      }
      if(Util.get(req, "code").equals("measure")) {
        DrugMeasures obj = Util.isNull(req, "id") ? new DrugMeasures() : dDrugMeasure.get(Util.getInt(req, "id"));
        obj.setName(Util.get(req, "name"));
        obj.setState(Util.isNull(req, "state") ? "P" : "A");
        obj.setIncomeFlag(Util.isNotNull(req, "income"));
        if (Util.isNull(req, "id")) {
          obj.setCrBy(session.getUserId());
          obj.setCrOn(new Date());
        }
        dDrugMeasure.save(obj);
      }
      if(Util.get(req, "code").equals("partner")) {
        DrugPartners obj = Util.isNull(req, "id") ? new DrugPartners() : dDrugPartner.get(Util.getInt(req, "id"));
        obj.setName(Util.get(req, "name"));
        obj.setEmail(Util.get(req, "email"));
        obj.setPhone(Util.get(req, "phone"));
        if (Util.isNull(req, "id")) {
          obj.setCrBy(session.getUserId());
          obj.setCrOn(new Date());
        }
        dDrugPartner.save(obj);
      }
      if(Util.get(req, "code").equals("drug")) {
        Drugs obj = Util.isNull(req, "id") ? new Drugs() : dDrug.get(Util.getInt(req, "id"));
        obj.setName(Util.get(req, "name"));
        obj.setState(Util.isNull(req, "state") ? "P" : "A");
        if (Util.isNull(req, "id")) {
          obj.setCrBy(session.getUserId());
          obj.setCrOn(new Date());
        }
        if(Util.isNull(req, "id")) {
          if(dDrug.isNameExist(obj)) {
            json.put("success", false);
            json.put("msg", "����� �������� ��� ���������� � ���� ������");
            return json.toString();
          }
        }
        dDrug.saveAndReturn(obj);
        json.put("id", obj.getId());
        json.put("name", obj.getName());
        List<DrugDrugCategories> list = dDrugDrugCategory.getList("From DrugDrugCategories Where drug.id = " + obj.getId());
        for(DrugDrugCategories d: list) dDrugDrugCategory.delete(d.getId());
        String[] cats = req.getParameterValues("cats");
        if(cats != null)
          for(String cat: cats) {
            DrugDrugCategories ct = new DrugDrugCategories();
            ct.setDrug(obj);
            ct.setCategory(dDrugCategory.get(Integer.parseInt(cat)));
            dDrugDrugCategory.save(ct);
          }
      }
      if(Util.get(req, "code").equals("storage")) {
        DrugStorages obj = Util.isNull(req, "id") ? new DrugStorages() : dDrugStorage.get(Util.getInt(req, "id"));
        obj.setName(Util.get(req, "name"));
        obj.setState(Util.isNull(req, "state") ? "P" : "A");
        if (Util.isNull(req, "id")) {
          obj.setCrBy(session.getUserId());
          obj.setCrOn(new Date());
        }
        dDrugStorage.save(obj);
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/dict/get.s", method = RequestMethod.POST)
  @ResponseBody
  protected String getDict(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      if(Util.get(req, "code").equals("category")) {
        DrugCategories obj = dDrugCategory.get(Util.getInt(req, "id"));
        json.put("id", obj.getId());
        json.put("name", obj.getName());
        json.put("state", obj.getState());
      }
      if(Util.get(req, "code").equals("manufacturer")) {
        DrugManufacturers obj = dDrugManufacturer.get(Util.getInt(req, "id"));
        json.put("id", obj.getId());
        json.put("name", obj.getName());
        json.put("state", obj.getState());
      }
      if(Util.get(req, "code").equals("direction")) {
        DrugDirections obj = dDrugDirection.get(Util.getInt(req, "id"));
        json.put("id", obj.getId());
        json.put("name", obj.getName());
        json.put("state", obj.getState());
        json.put("shock", obj.getShock());
        JSONArray arr = new JSONArray();
        for(DrugDirectionDeps d: dDrugDirectionDep.getList("From DrugDirectionDeps Where direction.id = " + obj.getId()))
          arr.put(d.getDept().getId());
        json.put("deps", arr);
      }
      if(Util.get(req, "code").equals("contract")) {
        DrugContracts obj = dDrugContract.get(Util.getInt(req, "id"));
        json.put("id", obj.getId());
        json.put("partner", obj.getPartner().getId());
        json.put("reg_num", obj.getRegNum());
        json.put("reg_date", Util.dateToString(obj.getRegDate()));
        json.put("start_date", Util.dateToString(obj.getStartDate()));
        json.put("end_date", Util.dateToString(obj.getEndDate()));
        json.put("extra_info", obj.getExtraInfo());
      }
      if(Util.get(req, "code").equals("cupboard")) {
        DrugCupboards obj = dDrugCupboard.get(Util.getInt(req, "id"));
        json.put("id", obj.getId());
        json.put("storage", obj.getStorage().getId());
        json.put("name", obj.getName());
        json.put("state", obj.getState());
      }
      if(Util.get(req, "code").equals("measure")) {
        DrugMeasures obj = dDrugMeasure.get(Util.getInt(req, "id"));
        json.put("id", obj.getId());
        json.put("name", obj.getName());
        json.put("state", obj.getState());
        json.put("income", obj.isIncomeFlag());
      }
      if(Util.get(req, "code").equals("partner")) {
        DrugPartners obj = dDrugPartner.get(Util.getInt(req, "id"));
        json.put("id", obj.getId());
        json.put("name", obj.getName());
        json.put("phone", obj.getPhone());
        json.put("email", obj.getEmail());
      }
      if(Util.get(req, "code").equals("drug")) {
        Drugs obj = dDrug.get(Util.getInt(req, "id"));
        json.put("id", obj.getId());
        json.put("name", obj.getName());
        json.put("state", obj.getState());
        JSONArray arr = new JSONArray();
        for(DrugDrugCategories d: dDrugDrugCategory.getList("From DrugDrugCategories Where drug.id = " + obj.getId()))
          arr.put(d.getCategory().getId());
        json.put("cats", arr);
      }
      if(Util.get(req, "code").equals("storage")) {
        DrugStorages obj = dDrugStorage.get(Util.getInt(req, "id"));
        json.put("id", obj.getId());
        json.put("name", obj.getName());
        json.put("state", obj.getState());
      }
      if(Util.get(req, "code").equals("saldo")) {
        DrugSaldos obj = dDrugSaldo.get(Util.getInt(req, "id"));
        json.put("id", obj.getId());
        json.put("drug", obj.getDrug().getId());
        json.put("count", obj.getDrugCount());
        json.put("price", obj.getPrice());
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("/dict/categories.s")
  protected String dicstCategories(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    session.setCurUrl("/drugs/dicts.s");
    session.setCurSubUrl("/drugs/dict/categories.s");
    //
    model.addAttribute("list", dDrugCategory.getAll());
    Util.makeMsg(request, model);
    return "/med/drugs/dicts/categories/index";
  }

  @RequestMapping("/dict/manufacturers.s")
  protected String dictManufacturers(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    session.setCurUrl("/drugs/dicts.s");
    session.setCurSubUrl("/drugs/dict/manufacturers.s");
    //
    model.addAttribute("list", dDrugManufacturer.getAll());
    Util.makeMsg(request, model);
    return "/med/drugs/dicts/manufacturers/index";
  }

  @RequestMapping("/dict/directions.s")
  protected String dictDirections(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    session.setCurUrl("/drugs/dicts.s");
    session.setCurSubUrl("/drugs/dict/directions.s");
    //
    model.addAttribute("list", dDrugDirection.getAll());
    model.addAttribute("deps", dDept.getAll());
    Util.makeMsg(request, model);
    return "/med/drugs/dicts/directions/index";
  }

  @RequestMapping("/dict/contracts.s")
  protected String dicstContracts(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    session.setCurUrl("/drugs/dicts.s");
    session.setCurSubUrl("/drugs/dict/contracts.s");
    //
    model.addAttribute("list", dDrugContract.getAll());
    model.addAttribute("partners", dDrugPartner.getAll());
    Util.makeMsg(request, model);
    return "/med/drugs/dicts/contracts/index";
  }

  @RequestMapping("/dict/cupboards.s")
  protected String dicstCubboards(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    session.setCurUrl("/drugs/dicts.s");
    session.setCurSubUrl("/drugs/dict/cupboards.s");
    //
    model.addAttribute("list", dDrugCupboard.getAll());
    model.addAttribute("storages", dDrugStorage.getList("From DrugStorages Order By Id Desc"));
    Util.makeMsg(request, model);
    return "/med/drugs/dicts/cupboards/index";
  }

  @RequestMapping("/dict/measures.s")
  protected String dicstMeasures(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    session.setCurUrl("/drugs/dicts.s");
    session.setCurSubUrl("/drugs/dict/measures.s");
    //
    model.addAttribute("list", dDrugMeasure.getAll());
    Util.makeMsg(request, model);
    return "/med/drugs/dicts/measures/index";
  }

  @RequestMapping("/dict/partners.s")
  protected String dicstPartners(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    session.setCurUrl("/drugs/dicts.s");
    session.setCurSubUrl("/drugs/dict/partners.s");
    //
    model.addAttribute("list", dDrugPartner.getAll());
    Util.makeMsg(request, model);
    return "/med/drugs/dicts/partners/index";
  }

  @RequestMapping("/dict/drugs.s")
  protected String dicstDrugs(HttpServletRequest request, Model model) {
    Session session = SessionUtil.getUser(request);
    session.setCurUrl("/drugs/dicts.s");
    String ct = Util.get(request, "cat");
    session.setCurSubUrl("/drugs/dict/drugs.s" + (Util.isNotNull(request, "cat") ? "?cat=" + ct : ""));
    //
    List<ObjList> list = new ArrayList<ObjList>();
    List<Drugs> drugs = dDrug.getList("From Drugs Order By Name");
    for(Drugs drug: drugs) {
      ObjList obj = new ObjList();
      obj.setC1(drug.getId().toString());
      obj.setC2(drug.getName());
      List<DrugDrugCategories> cats = dDrugDrugCategory.getList("From DrugDrugCategories Where drug.id = " + drug.getId());
      int i=0;
      String ids = "";
      for(DrugDrugCategories cat: cats) {
        obj.setC3((i == 0 ? "" : obj.getC3() + " + ") + cat.getCategory().getName());
        ids += cat.getCategory().getId() + ",";
        i++;
      }
      obj.setC4(drug.getState());
      if(ct == null || ct.equals("0")) {
        list.add(obj);
      } else {
        if(ids.contains(ct + ","))
          list.add(obj);
      }
    }
    model.addAttribute("list", list);
    model.addAttribute("ct", ct == null ? 0 : Integer.parseInt(ct));
    model.addAttribute("categories", dDrugCategory.getList("From DrugCategories Order By Id Desc"));
    model.addAttribute("measures", dDrugMeasure.getList("From DrugMeasures Order By Id Desc"));
    return "/med/drugs/dicts/drugs/index";
  }

  @RequestMapping("/dict/storages.s")
  protected String dicstStorages(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    session.setCurUrl("/drugs/dicts.s");
    session.setCurSubUrl("/drugs/dict/storages.s");
    //
    model.addAttribute("list", dDrugStorage.getAll());
    Util.makeMsg(request, model);
    return "/med/drugs/dicts/storages/index";
  }

  @RequestMapping("/dict/drug/incomes.s")
  protected String dictDrugIncome(HttpServletRequest req, Model model) {
    model.addAttribute("rows", dDrugActDrug.getList("From DrugActDrugs Where drug.id = " + Util.getInt(req, "id")));
    return "/med/drugs/dicts/drugs/incomes";
  }
  //endregion

  //region OUTS
  @RequestMapping("/write-off.s")
  protected String writeOff(HttpServletRequest request, Model model) {
    Session session = SessionUtil.getUser(request);
    session.setCurUrl("/drugs/write-off.s");
    String startDate = Util.get(request, "period_start", "01" + Util.getCurDate().substring(2));
    String endDate = Util.get(request, "period_end", Util.getCurDate());
    //
    List<DrugWriteOffs> acts = dDrugWriteOff.getList("From DrugWriteOffs Where (state in ('SND', 'CON') Or state = null) And regDate Between '" + Util.dateDBBegin(startDate) + "' And '" + Util.dateDBBegin(endDate) + "' Order By regDate Desc, id desc");
    List<ObjList> list = new ArrayList<ObjList>();
    //
    for(DrugWriteOffs act : acts) {
      ObjList obj = new ObjList();
      obj.setIb(act.getId().toString());
      obj.setC1("�" + act.getRegNum() + " �� " + Util.dateToString(act.getRegDate()));
      obj.setC2(dDrugActDrug.getCount("From DrugWriteOffRows Where doc.id = " + act.getId()).toString());
      if(act != null && act.getId() != null) {
        Double sum = dDrugWriteOffRow.getActSum(act.getId());
        obj.setC3("" + (sum == null ? 0 : sum));
      } else {
        obj.setC3("0");
      }
      obj.setC5(act.getState() == null ? "CON" : act.getState());
      if(act.getDirection() != null)
        obj.setC6(act.getDirection().getName());
      else
        obj.setC6("");
      obj.setC7(Util.dateTimeToString(act.getCrOn()));
      obj.setC8(Util.dateTimeToString(act.getSendOn()));
      obj.setC9(Util.dateTimeToString(act.getConfirmOn()));
      list.add(obj);
    }
    //
    model.addAttribute("list", list);
    model.addAttribute("period_start", startDate);
    model.addAttribute("period_end", endDate);
    return "/med/drugs/write-off/index";
  }

  @RequestMapping("/write-off/save.s")
  protected String writeOffSave(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/drugs/write-off/save.s?id=" + Util.getInt(req, "id"));
    //
    DrugWriteOffs obj = Util.getInt(req, "id") > 0 ? dDrugWriteOff.get(Util.getInt(req, "id")) : new DrugWriteOffs();
    if(Util.getInt(req, "id") == 0) obj.setId(0);
    List<DrugWriteOffRows> rr = dDrugWriteOffRow.getList("From DrugWriteOffRows t Where t.doc.id = " + obj.getId());
    List<Obj> list = new ArrayList<Obj>();
    for(DrugWriteOffRows r: rr) {
      Obj b = new Obj();
      b.setId(r.getId());
      if(r.getDrug() == null) {
        if (r.getChildType().equals("income"))
          r.setDrug(r.getIncome().getDrug());
        else
          r.setDrug(r.getSaldo().getDrug());
      }
      b.setName(r.getDrug().getName());
      b.setClaimCount(r.getClaimCount());
      b.setDrugCount(r.getDrugCount());
      b.setPrice(r.getPrice());
      List<DrugSaldos> saldo = dDrugSaldo.getList("From DrugSaldos Where drugCount - rasxod > 0 And drug.id = " + r.getDrug().getId());
      List<DrugActDrugs> act = dDrugActDrug.getList("From DrugActDrugs Where blockCount - rasxod > 0 And drug.id = " + r.getDrug().getId());
      List<ObjList> variuos = new ArrayList<ObjList>();
      if(saldo.size() > 0)
        for(DrugSaldos s: saldo) {
          ObjList o = new ObjList();
          o.setC1(s.getId().toString());
          o.setC2((s.getDrugCount() - s.getRasxod()) + "");
          o.setC3(s.getPrice().toString());
          o.setC4("saldo");
          variuos.add(o);
        }
      if(act.size() > 0)
        for(DrugActDrugs a: act) {
          ObjList o = new ObjList();
          o.setC1(a.getId().toString());
          o.setC2((a.getBlockCount() - a.getRasxod()) + "");
          o.setC3(a.getPrice().toString());
          o.setC4("income");
          variuos.add(o);
        }
      b.setList(variuos);
      list.add(b);
    }
    model.addAttribute("rows", list);
    //
    model.addAttribute("obj", obj);
    model.addAttribute("measures", dDrugMeasure.getList("From DrugMeasures Where incomeFlag = 1"));
    model.addAttribute("drugs", dDrug.getList("From Drugs Order By name"));
    Util.makeMsg(req, model);
    return "/med/drugs/write-off/addEdit";
  }

  @RequestMapping(value = "/write-off/row/clear.s", method = RequestMethod.POST)
  @ResponseBody
  protected String writeOffDel(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      DrugWriteOffRows row = dDrugWriteOffRow.get(Util.getInt(req, "id"));
      if (row.getChildType().equals("income")) {
        DrugActDrugs income = row.getIncome();
        income.setRasxod(income.getRasxod() - row.getDrugCount());
        dDrugActDrug.save(income);
      } else if(row.getChildType().equals("saldo")) {
        DrugSaldos saldo = row.getSaldo();
        saldo.setRasxod(saldo.getRasxod() - row.getDrugCount());
        dDrugSaldo.save(saldo);
      }
      row.setSaldo(null);
      row.setIncome(null);
      row.setChildType(null);
      row.setDrugCount(null);
      dDrugWriteOffRow.save(row);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/write-off/row/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String writeOffRowSave(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      String[] row_ids = req.getParameterValues("row_id");
      String[] child_types = req.getParameterValues("child_type");
      String[] drug_ids = req.getParameterValues("drug_id");
      String[] drug_counts = req.getParameterValues("drug_count");
      for(int i=0;i<row_ids.length;i++) {
        DrugWriteOffRows row = dDrugWriteOffRow.get(Integer.parseInt(row_ids[i]));
        row.setDrugCount(Double.parseDouble(drug_counts[i]));
        if(child_types[i].equals("income")) {
          DrugActDrugs income = dDrugActDrug.get(Integer.parseInt(drug_ids[i]));
          if(row.getDrugCount() > income.getBlockCount() - income.getRasxod()) {
            json.put("success", false);
            json.put("msg", "���-�� �������� �� ����� ���� ������ �������. ��������: " + row.getDrug().getName() + " �������: " + (income.getBlockCount() - income.getRasxod()) + " ��������: " + row.getDrugCount());
            return json.toString();
          }
          income.setRasxod(income.getRasxod() + row.getDrugCount());
          dDrugActDrug.save(income);
          row.setPrice(income.getPrice());
          row.setIncome(income);
        } else if(child_types[i].equals("saldo")) {
          DrugSaldos saldo = dDrugSaldo.get(Integer.parseInt(drug_ids[i]));
          if(row.getDrugCount() > saldo.getDrugCount() - saldo.getRasxod()) {
            json.put("success", false);
            json.put("msg", "���-�� �������� �� ����� ���� ������ �������. ��������: " + row.getDrug().getName() + " �������: " + (saldo.getDrugCount() - saldo.getRasxod()) + " ��������: " + row.getDrugCount());
            return json.toString();
          }
          if(child_types[i].equals("no"))
            row.setDrugCount(0D);
          saldo.setRasxod(saldo.getRasxod() + row.getDrugCount());
          dDrugSaldo.save(saldo);
          row.setPrice(saldo.getPrice());
          row.setSaldo(saldo);
        }
        row.setChildType(child_types[i]);
        dDrugWriteOffRow.save(row);
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/write-off/row/copy.s", method = RequestMethod.POST)
  @ResponseBody
  protected String writeOffRowCopy(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      DrugWriteOffRows fact = dDrugWriteOffRow.get(Util.getInt(req, "id"));
      Double rc = Double.parseDouble(Util.get(req, "drug_count", "0"));
      if(fact.getClaimCount() <= rc || rc <= 0) {
        json.put("msg", "���-�� ��� ���������� �� ������������� �����������");
        json.put("success", false);
      }
      fact.setClaimCount(fact.getClaimCount() - rc);
      dDrugWriteOffRow.save(fact);
      fact.setId(null);
      fact.setClaimCount(rc);
      fact.setSaldo(null);
      fact.setIncome(null);
      fact.setChildType(null);
      fact.setDrugCount(null);
      dDrugWriteOffRow.save(fact);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/write-off/row/del.s", method = RequestMethod.POST)
  @ResponseBody
  protected String writeOffRowDel(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      dDrugWriteOffRow.delete(Util.getInt(req, "id"));
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/write-off/confirm.s", method = RequestMethod.POST)
  @ResponseBody
  protected String writeOffConfirm(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      DrugWriteOffs row = dDrugWriteOff.get(Util.getInt(req, "id"));
      List<DrugWriteOffRows> rows = dDrugWriteOffRow.getList("From DrugWriteOffRows Where doc.id = " + row.getId());
      for(DrugWriteOffRows rw: rows) {
        if(rw.getDrugCount() == null) {
          json.put("success", false);
          json.put("msg", "�� ��� ������ ����������");
          return json.toString();
        }
      }
      row.setConfirmOn(new Date());
      row.setState("CON");
      dDrugWriteOff.save(row);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }
  //endregion
}