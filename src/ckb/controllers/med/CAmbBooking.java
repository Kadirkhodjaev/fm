package ckb.controllers.med;

import ckb.dao.admin.country.DCountry;
import ckb.dao.admin.forms.opts.DOpt;
import ckb.dao.admin.region.DRegion;
import ckb.dao.med.amb.DAmbBooking;
import ckb.dao.med.client.DClient;
import ckb.domains.med.amb.AmbBookings;
import ckb.services.admin.form.SForm;
import ckb.session.Session;
import ckb.session.SessionUtil;
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
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

@Controller
@RequestMapping("/amb/")
public class CAmbBooking {

  @Autowired private DAmbBooking dAmbBooking;
  @Autowired private DCountry dCountry;
  @Autowired private DRegion dRegion;
  @Autowired private SForm sForm;
  @Autowired private DClient dClient;
  @Autowired private DOpt dOpt;

  @RequestMapping("bookings.s")
  protected String bookings(HttpServletRequest req, Model m){
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/amb/bookings.s");
    //
    String startDate = session.getStartDate("amb_booking", "period_start", req);
    String endDate = session.getEndDate("amb_booking", "period_end", req);
    //
    m.addAttribute("rows", dAmbBooking.list("From AmbBookings Where date(regDate) Between '" + Util.dateDB(startDate) + "' And '" + Util.dateDB(endDate) + "' Order By regDate Desc"));
    //
    m.addAttribute("period_start", startDate);
    m.addAttribute("period_end", endDate);
    //
    return "med/amb/booking/index";
  }

  @RequestMapping("booking.s")
  protected String booking(HttpServletRequest req, Model m){
    Session session = SessionUtil.getUser(req);
    int id = Util.getInt(req, "id");
    session.setCurUrl("/amb/booking.s?id=" + id);
    AmbBookings booking = id == 0 ? new AmbBookings() : dAmbBooking.get(id);
    if(id == 0) {
      booking.setId(0);
      booking.setRegDate(new Date());
    }
    sForm.setSelectOptionModel(m, 1, "sex");
    m.addAttribute("countries", dCountry.getAll());
    m.addAttribute("regions", dRegion.getAll());
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
      }
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

}
