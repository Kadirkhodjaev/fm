package ckb.controllers.med;

import ckb.dao.med.amb.*;
import ckb.dao.med.client.DClient;
import ckb.domains.admin.Clients;
import ckb.domains.admin.Users;
import ckb.domains.med.amb.*;
import ckb.models.AmbGroup;
import ckb.models.AmbService;
import ckb.models.Obj;
import ckb.services.admin.form.SForm;
import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.BeanSession;
import ckb.utils.BeanUsers;
import ckb.utils.DB;
import ckb.utils.Util;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

@Controller
@RequestMapping("/amb/")
public class CAmbBooking {

  @Autowired private DAmbBooking dAmbBooking;
  @Autowired private SForm sForm;
  @Autowired private DClient dClient;
  @Autowired private DAmbBookingService dAmbBookingService;
  @Autowired private DAmbService dAmbService;
  @Autowired private DAmbServiceUser dAmbServiceUser;
  @Autowired private DAmbPatient dAmbPatient;
  @Autowired private DAmbPatientService dAmbPatientService;
  @Autowired private BeanSession beanSession;
  @Autowired private BeanUsers beanUsers;

  @RequestMapping("bookings.s")
  protected String bookings(HttpServletRequest req, Model m) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/amb/bookings.s");
    //
    String startDate = session.getStartDate("amb_booking", "period_start", req);
    String endDate = session.getEndDate("amb_booking", "period_end", req);
    ///
    Connection conn = null;
    PreparedStatement ps =  null;
    ResultSet rs = null;
    try {
      conn = DB.getConnection();
      ps = conn.prepareStatement("Select date(Reg_Date) From Amb_Bookings Where date(crOn) Between ? And ? And date(reg_date) >= CURRENT_DATE() Group By date(Reg_Date) Order By date(Reg_Date)");
      ps.setString(1, Util.dateDB(startDate));
      ps.setString(2, Util.dateDB(endDate));
      rs = ps.executeQuery();
      List<Obj> objs = new ArrayList<>();
      HashMap<Integer, String> services = new HashMap<>();
      while (rs.next()) {
        Obj obj = new Obj();
        obj.setName(Util.dateToString(rs.getDate(1)));
        List<AmbBookings> rows = dAmbBooking.list("From AmbBookings Where date(regDate) = '" + Util.dateDB(rs.getDate(1)) + "' Order By regDate");
        for(AmbBookings row : rows){
          List<AmbBookingServices> r = dAmbBookingService.list("From AmbBookingServices Where booking.id = " + row.getId());
          if(!r.isEmpty()) services.put(row.getId(), r.get(0).getService().getName());
        }
        obj.setBookings(rows);
        objs.add(obj);
      }
      //
      m.addAttribute("rows", objs);
      m.addAttribute("services", services);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn, ps, rs);
    }
    //
    m.addAttribute("period_start", startDate);
    m.addAttribute("period_end", endDate);
    //
    return "med/amb/booking/index";
  }

  @RequestMapping("booking/lvs.s")
  protected String booking_lvs(HttpServletRequest req, Model m) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/amb/booking/lvs.s");
    ///
    HashMap<Integer, String> services = new HashMap<>();
    List<AmbBookings> rows = dAmbBooking.list("From AmbBookings t Where exists (Select 1 From AmbBookingServices c Where c.booking.id = t.id And c.worker.id = " +  session.getUserId() + ") And date(t.regDate) >= '" + Util.dateDB(Util.getCurDate()) + "' Order By t.regDate");
    for(AmbBookings row : rows){
      List<AmbBookingServices> r = dAmbBookingService.list("From AmbBookingServices Where booking.id = " + row.getId());
      if(!r.isEmpty()) services.put(row.getId(), r.get(0).getService().getName());
    }
    //
    m.addAttribute("rows", rows);
    m.addAttribute("services", services);
    //
    return "med/amb/booking/lvs";
  }

  @RequestMapping("booking.s")
  protected String booking(HttpServletRequest req, Model m){
    Session session = SessionUtil.getUser(req);
    int id = Util.getInt(req, "id");
    session.setCurUrl("/amb/booking.s?id=" + id);
    AmbBookings booking = id == 0 ? new AmbBookings() : dAmbBooking.get(id);
    List<AmbService> ss = new ArrayList<>();
    if(id == 0) {
      booking.setId(0);
    } else {
      double ndsProc = Double.parseDouble(session.getParam("NDS_PROC"));
      Double summ = 0D, nds = 0D;
      List<AmbBookingServices> services = dAmbBookingService.list("From AmbBookingServices Where booking.id = " + booking.getId());
      for(AmbBookingServices s: services) {
        AmbService d = new AmbService();
        d.setId(s.getId());
        d.setService(s.getService());
        d.setWorker(s.getWorker());
        d.setCrBy(s.getCrBy());
        List<Users> users = new ArrayList<>();
        if("ENT".equals(booking.getState())) {
          List<AmbServiceUsers> serviceUsers = dAmbServiceUser.getList("From AmbServiceUsers t Where t.service = " + s.getService().getId());
          for(AmbServiceUsers serviceUser: serviceUsers) users.add(beanUsers.get(serviceUser.getUser()));
        } else
          if(s.getWorker() != null)
            users.add(beanUsers.get(s.getWorker().getId()));
        d.setUsers(users);
        //
        String sum = new DecimalFormat("###,###,###,###,###,###.##").format(s.getService().getPrice());
        if(!sum.contains(",")) sum = sum + ",00";
        d.setPrice(sum);
        //
        sum = new DecimalFormat("###,###,###,###,###,###.##").format(s.getService().getPrice() * (100 + ndsProc) / 100);
        if (!sum.contains(",")) sum = sum + ",00";
        d.setNds(sum);
        //
        ss.add(d);
        summ += s.getService().getPrice();
        nds += (double) Math.round(s.getService().getPrice() * (100 + ndsProc)) / 100;
      }
      m.addAttribute("serviceTotal", summ);
      m.addAttribute("ndsTotal", nds);
    }
    m.addAttribute("services", ss);
    sForm.setSelectOptionModel(m, 1, "sex");
    m.addAttribute("countries", beanSession.getCounteries());
    m.addAttribute("regions", beanSession.getRegions());
    m.addAttribute("booking", booking);
    return "med/amb/booking/form";
  }

  @RequestMapping(value = "booking.s", method = RequestMethod.POST)
  @ResponseBody
  protected String save_booking(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    Session session = SessionUtil.getUser(req);
    try {
      int id = Util.getInt(req, "id");
      AmbBookings a = id == 0 ? new AmbBookings() : dAmbBooking.get(id);
      if(id == 0) {
        a.setClient(dClient.get(Util.getInt(req, "client_id")));
        a.setSurname(a.getClient().getSurname());
        a.setName(a.getClient().getName());
        a.setMiddlename(a.getClient().getMiddlename());
        a.setBirthday(a.getClient().getBirthdate());
        a.setAddress(a.getClient().getAddress());
        a.setTel(a.getClient().getTel());
        a.setSex(a.getClient().getSex());
        a.setCountry(a.getClient().getCountry());
        a.setRegion(a.getClient().getRegion());
        a.setPassportInfo(a.getClient().getPassport());
        a.setCrBy(session.getUserId());
        a.setCrOn(new Date());
        a.setState("ENT");
      }
      a.setText(Util.get(req, "text"));
      String regDate = Util.get(req, "reg_date");
      String regTime = Util.get(req, "reg_time");
      DateFormat format = new SimpleDateFormat("dd.MM.yyyy HH:mm");
      Date date = format.parse(regDate + " " + regTime);
      a.setRegDate(date);
      dAmbBooking.saveAndReturn(a);
      json.put("id", a.getId());
      return Util.success(json);
    } catch (Exception e) {
      return Util.err(json, e.getMessage());
    }
  }

  @RequestMapping(value = "booking/del.s", method = RequestMethod.POST)
  @ResponseBody
  protected String del_booking(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      int id = Util.getInt(req, "id");
      dAmbBookingService.delSql("From AmbBookingServices Where booking.id = " + id);
      dAmbBooking.delete(id);
      return Util.success(json);
    } catch (Exception e) {
      return Util.err(json, e.getMessage());
    }
  }

  @RequestMapping("/booking/services.s")
  protected String serviceList(HttpServletRequest req, Model m) {
    List<AmbGroups> groups = beanSession.getAmbGroups();
    List<AmbGroup> gs = new ArrayList<>();
    AmbBookings booking = dAmbBooking.get(Util.getInt(req, "id"));
    for(AmbGroups group: groups) {
      AmbGroup g = new AmbGroup();
      List<AmbServices> list = new ArrayList<>();
      List<AmbServices> services = dAmbService.byType(group.getId());
      for(AmbServices s: services)
        if(dAmbServiceUser.getCount("From AmbServiceUsers Where service = " + s.getId()) > 0 && s.getStatusPrice(booking) > 0)
          list.add(s);
      if(!list.isEmpty()) {
        g.setServices(list);
        g.setGroup(group);
        gs.add(g);
      }
    }
    m.addAttribute("groups", gs);
    m.addAttribute("id", booking.getId());
    return "med/amb/booking/services";
  }

  @RequestMapping(value = "/booking/services.s", method = RequestMethod.POST)
  @ResponseBody
  protected String services(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    Session session = SessionUtil.getUser(req);
    try {
      AmbBookings booking = dAmbBooking.get(Util.getInt(req, "id"));
      String[] ids = req.getParameterValues("ids");
      for(int i = 0; i < ids.length; i++) {
        AmbServices a = dAmbService.get(Integer.parseInt(ids[i]));
        AmbBookingServices s = new AmbBookingServices();
        s.setBooking(booking);
        s.setService(a);
        s.setCrBy(session.getUserId());
        s.setCrOn(new Date());
        s.setWorker(null);
        //
        dAmbBookingService.save(s);
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/booking/reg.s", method = RequestMethod.POST)
  @ResponseBody
  protected String service_reg(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    Session session = SessionUtil.getUser(req);
    try {
      AmbBookings booking = dAmbBooking.get(Util.getInt(req, "id"));
      List<AmbBookingServices> bss = dAmbBookingService.list("From AmbBookingServices Where booking.id = " + booking.getId());
      AmbPatients a = new AmbPatients();
      a.setClient(booking.getClient());
      Clients c = a.getClient();
      Util.checkClient(c);
      a.setSurname(c.getSurname());
      a.setBirthday(c.getBirthdate());
      a.setName(c.getName());
      a.setMiddlename(c.getMiddlename());
      a.setBirthyear(c.getBirthyear());
      a.setCounteryId(c.getCountry().getId());
      a.setRegionId(c.getRegion().getId());
      a.setPassportInfo(c.getDocSeria() + " " + c.getDocNum() + " " + c.getDocInfo());
      a.setSex(c.getSex());
      a.setAddress(c.getAddress());
      //
      a.setState("PRN");
      a.setRegDate(new Date());
      a.setCard(0D);
      a.setCash(0D);
      a.setCrOn(new Date());
      a.setCrBy(session.getUserId());
      dAmbPatient.saveAndReturn(a);
      //
      for (AmbBookingServices bs: bss) {
        AmbPatientServices ser = new AmbPatientServices();
        AmbServices s = bs.getService();
        ser.setCrBy(session.getUserId());
        ser.setCrOn(new Date());
        ser.setPatient(a.getId());
        ser.setService(s);
        ser.setSaleProc(0D);
        if(s.getSaleStart() != null && s.getSaleEnd() != null && s.getSaleProc() != null && s.getSaleProc() > 0 && s.getSaleEnd().after(new Date()) && s.getSaleStart().before(new Date())) {
          ser.setPrice(s.getStatusPrice(a) - s.getStatusPrice(a) * s.getSaleProc() / 100);
          ser.setSaleProc(s.getSaleProc());
        } else {
          ser.setPrice(s.getStatusPrice(a));
        }
        if(ser.getPrice() == null)
          ser.setPrice(s.getStatusPrice(a));
        ser.setState("ENT");
        ser.setNdsProc(beanSession.getNds());
        ser.setNds(ser.getPrice() * (ser.getNdsProc() == 0 ? 100 : ser.getNdsProc()) / 100);
        ser.setResult(0);
        ser.setAmb_repeat("N");
        ser.setWorker(bs.getWorker() != null ? bs.getWorker() : dAmbServiceUser.getFirstUser(ser.getService().getId()));
        dAmbPatientService.save(ser);
      }
      booking.setState("ARCH");
      dAmbBooking.save(booking);
      json.put("id", a.getId());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/booking/service/user.s", method = RequestMethod.POST)
  @ResponseBody
  protected String service_user(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      AmbBookingServices a = dAmbBookingService.get(Util.getInt(req, "ser"));
      a.setWorker(beanUsers.get(Util.getInt(req, "user")));
      dAmbBookingService.save(a);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/booking/service/del.s", method = RequestMethod.POST)
  @ResponseBody
  protected String service_del(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      dAmbBookingService.delete(Util.getInt(req, "id"));
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

}
