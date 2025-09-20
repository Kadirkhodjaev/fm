package ckb.controllers.med;

import ckb.dao.admin.country.DCountry;
import ckb.dao.admin.dicts.DDict;
import ckb.dao.admin.dicts.DLvPartner;
import ckb.dao.admin.forms.DForm;
import ckb.dao.admin.region.DRegion;
import ckb.dao.admin.users.DUser;
import ckb.dao.med.amb.*;
import ckb.dao.med.drug.dict.drugs.DDrug;
import ckb.dao.med.kdos.DSalePack;
import ckb.dao.med.kdos.DSalePackRow;
import ckb.dao.med.patient.DPatient;
import ckb.dao.med.template.DTemplate;
import ckb.domains.admin.*;
import ckb.domains.med.amb.*;
import ckb.models.*;
import ckb.models.drugs.PatientDrug;
import ckb.models.drugs.PatientDrugDate;
import ckb.models.result.Doctor;
import ckb.models.result.Result;
import ckb.services.admin.form.SForm;
import ckb.services.med.amb.SAmb;
import ckb.services.med.results.SRkdo;
import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.*;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.util.*;
import java.util.concurrent.TimeUnit;

@Controller
@RequestMapping("/amb")
public class CAmb {

  //region AUTOWIRED
  private Session session = null;
  @Autowired private SAmb sAmb;
  @Autowired private SForm sForm;
  @Autowired private DForm dForm;
  @Autowired private DAmbPatient dAmbPatients;
  @Autowired private DAmbPatientService dAmbPatientServices;
  @Autowired private DAmbService dAmbServices;
  @Autowired private DAmbResult dAmbResults;
  @Autowired private DAmbServiceUser dAmbServiceUsers;
  @Autowired private DAmbGroup dAmbGroups;
  @Autowired private DAmbPatientLinks dAmbPatientLinks;
  @Autowired private DTemplate dTemplate;
  @Autowired private DAmbServiceField dAmbServiceFields;
  @Autowired private DLvPartner dLvPartner;
  @Autowired private DDrug dDrug;
  @Autowired private DDict dDict;
  @Autowired private DAmbDrug dAmbDrug;
  @Autowired private DAmbDrugDate dAmbDrugDate;
  @Autowired private DAmbDrugRow dAmbDrugRow;
  @Autowired private DPatient dPatient;
  @Autowired private SRkdo sRkdo;
  @Autowired private DAmbServiceUser dAmbServiceUser;
  @Autowired private DSalePack dSalePack;
  @Autowired private DSalePackRow dSalePackRow;
  @Autowired private DUser dUser;
  @Autowired private DCountry dCountry;
  @Autowired private DRegion dRegion;
  @Autowired private BeanSession beanSession;
  @Autowired private BeanUsers beanUsers;
  //endregion

  //region PATIENTS
  @RequestMapping(value = "/setFilter.s", method = RequestMethod.POST)
  @ResponseBody
  protected void setFilter(HttpServletRequest req){
    session = SessionUtil.getUser(req);
    session.clearFilter();
    String[] filters = {"birthBegin", "birthEnd", "regDateBegin", "regDateEnd", "group_id", "group_id", "state"};
    HashMap<String, String> hash = new HashMap<>();
    for(String filter : filters) {
      if(Util.isNotNull(req, filter)) {
        hash.put(filter, Util.get(req, filter));
      }
    }
    session.setAmbFilters(hash);
  }

  @RequestMapping("/home.s")
  protected String mains(HttpServletRequest r, Model model) {
    try {
      session = SessionUtil.getUser(r);
      session.setCurUrl("/amb/home.s");
      session.setArchive(false);
      session.setCurPat(0);
      session.setBackUrl(session.getCurUrl());
      String sql = " From Amb_Patients t Where t.state != 'ARCH' ";
      Users user = dUser.get(session.getUserId());
      if (session.getRoleId() == 14) {
        sql += " And (t.state in ('WORK', 'DONE') And Exists (Select 1 From Amb_Patient_Services c Where t.id = c.patient And c.State Not In ('DEL', 'AUTO_DEL') And c.worker_id = " + session.getUserId() + "))";
        if(user.isAmbFizio())
          sql += " Or (fizio = 'Y' And t.state != 'ARCH') ";
      }
      // ?????
      if (session.getRoleId() == 13)
        sql += " And t.state != 'PRN'";
      //region ??????
      if (!Req.isNull(r, "filter") || !Util.nvl(session.getFilterFio()).isEmpty()) {
        session.setFiltered(true);
        if (!Req.isNull(r, "filter"))
          session.setFilterFio(Req.get(r, "filterInput"));
        if (session.getFilterFio().isEmpty())
          session.setFiltered(false);
        sql += " And ( " +
          "Upper(t.surname) like Upper('%" + session.getFilterFio() + "%') Or " +
          "Upper(t.name) Like Upper('%" + session.getFilterFio() + "%') Or " +
          "Upper(t.middlename) Like Upper('%" + session.getFilterFio() + "%') " +
          ")";
      }
      sql += session.getAmbFilterSql();
      //endregion
      Grid grid = SessionUtil.getGrid(r, "AmbPatientGrid");
      grid.setPageSize(200);
      //region SORTIROVKA
      if (Req.get(r, "action").equals("sort")) {
        grid.setPage(1);
        if (grid.getOrderCol().equals(Req.get(r, "column"))) {
          grid.setOrderType(grid.getOrderType().isEmpty() ? "asc" : grid.getOrderType().equals("asc") ? "desc" : grid.getOrderType().equals("desc") ? "" : grid.getOrderType());
        } else {
          grid.setOrderType("asc");
        }
        grid.setOrderCol(Req.get(r, "column"));
        grid.setOrderColId("th" + (Req.get(r, "colId").isEmpty() ? Req.get(r, "column") : Req.get(r, "colId")));
      } else if (Req.get(r, "action").isEmpty() && session.getRoleId() != 5) {
        grid.init();
      }
      if (!grid.getOrderType().isEmpty())
        sql += " Order By " + grid.getOrderCol() + " " + grid.getOrderType();
      else
        sql += " Order By t.id Desc";
      model.addAttribute("htmlClass", grid.getOrderType().isEmpty() ? "sorting" : "sorting_" + grid.getOrderType());
      //endregion
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
      grid.setRowCount(sAmb.getCount(session, sql));
      Long tail = grid.getRowCount() % grid.getPageSize();
      grid.setMaxPage(tail == 0 ? Math.round(grid.getRowCount() / grid.getPageSize()) : Math.round(grid.getRowCount() / grid.getPageSize()) + 1);
      grid.setStartPos((grid.getPage() - 1) * grid.getPageSize() + 1);
      if (grid.getStartPos() == 1)
        grid.setEndPos(grid.getRowCount() < grid.getPageSize() ? Integer.parseInt("" + grid.getRowCount()) : grid.getPageSize());
      else
        grid.setEndPos(grid.getStartPos() + grid.getPageSize() < grid.getRowCount() ? grid.getStartPos() + grid.getPageSize() - 1 : Integer.parseInt("" + grid.getRowCount()));
      if (grid.getEndPos() == 0)
        grid.setStartPos(0);
      SessionUtil.addSession(r, "patientGrid", grid);
      model.addAttribute("list", sAmb.getGridList(grid, session));
      model.addAttribute("roleId", session.getRoleId());
      model.addAttribute("curUrl", session.getCurUrl());
      sAmb.makeAddEditUrlByRole(model, session.getRoleId(), session.isArchive());
      Util.makeMsg(r, model);
      return "med/amb/index";
    } catch (Exception e) {
      e.printStackTrace();
      return null;
    }
  }

