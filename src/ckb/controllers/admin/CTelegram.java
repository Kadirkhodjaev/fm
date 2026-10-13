package ckb.controllers.admin;

import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.DB;
import ckb.utils.Util;
import ckb.utils.tg.Tg;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;

/**
 * Администрирование -> Телеграм: кто подключил бота, какие уведомления получает,
 * отключение типов уведомлений, сообщение пользователю и история отправленных уведомлений.
 */
@Controller
@RequestMapping("/admin/tg")
public class CTelegram {

  private static final int NURSE_ROLE = 11;

  @RequestMapping("/index.s")
  protected String index(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/admin/tg/index.s");
    model.addAttribute("tgEnabled", Tg.isEnabled());
    model.addAttribute("botName", Tg.isEnabled() ? Tg.botName() : "");
    model.addAttribute("kinds", Tg.KINDS);
    List<Map<String, Object>> rows = new ArrayList<>();
    int linked = 0;
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      conn = DB.getConnection();
      Tg.initTables(conn);
      // отключённые типы: user_id -> set(kind)
      Map<Integer, Set<String>> off = new HashMap<>();
      ps = conn.prepareStatement("Select user_id, kind From Tg_User_Off");
      rs = ps.executeQuery();
      while (rs.next()) {
        if (!off.containsKey(rs.getInt(1))) off.put(rs.getInt(1), new HashSet<String>());
        off.get(rs.getInt(1)).add(rs.getString(2));
      }
      DB.done(rs);
      DB.done(ps);
      ps = conn.prepareStatement(
        "Select u.id, u.fio, u.login, u.Lv, u.Consul, d.name dept_name, t.chat_id, t.phone, t.linked_date, " +
        "       Exists(Select 1 From User_Roles ur Where ur.users_id = u.id And ur.roles_id = " + NURSE_ROLE + ") is_nurse, " +
        "       (u.glb = 1 And Exists(Select 1 From User_Roles ur Where ur.users_id = u.id And ur.roles_id = 6)) is_glv, " +
        "       Exists(Select 1 From Amb_Service_Users su Join Amb_Services s On s.id = su.service Where su.user = u.id And s.consul = 'Y') is_consul, " +
        "       (Select Max(l.sent_date) From Tg_Log l Where l.user_id = u.id) last_sent, " +
        "       (Select Count(*) From Tg_Log l Where l.user_id = u.id) sent_count " +
        "  From Users u " +
        "  Left Join Depts d On d.id = u.Dept_Id " +
        "  Left Join Tg_Users t On t.user_id = u.id " +
        " Where u.Active = 1 " +
        " Order By (t.chat_id Is Null), u.fio");
      rs = ps.executeQuery();
      while (rs.next()) {
        Map<String, Object> r = new HashMap<>();
        int id = rs.getInt("id");
        boolean isLinked = rs.getObject("chat_id") != null;
        if (isLinked) linked++;
        r.put("id", id);
        r.put("fio", Util.nvl(rs.getString("fio")));
        r.put("login", Util.nvl(rs.getString("login")));
        r.put("dept", Util.nvl(rs.getString("dept_name")));
        r.put("linked", isLinked);
        r.put("phone", Util.nvl(rs.getString("phone")));
        r.put("linkedDate", rs.getTimestamp("linked_date") == null ? "" : Util.dateTimeToString(rs.getTimestamp("linked_date")));
        r.put("lastSent", rs.getTimestamp("last_sent") == null ? "" : Util.dateTimeToString(rs.getTimestamp("last_sent")));
        r.put("sentCount", rs.getInt("sent_count"));
        // какие уведомления относятся к пользователю по его роли
        Map<String, Boolean> applies = new HashMap<>();
        applies.put(Tg.LV_NEW, rs.getBoolean("Lv"));
        applies.put(Tg.GLV_NEW, rs.getBoolean("is_glv")); // роль «Главный врач» + галочка в реквизитах, как в TgNewPatientGlv
        applies.put(Tg.SICK_REPEAT, rs.getBoolean("is_nurse"));
        applies.put(Tg.AMB_CONSUL, rs.getBoolean("is_consul"));
        applies.put(Tg.LV_CONSUL, rs.getBoolean("Consul"));
        applies.put(Tg.P_QUESTION, rs.getBoolean("Lv"));
        applies.put(Tg.DIET_CHANGE, rs.getBoolean("is_nurse"));
        applies.put(Tg.TABS_CHANGE, rs.getBoolean("is_nurse"));
        List<Map<String, Object>> kinds = new ArrayList<>();
        for (Map.Entry<String, String> k : Tg.KINDS.entrySet()) {
          Map<String, Object> kr = new HashMap<>();
          kr.put("kind", k.getKey());
          kr.put("name", k.getValue());
          kr.put("applies", Boolean.TRUE.equals(applies.get(k.getKey())));
          kr.put("on", !(off.containsKey(id) && off.get(id).contains(k.getKey())));
          kinds.add(kr);
        }
        r.put("kinds", kinds);
        rows.add(r);
      }
    } catch (Exception e) {
      e.printStackTrace();
      model.addAttribute("loadErr", true);
    } finally {
      DB.done(conn, ps, rs);
    }
    model.addAttribute("rows", rows);
    model.addAttribute("linkedCount", linked);
    return "/admin/telegram";
  }

  @RequestMapping(value = "/log.s", method = RequestMethod.POST)
  @ResponseBody
  protected String log(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    if (!isAdmin(req)) return Util.err(json, "Нет доступа");
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      conn = DB.getConnection();
      Tg.initTables(conn);
      ps = conn.prepareStatement(
        "Select l.sent_date, l.kind, l.text, l.ok, b.fio by_fio From Tg_Log l Left Join Users b On b.id = l.sent_by " +
        " Where l.user_id = ? Order By l.id Desc Limit 300");
      ps.setInt(1, Util.getInt(req, "user"));
      rs = ps.executeQuery();
      JSONArray list = new JSONArray();
      while (rs.next()) {
        JSONObject o = new JSONObject();
        o.put("date", Util.dateTimeToString(rs.getTimestamp("sent_date")));
        o.put("kind", rs.getString("kind"));
        o.put("kindName", Tg.kindName(rs.getString("kind")));
        o.put("text", Util.nvl(rs.getString("text")));
        o.put("ok", "Y".equals(rs.getString("ok")));
        o.put("by", Util.nvl(rs.getString("by_fio")));
        list.put(o);
      }
      json.put("rows", list);
      json.put("success", true);
    } catch (Exception e) {
      return Util.err(json, e.getMessage());
    } finally {
      DB.done(conn, ps, rs);
    }
    return json.toString();
  }

  @RequestMapping(value = "/toggle.s", method = RequestMethod.POST)
  @ResponseBody
  protected String toggle(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    if (!isAdmin(req)) return Util.err(json, "Нет доступа");
    String kind = Util.get(req, "kind");
    if (!Tg.KINDS.containsKey(kind)) return Util.err(json, "Неизвестный тип уведомления");
    Connection conn = null;
    try {
      conn = DB.getConnection();
      Tg.setOff(conn, Util.getInt(req, "user"), kind, !"Y".equals(Util.get(req, "on")));
      json.put("success", true);
    } catch (Exception e) {
      return Util.err(json, e.getMessage());
    } finally {
      DB.done(conn);
    }
    return json.toString();
  }

  @RequestMapping(value = "/send.s", method = RequestMethod.POST)
  @ResponseBody
  protected String send(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    if (!isAdmin(req)) return Util.err(json, "Нет доступа");
    String text = Util.nvl(req.getParameter("text")).trim();
    if (text.isEmpty()) return Util.err(json, "Введите текст сообщения");
    if (text.length() > 3500) return Util.err(json, "Слишком длинное сообщение");
    Connection conn = null;
    try {
      conn = DB.getConnection();
      if (!Tg.sendManual(conn, Util.getInt(req, "user"), text, SessionUtil.getUser(req).getUserId()))
        return Util.err(json, "Не удалось отправить: пользователь не подключил Telegram или заблокировал бота");
      json.put("success", true);
    } catch (Exception e) {
      return Util.err(json, e.getMessage());
    } finally {
      DB.done(conn);
    }
    return json.toString();
  }

  @RequestMapping(value = "/unlink.s", method = RequestMethod.POST)
  @ResponseBody
  protected String unlink(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    if (!isAdmin(req)) return Util.err(json, "Нет доступа");
    try {
      Tg.unlink(Util.getInt(req, "user"));
      json.put("success", true);
    } catch (Exception e) {
      return Util.err(json, e.getMessage());
    }
    return json.toString();
  }

  private boolean isAdmin(HttpServletRequest req) {
    Session session = SessionUtil.getUser(req);
    return session != null && (session.getRoleId() == 1 || session.getUserId() == 1);
  }
}
