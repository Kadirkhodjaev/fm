package ckb.services.med.amb;

import ckb.dao.admin.dicts.DLvPartner;
import ckb.dao.admin.forms.fields.DFormField;
import ckb.dao.admin.forms.opts.DOpt;
import ckb.dao.med.amb.*;
import ckb.dao.med.client.DClient;
import ckb.domains.admin.Clients;
import ckb.domains.admin.FormFields;
import ckb.domains.med.amb.*;
import ckb.models.AmbService;
import ckb.models.FormField;
import ckb.models.Grid;
import ckb.models.PatientList;
import ckb.models.drugs.PatientDrug;
import ckb.models.drugs.PatientDrugDate;
import ckb.models.drugs.PatientDrugRow;
import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.DB;
import ckb.utils.Req;
import ckb.utils.Util;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;

import javax.servlet.http.HttpServletRequest;
import java.sql.Connection;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class SAmpImp implements SAmb {

  @Autowired private DAmbPatient dAmpPatients;
  @Autowired private DAmbPatientService dAmpPatientServices;
  @Autowired private DAmbPatientLinks dAmbPatientLinks;
  @Autowired private DOpt dOpt;
  @Autowired private DAmbServiceField dAmbServiceFields;
  @Autowired private DAmbPatient dAmbPatients;
  @Autowired private DAmbPatientService dAmbPatientServices;
  @Autowired private DAmbResult dAmbResults;
  @Autowired private DFormField dFormField;
  @Autowired private DLvPartner dLvPartner;
  @Autowired private DAmbDrug dAmbDrug;
  @Autowired private DAmbDrugRow dAmbDrugRow;
  @Autowired private DAmbDrugDate dAmbDrugDate;
  @Autowired private DClient dClient;

  @Override
  public List<PatientList> getGridList(Grid grid, Session session) {
    Connection conn = null;
    ResultSet rs = null;
    List<PatientList> list = new ArrayList<PatientList>();
    if(grid.getRowCount() == 0)
      return list;
    try {
      conn = DB.getConnection();
      String sql = "Select * From (Select * " + grid.getSql() + ") global Limit " + (grid.getStartPos() - 1) + "," + grid.getPageSize();
      rs = conn.prepareStatement(sql).executeQuery();
      while(rs.next()) {
        PatientList pat = new PatientList();
        pat.setIconUrl("green");
        // Амбулаторная регистрация
        if(session.getRoleId() == 15 && rs.getString("state").equals("PRN")) pat.setIconUrl("red");
        // Услуги
        if(session.getRoleId() == 14) {
          if(dAmpPatientServices.getCount("From AmbPatientServices Where state != 'DONE' And worker.id = " + session.getUserId() + " And patient = " + rs.getInt("id")) > 0)
            pat.setIconUrl("red");
        }
        String state = rs.getString("state");
        if("PRN".equals(state)) pat.setMetka("Регистрация");
        if("CASH".equals(state)) pat.setMetka("Ожидание оплаты");
        if("WORK".equals(state)) pat.setMetka("Оказания услуг");
        if("DONE".equals(state)) pat.setMetka("Услуги оказаны");
        if("ARCH".equals(state)) pat.setMetka("Закрыта");
        // Касса
        if(session.getRoleId() == 13) {
          if(rs.getString("state").equals("CASH")) pat.setIconUrl("red");
          if(!rs.getString("state").equals("CASH"))
            if(dAmpPatientServices.getCount("From AmbPatientServices Where state = 'ENT' And patient = " + rs.getInt("id")) > 0) {
              pat.setIconUrl("red");
              pat.setMetka("Ожидание оплаты");
            }
        }
        //
        pat.setId(rs.getInt("id"));
        pat.setFio(Util.nvl(rs.getString("surname")) + " " + Util.nvl(rs.getString("name")) + " " + Util.nvl(rs.getString("middlename")));
        pat.setBirthYear(rs.getInt("birthyear") != 0 ? "" + rs.getInt("birthyear") : "");
        pat.setBirthday(Util.dateToString(rs.getDate("birthday")));
        pat.setDateBegin(Util.dateTimeToString(rs.getTimestamp("Reg_Date")));
        list.add(pat);
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
  public void makeAddEditUrlByRole(Model model, int roleId, boolean isArchive) {
    String url = "";
    if(roleId == 13)
      url = "/cashbox/amb.s?id=";
    if(roleId == 15 || roleId == 14)
      url = "/amb/reg.s?id=";
    if(isArchive)
      url = "/amb/reg.s?id=";
    model.addAttribute("addEditUrl", url);
  }

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

  public void createModel(HttpServletRequest req, AmbPatients p) {
    if(req.getParameter("id") != null || !Util.isNull(req, "reg")) {
      AmbPatients pat;
      if(Util.isNull(req, "reg"))
        pat = dAmpPatients.get(Req.getInt(req, "id"));
      else
        pat = dAmpPatients.get(Req.getInt(req, "reg"));
      if(Util.isNull(req, "reg")) p.setId(pat.getId());
      p.setSurname(pat.getSurname());
      p.setName(pat.getName());
      p.setMiddlename(pat.getMiddlename());
      p.setAddress(pat.getAddress());
      p.setBirthyear(pat.getBirthyear());
      p.setRegDate(pat.getRegDate());
      p.setTel(pat.getTel());
      p.setCounteryId(pat.getCounteryId());
      p.setRegionId(pat.getRegionId());
      p.setPassportInfo(pat.getPassportInfo());
      if(Util.isNull(req, "reg")) p.setState(pat.getState());
      p.setSex(pat.getSex());
      p.setFizio(pat.getFizio());
      p.setTgNumber(pat.getTgNumber());
      p.setLvpartner(pat.getLvpartner());
      p.setClient(pat.getClient());
      p.setQrcode(pat.getQrcode());
      p.setBirthday(pat.getBirthday());
    } else {
      p.setSex(dOpt.get(12));
      p.setTgNumber("998");
    }
  }

  @Override
  public AmbPatients save(HttpServletRequest req) throws Exception {
    AmbPatients pat = Util.isNull(req, "id") ? new AmbPatients() : dAmpPatients.get(Util.getInt(req, "id"));
    if(Util.isNotNull(req, "client_id")) {
      pat.setClient(dClient.get(Util.getInt(req, "client_id")));
      Clients c = pat.getClient();
      Util.checkClient(c);
      pat.setSurname(c.getSurname());
      pat.setBirthday(c.getBirthdate());
      pat.setName(c.getName());
      pat.setMiddlename(c.getMiddlename());
      pat.setBirthyear(c.getBirthyear());
      pat.setCounteryId(c.getCountry().getId());
      pat.setRegionId(c.getRegion().getId());
      pat.setPassportInfo(c.getDocSeria() + " " + c.getDocNum() + " " + c.getDocInfo());
      pat.setSex(c.getSex());
      pat.setAddress(c.getAddress());
    }
    pat.setTel(Util.get(req, "tel"));
    pat.setTgNumber(Util.get(req, "tgNumber"));
    pat.setLvpartner(Util.isNull(req, "lvpartner.id") ? null : dLvPartner.get(Util.getInt(req, "lvpartner.id")));
    if(Util.isNull(req, "id")) {
      pat.setState("PRN");
      pat.setRegDate(new Date());
      pat.setCard(0D);
      pat.setCash(0D);
      pat.setCrOn(new Date());
      pat.setCrBy(SessionUtil.getUser(req).getUserId());
    }
    AmbPatients pp = dAmpPatients.saveAndReturn(pat);
    if(Util.isNotNull(req, "regId")) {
      AmbPatientLinks link = new AmbPatientLinks();
      link.setParent(Util.getInt(req, "regId"));
      link.setChild(pp.getId());
      dAmbPatientLinks.save(link);
    }
    return pp;
  }

  @Override
  public void setFields(Model m, Integer serviceId) {
    List<AmbServiceFields> fields = dAmbServiceFields.byService(serviceId);
    for(int i=0;i<fields.size();i++) {
      m.addAttribute("isC" + (i+1), true);
      m.addAttribute("c" + (i+1) + "_name", fields.get(i).getName());
    }
  }

  @Override
  public List<AmbService> getHistoryServices(int curPat) {
    List<AmbService> list = new ArrayList<AmbService>();
    List<AmbPatientLinks> links = dAmbPatientLinks.getList("From AmbPatientLinks Where child = " + curPat);
    List<AmbPatientLinks> lins = dAmbPatientLinks.getList("From AmbPatientLinks Where parent = " + curPat);
    List<AmbPatientLinks> ls = new ArrayList<>();
    if(!lins.isEmpty()) ls.addAll(lins);
    if(!links.isEmpty()) ls.addAll(links);
    for(AmbPatientLinks link : ls) {
      AmbService service = new AmbService();
      // Child
      if(link.getChild() != curPat) {
        AmbPatients patient = dAmbPatients.get(link.getChild());
        service.setId(patient.getId());
        service.setRegDate(patient.getRegDate());
        service.setServices(dAmbPatientServices.getList("From AmbPatientServices Where patient = " + link.getChild()));
      }
      // Parent
      if(link.getParent() != curPat) {
        AmbPatients patient = dAmbPatients.get(link.getParent());
        service.setId(patient.getId());
        service.setRegDate(patient.getRegDate());
        service.setServices(dAmbPatientServices.getList("From AmbPatientServices Where patient = " + link.getParent()));
      }
      list.add(service);
    }
    return list;
  }

  @Override
  public String getFormJson(Integer result) {
    JSONObject json = new JSONObject();
    if(result > 0) {
      AmbResults f = dAmbResults.get(result);
      try {
        if (f != null) {
          json.put("c1", f.getC1());
          json.put("c2", f.getC2());
          json.put("c3", f.getC3());
          json.put("c4", f.getC4());
          json.put("c5", f.getC5());
          json.put("c6", f.getC6());
          json.put("c7", f.getC7());
          json.put("c8", f.getC8());
          json.put("c9", f.getC9());
          json.put("c10", f.getC10());
          json.put("c11", f.getC11());
          json.put("c12", f.getC12());
          json.put("c13", f.getC13());
          json.put("c14", f.getC14());
          json.put("c15", f.getC15());
          json.put("c16", f.getC16());
          json.put("c17", f.getC17());
          json.put("c18", f.getC18());
          json.put("c19", f.getC19());
          json.put("c20", f.getC20());
          json.put("c21", f.getC21());
          json.put("c22", f.getC22());
          json.put("c23", f.getC23());
          json.put("c24", f.getC24());
          json.put("c25", f.getC25());
          json.put("c26", f.getC26());
          json.put("c27", f.getC27());
          json.put("c28", f.getC28());
          json.put("c29", f.getC29());
          json.put("c30", f.getC30());
          json.put("c31", f.getC31());
          json.put("c32", f.getC32());
          json.put("c33", f.getC33());
          json.put("c34", f.getC34());
          json.put("c35", f.getC35());
          json.put("c36", f.getC36());
          json.put("c37", f.getC37());
          json.put("c38", f.getC38());
          json.put("c39", f.getC39());
          json.put("c40", f.getC40());
          json.put("c41", f.getC41());
          json.put("c42", f.getC42());
          json.put("c43", f.getC43());
          json.put("c44", f.getC44());
          json.put("c45", f.getC45());
          json.put("c46", f.getC46());
          json.put("c47", f.getC47());
          json.put("c48", f.getC48());
          json.put("c49", f.getC49());
          json.put("c50", f.getC50());
          json.put("c51", f.getC51());
          json.put("c52", f.getC52());
          json.put("c53", f.getC53());
          json.put("c54", f.getC54());
          json.put("c55", f.getC55());
          json.put("c56", f.getC56());
          json.put("c57", f.getC57());
          json.put("c58", f.getC58());
          json.put("c59", f.getC59());
          json.put("c60", f.getC60());
        }
      } catch (Exception e) {
        e.printStackTrace();
      }
    }
    return json.toString();
  }

  @Override
  public List<FormField> getResultFields(AmbPatientServices service) {
    Integer formId = service.getService().getForm_id();
    List<FormField> list = new ArrayList<FormField>();
    List<FormFields> fields = dFormField.getFileds(formId);
    AmbResults result = dAmbResults.get(service.getResult());
    for(FormFields f : fields) {
      String norma = "", ei = "";
      if(formId == 777) {
        norma = service.getService().getNormaFrom() != null ? service.getService().getNormaFrom() + (service.getService().getNormaTo() != null && !"".equals(service.getService().getNormaTo()) ? " - " + service.getService().getNormaTo() : "") : "";
        ei = service.getService().getEi() != null ? service.getService().getEi() : "";
      }
      FormField li = new FormField();
      li.setId(f.getId());
      li.setName(f.getField());
      li.setFieldCode(f.getFieldCode());
      li.setHtml(getValue(result, f));
      if(f.getNormaFrom() != null && !f.getNormaFrom().equals("")) {
        li.setNorma(f.getNormaFrom() + (!"".equals(f.getNormaTo()) ? " - " + f.getNormaTo() : ""));
      } else {
        li.setNorma(norma);
      }
      if(f.getEI() != null && !f.getEI().equals("")) {
        li.setEi(f.getEI());
      } else {
        li.setEi(ei);
      }
      li.setOrd(f.getOrd());
      list.add(li);
    }
    return list;
  }

  @Override
  public List<PatientDrug> getDrugs(int curPat) {
    List<PatientDrug> drugs = new ArrayList<PatientDrug>();
    List<AmbDrugs> patientDrugs = dAmbDrug.getList("From AmbDrugs Where patient.id = " + curPat);
    for(AmbDrugs pd: patientDrugs) {
      PatientDrug drug = new PatientDrug();
      drug.setId(pd.getId());
      drug.setDrugType(pd.getDrugType());
      drug.setInjectionType(pd.getInjectionType());
      List<PatientDrugRow> rows = new ArrayList<PatientDrugRow>();
      boolean canDel = true;
      for(AmbDrugRows patientDrugRow: dAmbDrugRow.getList("From AmbDrugRows Where ambDrug.id = " + drug.getId())) {
        PatientDrugRow row = new PatientDrugRow();
        row.setId(patientDrugRow.getId());
        row.setDrug(patientDrugRow.getDrug());
        row.setName(patientDrugRow.getSource().equals("own") ? patientDrugRow.getName() : patientDrugRow.getDrug().getName());
        if(!patientDrugRow.getSource().equals("own"))
          row.setName(row.getName() + " (" + patientDrugRow.getRasxod() + " " + patientDrugRow.getMeasure().getName() + ")");
        row.setExpanse(patientDrugRow.getRasxod());
        row.setSource(patientDrugRow.getSource());
        row.setMeasure(patientDrugRow.getMeasure());
        rows.add(row);
      }
      drug.setRows(rows);
      List<PatientDrugDate> dates = new ArrayList<PatientDrugDate>();
      for(AmbDrugDates dd: dAmbDrugDate.getList("From AmbDrugDates Where ambDrug.id = " + pd.getId())) {
        PatientDrugDate date = new PatientDrugDate();
        date.setId(dd.getId());
        date.setDate(dd.getDate());
        date.setChecked(dd.isChecked());
        date.setDateMonth(Util.dateToString(dd.getDate()).substring(0, 5));
        date.setState(dd.getState());
        dates.add(date);
      }
      drug.setDates(dates);
      drug.setNote(pd.getNote());
      drug.setDateBegin(pd.getDateBegin());
      drug.setDateEnd(pd.getDateEnd());
      drug.setCrBy(pd.getCrBy());
      drug.setCrOn(pd.getCrOn());
      drugs.add(drug);
    }
    return drugs;
  }

  @Override
  public PatientDrug getDrug(int id) {
    PatientDrug drug = new PatientDrug();
    AmbDrugs pd = dAmbDrug.get(id);
    drug.setId(pd.getId());
    drug.setDrugType(pd.getDrugType());
    drug.setInjectionType(pd.getInjectionType());
    List<PatientDrugRow> rows = new ArrayList<PatientDrugRow>();
    for(AmbDrugRows patientDrugRow: dAmbDrugRow.getList("From AmbDrugRows Where ambDrug.id = " + id)) {
      PatientDrugRow row = new PatientDrugRow();
      row.setId(patientDrugRow.getId());
      if(patientDrugRow.getSource().equals("own")) {
        row.setName(patientDrugRow.getName());
      } else {
        row.setName(patientDrugRow.getDrug().getName());
      }
      row.setExpanse(patientDrugRow.getRasxod());
      row.setSource(patientDrugRow.getSource());
      row.setMeasure(patientDrugRow.getMeasure());
      rows.add(row);
    }
    drug.setRows(rows);
    List<PatientDrugDate> dates = new ArrayList<PatientDrugDate>();
    for(AmbDrugDates dd: dAmbDrugDate.getList("From AmbDrugDates Where ambDrug.id = " + id)) {
      PatientDrugDate date = new PatientDrugDate();
      date.setId(dd.getId());
      date.setDate(dd.getDate());
      date.setChecked(dd.isChecked());
      date.setState(dd.getState());
      dates.add(date);
    }
    drug.setDates(dates);
    drug.setNote(pd.getNote());
    drug.setDateBegin(pd.getDateBegin());
    drug.setDateEnd(pd.getDateEnd());
    drug.setCrBy(pd.getCrBy());
    drug.setCrOn(pd.getCrOn());
    return drug;
  }

  private String getValue(AmbResults result, FormFields field){
    String value = "";

    if(field.getFieldCode().equals("c1")) value = result.getC1();
    if(field.getFieldCode().equals("c2")) value = result.getC2();
    if(field.getFieldCode().equals("c3")) value = result.getC3();
    if(field.getFieldCode().equals("c4")) value = result.getC4();
    if(field.getFieldCode().equals("c5")) value = result.getC5();
    if(field.getFieldCode().equals("c6")) value = result.getC6();
    if(field.getFieldCode().equals("c7")) value = result.getC7();
    if(field.getFieldCode().equals("c8")) value = result.getC8();
    if(field.getFieldCode().equals("c9")) value = result.getC9();
    if(field.getFieldCode().equals("c10")) value = result.getC10();
    if(field.getFieldCode().equals("c11")) value = result.getC11();
    if(field.getFieldCode().equals("c12")) value = result.getC12();
    if(field.getFieldCode().equals("c13")) value = result.getC13();
    if(field.getFieldCode().equals("c14")) value = result.getC14();
    if(field.getFieldCode().equals("c15")) value = result.getC15();
    if(field.getFieldCode().equals("c16")) value = result.getC16();
    if(field.getFieldCode().equals("c17")) value = result.getC17();
    if(field.getFieldCode().equals("c18")) value = result.getC18();
    if(field.getFieldCode().equals("c19")) value = result.getC19();
    if(field.getFieldCode().equals("c20")) value = result.getC20();
    if(field.getFieldCode().equals("c21")) value = result.getC21();
    if(field.getFieldCode().equals("c22")) value = result.getC22();
    if(field.getFieldCode().equals("c23")) value = result.getC23();
    if(field.getFieldCode().equals("c24")) value = result.getC24();
    if(field.getFieldCode().equals("c25")) value = result.getC25();
    if(field.getFieldCode().equals("c26")) value = result.getC26();
    if(field.getFieldCode().equals("c27")) value = result.getC27();
    if(field.getFieldCode().equals("c28")) value = result.getC28();
    if(field.getFieldCode().equals("c29")) value = result.getC29();
    if(field.getFieldCode().equals("c30")) value = result.getC30();
    if(field.getFieldCode().equals("c31")) value = result.getC31();
    if(field.getFieldCode().equals("c32")) value = result.getC32();
    if(field.getFieldCode().equals("c33")) value = result.getC33();
    if(field.getFieldCode().equals("c34")) value = result.getC34();
    if(field.getFieldCode().equals("c35")) value = result.getC35();
    if(field.getFieldCode().equals("c36")) value = result.getC36();
    if(field.getFieldCode().equals("c37")) value = result.getC37();
    if(field.getFieldCode().equals("c38")) value = result.getC38();
    if(field.getFieldCode().equals("c39")) value = result.getC39();
    if(field.getFieldCode().equals("c40")) value = result.getC40();
    if(field.getFieldCode().equals("c41")) value = result.getC41();
    if(field.getFieldCode().equals("c42")) value = result.getC42();
    if(field.getFieldCode().equals("c43")) value = result.getC43();
    if(field.getFieldCode().equals("c44")) value = result.getC44();
    if(field.getFieldCode().equals("c45")) value = result.getC45();
    if(field.getFieldCode().equals("c46")) value = result.getC46();
    if(field.getFieldCode().equals("c47")) value = result.getC47();
    if(field.getFieldCode().equals("c48")) value = result.getC48();
    if(field.getFieldCode().equals("c49")) value = result.getC49();
    if(field.getFieldCode().equals("c50")) value = result.getC50();
    if(field.getFieldCode().equals("c51")) value = result.getC51();
    if(field.getFieldCode().equals("c52")) value = result.getC52();
    if(field.getFieldCode().equals("c53")) value = result.getC53();
    if(field.getFieldCode().equals("c54")) value = result.getC54();
    if(field.getFieldCode().equals("c55")) value = result.getC55();
    if(field.getFieldCode().equals("c56")) value = result.getC56();
    if(field.getFieldCode().equals("c57")) value = result.getC57();
    if(field.getFieldCode().equals("c58")) value = result.getC58();
    if(field.getFieldCode().equals("c59")) value = result.getC59();
    if(field.getFieldCode().equals("c60")) value = result.getC60();

    return value;
  }
}
