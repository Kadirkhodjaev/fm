package ckb.services.mo.amb;

import ckb.dao.admin.countery.DCountry;
import ckb.dao.admin.region.DRegion;
import ckb.dao.med.amb.DAmbPatient;
import ckb.dao.med.amb.DAmbPatientService;
import ckb.dao.med.amb.DAmbService;
import ckb.dao.med.amb.DAmbServiceUsers;
import ckb.domains.med.amb.AmbPatientServices;
import ckb.domains.med.amb.AmbPatients;
import ckb.domains.med.amb.AmbServices;
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
import java.util.Date;
import java.util.List;

public class SMoAmbImp implements SMoAmb {

  @Autowired private DAmbPatient dAmbPatient;
  @Autowired private DAmbServiceUsers dAmbServiceUser;
  @Autowired private DAmbPatientService dAmpPatientService;
  @Autowired private DAmbService dAmbService;
  @Autowired private DCountry dCountry;
  @Autowired private DRegion dRegion;

  @Override
  public List<AmbPatient> gridRows(AmbGrid grid, Session session) {
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
        if(session.getRoleId() == 23) {
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
        pat.setPaySum(rs.getDouble("paySum"));
        pat.setTel(rs.getString("tel"));
        pat.setCountry(rs.getString("counteryid") == null ? "" : dCountry.get(rs.getInt("counteryid")).getName());
        pat.setRegion(rs.getString("regionid") == null ? "" : dRegion.get(rs.getInt("regionid")).getName());
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
  public long gridRowCount(AmbGrid grid) {
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

  @Override
  public int createPatientServiceId(int patient, int service, int user, int treatment) {
    AmbPatients pat = dAmbPatient.get(patient);
    AmbPatientServices ser = new AmbPatientServices();
    AmbServices s = dAmbService.get(service);
    ser.setCrBy(user);
    ser.setCrOn(new Date());
    ser.setPatient(pat.getId());
    ser.setService(s);
    ser.setPrice(pat.isResident() ? s.getPrice() : s.getFor_price());
    ser.setState("ENT");
    ser.setPlanDate(new Date());
    ser.setResult(0);
    ser.setAmb_repeat("N");
    ser.setWorker(dAmbServiceUser.getFirstUser(s.getId()));
    ser.setTreatmentId(treatment);
    dAmpPatientService.saveAndReturn(ser);
    if("DONE".equals(pat.getState())) {
      pat.setPaySum(pat.getPaySum() + ser.getPrice());
      pat.setState("WORK");
      dAmbPatient.save(pat);
    }
    return ser.getId();
  }
  @Override
  public void createPatientService(int patient, int service, int user) {
    int id = createPatientServiceId(patient, service, user, 0);
  }

}
