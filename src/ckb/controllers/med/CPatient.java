package ckb.controllers.med;


import ckb.dao.admin.dicts.DDict;
import ckb.dao.admin.users.DUser;
import ckb.dao.med.dicts.rooms.DRooms;
import ckb.dao.med.head_nurse.patient.DHNPatient;
import ckb.dao.med.kdos.DKdoTypes;
import ckb.dao.med.kdos.DKdos;
import ckb.dao.med.lv.fizio.DLvFizioDate;
import ckb.dao.med.lv.fizio.DLvFizioDateH;
import ckb.dao.med.lv.plan.DLvPlan;
import ckb.dao.med.patient.DPatient;
import ckb.dao.med.patient.DPatientPlan;
import ckb.domains.med.lv.LvFizioDates;
import ckb.domains.med.lv.LvFizioDatesH;
import ckb.domains.med.lv.LvPlans;
import ckb.domains.med.patient.PatientPlans;
import ckb.domains.med.patient.Patients;
import ckb.models.Grid;
import ckb.models.ObjList;
import ckb.services.med.kdo.SKdo;
import ckb.services.med.patient.SPatient;
import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.DB;
import ckb.utils.Req;
import ckb.utils.Util;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.view.RedirectView;

import javax.servlet.http.HttpServletRequest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

@Controller
@RequestMapping("/patients")
public class CPatient {

  private Session session = null;
  @Autowired SPatient sPatient;
  @Autowired SKdo sKdo;
  @Autowired DPatient dPatient;
  @Autowired DUser dUser;
  @Autowired DPatientPlan dPatientPlan;
  @Autowired DKdoTypes dKdoType;
  @Autowired DKdos dKdos;
  @Autowired DLvPlan dLvPlan;
  @Autowired DDict dDict;
  @Autowired DRooms dRoom;
  @Autowired DHNPatient dhnPatient;
  @Autowired DLvFizioDate dLvFizioDate;
  @Autowired DLvFizioDateH dLvFizioDateH;

  private final Logger logger = Logger.getLogger(CPatient.class);

  @RequestMapping("/index.s")
  protected RedirectView index(HttpServletRequest r) {
    try {
      session = SessionUtil.getUser(r);
      String query = "grid=1";
      if (!Req.isNull(r, "filter"))
        query = "filter=" + Req.get(r, "filter");
      if (!Req.isNull(r, "filterInput")) {
        query += "&filterInput=" + Util.toUTF8(Req.get(r, "filterInput"));
        //query += "&filterInput=" + Req.get(r, "filterInput");
      }
      if (!Req.isNull(r, "action"))
        query += "&action=" + Req.get(r, "action");
      if (!Req.isNull(r, "column"))
        query += "&column=" + Req.get(r, "column");
      if (!Req.isNull(r, "colId"))
        query += "&colId=" + Req.get(r, "colId");
      if (!Req.isNull(r, "page"))
        query += "&page=" + Req.get(r, "page");
      //
      return new RedirectView(session.getCurUrl() + (session.getCurUrl().contains("?") ? "&" : "?") + query);
      //return "redirect:/" + session.getCurUrl() + (session.getCurUrl().contains("?") ? "&" : "?") + query;
    } catch (Exception e) {
      logger.error("index.s: " + e.getMessage());
      return null;
    }
  }

