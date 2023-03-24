package ckb.services.med.patient;

import ckb.dao.admin.depts.DDept;
import ckb.dao.admin.forms.opts.DOpt;
import ckb.dao.admin.params.DParam;
import ckb.dao.admin.users.DUser;
import ckb.dao.med.bookings.DRoomBookings;
import ckb.dao.med.client.DClient;
import ckb.dao.med.dicts.rooms.DRooms;
import ckb.dao.med.kdos.DKdos;
import ckb.dao.med.lv.bio.DLvBio;
import ckb.dao.med.lv.consul.DLvConsul;
import ckb.dao.med.lv.coul.DLvCoul;
import ckb.dao.med.lv.dairy.DLvDairy;
import ckb.dao.med.lv.epic.DLvEpic;
import ckb.dao.med.lv.fizio.DLvFizio;
import ckb.dao.med.lv.garmon.DLvGarmon;
import ckb.dao.med.lv.plan.DKdoChoosen;
import ckb.dao.med.lv.plan.DLvPlan;
import ckb.dao.med.lv.torch.DLvTorch;
import ckb.dao.med.patient.*;
import ckb.domains.admin.Kdos;
import ckb.domains.med.RoomBookings;
import ckb.domains.med.dicts.Rooms;
import ckb.domains.med.lv.*;
import ckb.domains.med.patient.*;
import ckb.models.Grid;
import ckb.models.ObjList;
import ckb.models.PatientList;
import ckb.models.drugs.PatientDrug;
import ckb.models.drugs.PatientDrugDate;
import ckb.models.drugs.PatientDrugRow;
import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.DB;
import ckb.utils.Req;
import ckb.utils.Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;

import javax.servlet.http.HttpServletRequest;
import java.sql.Connection;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 22.08.15
 * Time: 0:57
 * To change this template use File | Settings | File Templates.
 */
public class SPatientImp implements SPatient {

  @Autowired DPatient dPatient;
  @Autowired DLvDairy dLvDairy;
  @Autowired DLvPlan dLvPlan;
  @Autowired DKdos dKdos;
  @Autowired DUser dUser;
  @Autowired DDept dDept;
  @Autowired DLvEpic dLvEpic;
  @Autowired DLvConsul dLvConsul;
  @Autowired DOpt dOpt;
  @Autowired DLvBio dLvBio;
  @Autowired DLvCoul dLvCoul;
  @Autowired DLvGarmon dLvGarmon;
  @Autowired DLvTorch dLvTorch;
  @Autowired DLvFizio dLvFizio;
  @Autowired DRooms dRoom;
  @Autowired private DRoomBookings dRoomBooking;
  @Autowired private DPatientPlan dPatientPlan;
  @Autowired private DKdoChoosen dKdoChoosen;
  @Autowired private DPatientDrug dPatientDrug;
  @Autowired private DPatientDrugRow dPatientDrugRow;
  @Autowired private DPatientDrugDate dPatientDrugDate;
  @Autowired private DParam dParam;
  @Autowired private DClient dClient;

  @Override
  public Patients save(HttpServletRequest req) {
    Patients pat = Util.isNull(req, "id") ? new Patients() : dPatient.get(Util.getInt(req, "id"));
    pat.setSurname(Util.get(req, "surname").toUpperCase());
    pat.setName(Util.get(req, "name").toUpperCase());
    pat.setMiddlename(Util.get(req, "middlename", "").toUpperCase());
    //pat.setBirthyear(Util.getNullInt(req, "birthyear"));
    pat.setPost(Util.get(req, "post"));
    pat.setTel(Util.get(req, "tel"));
    pat.setWork(Util.get(req, "work"));
    pat.setCounteryId(Util.getNullInt(req, "counteryId"));
    pat.setRegionId(Util.getNullInt(req, "regionId"));
    pat.setPassportInfo(Util.get(req, "passportInfo"));
    pat.setAddress(Util.get(req, "address"));
    pat.setSex(Util.isNull(req, "sex.id") ? null : dOpt.get(Util.getInt(req, "sex.id")));
    pat.setMetka(Util.isNull(req, "metka.id") ? null : dOpt.get(Util.getInt(req, "metka.id")));
    pat.setCat(Util.isNull(req, "cat.id") ? null : dOpt.get(Util.getInt(req, "cat.id")));
    pat.setTarDate(Util.get(req, "tarDate"));
    pat.setTemp(Util.get(req, "temp"));
    pat.setRost(Util.get(req, "rost"));
    pat.setVes(Util.get(req, "ves"));
    pat.setAmbNum(Util.get(req, "ambNum"));
    pat.setPitanie(Util.isNull(req, "pitanie.id") ? null : dOpt.get(Util.getInt(req, "pitanie.id")));
    pat.setLgotaType(Util.isNull(req, "lgotaType.id") ? null : dOpt.get(Util.getInt(req, "lgotaType.id")));
    pat.setRedirect(Util.isNull(req, "redirect.id") ? null : dOpt.get(Util.getInt(req, "redirect.id")));
    pat.setVidPer(Util.isNull(req, "vidPer.id") ? null : dOpt.get(Util.getInt(req, "vidPer.id")));
    pat.setRoom(dRoom.get(Util.getInt(req, "room.id")));
    pat.setDiagnoz(Util.get(req, "diagnoz"));
    pat.setTime(Util.get(req, "time"));
    pat.setTransport(Util.get(req, "transport"));
    pat.setOrientedBy(Util.get(req, "orientedBy"));
    pat.setDrugEffect(Util.get(req, "drugEffect"));
    pat.setResus(Util.get(req, "resus"));
    pat.setPalata(Util.get(req, "palata"));
    pat.setDayCount(Util.getInt(req, "dayCount"));
    pat.setBloodGroup(Util.isNull(req, "bloodGroup.id") ? null : dOpt.get(Util.getInt(req, "bloodGroup.id")));
    pat.setDept(Util.isNull(req, "dept.id") ? null : dDept.get(Util.getInt(req, "dept.id")));
    if(Util.isNotNull(req, "client"))
      pat.setClient(dClient.get(Util.getInt(req, "client")));
    //pat.setPay_type(Util.isNull(req, "pay_type.id") ? null : dOpt.get(Util.getInt(req, "pay_type.id")));
    //pat.setDayCount(Util.getInt(req, "dayCount"));
    pat.setBirthday(Util.stringToDate(Util.get(req, "birthdayString")));
    if(pat.getBirthday() != null) {
      pat.setBirthyear(1900 + pat.getBirthday().getYear());
    }
    if(Util.isNull(req, "id")) {
      pat.setPaid("N");
      Rooms room = pat.getRoom();
      room.setAccess("N");
      dRoom.save(room);
    }
    if(!Util.isNull(req, "lv_id")) {
      pat.setLv_id(Util.getInt(req, "lv_id"));
      pat.setLv_dept_id(dUser.get(pat.getLv_id()).getDept().getId());
    }
    if(Util.isNotNull(req, "booking")) {
      RoomBookings bk = dRoomBooking.get(Util.getInt(req, "booking"));
      bk.setState("ARCH");
      //
      pat.setLv_id(bk.getLv() == null ? null : bk.getLv().getId());
      pat.setLv_dept_id(bk.getLv() != null ? bk.getLv().getDept().getId() : null);
      dRoomBooking.save(bk);
    }
    return dPatient.saveAndReturn(pat);
  }

