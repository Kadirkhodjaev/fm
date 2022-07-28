package ckb.services.med.client;

import ckb.domains.admin.Clients;
import ckb.models.Grid;
import ckb.session.Session;
import ckb.utils.DB;

import java.sql.Connection;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class SClientImp implements SClient {

  @Override
  public long getCount(Session session, String sql) {
    Connection conn = null;
    ResultSet rs = null;
    try {
      conn = DB.getConnection();
      rs = conn.prepareStatement("Select Count(*) "+ sql).executeQuery();
      if(rs.next())
        return rs.getInt(1);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(conn);
    }
    return 0;
  }

  @Override
  public List<Clients> getGridList(Grid grid, Session session) {
    Connection conn = null;
    ResultSet rs = null;
    List<Clients> list = new ArrayList<Clients>();
    if(grid.getRowCount() == 0) return list;
    try {
      conn = DB.getConnection();
      String sql = "Select * From (Select t.* " + grid.getSql() + ") global Limit " + (grid.getStartPos() - 1) + "," + grid.getPageSize();
      rs = conn.prepareStatement(sql).executeQuery();
      while(rs.next()) {
        Clients c = new Clients();
        c.setId(rs.getInt("id"));
        c.setBirthdate(rs.getDate("birthdate"));
        c.setSurname(rs.getString("surname"));
        c.setName(rs.getString("name"));
        c.setTel(rs.getString("tel"));
        c.setMiddlename(rs.getString("middlename"));
        c.setCrOn(rs.getDate("crOn"));
        list.add(c);
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(conn);
    }
    return list;
  }
}