  @RequestMapping("/list.s")
  protected String main(HttpServletRequest r, Model model){
    try {
      session = SessionUtil.getUser(r);
      String curPat = Req.get(r, "curPat");
      session.setCurUrl("/patients/list.s" + (curPat.equals("") ? "" : "?curPat=Y"));
      session.setArchive(false);
      session.setCurPat(0);
      session.setBackUrl(session.getCurUrl());
      String sql = " From Patients t Where t.state != 'ARCH' ";
      model.addAttribute("gridHeight", "99");
      // Врачу ПП не показываем пациентов ПП медсестры
      if (session.getRoleId() == 4)
        sql += " And t.state != 'PRN' ";
      if (session.getRoleId() == 5) { // Лечащий врач
        sql += " And t.state in ('LV', 'ZGV') ";
        if (dUser.get(session.getUserId()).isZavlv()) // Леч врач + заведующий отделом
          sql += " And t.lv_dept_id = " + session.getDeptId();
        else
          sql += " And t.lv_id = " + session.getUserId();
      }
      if (session.getRoleId() == 11) { // Постовой
        sql += " And t.state in ('LV', 'ZGV') ";
        sql += " And t.dept_id = " + session.getDeptId();
      }
      if (session.getRoleId() == 6 && "".equals(curPat))
        sql += " And t.state = 'ZGV'";
      if (session.getRoleId() == 6 && !"".equals(curPat))
        sql += session.isParamEqual("CLINIC_CODE", "fm") ? " And t.state in ('LV', 'CZG')" : " And t.state = 'LV'";
      if (session.getRoleId() == 7) {
        model.addAttribute("gridHeight", "65");
        String ids = session.getKdoTypesIds().toString();
        ids = ids.substring(1, ids.length() - 1);
        sql += " And Exists (Select 1 From Patient_Plans c Where t.id = c.patient_id And c.actDate <= CURRENT_TIMESTAMP() And c.Kdo_Type_Id in (" + ids + ")) ";
      }
      if (session.getRoleId() == 8)
        sql += " And t.state = 'LV'";
      if (session.getRoleId() == 16)
        sql += " And t.fizio = 1 ";
      // Фильтр
      if (!Req.isNull(r, "filter") || !Util.nvl(session.getFilterFio()).equals("")) {
        session.setFiltered(true);
        if (!Req.isNull(r, "filter")) {
          String filterWord = Req.get(r, "filterInput");
          //String filterWord = Util.toUTF8(Req.get(r, "filterInput"));
          session.setFilterFio(filterWord);
        }
        if (session.getFilterFio().equals(""))
          session.setFiltered(false);
        sql += " And ( " +
          "Upper(t.surname) like Upper('%" + session.getFilterFio() + "%') Or " +
          "Upper(t.name) Like Upper('%" + session.getFilterFio() + "%') Or " +
          "Upper(t.middlename) Like Upper('%" + session.getFilterFio() + "%') Or " +
          "Upper(t.yearNum) Like Upper('%" + session.getFilterFio() + "%') " +
          ")";
      }
      sql += session.getFilterSql();
      Grid grid = SessionUtil.getGrid(r, "patientGrid");
      grid.setPageSize(200);
      if (Req.get(r, "action").equals("sort")) {
        grid.setPage(1);
        if (grid.getOrderCol().equals(Req.get(r, "column"))) {
          grid.setOrderType(grid.getOrderType().equals("") ? "asc" : grid.getOrderType().equals("asc") ? "desc" : grid.getOrderType().equals("desc") ? "" : grid.getOrderType());
        } else {
          grid.setOrderType("asc");
        }
        grid.setOrderCol(Req.get(r, "column"));
        grid.setOrderColId("th" + (Req.get(r, "colId").equals("") ? Req.get(r, "column") : Req.get(r, "colId")));
      } else if (Req.get(r, "action").equals("") && session.getRoleId() != 5) {
        grid.init();
      }
      if (!grid.getOrderType().equals(""))
        sql += " Order By " + grid.getOrderCol() + " " + grid.getOrderType();
      else
        sql += " Order By t.id Desc";
      model.addAttribute("htmlClass", grid.getOrderType().equals("") ? "sorting" : "sorting_" + grid.getOrderType());
      model.addAttribute("newFieldId", grid.getOrderColId());
      if (Req.get(r, "action").equals("page"))
        grid.setPage(Req.getInt(r, "page"));
      if (Req.get(r, "action").equals("prev"))
        grid.setPage(grid.getPage() - 1);
      if (Req.get(r, "action").equals("begin"))
        grid.setPage(1);
      if (Req.get(r, "action").equals("next"))
        grid.setPage(grid.getPage() + 1);
      if (Req.get(r, "action").equals("end"))
        grid.setPage(grid.getMaxPage());
      grid.setSql(sql);
      grid.setRowCount(sPatient.getCount(session, sql));
      Long tail = grid.getRowCount() % grid.getPageSize();
      grid.setMaxPage(tail == 0 ? Math.round(grid.getRowCount() / grid.getPageSize()) : Math.round(grid.getRowCount() / grid.getPageSize()) + 1);
      grid.setStartPos((grid.getPage() - 1) * grid.getPageSize() + 1);
      if (grid.getStartPos() == 1)
        grid.setEndPos(grid.getRowCount() < grid.getPageSize() ? Integer.parseInt("" + grid.getRowCount()) : grid.getPageSize());
      else
        grid.setEndPos(grid.getStartPos() + grid.getPageSize() < grid.getRowCount() ? grid.getStartPos() + grid.getPageSize() - 1 : Integer.valueOf("" + grid.getRowCount()));
      if (grid.getEndPos() == 0)
        grid.setStartPos(0);
      SessionUtil.addSession(r, "patientGrid", grid);
      model.addAttribute("list", sPatient.getGridList(grid, session));
      model.addAttribute("roleId", session.getRoleId());
      model.addAttribute("curUrl", session.getCurUrl());
      sPatient.makeAddEditUrlByRole(model, session.getRoleId(), curPat);
      Util.makeMsg(r, model);
      return "med/patients/" + (session.isParamEqual("CLINIC_CODE", "fm") ? "fm/" : "") + "index";
    } catch (Exception e) {
      logger.error("list.s: " + e.getMessage());
      return null;
    }
  }

