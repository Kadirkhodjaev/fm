package ckb.controllers.admin;

import ckb.dao.admin.depts.DDept;
import ckb.dao.admin.dicts.DLvPartner;
import ckb.dao.admin.params.DParam;
import ckb.dao.admin.users.DUser;
import ckb.dao.admin.users.DUserLog;
import ckb.dao.med.dicts.rooms.DRooms;
import ckb.domains.admin.Depts;
import ckb.domains.admin.LvPartners;
import ckb.domains.admin.Params;
import ckb.domains.admin.Users;
import ckb.domains.med.dicts.Rooms;
import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.Req;
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
import java.util.HashMap;

@Controller
@RequestMapping("/admin")
public class CAdmin {

  @Autowired private DUser dUser;
  @Autowired private DDept dDept;
  @Autowired private DParam dParam;
  @Autowired private DUserLog dUserLog;
  @Autowired private DLvPartner dLvPartner;
  @Autowired private DRooms dRoom;

  @RequestMapping("/changePass.s")
  protected String changePass(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    model.addAttribute("u", dUser.get(session.getUserId()));
    return "/core/users/changePass";
  }

  @RequestMapping(value = "/changePass.s", method = RequestMethod.POST)
  @ResponseBody
  protected String changePass(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      Session session = SessionUtil.getUser(req);
      String password = Req.get(req, "newPass");
      Users u = dUser.get(session.getUserId());
      u.setPassword(Util.md5(password));
      dUser.save(u);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("/price.s")
  protected String price(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/admin/price.s");
    model.addAttribute("prices", dParam.getList("From Params Where showFlag = 'Y'"));
    return "/admin/prices";
  }

  @RequestMapping(value = "/price.s", method = RequestMethod.POST)
  @ResponseBody
  protected String savePrice(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      String[] codes = req.getParameterValues("code");
      String[] prices = req.getParameterValues("price");
      for(int i=0;i<codes.length;i++) {
        Params param = dParam.getObj("From Params Where code = '" + codes[i] + "'");
        param.setVal(prices[i]);
        dParam.save(param);
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("/log.s")
  protected String log(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/admin/log.s");
    String user = Util.get(req, "user", "0");
    String ip = Util.get(req, "ip", "");
    //
    String db = session.getDateBegin().get("user_log");
    if(db == null) db = "01" + Util.getCurDate().substring(2);
    String de = session.getDateEnd().get("user_log");
    if(de == null) de = Util.getCurDate();
    //
    String startDate = Util.get(req, "period_start", db);
    String endDate = Util.get(req, "period_end", de);
    //
    HashMap<String, String> dh = session.getDateBegin();
    dh.put("user_log", startDate);
    session.setDateBegin(dh);
    dh = session.getDateEnd();
    dh.put("user_log", endDate);
    session.setDateEnd(dh);
    //
    model.addAttribute("rows", dUserLog.getList("From UserLogs Where " + (ip.equals("") ? "" : " ip like '%" + ip + "%' And ") + (user.equals("") || user.equals("0") ? "" : " user.id = " + user + " And ") + " date(dateTime) Between '" + Util.dateDBBegin(startDate) + "' And '" + Util.dateDBBegin(endDate) + "' Order By id Desc"));
    model.addAttribute("users", dUser.getAll());
    model.addAttribute("period_start", startDate);
    model.addAttribute("period_end", endDate);
    model.addAttribute("user_id", user);
    model.addAttribute("filterWord", ip);
    //
    return "/admin/log";
  }

  @RequestMapping("/depts.s")
  protected String depts(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/admin/depts.s");
    //
    model.addAttribute("rows", dDept.getAll());
    model.addAttribute("users", dUser.getAll());
    //
    return "/admin/depts";
  }

  @RequestMapping(value = "/dept/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String saveDept(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      Depts rp = Util.isNull(req, "id") ? new Depts() : dDept.get(Util.getInt(req, "id"));
      rp.setName(Util.get(req, "name"));
      rp.setNurse(dUser.get(Util.getInt(req, "user")));
      rp.setState(Util.get(req, "state", "P"));
      dDept.save(rp);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/dept/get.s", method = RequestMethod.POST)
  @ResponseBody
  protected String getDept(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      Depts rp = dDept.get(Util.getInt(req, "id"));
      json.put("id", rp.getId());
      json.put("name", rp.getName());
      json.put("nurse", rp.getNurse() == null ? 0 : rp.getNurse().getId());
      json.put("state", rp.getState());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }


  @RequestMapping("/lvpartners.s")
  protected String lvpartners(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/admin/lvpartners.s");
    String state = Util.get(req, "state", "A");
    String word = Util.get(req, "word", "");
    //
    model.addAttribute("rows", dLvPartner.list("From LvPartners Where state = '" + state + "' And (code like '%" + word + "%' Or fio like '%" + word + "%')"));
    model.addAttribute("state", state);
    model.addAttribute("word", word);
    //
    return "/admin/lvpartners";
  }

  @RequestMapping(value = "/lvpartner/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String saveLvPartner(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      LvPartners rp = Util.isNull(req, "id") ? new LvPartners() : dLvPartner.get(Util.getInt(req, "id"));
      rp.setCode(Util.get(req, "code"));
      rp.setFio(Util.get(req, "fio"));
      rp.setState(Util.get(req, "state", "P"));
      rp.setReport(Util.get(req, "report", "N"));
      dLvPartner.save(rp);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/lvpartner/get.s", method = RequestMethod.POST)
  @ResponseBody
  protected String getLvPartner(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      LvPartners rp = dLvPartner.get(Util.getInt(req, "id"));
      json.put("id", rp.getId());
      json.put("code", rp.getCode());
      json.put("fio", rp.getFio());
      json.put("state", rp.getState());
      json.put("report", rp.getReport());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("/rooms.s")
  protected String rooms(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/admin/rooms.s");
    //
    model.addAttribute("rows", dRoom.getAll());
    //
    return "/admin/rooms";
  }

  @RequestMapping(value = "/room/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String save_room(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      Rooms room = dRoom.get(Util.getInt(req, "id"));
      String t = Util.get(req, "type");
      Double v = Util.getDouble(req, "value", 0D);
      if(t.equals("koykoLimit")) room.setKoykoLimit(Long.valueOf(Util.get(req, "value")));
      if(t.equals("price")) room.setPrice(v);
      if(t.equals("for_price")) room.setFor_price(v);
      if(t.equals("extra_price")) room.setExtra_price(v);
      if(t.equals("for_extra_price")) room.setFor_extra_price(v);
      if(t.equals("bron_price")) room.setBron_price(v);
      if(t.equals("for_bron_price")) room.setFor_bron_price(v);
      dRoom.save(room);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

}
