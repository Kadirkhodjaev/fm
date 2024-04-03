package ckb.controllers.med;

import ckb.dao.admin.depts.DDept;
import ckb.dao.admin.params.DParam;
import ckb.dao.admin.users.DUserDrugLine;
import ckb.dao.med.drug.act.DDrugAct;
import ckb.dao.med.drug.actdrug.DDrugActDrug;
import ckb.dao.med.drug.dict.categories.DDrugCategory;
import ckb.dao.med.drug.dict.contracts.DDrugContract;
import ckb.dao.med.drug.dict.directions.DDrugDirection;
import ckb.dao.med.drug.dict.directions.DDrugDirectionDep;
import ckb.dao.med.drug.dict.drugs.DDrug;
import ckb.dao.med.drug.dict.drugs.category.DDrugDrugCategory;
import ckb.dao.med.drug.dict.drugs.counter.DDrugCount;
import ckb.dao.med.drug.dict.manufacturer.DDrugManufacturer;
import ckb.dao.med.drug.dict.measures.DDrugMeasure;
import ckb.dao.med.drug.dict.partners.DDrugPartner;
import ckb.dao.med.drug.drugsaldo.DDrugSaldo;
import ckb.dao.med.drug.out.DDrugOut;
import ckb.dao.med.drug.out.DDrugOutRow;
import ckb.dao.med.head_nurse.direction.DHNDirection;
import ckb.dao.med.head_nurse.direction.DHNDirectionLink;
import ckb.domains.admin.UserDrugLines;
import ckb.domains.med.drug.*;
import ckb.domains.med.drug.dict.*;
import ckb.domains.med.head_nurse.HNDirectionLinks;
import ckb.domains.med.head_nurse.HNDirections;
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
  @Autowired private DDrugMeasure dDrugMeasure;
  @Autowired private DDrugPartner dDrugPartner;
  @Autowired private DDrugDirection dDrugDirection;
  @Autowired private DDrugAct dDrugAct;
  @Autowired private DDrugActDrug dDrugActDrug;
  @Autowired private DDrugSaldo dDrugSaldo;
  @Autowired private DDrugOut dDrugOut;
  @Autowired private DDrugOutRow dDrugOutRow;
  @Autowired private DDrugCount dDrugCount;
  @Autowired private DDept dDept;
  @Autowired private DDrugDirectionDep dDrugDirectionDep;
  @Autowired private DDrugManufacturer dDrugManufacturer;
  @Autowired private DHNDirection dhnDirection;
  @Autowired private DHNDirectionLink dhnDirectionLink;
  @Autowired private DUserDrugLine dUserDrugLine;
  @Autowired private DParam dParam;

  //region INCOMES
  @RequestMapping("/acts.s")
  protected String income(HttpServletRequest request, Model model) {
    Session session = SessionUtil.getUser(request);
    session.setCurUrl("/drugs/acts.s");
    String startDate = Util.get(request, "period_start", "01" + Util.getCurDate().substring(2));
    String endDate = Util.get(request, "period_end", Util.getCurDate());
    String partner = Util.get(request, "partner");
    //
    List<DrugActs> acts = dDrugAct.getList("From DrugActs Where date(regDate) Between '" + Util.dateDBBegin(startDate) + "' And '" + Util.dateDBBegin(endDate) + "' " + (partner != null && !partner.isEmpty() ? " And contract.partner.id = " + partner : "") + " Order By regDate Desc");
    List<ObjList> list = new ArrayList<ObjList>();
    for(DrugActs act : acts) {
      ObjList obj = new ObjList();
      obj.setIb(act.getId().toString());
      obj.setC1(act.getContract().getPartner().getName());
      obj.setC2("№" + act.getRegNum() + " от " + Util.dateToString(act.getRegDate()));
      obj.setC3(dDrugActDrug.getCount("From DrugActDrugs Where act.id = " + act.getId()).toString());
      if(act.getId() != null) {
        Double sum = dDrugActDrug.getActSum(act.getId());
        obj.setC4("" + (sum == null ? 0 : sum));
      } else {
        obj.setC4("0");
      }
      obj.setC5(act.getState());
      obj.setC6(Util.dateTimeToString(act.getCrOn()));
      list.add(obj);
    }
    model.addAttribute("partners", dDrugPartner.getList("From DrugPartners Order By name"));
    model.addAttribute("acts", list);
    model.addAttribute("period_start", startDate);
    model.addAttribute("period_end", endDate);
    model.addAttribute("partner", partner);
    return "/med/drugs/incomes/index";
  }

  @RequestMapping("/act/addEdit.s")
  protected String addEditAct(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/drugs/act/addEdit.s?id=" + Util.get(req, "id"));
    Double ndsProc = Double.parseDouble(dParam.byCode("NDS_PROC"));
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
    model.addAttribute("drug_total_sum", dDrugActDrug.getActSum(Util.getInt(req, "id")));
    model.addAttribute("ndsProc", ndsProc);
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
      Double ndsProc = Double.parseDouble(dParam.byCode("NDS_PROC"));
      Date endDate = Util.stringToDate(Util.get(req, "end_date"));
      boolean isErr = false;
      if(Util.isNotDouble(req, "price")) {
        isErr = true;
        json.put("msg", "Поля цена имеет не правильный формат");
      }
      if(Util.isNotDouble(req, "block_count")) {
        json.put("msg", (isErr ? json.get("msg") + "\n" : "") + "Поле кол-во имеет не правильный формат");
        isErr = true;
      }
      if(Util.isNotDouble(req, "one_price")) {
        json.put("msg", (isErr ? json.get("msg") + "\n" : "") + "Поле Цена за единицу имеет не правильный формат");
        isErr = true;
      }
      if(Util.isNull(req, "counter") || Util.isNotDouble(req, "counter")) {
        json.put("msg", (isErr ? json.get("msg") + "\n" : "") + "Поле Кол-во единиц имеет не правильный формат");
        isErr = true;
      }
      if(endDate.before(new Date()) || endDate.equals(new Date())) {
        json.put("msg", (isErr ? json.get("msg") + "\n" : "") + "Срок годность не может быть меньше текущей даты");
        isErr = true;
      }
      if(Util.isNull(req, "man")) {
        json.put("msg", (isErr ? json.get("msg") + "\n" : "") + "Производитель не может быть пустым");
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
      drug.setPrice(Util.getDouble(req, "price"));
      drug.setNdsProc(ndsProc);
      drug.setBlockCount(Util.getDouble(req, "block_count"));
      drug.setCounter(Util.getDouble(req, "counter"));
      drug.setMeasure(drug.getDrug().getMeasure());
      drug.setCountPrice(Util.getDouble(req, "one_price"));
      drug.setNds(Util.getDouble(req, "nds"));
      drug.setEndDate(endDate);
      drug.setRasxod(0D);
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

  @RequestMapping(value = "/act/drug/update.s", method = RequestMethod.POST)
  @ResponseBody
  protected String actDrugUpdate(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      DrugActDrugs drug = dDrugActDrug.get(Util.getInt(req, "id"));
      drug.setPrice(Util.getDouble(req, "price_block"));
      drug.setBlockCount(Util.getDouble(req, "count_block"));
      drug.setCountPrice(Util.getDouble(req, "price_drug"));
      drug.setCounter(Util.getDouble(req, "count_drug"));
      dDrugActDrug.save(drug);
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
      //
      Double income_in = DB.getSum(conn, "Select Sum(c.countprice * c.counter) From Drug_Acts t, Drug_Act_Drugs c Where t.id = c.act_id And t.regDate < '" + Util.dateDBBegin(startDate) + "'");
      Double out_in = DB.getSum(conn, "Select Sum(c.price * c.drugCount) From Drug_Outs t, Drug_Out_Rows c Where t.id = c.doc_id And t.regDate < '" + Util.dateDBBegin(startDate) + "'");
      //
      Double income_period = DB.getSum(conn, "Select Sum(c.countprice * c.counter) From Drug_Acts t, Drug_Act_Drugs c Where t.id = c.act_id And t.regDate Between '" + Util.dateDBBegin(startDate) + "' And '" + Util.dateDBBegin(endDate) + "' ");
      Double out_period = DB.getSum(conn, "Select Sum(c.price * c.drugCount) From Drug_Outs t, Drug_Out_Rows c Where t.id = c.doc_id And t.regDate Between '" + Util.dateDBBegin(startDate) + "' And '" + Util.dateDBBegin(endDate) + "'");
      //
      model.addAttribute("saldo_in", income_in - out_in);
      model.addAttribute("income_sum", income_period);
      model.addAttribute("outcome_sum", out_period);
      model.addAttribute("saldo_out", income_in - out_in + income_period - out_period);
      //
      List<ObjList> rows = new ArrayList<ObjList>();
      ps = conn.prepareStatement(
          " Select t.Drug_Id, " +
            "      c.name, " +
          "        t.countPrice * (t.counter - t.rasxod) summ, " +
          "        t.counter - t.rasxod counter, " +
          "        t.countprice Price " +
          "   From drug_act_drugs t, drug_s_names c " +
          "  Where t.counter - t.rasxod > 0" +
          "    And t.drug_id = c.id " +
          "  Order By c.Name");
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
          " Select t.Drug_Id, t.countprice * (t.counter - t.rasxod) summ, t.counter - t.rasxod counter, t.countprice Price From drug_act_drugs t Where t.counter - t.rasxod > 0 " +
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
      model.addAttribute("header_title", "Остаток на дату: " + Util.getCurDate() + " " + Util.getCurTime());
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
        " Select t.id, " +
          "          c.name, " +
          "          t.drug_id, " +
          "          t.countprice * t.counter summ, " +
          "          t.counter, " +
          "          t.price, " +
          "          t.rasxod " +
          "     From drug_act_drugs t, drug_s_names c Where c.id = t.drug_id " + (code.equals("out") ? "  " : "") + (code.equals("saldo") ? " And t.counter - t.rasxod != 0 " : "") + (code.equals("rasxod") ? " And t.rasxod > 0 " : "") +
          "  Order By c.Name");
      rs = ps.executeQuery();
      while (rs.next()) {
        ObjList obj = new ObjList();
        obj.setIb(rs.getString("id"));
        obj.setC1(rs.getString("name"));
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
      ps = conn.prepareStatement(
        "Select t.*, " +
          "         d.name direction_name, " +
          "         c.regDate, " +
          "         c.regNum, " +
          "         c.id act_id " +
          "    From Drug_Out_Rows t, Drug_Outs c, Drug_s_Directions d " +
          "   Where d.id = c.direction_id " +
          "     And c.id = t.doc_id " +
          "     And t.income_id = ? " +
          "   Order By c.regDate"
      );
      ps.setInt(1, Util.getInt(req, "id"));
      rs = ps.executeQuery();
      while (rs.next()) {
        JSONObject obj = new JSONObject();
        obj.put("direction_name", rs.getString("direction_name"));
        obj.put("reg_num", rs.getString("regNum"));
        obj.put("reg_date", Util.dateToString(rs.getDate("regDate")));
        obj.put("counter", rs.getDouble("drugCount"));
        obj.put("doc_id", rs.getInt("act_id"));
        obj.put("id", rs.getInt("id"));
        counter += rs.getDouble("drugCount");
        //
        rows.put(obj);
      }
      DrugActDrugs actDrug = dDrugActDrug.get(Util.getInt(req, "id"));
      json.put("name", actDrug.getDrug().getName() + "(ID: " + Util.get(req, "id") + ")");
      json.put("drug_count", counter);
      json.put("rasxod", actDrug.getRasxod());
      json.put("price", actDrug.getCountPrice());
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
      if(Util.isNotNull(req, "drug") && !Util.get(req, "drug").equals("") && Util.isNotNull(req, "count") && Util.isNotNull(req, "price")) {
        DrugSaldos saldo = new DrugSaldos();
        if (Util.isNotNull(req, "id"))
          saldo = dDrugSaldo.get(Util.getInt(req, "id"));
        else {
          saldo.setRasxod(0D);
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
      if(Util.get(req, "code").equals("direction")) dDrugDirection.delete(Util.getInt(req, "id"));
      if(Util.get(req, "code").equals("rasxodtype")) dhnDirection.delete(Util.getInt(req, "id"));
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
        obj.setTransfer(Util.isNull(req, "transfer") ? "N" : "Y");
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
        obj.setCounter(Util.getDouble(req, "counter"));
        obj.setMeasure(dDrugMeasure.get(Util.getInt(req, "measure")));
        obj.setState(Util.isNull(req, "state") ? "P" : "A");
        if (Util.isNull(req, "id")) {
          obj.setCrBy(session.getUserId());
          obj.setCrOn(new Date());
        }
        if(Util.isNull(req, "id")) {
          if(dDrug.isNameExist(obj)) {
            json.put("success", false);
            json.put("msg", "Такое название уже существует в Базе данных");
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
      if(Util.get(req, "code").equals("rasxodtype")) {
        HNDirections obj = Util.isNull(req, "id") ? new HNDirections() : dhnDirection.get(Util.getInt(req, "id"));
        obj.setName(Util.get(req, "name"));
        obj.setState(Util.isNull(req, "state") ? "P" : "A");
        if (Util.isNull(req, "id")) {
          obj.setCrBy(session.getUserId());
          obj.setCrOn(new Date());
        }
        dhnDirection.save(obj);
        List<HNDirectionLinks> links = dhnDirectionLink.getList("From HNDirectionLinks Where rasxod = " + obj.getId());
        for(HNDirectionLinks link: links) {
          dhnDirectionLink.delete(link.getId());
        }
        List<DrugDirections> directions = dDrugDirection.getList("From DrugDirections Order By id");
        for(DrugDirections d: directions) {
          if(Util.isNotNull(req, "direction_" + d.getId())) {
            HNDirectionLinks f = new HNDirectionLinks();
            f.setRasxod(obj.getId());
            f.setDirection(d.getId());
            dhnDirectionLink.save(f);
          }
        }
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
        json.put("transfer", obj.getTransfer());
        JSONArray arr = new JSONArray();
        for(DrugDirectionDeps d: dDrugDirectionDep.getList("From DrugDirectionDeps Where direction.id = " + obj.getId()))
          arr.put(d.getDept().getId());
        json.put("deps", arr);
        StringBuilder users = new StringBuilder();
        for(UserDrugLines user: dUserDrugLine.getList("From UserDrugLines Where user.id != 1 And direction.id = " + obj.getId()))
          users.append(user.getUser().getFio()).append("; ");
        json.put("users", users.toString());
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
        json.put("counter", obj.getCounter());
        json.put("measure", obj.getMeasure() != null ? obj.getMeasure().getId() : 0);
        json.put("state", obj.getState());
        JSONArray arr = new JSONArray();
        for(DrugDrugCategories d: dDrugDrugCategory.getList("From DrugDrugCategories Where drug.id = " + obj.getId()))
          arr.put(d.getCategory().getId());
        json.put("cats", arr);
      }
      if(Util.get(req, "code").equals("saldo")) {
        DrugSaldos obj = dDrugSaldo.get(Util.getInt(req, "id"));
        json.put("id", obj.getId());
        json.put("drug", obj.getDrug().getId());
        json.put("count", obj.getDrugCount());
        json.put("price", obj.getPrice());
      }
      if(Util.get(req, "code").equals("rasxodtype")) {
        HNDirections obj = dhnDirection.get(Util.getInt(req, "id"));
        json.put("id", obj.getId());
        json.put("name", obj.getName());
        json.put("state", obj.getState().equals("A"));
        List<HNDirectionLinks> links = dhnDirectionLink.getList("From HNDirectionLinks Where rasxod = " + obj.getId());
        for(HNDirectionLinks d: links) {
          json.put("direction_" + d.getDirection(), true);
        }
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("dict/rasxodtypes.s")
  protected String dicstDirection(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    session.setCurSubUrl("/drugs/dict/rasxodtypes.s");
    //
    model.addAttribute("list", dhnDirection.getAll());
    model.addAttribute("rows", dDrugDirection.getList("From DrugDirections Order By id"));
    return "/med/drugs/dicts/rasxodtypes/index";
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
    String ct = Util.get(request, "cat", "A");
    session.setCurSubUrl("/drugs/dict/drugs.s?cat=" + ct);
    model.addAttribute("drugs", dDrug.getList("From Drugs Where state= '" + ct + "' Order By Name"));
    model.addAttribute("ct", ct);
    model.addAttribute("categories", dDrugCategory.getList("From DrugCategories Order By Id Desc"));
    model.addAttribute("measures", dDrugMeasure.getList("From DrugMeasures Order By Id Desc"));
    return "/med/drugs/dicts/drugs/index";
  }

  @RequestMapping("/dict/drug/incomes.s")
  protected String dictDrugIncome(HttpServletRequest req, Model model) {
    model.addAttribute("rows", dDrugActDrug.getList("From DrugActDrugs Where drug.id = " + Util.getInt(req, "id")));
    return "/med/drugs/dicts/drugs/incomes";
  }
  //endregion

  //region OUTS
  @RequestMapping("/out.s")
  protected String Out(HttpServletRequest request, Model model) {
    Session session = SessionUtil.getUser(request);
    session.setCurUrl("/drugs/out.s");
    String startDate = Util.get(request, "period_start", "01" + Util.getCurDate().substring(2));
    String endDate = Util.get(request, "period_end", Util.getCurDate());
    String direction = Util.get(request, "direction");
    //
    List<DrugOuts> acts = dDrugOut.getList("From DrugOuts Where (state in ('SND', 'CON') Or state = null) And date(regDate) Between '" + Util.dateDBBegin(startDate) + "' And '" + Util.dateDBBegin(endDate) + "' " + (direction != null && !direction.isEmpty() ? "And direction.id = " + direction : "") + " Order By regDate Desc, id desc");
    List<ObjList> list = new ArrayList<ObjList>();
    //
    for(DrugOuts act : acts) {
      ObjList obj = new ObjList();
      obj.setIb(act.getId().toString());
      obj.setC1("№" + act.getRegNum() + " от " + Util.dateToString(act.getRegDate()));
      obj.setC2(dDrugActDrug.getCount("From DrugOutRows Where doc.id = " + act.getId()).toString());
      if(act != null && act.getId() != null) {
        Double sum = dDrugOutRow.getActSum(act.getId());
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
    model.addAttribute("directions", dDrugDirection.getAll());
    model.addAttribute("direction", direction);
    return "/med/drugs/out/index";
  }

  @RequestMapping("/out/save.s")
  protected String OutSave(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/drugs/out/save.s?id=" + Util.getInt(req, "id"));
    //
    DrugOuts obj = Util.getInt(req, "id") > 0 ? dDrugOut.get(Util.getInt(req, "id")) : new DrugOuts();
    if(Util.getInt(req, "id") == 0) obj.setId(0);
    List<DrugOutRows> rr = dDrugOutRow.getList("From DrugOutRows t Where t.doc.id = " + obj.getId());
    List<Obj> list = new ArrayList<Obj>();
    for(DrugOutRows r: rr) {
      Obj b = new Obj();
      b.setId(r.getId());
      b.setName(r.getDrug().getName());
      b.setClaimCount(r.getClaimCount());
      b.setDrugCount(r.getDrugCount());
      b.setPrice(r.getPrice());
      List<DrugActDrugs> act = dDrugActDrug.getList("From DrugActDrugs Where act.state != 'E' And counter - rasxod > 0 And drug.id = " + r.getDrug().getId());
      List<ObjList> variuos = new ArrayList<ObjList>();
      if(act.size() > 0)
        for(DrugActDrugs a: act) {
          ObjList o = new ObjList();
          o.setC1(a.getId().toString());
          o.setC2((a.getCounter() - a.getRasxod()) + "");
          o.setC3(a.getCountPrice().toString());
          o.setC4(a.getBlockCount().toString());
          variuos.add(o);
        }
      b.setList(variuos);
      list.add(b);
    }
    model.addAttribute("rows", list);
    //
    model.addAttribute("obj", obj);
    model.addAttribute("measures", dDrugMeasure.getList("From DrugMeasures"));
    model.addAttribute("drugs", dDrug.getList("From Drugs t Where exists (Select 1 From DrugActDrugs c Where act.state != 'E' And c.counter - c.rasxod > 0 And c.drug.id = t.id) Order By t.name"));
    Util.makeMsg(req, model);
    return "/med/drugs/out/addEdit";
  }

  @RequestMapping(value = "/out/row/clear.s", method = RequestMethod.POST)
  @ResponseBody
  protected String OutDel(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      DrugOutRows row = dDrugOutRow.get(Util.getInt(req, "id"));
      //
      DrugActDrugs income = row.getIncome();
      income.setRasxod(income.getRasxod() - row.getDrugCount());
      dDrugActDrug.save(income);
      //
      row.setIncome(null);
      row.setPrice(null);
      row.setDrugCount(null);
      dDrugOutRow.save(row);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/out/row/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String outRowSave(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      String[] row_ids = req.getParameterValues("row_id");
      String[] drug_ids = req.getParameterValues("drug_id");
      String[] drug_counts = req.getParameterValues("drug_count");
      for(int i=0;i<row_ids.length;i++) {
        DrugOutRows row = dDrugOutRow.get(Integer.parseInt(row_ids[i]));
        row.setDrugCount(Double.parseDouble(drug_counts[i]));
        DrugActDrugs income = dDrugActDrug.get(Integer.parseInt(drug_ids[i]));
        if(row.getDrugCount() > income.getCounter() - income.getRasxod()) {
          json.put("success", false);
          json.put("msg", "Кол-во списании не может быть больше остатка. Препарад: " + row.getDrug().getName() + " Остаток: " + (income.getCounter() - income.getRasxod()) + " Списание: " + row.getDrugCount());
          return json.toString();
        }
        income.setRasxod(income.getRasxod() + row.getDrugCount());
        dDrugActDrug.save(income);
        row.setPrice(income.getCountPrice());
        row.setIncome(income);
        dDrugOutRow.save(row);
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/out/row/copy.s", method = RequestMethod.POST)
  @ResponseBody
  protected String OutRowCopy(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      DrugOutRows fact = dDrugOutRow.get(Util.getInt(req, "id"));
      Double rc = Double.parseDouble(Util.get(req, "drug_count", "0"));
      if(fact.getClaimCount() <= rc || rc <= 0) {
        json.put("msg", "Кол-во для разделения не соответствует требованиям");
        json.put("success", false);
      }
      fact.setClaimCount(fact.getClaimCount() - rc);
      dDrugOutRow.save(fact);
      fact.setId(null);
      fact.setClaimCount(rc);
      fact.setIncome(null);
      fact.setPrice(null);
      fact.setDrugCount(null);
      dDrugOutRow.save(fact);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/out/row/del.s", method = RequestMethod.POST)
  @ResponseBody
  protected String OutRowDel(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      dDrugOutRow.delete(Util.getInt(req, "id"));
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/out/confirm.s", method = RequestMethod.POST)
  @ResponseBody
  protected String OutConfirm(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      DrugOuts row = dDrugOut.get(Util.getInt(req, "id"));
      List<DrugOutRows> rows = dDrugOutRow.getList("From DrugOutRows Where doc.id = " + row.getId());
      for(DrugOutRows rw: rows) {
        if(rw.getDrugCount() == null) {
          json.put("success", false);
          json.put("msg", "Не все строки обработаны");
          return json.toString();
        }
      }
      row.setConfirmOn(new Date());
      row.setState("CON");
      dDrugOut.save(row);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }
  //endregion
}