  @RequestMapping(value = "/setFilter.s", method = RequestMethod.POST)
  @ResponseBody
  protected void setFilter(HttpServletRequest req){
    session = SessionUtil.getUser(req);
    session.clearFilter();
    String[] filters = {"birthBegin", "birthEnd", "regDateBegin", "regDateEnd", "vypDateBegin", "vypDateEnd", "lv_id", "dept_id"};
    HashMap<String, String> hash = new HashMap<String, String>();
    for(String filter : filters) {
      if(Util.isNotNull(req, filter)) {
        hash.put(filter, Util.get(req, filter));
      }
    }
    session.setFilters(hash);
  }

  @RequestMapping("/archive.s")
  protected String archive(HttpServletRequest r, Model m){
    try {
      session = SessionUtil.getUser(r);
      session.setCurUrl("/patients/archive.s");
      session.setArchive(true);
      session.setCurPat(0);
      session.setBackUrl(session.getCurUrl());
      String sql = " From Patients t Where t.state = 'ARCH' ";
      m.addAttribute("gridHeight", "99");
      // Фильтр
      if(!Req.isNull(r, "filter") || !Util.nvl(session.getFilterFio()).equals("")) {
        session.setFiltered(true);
        if(!Req.isNull(r, "filter"))
          session.setFilterFio(Req.get(r, "filterInput"));
        if(session.getFilterFio().equals(""))
          session.setFiltered(false);
        sql += " And ( " +
          "Upper(t.surname) like Upper('%" + session.getFilterFio() + "%') Or " +
          "Upper(t.name) Like Upper('%" + session.getFilterFio() + "%') Or " +
          "Upper(t.middlename) Like Upper('%" + session.getFilterFio() + "%') Or " +
          "Upper(t.yearNum) Like Upper('%" + session.getFilterFio() + "%') " +
          ")";
        //sql += " And ( Upper(t.surname) like Upper('%" + session.getFilterFio() + "%') Or Upper(t.name) Like Upper('%" + session.getFilterFio() + "%') Or Upper(t.middlename) Like Upper('%" + session.getFilterFio() + "%'))";
      }
      // Фильтр
      if(!Req.isNull(r, "filter") || !Util.nvl(session.getFilterFio()).equals("")) {
        session.setFiltered(true);
        if(!Req.isNull(r, "filter"))
          session.setFilterFio(Req.get(r, "filterInput"));
        if(session.getFilterFio().equals(""))
          session.setFiltered(false);
        sql += " And ( " +
          "Upper(t.surname) like Upper('%" + session.getFilterFio() + "%') Or " +
          "Upper(t.name) Like Upper('%" + session.getFilterFio() + "%') Or " +
          "Upper(t.middlename) Like Upper('%" + session.getFilterFio() + "%') Or " +
          "Upper(t.yearNum) Like Upper('%" + session.getFilterFio() + "%') " +
          ")";
        //sql += " And ( Upper(t.surname) like Upper('%" + session.getFilterFio() + "%') Or Upper(t.name) Like Upper('%" + session.getFilterFio() + "%') Or Upper(t.middlename) Like Upper('%" + session.getFilterFio() + "%'))";
      }
      sql += session.getFilterSql();
      Grid grid = SessionUtil.getGrid(r, "patientGrid");
      grid.setPageSize(100);
      if(Req.get(r, "action").equals("sort")) {
        grid.setPage(1);
        if (grid.getOrderCol().equals(Req.get(r, "column"))) {
          grid.setOrderType(grid.getOrderType().equals("") ? "asc" : grid.getOrderType().equals("asc") ? "desc" : grid.getOrderType().equals("desc") ? "" : grid.getOrderType());
        } else {
          grid.setOrderType("asc");
        }
        grid.setOrderCol(Req.get(r, "column"));
        grid.setOrderColId("th" + (Req.get(r, "colId").equals("") ? Req.get(r, "column") : Req.get(r, "colId")));
      } else if(Req.get(r, "action").equals("")) {
        grid.init();
      }
      if(!grid.getOrderType().equals(""))
        sql += " Order By " + grid.getOrderCol() + " " + grid.getOrderType();
      else
        sql += " Order By t.id Desc";
      m.addAttribute("htmlClass", grid.getOrderType().equals("") ? "sorting" : "sorting_" + grid.getOrderType());
      m.addAttribute("newFieldId", grid.getOrderColId());
      if(Req.get(r, "action").equals("page")) {
        grid.setPage(Req.getInt(r, "page"));
      }
      if (Req.get(r, "action").equals("prev"))
        grid.setPage(grid.getPage() - 1);
      if (Req.get(r, "action").equals("begin"))
        grid.setPage(1);
      if (Req.get(r, "action").equals("next"))
        grid.setPage(grid.getPage() + 1);
      if (Req.get(r, "action").equals("end"))
        grid.setPage(grid.getMaxPage());
      grid.setSql(sql);
      grid.setRowCount(sPatient.getCount(session, sql));

      grid.setMaxPage(Math.round(grid.getRowCount() / grid.getPageSize()) + 1);
      grid.setStartPos((grid.getPage() - 1) * grid.getPageSize() + 1);
      if(grid.getStartPos() == 1)
        grid.setEndPos(grid.getRowCount() < grid.getPageSize() ? Integer.parseInt("" + grid.getRowCount()) : grid.getPageSize());
      else
        grid.setEndPos(grid.getStartPos() + grid.getPageSize() < grid.getRowCount() ? grid.getStartPos() + grid.getPageSize() : Integer.valueOf("" + grid.getRowCount()));
      if(grid.getEndPos() == 0)
        grid.setStartPos(0);
      SessionUtil.addSession(r, "patientGrid", grid);
      m.addAttribute("list", sPatient.getGridList(grid, session));
      m.addAttribute("roleId", session.getRoleId());
      m.addAttribute("curUrl", session.getCurUrl());
      m.addAttribute("addEditUrl", session.getRoleId() == 13 ? "/cashbox/stat.s?id=" : "/view/index.s?id=");
      Util.makeMsg(r, m);
      return "med/patients/" + (session.isParamEqual("CLINIC_CODE", "fm") ? "fm/" : "") + "index";
    } catch (Exception e) {
      logger.error("archive.s: " + e.getMessage());
      return null;
    }
  }

