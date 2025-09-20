package ckb.utils;

import ckb.dao.med.amb.DAmbGroup;
import ckb.dao.med.dicts.rooms.DRooms;
import ckb.domains.admin.Counteries;
import ckb.domains.admin.Depts;
import ckb.domains.admin.Regions;
import ckb.domains.med.amb.AmbGroups;
import ckb.domains.med.dicts.Rooms;
import org.springframework.beans.factory.annotation.Autowired;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BeanSession {

  @Autowired private DRooms dRoom;
  @Autowired private DAmbGroup dAmbGroup;

  private List<Depts> depts = new ArrayList<>();
  private List<AmbGroups> ambGroups = new ArrayList<>();
  private List<Counteries> counteries = new ArrayList<>();
  private List<Regions> regions = new ArrayList<>();
  private HashMap<String, String> params = new HashMap<>();
  private List<Rooms> rooms = new ArrayList<>();

  public void initialize() {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      conn = DB.getConnection();
      ps = conn.prepareStatement("Select * From Depts");
      rs = ps.executeQuery();
      while (rs.next()) {
        Depts a = new Depts();
        a.setId(rs.getInt("id"));
        a.setName(rs.getString("name"));
        a.setState(rs.getString("state"));
        depts.add(a);
      }
      ambGroups = dAmbGroup.getAll();
      ps = conn.prepareStatement("Select * From Counteries Order By ord, name");
      rs = ps.executeQuery();
      while (rs.next()) {
        Counteries a = new Counteries();
        a.setId(rs.getInt("id"));
        a.setName(rs.getString("name"));
        a.setCode(rs.getString("code"));
        counteries.add(a);
      }
      ps = conn.prepareStatement("Select * From Regions Order By ord, name");
      rs = ps.executeQuery();
      while (rs.next()) {
        Regions a = new Regions();
        a.setId(rs.getInt("id"));
        a.setName(rs.getString("name"));
        a.setCode(rs.getString("code"));
        regions.add(a);
      }
      ps = conn.prepareStatement("Select * From Params");
      rs = ps.executeQuery();
      while (rs.next()) {
        params.put(rs.getString("code"), rs.getString("val"));
      }
      rooms = dRoom.list("From Rooms");
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn, ps, rs);
    }
  }

  public List<Depts> getDepts() {
    return depts;
  }

  public List<AmbGroups> getAmbGroups() {
    return ambGroups;
  }

  public List<Counteries> getCounteries() {
    return counteries;
  }

  public List<Regions> getRegions() {
    return regions;
  }

  public String getParam(String code) {
    return params.get(code);
  }

  public List<Rooms> getRooms() {
    return rooms;
  }

  public Depts getDept(int id) {
    for(Depts d : depts) {
      if(d.getId() == id) {
        return d;
      }
    }
    return null;
  }

  public Double getNds() {
    return Double.parseDouble(params.get("NDS_PROC"));
  }

  public Map<String, String> getParams() {
    return params;
  }
}
