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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/mkb/")
public class CMkb {

  // The whole dictionary is read with one query and the tree is built in memory
  // (previously every node made its own query: thousands of queries per page open)
  private JSONArray loadTree(boolean isUser) throws Exception {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    List<String[]> roots = new ArrayList<String[]>();
    Map<String, List<String[]>> children = new HashMap<String, List<String[]>>();
    try {
      conn = DB.getConnection();
      ps = conn.prepareStatement("Select id, parent_id, name, additional_info, code, state From Mkb Order By id");
      rs = ps.executeQuery();
      while (rs.next()) {
        String[] row = {rs.getString("id"), rs.getString("parent_id"), rs.getString("name"), rs.getString("additional_info"), rs.getString("code"), rs.getString("state")};
        if (row[1] == null) {
          roots.add(row);
        } else {
          List<String[]> l = children.get(row[1]);
          if (l == null) children.put(row[1], l = new ArrayList<String[]>());
          l.add(row);
        }
      }
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(conn);
    }
    JSONArray list = new JSONArray();
    for (String[] root : roots) {
      list.put(mkbNode(root, !isUser));
      addChildren(list, children, root[0], isUser);
    }
    return list;
  }

  private void addChildren(JSONArray list, Map<String, List<String[]>> children, String parent, boolean isUser) throws JSONException {
    List<String[]> l = children.get(parent);
    if (l == null) return;
    for (String[] row : l) {
      list.put(mkbNode(row, !isUser));
      if (!isUser || "A".equals(row[5]))
        addChildren(list, children, row[0], isUser);
    }
  }

  private JSONObject mkbNode(String[] row, boolean withState) throws JSONException {
    JSONObject obj = new JSONObject();
    obj.put("id", "padre" + row[0]);
    obj.put("parent", row[1] == null ? "#" : "padre" + row[1]);
    obj.put("text", row[2]);
    obj.put("info", row[3]);
    obj.put("code", row[4]);
    if (withState) {
      JSONObject state = new JSONObject();
      state.put("selected", "A".equals(row[5]));
      obj.put("state", state);
    }
    return obj;
  }

  @RequestMapping("index.s")
  public String home(Model m){
    try {
      m.addAttribute("mkb", loadTree(true).toString());
    } catch (Exception e) {
      e.printStackTrace();
    }
    return "/med/mkb/index";
  }

  @RequestMapping("admin.s")
  public String admin(HttpServletRequest req, Model m){
    Session session = SessionUtil.getUser(req);
    try {
      session.setCurUrl("/mkb/admin.s");
      m.addAttribute("mkb", loadTree(false).toString());
      m.addAttribute("sel", Util.get(req, "sel", "0").replaceAll("[^0-9]", ""));
    } catch (Exception e) {
      e.printStackTrace();
    }
    return "/med/mkb/admin";
  }