  @RequestMapping("/consul.s")
  protected String consul(HttpServletRequest r, Model m){
    try {
      session = SessionUtil.getUser(r);
      session.setCurUrl("/patients/consul.s");
      session.setCurPat(0);
      session.setBackUrl(session.getCurUrl());
      String sql = " From Patients t Where t.state != 'ARCH' And t.id in (Select c.patientId From Lv_Consuls c Where c.lvId = " + session.getUserId()+ ")";
      m.addAttribute("gridHeight", "99");
      Grid grid = SessionUtil.getGrid(r, "patientGrid");

      if(Req.get(r, "action").equals("sort")) {
        grid.setPage(1);
        if (grid.getOrderCol().equals(Req.get(r, "column"))) {
          grid.setOrderType(grid.getOrderType().equals("") ? "asc" : grid.getOrderType().equals("asc") ? "desc" : grid.getOrderType().equals("desc") ? "" : grid.getOrderType());
        } else {
          grid.setOrderType("asc");
        }
        grid.setOrderCol(Req.get(r, "column"));
        grid.setOrderColId("th" + (Req.get(r, "colId").equals("") ? Req.get(r, "column") : Req.get(r, "colId")));
      } else if(Req.get(r, "action").equals("")) {
        grid.init();
      }
      if(!grid.getOrderType().equals(""))
        sql += " Order By " + grid.getOrderCol() + " " + grid.getOrderType();
      else
        sql += " Order By t.id Desc";
      m.addAttribute("htmlClass", grid.getOrderType().equals("") ? "sorting" : "sorting_" + grid.getOrderType());
      m.addAttribute("newFieldId", grid.getOrderColId());
      if(Req.get(r, "action").equals("page")) {
        grid.setPage(Req.getInt(r, "page"));
      }
      if (Req.get(r, "action").equals("prev"))
        grid.setPage(grid.getPage() - 1);
      if (Req.get(r, "action").equals("begin"))
        grid.setPage(1);
      if (Req.get(r, "action").equals("next"))
        grid.setPage(grid.getPage() + 1);
      if (Req.get(r, "action").equals("end"))
        grid.setPage(grid.getMaxPage());
      grid.setSql(sql);
      grid.setRowCount(sPatient.getCount(session, sql));

      grid.setMaxPage(Math.round(grid.getRowCount() / grid.getPageSize()) + 1);
      grid.setStartPos((grid.getPage() - 1) * grid.getPageSize() + 1);
      if(grid.getStartPos() == 1)
        grid.setEndPos(grid.getRowCount() < grid.getPageSize() ? Integer.parseInt("" + grid.getRowCount()) : grid.getPageSize());
      else
        grid.setEndPos(grid.getStartPos() + grid.getPageSize() < grid.getRowCount() ? grid.getStartPos() + grid.getPageSize() : Integer.valueOf("" + grid.getRowCount()));
      if(grid.getEndPos() == 0)
        grid.setStartPos(0);
      SessionUtil.addSession(r, "patientGrid", grid);
      m.addAttribute("list", sPatient.getGridList(grid, session));
      m.addAttribute("roleId", session.getRoleId());
      m.addAttribute("curUrl", session.getCurUrl());
      m.addAttribute("addEditUrl", "/view/index.s?id=");
      Util.makeMsg(r, m);
      return "med/patients/" + (session.isParamEqual("CLINIC_CODE", "fm") ? "fm/" : "") + "index";
    } catch (Exception e) {
      logger.error("consul.s: " + e.getMessage());
      return null;
    }
  }

