package ckb.controllers.med;

import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.DB;
import ckb.utils.Util;
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

@Controller
@RequestMapping("/mkb/")
public class CMkb {

  private void buildMkb(Connection conn, JSONArray list, Integer parent, boolean isUser) {
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      ps = conn.prepareStatement("Select * From Mkb Where parent_id = " + parent);
      ps.execute();
      rs = ps.getResultSet();
      while (rs.next()) {
        JSONObject obj = new JSONObject();
        obj.put("id", "padre" + rs.getString("id"));
        obj.put("parent", rs.getString("parent_id") == null ? "#" : "padre" + rs.getString("parent_id"));
        obj.put("text", rs.getString("name"));
        obj.put("info", rs.getString("additional_info"));
        obj.put("code", rs.getString("code"));
        if(!isUser) {
          JSONObject state = new JSONObject();
          state.put("selected", rs.getString("state").equals("A"));
          obj.put("state", state);
        }
        list.put(obj);
        if(isUser && "A".equals(rs.getString("state")))
          buildMkb(conn, list, rs.getInt("id"), isUser);
        else if (!isUser)
          buildMkb(conn, list, rs.getInt("id"), isUser);
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
  }

  @RequestMapping("index.s")
  public String home(Model m){
    JSONArray list = new JSONArray();
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      conn = DB.getConnection();
      ps = conn.prepareStatement("Select * From Mkb Where parent_id is null");
      ps.execute();
      rs = ps.getResultSet();
      while (rs.next()) {
        JSONObject obj = new JSONObject();
        obj.put("id", "padre" + rs.getString("id"));
        obj.put("parent", rs.getString("parent_id") == null ? "#" : "padre" + rs.getString("parent_id"));
        obj.put("text", rs.getString("name"));
        obj.put("info", rs.getString("additional_info"));
        obj.put("code", rs.getString("code"));
        list.put(obj);
        buildMkb(conn, list, rs.getInt("id"), true);
      }
      m.addAttribute("mkb", list.toString());
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(conn);
    }
    return "/med/mkb/index";
  }

  @RequestMapping("admin.s")
  public String admin(HttpServletRequest req, Model m){
    Session session = SessionUtil.getUser(req);
    JSONArray list = new JSONArray();
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      conn = DB.getConnection();
      session.setCurUrl("/mkb/admin.s");
      ps = conn.prepareStatement("Select * From Mkb Where parent_id is null");
      ps.execute();
      rs = ps.getResultSet();
      while (rs.next()) {
        JSONObject obj = new JSONObject();
        obj.put("id", "padre" + rs.getString("id"));
        obj.put("parent", rs.getString("parent_id") == null ? "#" : "padre" + rs.getString("parent_id"));
        obj.put("text", rs.getString("name"));
        obj.put("info", rs.getString("additional_info"));
        obj.put("code", rs.getString("code"));
        JSONObject state = new JSONObject();
        state.put("selected", rs.getString("state").equals("A"));
        obj.put("state", state);
        list.put(obj);
        buildMkb(conn, list, rs.getInt("id"), false);
      }
      m.addAttribute("mkb", list.toString());
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(conn);
    }
    return "/med/mkb/admin";
  }

  private void delMkb(Connection conn, Integer id) {
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      ps = conn.prepareStatement("Select * From Mkb Where parent_id = " + id);
      ps.execute();
      rs = ps.getResultSet();
      while (rs.next()) delMkb(conn, rs.getInt("id"));
      ps = conn.prepareStatement("Delete From Mkb Where parent_id = " + id);
      ps.execute();
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
  }

  @RequestMapping(value = "del.s", method = RequestMethod.POST)
  @ResponseBody
  protected String del(HttpServletRequest req) throws JSONException {
    Connection conn = null;
    PreparedStatement ps = null;
    JSONObject json = new JSONObject();
    try {
      conn = DB.getConnection();
      delMkb(conn, Util.getInt(req, "id"));
      ps = conn.prepareStatement("Delete From Mkb Where id = " + Util.getInt(req, "id"));
      ps.execute();
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    } finally {
      DB.done(ps);
      DB.done(conn);
    }
    return json.toString();
  }

  @RequestMapping(value = "get.s", method = RequestMethod.POST)
  @ResponseBody
  protected String get(HttpServletRequest req) throws JSONException {
    Connection conn = null;
    PreparedStatement ps =  null;
    ResultSet rs = null;
    JSONObject json = new JSONObject();
    try {
      conn = DB.getConnection();
      ps = conn.prepareStatement("Select * From Mkb Where id = " + Util.getInt(req, "id"));
      rs = ps.executeQuery();
      if(rs.next()) {
        json.put("id", rs.getInt("id"));
        json.put("code", rs.getString("code"));
        json.put("name", rs.getString("name"));
        json.put("info", rs.getString("additional_info"));
        json.put("state", rs.getString("state"));
      }
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

  private void setChildState(Connection conn, Integer id, String state) {
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      ps = conn.prepareStatement("Select * From Mkb Where parent_id = " + id);
      ps.execute();
      rs = ps.getResultSet();
      while (rs.next()) {
        ps = conn.prepareStatement("Update Mkb Set state = ? Where id = ?");
        ps.setString(1, state);
        ps.setInt(2, rs.getInt("id"));
        ps.execute();
        setChildState(conn, rs.getInt("id"), state);
      }
      ps = conn.prepareStatement("Update Mkb Set state = ? Where parent_id = ?");
      ps.setString(1, state);
      ps.setInt(2, id);
      ps.execute();
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
  }

  @RequestMapping(value = "save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String save(HttpServletRequest req) throws JSONException {
    Connection conn = null;
    PreparedStatement ps = null;
    JSONObject json = new JSONObject();
    try {
      conn = DB.getConnection();
      if(Util.isNull(req, "id")) {
        ps = conn.prepareStatement("Insert Into Mkb(parent_id, name, code, additional_info, state) Values (?, ?, ?, ?, ?)");
        ps.setInt(1, Util.getInt(req, "parent_id"));
        ps.setString(2, Util.get(req, "name"));
        ps.setString(3, Util.get(req, "code"));
        ps.setString(4, Util.get(req, "info"));
        ps.setString(5, Util.isNotNull(req, "state") ? "A" : "P");
        ps.execute();
      } else {
        ps = conn.prepareStatement("Update Mkb Set name = ?, code = ?, additional_info = ?, state = ? Where id = ?");
        ps.setString(1, Util.get(req, "name"));
        ps.setString(2, Util.get(req, "code"));
        ps.setString(3, Util.get(req, "info"));
        ps.setString(4, Util.isNotNull(req, "state") ? "A" : "P");
        ps.setInt(5, Util.getInt(req, "id"));
        ps.execute();
        setChildState(conn, Util.getInt(req, "id"), Util.isNotNull(req, "state") ? "A" : "P");
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    } finally {
      DB.done(ps);
      DB.done(conn);
    }
    return json.toString();
  }

}
