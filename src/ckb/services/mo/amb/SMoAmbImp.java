package ckb.services.mo.amb;

import ckb.dao.admin.country.DCountry;
import ckb.dao.admin.region.DRegion;
import ckb.dao.med.amb.*;
import ckb.dao.med.amb.form.DAmbForm;
import ckb.dao.med.amb.form.DAmbFormField;
import ckb.dao.med.amb.form.DAmbFormFieldNorma;
import ckb.dao.med.amb.form.DAmbFormFieldOption;
import ckb.dao.med.cashbox.discount.DCashDiscount;
import ckb.domains.med.amb.*;
import ckb.grid.AmbGrid;
import ckb.models.AmbPatient;
import ckb.models.amb.AmbFormField;
import ckb.models.amb.AmbFormFieldNorma;
import ckb.models.amb.AmbFormFieldRow;
import ckb.session.Session;
import ckb.utils.DB;
import ckb.utils.Util;
import org.springframework.beans.factory.annotation.Autowired;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Arrays;
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
  @Autowired private DAmbForm dAmbForm;
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
  public List<AmbFormFieldRow> serviceFields(Integer service, Integer form) {
    if(form == null) {
      form = dAmbForm.maxForm(service);
    }
    Integer maxCol = dAmbFormField.getMaxCol(service, form);
    Integer maxRow = dAmbFormField.getMaxRow(service, form);
    List<AmbFormFieldRow> rows = new ArrayList<>();
    for(int r=1;r<=maxRow;r++) {
      AmbFormFieldRow row = new AmbFormFieldRow();
      List<AmbFormField> fields = new ArrayList<>();
      for(int c=1;c<=maxCol;c++) {
        List<AmbFormFields> fs = dAmbFormField.list("From AmbFormFields Where form = " + form + " And service = " + service + " And col = " + c + " And row = " + r);
        for(AmbFormFields field: fs) {
          AmbFormField f = getServiceField(field.getId());
          //
          if(row.getName() == null) {
            row.setId(f.getId());
            row.setName(f.getFieldLabel());
            row.setTypeCode(f.getTypeCode());
            row.setCode(Util.nvl(f.getCode(), ""));
            row.setFieldName(f.getFieldName());
            row.setNorma("");
            if(f.getTypeCode().contains("_norm")) {
              if(f.getNormaType().equals("all")) {
                if(f.getNormaFrom() != null && f.getNormaTo() != null)
                  row.setNorma(f.getNormaFrom() + " - " + f.getNormaTo());
              }
              if(f.getNormaType().equals("sex_norm")) {
                row.setNorma("М: " + f.getMaleNormaFrom() + " - " + f.getMaleNormaTo() + "<br/>" + "Ж: " + f.getFemaleNormaFrom() + " - " + f.getFemaleNormaTo());
              }
              if(f.getNormaType().equals("year_norm")) {
                for(AmbFormFieldNorma n: f.getNormas()) {
                  row.setNorma(row.getNorma() + n.getYearFrom() + " - " + n.getYearTo() + " лет: " + n.getNormaFrom() + " - " + n.getNormaTo() + "<br/>");
                }
              }
              if(f.getNormaType().equals("sex_year_norm")) {
                for(AmbFormFieldNorma n: f.getNormas()) {
                  row.setNorma(row.getNorma() + (n.getSex().equals("male") ? "М" : "Ж") + ": " + n.getYearFrom() + " - " + n.getYearTo() + " лет: " + n.getNormaFrom() + " - " + n.getNormaTo() + "<br/>");
                }
              }
              if(f.getNormaType().equals("cat_norm")) {
                for(AmbFormFieldNorma n: f.getNormas()) {
                  row.setNorma(row.getNorma() + ": " + n.getCatName() + ": " + n.getNormaFrom() + " - " + n.getNormaTo() + "<br/>");
                }
              }
              if(f.getNormaType().equals("cat_sex_norm")) {
                for(AmbFormFieldNorma n: f.getNormas()) {
                  row.setNorma(row.getNorma() + (n.getSex().equals("male") ? "М" : "Ж") + ": " + n.getCatName() + ": " + n.getNormaFrom() + " - " + n.getNormaTo() + "<br/>");
                }
              }
            }
            row.setEi(Util.nvl(f.getEi(), ""));
          }
          //
          fields.add(f);
        }
      }
      if(!fields.isEmpty()) {
        row.setFields(fields);
        rows.add(row);
      }
    }
    return rows;
  }

  @Override
  public AmbFormField getServiceField(int id) {
    AmbFormField f = new AmbFormField();
    AmbFormFields field = dAmbFormField.get(id);
    f.setId(field.getId());
    f.setService(field.getService());
    f.setForm(field.getForm());
    f.setCode(field.getCode());
    f.setFieldName(field.getFieldName());
    f.setFieldLabel(field.getFieldLabel());
    f.setTypeCode(field.getTypeCode());
    f.setOrd(field.getOrd());
    List<String> listTypes = Arrays.asList("sex_year_norm", "year_norm", "cat_norm", "cat_sex_norm");
    if(f.getTypeCode().contains("_norm")) {
      f.setNormaType(field.getNormaType());
      f.setEi(field.getEi());
      if(f.getNormaType() != null && f.getNormaType().equals("all")) {
        List<AmbFormFieldNormas> normas = dAmbFormFieldNorma.list(" From AmbFormFieldNormas Where field = " + f.getId() + " And normType = 'all'");
        if(normas != null && !normas.isEmpty()) {
          f.setNormaId(normas.get(0).getId());
          f.setNormaFrom(normas.get(0).getNormaFrom());
          f.setNormaTo(normas.get(0).getNormaTo());
        }
      }
      if(f.getNormaType() != null && f.getNormaType().equals("sex_norm")) {
        List<AmbFormFieldNormas> maleNorm = dAmbFormFieldNorma.list(" From AmbFormFieldNormas Where field = " + f.getId() + " And normType = 'sex_norm' And sex = 'male'");
        if(maleNorm != null && !maleNorm.isEmpty()) {
          f.setMaleNormaId(maleNorm.get(0).getId());
          f.setMaleNormaFrom(maleNorm.get(0).getNormaFrom());
          f.setMaleNormaTo(maleNorm.get(0).getNormaTo());
        }
        List<AmbFormFieldNormas> femaleNorm = dAmbFormFieldNorma.list(" From AmbFormFieldNormas Where field = " + f.getId() + " And normType = 'sex_norm' And sex = 'female'");
        if(femaleNorm != null && !femaleNorm.isEmpty()) {
          f.setFemaleNormaId(femaleNorm.get(0).getId());
          f.setFemaleNormaFrom(femaleNorm.get(0).getNormaFrom());
          f.setFemaleNormaTo(femaleNorm.get(0).getNormaTo());
        }
      }
      if(f.getNormaType() != null && listTypes.contains(f.getNormaType())) {
        List<AmbFormFieldNormas> normas = dAmbFormFieldNorma.list(" From AmbFormFieldNormas Where field = " + f.getId() + " And normType = '" + f.getNormaType() + "'");
        List<AmbFormFieldNorma> nms = new ArrayList<>();
        for(AmbFormFieldNormas n: normas) {
          AmbFormFieldNorma a = new AmbFormFieldNorma();
          a.setId(n.getId());
          a.setSex(n.getSex());
          a.setCatName(n.getCatName());
          a.setYearFrom(n.getYearFrom());
          a.setYearTo(n.getYearTo());
          a.setNormaFrom(n.getNormaFrom());
          a.setNormaTo(n.getNormaTo());
          a.setNormType(n.getNormType());
          nms.add(a);
        }
        f.setNormas(nms);
      }
    }
    f.setOptions(dAmbFormFieldOption.list("From AmbFormFieldOptions Where field = " + f.getId()));
    return f;
  }

}
