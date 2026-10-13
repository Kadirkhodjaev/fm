package ckb.controllers.med;

import ckb.dao.admin.depts.DDept;
import ckb.dao.admin.users.DUser;
import ckb.dao.med.kdos.DKdoTypes;
import ckb.dao.med.kdos.DKdos;
import ckb.dao.med.lv.bio.DLvBio;
import ckb.dao.med.lv.coul.DLvCoul;
import ckb.dao.med.lv.fizio.DLvFizio;
import ckb.dao.med.lv.fizio.DLvFizioDate;
import ckb.dao.med.lv.garmon.DLvGarmon;
import ckb.dao.med.lv.torch.DLvTorch;
import ckb.dao.med.patient.DPatient;
import ckb.domains.admin.Depts;
import ckb.domains.admin.Kdos;
import ckb.domains.admin.Users;
import ckb.domains.med.lv.*;
import ckb.domains.med.patient.Patients;
import ckb.models.Obj;
import ckb.models.ObjList;
import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.BeanSession;
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
import java.util.*;

@Controller
@RequestMapping("/nurses")
public class CNurse {

  @Autowired private DPatient dPatient;
  @Autowired private DKdoTypes dKdoType;
  @Autowired private DLvBio dLvBio;
  @Autowired private DLvGarmon dLvGarmon;
  @Autowired private DLvCoul dLvCoul;
  @Autowired private DLvTorch dLvTorch;
  @Autowired private DLvFizio dLvFizio;
  @Autowired private DLvFizioDate dLvFizioDate;
  @Autowired private DKdos dKdo;
  @Autowired private DUser dUser;
  @Autowired private DDept dDep;
  @Autowired private BeanSession beanSession;

