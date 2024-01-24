package ckb.services.med.client;

import ckb.dao.admin.countery.DCountry;
import ckb.dao.admin.forms.opts.DOpt;
import ckb.dao.admin.region.DRegion;
import ckb.domains.admin.Clients;
import ckb.grid.ClientGrid;
import ckb.models.Client;
import ckb.models.Grid;
import ckb.session.Session;
import ckb.utils.DB;
import ckb.utils.Util;
import org.springframework.beans.factory.annotation.Autowired;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class SClientImp implements SClient {

  @Autowired private DCountry dCountry;
  @Autowired private DRegion dRegion;
  @Autowired private DOpt dOpt;

  @Override
  public long getCount(String sql) {
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

  @Override
  public List<Client> rows(ClientGrid grid, Session session) {
    if(grid.getRowCount() == 0) return new ArrayList<>();
    List<Client> rows = new ArrayList<>();
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      conn = DB.getConnection();
      //
      String sql = "Select * From (Select * " + grid.select() + ") global Limit " + (grid.getStartPos() - 1) + "," + grid.getPageSize();
      ps = conn.prepareStatement(sql);
      rs = ps.executeQuery();
      while(rs.next()) {
        Client obj = new Client();
        obj.setId(rs.getInt("id"));
        obj.setFio(Util.nvl(rs.getString("surname")) + " " + Util.nvl(rs.getString("name")) + " " + Util.nvl(rs.getString("middlename")));
        obj.setBirthdate(Util.dateToString(rs.getDate("birthdate")));
        obj.setCountry(rs.getString("country_id") == null ? "" : dCountry.get(rs.getInt("country_id")).getName());
        obj.setRegion(rs.getString("region_id") == null ? "" : dRegion.get(rs.getInt("region_id")).getName());
        obj.setSex(rs.getString("sex_id") == null ? "" : dOpt.get(rs.getInt("sex_id")).getName());
        obj.setDocSeria(rs.getString("docSeria"));
        obj.setDocNum(rs.getString("docNum"));
        obj.setTel(rs.getString("tel"));
        obj.setDateReg(Util.dateTimeToString(rs.getTimestamp("cron")));
        rows.add(obj);
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(conn);
    }
    return rows;
  }
}