  @Override
  public void createModel(HttpServletRequest request, Patients pat) {
    if(request.getParameter("id") != null) {
      Patients p = dPatient.get(Integer.parseInt(request.getParameter("id")));
      pat.setSex(p.getSex());
      pat.setSurname(p.getSurname());
      pat.setName(p.getName());
      pat.setMiddlename(p.getMiddlename());
      pat.setBirthyear(p.getBirthyear());
      pat.setPost(p.getPost());
      pat.setTel(p.getTel());
      pat.setWork(p.getWork());
      pat.setPassportInfo(p.getPassportInfo());
      pat.setAddress(p.getAddress());
      pat.setId(p.getId());
      pat.setMetka(p.getMetka());
      pat.setCat(p.getCat());
      pat.setTarDate(p.getTarDate());
      pat.setTemp(p.getTemp());
      pat.setRost(p.getRost());
      pat.setVes(p.getVes());
      pat.setAmbNum(p.getAmbNum());
      pat.setPitanie(p.getPitanie());
      pat.setLgotaType(p.getLgotaType());
      pat.setRedirect(p.getRedirect());
      pat.setVidPer(p.getVidPer());
      pat.setDiagnoz(p.getDiagnoz());
      pat.setState(p.getState());
      pat.setTime(p.getTime());
      pat.setCounteryId(p.getCounteryId());
      pat.setRegionId(p.getRegionId());
      pat.setResus(p.getResus());
      pat.setDrugEffect(p.getDrugEffect());
      pat.setOrientedBy(p.getOrientedBy());
      pat.setTransport(p.getTransport());
      pat.setBloodGroup(p.getBloodGroup());
      pat.setLv_id(p.getLv_id());
      pat.setLv_dept_id(p.getLv_dept_id());
      pat.setPalata(p.getPalata());
      pat.setDept(p.getDept());
      pat.setRoom(p.getRoom());
      pat.setDayCount(p.getDayCount());
      pat.setBirthday(p.getBirthday());
    } else if(!Req.isNull(request, "reg")) {
      Patients p = dPatient.get(SessionUtil.getUser(request).getCurPat());
      pat.setSex(p.getSex());
      pat.setSurname(p.getSurname());
      pat.setName(p.getName());
      pat.setMiddlename(p.getMiddlename());
      pat.setBirthyear(p.getBirthyear());
      pat.setPost(p.getPost());
      pat.setTel(p.getTel());
      pat.setWork(p.getWork());
      pat.setPassportInfo(p.getPassportInfo());
      pat.setAddress(p.getAddress());
      pat.setMetka(p.getMetka());
      pat.setCat(p.getCat());
      pat.setTarDate(p.getTarDate());
      pat.setTemp(p.getTemp());
      pat.setRost(p.getRost());
      pat.setVes(p.getVes());
      pat.setAmbNum(p.getAmbNum());
      pat.setPitanie(p.getPitanie());
      pat.setLgotaType(p.getLgotaType());
      pat.setRedirect(p.getRedirect());
      pat.setVidPer(p.getVidPer());
      pat.setDiagnoz(p.getDiagnoz());
      pat.setTime(Util.getCurTime());
      pat.setCounteryId(p.getCounteryId());
      pat.setRegionId(p.getRegionId());
      pat.setBloodGroup(p.getBloodGroup());
      pat.setResus(p.getResus());
      pat.setDrugEffect(p.getDrugEffect());
      pat.setOrientedBy(p.getOrientedBy());
      pat.setTransport(p.getTransport());
      pat.setLv_id(p.getLv_id());
      pat.setLv_dept_id(p.getLv_dept_id());
      pat.setRoom(p.getRoom());
      pat.setDayCount(p.getDayCount());
      pat.setBirthday(p.getBirthday());
    } else if(Util.isNotNull(request, "booking")) {
      RoomBookings bk = dRoomBooking.get(Util.getInt(request, "booking"));
      if(bk.getHistoryId() != null && bk.getHistoryId() > 0) {
        Patients p = dPatient.get(bk.getHistoryId());
        pat.setClient(p.getClient());
        pat.setSex(bk.getSex());
        pat.setSurname(p.getSurname());
        pat.setName(p.getName());
        pat.setMiddlename(p.getMiddlename());
        pat.setBirthyear(p.getBirthyear());
        pat.setPost(p.getPost());
        pat.setTel(p.getTel());
        pat.setWork(p.getWork());
        pat.setPassportInfo(bk.getPassportInfo());
        pat.setAddress(p.getAddress());
        pat.setMetka(p.getMetka());
        pat.setCat(p.getCat());
        pat.setTarDate(p.getTarDate());
        pat.setTemp(p.getTemp());
        pat.setRost(p.getRost());
        pat.setVes(p.getVes());
        pat.setAmbNum(p.getAmbNum());
        pat.setPitanie(p.getPitanie());
        pat.setLgotaType(p.getLgotaType());
        pat.setRedirect(p.getRedirect());
        pat.setVidPer(p.getVidPer());
        pat.setDiagnoz(p.getDiagnoz());
        pat.setTime(Util.getCurTime());
        pat.setCounteryId(bk.getCountry().getId());
        pat.setRegionId(p.getRegionId());
        pat.setBloodGroup(p.getBloodGroup());
        pat.setResus(p.getResus());
        pat.setDrugEffect(p.getDrugEffect());
        pat.setOrientedBy(p.getOrientedBy());
        pat.setTransport(p.getTransport());
        pat.setDept(bk.getDept());
        pat.setLv_id(bk.getLv() != null ? bk.getLv().getId() : p.getLv_id());
        pat.setLv_dept_id(bk.getLv() != null ? bk.getLv().getDept().getId() : p.getLv_dept_id());
        pat.setRoom(bk.getRoom());
        pat.setDayCount(p.getDayCount());
        pat.setBirthday(p.getBirthday());
      } else {
        pat.setSurname(bk.getSurname());
        pat.setName(bk.getName());
        pat.setMiddlename(bk.getMiddlename());
        pat.setBirthyear(bk.getBirthyear());
        pat.setTel(bk.getTel());
        pat.setPassportInfo(bk.getPassportInfo());
        pat.setCounteryId(bk.getCountry().getId());
        pat.setSex(bk.getSex());
        pat.setDept(bk.getDept());
        pat.setRoom(bk.getRoom());
        pat.setTime(Util.getCurTime());
        pat.setDayCount(10);
      }
    } else {
      pat.setTarDate(Util.getCurDate());
      pat.setTime(Util.getCurTime());
      pat.setDayCount(10);
    }
  }

