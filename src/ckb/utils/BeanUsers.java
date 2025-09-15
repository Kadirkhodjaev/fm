package ckb.utils;

import ckb.domains.admin.Users;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class BeanUsers {

  private List<Users> users = new ArrayList<>();
  private List<Users> lvs = new ArrayList<>();
  private List<Users> consuls = new ArrayList<>();
  private HashMap<Integer, Users> zavlvs = new HashMap<>();

  private Users glb;
  private Users boss;
  private Users glavbuh;

  public void initialize() {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      conn = DB.getConnection();
      ps = conn.prepareStatement("Select * From Users Order By fio");
      rs = ps.executeQuery();
      while (rs.next()) {
        Users a = new Users();
        a.setId(rs.getInt("id"));
        a.setFio(rs.getString("fio"));
        if(rs.getInt("dept_id") > 0 && rs.getInt("lv") > 0 && rs.getInt("id") != 1) {
          lvs.add(a);
        }
        if(rs.getInt("dept_id") > 0 && rs.getInt("zavlv") > 0 && rs.getInt("id") != 1) {
          zavlvs.put(rs.getInt("dept_id"), a);
        }
        if(rs.getInt("consul") > 0 && rs.getInt("active") > 0) {
          consuls.add(a);
        }
        if(rs.getInt("glb") > 0) glb = a;
        if(rs.getInt("boss") > 0) boss = a;
        if(rs.getInt("glavbuh") > 0) glavbuh = a;
        users.add(a);
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(conn);
    }
  }

  public List<Users> getUsers() {
    return users;
  }
  public void setUsers(List<Users> users) {
    this.users = users;
  }

  public List<Users> getLvs() {
    return lvs;
  }

  public void setLvs(List<Users> lvs) {
    this.lvs = lvs;
  }

  public List<Users> getConsuls() {
    return consuls;
  }

  public void setConsuls(List<Users> consuls) {
    this.consuls = consuls;
  }

  public Users getZavLvs(int dept) {
    return zavlvs.get(dept);
  }

  public Users getGlb() {
    return glb;
  }

  public Users getBoss() {
    return boss;
  }

  public Users getGlavbuh() {
    return glavbuh;
  }
}
