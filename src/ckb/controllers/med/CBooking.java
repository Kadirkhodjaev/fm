package ckb.controllers.med;

import ckb.dao.admin.country.DCountry;
import ckb.dao.admin.depts.DDept;
import ckb.dao.admin.dicts.DDict;
import ckb.dao.admin.forms.opts.DOpt;
import ckb.dao.admin.users.DUser;
import ckb.dao.med.bookings.DRoomBookings;
import ckb.dao.med.dicts.rooms.DRooms;
import ckb.dao.med.patient.DPatient;
import ckb.dao.med.patient.DPatientWatchers;
import ckb.domains.admin.Dicts;
import ckb.domains.med.RoomBookings;
import ckb.domains.med.dicts.Rooms;
import ckb.domains.med.patient.PatientWatchers;
import ckb.domains.med.patient.Patients;
import ckb.models.ClinicStage;
import ckb.models.ObjList;
import ckb.models.Room;
import ckb.services.admin.form.SForm;
import ckb.session.Session;
import ckb.session.SessionUtil;
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
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/booking/")
public class CBooking {

  @Autowired private DRoomBookings dRoomBooking;
  @Autowired private DRooms dRoom;
  @Autowired private DUser dUser;
  @Autowired private DDept dDept;
  @Autowired private SForm sForm;
  @Autowired private DCountry dCountry;
  @Autowired private DOpt dOpt;
  @Autowired private DDict dDict;
  @Autowired private DPatient dPatient;
  @Autowired private DPatientWatchers dPatientWatcher;

  @RequestMapping("index.s")
  protected String serviceList(HttpServletRequest req, Model m) {
    Session session = SessionUtil.getUser(req);
    session.setCurPat(0);
    String filter = Util.nvl(req, "word", "");
    session.setCurUrl("/booking/index.s?word=" + filter);
    m.addAttribute("filter", filter);
    Integer history = Integer.parseInt(Util.nvl(req, "history", "0"));
    m.addAttribute("history", history);
    //region Услуги
    List<RoomBookings> list;
    if(filter.isEmpty()) {
      Calendar calendar = Calendar.getInstance();
      calendar.add(Calendar.DATE, 5);
      List<RoomBookings> others = dRoomBooking.getList("From RoomBookings Where dateBegin Between '" + Util.dateDB(new Date()) + "' And '" + Util.dateDB(calendar.getTime()) + "' And state = 'ENT' Order By dateBegin");
      m.addAttribute("others", others);
      list = dRoomBooking.getList("From RoomBookings Where dateBegin Not Between '" + Util.dateDB(new Date()) + "' And '" + Util.dateDB(calendar.getTime()) + "' And state = 'ENT' Order By Id Desc");
    } else {
      list = dRoomBooking.getList("From RoomBookings Where " + (filter != null ? " (lower(surname) like lower('%" + filter + "%') Or lower(name) like lower('%" + filter + "%')) And" : "") + " state = 'ENT' Order By Id Desc");
    }
    m.addAttribute("list", list);
    m.addAttribute("rooms", dRoom.getActives());
    m.addAttribute("lvs", dUser.getLvs());
    m.addAttribute("depts", dDept.getAll());
    m.addAttribute("countries", dCountry.getCounteries());
    m.addAttribute("watcherTypes", dDict.getByTypeList("WATCHER_TYPE"));
    sForm.setSelectOptionModel(m, 1, "sex");
    //endregion
    return "med/booking/index";
  }