  /** Все потомки узла (в порядке обхода сверху вниз); дерево читается одним запросом */
  private List<Integer> descendants(Connection conn, int id) throws Exception {
    PreparedStatement ps = null;
    ResultSet rs = null;
    Map<Integer, List<Integer>> children = new HashMap<Integer, List<Integer>>();
    try {
      ps = conn.prepareStatement("Select id, parent_id From Mkb Where parent_id Is Not Null");
      rs = ps.executeQuery();
      while (rs.next()) {
        List<Integer> l = children.get(rs.getInt("parent_id"));
        if (l == null) children.put(rs.getInt("parent_id"), l = new ArrayList<Integer>());
        l.add(rs.getInt("id"));
      }
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
    List<Integer> res = new ArrayList<Integer>();
    List<Integer> queue = new ArrayList<Integer>();
    queue.add(id);
    for (int i = 0; i < queue.size(); i++) {
      List<Integer> l = children.get(queue.get(i));
      if (l == null) continue;
      for (Integer c : l) if (!res.contains(c)) { res.add(c); queue.add(c); }
    }
    return res;
  }

  @RequestMapping(value = "del.s", method = RequestMethod.POST)
  @ResponseBody
  protected String del(HttpServletRequest req) throws JSONException {
    Connection conn = null;
    PreparedStatement ps = null;
    JSONObject json = new JSONObject();
    try {
      int id = Util.getInt(req, "id");
      conn = DB.getConnection();
      List<Integer> ids = descendants(conn, id);
      ids.add(0, id);
      ps = conn.prepareStatement("Delete From Mkb Where id = ?");
      // снизу вверх: сначала самые глубокие узлы
      for (int i = ids.size() - 1; i >= 0; i--) {
        ps.setInt(1, ids.get(i));
        ps.executeUpdate();
      }
      json.put("success", true);
      json.put("count", ids.size());
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    } finally {
      DB.done(ps);
      DB.done(conn);
    }
    return json.toString();
  }

  @RequestMapping(value = "search.s", method = RequestMethod.POST)
  @ResponseBody
  protected String search(HttpServletRequest req) throws JSONException {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    JSONObject json = new JSONObject();
    JSONArray list = new JSONArray();
    try {
      String q = Util.get(req, "q");
      if(q != null && q.trim().length() >= 2) {
        String like = "%" + q.trim().toUpperCase() + "%";
        conn = DB.getConnection();
        ps = conn.prepareStatement(
          "Select t.id, t.code, t.name From Mkb t " +
          " Where t.state = 'A' " +
          "   And (Upper(t.code) Like ? Or Upper(t.name) Like ?) " +
          "   And Not Exists (Select 1 From Mkb c Where c.parent_id = t.id) " +
          " Order By t.code Limit 30");
        ps.setString(1, like);
        ps.setString(2, like);
        rs = ps.executeQuery();
        while (rs.next()) {
          JSONObject obj = new JSONObject();
          obj.put("id", rs.getInt("id"));
          obj.put("code", rs.getString("code"));
          obj.put("name", rs.getString("name"));
          list.put(obj);
        }
      }
      json.put("rows", list);
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

  @RequestMapping(value = "save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String save(HttpServletRequest req) throws JSONException {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    JSONObject json = new JSONObject();
    try {
      String name = Util.get(req, "name", "").trim();
      String code = Util.get(req, "code", "").trim();
      String info = Util.get(req, "info", "").trim();
      String state = "P".equals(Util.get(req, "state")) ? "P" : "A";
      if (code.isEmpty() || name.isEmpty()) {
        json.put("success", false);
        json.put("msg", "Укажите код и наименование");
        return json.toString();
      }
      if (code.length() > 20) code = code.substring(0, 20);
      if (name.length() > 512) name = name.substring(0, 512);
      conn = DB.getConnection();
      int id;
      if (Util.isNull(req, "id")) {
        String parent = Util.get(req, "parent_id", "").replaceAll("[^0-9]", "");
        ps = conn.prepareStatement("Insert Into Mkb(parent_id, name, code, additional_info, state) Values (?, ?, ?, ?, ?)", java.sql.Statement.RETURN_GENERATED_KEYS);
        if (parent.isEmpty() || parent.equals("0")) ps.setNull(1, java.sql.Types.INTEGER);
        else ps.setInt(1, Integer.parseInt(parent));
        ps.setString(2, name);
        ps.setString(3, code);
        ps.setString(4, info.isEmpty() ? null : info);
        ps.setString(5, state);
        ps.executeUpdate();
        rs = ps.getGeneratedKeys();
        id = rs.next() ? rs.getInt(1) : 0;
      } else {
        id = Util.getInt(req, "id");
        ps = conn.prepareStatement("Update Mkb Set name = ?, code = ?, additional_info = ?, state = ? Where id = ?");
        ps.setString(1, name);
        ps.setString(2, code);
        ps.setString(3, info.isEmpty() ? null : info);
        ps.setString(4, state);
        ps.setInt(5, id);
        ps.executeUpdate();
        DB.done(ps);
        // состояние раздела переходит на все вложенные узлы
        List<Integer> ids = descendants(conn, id);
        ps = conn.prepareStatement("Update Mkb Set state = ? Where id = ?");
        for (Integer c : ids) {
          ps.setString(1, state);
          ps.setInt(2, c);
          ps.executeUpdate();
        }
      }
      json.put("success", true);
      json.put("id", id);
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

}