  @RequestMapping("/archive.s")
  protected String archive(HttpServletRequest r, Model model) {
    try {
      session = SessionUtil.getUser(r);
      session.setCurUrl("/amb/archive.s");
      session.setArchive(true);
      session.setCurPat(0);
      session.setBackUrl(session.getCurUrl());
      String flag = Util.get(r, "flag", "");
      HashMap<String, String> filters = session.getFilters();
      if(flag.isEmpty() && filters.containsKey("amb_patient_flag"))
        flag = filters.get("amb_patient_flag");
      if(flag.equals("0")) flag = "";
      filters.put("amb_patient_flag", flag);
      String sql = " From Amb_Patients t Where emp is null And t.state = 'ARCH' " + (flag.isEmpty() ? "" : flag.equals("DONE") ? " And client_id is not null" : " And client_Id is null");
      //region Поиск
      if (!Req.isNull(r, "filter") || !Util.nvl(session.getFilterFio()).isEmpty()) {
        session.setFiltered(true);
        if (!Req.isNull(r, "filter"))
          session.setFilterFio(Req.get(r, "filterInput"));
        if (session.getFilterFio().isEmpty())
          session.setFiltered(false);
        sql += " And ( " +
          "Upper(t.surname) like Upper('%" + session.getFilterFio() + "%') Or " +
          "Upper(t.name) Like Upper('%" + session.getFilterFio() + "%') Or " +
          "Upper(t.middlename) Like Upper('%" + session.getFilterFio() + "%') " +
          ")";
      }
      sql += session.getAmbFilterSql();
      //endregion
      Grid grid = SessionUtil.getGrid(r, "AmbPatientGrid");
      grid.setPageSize(100);
      //region SORTIROVKA
      if (Req.get(r, "action").equals("sort")) {
        grid.setPage(1);
        if (grid.getOrderCol().equals(Req.get(r, "column"))) {
          grid.setOrderType(grid.getOrderType().isEmpty() ? "asc" : grid.getOrderType().equals("asc") ? "desc" : grid.getOrderType().equals("desc") ? "" : grid.getOrderType());
        } else {
          grid.setOrderType("asc");
        }
        grid.setOrderCol(Req.get(r, "column"));
        grid.setOrderColId("th" + (Req.get(r, "colId").isEmpty() ? Req.get(r, "column") : Req.get(r, "colId")));
      } else if (Req.get(r, "action").isEmpty() && session.getRoleId() != 5) {
        grid.init();
      }
      if (!grid.getOrderType().isEmpty())
        sql += " Order By " + grid.getOrderCol() + " " + grid.getOrderType();
      else
        sql += " Order By t.id Desc";
      model.addAttribute("htmlClass", grid.getOrderType().isEmpty() ? "sorting" : "sorting_" + grid.getOrderType());
      //endregion
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
      grid.setRowCount(sAmb.getCount(session, sql));
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
      model.addAttribute("list", sAmb.getGridList(grid, session));
      model.addAttribute("roleId", session.getRoleId());
      model.addAttribute("curUrl", session.getCurUrl());
      sAmb.makeAddEditUrlByRole(model, session.getRoleId(), session.isArchive());
      model.addAttribute("flag", flag);
      Util.makeMsg(r, model);
      return "med/amb/index";
    } catch (Exception e) {
      e.printStackTrace();
      return null;
    }
  }
  //endregion

  //region REGISTRATION
  @RequestMapping("/reg.s")
  protected String reg(@ModelAttribute("patient") AmbPatients p, HttpServletRequest req, Model m) {
    session = SessionUtil.getUser(req);
    boolean isDone = true;
    session.setCurPat(0);
    if (!Req.isNull(req, "id"))
      session.setCurPat(Req.getInt(req, "id"));
    session.setCurUrl("/amb/reg.s" + (Req.isNull(req, "id") ? "" : "?id=" + Req.get(req, "id")));
    sAmb.createModel(req, p);
    sForm.setSelectOptionModel(m, 1, "sex");
    List<AmbService> ss = new ArrayList<>();
    m.addAttribute("counteries", beanSession.getCounteries());
    m.addAttribute("regions", beanSession.getRegions());
    if(session.getCurPat() > 0 && Util.isNull(req, "reg")) {
      List<AmbPatientServices> services = dAmbPatientServices.getList("From AmbPatientServices Where patient = " + session.getCurPat());
      for(AmbPatientServices s: services) {
        AmbService d = new AmbService();
        d.setId(s.getId());
        d.setState(s.getState());
        d.setService(s.getService());
        d.setWorker(s.getWorker());
        d.setRepeat(false);
        d.setConfDate(s.getConfDate());
        d.setCrBy(s.getCrBy());
        d.setSaleProc(s.getSaleProc());
        d.setResultId(Util.nvl(s.getResult(), 0));
        if(Util.nvl(s.getPack(), 0) != 0) {
          d.setPack(dSalePack.get(s.getPack()).getName());
        }
        if("Y".equals(s.getService().getConsul()) && session.getRoleId() == 15 && "DONE".equals(s.getState())) {
          long diff = new Date().getTime() - p.getRegDate().getTime();
          if(diff / (1000*60*60*24) <= 5 && !"D".equals(s.getAmb_repeat()) && !"Y".equals(s.getAmb_repeat()))
            d.setRepeat(true);
        }
        if(!"DONE".equals(s.getState()) && !"DEL".equals(s.getState()) && !"AUTO_DEL".equals(s.getState()))
          isDone = false;
        List<Users> users = new ArrayList<>();
        if("ENT".equals(s.getState()) || ("PAID".equals(s.getState()) && p.getEmp() != null && Util.nvl(s.getResult(), 0) == 0 && s.getCrBy() == session.getUserId()) || ("PAID".equals(s.getState()) && session.getRoleId() == 15 && (s.getResult() == null || s.getResult() == 0))) {
          List<AmbServiceUsers> serviceUsers = dAmbServiceUser.getList("From AmbServiceUsers t Where t.service = " + s.getService().getId());
          for(AmbServiceUsers serviceUser: serviceUsers) users.add(beanUsers.get(serviceUser.getUser()));
        } else
          users.add(beanUsers.get(s.getWorker().getId()));
        d.setUsers(users);
        //
        String sum = new DecimalFormat("###,###,###,###,###,###.##").format(s.getPrice());
        if(!sum.contains(",")) sum = sum + ",00";
        d.setPrice(sum);
        //
        sum = new DecimalFormat("###,###,###,###,###,###.##").format(s.getPrice() + Util.nvl(s.getNds(), 0D));
        if (!sum.contains(",")) sum = sum + ",00";
        d.setNds(sum);
        //
        ss.add(d);
      }
      m.addAttribute("services", ss);
      Double summ = dAmbPatientServices.patientTotalSum(session.getCurPat()), nds = dAmbPatientServices.patientNdsSum(session.getCurPat());
      m.addAttribute("serviceTotal", summ);
      m.addAttribute("ndsTotal", nds + summ);
      m.addAttribute("histories", sAmb.getHistoryServices(session.getCurPat()));
    }
    m.addAttribute("countries", beanSession.getCounteries());
    m.addAttribute("regions", beanSession.getRegions());
    m.addAttribute("packs", dSalePack.getCount("From SalePacks Where state = 'A' And ambStat = 'AMB' "));
    m.addAttribute("countryName", p.getCounteryId() != null ? dCountry.get(p.getCounteryId()).getName() : "");
    m.addAttribute("regionName", p.getRegionId() != null ? dRegion.get(p.getRegionId()).getName() : "");
    m.addAttribute("lvpartners", dLvPartner.getList("From LvPartners " + (session.getCurPat() > 0 ? "" : " Where state = 'A' ") + " Order By code"));
    m.addAttribute("fizio_user", dUser.get(session.getUserId()).isAmbFizio());
    m.addAttribute("regId", Util.get(req, "reg"));
    m.addAttribute("done", isDone && session.getRoleId() == 15 && session.getCurPat() > 0 && !ss.isEmpty() && !p.getState().equals("ARCH"));
    m.addAttribute("drug_exist", dAmbDrug.getCount("From AmbDrugs Where patient.id = " + session.getCurPat()) > 0);
    if(Util.isNotNull(req, "stat"))
      m.addAttribute("pat", dPatient.get(Util.getInt(req, "stat")));
    Util.makeMsg(req, m);
    return "med/amb/reg";
  }

