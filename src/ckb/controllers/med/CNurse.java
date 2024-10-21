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
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;

@Controller
@RequestMapping("/nurses")
public class CNurse {

  private Session session = null;

  @Autowired private DPatient dPatient;
  @Autowired private DKdoTypes dKdoType;
  @Autowired private DLvBio dLvBio;
  @Autowired private DLvGarmon dLvGarmon;
  @Autowired private DLvCoul dLvCoul;
  @Autowired private DLvTorch dLvTorch;
  @Autowired private DDept dDep;
  @Autowired private DUser dUser;
  @Autowired private DLvFizio dLvFizio;
  @Autowired private DLvFizioDate dLvFizioDate;
  @Autowired private DKdos dKdo;

  @RequestMapping("/work.s")
  protected String acts(HttpServletRequest req, Model model) {
    session = SessionUtil.getUser(req);
    session.setCurUrl("/nurses/work.s");

    String dep = Util.get(req, "dep");
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null, rc = null;
    boolean is1 = false, is3 = false, is4 = false, is6 = false, is10 = false, is11 = false, is12 = false, is13 = false, is14 = false, is15 = false, is16 = false, is17 = false;
    try {
      List<Depts> depts = dDep.getAll();
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
          Kdos kdo = dKdo.get(rc.getInt("kdo_id"));
          String name = kdo.getName();
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
          if (rc.getInt("kdo_type_id") == 1 || rc.getInt("kdo_type_id") == 2) {
            is1 = true;
            row.setC11((row.getC11() == null ? "" : row.getC11() + "<br/>") + name);
          }
          if (rc.getInt("kdo_type_id") == 3) {
            is3 = true;
            row.setC13((row.getC13() == null ? "" : row.getC13() + "<br/>") + name);
          }
          if (rc.getInt("kdo_type_id") == 4) {
            is4 = true;
            row.setC14((row.getC14() == null ? "" : row.getC14() + "<br/>") + name);
          }
          if (rc.getInt("kdo_type_id") == 6) {
            is6 = true;
            row.setC16((row.getC16() == null ? "" : row.getC16() + "<br/>") + name);
          }
          if (rc.getInt("kdo_type_id") == 10) {
            is10 = true;
            row.setC20((row.getC20() == null ? "" : row.getC20() + "<br/>") + name);
          }
          if (rc.getInt("kdo_type_id") == 11) {
            is11 = true;
            row.setC21((row.getC21() == null ? "" : row.getC21() + "<br/>") + name);
          }
          if (rc.getInt("kdo_type_id") == 12) {
            is12 = true;
            row.setC22((row.getC22() == null ? "" : row.getC22() + "<br/>") + name);
          }
          if (rc.getInt("kdo_type_id") == 13) {
            is13 = true;
            row.setC23((row.getC23() == null ? "" : row.getC23() + "<br/>") + name);
          }
          if (rc.getInt("kdo_type_id") == 14) {
            is14 = true;
            row.setC24((row.getC24() == null ? "" : row.getC24() + "<br/>") + name);
          }
          if (rc.getInt("kdo_type_id") == 17) {
            is17 = true;
            row.setC27((row.getC27() == null ? "" : row.getC27() + "<br/>") + name);
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
          row.setC25((row.getC25() == null ? "" : row.getC25() + "<br/>") + name);
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
    session = SessionUtil.getUser(req);
    session.setCurUrl("nurses/fizio.s");
    //
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null,  rc = null, rg = null;
    String status = Util.get(req, "status", "0");
    String room = Util.get(req, "room", "0");
    String dated = Util.get(req, "dated", Util.getCurDate());
    Integer patId = Integer.parseInt(Util.get(req, "patient", "0"));
    Integer kdoId = Integer.parseInt(Util.get(req, "kdo", "0"));
    LinkedHashMap<Integer, Kdos> kdos = new LinkedHashMap<Integer, Kdos>();
    List<Obj> rows = new ArrayList<Obj>();
    List<Obj> rooms = new ArrayList<Obj>();
    try {
      conn = DB.getConnection();
      ps = conn.prepareStatement("Select room From Kdos Where room is not null Group By room");
      rs = ps.executeQuery();
      while (rs.next()) {
        Obj r = new Obj();
        r.setName(rs.getString("room"));
        rooms.add(r);
      }
      DB.done(ps);
      DB.done(rs);
      ps = conn.prepareStatement(
        "Select c.id Patient,  " +
          "         Concat(c.surname, ' ', c.name, ' ', c.middlename) Fio,  " +
          "         r.name room  " +
          "    From Patients c, Rooms r " +
          "   Where Exists ( " +
          "      Select 1 " +
          "        From Lv_Fizios g, Lv_Fizio_Dates d " +
          "       Where d.fizio_Id = g.id  " +
          "         And date(d.date) = ? " +
          "         And g.patientId = c.id " +
          "         And d.state = 'Y')  " +
          "    And c.room_id = r.id " +
          "    And c.state != 'ARCH' " +
          (patId > 0 ? " And c.id = " + patId : " " )
      );
      ps.setString(1, Util.dateDB(dated));
      rs = ps.executeQuery();
      while(rs.next()) {
        Obj p = new Obj();
        p.setId(rs.getInt("patient"));
        p.setFio(rs.getString("fio"));
        p.setName(rs.getString("room"));
        List<ObjList> rws = new ArrayList<ObjList>();
        String query = "Select f.name kdo_name, " +
          "         c.comment, " +
          "         d.done, " +
          "         d.id, " +
          "         f.id kdo_id, " +
          "         d.fizio_id, " +
          "         d.confDate, " +
          "         f.room, " +
          "         date(d.date) dated " +
          "  From Lv_Fizios c, lv_fizio_dates d, Kdos f " +
          " Where c.patientId = " + p.getId() +
          "   And d.fizio_Id = c.id " +
          "   And f.Id = c.Kdo_Id " +
          (room.equals("0") ? "" : " And f.room = '" + room + "'") +
          (kdoId > 0 ? " And f.id = " + kdoId : " " ) +
          (status.equals("0") ? "" : (status.equals("0") ? "" : " And d.done = '" + status + "' ")) +
          "  And d.state = 'Y' " +
          "  And date(d.date) = ? ";
        ps = conn.prepareStatement(query);
        ps.setString(1, Util.dateDB(dated));
        rc = ps.executeQuery();
        while (rc.next()) {
          ObjList row = new ObjList();
          row.setId(rc.getInt("id"));
          row.setC1(rc.getString("kdo_name"));
          row.setC2(rc.getString("comment"));
          row.setC3(rc.getString("done"));
          row.setC4(Util.dateTimeToString(rc.getTimestamp("confDate")));
          //
          row.setC7(rc.getString("room"));
          rws.add(row);
          if(!kdos.containsKey(rc.getInt("kdo_id")))
            kdos.put(rc.getInt("kdo_id"), dKdo.get(rc.getInt("kdo_id")));
        }
        DB.done(rc);
        DB.done(ps);
        p.setList(rws);
        rows.add(p);
      }
      model.addAttribute("room", room);
      model.addAttribute("kdoId", kdoId);
      model.addAttribute("patId", patId);
      model.addAttribute("dated", dated);
      model.addAttribute("status", status);
      model.addAttribute("kdos", kdos);
      model.addAttribute("rooms", rooms);
      model.addAttribute("rows", rows);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rg);
      DB.done(rc);
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
}