  @RequestMapping("/confirm.s")
  protected String confirm(HttpServletRequest r){
    try {
      session = SessionUtil.getUser(r);
      String[] ids = r.getParameterValues("id");
      for (String id : ids) {
        Patients p = dPatient.get(Integer.parseInt(id));
        if (session.getRoleId() == 3) { // Медсестра ПП
          LvPlans plan = new LvPlans();
          plan.setActDate(Util.stringToDate(Util.getCurDate()));
          plan.setKdo(dKdos.get(50));
          plan.setDone("N");
          plan.setPrice(0D);
          plan.setCashState("FREE");
          plan.setKdoType(dKdos.get(50).getKdoType());
          plan.setUserId(SessionUtil.getUser(r).getUserId());
          plan.setPatientId(p.getId());
          plan.setResultId(0);
          plan.setCrOn(new Date());
          dLvPlan.save(plan);

          PatientPlans pp = new PatientPlans();
          pp.setPlan_Id(plan.getId());
          pp.setKdo_type_id(plan.getKdoType().getId());
          pp.setActDate(plan.getActDate());
          pp.setPatient_id(plan.getPatientId());
          dPatientPlan.save(pp);
          //
          p.setState("PRD"); // Передается врачу приемного пакоя
          dPatient.save(p);
        }
        if (session.getRoleId() == 4) { // Доктор ПП
          if(session.getParam("CLINIC_CODE").equals("fm")) {
            p.setState("CZG"); // Отправляется леч. врачу
            dPatient.save(p);
          } else {
            if (p.getLv_id() != null && p.getDept() != null && p.getLv_id() != null && p.getDept().getId() != null) {
              p.setState("LV"); // Отправляется леч. врачу
              dPatient.save(p);
            }
          }
        }
        if (session.getRoleId() == 5 && p.getState().equals("LV")) {
          p.setState("ZGV");
          dPatient.save(p);
        }
        if (session.getRoleId() == 6 && p.getState().equals("ARCH")) {
          p.setState("LV");
          dPatient.save(p);
        }
        if (session.getRoleId() == 6 && p.getState().equals("ZGV")) {
          p.setState("ARCH");
          dPatient.save(p);
          dPatientPlan.delPatientTempPlans(p.getId());
          List<LvFizioDates> dates = dLvFizioDate.getList("From LvFizioDates t Where t.fizio.id = " + p.getId());
          for(LvFizioDates date: dates) {
            LvFizioDatesH d = new LvFizioDatesH();
            d.setDate(date.getDate());
            d.setDone(date.getDone());
            d.setState(date.getState());
            d.setFizio(date.getFizio());
            d.setConfDate(date.getConfDate());
            dLvFizioDateH.save(d);
            dLvFizioDate.delete(date.getId());
          }
        }
        if (session.getRoleId() == 6 && p.getState().equals("CZG") && p.getLv_id() != null) {
          p.setState("LV");
          dPatient.save(p);
        }
      }
      return "redirect:/patients/list.s?msgState=1&msgCode=successSave" + (session.getCurUrl().contains("curPat=Y") ? "&curPat=Y" : "");
    } catch (Exception e) {
      logger.error("confirm.s: " + e.getMessage());
      return null;
    }
  }

