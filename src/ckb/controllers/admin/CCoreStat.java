package ckb.controllers.admin;

import ckb.dao.admin.forms.DForm;
import ckb.dao.med.kdos.DKdoTypes;
import ckb.dao.med.kdos.DKdos;
import ckb.dao.med.lv.plan.DKdoChoosen;
import ckb.domains.admin.KdoTypes;
import ckb.domains.admin.Kdos;
import ckb.domains.med.lv.KdoChoosens;
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
import java.util.HashMap;

@Controller
@RequestMapping("/core/stat/")
public class CCoreStat {

  @Autowired private DForm dForm;
  @Autowired private DKdoTypes dKdoType;
  @Autowired private DKdos dKdo;
  @Autowired private DKdoChoosen dKdoChoosen;

  @RequestMapping("/groups.s")
  protected String stat_groups(HttpServletRequest request, Model model) {
    Session session = SessionUtil.getUser(request);
    session.setCurUrl("/core/stat/groups.s");
    model.addAttribute("groups", dKdoType.getAll());
    return "/core/stat/groups";
  }

  @RequestMapping("/group/save.s")
  protected String addStatGroup(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/core/stat/group/save.s?id=" + Util.nvl(req, "id"));
    if(Util.isNotNull(req, "id"))
      model.addAttribute("ser", dKdoType.get(Util.getInt(req, "id")));
    return "/core/stat/addGroup";
  }