  @RequestMapping("/work.s")
  protected String acts(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/nurses/work.s");

    String dep = Util.get(req, "dep");
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null, rc = null;
    boolean is1 = false, is3 = false, is4 = false, is6 = false, is10 = false, is11 = false, is12 = false, is13 = false, is14 = false, is15 = false, is16 = false, is17 = false, is22 = false;
    try {
      List<Depts> depts = beanSession.getDepts();
      Users user = dUser.get(session.getUserId());
      if(session.getUserId() == 1 || user.isGlb()) {
        dep = dep == null ? depts.get(0).getId() + "" : dep;
        model.addAttribute("depts", depts);
      } else {
        dep = user.getDept().getId().toString();
        model.addAttribute("depts", dDep.getList("From Depts Where id = " + user.getDept().getId()));
      }
      List<ObjList> rows = new ArrayList<>();
      conn = DB.getConnection();
      ps = conn.prepareStatement(
        "Select t.id " +
          "    From Patients t " +
          "   Where t.state = 'LV' " +
          "     And t.dept_id = ? " +
          "   Group By t.id "
      );
      ps.setInt(1, dep == null ? session.getDeptId() : Integer.parseInt(dep));
      rs = ps.executeQuery();
      //
      Map<Integer, Kdos> kdoMap = new HashMap<>();
      for (Kdos k : dKdo.getAll()) kdoMap.put(k.getId(), k);
      //
      while (rs.next()) {
        ObjList row = new ObjList();
        Patients d = dPatient.get(rs.getInt("id"));
        row.setC1(d.getSurname() + " " + d.getName() + " " + d.getMiddlename());
        row.setC2(d.getBirthyear() + "");
        row.setC3(Util.dateToString(d.getDateBegin()));
        row.setC4(d.getYearNum() + "");
        row.setC30(d.getRoom().getName() + "-" + d.getRoom().getRoomType().getName());
        ps = conn.prepareStatement(
          "Select t.id, " +
            "         t.comment, " +
            "         t.actDate, " +
            "         t.Done_Flag, " +
            "         t.Result_Id," +
            "         t.Kdo_Type_Id," +
            "         t.Kdo_Id " +
            "    From Lv_Plans t" +
            "   Where t.patientId =  " + d.getId() +
            "     And t.result_date is null "
        );
        rc = ps.executeQuery();
        int i = 0;
        while (rc.next()) {
          i++;
          Kdos kdo = kdoMap.get(rc.getInt("kdo_id"));
          String name = kdo.getName();
          int type = rc.getInt("kdo_type_id");
          if (rc.getInt("kdo_id") == 13) { // Биохимия
            String st = "";
            LvBios bio = dLvBio.getByPlan(rc.getInt("id"));
            if (bio != null) {
              if (bio.getC1() == 1) st += "Глюкоза крови, ";
              if (bio.getC2() == 1) st += "Холестерин, ";
              if (bio.getC3() == 1) st += "Бетта липопротеиды, ";
              if (bio.getC4() == 1) st += "Общий белок, ";
              if (bio.getC5() == 1) st += "Мочевина, ";
              if (bio.getC23() == 1) st += "Fе (железо), ";
              if (bio.getC8() == 1) st += "Билирубин, ";
              if (bio.getC7() == 1) st += "Креатинин, ";
              if (bio.getC13() == 1) st += "Амилаза крови, ";
              if (bio.getC12() == 1) st += "Трансаминазы-АЛТ, ";
              if (bio.getC14() == 1) st += "Мочевая кислота, ";
              if (bio.getC11() == 1) st += "Трансаминазы-АСТ, ";
              if (bio.getC15() == 1) st += "Сывороточное железо, ";
              if (bio.getC16() == 1) st += "К-калий, ";
              if (bio.getC17() == 1) st += "Na - натрий, ";
              if (bio.getC18() == 1) st += "Са - кальций, ";
              if (bio.getC19() == 1) st += "Cl - хлор, ";
              if (bio.getC20() == 1) st += "Phos - фосфор, ";
              if (bio.getC21() == 1) st += "Mg - магний, ";
              if (bio.getC24() == 1) st += "Альбумин, ";
              if (bio.getC25() == 1) st += "Лактатдегидрогеноза, ";
              if (bio.getC26() == 1) st += "Гамма-глутамилтрансфераза, ";
              if (bio.getC27() == 1) st += "Шелочная фосфотаза, ";
              if (bio.getC28() == 1) st += "Тимоловая проба, ";
              if (bio.getC29() == 1) st += "Креотенин киназа, ";
              if (st != "") {
                st = st.substring(0, st.length() - 1);
                name = name + "<br/>" + st;
              }
            }
          }
          if (rc.getInt("kdo_id") == 153) { // Биохимия
            String st = "";
            LvBios bio = dLvBio.getByPlan(rc.getInt("id"));
            if (bio != null) {
              if (bio.getC1() == 1) st += "Умумий оксил, ";
              if (bio.getC2() == 1) st += "Холестерин, ";
              if (bio.getC3() == 1) st += "Глюкоза, ";
              if (bio.getC4() == 1) st += "Мочевина, ";
              if (bio.getC5() == 1) st += "Креатинин, ";
              if (bio.getC6() == 1) st += "Билирубин, ";
              if (bio.getC7() == 1) st += "АЛТ, ";
              if (bio.getC8() == 1) st += "АСТ, ";
              if (bio.getC9() == 1) st += "Альфа амилаза, ";
              if (bio.getC10() == 1) st += "Кальций, ";
              if (bio.getC11() == 1) st += "Сийдик кислотаси, ";
              if (bio.getC12() == 1) st += "K – калий, ";
              if (bio.getC13() == 1) st += "Na – натрий, ";
              if (bio.getC14() == 1) st += "Fe – темир, ";
              if (bio.getC15() == 1) st += "Mg – магний, ";
              if (bio.getC16() == 1) st += "Ишкорий фасфотаза, ";
              if (bio.getC17() == 1) st += "ГГТ, ";
              if (bio.getC18() == 1) st += "Гликирланган гемоглобин, ";
              if (bio.getC19() == 1) st += "РФ, ";
              if (bio.getC20() == 1) st += "АСЛО, ";
              if (bio.getC21() == 1) st += "СРБ, ";
              if (bio.getC22() == 1) st += "RW, ";
              if (bio.getC23() == 1) st += "Hbs Ag, ";
              if (bio.getC24() == 1) st += "Гепатит «С» ВГС, ";
              if (st != "") {
                st = st.substring(0, st.length() - 1);
                name = name + ": <b>" + st + "</b>";
              }
            }
          }
          if (rc.getInt("kdo_id") == 56) { // Каулограмма
            String st = "";
            LvCouls bio = dLvCoul.getByPlan(rc.getInt("id"));
            if (bio != null) {
              if (bio.isC4()) st += "ПТИ, ";
              if (bio.isC1()) st += "Фибриноген, ";
              if (bio.isC2()) st += "Тромбин вакти, ";
              if (bio.isC3()) st += "А.Ч.Т.В. (сек), ";
              if (st != "") {
                st = st.substring(0, st.length() - 1);
                name = name + ": <b>" + st + "</b>";
              }
            }
          }
          if (rc.getInt("kdo_id") == 120) { // Garmon
            String st = "";
            LvGarmons bio = dLvGarmon.getByPlan(rc.getInt("id"));
            if (bio != null) {
              if (bio.isC1()) st += "ТТГ, ";
              if (bio.isC2()) st += "Т4, ";
              if (bio.isC3()) st += "Т3, ";
              if (bio.isC4()) st += "Анти-ТРО, ";
              if (st != "") {
                st = st.substring(0, st.length() - 1);
                name = name + ": <b>" + st + "</b>";
              }
            }
          }
          if (rc.getInt("kdo_id") == 121) { // Торч
            String st = "";
            LvTorchs bio = dLvTorch.getByPlan(rc.getInt("id"));
            if (bio != null) {
              if (bio.isC1()) st += "Хламидия, ";
              if (bio.isC2()) st += "Токсоплазма, ";
              if (bio.isC3()) st += "ЦМВ, ";
              if (bio.isC4()) st += "ВПГ, ";
              if (st != "") {
                st = st.substring(0, st.length() - 1);
                name = name + ": <b>" + st + "</b>";
              }
            }
          }
          if (rc.getInt("kdo_id") == 17) { // Торч
            name += ":" + rc.getString("comment");
          }
          name ="<img src=\"/res/imgs/" + (rc.getInt("result_id") > 0 ? "yellow" : "red") + ".gif\"> <b><i>" + Util.dateToString(rc.getDate("actDate")) + "</i></b> - " + name;
          if (type == 1 || type == 2 || type == 23 || type == 20 || type == 18) {
            is1 = true;
            row.setC11((row.getC11() == null ? "" : row.getC11() + "<br/>") + name);
          }
          if (type == 3) {
            is3 = true;
            row.setC13((row.getC13() == null ? "" : row.getC13() + "<br/>") + name);
          }
          if (type == 4) {
            is4 = true;
            row.setC14((row.getC14() == null ? "" : row.getC14() + "<br/>") + name);
          }
          if (type == 6) {
            is6 = true;
            row.setC16((row.getC16() == null ? "" : row.getC16() + "<br/>") + name);
          }
          if (type == 10) {
            is10 = true;
            row.setC20((row.getC20() == null ? "" : row.getC20() + "<br/>") + name);
          }
          if (type == 11) {
            is11 = true;
            row.setC21((row.getC21() == null ? "" : row.getC21() + "<br/>") + name);
          }
          if (type == 12) {
            is12 = true;
            row.setC22((row.getC22() == null ? "" : row.getC22() + "<br/>") + name);
          }
          if (type == 13) {
            is13 = true;
            row.setC23((row.getC23() == null ? "" : row.getC23() + "<br/>") + name);
          }
          if (type == 14) {
            is14 = true;
            row.setC24((row.getC24() == null ? "" : row.getC24() + "<br/>") + name);
          }
          if (type == 17) {
            is17 = true;
            row.setC27((row.getC27() == null ? "" : row.getC27() + "<br/>") + name);
          }
          if (type == 22) {
            is22 = true;
            row.setC25((row.getC25() == null ? "" : row.getC25() + "<br/>") + name);
          }
        }
        DB.done(rc);
        DB.done(ps);
        ps = conn.prepareStatement(
          " Select t.lvname, t.date actDate " +
            "    From Lv_Consuls t " +
            "   Where t.state != 'DONE' " +
            "     And t.patientId = ? "
        );
        ps.setInt(1, d.getId());
        rc = ps.executeQuery();
        //
        while (rc.next()) {
          i++;
          is15 = true;
          String name ="<b><i>" + rc.getString("actDate") + "</i></b> - " + rc.getString("lvname");
          row.setC18((row.getC18() == null ? "" : row.getC18() + "<br/>") + name);
        }
        if(d.isFizio()) {
          if(dLvFizio.getCount("From LvFizios Where patientId = " + d.getId()) == 0) {
            i++;
            is16 = true;
            row.setC26("Физиотерапия");
          }
        }
        if(i > 0) rows.add(row);
        DB.done(rc);
        DB.done(ps);
      }
      model.addAttribute("dep", Long.parseLong(dep));
      model.addAttribute("is1", is1);
      model.addAttribute("is3", is3);
      model.addAttribute("is4", is4);
      model.addAttribute("is6", is6);
      model.addAttribute("is10", is10);
      model.addAttribute("is11", is11);
      model.addAttribute("is12", is12);
      model.addAttribute("is13", is13);
      model.addAttribute("is14", is14);
      model.addAttribute("is15", is15);
      model.addAttribute("is16", is16);
      model.addAttribute("is17", is17);
      model.addAttribute("is22", is22);
      model.addAttribute("types", dKdoType.getList("From KdoTypes Where state = 'A'"));
      model.addAttribute("rows", rows);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rc);
      DB.done(rs);
      DB.done(ps);
      DB.done(conn);
    }
    return "/med/nurse/index";
  }

  @RequestMapping("/fizio.s")
  protected String fizio(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("nurses/fizio.s");
    //
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    String status = Util.get(req, "status", "0");
    String room = Util.get(req, "room", "0");
    String dated = Util.get(req, "dated", Util.getCurDate());
    Integer patId = Integer.parseInt(Util.get(req, "patient", "0"));
    Integer kdoId = Integer.parseInt(Util.get(req, "kdo", "0"));
    LinkedHashMap<Integer, Kdos> kdos = new LinkedHashMap<Integer, Kdos>();
    List<Obj> rows = new ArrayList<>();
    List<Obj> patients = new ArrayList<>();
    List<Obj> rooms = new ArrayList<>();
    try {
      conn = DB.getConnection();
      ps = conn.prepareStatement("Select room From Kdos Where room is not null And room != '' Group By room");
      rs = ps.executeQuery();
      while (rs.next()) {
        Obj r = new Obj();
        r.setName(rs.getString("room"));
        rooms.add(r);
      }
      DB.done(rs);
      DB.done(ps);
      // Все процедуры дня одним запросом (раньше - отдельный запрос на каждого пациента).
      // Диапазон по дате, а не date(d.date) = ?, чтобы работал индекс lv_fizio_dates_idx (date, fizio_Id).
      ps = conn.prepareStatement(
        "Select c.id pid, Concat(c.surname, ' ', c.name, ' ', IfNull(c.middlename, '')) fio, r.name palata, " +
        "       d.id, d.done, d.confDate, g.comment, f.id kdo_id, f.name kdo_name, f.room " +
        "  From Lv_Fizio_Dates d " +
        "  Join Lv_Fizios g On g.id = d.fizio_Id " +
        "  Join Kdos f On f.id = g.Kdo_Id " +
        "  Join Patients c On c.id = g.patientId " +
        "  Join Rooms r On r.id = c.room_id " +
        " Where d.date >= ? And d.date < Date_Add(?, Interval 1 Day) " +
        "   And d.state = 'Y' And c.state != 'ARCH' " +
        " Order By c.surname, c.name, c.id, f.name");
      ps.setString(1, Util.dateDB(dated));
      ps.setString(2, Util.dateDB(dated));
      rs = ps.executeQuery();
      Map<Integer, Kdos> kdoMap = new HashMap<>();
      for (Kdos k : dKdo.getAll()) kdoMap.put(k.getId(), k);
      Obj p = null;
      while (rs.next()) {
        int pid = rs.getInt("pid");
        int kid = rs.getInt("kdo_id");
        String kRoom = Util.nvl(rs.getString("room"));
        String done = rs.getString("done");
        if (p == null || p.getId() != pid) {
          p = new Obj();
          p.setId(pid);
          p.setFio(rs.getString("fio"));
          p.setName(rs.getString("palata"));
          p.setList(new ArrayList<ObjList>());
          patients.add(p);
        }
        // выпадающий список процедур - все процедуры дня, а не только найденные фильтром
        if (!kdos.containsKey(kid) && kdoMap.get(kid) != null) kdos.put(kid, kdoMap.get(kid));
        if (patId > 0 && pid != patId) continue;
        if (!room.equals("0") && !room.equals(kRoom)) continue;
        if (kdoId > 0 && kid != kdoId) continue;
        if (!status.equals("0") && !status.equals(done)) continue;
        ObjList row = new ObjList();
        row.setId(rs.getInt("id"));
        row.setC1(rs.getString("kdo_name"));
        row.setC2(rs.getString("comment"));
        row.setC3(done);
        row.setC4(Util.dateTimeToString(rs.getTimestamp("confDate")));
        row.setC7(kRoom);
        p.getList().add(row);
      }
      for (Obj o : patients) if (!o.getList().isEmpty()) rows.add(o);
      model.addAttribute("room", room);
      model.addAttribute("kdoId", kdoId);
      model.addAttribute("patId", patId);
      model.addAttribute("dated", dated);
      model.addAttribute("status", status);
      model.addAttribute("kdos", kdos);
      model.addAttribute("rooms", rooms);
      model.addAttribute("rows", rows);
      model.addAttribute("patients", patients);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(conn);
    }
    //
    return "med/nurse/fizio/index";
  }

  @RequestMapping(value = "/fizio.s", method = RequestMethod.POST)
  @ResponseBody
  protected String setFizio(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      LvFizioDates df = dLvFizioDate.get(Util.getInt(req, "id"));
      df.setDone(Util.get(req, "type"));
      df.setConfDate(Util.get(req, "type").equals("Y") ? new Date() : null);
      dLvFizioDate.save(df);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  // Больничные листы: пациенты, которым при регистрации указано "Больничный лист = Да"
  @RequestMapping("/sicks.s")
  protected String sicks(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/nurses/sicks.s");

    String dep = Util.get(req, "dep", "");

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    List<ObjList> rows = new ArrayList<>();
    try {
      List<Depts> depts = beanSession.getDepts();
      Users user = dUser.get(session.getUserId());
      if (session.getUserId() == 1 || user.isGlb()) {
        dep = dep.isEmpty() && !depts.isEmpty() ? depts.get(0).getId() + "" : dep;
        model.addAttribute("depts", depts);
      } else {
        dep = user.getDept() == null ? "" : user.getDept().getId().toString();
        model.addAttribute("depts", dep.isEmpty() ? new ArrayList<Depts>() : dDep.getList("From Depts Where id = " + dep));
      }
      // Один запрос: отделение, палата, врач и МКБ-10 из осмотра врача (без N+1)
      String sql =
        "Select t.id, t.surname, t.name, t.middlename, t.birthyear, t.yearNum, t.Date_Begin, t.Date_End, t.state, t.palata, " +
        "       d.name dept_name, r.name room_name, rt.name room_type, u.fio lv_fio, " +
        "       m.code mkb_code, m.name mkb_name, o.mkb mkb_text " +
        "  From Patients t " +
        "  Left Join Depts d On d.id = t.Dept_Id " +
        "  Left Join Rooms r On r.id = t.Room_Id " +
        "  Left Join Dicts rt On rt.id = r.roomType " +
        "  Left Join Users u On u.id = t.lv_id " +
        "  Left Join Lv_Docs o On o.id = (Select Max(x.id) From Lv_Docs x Where x.patient_id = t.id And x.docCode = 'osm') " +
        "  Left Join Mkb m On m.id = o.mkb_id " +
        " Where t.sick_leave = 'Y' " +
        "   And t.state = 'LV' " +
        (dep.isEmpty() ? "" : " And t.Dept_Id = ? ") +
        " Order By t.Date_Begin Desc, t.id Desc";
      conn = DB.getConnection();
      ps = conn.prepareStatement(sql);
      if (!dep.isEmpty()) ps.setInt(1, Integer.parseInt(dep));
      rs = ps.executeQuery();
      while (rs.next()) {
        ObjList row = new ObjList();
        row.setC1(rs.getString("id"));
        row.setC2((Util.nvl(rs.getString("surname")) + " " + Util.nvl(rs.getString("name")) + " " + Util.nvl(rs.getString("middlename"))).trim());
        row.setC3(rs.getInt("yearNum") != 0 ? rs.getInt("yearNum") + "" : "");
        row.setC4(Util.dateToString(rs.getTimestamp("Date_Begin")));
        if (rs.getTimestamp("Date_Begin") != null) {
          Calendar rc = Calendar.getInstance();
          rc.setTime(rs.getTimestamp("Date_Begin"));
          rc.add(Calendar.DAY_OF_MONTH, 4);
          row.setC13(Util.dateToString(rc.getTime()));
        }
        row.setC5(Util.dateToString(rs.getTimestamp("Date_End")));
        String room = rs.getString("palata");
        if (room == null && rs.getString("room_name") != null)
          room = rs.getString("room_name") + (rs.getString("room_type") != null ? "-" + rs.getString("room_type") : "");
        row.setC6(Util.nvl(rs.getString("dept_name")));
        row.setC7(Util.nvl(room));
        row.setC8(Util.nvl(rs.getString("lv_fio")));
        row.setC9(Util.nvl(rs.getString("mkb_code")));
        row.setC10(rs.getString("mkb_name") != null ? rs.getString("mkb_name") : Util.nvl(rs.getString("mkb_text")));
        row.setC11(rs.getString("state"));
        row.setC12(rs.getInt("birthyear") != 0 ? rs.getInt("birthyear") + "" : "");
        rows.add(row);
      }
    } catch (Exception e) {
      e.printStackTrace();
      model.addAttribute("loadErr", true);
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(conn);
    }
    model.addAttribute("rows", rows);
    model.addAttribute("dep", dep);
    return "med/nurse/sicks";
  }
}
