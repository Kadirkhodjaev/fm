package ckb.services.mo;

import ckb.dao.med.amb.DAmbPatientServices;
import ckb.grid.AmbGrid;
import ckb.models.AmbPatient;
import ckb.session.Session;
import ckb.utils.DB;
import ckb.utils.Util;
import org.springframework.beans.factory.annotation.Autowired;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class SAmbGridImp implements SAmbGrid {

  @Autowired private DAmbPatientServices dAmpPatientService;

  @Override
  public List<AmbPatient> rows(AmbGrid grid, Session session) {
    if(grid.getRowCount() == 0) return new ArrayList<>();
    List<AmbPatient> rows = new ArrayList<>();
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
        AmbPatient pat = new AmbPatient();
        pat.setId(rs.getInt("id"));
        pat.setFio(Util.nvl(rs.getString("surname")) + " " + Util.nvl(rs.getString("name")) + " " + Util.nvl(rs.getString("middlename")));
        pat.setIcon("green");
        String state = rs.getString("state");
        if("PRN".equals(state)) pat.setState("Регистрация");
        if("CASH".equals(state)) pat.setState("Ожидание оплаты");
        if("WORK".equals(state)) pat.setState("Оказания услуг");
        if("DONE".equals(state)) pat.setState("Услуги оказаны");
        if("ARCH".equals(state)) pat.setState("Закрыта");
        // Регистрация
        if(session.getRoleId() == 22 && rs.getString("state").equals("PRN")) pat.setIcon("red");
        // Услуги
        if(session.getRoleId() == 14) {
          if(dAmpPatientService.getCount("From AmbPatientServices Where state != 'DONE' And worker.id = " + session.getUserId() + " And patient = " + rs.getInt("id")) > 0)
            pat.setIcon("red");
        }
        // Касса
        if(session.getRoleId() == 13) {
          if(rs.getString("state").equals("CASH")) pat.setIcon("red");
          if(!rs.getString("state").equals("CASH"))
            if(dAmpPatientService.getCount("From AmbPatientServices Where state = 'ENT' And patient = " + rs.getInt("id")) > 0) {
              pat.setIcon("red");
              pat.setState("Ожидание оплаты");
            }
        }
        pat.setBirthdate(rs.getInt("birthyear") != 0 ? "" + rs.getInt("birthyear") : "");
        pat.setDateReg(Util.dateTimeToString(rs.getTimestamp("reg_date")));
        rows.add(pat);
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

  @Override
  public long rowCount(AmbGrid grid) {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      conn = DB.getConnection();
      // Кол-во записей
      ps = conn.prepareStatement("Select count(*)" + grid.select());
      rs = ps.executeQuery();
      if(rs.next()) return rs.getInt(1);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(conn);
    }
    return 0;
  }

}
