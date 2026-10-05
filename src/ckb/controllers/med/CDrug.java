package ckb.controllers.med;

import ckb.dao.admin.users.DUserDrugLine;
import ckb.dao.med.drug.act.DDrugAct;
import ckb.dao.med.drug.actdrug.DDrugActDrug;
import ckb.dao.med.drug.dict.categories.DDrugCategory;
import ckb.dao.med.drug.dict.contracts.DDrugContract;
import ckb.dao.med.drug.dict.directions.DDrugDirection;
import ckb.dao.med.drug.dict.directions.DDrugDirectionDep;
import ckb.dao.med.drug.dict.drugs.DDrug;
import ckb.dao.med.drug.dict.drugs.category.DDrugDrugCategory;
import ckb.dao.med.drug.dict.drugs.norma.DDrugNorma;
import ckb.dao.med.drug.dict.drugs.norma.DDrugNormaDirection;
import ckb.dao.med.drug.dict.manufacturer.DDrugManufacturer;
import ckb.dao.med.drug.dict.measures.DDrugMeasure;
import ckb.dao.med.drug.dict.partners.DDrugPartner;
import ckb.dao.med.drug.outs.DDrugOut;
import ckb.dao.med.drug.outs.DDrugOutRow;
import ckb.dao.med.head_nurse.direction.DHNDirection;
import ckb.dao.med.head_nurse.direction.DHNDirectionLink;
import ckb.domains.admin.UserDrugLines;
import ckb.domains.med.drug.DrugActDrugs;
import ckb.domains.med.drug.DrugActs;
import ckb.domains.med.drug.DrugOutRows;
import ckb.domains.med.drug.DrugOuts;
import ckb.domains.med.drug.dict.*;
import ckb.domains.med.head_nurse.HNDirectionLinks;
import ckb.domains.med.head_nurse.HNDirections;
import ckb.models.Obj;
import ckb.models.ObjList;
import ckb.services.med.drug.SDrug;
import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.BeanSession;
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
import javax.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Objects;

@Controller
@RequestMapping("/drugs")
public class CDrug {

  //region Autowired
  @Autowired private DDrug dDrug;
  @Autowired private DDrugDrugCategory dDrugDrugCategory;
  @Autowired private DDrugCategory dDrugCategory;
  @Autowired private DDrugContract dDrugContract;
  @Autowired private DDrugMeasure dDrugMeasure;
  @Autowired private DDrugPartner dDrugPartner;
  @Autowired private DDrugDirection dDrugDirection;
  @Autowired private DDrugAct dDrugAct;
  @Autowired private DDrugActDrug dDrugActDrug;
  @Autowired private DDrugOut dDrugOut;
  @Autowired private DDrugOutRow dDrugOutRow;
  @Autowired private DDrugDirectionDep dDrugDirectionDep;
  @Autowired private DDrugManufacturer dDrugManufacturer;
  @Autowired private DHNDirection dhnDirection;
  @Autowired private DHNDirectionLink dhnDirectionLink;
  @Autowired private DUserDrugLine dUserDrugLine;
  @Autowired private DDrugNorma dDrugNorma;
  @Autowired private DDrugNormaDirection dDrugNormaDirection;
  @Autowired private SDrug sDrug;
  @Autowired private BeanSession beanSession;
  //endregion