  @Override
  public void makeAddEditUrlByRole(Model model, int roleId, String curPat) {
    String url = "";
    if(roleId == 3)
      url = "/reg/nurse/index.s?id=";
    if(roleId == 4)
      url = "/reg/doctor/index.s?id=";
    if(roleId == 5 || roleId == 8)
      url = "/lv/index.s?id=";
    if(roleId == 6 && curPat.equals(""))
      url = "/view/index.s?id=";
    if(roleId == 6 && !curPat.equals(""))
      url = "/lv/index.s?id=";
    if(roleId == 7 || roleId == 16 || roleId == 11)
      url = "/view/index.s?id=";
    if(roleId == 13)
      url = "/cashbox/stat.s?id=";
    model.addAttribute("addEditUrl", url);
  }

  @Override
  public List<PatientList> getGridList(Grid grid, Session session) {
    Connection conn = null;
    ResultSet rs = null;
    List<PatientList> list = new ArrayList<PatientList>();
    if(grid.getRowCount() == 0)
      return list;
    try {
      conn = DB.getConnection();
      rs = conn.prepareStatement("Select * From (Select * " + grid.getSql() + ") global Limit " + (grid.getStartPos() - 1) + "," + grid.getPageSize()).executeQuery();
      while(rs.next()) {
        PatientList pat = new PatientList();
        // Приемное - медсестра
        if(session.getRoleId() == 3 && rs.getString("state").equals("PRN"))
          pat.setShowCheckbox(true);
        // Приемное - Врач
        if(session.getRoleId() == 4 && rs.getString("state").equals("PRD"))
          pat.setShowCheckbox(true);
        // Цвет иконки
        pat.setIconUrl("red");
        // Приемное - медсестра
        if(session.getRoleId() == 3 && !rs.getString("state").equals("PRN"))
          pat.setIconUrl("green");
        // Приемное - Врач
        if(session.getRoleId() == 4 && rs.getString("state").equals("LV"))
          pat.setIconUrl("green");
        if(session.getRoleId() == 5 && rs.getString("state").equals("LV"))
          pat.setIconUrl("green");
        if(session.getRoleId() == 5 && rs.getString("state").equals("ZGV"))
          pat.setIconUrl("red");
        if(session.getRoleId() == 5 && rs.getString("state").equals("LV") && rs.getDate("Date_End") != null && rs.getString("paid") != null && rs.getString("paid").equals("CLOSED"))
          pat.setShowCheckbox(true);
        if(session.getRoleId() == 6 && rs.getString("state").equals("ZGV")) {
          pat.setIconUrl("green");
          pat.setShowCheckbox(true);
        }
        if(session.getRoleId() == 6 && rs.getString("state").equals("CZG")) {
          pat.setIconUrl("green");
          pat.setShowCheckbox(true);
        }
        if(rs.getString("state").equals("ARCH")) {
          pat.setIconUrl("green");
          if(session.getRoleId() == 6)
            pat.setShowCheckbox(true);
        }
        if(session.getRoleId() == 7) {
          Long conCount = dLvConsul.getCount("From PatientPlans c Where c.patient_id = " + rs.getInt("id") + " And done = 'Y'");
          pat.setIconUrl(conCount == 0 ? "red" : "green");
        }
        //pat.setPaid("Y".equals(rs.getString("paid")) ? "Оплачено" : "C".equals(rs.getString("paid")) ? "Частично" : "Не оплачено");
        /*if(session.getRoleId() == 13) {
          String paid = rs.getString("paid") == null ? "N" : rs.getString("paid");
          pat.setIconUrl(!"Y".equals(paid) ? "red" : "green");
        }*/
        if(session.getRoleId() == 9 || (session.getRoleId() == 5 && session.getCurUrl().contains("consul.s"))) {
          Long conCount = dLvConsul.getCount("From LvConsuls c Where c.patientId = " + rs.getInt("id") + " And (c.text = null Or c.text='') And c.lvId = " + session.getUserId());
          pat.setIconUrl(conCount > 0 ? "red" : "green");
        }
        // Если это консультация то скрвываем чекбокс
        if(session.getCurUrl().equals("/patients/consul.s"))
          pat.setShowCheckbox(false);
        if(session.getRoleId() == 16) {
          if(dLvFizio.getCount("From LvFizios Where patientId = " + rs.getInt("id")) > 0)
            pat.setIconUrl("green");
        }
        //
        pat.setId(rs.getInt("id"));
        pat.setFio(Util.nvl(rs.getString("surname")) + " " + Util.nvl(rs.getString("name")) + " " + Util.nvl(rs.getString("middlename")));
        pat.setBirthYear(rs.getInt("birthyear") != 0 ? "" + rs.getInt("birthyear") : "");
        pat.setDateBegin(Util.dateToString(rs.getDate("Date_Begin")));
        pat.setDateEnd(Util.dateToString(rs.getDate("Date_End")));
        pat.setIbNum(rs.getInt("YearNum") != 0 ? rs.getInt("YearNum") + "" : "");

        if(rs.getString("palata") == null) {
          if(rs.getString("Dept_Id") != null) {
            pat.setOtdPal(dDept.get(rs.getInt("Dept_Id")).getName());
          }
          if(rs.getString("Room_Id") != null) {
            Rooms room = dRoom.get(rs.getInt("room_id"));
            String palata = room.getName() + "-" + room.getRoomType().getName();
            pat.setOtdPal(pat.getOtdPal() + ("".equals(pat.getOtdPal()) ? "" : " / ") + palata);
          }
        } else {
          pat.setOtdPal(rs.getInt("Dept_Id") != 0 ? dDept.get(rs.getInt("Dept_Id")).getName() + " / " + rs.getString("palata") : "");
        }
        pat.setCat(rs.getInt("cat_id") != 0 ? dOpt.get(rs.getInt("cat_id")).getName() : "");
        pat.setMetka(rs.getInt("metka_id") != 0 ? dOpt.get(rs.getInt("metka_id")).getName() : "");
        pat.setLv(rs.getInt("lv_id") != 0 ? dUser.get(rs.getInt("lv_id")).getFio() : "");
        list.add(pat);
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(conn);
    }
    return list;
   /* List<Patients> patients = getList() dPatient.getGridList(grid);
    for (Patients p : patients) {
      PatientList pat = new PatientList();
      // Приемное - медсестра
      if(session.getRoleId() == 3 && p.getState().equals("PRN"))
        pat.setShowCheckbox(true);
      // Приемное - Врач
      if(session.getRoleId() == 4 && p.getState().equals("PRD"))
        pat.setShowCheckbox(true);
      // Цвет иконки
      pat.setIconUrl("red");
      // Приемное - медсестра
      if(session.getRoleId() == 3 && !p.getState().equals("PRN"))
        pat.setIconUrl("green");
      // Приемное - Врач
      if(session.getRoleId() == 4 && p.getState().equals("LV"))
        pat.setIconUrl("green");
      if(session.getRoleId() == 5 && p.getState().equals("LV"))
        pat.setIconUrl("green");
      if(session.getRoleId() == 5 && p.getState().equals("ZGV"))
        pat.setIconUrl("red");
      if(session.getRoleId() == 5 && p.getState().equals("LV") && p.getDateEnd() != null)
        pat.setShowCheckbox(true);
      if(session.getRoleId() == 6 && p.getState().equals("ZGV")) {
        pat.setIconUrl("green");
        pat.setShowCheckbox(true);
      }
      if(session.getRoleId() == 9) {
        Long conCount = dLvConsul.getCount("From LvConsuls c Where c.patientId = " + p.getId() + " And c.text = null And c.lvId = " + session.getUserId());
        pat.setIconUrl(conCount > 0 ? "red" : "green");
      }
      if(p.getState().equals("ARCH")) {
        pat.setIconUrl("green");
        if(session.getRoleId() == 6)
          pat.setShowCheckbox(true);
      }
      // Если это консультация то скрвываем чекбокс
      if(session.getCurUrl().equals("/patients/consul.s"))
        pat.setShowCheckbox(false);
      //
      pat.setId(p.getId());
      pat.setFio(Util.nvl(p.getSurname()) + " " + Util.nvl(p.getName()) + " " + Util.nvl(p.getMiddlename()));
      pat.setBirthYear(p.getBirthyear() != null ? "" + p.getBirthyear() : "");
      pat.setDateBegin(Util.dateToString(p.getDateBegin()));
      pat.setIbNum(p.getYearNum() != null ? p.getYearNum() + "" : "");
      pat.setOtdPal(p.getDept() != null ? p.getDept().getName() + " / " + p.getPalata() : "");
      pat.setCat(p.getCat() != null ? p.getCat().getName() : "");
      pat.setMetka(p.getMetka() != null ? p.getMetka().getName() : "");
      pat.setLv(p.getLv() != null ? dUser.get(p.getLv()).getFio() : "");
      list.add(pat);
    }
    return list;*/
  }

  @Override
  public void createDocModel(Patients pat, Patients p) {
    p.setId(pat.getId());
    p.setSurname(pat.getSurname());
    p.setName(pat.getName());
    //
    p.setYearNum(pat.getYearNum());
    p.setOtdNum(pat.getOtdNum());
    p.setDateBegin(pat.getDateBegin());
    p.setDateEnd(pat.getDateEnd());
    p.setDept(pat.getDept());
    p.setPalata(pat.getPalata());
    p.setState(pat.getState());
    p.setLv_id(pat.getLv_id());
    p.setDiagnosDate(pat.getDiagnosDate());
    p.setStartDiagnoz(pat.getStartDiagnoz());
    p.setSopustDBolez(pat.getSopustDBolez());
    p.setOslojn(pat.getOslojn());
    p.setNo1(pat.getNo1());
    p.setNo2(pat.getNo2());
    p.setNo3(pat.getNo3());
    p.setNo4(pat.getNo4());
    p.setNo4(pat.getNo4());
    p.setJaloby(pat.getJaloby());
    p.setAnamnez(pat.getAnamnez());
    p.setC1(pat.getC1());
    p.setC2(pat.getC2());
    p.setC3(pat.getC3());
    p.setC4(pat.getC4());
    p.setC5(pat.getC5());
    p.setC6(pat.getC6());
    p.setC7(pat.getC7());
    p.setC8(pat.getC8());
    p.setC9(pat.getC9());
    p.setC10(pat.getC10());
    p.setC11(pat.getC11());
    p.setC12(pat.getC12());
    p.setC13(pat.getC13());
    p.setC14(pat.getC14());
    p.setC15(pat.getC15());
    p.setC16(pat.getC16());
    p.setC17(pat.getC17());
    p.setC18(pat.getC18());
    p.setC19(pat.getC19());
    p.setC20(pat.getC20());
    p.setC21(pat.getC21());
    p.setC22(pat.getC22());
    p.setC23(pat.getC23());
    p.setC24(pat.getC24());
    p.setC25(pat.getC25());
    p.setC26(pat.getC26());
    p.setC27(pat.getC27());
    p.setC28(pat.getC28());
    p.setC29(pat.getC29());
    p.setC30(pat.getC30());
    p.setC31(pat.getC31());
    p.setC32(pat.getC32());
    p.setC33(pat.getC33());
    p.setC34(pat.getC34());
    p.setC35(pat.getC35());
    p.setC36(pat.getC36());
    p.setC37(pat.getC37());
    /*p.setMkb_id(pat.getMkb_id());
    p.setMkb(pat.getMkb());*/
    if(p.getYearNum() == null)
      p.setYearNum(dPatient.getNextYearNum());
    else
      p.setYearNum(pat.getYearNum());
  }

  @Override
  public Patients docSave(HttpServletRequest req) {
    Session session = SessionUtil.getUser(req);
    Patients p = dPatient.get(Util.getInt(req, "id"));
    p.setDateBegin(Util.stringToDate(req.getParameter("date_Begin")));
    p.setDiagnosDate(Util.stringToDate(req.getParameter("diagnos_Date")));
    if(p.getState().equals("PRN")) p.setStartEpicDate(p.getDateBegin());
    // Фарход мадад шифода ушбу полялар медсестрага олиб чикилган
    if(!session.isParamEqual("CLINIC_CODE", "fm")) {
      p.setDept(Util.isNull(req, "dept.id") ? null : dDept.get(Util.getInt(req, "dept.id")));
      p.setPalata(Util.get(req, "palata"));
      p.setLv_id(Util.getNullInt(req, "lv_id"));
      if(p.getLv_id() != null)
        p.setLv_dept_id(dUser.get(p.getLv_id()).getDept().getId());
    }
    /*p.setMkb(Util.get(req, "mkb"));
    p.setMkb_id(Util.getInt(req, "mkb_id"));*/
    p.setStartDiagnoz(Util.get(req, "startDiagnoz"));
    p.setSopustDBolez(Util.get(req, "sopustDBolez"));
    p.setOslojn(Util.get(req, "oslojn"));
    p.setNo1(Util.get(req, "no1"));
    p.setNo2(Util.get(req, "no2"));
    p.setNo3(Util.get(req, "no3"));
    p.setNo4(Util.get(req, "no4"));
    p.setNo4(Util.get(req, "no4"));
    p.setJaloby(Util.get(req, "jaloby"));
    p.setAnamnez(Util.get(req, "anamnez"));
    p.setYearNum(Util.getInt(req, "yearNum"));
    p.setC1(Util.get(req, "c1"));
    p.setC2(Util.get(req, "c2"));
    p.setC3(Util.get(req, "c3"));
    p.setC4(Util.get(req, "c4"));
    p.setC5(Util.get(req, "c5"));
    p.setC6(Util.get(req, "c6"));
    p.setC7(Util.get(req, "c7"));
    p.setC8(Util.get(req, "c8"));
    p.setC9(Util.get(req, "c9"));
    p.setC10(Util.get(req, "c10"));
    p.setC11(Util.get(req, "c11"));
    p.setC12(Util.get(req, "c12"));
    p.setC13(Util.get(req, "c13"));
    p.setC14(Util.get(req, "c14"));
    p.setC15(Util.get(req, "c15"));
    p.setC16(Util.get(req, "c16"));
    p.setC17(Util.get(req, "c17"));
    p.setC18(Util.get(req, "c18"));
    p.setC19(Util.get(req, "c19"));
    p.setC20(Util.get(req, "c20"));
    p.setC21(Util.get(req, "c21"));
    p.setC22(Util.get(req, "c22"));
    p.setC23(Util.get(req, "c23"));
    p.setC24(Util.get(req, "c24"));
    p.setC25(Util.get(req, "c25"));
    p.setC26(Util.get(req, "c26"));
    p.setC27(Util.get(req, "c27"));
    p.setC28(Util.get(req, "c28"));
    p.setC29(Util.get(req, "c29"));
    p.setC30(Util.get(req, "c30"));
    p.setC31(Util.get(req, "c31"));
    p.setC32(Util.get(req, "c32"));
    p.setC33(Util.get(req, "c33"));
    p.setC34(Util.get(req, "c34"));
    p.setC35(Util.get(req, "c35"));
    p.setC36(Util.get(req, "c36"));
    p.setC37(Util.get(req, "c37"));
    //p.setMkb(Util.get(req, "mkb"));
    //
    if(Util.isNotNull(req, "glikoFlag")) {
      LvPlans plan = new LvPlans();
      plan.setActDate(new Date());
      plan.setKdo(dKdos.get(153));
      plan.setDone("N");
      plan.setPrice(0D);
      plan.setKdoType(dKdos.get(153).getKdoType());
      plan.setUserId(SessionUtil.getUser(req).getUserId());
      plan.setPatientId(p.getId());
      plan.setResultId(0);
      dLvPlan.saveAndReturn(plan);

      PatientPlans pp = new PatientPlans();
      pp.setPlan_Id(plan.getId());
      pp.setKdo_type_id(plan.getKdoType().getId());
      pp.setActDate(plan.getActDate());
      pp.setPatient_id(plan.getPatientId());
      dPatientPlan.save(pp);
      //
      LvBios bio = dLvBio.getByPlan(plan.getId());
      bio.setPlanId(plan.getId());
      bio.setPatientId(plan.getPatientId());
      bio.setC18(1);
      dLvBio.save(bio);
      //
      plan.setPrice(dKdoChoosen.getPrice(p.getCounteryId(), plan.getKdo().getId(), 18));
      if(plan.getPrice() == 0) {
        plan.setPayDate(new Date());
        plan.setCashState("FREE");
      }
      dLvPlan.save(plan);
    }
    return dPatient.saveAndReturn(p);
  }

  @Override
  public ArrayList<ObjList> getDairies(int curPat) {
    ArrayList<LvDairies> ds = dLvDairy.getByPatientId(curPat);
    ArrayList<ObjList> list = new ArrayList<ObjList>();
    for (LvDairies d : ds){
      ObjList o = new ObjList();
      o.setC1(d.getId().toString());
      o.setC2(Util.dateToString(d.getActDate()));
      o.setC3(d.getPuls());
      o.setC4(d.getTemp());
      o.setC5(d.getText());
      o.setC6(d.getDav1());
      o.setC7(d.getDav2());
      if(d.getCreatedBy() != null)
        o.setC8(dUser.get(d.getCreatedBy()).getFio());
      else
        o.setC8(dUser.get(dPatient.get(curPat).getLv_id()).getFio());
      //
      list.add(o);
    }
    return list;
  }

  @Override
  public ArrayList<ObjList> getPlans(int curPat) {
    ArrayList<LvPlans> ds = dLvPlan.getByPatientId(curPat);
    ArrayList<ObjList> list = new ArrayList<ObjList>();
    for (LvPlans d : ds){
      ObjList o = new ObjList();
      o.setC1(d.getId().toString()); // Идентификатор строки
      o.setC2(d.getPatientId().toString()); // Id пациента
      o.setC3(d.getKdo().getId().toString()); // Id обследования
      o.setC4(d.getKdo().getName()); // Наименование обследования
      o.setC5(Util.dateToString(d.getActDate())); // Дата обследования
      o.setC6(d.getComment());
      if(d.getKdo().getId() == 13) { // Биохимия
        String st = "";
        LvBios bio = dLvBio.getByPlan(d.getId());
        if(bio != null) {
          if (bio.getC1() == 1) st +=  "Глюкоза крови,";
          if (bio.getC2() == 1) st += "Холестерин,";
          if (bio.getC3() == 1) st += "Бетта липопротеиды,";
          if (bio.getC4() == 1) st += "Общий белок,";
          if (bio.getC5() == 1) st += "Мочевина,";
          if (bio.getC23() == 1) st += "Fе (железо),";
          if (bio.getC8() == 1) st += "Билирубин,";
          if (bio.getC7() == 1) st += "Креатинин,";
          if (bio.getC13() == 1) st += "Амилаза крови,";
          if (bio.getC12() == 1) st += "Трансаминазы-АЛТ,";
          if (bio.getC14() == 1) st += "Мочевая кислота,";
          if (bio.getC11() == 1) st += "Трансаминазы-АСТ,";
          if (bio.getC15() == 1) st += "Сывороточное железо,";
          if (bio.getC16() == 1) st += "К-калий,";
          if (bio.getC17() == 1) st += "Na - натрий,";
          if (bio.getC18() == 1) st += "Са - кальций,";
          if (bio.getC19() == 1) st += "Cl - хлор,";
          if (bio.getC20() == 1) st += "Phos - фосфор,";
          if (bio.getC21() == 1) st += "Mg - магний,";
          if (bio.getC24() == 1) st += "Альбумин,";
          if (bio.getC25() == 1) st += "Лактатдегидрогеноза,";
          if (bio.getC26() == 1) st += "Гамма-глутамилтрансфераза,";
          if (bio.getC27() == 1) st += "Шелочная фосфотаза,";
          if (bio.getC28() == 1) st += "Тимоловая проба,";
          if (bio.getC29() == 1) st += "Креотенин киназа,";
          if(st != "") {
            st = st.substring(0, st.length() - 1);
            o.setC4(d.getKdo().getName() + "<br/>" + st);
          }
        }
      }
      if(d.getKdo().getId() == 153) { // Биохимия
        String st = "";
        LvBios bio = dLvBio.getByPlan(d.getId());
        if(bio != null) {
          if (bio.getC1() == 1) st += "Умумий оксил,";
          if (bio.getC2() == 1) st += "Холестерин,";
          if (bio.getC3() == 1) st += "Глюкоза,";
          if (bio.getC4() == 1) st += "Мочевина,";
          if (bio.getC5() == 1) st += "Креатинин,";
          if (bio.getC6() == 1) st += "Билирубин,";
          if (bio.getC7() == 1) st += "АЛТ,";
          if (bio.getC8() == 1) st += "АСТ,";
          if (bio.getC9() == 1) st += "Альфа амилаза,";
          if (bio.getC10() == 1) st += "Кальций,";
          if (bio.getC11() == 1) st += "Сийдик кислотаси,";
          if (bio.getC12() == 1) st += "K – калий,";
          if (bio.getC13() == 1) st += "Na – натрий,";
          if (bio.getC14() == 1) st += "Fe – темир,";
          if (bio.getC15() == 1) st += "Mg – магний,";
          if (bio.getC16() == 1) st += "Ишкорий фасфотаза,";
          if (bio.getC17() == 1) st += "ГГТ,";
          if (bio.getC18() == 1) st += "Гликирланган гемоглобин,";
          if (bio.getC19() == 1) st += "РФ,";
          if (bio.getC20() == 1) st += "АСЛО,";
          if (bio.getC21() == 1) st += "СРБ,";
          if (bio.getC22() == 1) st += "RW,";
          if (bio.getC23() == 1) st += "Hbs Ag,";
          if (bio.getC24() == 1) st += "Гепатит «С» ВГС,";
          if(st != "") {
            st = st.substring(0, st.length() - 1);
            o.setC4(d.getKdo().getName() + "<br/>" + st);
          }
        }
      }
      if(d.getKdo().getId() == 56) { // Каулограмма
        String st = "";
        LvCouls bio = dLvCoul.getByPlan(d.getId());
        if(bio != null) {
          if (bio.isC4()) st += "ПТИ,";
          if (bio.isC1()) st += "Фибриноген,";
          if (bio.isC2()) st += "Тромбин вакти,";
          if (bio.isC3()) st += "А.Ч.Т.В. (сек),";
          if(st != "") {
            st = st.substring(0, st.length() - 1);
            o.setC4(d.getKdo().getName() + "<br/>" + st);
          }
        }
      }
      if(d.getKdo().getId() == 120) { // Garmon
        String st = "";
        LvGarmons bio = dLvGarmon.getByPlan(d.getId());
        if(bio != null) {
          if (bio.isC1()) st += "ТТГ,";
          if (bio.isC2()) st += "Т4,";
          if (bio.isC3()) st += "Т3,";
          if (bio.isC4()) st += "Анти-ТРО,";
          if (bio.isC5()) st += "АН-ТГ,";
          if (bio.isC6()) st += "ДГЭА-С,";
          if (bio.isC7()) st += "Глобулин связующие половые ,";
          if (bio.isC8()) st += "АКТГ,";
          if (bio.isC9()) st += "С-пептид,";
          if (bio.isC10()) st += "Инсулин,";
          if (bio.isC11()) st += "Пролактин,";
          if (bio.isC12()) st += "Тестестерон ,";
          if (bio.isC13()) st += "Гормонроста hGH,";
          if (bio.isC14()) st += "Кальцитонин,";
          if (bio.isC15()) st += "Тиреоглобулин,";
          if (bio.isC16()) st += "Эстрадиол,";
          if (bio.isC17()) st += "Кортизол,";
          if (bio.isC18()) st += "Прогестерон,";
          if (bio.isC19()) st += "ЛГ,";
          if (bio.isC20()) st += "ФСГ,";
          if (bio.isC21()) st += "Паратгормон,";
          if (bio.isC22()) st += "АМГ,";
          if (bio.isC23()) st += "Витамин Д,";
          if (bio.isC24()) st += "Обший ПСА,";
          if (bio.isC25()) st += "Свободный ПСА,";
          if (bio.isC26()) st += "Кросс Лапс,";
          if (bio.isC27()) st += "Нейро-спецефическая энолаза,";

          if(st != "") {
            st = st.substring(0, st.length() - 1);
            o.setC4(d.getKdo().getName() + "<br/>" + st);
          }
        }
      }
      if(d.getKdo().getId() == 121) { // Торч
        String st = "";
        LvTorchs bio = dLvTorch.getByPlan(d.getId());
        if(bio != null) {
          if (bio.isC1()) st += "Хламидия,";
          if (bio.isC2()) st += "Токсоплазма,";
          if (bio.isC3()) st += "ЦМВ,";
          if (bio.isC4()) st += "ВПГ,";
          if(st != "") {
            st = st.substring(0, st.length() - 1);
            o.setC4(d.getKdo().getName() + "<br/>" + st);
          }
        }
      }
      o.setC7(d.getDone());
      o.setC8(d.getResultId().toString());
      o.setC10(d.getUserId() + "");
      if(d.getUserId() != null)
        o.setC9(dUser.get(d.getUserId()).getFio());
      //
      list.add(o);
    }
    return list;
  }

  @Override
  public List<Kdos> getKdos() {
    return dKdos.getAll();
  }

  @Override
  public void saveKdos(Session session, String[] ids) {
    if (ids != null && ids.length > 0) {
      Patients pat = dPatient.get(session.getCurPat());
      Long pricedUzi = dLvPlan.getCount("From LvPlans Where kdo.priced = 'Y' And kdoType.id = 4 And patientId = " + session.getCurPat());
      for(String id : ids) {
        LvPlans p = new LvPlans();
        Kdos kdo = dKdos.get(Integer.parseInt(id));
        p.setKdo(kdo);
        p.setKdoType(kdo.getKdoType());
        p.setDone("N");
        p.setPatientId(session.getCurPat());
        p.setResultId(0);
        p.setCrOn(new Date());
        p.setPrice(pat.getCounteryId() == 199 ? kdo.getPrice() : kdo.getFor_price());
        p.setCashState(p.getPrice() == null || p.getPrice() == 0 ? "FREE" : "ENT");
        if(p.getPrice() == null || p.getPrice() == 0) p.setPayDate(new Date());
        p.setUserId(session.getUserId());
        if(kdo.getKdoType().getId() == 4 && kdo.getPriced() != null && kdo.getPriced().equals("Y") && pricedUzi == 0) {
          p.setPrice(0D);
          p.setCashState("PAID");
          p.setPayDate(new Date());
        }
        dLvPlan.save(p);
        if(kdo.getPriced() != null && kdo.getPriced().equals("Y"))
          pricedUzi++;
      }
    }
  }

  @Override
  public void createEpicModel(LvEpics epic) {
    Patients patient = dPatient.get(epic.getPatientId());
    epic.setDateBegin(patient.getStartEpicDate());
    epic.setDeptId(patient.getDept().getId());
    epic.setLvId(patient.getLv_id());
    epic.setPalata(patient.getPalata());
    epic.setRoom(patient.getRoom());
  }

  @Override
  public void saveEpic(LvEpics epic) {
    Patients pat = dPatient.get(epic.getPatientId());
    if(!pat.getRoom().getId().equals(epic.getRoom().getId()) || !pat.getLv_id().equals(epic.getLvId()) || !pat.getDept().getId().equals(epic.getDeptId())) {
      //
      LvEpics e = new LvEpics();
      e.setDateBegin(epic.getDateBegin());
      e.setDateEnd(epic.getDateEnd());
      e.setLvId(pat.getLv_id());
      e.setDeptId(pat.getDept().getId());
      e.setRoom(pat.getRoom());
      e.setPatientId(epic.getPatientId());
      e.setKoyko(epic.getKoyko());
      e.setPrice(epic.getPrice());
      //
      pat.setLv_id(epic.getLvId());
      pat.setLv_dept_id(dUser.get(epic.getLvId()).getDept().getId());
      pat.setDept(dDept.get(epic.getDeptId()));
      pat.setRoom(epic.getRoom());
      pat.setStartEpicDate(epic.getDateEnd());
      //
      dPatient.save(pat);
      dLvEpic.save(e);
    }
  }

  @Override
  public List<ObjList> getEpicGrid(Integer patientId) {
    List<LvEpics> epics = dLvEpic.getPatientEpics(patientId);
    List<ObjList> list = new ArrayList<ObjList>();
    for(LvEpics epic : epics){
      ObjList o = new ObjList();
      o.setC1(Util.dateToString(epic.getDateBegin()));
      o.setC2(Util.dateToString(epic.getDateEnd()));
      o.setC3(dDept.get(epic.getDeptId()).getName());
      o.setC4(epic.getPalata());
      if (epic.getRoom() != null)
        o.setC4(epic.getRoom().getName() + " " + epic.getRoom().getFloor().getName() + " " + epic.getRoom().getRoomType().getName());
      if(epic.getLvId() != null)
        o.setC5(dUser.get(epic.getLvId()).getFio());
      list.add(o);
    }
    return list;
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

  @Override
  public List<PatientDrug> getPatientDrugs(int curPat) {
    List<PatientDrug> drugs = new ArrayList<PatientDrug>();
    List<PatientDrugs> patientDrugs = dPatientDrug.byPatient(curPat);
    for(PatientDrugs pd: patientDrugs) {
      PatientDrug drug = new PatientDrug();
      drug.setId(pd.getId());
      drug.setPatient(pd.getPatient());
      drug.setGoal(pd.getGoal());
      drug.setDrugType(pd.getDrugType());
      drug.setInjectionType(pd.getInjectionType());
      List<PatientDrugRow> rows = new ArrayList<PatientDrugRow>();
      boolean canDel = true;
      for(PatientDrugRows patientDrugRow: dPatientDrugRow.getList("From PatientDrugRows Where patientDrug.id = " + drug.getId())) {
        PatientDrugRow row = new PatientDrugRow();
        row.setId(patientDrugRow.getId());
        row.setDrug(patientDrugRow.getDrug());
        row.setName(patientDrugRow.getSource().equals("own") ? patientDrugRow.getName() : patientDrugRow.getDrug().getName());
        if(!patientDrugRow.getSource().equals("own"))
          row.setName(row.getName() + " (" + patientDrugRow.getExpanse() + " " + (patientDrugRow.getMeasure() != null ? patientDrugRow.getMeasure().getName() : "") + ")");
        row.setExpanse(patientDrugRow.getExpanse());
        row.setSource(patientDrugRow.getSource());
        row.setState(patientDrugRow.getState());
        row.setMeasure(patientDrugRow.getMeasure());
        if(!row.getState().equals("ENT")) canDel = false;
        rows.add(row);
      }
      drug.setRows(rows);
      drug.setCanDel(canDel || rows.size() == 0);
      List<PatientDrugDate> dates = new ArrayList<PatientDrugDate>();
      for(PatientDrugDates dd: dPatientDrugDate.getList("From PatientDrugDates Where patientDrug.id = " + pd.getId())) {
        PatientDrugDate date = new PatientDrugDate();
        date.setId(dd.getId());
        date.setDate(dd.getDate());
        date.setChecked(dd.isChecked());
        date.setDateMonth(Util.dateToString(dd.getDate()).substring(0, 5));
        date.setState(dd.getState());
        dates.add(date);
      }
      drug.setDates(dates);
      drug.setState(pd.getState());
      String time = "";
      if(pd.isMorningTime()) time += "Утром" + (pd.isMorningTimeBefore() ? " до еды" : "") + (pd.isMorningTimeAfter() ? " после еды" : "");
      if(pd.isNoonTime()) time += (time.equals("") ? "" : ", ") + "Днем" + (pd.isNoonTimeBefore() ? " до еды" : "") + (pd.isNoonTimeAfter() ? " после еды" : "");
      if(pd.isEveningTime()) time += (time.equals("") ? "" : ", ") + "Вечером" + (pd.isEveningTimeBefore() ? " до еды" : "") + (pd.isEveningTimeAfter() ? " после еды" : "");
      drug.setNote((time.equals("") ? "" : time + "; ") + " " + pd.getNote());
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
    PatientDrugs pd = dPatientDrug.get(id);
    drug.setId(pd.getId());
    drug.setPatient(pd.getPatient());
    drug.setGoal(pd.getGoal());
    drug.setDrugType(pd.getDrugType());
    drug.setInjectionType(pd.getInjectionType());
    List<PatientDrugRow> rows = new ArrayList<PatientDrugRow>();
    for(PatientDrugRows patientDrugRow: dPatientDrugRow.getList("From PatientDrugRows Where patientDrug.id = " + id)) {
      PatientDrugRow row = new PatientDrugRow();
      row.setId(patientDrugRow.getId());
      if(patientDrugRow.getSource().equals("own")) {
        row.setName(patientDrugRow.getName());
      } else {
        row.setName(patientDrugRow.getDrug().getName());
      }
      row.setExpanse(patientDrugRow.getExpanse());
      row.setSource(patientDrugRow.getSource());
      row.setState(patientDrugRow.getState());
      row.setMeasure(patientDrugRow.getMeasure());
      rows.add(row);
    }
    drug.setRows(rows);
    List<PatientDrugDate> dates = new ArrayList<PatientDrugDate>();
    for(PatientDrugDates dd: dPatientDrugDate.getList("From PatientDrugDates Where patientDrug.id = " + id)) {
      PatientDrugDate date = new PatientDrugDate();
      date.setId(dd.getId());
      date.setDate(dd.getDate());
      date.setChecked(dd.isChecked());
      date.setState(dd.getState());
      dates.add(date);
    }
    drug.setDates(dates);
    drug.setState(pd.getState());

    drug.setMorningTime(pd.isMorningTime());
    drug.setNoonTime(pd.isNoonTime());
    drug.setEveningTime(pd.isEveningTime());

    drug.setMorningTimeBefore(pd.isMorningTimeBefore());
    drug.setMorningTimeAfter(pd.isMorningTimeAfter());
    drug.setNoonTimeBefore(pd.isNoonTimeBefore());
    drug.setNoonTimeAfter(pd.isNoonTimeAfter());
    drug.setEveningTimeBefore(pd.isEveningTimeBefore());
    drug.setEveningTimeAfter(pd.isEveningTimeAfter());

    drug.setNote(pd.getNote());
    drug.setDateBegin(pd.getDateBegin());
    drug.setDateEnd(pd.getDateEnd());
    drug.setCrBy(pd.getCrBy());
    drug.setCrOn(pd.getCrOn());
    return drug;
  }

  @Override
  public double getPatientKoykoPrice(Patients patient) {
    Double KOYKA_PRICE_LUX_UZB = Double.parseDouble(dParam.byCode("KOYKA_PRICE_LUX_UZB"));
    Double KOYKA_PRICE_SIMPLE_UZB = Double.parseDouble(dParam.byCode("KOYKA_PRICE_SIMPLE_UZB"));
    Double KOYKA_SEMILUX_UZB = Double.parseDouble(dParam.byCode("KOYKA_SEMILUX_UZB"));
    Double KOYKA_PRICE_LUX = Double.parseDouble(dParam.byCode("KOYKA_PRICE_LUX"));
    Double KOYKA_PRICE_SIMPLE = Double.parseDouble(dParam.byCode("KOYKA_PRICE_SIMPLE"));
    Double KOYKA_SEMILUX = Double.parseDouble(dParam.byCode("KOYKA_SEMILUX"));
    if(patient.getCounteryId() == 199) { // Узбекистан
      if(patient.getRoom().getRoomType().getId() == 5)  // Люкс
        return KOYKA_PRICE_LUX_UZB;
      else if(patient.getRoom().getRoomType().getId() == 6) // Протая
        return KOYKA_PRICE_SIMPLE_UZB;
      else // Полулюкс
        return KOYKA_SEMILUX_UZB;
    } else {
      if(patient.getRoom().getRoomType().getId() == 5)  // Люкс
        return KOYKA_PRICE_LUX;
      else if(patient.getRoom().getRoomType().getId() == 6) // Протая
        return KOYKA_PRICE_SIMPLE;
      else // Полулюкс
        return KOYKA_SEMILUX;
    }
  }

  @Override
  public List<PatientDrug> getDrugsByType(int curPat, int type) {
    return getDrugsByType(curPat, type, false);
  }

  @Override
  public List<PatientDrug> getDrugsByType(int curPat, int type, boolean isLv) {
    List<PatientDrug> drugs = new ArrayList<PatientDrug>();
    List<PatientDrugs> patientDrugs = dPatientDrug.byType(curPat, type);
    for(PatientDrugs pd: patientDrugs) {
      PatientDrug drug = new PatientDrug();
      drug.setId(pd.getId());
      drug.setPatient(pd.getPatient());
      drug.setGoal(pd.getGoal());
      List<PatientDrugRow> rows = new ArrayList<PatientDrugRow>();
      boolean canDel = true;
      for(PatientDrugRows patientDrugRow: dPatientDrugRow.getList("From PatientDrugRows Where patientDrug.id = " + drug.getId())) {
        PatientDrugRow row = new PatientDrugRow();
        row.setName(patientDrugRow.getSource().equals("own") ? patientDrugRow.getName() : patientDrugRow.getDrug().getName());
        if(!patientDrugRow.getSource().equals("own"))
          row.setName(row.getName() + (isLv ? "" : " (" + patientDrugRow.getExpanse() + " " + patientDrugRow.getMeasure().getName() + ")"));
        row.setExpanse(patientDrugRow.getExpanse());
        row.setSource(patientDrugRow.getSource());
        row.setState(patientDrugRow.getState());
        if(!row.getState().equals("ENT")) canDel = false;
        rows.add(row);
      }
      drug.setInjectionType(pd.getInjectionType());
      drug.setRows(rows);
      drug.setCanDel(canDel || rows.size() == 0);
      List<PatientDrugDate> dates = new ArrayList<PatientDrugDate>();
      for(PatientDrugDates dd: dPatientDrugDate.getList("From PatientDrugDates Where patientDrug.id = " + pd.getId())) {
        PatientDrugDate date = new PatientDrugDate();
        date.setDate(dd.getDate());
        date.setDateMonth(Util.dateToString(dd.getDate()).substring(0, 5));
        date.setChecked(dd.isChecked());
        date.setState(dd.getState());
        dates.add(date);
      }
      drug.setDates(dates);
      drug.setState(pd.getState());
      String time = "";
      if(pd.isMorningTime()) time += "Утром" + (pd.isMorningTimeBefore() ? " до еды" : "") + (pd.isMorningTimeAfter() ? " после еды" : "");
      if(pd.isNoonTime()) time += (time.equals("") ? "" : ", ") + "Днем" + (pd.isNoonTimeBefore() ? " до еды" : "") + (pd.isNoonTimeAfter() ? " после еды" : "");
      if(pd.isEveningTime()) time += (time.equals("") ? "" : ", ") + "Вечером" + (pd.isEveningTimeBefore() ? " до еды" : "") + (pd.isEveningTimeAfter() ? " после еды" : "");
      drug.setNote((time.equals("") ? "" : time + "; ") + " " + pd.getNote());
      drug.setDateBegin(pd.getDateBegin());
      drug.setDateEnd(pd.getDateEnd());
      drug.setCrBy(pd.getCrBy());
      drug.setCrOn(pd.getCrOn());
      drugs.add(drug);
    }
    return drugs;
  }
}
