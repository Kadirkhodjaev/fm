package ckb.controllers.med;

import ckb.dao.admin.country.DCountry;
import ckb.dao.admin.region.DRegion;
import ckb.dao.med.amb.DAmbBooking;
import ckb.services.admin.form.SForm;
import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/amb/")
public class CAmbBooking {

  @Autowired private DAmbBooking dAmbBooking;
  @Autowired private DCountry dCountry;
  @Autowired private DRegion dRegion;
  @Autowired private SForm sForm;

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
    m.addAttribute("bookings", dAmbBooking.getAll());
    return "med/amb/booking/index";
  }

  @RequestMapping("booking.s")
  protected String booking(HttpServletRequest req, Model m){
    Session session = SessionUtil.getUser(req);
    int id = Util.getInt(req, "id");
    session.setCurUrl("/amb/booking.s?id=" + id);

    sForm.setSelectOptionModel(m, 1, "sex");
    m.addAttribute("countries", dCountry.getAll());
    m.addAttribute("regions", dRegion.getAll());
    m.addAttribute("booking", dAmbBooking.get(id));
    return "med/amb/booking/form";
  }
}