  @RequestMapping(value = "/reg.s", method = RequestMethod.POST)
  @ResponseBody
  protected String save(HttpServletRequest req) throws JSONException {
    session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      AmbPatients p = sAmb.save(req);
      p.setQrcode(Util.md5(p.getId().toString()));
      dAmbPatients.save(p);
      session.setCurPat(p.getId());
      String[] ids = req.getParameterValues("service");
      String[] users = req.getParameterValues("user");
      if(ids != null) {
        for(int i=0;i<ids.length;i++) {
          AmbPatientServices ser = dAmbPatientServices.get(Integer.parseInt(ids[i]));
          if(ser.getResult() == 0)
            ser.setWorker(beanUsers.get(Integer.parseInt(users[i])));
          dAmbPatientServices.save(ser);
        }
      }
      json.put("id", p.getId());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/setPartner.s", method = RequestMethod.POST)
  @ResponseBody
  protected String setPartner(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      AmbPatients pat = dAmbPatients.get(Util.getInt(req, "id"));
      pat.setLvpartner(dLvPartner.get(Util.getInt(req, "partner")));
      dAmbPatients.save(pat);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("/del.s")
  @ResponseBody
  protected String delPatient(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      if(dAmbPatients.get(session.getCurPat()).getState().equals("PRN")) {
        List<AmbPatientLinks> links = dAmbPatientLinks.getList("From AmbPatientLinks Where parent = " + session.getCurPat());
        for(AmbPatientLinks link: links)
          dAmbPatientLinks.delete(link.getId());
        List<AmbPatientLinks> lins = dAmbPatientLinks.getList("From AmbPatientLinks Where child = " + session.getCurPat());
        for(AmbPatientLinks link: lins)
          dAmbPatientLinks.delete(link.getId());
        List<AmbPatientServices> services = dAmbPatientServices.getList("From AmbPatientServices Where patient = " + session.getCurPat());
        for(AmbPatientServices ser : services)
          dAmbPatientServices.delete(ser.getId());
        dAmbPatients.delete(session.getCurPat());
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("/services.s")
  protected String serviceList(HttpServletRequest req, Model m){
    session = SessionUtil.getUser(req);
    //region Groups
    List<AmbGroups> groups = dAmbGroups.getList("From AmbGroups t Where t.active = 1");
    List<AmbGroup> gs = new ArrayList<>();
    AmbPatients pat = dAmbPatients.get(session.getCurPat());
    for(AmbGroups group: groups) {
      AmbGroup g = new AmbGroup();
      List<AmbServices> list = new ArrayList<>();
      List<AmbServices> services = dAmbServices.byType(group.getId());
      for(AmbServices s: services)
        if(dAmbServiceUsers.getCount("From AmbServiceUsers Where service = " + s.getId()) > 0 && s.getStatusPrice(pat) > 0)
          list.add(s);
      if(!list.isEmpty()) {
        g.setServices(list);
        g.setGroup(group);
        gs.add(g);
      }
    }
    m.addAttribute("groups", gs);
    m.addAttribute("id", session.getCurPat());
    //endregion
    return "med/amb/services";
  }

  @RequestMapping("/prices.s")
  protected String prices(HttpServletRequest req, Model m){
    session = SessionUtil.getUser(req);
    session.setCurUrl("/amb/prices.s");
    //region Groups
    List<AmbGroups> groups = dAmbGroups.getList("From AmbGroups t Where t.active = 1");
    List<AmbGroup> gs = new ArrayList<>();
    for(AmbGroups group: groups) {
      AmbGroup g = new AmbGroup();
      List<AmbServices> list = new ArrayList<>();
      List<AmbServices> services = dAmbServices.byType(group.getId());
      for(AmbServices s: services)
        if(dAmbServiceUsers.getCount("From AmbServiceUsers Where service = " + s.getId()) > 0)
          list.add(s);
      if(!list.isEmpty()) {
        g.setServices(list);
        g.setGroup(group);
        gs.add(g);
      }
    }
    m.addAttribute("groups", gs);
    //endregion
    return "med/amb/prices";
  }

  @RequestMapping(value = "/services.s", method = RequestMethod.POST)
  @ResponseBody
  protected String services(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      AmbPatients pat = dAmbPatients.get(session.getCurPat());
      String[] ids = req.getParameterValues("ids");
      for(String id: ids) {
        AmbPatientServices ser = new AmbPatientServices();
        AmbServices s = dAmbServices.get(Integer.parseInt(id));
        ser.setCrBy(session.getUserId());
        ser.setCrOn(new Date());
        ser.setPatient(session.getCurPat());
        ser.setService(s);
        ser.setSaleProc(0D);
        if(s.getSaleStart() != null && s.getSaleEnd() != null && s.getSaleProc() != null && s.getSaleProc() > 0 && s.getSaleEnd().after(new Date()) && s.getSaleStart().before(new Date())) {
          ser.setPrice(s.getStatusPrice(pat) - s.getStatusPrice(pat) * s.getSaleProc() / 100);
          ser.setSaleProc(s.getSaleProc());
        } else {
          ser.setPrice(s.getStatusPrice(pat));
        }
        if(pat.getEmp() != null) {
          Double proc = Util.nvl(ser.getService().getGroup().getEmpProc(), 0) > 0 ? ser.getService().getGroup().getEmpProc() : 0D;
          ser.setPrice(ser.getService().getPrice() * proc / 100);
          ser.setState("PAID");
        } else {
          if(ser.getPrice() == null)
            ser.setPrice(s.getStatusPrice(pat));
          ser.setState("ENT");
        }
        ser.setNdsProc(beanSession.getNds());
        ser.setNds(ser.getPrice() * (ser.getNdsProc() == 0 ? 100 : ser.getNdsProc()) / 100);
        ser.setResult(0);
        ser.setAmb_repeat("N");
        ser.setWorker(dAmbServiceUsers.getFirstUser(Integer.parseInt(id)));
        dAmbPatientServices.save(ser);
      }
      if(pat.getEmp() != null) {
        if(pat.getState().equals("PRN")) {
          pat.setState("WORK");
          dAmbPatients.save(pat);
        }
      }
      if("DONE".equals(pat.getState())) {
        pat.setState("WORK");
        dAmbPatients.save(pat);
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/delSer.s", method = RequestMethod.POST)
  @ResponseBody
  protected String delSer(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      if(Util.isNull(req, "msg")) {
        AmbPatientServices ser = dAmbPatientServices.get(Util.getInt(req, "id"));
        if(ser.getPack() != null && ser.getPack() > 0) {
          if(dAmbPatientServices.getCount("From AmbPatientServices Where result > 0 And patient = " + ser.getPatient() + " And pack = " + ser.getPack()) > 0) {
            return Util.err(json, "Нельзя удалить услугу пакета. Есть заполненные услуги из пакета");
          }
          dAmbPatientServices.delSql("From AmbPatientServices Where ifnull(result, 0) = 0 And patient = " + ser.getPatient() + " And pack = " + ser.getPack());
        } else {
          dAmbPatientServices.delete(ser.getId());
        }
        AmbPatients pat = dAmbPatients.get(ser.getPatient());
        if(pat.getEmp() != null) {
          if(dAmbPatientServices.getCount("From AmbPatientServices Where patient = " + ser.getPatient()) == 0 && pat.getState().equals("WORK")) {
            pat.setState("PRN");
            dAmbPatients.save(pat);
          }
        }
        // По пациенту имеется услуги
        if (dAmbPatientServices.getCount("From AmbPatientServices Where patient = " + ser.getPatient()) > 0) {
          // Если есть не выполненные услуги то проводим DONE
          if (dAmbPatientServices.getCount("From AmbPatientServices Where state != 'DONE' And patient = " + ser.getPatient()) == 0) {
            pat.setState("DONE");
            dAmbPatients.save(pat);
          }
        }
      } else {
        AmbPatientServices ser = dAmbPatientServices.get(Util.getInt(req, "id"));
        ser.setState("DEL");
        ser.setMsg(Util.get(req, "msg"));
        dAmbPatientServices.save(ser);
        // По пациенту имеется услуги
        if (dAmbPatientServices.getCount("From AmbPatientServices Where patient = " + ser.getPatient()) > 0) {
          if (dAmbPatientServices.getCount("From AmbPatientServices Where state != 'DONE' And state != 'DEL' And patient = " + ser.getPatient()) == 0) {
            AmbPatients pat = dAmbPatients.get(ser.getPatient());
            pat.setState("DONE");
            dAmbPatients.save(pat);
          }
        }
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/confirm.s", method = RequestMethod.POST)
  @ResponseBody
  protected String confirm(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      AmbPatients patient = dAmbPatients.get(session.getCurPat());
      if("PRN".equals(patient.getState())) patient.setState("CASH");
      if("DONE".equals(patient.getState())) patient.setState("ARCH");
      dAmbPatients.save(patient);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }
  //endregion

  //region Амбулаторные услуги
  @RequestMapping("/patientServices.s")
  protected String patientServices(HttpServletRequest req, Model m){
    session = SessionUtil.getUser(req);
    AmbPatients pat = dAmbPatients.get(Util.getInt(req, "id"));
    m.addAttribute("patient", pat);
    m.addAttribute("curUser", session.getUserId());
    m.addAttribute("services", dAmbPatientServices.getList("From AmbPatientServices Where patient = " + pat.getId() + " And state in ('PAID', 'DONE')"));
    //
    return "med/amb/patientServices";
  }

  @RequestMapping("/work.s")
  protected String patientService(HttpServletRequest req, Model m){
    m.addAttribute("id", Util.getInt(req, "id"));
    return "med/amb/workFrame";
  }

  @RequestMapping("/doWork.s")
  protected String doWork(HttpServletRequest req, Model m){
    session = SessionUtil.getUser(req);
    AmbPatientServices service = dAmbPatientServices.get(Util.getInt(req, "id"));
    session.setCurUrl("/amb/work.s?id=" + service.getId());
    AmbPatients pat = dAmbPatients.get(service.getPatient());
    m.addAttribute("patient", pat);
    if(pat.getCounteryId() != null)
      m.addAttribute("country", dCountry.get(pat.getCounteryId()).getName());
    if(pat.getRegionId() != null)
      m.addAttribute("region", dRegion.get(pat.getRegionId()).getName());
    m.addAttribute("service", service);
    if(service.getResult() > 0)
      m.addAttribute("result", dAmbResults.get(service.getResult()));
    //
    if(service.getResult() == 0)
      if(dTemplate.getCount("From Templates where userId = " + session.getUserId() + " And field='" + service.getService().getId() + "_c1'") == 1) {
        AmbResults results = new AmbResults();
        results.setC1(dTemplate.getObj("From Templates where userId = " + session.getUserId() + " And field='" + service.getService().getId() + "_c1'").getTemplate());
        m.addAttribute("result", results);
      }
    session.setCurPat(service.getPatient());
    m.addAttribute("curUser", session.getUserId());
    if(service.getService().getForm_id() != null && service.getService().getForm_id() > 0) {
      m.addAttribute("data", sAmb.getFormJson(service.getResult()));
      m.addAttribute("fields", sForm.createFields(service.getService().getForm_id(), service.getService().getId()));
      Forms form = dForm.get(service.getService().getForm_id());
      return "med/amb/forms/" + (form.getJsp() != null  ? service.getService().getForm_id() : "standart");
    } else {
      sAmb.setFields(m, service.getService().getId());
      return "med/amb/work";
    }
  }

  @RequestMapping(value = "/work.s", method = RequestMethod.POST)
  @ResponseBody
  protected String workSave(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      AmbPatientServices service = dAmbPatientServices.get(Util.getInt(req, "id"));
      AmbResults result = service.getResult() > 0 ? dAmbResults.get(service.getResult()) : new AmbResults();
      if(service.getService().getForm_id() != null && service.getService().getForm_id() > 0) {
        result.setC1(Util.get(req, "c1"));
        result.setC2(Util.get(req, "c2"));
        result.setC3(Util.get(req, "c3"));
        result.setC4(Util.get(req, "c4"));
        result.setC5(Util.get(req, "c5"));
        result.setC6(Util.get(req, "c6"));
        result.setC7(Util.get(req, "c7"));
        result.setC8(Util.get(req, "c8"));
        result.setC9(Util.get(req, "c9"));
        result.setC10(Util.get(req, "c10"));
        result.setC11(Util.get(req, "c11"));
        result.setC12(Util.get(req, "c12"));
        result.setC13(Util.get(req, "c13"));
        result.setC14(Util.get(req, "c14"));
        result.setC15(Util.get(req, "c15"));
        result.setC16(Util.get(req, "c16"));
        result.setC17(Util.get(req, "c17"));
        result.setC18(Util.get(req, "c18"));
        result.setC19(Util.get(req, "c19"));
        result.setC20(Util.get(req, "c20"));
        result.setC21(Util.get(req, "c21"));
        result.setC22(Util.get(req, "c22"));
        result.setC23(Util.get(req, "c23"));
        result.setC24(Util.get(req, "c24"));
        result.setC25(Util.get(req, "c25"));
        result.setC26(Util.get(req, "c26"));
        result.setC27(Util.get(req, "c27"));
        result.setC28(Util.get(req, "c28"));
        result.setC29(Util.get(req, "c29"));
        result.setC30(Util.get(req, "c30"));
        result.setC31(Util.get(req, "c31"));
        result.setC32(Util.get(req, "c32"));
        result.setC33(Util.get(req, "c33"));
        result.setC34(Util.get(req, "c34"));
        result.setC35(Util.get(req, "c35"));
        result.setC36(Util.get(req, "c36"));
        result.setC37(Util.get(req, "c37"));
        result.setC38(Util.get(req, "c38"));
        result.setC39(Util.get(req, "c39"));
        result.setC40(Util.get(req, "c40"));
        result.setC41(Util.get(req, "c41"));
        result.setC42(Util.get(req, "c42"));
        result.setC43(Util.get(req, "c43"));
        result.setC44(Util.get(req, "c44"));
        result.setC45(Util.get(req, "c45"));
        result.setC46(Util.get(req, "c46"));
        result.setC47(Util.get(req, "c47"));
        result.setC48(Util.get(req, "c48"));
        result.setC49(Util.get(req, "c49"));
        result.setC50(Util.get(req, "c50"));
        result.setC51(Util.get(req, "c51"));
        result.setC52(Util.get(req, "c52"));
        result.setC53(Util.get(req, "c53"));
        result.setC54(Util.get(req, "c54"));
        result.setC55(Util.get(req, "c55"));
        result.setC56(Util.get(req, "c56"));
        result.setC57(Util.get(req, "c57"));
        result.setC58(Util.get(req, "c58"));
        result.setC59(Util.get(req, "c59"));
        result.setC60(Util.get(req, "c60"));
      } else {
        result.setC1(Util.get(req, "f1"));
        result.setC2(Util.get(req, "f2"));
        result.setC3(Util.get(req, "f3"));
        result.setC4(Util.get(req, "f4"));
        result.setC5(Util.get(req, "f5"));
        result.setC6(Util.get(req, "f6"));
        result.setC7(Util.get(req, "f7"));
        result.setC8(Util.get(req, "f8"));
        result.setC9(Util.get(req, "f9"));
        result.setC10(Util.get(req, "f10"));
      }
      result.setService(service.getId());
      result.setPatient(service.getPatient());
      dAmbResults.saveAndReturn(result);
      service.setResult(result.getId());
      service.setDiagnoz(Util.get(req, "diagnoz"));
      dAmbPatientServices.save(service);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/confirmService.s", method = RequestMethod.POST)
  @ResponseBody
  protected String confirmService(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      AmbPatientServices service = dAmbPatientServices.get(Util.getInt(req, "id"));
      service.setState("DONE");
      service.setConfDate(new Date());
      dAmbPatientServices.save(service);
      if(dAmbPatientServices.getCount("From AmbPatientServices Where state != 'DONE' And patient = " + service.getPatient()) == 0) {
        AmbPatients pat = dAmbPatients.get(service.getPatient());
        pat.setState("DONE");
        dAmbPatients.save(pat);
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("/print.s")
  protected String print(HttpServletRequest req, Model m) {
    AmbPatients pat = dAmbPatients.get(session.getCurPat());
    m.addAttribute("ids", req.getParameter("ids"));
    m.addAttribute("patFio", pat.getSurname() + " " + pat.getName() + " " + pat.getMiddlename());
    SessionUtil.addSession(req, "fontSize", Req.get(req, "font", "14"));
    m.addAttribute("isFizio", !Req.isNull(req, "fizio"));
    m.addAttribute("check", Util.isNotNull(req, "check"));
    m.addAttribute("check_id", Util.get(req, "check"));
    //
    return "med/amb/print";
  }

  @RequestMapping("/printPage.s")
  protected String printPage(HttpServletRequest req, Model m) {
    session = SessionUtil.getUser(req);
    List<AmbService> list = new ArrayList<>();
    String[] ids = Util.get(req, "ids").split("_");
    for(String id: ids) {
      AmbService ser = new AmbService();
      AmbPatientServices service = dAmbPatientServices.get(Integer.parseInt(id));
      ser.setId(service.getId());
      ser.setService(service.getService());
      ser.setWorker(service.getWorker());
      ser.setResult(dAmbResults.get(service.getResult()));
      list.add(ser);
    }
    m.addAttribute("patient", dAmbPatients.get(session.getCurPat()));
    m.addAttribute("services", list);
    //
    return "med/amb/print/print";
  }

  @RequestMapping("/printForm.s")
  protected String printForm(HttpServletRequest req, Model model) {
    AmbPatientServices service = dAmbPatientServices.get(Util.getInt(req, "id"));
    model.addAttribute("fields", sAmb.getResultFields(service));
    model.addAttribute("service", service);
    Forms form = dForm.get(service.getService().getForm_id());
    model.addAttribute("form", form);
    if(service.getResult() != null && service.getResult() > 0)
      model.addAttribute("result", dAmbResults.get(service.getResult()));
    //
    return "med/amb/qrcode/" + form.getJsp();
  }

  @RequestMapping("/word.s")
  protected String printPage(HttpServletResponse res, HttpServletRequest req, Model m){
    session = SessionUtil.getUser(req);
    List<AmbService> list = new ArrayList<>();
    String[] ids = Util.get(req, "ids").split("_");
    for(String id: ids) {
      AmbService ser = new AmbService();
      AmbPatientServices service = dAmbPatientServices.get(Integer.parseInt(id));
      ser.setService(service.getService());
      ser.setWorker(service.getWorker());
      ser.setResult(dAmbResults.get(service.getResult()));
      if(service.getService().getForm_id() != null && service.getService().getForm_id() > 0) {
        Forms form = dForm.get(service.getService().getForm_id());
        ser.setState(form.getJsp());
        ser.setFields(sAmb.getResultFields(service));
      } else {
        ser.setState("");
        List<AmbServiceFields> fields = dAmbServiceFields.byService(service.getService().getId());
        for(int i=0;i<fields.size();i++) {
          if(i == 0) ser.setC1_name(fields.get(i).getName());
          if(i == 1) ser.setC2_name(fields.get(i).getName());
          if(i == 2) ser.setC3_name(fields.get(i).getName());
          if(i == 3) ser.setC4_name(fields.get(i).getName());
          if(i == 4) ser.setC5_name(fields.get(i).getName());
          if(i == 5) ser.setC6_name(fields.get(i).getName());
          if(i == 6) ser.setC7_name(fields.get(i).getName());
          if(i == 7) ser.setC8_name(fields.get(i).getName());
          if(i == 8) ser.setC9_name(fields.get(i).getName());
          if(i == 9) ser.setC10_name(fields.get(i).getName());
        }
      }
      list.add(ser);
    }
    m.addAttribute("patient", dAmbPatients.get(session.getCurPat()));
    m.addAttribute("services", list);
    //
    return "med/amb/print/word";
  }

  @RequestMapping("/view.s")
  protected String viewPage(HttpServletRequest req, Model m){
    session = SessionUtil.getUser(req);
    AmbService ser = new AmbService();
    AmbPatientServices service = dAmbPatientServices.get(Util.getInt(req, "id"));
    ser.setService(service.getService());
    ser.setWorker(service.getWorker());
    ser.setResult(dAmbResults.get(service.getResult()));
    if(service.getService().getForm_id() != null && service.getService().getForm_id() > 0) {
      ser.setFields(sAmb.getResultFields(service));
      m.addAttribute("ser", ser);
      Forms form = dForm.get(service.getService().getForm_id());
      return "med/amb/print/" + (form.getJsp() != null ? service.getService().getForm_id() : "standart");
    } else {
      List<AmbServiceFields> fields = dAmbServiceFields.byService(service.getService().getId());
      for(int i=0;i<fields.size();i++) {
        if(i == 0) ser.setC1_name(fields.get(i).getName());
        if(i == 1) ser.setC2_name(fields.get(i).getName());
        if(i == 2) ser.setC3_name(fields.get(i).getName());
        if(i == 3) ser.setC4_name(fields.get(i).getName());
        if(i == 4) ser.setC5_name(fields.get(i).getName());
        if(i == 5) ser.setC6_name(fields.get(i).getName());
        if(i == 6) ser.setC7_name(fields.get(i).getName());
        if(i == 7) ser.setC8_name(fields.get(i).getName());
        if(i == 8) ser.setC9_name(fields.get(i).getName());
        if(i == 9) ser.setC10_name(fields.get(i).getName());
      }
      m.addAttribute("ser", ser);
      return "med/amb/print/old";
    }
  }

  @RequestMapping(value = "/fizio.s", method = RequestMethod.POST)
  @ResponseBody
  protected String fizio(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      AmbPatients patient = dAmbPatients.get(session.getCurPat());
      patient.setFizio("Y");
      patient.setFizioSetUser(session.getUserId());
      dAmbPatients.save(patient);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("/fizio/print.s")
  protected String fizioPrint(HttpServletRequest req, Model m){
    session = SessionUtil.getUser(req);
    //
    AmbPatients pat = dAmbPatients.get(session.getCurPat());
    m.addAttribute("pat", pat);
    m.addAttribute("fizios", dAmbPatientServices.byUser(session.getCurPat(), session.getUserId()));
    m.addAttribute("dates", Util.getDateList(pat.getRegDate(), 10));
    //
    return "med/amb/fizioPrint";
  }

  @RequestMapping(value = "/reiterativeConsul.s", method = RequestMethod.POST)
  @ResponseBody
  protected String reiterativeConsul(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      AmbPatientServices ser = dAmbPatientServices.get(Req.getInt(req, "id"));
      ser.setAmb_repeat("D");
      dAmbPatientServices.save(ser);
      //
      ser.setId(null);
      ser.setState("ENT");
      ser.setAmb_repeat("Y");
      ser.setCrOn(new Date());
      ser.setPrice(ser.getPrice() / 2);
      ser.setCrBy(session.getUserId());
      dAmbPatientServices.save(ser);
      //
      AmbPatients pat = dAmbPatients.get(ser.getPatient());
      pat.setState("CASH");
      dAmbPatients.save(pat);
      //
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }
  //endregion

  //region DRUGS
  @RequestMapping("/drug.s")
  protected String drug(HttpServletRequest req, Model model){
    session = SessionUtil.getUser(req);
    //
    AmbPatients pat = dAmbPatients.get(session.getCurPat());
    model.addAttribute("pat", pat);
    model.addAttribute("drugs", dDrug.getList("From Drugs t Where t.id in (Select c.drug.id From DrugActDrugs c Where c.counter - rasxod > 0) Or t.id In (Select f.drug.id From HNDrugs f Where f.drugCount - f.rasxod > 0) Order By name"));
    //
    PatientDrug drug = new PatientDrug();
    if(Util.isNotNull(req, "id"))
      model.addAttribute("drug", sAmb.getDrug(Util.getInt(req, "id")));
    else {
      drug.setDateBegin(pat.getRegDate());
      //
      Calendar cal = Calendar.getInstance();
      cal.setTime(pat.getRegDate());
      cal.add(Calendar.DATE, 10);
      List<PatientDrugDate> dates = new ArrayList<>();
      for (int i = 0; i <= 10; i++) {
        PatientDrugDate date = new PatientDrugDate();
        Calendar cl = Calendar.getInstance();
        cl.setTime(pat.getRegDate());
        cl.add(Calendar.DATE, i);
        date.setDate(cl.getTime());
        date.setState("ENT");
        date.setId(0);
        dates.add(date);
      }
      drug.setDateEnd(cal.getTime());
      drug.setDates(dates);
      model.addAttribute("drug", drug);
    }
    Date minDate = dAmbDrugDate.minDate(session.getCurPat());
    Date maxDate = dAmbDrugDate.maxDate(session.getCurPat());
    if(minDate != null) {
      long diffInMillies = Math.abs(maxDate.getTime() - minDate.getTime());
      long diff = TimeUnit.DAYS.convert(diffInMillies, TimeUnit.MILLISECONDS) + 2;
      model.addAttribute("dates", Util.getDateList(minDate, (int) (diff)));
    }
    model.addAttribute("rows", sAmb.getDrugs(session.getCurPat()));
    model.addAttribute("drugTypes", dDict.getList("From Dicts Where typeCode = 'drugTypes'"));
    model.addAttribute("injectionTypes", dDict.getList("From Dicts Where typeCode = 'injectionTypes'"));
    //
    return "med/amb/drug/index";
  }

  @RequestMapping("/drug/view.s")
  protected String drugView(HttpServletRequest req, Model model){
    session = SessionUtil.getUser(req);
    //
    Date minDate = dAmbDrugDate.minDate(session.getCurPat());
    Date maxDate = dAmbDrugDate.maxDate(session.getCurPat());
    if(minDate != null) {
      long diffInMillies = Math.abs(maxDate.getTime() - minDate.getTime());
      long diff = TimeUnit.DAYS.convert(diffInMillies, TimeUnit.MILLISECONDS) + 2;
      model.addAttribute("dates", Util.getDateList(minDate, (int) (diff)));
    }
    model.addAttribute("rows", sAmb.getDrugs(session.getCurPat()));
    return "med/amb/drug/view";
  }

  @RequestMapping(value = "/patient/get.s", method = RequestMethod.POST)
  @ResponseBody
  protected String get_amb_patient(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      AmbPatients p = dAmbPatients.get(Util.getInt(req, "id"));
      json.put("id", p.getId());
      json.put("surname", p.getSurname());
      json.put("name", p.getName());
      json.put("middlename", p.getMiddlename());
      json.put("birthdate", Util.dateToString(p.getBirthday()));
      json.put("sex_id", p.getSex().getId());
      json.put("tel", p.getTel());
      json.put("country_id", p.getCounteryId());
      json.put("region_id", p.getRegionId());
      json.put("address", p.getAddress());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/drug/save.s", method = RequestMethod.POST) @ResponseBody
  protected String patientDrugSave() {
    /*Session session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    Integer id = Util.getNullInt(req, "id");
    List<AmbDrugRows> rows = new ArrayList<AmbDrugRows>();
    try {
      //
      String[] row_ids = req.getParameterValues("row_id");
      String[] date_ids = req.getParameterValues("date_id");
      String[] sources = req.getParameterValues("source_code");
      String[] drugs = req.getParameterValues("drug_drug");
      String[] names = req.getParameterValues("drug_name");
      String[] expenses = req.getParameterValues("out_count");
      String[] drug_measures = req.getParameterValues("drug_measure");
      String[] dates = req.getParameterValues("dates");
      String[] dateStates = req.getParameterValues("date_state");
      String[] date_states = req.getParameterValues("dt_state");
      //
      for(int i=0;i<sources.length;i++) {
        AmbDrugRows row = new AmbDrugRows();
        if(!row_ids[i].equals("0") && !row_ids[i].equals("")) row.setId(Integer.parseInt(row_ids[i]));
        row.setSource(sources[i]);
        if(sources[i].equals("own")) {
          row.setName(names[i]);
          if(!names[i].equals("")) {
            rows.add(row);
          }
        } else {
          if(row_ids[i].equals("0") || row_ids[i].equals("")) {
            try {
              row.setMeasure(dDrugMeasure.get(Integer.parseInt(drug_measures[i])));
            } catch (Exception e) {
              json.put("msg", "??? ?????? ?? ??????? ?????????. ?????????? ??????? ?????????! ?? ??????????? ?? ?????????? ????????????? ????");
              json.put("success", false);
              return json.toString();
            }
            row.setDrug(dDrug.get(Integer.parseInt(drugs[i])));
          }
          row.setRasxod(Double.parseDouble(expenses[i]));
          if(!row_ids[i].equals("0") || (row.getDrug() != null && row.getRasxod() > 0))
            rows.add(row);
        }
      }
      //
      List<String> states = new ArrayList<>();
      if(dateStates != null && dateStates.length > 0) Collections.addAll(states, dateStates);
      //
      if(id == null || id == 0) {
        if(dateStates == null || dateStates.length == 0) {
          json.put("msg", "???? ?????????? ?? ???????");
          json.put("success", false);
          return json.toString();
        }
        if(rows.size() == 0) {
          json.put("msg", "?????? ?????????? ?? ????? ???? ??????");
          json.put("success", false);
          return json.toString();
        }
        AmbDrugs drug = new AmbDrugs();
        drug.setDrugType(dDict.get(Util.getInt(req, "drug_type")));
        if(Util.getInt(req, "drug_type") == 16)
          drug.setInjectionType(dDict.get(Util.getInt(req, "injection_type")));
        drug.setPatient(dAmbPatients.get(session.getCurPat()));
        drug.setDateBegin(Util.getDate(req, "dateBegin"));
        drug.setDateEnd(Util.getDate(req, "dateEnd"));
        //
        drug.setNote(Util.get(req, "note"));
        //
        drug.setCrBy(session.getUserId());
        drug.setCrOn(new Date());
        //
        dAmbDrug.saveAndReturn(drug);
        for (String date : dates) {
          AmbDrugDates drugDate = new AmbDrugDates();
          drugDate.setAmbDrug(drug);
          drugDate.setDate(Util.stringToDate(date));
          drugDate.setChecked(states.contains(date));
          drugDate.setState("ENT");
          dAmbDrugDate.saveAndReturn(drugDate);
        }
        for(AmbDrugRows row: rows) {
          row.setAmbDrug(drug);
          dAmbDrugRow.save(row);
        }
      } else {
        AmbDrugs drug = dAmbDrug.get(Util.getInt(req, "id"));
        drug.setDrugType(dDict.get(Util.getInt(req, "drug_type")));
        if(Util.getInt(req, "drug_type") == 16)
          drug.setInjectionType(dDict.get(Util.getInt(req, "injection_type")));
        else
          drug.setInjectionType(null);
        drug.setDateBegin(Util.getDate(req, "dateBegin"));
        drug.setDateEnd(Util.getDate(req, "dateEnd"));
        //
        drug.setNote(Util.get(req, "note"));
        //
        if(rows.size() == 0) {
          json.put("msg", "?????? ?????????? ?? ????? ???? ??????");
          json.put("success", false);
          return json.toString();
        }
        List<AmbDrugDates> dbDates = dAmbDrugDate.getList("From AmbDrugDates Where ambDrug.id = " + drug.getId());
        for(AmbDrugDates dd: dbDates) dAmbDrugDate.delete(dd.getId());
        for (int i=0;i<date_ids.length;i++) {
          AmbDrugDates drugDate = new AmbDrugDates();
          drugDate.setAmbDrug(drug);
          drugDate.setDate(Util.stringToDate(dates[i]));
          if(date_ids[i].equals("0")) {
            drugDate.setChecked(states.contains(dates[i]));
            drugDate.setState("ENT");
          } else {
            drugDate.setId(Integer.parseInt(date_ids[i]));
            drugDate.setState(date_states[i]);
            if(date_states[i].equals("ENT"))
              drugDate.setChecked(states.contains(dates[i]));
          }
          dAmbDrugDate.save(drugDate);
        }
        for(AmbDrugRows row: rows) {
          if(row.getId() != null) {
            AmbDrugRows rw = dAmbDrugRow.get(row.getId());
            rw.setRasxod(row.getRasxod());
          } else {
            row.setAmbDrug(drug);
            dAmbDrugRow.save(row);
          }
        }
        dAmbDrug.save(drug);
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();*/
    return "";
  }

  @RequestMapping(value = "/drugs/setPeriod.s")
  @ResponseBody
  protected String patientDrugPeriod() {
    /*Session session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      AmbPatients pat = dAmbPatients.get(session.getCurPat());
      Date begin = Util.getDate(req, "begin");
      Date end = Util.getDate(req, "end");
      if(begin != null) {
        Calendar cal = Calendar.getInstance(); // locale-specific
        cal.setTime(pat.getRegDate());
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        if(begin.before(cal.getTime())) throw new Exception("???? ?????? ??????? ?? ????? ???? ?????? ???? ??????????? ????????");
      }
      if(end == null) {
        json.put("success", true);
        json.put("dates", new JSONArray());
        return json.toString();
      }
      if(begin.after(end)) throw new Exception("????? ??????? ?? ????? ???? ?????? ??????");
      JSONArray dates = new JSONArray();
      int i = 0;
      while(true) {
        JSONObject date = new JSONObject();
        Calendar cl = Calendar.getInstance();
        cl.setTime(begin);
        cl.add(Calendar.DATE, i++);
        date.put("date", Util.dateToString(cl.getTime()));
        date.put("state", false);
        dates.put(date);
        if(cl.getTime().equals(end)) break;
      }
      json.put("success", true);
      json.put("dates", dates);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();*/
    return "";
  }

  @RequestMapping(value = "/drug/delete.s", method = RequestMethod.POST)
  @ResponseBody
  protected String removePatientDrug(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    Integer id = Util.getNullInt(req, "id");
    try {
      List<AmbDrugRows> rows = dAmbDrugRow.getList("From AmbDrugRows Where ambDrug.id = " + id);
      List<AmbDrugDates> dates = dAmbDrugDate.getList("From AmbDrugDates Where ambDrug.id = " + id);
      for(AmbDrugRows row: rows) dAmbDrugRow.delete(row.getId());
      for(AmbDrugDates date: dates) dAmbDrugDate.delete(date.getId());
      dAmbDrug.delete(id);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }
  //endregion

  @RequestMapping("qrcode.s")
  protected String botPdf(HttpServletRequest req, Model m) {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    ResultSet rc = null;
    //
    List<AmbPatients> patients = dAmbPatients.getList("From AmbPatients Where qrcode = '" + Util.get(req, "id") + "'");
    if(!patients.isEmpty()) {
      int patId = patients.get(0).getId();
      m.addAttribute("patient", patients.get(0));
      List<AmbPatientServices> services = dAmbPatientServices.getList("From AmbPatientServices Where patient = " + patId);
      try {
        conn = DB.getConnection();
        ps = conn.prepareStatement(
          "Select t.worker_id, u.fio, u.profil " +
            "  From Amb_Patient_Services t, Users u, Amb_Services s " +
            "  Where u.id = t.worker_id " +
            "    And s.id = t.service_id " +
            "    And t.patient =  " + patId +
            "    And s.form_id in (777, 888) " +
            "  Group By t.worker_id, u.fio ");
        rs = ps.executeQuery();
        List<Doctor> objs777 = new ArrayList<>();
        while(rs.next()) {
          Doctor obj = new Doctor();
          obj.setUser(rs.getInt("worker_id"));
          obj.setFio(rs.getString("fio"));
          obj.setProfil(rs.getString("profil"));
          //
          ps = conn.prepareStatement("Select t.id From Amb_Patient_Services t, Amb_Services s Where t.state = 'DONE' And t.service_id = s.id And s.form_id in (777, 888) And t.patient = " + patId + " And worker_id = " + obj.getUser());
          rc = ps.executeQuery();
          List<Result> o = new ArrayList<>();
          while(rc.next()) {
            Result res = sRkdo.getAmbResult(rc.getInt("id"));
            if(res != null) o.add(res);
          }
          obj.setResults(o);
          if(!o.isEmpty())
            objs777.add(obj);
          DB.done(rc);
          DB.done(ps);
        }
        ps = conn.prepareStatement(
          "Select t.worker_id, u.fio, u.profil " +
            "  From Amb_Patient_Services t, Users u, Amb_Services s " +
            "  Where u.id = t.worker_id " +
            "    And s.id = t.service_id " +
            "    And t.patient = " + patId +
            "    And (s.form_id not in (777, 888) Or s.form_id is null) " +
            "  Group By t.worker_id, u.fio ");
        rs = ps.executeQuery();
        List<Doctor> objs = new ArrayList<>();
        while(rs.next()) {
          Doctor obj = new Doctor();
          obj.setUser(rs.getInt("worker_id"));
          obj.setFio(rs.getString("fio"));
          obj.setProfil(rs.getString("profil"));
          //
          ps = conn.prepareStatement("Select t.id From Amb_Patient_Services t, Amb_Services s Where t.state = 'DONE' And t.service_id = s.id And (s.form_id not in (777, 888) Or s.form_id is null) And t.patient = " + patId + " And worker_id = " + obj.getUser());
          rc = ps.executeQuery();
          List<Result> o = new ArrayList<>();
          while(rc.next()) {
            Result res = sRkdo.getAmbResult(rc.getInt("id"));
            if(res != null) o.add(res);
          }
          obj.setResults(o);
          if(!o.isEmpty())
            objs.add(obj);
          DB.done(rc);
          DB.done(ps);
        }
        m.addAttribute("objs777", objs777);
        m.addAttribute("objs", objs);
        m.addAttribute("services", services);
        m.addAttribute("clinic_address", beanSession.getParam("CLINIC_ADDRESS"));
        m.addAttribute("path", Util.get(req, "path"));
        return "med/amb/qrcode/pages";
      } catch (Exception e) {
        e.printStackTrace();
      } finally {
        DB.done(rs);
        DB.done(rc);
        DB.done(ps);
        DB.done(conn);
      }
    }
    //
    return "med/amb/qrcode/page_404";
  }

  @RequestMapping("/packs.s")
  protected String packs(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    //
    List<Obj> rows = new ArrayList<>();
    AmbPatients pat = dAmbPatients.get(session.getCurPat());
    double ndsProc = Double.parseDouble(session.getParam("NDS_PROC"));
    for(SalePacks pack: dSalePack.list("From SalePacks Where ambStat != 'STAT' And state = 'A'")) {
      Obj row = new Obj();
      row.setPrice(0D);
      List<ObjList> list = new ArrayList<>();
      // Pack
      row.setId(pack.getId());
      row.setName(pack.getName());
      //
      double realSum = 0;
      for(SalePackRows rw: dSalePackRow.list("From SalePackRows Where doc.id = " + pack.getId())) {
        ObjList l = new ObjList();
        AmbServices ser = dAmbServices.get(rw.getService());
        l.setC1(ser.getId().toString());
        l.setC2(ser.getName());
        l.setPrice(ser.getStatusPrice(pat) * (100 - rw.getProc()) / 100);
        row.setPrice(row.getPrice() + l.getPrice());
        row.setClaimCount(row.getPrice() * (100 + ndsProc) / 100);
        realSum += ser.getPrice();
        if(dAmbServices.getCount("From AmbServices t Where t.id = " + rw.getService() + " And Exists (From AmbServiceUsers c Where c.service = t.id) And t.price > 0 And t.state = 'A'") == 0) {
          list = new ArrayList<>();
          break;
        }
        list.add(l);
      }
      row.setDrugCount(pack.getNdsProc());
      row.setOutCount(realSum);
      if(!list.isEmpty()) {
        row.setList(list);
        rows.add(row);
      }
    }
    model.addAttribute("packs", rows);
    model.addAttribute("id", session.getCurPat());
    return "med/amb/packs";
  }

  @RequestMapping(value = "/pack.s", method = RequestMethod.POST)
  @ResponseBody
  protected String savePack(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    Session session = SessionUtil.getUser(req);
    Connection conn = null;
    Double ndsProc = beanSession.getNds();
    try {
      conn = DB.getConnection();
      AmbPatients pat = dAmbPatients.get(session.getCurPat());
      SalePacks pack = dSalePack.get(Util.getInt(req, "id"));
      if(dAmbPatientServices.getCount("From AmbPatientServices Where pack = " + pack.getId() + " And patient = " + pat.getId()) == 0) {
        for(SalePackRows row: dSalePackRow.list("From SalePackRows Where doc.id = " + pack.getId())) {
          AmbPatientServices ser = new AmbPatientServices();
          AmbServices s = dAmbServices.get(row.getService());
          ser.setCrBy(session.getUserId());
          ser.setCrOn(new Date());
          ser.setPatient(session.getCurPat());
          ser.setService(s);
          ser.setPrice(row.getPrice());
          ser.setNdsProc(ndsProc);
          ser.setNds(ser.getPrice() * ndsProc / 100);
          ser.setPack(pack.getId());
          ser.setState(ser.getPrice() > 0 ? "ENT" : "PAID");
          ser.setNdsProc(beanSession.getNds());
          ser.setNds(ser.getPrice() * (ser.getNdsProc() == 0 ? 100 : ser.getNdsProc()) / 100);
          ser.setResult(0);
          ser.setAmb_repeat("N");
          ser.setWorker(dAmbServiceUsers.getFirstUser(row.getService()));
          dAmbPatientServices.save(ser);
        }
        if(!pat.getState().equals("PRN")) {
          Double summ = DB.getSum(conn, "Select Sum(t.price) From Amb_Patient_Services t Where t.patient = " + session.getCurPat() + " And t.state Not In ('PAID', 'DONE', 'DEL', 'REG_DEL', 'AUTO_DEL')");
          Double count = DB.getSum(conn, "Select Count(*) From Amb_Patient_Services t Where t.patient = " + session.getCurPat() + " And t.state Not In ('DONE', 'DEL', 'REG_DEL', 'AUTO_DEL')");
          if (summ > 0) {
            pat.setState("CASH");
          } else {
            if (count == 0) {
              pat.setState("DONE");
            } else {
              pat.setState("WORK");
            }
          }
        }
        dAmbPatients.save(pat);
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    } finally {
      DB.done(conn);
    }
    return json.toString();
  }

}