  @RequestMapping("/stat.s")
  protected String stat(HttpServletRequest req, Model model){
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/patients/stat.s");
    List<ObjList> list = new ArrayList<ObjList>();
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    Long regTotal = 0L, vypTotal = 0L, curTotal = 0L;
    try {
      conn = DB.getConnection();
      ps = conn.prepareStatement("SELECT t.id, t.fio FROM Users t WHERE t.lv = 1 AND t.active = 1 ORDER BY t.fio");
      ps.execute();
      rs = ps.getResultSet();
      while (rs.next()) {
        ObjList obj = new ObjList();
        obj.setC1(rs.getString(1));
        obj.setC2(rs.getString(2));
        Long reg = dPatient.getCount("From Patients Where state = 'LV' And date(dateBegin) = date(CURRENT_TIMESTAMP()) And lv_Id = " + obj.getC1());
        Long vyp = dPatient.getCount("From Patients Where state = 'LV' And date(dateEnd) = date(CURRENT_TIMESTAMP()) And lv_Id = " + obj.getC1());
        Long cur = dPatient.getCount("From Patients Where state = 'LV' And lv_Id = " + obj.getC1());
        obj.setC3("" + reg);
        obj.setC4("" + vyp);
        obj.setC5("" + cur);
        regTotal += reg;
        vypTotal += vyp;
        curTotal += cur;
        if(reg != 0 || vyp != 0 || cur != 0)
          list.add(obj);
      }
      ObjList obj = new ObjList();
      obj.setC1("0");
      obj.setC2("Всего");
      obj.setC3("" + regTotal);
      obj.setC4("" + vypTotal);
      obj.setC5("" + curTotal);
      list.add(obj);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(conn);
    }
    model.addAttribute("cur", dPatient.getCount("From Patients Where state = 'LV'"));
    model.addAttribute("vyp", dPatient.getCount("From Patients Where date(dateEnd) = date(CURRENT_TIMESTAMP())"));
    model.addAttribute("curMonth", dPatient.getCount("From Patients Where YEAR(dateEnd) = YEAR(CURRENT_TIMESTAMP()) And Month(dateEnd) = MONTH(CURRENT_TIMESTAMP())"));
    model.addAttribute("curYear", dPatient.getCount("From Patients Where YEAR(dateEnd) = YEAR(CURRENT_TIMESTAMP())"));
    model.addAttribute("lvs", list);
    return "med/patients/stat";
  }