  @RequestMapping(value = "/group/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String saveStatGroup(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      KdoTypes ser = Util.isNull(req, "id") ? new KdoTypes() : dKdoType.get(Util.getInt(req, "id"));
      ser.setName(Util.get(req, "name"));
      ser.setGroupState(Util.isNull(req, "group") ? "N" : Util.get(req, "group"));
      ser.setState(Util.isNull(req, "active") ? "P" : Util.get(req, "active"));
      dKdoType.save(ser);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("/services.s")
  protected String statServices(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    String group = Util.get(req, "group", "0");
    session.setCurUrl("/core/stat/services.s?group=" + group);
    String stateCode = Util.get(req, "state");
    if(stateCode == null) stateCode = session.getFilters().get("admin_stat_state");
    if(stateCode == null) stateCode = "A";
    HashMap<String, String> df = session.getFilters();
    df.put("admin_stat_state", stateCode);
    session.setFilters(df);
    model.addAttribute("groups", dKdoType.getList("From KdoTypes Order By id Desc"));
    model.addAttribute("services", dKdo.getList("From Kdos Where 1=1 " + (group.equals("0") ? "" : " And kdoType.id = " + group) + (stateCode.equals("0") ? "" : " And state = '" + stateCode + "'") + " And id not in (13, 56, 120, 121, 153) Order By kdoType.id"));
    model.addAttribute("forms", dForm.getAll());
    model.addAttribute("group", group);
    model.addAttribute("stateCode", stateCode);
    return "/core/stat/services";
  }

  @RequestMapping("/service/save.s")
  protected String addStat(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/core/stat/service/save.s?id=" + Util.nvl(req, "id"));
    model.addAttribute("groups", dKdoType.getList("From KdoTypes Order By id Desc"));
    if(Util.isNotNull(req, "id")) {
      model.addAttribute("ser", dKdo.get(Util.getInt(req, "id")));
    }
    return "/core/stat/add";
  }

  @RequestMapping("/details.s")
  protected String kdoDetails(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/core/stat/details.s");
    model.addAttribute("services", dKdoChoosen.getList("From KdoChoosens Where kdo.state = 'A' "));
    return "/core/stat/kdoDetails";
  }

  @RequestMapping(value = "/details.s", method = RequestMethod.POST)
  @ResponseBody
  protected String kdoDetailsSave(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      KdoChoosens kdo = dKdoChoosen.get(Util.getInt(req, "id"));
      if(Util.isNotNull(req, "price")) kdo.setPrice(Double.parseDouble(Util.get(req, "price").replaceAll(",", ".")));
      if(Util.isNotNull(req, "for_price")) kdo.setFor_price(Double.parseDouble(Util.get(req, "for_price").replaceAll(",", ".")));
      if(Util.isNotNull(req, "real_price")) kdo.setReal_price(Double.parseDouble(Util.get(req, "real_price").replaceAll(",", ".")));
      if(Util.isNotNull(req, "for_real_price")) kdo.setFor_real_price(Double.parseDouble(Util.get(req, "for_real_price").replaceAll(",", ".")));
      dKdoChoosen.save(kdo);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/kdo/get.s", method = RequestMethod.POST)
  @ResponseBody
  protected String statGeyKdo(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      Kdos d = dKdo.get(Util.getInt(req, "id"));
      json.put("name", d.getName());
      json.put("price", d.getPrice());
      json.put("priced", d.getPriced());
      json.put("for_price", d.getFor_price());
      json.put("real_price", d.getReal_price());
      json.put("for_real_price", d.getFor_real_price());
      json.put("bonus_proc", d.getBonusProc());
      json.put("minTime", d.getMinTime());
      json.put("maxTime", d.getMaxTime());
      json.put("state", d.getState());
      json.put("necKdo", d.getNecKdo());
      json.put("group", d.getKdoType().getId());
      json.put("kdoType", d.getKdoType().getId());
      json.put("norma", d.getNorma());
      json.put("ei", d.getEi());
      json.put("room", d.getRoom());
      json.put("fizei", d.getFizei());
      json.put("form", d.getFormId());
      StringBuilder users = new StringBuilder();
      conn = DB.getConnection();
      assert conn != null;
      ps = conn.prepareStatement("Select a.fio From User_Kdo_Types t, Kdos c, Users a Where a.id = t.users_id And c.kdo_type = t.kdoTypes_Id And c.id = " + d.getId());
      rs = ps.executeQuery();
      while(rs.next()) {
        users.append(rs.getString("fio")).append("; ");
      }
      json.put("users", users);
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

  @RequestMapping(value = "/service/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String kdoSave(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      Kdos d = Util.isNotNull(req, "id") ? dKdo.get(Util.getInt(req, "id")) : new Kdos();
      d.setName(Util.get(req, "name"));
      if(Util.isNotNull(req, "price")) d.setPrice(Double.parseDouble(Util.get(req, "price").replaceAll(",", ".")));
      if(Util.isNotNull(req, "for_price")) d.setFor_price(Double.parseDouble(Util.get(req, "for_price").replaceAll(",", ".")));
      if(Util.isNotNull(req, "real_price")) d.setReal_price(Double.parseDouble(Util.get(req, "real_price").replaceAll(",", ".")));
      if(Util.isNotNull(req, "for_real_price")) d.setFor_real_price(Double.parseDouble(Util.get(req, "for_real_price").replaceAll(",", ".")));
      if(Util.isNotNull(req, "bonus_proc")) d.setBonusProc(Double.parseDouble(Util.get(req, "bonus_proc").replaceAll(",", ".")));
      d.setState(Util.isNull(req, "state") ? "P": "A");
      d.setPriced(Util.isNull(req, "priced") ? "N": "Y");
      d.setNecKdo(Util.isNull(req, "necKdo") ? "N": "Y");
      d.setKdoType(dKdoType.get(Util.getInt(req, "group")));
      d.setCssWidth("700");
      d.setNorma(Util.get(req, "norma"));
      d.setEi(Util.get(req, "ei"));
      d.setShortName(d.getName());
      d.setFormId(Util.getInt(req, "form_id"));
      d.setRoom(Util.get(req, "room"));
      d.setFizei(Util.get(req, "fizei"));
      if(Util.isNotNull(req, "minTime")) d.setMinTime(Integer.parseInt(Util.get(req, "minTime").replaceAll(",", ".")));
      if(Util.isNotNull(req, "maxTime")) d.setMaxTime(Integer.parseInt(Util.get(req, "maxTime").replaceAll(",", ".")));
      dKdo.save(d);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

}