  //region INCOMES
  @RequestMapping("/acts.s")
  protected String income(HttpServletRequest request, Model model) {
    Session session = SessionUtil.getUser(request);
    session.setCurUrl("/drugs/acts.s");
    String startDate = Util.get(request, "period_start", "01" + Util.getCurDate().substring(2));
    String endDate = Util.get(request, "period_end", Util.getCurDate());
    String partner = Util.get(request, "partner");
    //
    List<DrugActs> acts = dDrugAct.getList("From DrugActs Where date(regDate) Between '" + Util.dateDB(startDate) + "' And '" + Util.dateDB(endDate) + "' " + (partner != null && !partner.isEmpty() ? " And contract.partner.id = " + partner : "") + " Order By regDate Desc");
    List<ObjList> list = new ArrayList<>();
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
    Double ndsProc = beanSession.getNds();
    //
    DrugActs act = Util.getInt(req, "id") > 0 ? dDrugAct.get(Util.getInt(req, "id")) : new DrugActs();
    if(Util.getInt(req, "id") == 0)
      act.setRegDate(new Date());
    model.addAttribute("obj", act);
    model.addAttribute("contracts", dDrugContract.list("From DrugContracts Order By partner.ord"));
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
      Double ndsProc = beanSession.getNds();
      Date endDate = Util.stringToDate(Util.get(req, "end_date"));
      boolean isErr = false;
      if(Util.isNotDouble(req, "price")) {
        isErr = true;
        json.put("msg", "Поля цена имеет не правильный формат");
      }
      if(Util.isNotDouble(req, "block_count")) {
        json.put("msg", (isErr ? json.get("msg") + " " : "") + "Поле кол-во имеет не правильный формат");
        isErr = true;
      }
      if(Util.isNotDouble(req, "one_price")) {
        json.put("msg", (isErr ? json.get("msg") + " " : "") + "Поле Цена за единицу имеет не правильный формат");
        isErr = true;
      }
      if(Util.isNull(req, "counter") || Util.isNotDouble(req, "counter")) {
        json.put("msg", (isErr ? json.get("msg") + " " : "") + "Поле Кол-во единиц имеет не правильный формат");
        isErr = true;
      }
      if(endDate.before(new Date()) || endDate.equals(new Date())) {
        json.put("msg", (isErr ? json.get("msg") + " " : "") + "Срок годность не может быть меньше текущей даты");
        isErr = true;
      }
      if(Util.isNull(req, "man")) {
        json.put("msg", (isErr ? json.get("msg") + " " : "") + "Производитель не может быть пустым");
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
      drug.setDone("N");
      dDrugActDrug.save(drug);
      json.put("id", drug.getId());
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
      if (drug.getCountPrice() != null && drug.getNdsProc() != null)
        drug.setNds(Math.round(drug.getNdsProc() * drug.getCountPrice()) / 100.0);
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
      Double income_in = DB.getSum(conn, "Select Sum(c.countprice * c.counter) From Drug_Acts t, Drug_Act_Drugs c Where t.id = c.act_id And t.state != 'E' And t.regDate < '" + Util.dateDBBegin(startDate) + "'");
      Double out_in = DB.getSum(conn, "Select Sum(c.price * c.drugCount) From Drug_Outs t, Drug_Out_Rows c Where t.id = c.doc_id And t.regDate < '" + Util.dateDBBegin(startDate) + "'");
      //
      Double income_period = DB.getSum(conn, "Select Sum(c.countprice * c.counter) From Drug_Acts t, Drug_Act_Drugs c Where t.id = c.act_id And t.state != 'E' And t.regDate Between '" + Util.dateDBBegin(startDate) + "' And '" + Util.dateDBBegin(endDate) + "' ");
      Double out_period = DB.getSum(conn, "Select Sum(c.price * c.drugCount) From Drug_Outs t, Drug_Out_Rows c Where t.id = c.doc_id And t.regDate Between '" + Util.dateDBBegin(startDate) + "' And '" + Util.dateDBBegin(endDate) + "'");
      //
      model.addAttribute("saldo_in", income_in - out_in);
      model.addAttribute("income_sum", income_period);
      model.addAttribute("outcome_sum", out_period);
      model.addAttribute("saldo_out", income_in - out_in + income_period - out_period);
      //
      List<ObjList> rows = new ArrayList<>();
      // stock = batches of CONFIRMED acts (draft acts are not on the warehouse yet), with expiry, act and manufacturer
      ps = conn.prepareStatement(
          " Select t.Id batch_id, " +
          "        t.Drug_Id, " +
          "        c.name, " +
          "        m.name measure, " +
          "        t.countPrice * (t.counter - t.rasxod) summ, " +
          "        t.counter - t.rasxod counter, " +
          "        t.countprice Price, " +
          "        t.nds, " +
          "        date_format(t.endDate, '%Y-%m-%d') end_date, " +
          "        a.regNum, " +
          "        date_format(a.regDate, '%d.%m.%Y') reg_date, " +
          "        f.name man " +
          "   From drug_act_drugs t " +
          "   Join drug_s_names c On c.id = t.drug_id " +
          "   Join drug_acts a On a.id = t.act_id " +
          "   Left Join drug_s_measures m On m.id = t.measure_id " +
          "   Left Join drug_s_manufacturers f On f.id = t.manufacturer_id " +
          "  Where t.counter - t.rasxod > 0 " +
          "    And a.state != 'E' " +
          "  Order By c.Name, t.endDate");
      rs = ps.executeQuery();
      while (rs.next()) {
        ObjList obj = new ObjList();
        obj.setIb(rs.getString("drug_id"));
        obj.setC1(rs.getString("name"));
        obj.setC2(rs.getString("counter"));
        obj.setC3(rs.getString("summ"));
        obj.setC4(rs.getString("price"));
        obj.setC5(rs.getString("nds"));
        obj.setC6(rs.getString("end_date"));
        obj.setC7(rs.getString("regNum"));
        obj.setC8(rs.getString("reg_date"));
        obj.setC9(rs.getString("man"));
        obj.setC10(rs.getString("measure"));
        obj.setC11(rs.getString("batch_id"));
        //
        rows.add(obj);
      }
      Double ndsProc = beanSession.getNds();
      model.addAttribute("ndsProc", ndsProc);
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
      List<ObjList> rows = new ArrayList<>();
      ps = conn.prepareStatement(
        " Select t.drug_id, c.name, m.name measure, t.countPrice * (t.counter - t.rasxod) summ, t.counter - t.rasxod counter, t.countPrice price, " +
        "        date_format(t.endDate, '%d.%m.%Y') end_date, f.name man, a.regNum, date_format(a.regDate, '%d.%m.%Y') reg_date " +
        "   From drug_act_drugs t " +
        "   Join drug_s_names c On c.id = t.drug_id " +
        "   Join drug_acts a On a.id = t.act_id " +
        "   Left Join drug_s_measures m On m.id = t.measure_id " +
        "   Left Join drug_s_manufacturers f On f.id = t.manufacturer_id " +
        "  Where t.counter - t.rasxod > 0 And a.state != 'E' " +
        "  Order By c.Name, t.endDate");
      rs = ps.executeQuery();
      while (rs.next()) {
        ObjList obj = new ObjList();
        obj.setIb(rs.getString("drug_id"));
        obj.setC1(rs.getString("name"));
        obj.setC2(rs.getString("counter"));
        obj.setC3(rs.getString("summ"));
        obj.setC4(rs.getString("price"));
        obj.setC5(rs.getString("end_date"));
        obj.setC6(rs.getString("man"));
        obj.setC7(rs.getString("regNum"));
        obj.setC8(rs.getString("reg_date"));
        obj.setC9(rs.getString("measure"));
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
    // the rows are loaded by the page itself (one compact json request): see /details/list.s
    model.addAttribute("page_code", code);
    return "/med/drugs/details/index";
  }

  private static void jsonText(StringBuilder sb, String s) {
    if(s == null) {
      sb.append("null");
      return;
    }
    sb.append('"');
    for(int i = 0; i < s.length(); i++) {
      char ch = s.charAt(i);
      switch(ch) {
        case '"': sb.append("\\\""); break;
        case '\\': sb.append("\\\\"); break;
        case '\n': sb.append("\\n"); break;
        case '\r': sb.append("\\r"); break;
        case '\t': sb.append("\\t"); break;
        case '/': sb.append("\\/"); break;
        default:
          if(ch < 0x20) sb.append(String.format("\\u%04x", (int) ch));
          else sb.append(ch);
      }
    }
    sb.append('"');
  }

  private static void jsonNum(StringBuilder sb, double v) {
    sb.append(new java.math.BigDecimal(v).setScale(2, java.math.RoundingMode.HALF_UP).toPlainString());
  }

  // All batches of all acts as compact arrays (one request instead of a 30 000 row html page).
  // Row: [batch id, drug id, drug, act no, act date, act state, expiry yyyy-MM-dd, unit price, received, used, sum of out rows, manufacturer, unit]
  @RequestMapping("/details/list.s")
  protected void detailsList(HttpServletRequest req, HttpServletResponse resp) throws Exception {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    StringBuilder sb = new StringBuilder(1 << 20);
    try {
      conn = DB.getConnection();
      ps = conn.prepareStatement(
        " Select t.id, t.drug_id, c.name, a.regNum, date_format(a.regDate, '%d.%m.%Y') reg_date, a.state act_state, " +
        "        date_format(t.endDate, '%Y-%m-%d') end_date, t.countPrice price, t.counter, t.rasxod, " +
        "        (Select Sum(r.drugCount) From drug_out_rows r Where r.income_id = t.id) out_sum, " +
        "        f.name man, m.name measure " +
        "   From drug_act_drugs t " +
        "   Join drug_s_names c On c.id = t.drug_id " +
        "   Join drug_acts a On a.id = t.act_id " +
        "   Left Join drug_s_manufacturers f On f.id = t.manufacturer_id " +
        "   Left Join drug_s_measures m On m.id = t.measure_id " +
        "  Order By c.name, t.endDate, t.id");
      rs = ps.executeQuery();
      sb.append("{\"success\":true,\"rows\":[");
      boolean first = true;
      while(rs.next()) {
        if(!first) sb.append(',');
        first = false;
        sb.append('[').append(rs.getInt("id")).append(',').append(rs.getInt("drug_id")).append(',');
        jsonText(sb, rs.getString("name")); sb.append(',');
        jsonText(sb, rs.getString("regNum")); sb.append(',');
        jsonText(sb, rs.getString("reg_date")); sb.append(',');
        jsonText(sb, rs.getString("act_state")); sb.append(',');
        jsonText(sb, rs.getString("end_date")); sb.append(',');
        jsonNum(sb, rs.getDouble("price")); sb.append(',');
        jsonNum(sb, rs.getDouble("counter")); sb.append(',');
        jsonNum(sb, rs.getDouble("rasxod")); sb.append(',');
        jsonNum(sb, rs.getDouble("out_sum")); sb.append(',');
        jsonText(sb, rs.getString("man")); sb.append(',');
        jsonText(sb, rs.getString("measure"));
        sb.append(']');
      }
      sb.append("]}");
    } catch (Exception e) {
      e.printStackTrace();
      sb.setLength(0);
      sb.append("{\"success\":false,\"msg\":");
      jsonText(sb, String.valueOf(e.getMessage()));
      sb.append('}');
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(conn);
    }
    byte[] bytes = sb.toString().getBytes("UTF-8");
    resp.setContentType("application/json;charset=UTF-8");
    String ae = req.getHeader("Accept-Encoding");
    if(ae != null && ae.contains("gzip")) {
      resp.setHeader("Content-Encoding", "gzip");
      java.util.zip.GZIPOutputStream gz = new java.util.zip.GZIPOutputStream(resp.getOutputStream());
      gz.write(bytes);
      gz.finish();
      gz.close();
    } else {
      resp.getOutputStream().write(bytes);
    }
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
      json.put("drug_count", actDrug.getCounter());
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

  //region DICTS
  @RequestMapping("/dicts.s")
  protected String dicsts(HttpServletRequest request) {
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
            ct.setDept(beanSession.getDept(Integer.parseInt(dep)));
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
        obj.setOrd(Util.getDouble(req, "ord", 0D));
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
        json.put("ord", obj.getOrd());
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
  protected String dictsDirection(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    session.setCurSubUrl("/drugs/dict/rasxodtypes.s");
    //
    model.addAttribute("list", dhnDirection.getAll());
    model.addAttribute("rows", dDrugDirection.getList("From DrugDirections Order By id"));
    return "/med/drugs/dicts/rasxodtypes/index";
  }

  @RequestMapping("/dict/categories.s")
  protected String dictsCategories(HttpServletRequest request, Model model){
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
    model.addAttribute("deps", beanSession.getDepts());
    Util.makeMsg(request, model);
    return "/med/drugs/dicts/directions/index";
  }

  @RequestMapping("/dict/contracts.s")
  protected String dictsContracts(HttpServletRequest request, Model model){
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
  protected String dictsMeasures(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    session.setCurUrl("/drugs/dicts.s");
    session.setCurSubUrl("/drugs/dict/measures.s");
    //
    model.addAttribute("list", dDrugMeasure.getAll());
    Util.makeMsg(request, model);
    return "/med/drugs/dicts/measures/index";
  }

  @RequestMapping("/dict/partners.s")
  protected String dictsPartners(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    session.setCurUrl("/drugs/dicts.s");
    session.setCurSubUrl("/drugs/dict/partners.s");
    //
    model.addAttribute("list", dDrugPartner.getAll());
    Util.makeMsg(request, model);
    return "/med/drugs/dicts/partners/index";
  }

  @RequestMapping("/dict/drugs.s")
  protected String dictsDrugs(HttpServletRequest request, Model model) {
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

  @RequestMapping("/dict/drug/normas.s")
  protected String dictsDrugNormas(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/drugs/dicts.s");
    session.setCurSubUrl("/drugs/dict/drug/normas.s");
    model.addAttribute("drugs", dDrug.list("From Drugs t Where Not Exists (Select 1 From DrugNormas c Where c.drug.id = t.id) And state = 'A' Order By Name"));
    model.addAttribute("rows", dDrugNorma.list("From DrugNormas Order By drug.name"));
    model.addAttribute("directions", dDrugDirection.list("From DrugDirections Where id in (25, 28, 29) Order By Name"));
    return "/med/drugs/dicts/drugs/normas";
  }

  @RequestMapping("/dict/drug/normas/view.s")
  protected String dictsDrugView(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/drugs/dicts.s");
    session.setCurSubUrl("/drugs/dict/drug/normas/view.s?id=" + Util.getInt(req, "id"));
    Drugs drug = dDrug.get(Util.getInt(req, "id"));
    model.addAttribute("drug", drug);
    model.addAttribute("norma", dDrugNorma.obj("From DrugNormas Where drug.id = " + drug.getId()));
    List<DrugNormaDirections> dirs = dDrugNormaDirection.list("From DrugNormaDirections Where drug.id = " + drug.getId());
    if(dirs.isEmpty()) {
      List<DrugDirections> directs = dDrugDirection.list("From DrugDirections Where id in (25, 28, 29) Order By Name");
      for(DrugDirections d : directs) {
        DrugNormaDirections a = new DrugNormaDirections();
        a.setDrug(drug);
        a.setDirection(d);
        a.setNorma(0D);
        dirs.add(a);
      }
    }
    model.addAttribute("directions", dirs);
    return "/med/drugs/dicts/drugs/norma_view";
  }

  @RequestMapping(value = "/dict/drug/norma.s", method = RequestMethod.POST)
  @ResponseBody
  protected String saveDrugNorma(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      int id = Util.getInt(req, "id", 0);
      DrugNormas norma = id == 0 ? new DrugNormas() : dDrugNorma.get(id);
      norma.setDrug(dDrug.get(Util.getInt(req, "drug")));
      norma.setNormaType(Util.get(req, "type"));
      norma.setNorma(Util.getDouble(req, "norma", 0D));
      norma.setTab(Util.getDouble(req, "tab", 0D));
      if(id == 0) {
        norma.setProc(norma.getNorma());
        norma.setMaxval(norma.getNorma());
      }
      dDrugNorma.saveAndReturn(norma);
      dDrugNormaDirection.delSql("From DrugNormaDirections Where doc.id = " + norma.getId());
      if(norma.getNormaType().equals("MULTI")) {
        norma.setNorma(0D);
        dDrugNorma.save(norma);
        String[] ids = req.getParameterValues("ids");
        String[] normas = req.getParameterValues("normas");
        for(int i = 0; i < ids.length; i++) {
          DrugNormaDirections dn = new DrugNormaDirections();
          dn.setDoc(norma);
          dn.setDrug(norma.getDrug());
          dn.setNorma(Double.parseDouble(normas[i]));
          dn.setDirection(dDrugDirection.get(Integer.parseInt(ids[i])));
          dDrugNormaDirection.save(dn);
        }
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/dict/drug/norma/set.s", method = RequestMethod.POST)
  @ResponseBody
  protected String setDrugNorma(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      int id = Util.getInt(req, "id", 0);
      DrugNormas norma = dDrugNorma.get(id);
      if(Util.get(req, "type").equals("norma"))
        norma.setNorma(Util.getDouble(req, "val", 0D));
      if(Util.get(req, "type").equals("tab"))
        norma.setTab(Util.getDouble(req, "val", 0D));
      if(Util.get(req, "type").equals("proc"))
        norma.setProc(Util.getDouble(req, "val", 0D));
      if(Util.get(req, "type").equals("max"))
        norma.setMaxval(Util.getDouble(req, "val", 0D));
      dDrugNorma.save(norma);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/dict/drug/norma/del.s", method = RequestMethod.POST)
  @ResponseBody
  protected String delDrugNorma(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      int id = Util.getInt(req, "id", 0);
      dDrugNormaDirection.delSql("From DrugNormaDirections Where doc.id = " + id);
      dDrugNorma.delete(id);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
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
    String state = Util.get(request, "state", "");
    //
    List<DrugOuts> acts = dDrugOut.getList("From DrugOuts Where (state in ('SND', 'CON') Or state = null) And date(regDate) Between '" + Util.dateDB(startDate) + "' And '" + Util.dateDB(endDate) + "' " + (direction != null && !direction.isEmpty() ? "And direction.id = " + direction : "") + ( state.isEmpty() ? "" : " And insFlag != 'Y'" ) + " Order By regDate Desc, id desc");
    List<ObjList> list = new ArrayList<>();
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
      obj.setC10(act.getAutoFlag());
      list.add(obj);
    }
    //
    model.addAttribute("list", list);
    model.addAttribute("period_start", startDate);
    model.addAttribute("period_end", endDate);
    model.addAttribute("directions", dDrugDirection.getAll());
    model.addAttribute("direction", direction);
    model.addAttribute("state", state);
    return "/med/drugs/out/index";
  }

  @RequestMapping("/out/save.s")
  protected String OutSave(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/drugs/out/save.s?id=" + Util.getInt(req, "id"));
    //
    DrugOuts obj = Util.getInt(req, "id") > 0 ? dDrugOut.get(Util.getInt(req, "id")) : new DrugOuts();
    if(Util.getInt(req, "id") == 0) obj.setId(0);
    List<DrugOutRows> rr = dDrugOutRow.getList("From DrugOutRows t Where t.doc.id = " + obj.getId() + " Order By drug.name");
    List<Obj> list = new ArrayList<>();
    for(DrugOutRows r: rr) {
      Obj b = new Obj();
      b.setId(r.getId());
      b.setName(r.getDrug().getName());
      b.setClaimCount(r.getClaimCount());
      b.setDrugCount(r.getDrugCount());
      b.setPrice(r.getPrice());
      if(r.getPerc() != null)
        b.setPerc(Math.ceil(r.getPerc() * 10000) / 100);
      List<DrugActDrugs> act = dDrugActDrug.getList("From DrugActDrugs Where act.state != 'E' And counter - rasxod > 0 And drug.id = " + r.getDrug().getId() + " Order By endDate, id");
      List<ObjList> variuos = new ArrayList<>();
      if(!act.isEmpty())
        for(DrugActDrugs a: act) {
          ObjList o = new ObjList();
          o.setC1(a.getId().toString());
          o.setC2((a.getCounter() - a.getRasxod()) + "");
          o.setC3(a.getCountPrice().toString());
          o.setC4(a.getBlockCount().toString());
          o.setC5(Util.dateToString(a.getAct().getRegDate()));
          o.setC6(Util.dateToString(a.getEndDate()));
          o.setC7(a.getManufacturer() == null ? "" : a.getManufacturer().getName());
          variuos.add(o);
        }
      b.setList(variuos);
      if(Util.nvl(r.getDoc().getAutoFlag(), "N").equals("Y")) {
        try {
          DrugNormas norma = dDrugNorma.obj("From DrugNormas Where drug.id = " + r.getDrug().getId());
          if(norma != null) {
            b.setFio(norma.getId().toString());
          }
        } catch (Exception e) {

        }
      }
      list.add(b);
    }
    model.addAttribute("rows", list);
    //
    model.addAttribute("obj", obj);
    model.addAttribute("measures", dDrugMeasure.getList("From DrugMeasures"));
    model.addAttribute("drugs", dDrug.getList("From Drugs t Where exists (Select 1 From DrugActDrugs c Where c.done = 'N' And act.state != 'E' And c.counter - c.rasxod > 0 And c.drug.id = t.id) Order By t.name"));
    Util.makeMsg(req, model);
    return "/med/drugs/out/addEdit";
  }

  @RequestMapping(value = "/out/row/norma.s", method = RequestMethod.POST)
  @ResponseBody
  protected String save_out_row_norma(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      DrugNormas norma = dDrugNorma.get(Util.getInt(req, "id"));
      norma.setDrug(dDrug.get(Util.getInt(req, "drug")));
      norma.setNormaType(Util.get(req, "type"));
      norma.setNorma(Util.getDouble(req, "norma", 0D));
      double n = norma.getNorma();
      DrugOutRows outRow = dDrugOutRow.get(Util.getInt(req, "out_row"));
      dDrugNorma.saveAndReturn(norma);
      dDrugNormaDirection.delSql("From DrugNormaDirections Where doc.id = " + norma.getId());
      if(norma.getNormaType().equals("MULTI")) {
        norma.setNorma(0D);
        dDrugNorma.save(norma);
        String[] ids = req.getParameterValues("ids");
        String[] normas = req.getParameterValues("normas");
        for(int i = 0; i < ids.length; i++) {
          DrugNormaDirections dn = new DrugNormaDirections();
          dn.setDoc(norma);
          dn.setDrug(norma.getDrug());
          dn.setNorma(Double.parseDouble(normas[i]));
          dn.setDirection(dDrugDirection.get(Integer.parseInt(ids[i])));
          if(Objects.equals(outRow.getDoc().getDirection().getId(), dn.getDirection().getId())) {
            n = dn.getNorma();
          }
          dDrugNormaDirection.save(dn);
        }
      }
      double saldo = sDrug.saldo(outRow.getDoc().getDirection().getId(), outRow.getDrug().getId()), drug_saldo = sDrug.drug_saldo(outRow.getDrug().getId());
      if(drug_saldo > 0 && n > 0 && n - saldo > 0 && (n - saldo) / n <= 0.75) {
        outRow.setClaimCount(n - saldo);
        dDrugOutRow.save(outRow);
      } else {
        int doc = outRow.getDoc().getId();
        dDrugOutRow.delete(outRow.getId());
        if(dDrugOutRow.getCount("From DrugOutRows Where doc.id = " + doc) == 0) {
          dDrugOut.delete(doc);
          json.put("empty_flag", "Y");
        }
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("/out/drug/norma.s")
  protected String out_drug_norma(HttpServletRequest req, Model model) {
    DrugNormas norma = dDrugNorma.get(Util.getInt(req, "id"));
    model.addAttribute("drug", norma.getDrug());
    model.addAttribute("norma", dDrugNorma.obj("From DrugNormas Where id = " + norma.getId()));
    List<DrugNormaDirections> dirs = dDrugNormaDirection.list("From DrugNormaDirections Where drug.id = " + norma.getDrug().getId());
    if(dirs.isEmpty()) {
      List<DrugDirections> directs = dDrugDirection.list("From DrugDirections Where id in (25, 28, 29) Order By Name");
      for(DrugDirections d : directs) {
        DrugNormaDirections a = new DrugNormaDirections();
        a.setDrug(norma.getDrug());
        a.setDirection(d);
        a.setNorma(0D);
        dirs.add(a);
      }
    }
    model.addAttribute("directions", dirs);
    DrugOutRows outRow = dDrugOutRow.get(Util.getInt(req, "out_row"));

    model.addAttribute("outRow", outRow);
    return "/med/drugs/dicts/drugs/norma_modal";
  }

  @RequestMapping(value = "/out/del.s", method = RequestMethod.POST)
  @ResponseBody
  protected String del_out_doc(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      DrugOuts out = dDrugOut.get(Util.getInt(req, "id"));
      if(out.getState().equals("SND")) {
        if(dDrugOutRow.getCount("From DrugOutRows Where doc.id = " + out.getId() + " And drugCount is not null") == 0) {
          dDrugOutRow.delSql("From DrugOutRows Where doc.id = " + out.getId());
          dDrugOut.delete(out.getId());
        } else {
          return Util.err(json, "Есть подтвержденные записи. Удалиты связку медикаментов");
        }
      } else {
        return Util.err(json, "Нельзя удалить документ! Состояние документа не 'Отплавлен' ");
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
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
      if(row_ids == null) {
        json.put("success", true);
        return json.toString();
      }
      for(int i=0;i<row_ids.length;i++) {
        DrugOutRows row = dDrugOutRow.get(Integer.parseInt(row_ids[i]));
        // the row is already issued (second click / second request): never write it off twice
        if(row.getDrugCount() != null)
          continue;
        double cnt = Double.parseDouble(drug_counts[i]);
        int batchId = Integer.parseInt(drug_ids[i]);
        // nothing to issue for this row (no stock / zero): leave it untouched
        if(batchId <= 0 || cnt <= 0)
          continue;
        // atomic: the batch balance is checked and decreased by one statement, so two users cannot take the same stock
        if(dDrugActDrug.takeStock(batchId, cnt) == 0) {
          DrugActDrugs fresh = dDrugActDrug.get(batchId);
          double left = fresh == null ? 0 : fresh.getCounter() - fresh.getRasxod();
          json.put("success", false);
          json.put("msg", "Кол-во списания не может быть больше остатка. Препарат: " + row.getDrug().getName() + ". Остаток по партии: " + left);
          return json.toString();
        }
        try {
          DrugActDrugs actDrug = dDrugActDrug.get(batchId);
          row.setDrugCount(cnt);
          row.setPrice(actDrug.getCountPrice());
          row.setIncome(actDrug);
          dDrugOutRow.save(row);
        } catch (Exception e) {
          dDrugActDrug.giveBack(batchId, cnt);
          throw e;
        }
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  // Auto issue of the whole document: every pending row is covered by the batches that expire first (FEFO).
  // If one batch is not enough the row is split: one row per batch. What cannot be covered stays as a pending row.
  @RequestMapping(value = "/out/auto.s", method = RequestMethod.POST)
  @ResponseBody
  protected String outAuto(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      DrugOuts out = dDrugOut.get(Util.getInt(req, "id"));
      if(out == null || !"SND".equals(out.getState()))
        return Util.err(json, "Документ нельзя обработать: состояние не «Отправлен»");
      List<DrugOutRows> rows = dDrugOutRow.getList("From DrugOutRows Where doc.id = " + out.getId() + " And drugCount is null Order By id");
      int issued = 0, lines = 0;
      JSONArray shortage = new JSONArray();
      for(DrugOutRows row : rows) {
        double need = row.getClaimCount() == null ? 0 : row.getClaimCount();
        if(need <= 0)
          continue;
        List<DrugActDrugs> batches = dDrugActDrug.getList("From DrugActDrugs Where act.state != 'E' And counter - rasxod > 0 And endDate > CURRENT_DATE() And drug.id = " + row.getDrug().getId() + " Order By endDate, id");
        double left = need;
        boolean first = true;
        for(DrugActDrugs b : batches) {
          if(left <= 0.0001)
            break;
          double take = Math.round(Math.min(left, b.getCounter() - b.getRasxod()) * 100) / 100.0;
          if(take <= 0)
            continue;
          // somebody has just taken this batch: try the next one
          if(dDrugActDrug.takeStock(b.getId(), take) == 0)
            continue;
          DrugOutRows target = row;
          if(!first) {
            target = new DrugOutRows();
            target.setDoc(out);
            target.setDrug(row.getDrug());
            target.setMeasure(row.getMeasure());
            target.setPerc(row.getPerc());
            target.setHndrug(row.getHndrug());
            target.setCrBy(row.getCrBy());
            target.setCrOn(row.getCrOn());
          }
          try {
            target.setClaimCount(take);
            target.setDrugCount(take);
            target.setIncome(b);
            target.setPrice(b.getCountPrice());
            dDrugOutRow.save(target);
          } catch (Exception e) {
            dDrugActDrug.giveBack(b.getId(), take);
            throw e;
          }
          first = false;
          lines++;
          left = Math.round((left - take) * 100) / 100.0;
        }
        if(first) {
          // nothing was found for this row
          shortage.put(row.getDrug().getName() + ": " + need);
        } else {
          issued++;
          if(left > 0.0001) {
            DrugOutRows rest = new DrugOutRows();
            rest.setDoc(out);
            rest.setDrug(row.getDrug());
            rest.setMeasure(row.getMeasure());
            rest.setPerc(row.getPerc());
            rest.setHndrug(row.getHndrug());
            rest.setCrBy(row.getCrBy());
            rest.setCrOn(row.getCrOn());
            rest.setClaimCount(left);
            dDrugOutRow.save(rest);
            shortage.put(row.getDrug().getName() + ": " + left);
          }
        }
      }
      json.put("success", true);
      json.put("issued", issued);
      json.put("lines", lines);
      json.put("shortage", shortage);
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
      boolean delOut = false;
      DrugOutRows a = dDrugOutRow.get(Util.getInt(req, "id"));
      Integer doc = a.getDoc().getId();
      if(Util.nvl(a.getDoc().getAutoFlag(), "N").equals("Y"))
        if(dDrugOutRow.getCount("From DrugOutRows Where doc.id = " + doc) == 1)
          delOut = true;
      dDrugOutRow.delete(a.getId());
      if(delOut)
        dDrugOut.delete(doc);
      json.put("del_out", delOut);
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

  // departments served by the automatic requests: set the system parameter DRUG_AUTO_OUT_DIRS (ids separated by commas); default 25, 28, 29
  private String autoDirections() {
    String v = beanSession.getParam("DRUG_AUTO_OUT_DIRS");
    return v != null && v.matches("^\\s*\\d+(\\s*,\\s*\\d+)*\\s*$") ? v.trim() : "25, 28, 29";
  }

  // days when the pharmacy orders from the suppliers: system parameter DRUG_ORDER_DAYS (1 = Monday ... 7 = Sunday, separated by commas); default Mon, Wed, Fri
  private String orderDays() {
    String v = beanSession.getParam("DRUG_ORDER_DAYS");
    return v != null && v.matches("^\\s*[1-7](\\s*,\\s*[1-7])*\\s*$") ? v.trim() : "1,3,5";
  }
  @RequestMapping(value = "/out/gen_auto_out.s", method = RequestMethod.POST)
  @ResponseBody
  protected String gen_auto_out(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      List<DrugDirections> directions = dDrugDirection.list("From DrugDirections Where id in (" + autoDirections() + ")");
      double pog = 0;// Double.parseDouble(beanSession.getParam("DRUG_AUTO_OUT_PROC"));
      for(DrugDirections dd : directions) {
        if(dDrugOut.getCount("From DrugOuts Where direction.id = " + dd.getId() + " And state != 'CON' And autoFlag = 'Y'") > 0)
          continue;
        if(dDrugOut.getCount("From DrugOuts Where direction.id = " + dd.getId() + " And state != 'CON' And insFlag = 'Y'") == 0) {
          List<DrugNormas> normas = dDrugNorma.list("From DrugNormas");
          DrugOuts out = null;
          for (DrugNormas norma:  normas) {
            double saldo = sDrug.saldo(dd.getId(), norma.getDrug().getId()), n = 0;
            if(norma.getNormaType().equals("ALL"))
              n = norma.getNorma();
            else {
              DrugNormaDirections nd = dDrugNormaDirection.obj("From DrugNormaDirections Where direction.id = " + dd.getId() + " And doc.id = " + norma.getId());
              if(nd != null)
                n = nd.getNorma();
            }
            pog = norma.getProc();
            double f = n - saldo;
            if(n - saldo > 0 && (saldo <= pog || saldo == 0)) {
              if(Util.nvl(norma.getTab(), 0) > 0) {
                if (f >= norma.getTab()) {
                  double d = Math.floor(f / norma.getTab());
                  double g = Math.ceil(f / norma.getTab());
                  if(norma.getTab() * g <= norma.getMaxval()) {
                    f = norma.getTab() * g;
                  } else {
                    f = norma.getTab() * d;
                  }
                } else {
                  f = norma.getTab();
                }
              }
              double drugSaldo = sDrug.drug_saldo(norma.getDrug().getId());
              if (drugSaldo > 0) {
                if (out == null) {
                  out = new DrugOuts();
                  out.setAutoFlag("Y");
                  out.setState("SND");
                  out.setDirection(dd);
                  out.setRegDate(new Date());
                  out.setCrOn(new Date());
                  out.setRegNum("AUTO");
                  out.setSendOn(new Date());
                  out.setInfo("Автоматическая заявка");
                  out.setInsFlag("N");
                  dDrugOut.saveAndReturn(out);
                }
                DrugOutRows row = new DrugOutRows();
                row.setDoc(out);
                row.setClaimCount(f);
                row.setDrug(norma.getDrug());
                row.setMeasure(row.getDrug().getMeasure());
                row.setPerc((double) Math.round(saldo * 100 / n) / 100);
                row.setCrBy(0);
                row.setCrOn(new Date());
                dDrugOutRow.save(row);
              }
            }
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

  @RequestMapping("/out/drug/claim.s")
  protected String out_drug_claim(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/drugs/out/drug/claim.s");
    // purchase planning page: the data are loaded by the page itself, see /order/data.s
    model.addAttribute("autoDirs", autoDirections());
    return "/med/drugs/order/index";
  }

  private static int intParam(HttpServletRequest req, String name, int def, int min, int max) {
    try {
      int v = Integer.parseInt(req.getParameter(name).trim());
      return Math.max(min, Math.min(max, v));
    } catch (Exception e) {
      return def;
    }
  }

  private static void jsonNum3(StringBuilder sb, double v) {
    sb.append(new java.math.BigDecimal(v).setScale(3, java.math.RoundingMode.HALF_UP).toPlainString());
  }

  // What to order from the suppliers: demand, stock, expiry and norms of every drug (see ckb.utils.OrderCalc).
  // Row: [id, name, unit, block, per day, trend, sigma/day, usable stock, to expire unused, unconfirmed acts, in departments, deficit to norms,
  //       cover days, reorder point, target, order units, order blocks, unit price, vat, supplier, status, ABC, issued in period, history days,
  //       low data, limited by shelf life, shelf days, safety stock, has norm,
  //       main departments [[direction id, stock, up to the norm, use per day, norm, to issue, used today, threshold, surplus], ...],
  //       transfers between the main departments [[from direction id, to direction id, quantity], ...],
  //       pharmacy: expired, expires before it is used up, all the stock, stock of unconfirmed acts]
  @RequestMapping("/order/data.s")
  protected void orderData(HttpServletRequest req, HttpServletResponse resp) throws Exception {
    ckb.utils.OrderCalc.Params p = new ckb.utils.OrderCalc.Params();
    p.period = intParam(req, "period", 28, 14, 365);
    p.cover = intParam(req, "cover", 0, 0, 14);
    p.service = intParam(req, "service", 90, 80, 99) / 100.0;
    p.dirs = autoDirections();
    p.orderDays = orderDays();
    Connection conn = null;
    StringBuilder sb = new StringBuilder(1 << 18);
    try {
      conn = DB.getConnection();
      List<ckb.utils.OrderCalc.Result> res = ckb.utils.OrderCalc.run(conn, p);
      sb.append("{\"success\":true,\"rows\":[");
      boolean first = true;
      for(ckb.utils.OrderCalc.Result r : res) {
        ckb.utils.OrderCalc.Input in = r.in;
        if(!first) sb.append(',');
        first = false;
        sb.append('[').append(in.id).append(',');
        jsonText(sb, in.name); sb.append(',');
        jsonText(sb, in.measure); sb.append(',');
        jsonNum(sb, in.block); sb.append(',');
        jsonNum3(sb, r.d); sb.append(',');
        jsonNum(sb, r.trend); sb.append(',');
        jsonNum3(sb, r.sigma); sb.append(',');
        jsonNum(sb, r.usable); sb.append(',');
        jsonNum(sb, r.risk); sb.append(',');
        jsonNum(sb, r.draftQty); sb.append(',');
        jsonNum(sb, in.deptAll); sb.append(',');
        jsonNum(sb, in.deficit); sb.append(',');
        jsonNum(sb, Math.min(r.cover, 99999)); sb.append(',');
        jsonNum(sb, r.rop); sb.append(',');
        jsonNum(sb, r.target); sb.append(',');
        jsonNum(sb, r.orderUnits); sb.append(',');
        jsonNum(sb, r.orderBlocks); sb.append(',');
        jsonNum(sb, in.lastPrice); sb.append(',');
        jsonNum(sb, in.lastNds); sb.append(',');
        jsonText(sb, in.partner); sb.append(',');
        jsonText(sb, r.status); sb.append(',');
        jsonText(sb, r.abc); sb.append(',');
        jsonNum(sb, in.qTotal); sb.append(',');
        sb.append(in.effDays).append(',');
        sb.append(r.lowData ? 1 : 0).append(',');
        sb.append(r.capped ? 1 : 0).append(',');
        jsonNum(sb, in.shelfDays); sb.append(',');
        jsonNum(sb, r.ss); sb.append(',');
        sb.append(in.hasNorm ? 1 : 0).append(",[");
        for(int k = 0; k < p.dirIds.length; k++) {
          if(k > 0) sb.append(',');
          sb.append('[').append(p.dirIds[k]).append(',');
          jsonNum(sb, in.depStock[k]); sb.append(',');
          jsonNum(sb, r.depToNorm[k]); sb.append(',');
          jsonNum3(sb, in.depRate[k]); sb.append(',');
          jsonNum(sb, in.depNorm[k]); sb.append(',');
          jsonNum(sb, r.depIssue[k]); sb.append(',');
          jsonNum(sb, in.depToday[k]); sb.append(',');
          jsonNum(sb, r.depThreshold[k]); sb.append(',');
          jsonNum(sb, r.depSurplus[k]); sb.append(']');
        }
        sb.append("],[");
        for(int k = 0; k < r.transfers.size(); k++) {
          double[] t = r.transfers.get(k);
          if(k > 0) sb.append(',');
          sb.append('[').append(p.dirIds[(int) t[0]]).append(',').append(p.dirIds[(int) t[1]]).append(',');
          jsonNum(sb, t[2]); sb.append(']');
        }
        sb.append("],");
        jsonNum(sb, r.expired); sb.append(',');
        jsonNum(sb, r.late); sb.append(',');
        jsonNum(sb, r.pharmacy); sb.append(',');
        jsonNum(sb, r.draftAll);
        sb.append(']');
      }
      sb.append("],\"params\":{\"period\":").append(p.period).append(",\"coverDays\":").append(p.coverDays).append(",\"auto\":").append(p.cover == 0)
        .append(",\"orderDays\":");
      jsonText(sb, p.orderDays);
      sb.append(",\"service\":").append((int) Math.round(p.service * 100)).append(",\"dirs\":[");
      for(int k = 0; k < p.dirIds.length; k++) {
        if(k > 0) sb.append(',');
        sb.append('[').append(p.dirIds[k]).append(',');
        jsonText(sb, p.dirNames[k]);
        sb.append(']');
      }
      sb.append("]}}");
    } catch (Exception e) {
      e.printStackTrace();
      sb.setLength(0);
      sb.append("{\"success\":false,\"msg\":");
      jsonText(sb, String.valueOf(e.getMessage()));
      sb.append('}');
    } finally {
      DB.done(conn);
    }
    byte[] bytes = sb.toString().getBytes("UTF-8");
    resp.setContentType("application/json;charset=UTF-8");
    String ae = req.getHeader("Accept-Encoding");
    if(ae != null && ae.contains("gzip")) {
      resp.setHeader("Content-Encoding", "gzip");
      java.util.zip.GZIPOutputStream gz = new java.util.zip.GZIPOutputStream(resp.getOutputStream());
      gz.write(bytes);
      gz.finish();
      gz.close();
    } else {
      resp.getOutputStream().write(bytes);
    }
  }
  //endregion
}