  @RequestMapping("/contract.s")
  protected String contract(HttpServletRequest req, Model model) {
    session = SessionUtil.getUser(req);
    Patients pat = dPatient.get(session.getCurPat());
    model.addAttribute("pat", pat);
    model.addAttribute("price", pat.getRoomPrice());
    model.addAttribute("sysdate", Util.getCurDate());
    return "med/patients/contract";
  }

  /*@RequestMapping("/cashDetails.s")
  protected String cashDetails(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/patients/cashStat.s");
    List<ObjList> list = new ArrayList<ObjList>();
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      String startDate = Util.get(req, "period_start", Util.getCurDate());
      String endDate = Util.get(req, "period_end", Util.getCurDate());
      ps = session.getConn().prepareStatement("SELECT Sum(t.card + t.transfer + t.cash) total, Sum(t.card) card, Sum(t.transfer) transfer, Sum(t.cash) cash FROM Amb_Patients t Where Exists (Select 1 From Amb_Patient_Services c Where c.patient = t.Id And c.cashDate between ? and ?) ");
      ps.setString(1, Util.dateDBBegin(startDate));
      ps.setString(2, Util.dateDBEnd(endDate));
      rs = ps.executeQuery();
      ObjList obj = new ObjList();
      if(rs.next()){
        obj.setC1(rs.getString("card") == null ? "0" : rs.getString("card"));
        obj.setC3(rs.getString("transfer") == null ? "0" : rs.getString("transfer"));
        obj.setC4(rs.getString("cash") == null ? "0" : rs.getString("cash"));
        obj.setC20(rs.getString("total") == null ? "0" : rs.getString("total"));
      } else {
        obj.setC1("0");
        obj.setC2("0");
        obj.setC3("0");
        obj.setC4("0");
      }
      ps = session.getConn().prepareStatement("SELECT Sum(t.card + t.transfer + t.cash) total, Sum(t.card) card, Sum(t.transfer) transfer, Sum(t.cash) cash FROM Patient_Pays t WHERE date(t.crOn) between ? and ? ");
      ps.setString(1, Util.dateDB(startDate));
      ps.setString(2, Util.dateDB(endDate));
      rs = ps.executeQuery();
      if(rs.next()){
        obj.setC5(rs.getString("card") == null ? "0" : rs.getString("card"));
        obj.setC7(rs.getString("transfer") == null ? "0" : rs.getString("transfer"));
        obj.setC8(rs.getString("cash") == null ? "0" : rs.getString("cash"));
        obj.setC10(rs.getString("total") == null ? "0" : rs.getString("total"));
      } else {
        obj.setC5("0");
        obj.setC6("0");
        obj.setC7("0");
        obj.setC8("0");
      }
      model.addAttribute("obj", obj);
      model.addAttribute("period_start", startDate);
      model.addAttribute("period_end", endDate);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
    return "med/patients/cashStat";
  }*/

}
