package ckb.services.mo.amb;

import ckb.dao.admin.country.DCountry;
import ckb.dao.admin.region.DRegion;
import ckb.dao.med.amb.*;
import ckb.dao.med.amb.form.DAmbFormField;
import ckb.dao.med.amb.form.DAmbFormFieldNorma;
import ckb.dao.med.amb.form.DAmbFormFieldOption;
import ckb.dao.med.cashbox.discount.DCashDiscount;
import ckb.domains.med.amb.*;
import ckb.grid.AmbGrid;
import ckb.models.AmbPatient;
import ckb.models.amb.AmbFormField;
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
  @Autowired private DAmbServiceUser dAmbServiceUser;
  @Autowired private DAmbPatientService dAmpPatientService;
  @Autowired private DAmbService dAmbService;
  @Autowired private DCountry dCountry;
  @Autowired private DRegion dRegion;
  @Autowired private DAmbPatientService dAmbPatientService;
  @Autowired private DCashDiscount dCashDiscount;
  @Autowired private DAmbPatientPay dAmbPatientPay;
  @Autowired private DAmbFormField dAmbFormField;
  @Autowired private DAmbFormFieldNorma dAmbFormFieldNorma;
  @Autowired private DAmbFormFieldOption dAmbFormFieldOption;

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
        if("PRN".equals(state)) pat.setState("�����������");
        if("CASH".equals(state)) pat.setState("�������� ������");
        if("WORK".equals(state)) pat.setState("�������� �����");
        if("DONE".equals(state)) pat.setState("������ �������");
        if("ARCH".equals(state)) pat.setState("�������");
        // �����������
        if(session.getRoleId() == 22 && rs.getString("state").equals("PRN")) pat.setIcon("red");
        // ������
        if(session.getRoleId() == 23) {
          if(dAmpPatientService.getCount("From AmbPatientServices Where state != 'DONE' And worker.id = " + session.getUserId() + " And patient = " + rs.getInt("id")) > 0)
            pat.setIcon("red");
        }
        // �����
        if(session.getRoleId() == 13) {
          if(rs.getString("state").equals("CASH")) pat.setIcon("red");
          if(!rs.getString("state").equals("CASH"))
            if(dAmpPatientService.getCount("From AmbPatientServices Where state = 'ENT' And patient = " + rs.getInt("id")) > 0) {
              pat.setIcon("red");
              pat.setState("�������� ������");
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
      // ���-�� �������
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

  @Override
  public void updatePaySum(Integer patient) {
    AmbPatients pat = dAmbPatient.get(patient);
    List<AmbPatientServices> sers = dAmbPatientService.list("From AmbPatientServices t Where t.patient = " + patient);
    double summ = 0;
    for(AmbPatientServices ser: sers) {
      summ += ser.getPrice();
    }
    Double discount = dCashDiscount.patientAmbDiscountSum(patient);
    Double paid = dAmbPatientPay.paidSum(patient);
    pat.setPaySum(summ - paid - discount);
    dAmbPatient.save(pat);
  }

  @Override
  public List<AmbFormField> serviceFields(Integer service) {
    List<AmbFormFields> fields = dAmbFormField.list("From AmbFormFields Where service = " + service);
    List<AmbFormField> rows = new ArrayList<>();
    for(AmbFormFields field: fields) {
      AmbFormField f = new AmbFormField();
      f.setId(field.getId());
      f.setService(service);
      f.setFieldName(field.getFieldName());
      f.setFieldLabel(field.getFieldLabel());
      f.setTypeCode(field.getTypeCode());
      f.setEi(field.getEi());
      f.setOrd(field.getOrd());
      f.setNormaType(field.getNormaType());
      if(f.getNormaType() != null && f.getNormaType().equals("all")) {
        List<AmbFormFieldNormas> normas = dAmbFormFieldNorma.list(" From AmbFormFieldNormas Where field = " + f.getId() + " And sex = 'all'");
        if(normas != null && !normas.isEmpty()) {
          f.setNormaId(normas.get(0).getId());
          f.setNormaFrom(normas.get(0).getNormaFrom());
          f.setNormaTo(normas.get(0).getNormaTo());
        }
      }
      if(f.getNormaType() != null && f.getNormaType().equals("sex_norm")) {
        List<AmbFormFieldNormas> maleNorm = dAmbFormFieldNorma.list(" From AmbFormFieldNormas Where field = " + f.getId() + " And sex = 'male'");
        if(maleNorm != null && !maleNorm.isEmpty()) {
          f.setMaleNormaId(maleNorm.get(0).getId());
          f.setMaleNormaFrom(maleNorm.get(0).getNormaFrom());
          f.setMaleNormaTo(maleNorm.get(0).getNormaTo());
        }
        List<AmbFormFieldNormas> femaleNorm = dAmbFormFieldNorma.list(" From AmbFormFieldNormas Where field = " + f.getId() + " And sex = 'female'");
        if(femaleNorm != null && !femaleNorm.isEmpty()) {
          f.setFemaleNormaId(femaleNorm.get(0).getId());
          f.setFemaleNormaFrom(femaleNorm.get(0).getNormaFrom());
          f.setFemaleNormaTo(femaleNorm.get(0).getNormaTo());
        }
      }
      f.setOptions(dAmbFormFieldOption.list("From AmbFormFieldOptions Where field = " + f.getId()));
      //
      rows.add(f);
    }
    return rows;
  }

}