  @RequestMapping(value = "get.s", method = RequestMethod.POST)
  @ResponseBody
  protected String getBooking(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      Integer history = Integer.parseInt(Util.nvl(req, "history", "0"));
      JSONObject bb = new JSONObject();
      if(history > 0) {
        Patients p = dPatient.get(history);
        bb.put("id", 0);
        bb.put("surname", p.getSurname());
        bb.put("name", p.getName());
        bb.put("middlename", p.getMiddlename());
        bb.put("birthyear", p.getBirthyear());
        bb.put("tel", p.getTel());
        bb.put("passport", p.getPassportInfo());
        bb.put("country", p.getCounteryId());
        bb.put("sex", p.getSex() != null ? p.getSex().getId() : 0);
        bb.put("lv", p.getLv_id() != null ? p.getLv_id() : 0);
        bb.put("date_begin", Util.dateToString(new Date()));
        bb.put("dept", 0);
        bb.put("room", 0);
        bb.put("history", history);
      } else {
        RoomBookings book = dRoomBooking.get(Util.getInt(req, "id"));
        bb.put("id", book.getId());
        bb.put("surname", book.getSurname());
        bb.put("name", book.getName());
        bb.put("middlename", book.getMiddlename());
        bb.put("birthyear", book.getBirthyear());
        bb.put("tel", book.getTel());
        bb.put("passport", book.getPassportInfo());
        bb.put("country", book.getCountry().getId());
        bb.put("sex", book.getSex() != null ? book.getSex().getId() : 0);
        bb.put("lv", book.getLv() != null ? book.getLv().getId() : 0);
        bb.put("date_begin", Util.dateToString(book.getDateBegin()));
        bb.put("dept", book.getDept().getId());
        bb.put("room", book.getRoom().getId());
        bb.put("author", book.getCrBy() > 0 ? dUser.get(book.getCrBy()).getFio() : "");
        bb.put("bron", book.getBron() != null ? book.getBron().getId() : 0);
      }
      json.put("data", bb);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String bookingSave(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    Session session = SessionUtil.getUser(req);
    try {
      int id = 0;
      if(!Util.isNull(req, "id"))
        id = Util.getInt(req, "id");
      RoomBookings book = id == 0 ? new RoomBookings() : dRoomBooking.get(id);
      if(id != 0 && session.getUserId() != 1) {
        if(session.getUserId() != book.getCrBy()) {
          json.put("success", false);
          json.put("msg", "Данная запись создана другим пользователям");
          return json.toString();
        }
      }
      book.setSurname(Util.get(req, "surname").toUpperCase());
      book.setName(Util.get(req, "name").toUpperCase());
      book.setMiddlename(Util.get(req, "middlename", "").toUpperCase());
      book.setBirthyear(Util.getInt(req, "birthyear"));
      book.setTel(Util.get(req, "tel"));
      book.setPassportInfo(Util.get(req, "passport"));
      book.setCountry(dCountry.get(Util.getInt(req, "country")));
      book.setSex(dOpt.get(Util.getInt(req, "sex")));
      if(Util.isNotNull(req, "lv"))
        book.setLv(dUser.get(Util.getInt(req, "lv")));
      book.setDateBegin(Util.stringToDate(Util.get(req, "date_begin")));
      book.setDept(dDept.get(Util.getInt(req, "dept")));
      book.setRoom(dRoom.get(Util.getInt(req, "room")));
      book.setBron(Util.isNotNull(req, "bron") && !Util.get(req, "bron").equals("0") && Util.getInt(req, "bron") > 0 ? dDict.get(Util.getInt(req, "bron")) : null);
      if(id == 0) {
        book.setState("ENT");
        book.setCrBy(session.getUserId());
        book.setCrOn(new Date());
      }
      book.setHistoryId(Util.isNull(req, "history") ? 0 : Integer.parseInt(Util.nvl(req, "history", "0")));
      dRoomBooking.save(book);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("koyki.s")
  protected String statKoyok(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/booking/koyki.s");
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    Date sysdate = Util.stringToDate(Util.getCurDate());
    List<ClinicStage> stages = new ArrayList<>();
    String vypDate = Util.isNull(req,"vypDate") ? Util.getCurDate() : Util.get(req, "vypDate");
    String emptyDate = Util.isNull(req,"emptyDate") ? Util.getCurDate() : Util.get(req, "emptyDate");
    int vypCount = 0, emptyCount = 0;
    try {
      conn = DB.getConnection();
      ps = conn.prepareStatement("Select floor From Rooms t Group By floor");
      ps.execute();
      rs = ps.getResultSet();
      while (rs.next()) {
        Dicts floor = dDict.get(rs.getInt("floor"));
        ClinicStage stage = new ClinicStage();
        stage.setCode("" + floor.getId());
        stage.setName(floor.getName());
        stages.add(stage);
      }
      for(ClinicStage stage: stages) {
        List<Rooms> rooms = dRoom.getList("From Rooms Where floor.id = " + stage.getCode());
        List<Room> stageRooms = new ArrayList<>();
        int counter = 0;
        for (Rooms room : rooms) {
          Room rr = new Room();
          rr.setNext_tr(counter % 4 == 0 ? "Y" : "N");
          counter++;
          rr.setId(room.getId());
          rr.setNum(room.getName());
          rr.setStage(room.getFloor().getName());
          rr.setType(room.getRoomType().getName());
          rr.setState(room.getState());
          ps = conn.prepareStatement("Select * From Patients t Where t.date_begin is not null And t.state != 'ARCH' And room_id = " + room.getId());
          rs = ps.executeQuery();
          List<ObjList> list = new ArrayList<>();
          while (rs.next()) {
            if(Util.isNotNull(req,"emptyDate")) {
              Date vypiska = Util.dateAddDay(rs.getDate("date_begin"), rs.getInt("day_count"));
              if(vypiska.before(Util.stringToDate(emptyDate)) || vypiska.equals(Util.stringToDate(emptyDate)))
                continue;
            }
            if(Util.isNotNull(req, "vypDate")) {
              Date vypiska = Util.dateAddDay(rs.getDate("date_begin"), rs.getInt("day_count"));
              if(!vypiska.equals(Util.stringToDate(vypDate)))
                continue;
            }
            vypCount++;
            ObjList obj = new ObjList();
            obj.setFio(rs.getString("surname") + " " + rs.getString("name"));
            obj.setIb(rs.getString("yearnum"));
            obj.setDate(Util.dateToString(rs.getDate("date_begin")));
            obj.setC1(Util.dateToString(Util.dateAddDay(rs.getDate("date_begin"), rs.getInt("day_count"))));
            obj.setC2("cr");
            obj.setC10(room.getName() + " - " + room.getRoomType().getName());
            list.add(obj);
            // Ухаживающий или Брон
            List<PatientWatchers> watchers = dPatientWatcher.byPatient(rs.getInt("id"));
            if(!watchers.isEmpty()) {
              for(PatientWatchers watcher: watchers) {
                if(sysdate.before(Util.dateAddDay(watcher.getCrOn(), watcher.getDayCount()))) {
                  obj = new ObjList();
                  obj.setFio(rs.getString("surname") + " " + rs.getString("name"));
                  obj.setIb("Уход");
                  obj.setDate(Util.dateToString(rs.getDate("date_begin")));
                  obj.setC1(Util.dateToString(Util.dateAddDay(watcher.getCrOn(), watcher.getDayCount())));
                  obj.setC2("ux");
                  obj.setC10(room.getName() + " - " + room.getRoomType().getName());
                  list.add(obj);
                }
              }
            }
          }
          ps = conn.prepareStatement("Select * From Room_Bookings t Where t.state != 'ARCH' And room_id = " + room.getId());
          rs = ps.executeQuery();
          while (rs.next()) {
            if(Util.isNotNull(req,"emptyDate")) {
              Date vypiska = Util.dateAddDay(rs.getDate("date_begin"), rs.getInt("day_count"));
              if(vypiska.before(Util.stringToDate(emptyDate)) || vypiska.equals(Util.stringToDate(emptyDate)))
                continue;
            }
            if(Util.isNotNull(req, "vypDate"))
              continue;
            ObjList obj = new ObjList();
            obj.setFio(rs.getString("surname") + " " + rs.getString("name"));
            obj.setIb("");
            obj.setDate(Util.dateToString(rs.getDate("date_begin")));
            obj.setC1("");
            obj.setC2("bk");
            obj.setC10(room.getName() + " - " + room.getRoomType().getName());
            list.add(obj);
          }
          if(list.isEmpty()) emptyCount++;
          rr.setPatients(list);
          stageRooms.add(rr);
          DB.done(ps);
          DB.done(rs);
        }
        stage.setRooms(stageRooms);
      }
      model.addAttribute("stages", stages);
      Long patientCount = dPatient.getCount("From Patients Where state = 'LV'");
      model.addAttribute("cur", patientCount);
      if(Util.isNull(req, "vypDate")) {
        model.addAttribute("vyp", dPatient.getCount("From Patients Where DAY(dateEnd) = DAY(CURRENT_TIMESTAMP()) And YEAR(dateEnd) = YEAR(CURRENT_TIMESTAMP()) And MONTH(dateEnd) = MONTH(CURRENT_TIMESTAMP())"));
      } else {
        model.addAttribute("vyp", vypCount);
      }
      Long emptyKoyko = 0L;
      //
      List<Rooms> rooms = dRoom.getAll();
      for(Rooms room: rooms) {
        Long roomPatientCount = dPatient.getCount("From Patients Where state != 'ARCH' And state != 'ZGV' And room.id = " + room.getId());
        if(roomPatientCount < room.getKoykoLimit() && room.getState().equals("A"))
          emptyKoyko += room.getKoykoLimit() - roomPatientCount;
      }
      //
      model.addAttribute("emptyCount", emptyCount);
      model.addAttribute("koekCount", emptyKoyko);
      model.addAttribute("vypDate", vypDate);
      model.addAttribute("emptyDate", emptyDate);
      //
      model.addAttribute("rooms", dRoom.getActives());
      model.addAttribute("lvs", dUser.getLvs());
      model.addAttribute("depts", dDept.getAll());
      model.addAttribute("countries", dCountry.getCounteries());
      sForm.setSelectOptionModel(model, 1, "sex");
      //
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(conn);
    }
    return "med/booking/koyki";
  }

  @RequestMapping("palata.s")
  protected String palataAccess(HttpServletRequest req, Model m) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/booking/palata.s");
    //region Услуги
    List<Rooms> list = dRoom.getAll();
    List<Room> rooms = new ArrayList<>();
    for(Rooms room: list) {
      Room rr = new Room();
      rr.setId(room.getId());
      rr.setType(room.getRoomType().getName());
      rr.setStage(room.getFloor().getName());
      rr.setNum(room.getName());
      Long count = dPatient.getCount("From Patients Where state != 'ARCH' And state != 'ZGV' And room.id = " + room.getId());
      rr.setNext_tr(count + "");
      rr.setAccess(room.getAccess());
      rr.setLimit("" + room.getKoykoLimit());
      rr.setState(room.getState());
      rooms.add(rr);
    }
    m.addAttribute("rooms", rooms);
    //endregion
    return "med/booking/palata";
  }

  @RequestMapping(value = "palata.s", method = RequestMethod.POST)
  @ResponseBody
  protected String palataAccess(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      Rooms room = dRoom.get(Util.getInt(req, "id"));
      room.setAccess(Util.get(req, "code").equals("set") ? "Y" : "N");
      dRoom.save(room);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "remove.s", method = RequestMethod.POST)
  @ResponseBody
  protected String removeBooking(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    Session session = SessionUtil.getUser(req);
    try {
      RoomBookings book = dRoomBooking.get(Util.getInt(req, "id"));
      if(session.getUserId() != book.getCrBy() && session.getUserId() != 1) {
        json.put("success", false);
        json.put("msg", "Данная запись создана другим пользователям");
        return json.toString();
      }
      dRoomBooking.delete(book.getId());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("nurse.s")
  protected String nurse(HttpServletRequest req, Model m) {
    Session session = SessionUtil.getUser(req);
    String filter = Util.get(req, "word");
    session.setCurUrl("/booking/nurse.s?word=" + filter);
    m.addAttribute("filter", filter);
    //region Услуги
    m.addAttribute("list", dRoomBooking.getList("From RoomBookings Where " + (filter != null ? " (lower(surname) like lower('%" + filter + "%') Or lower(name) like lower('%" + filter + "%')) And" : "") + " state = 'ENT' Order By date_begin"));
    //endregion
    return "med/booking/nurse";
  }


}
