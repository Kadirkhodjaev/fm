package ckb.controllers.med;

import ckb.dao.admin.dicts.DDict;
import ckb.dao.med.eat.claim.DEatClaim;
import ckb.dao.med.eat.claim.DEatClaimEat;
import ckb.dao.med.eat.claim.DEatClaimPatient;
import ckb.dao.med.eat.dict.category.DEatCategory;
import ckb.dao.med.eat.dict.eat.DEat;
import ckb.dao.med.eat.dict.eat.norm.DEatNorm;
import ckb.dao.med.eat.dict.measure.DEatMeasure;
import ckb.dao.med.eat.dict.menuTypes.DEatMenuType;
import ckb.dao.med.eat.dict.product.DEatProduct;
import ckb.dao.med.eat.dict.table.DEatTable;
import ckb.dao.med.eat.dict.types.DEatType;
import ckb.dao.med.eat.menu.DEatMenu;
import ckb.dao.med.eat.menu.row.DEatMenuRow;
import ckb.dao.med.eat.menu.row.detail.DEatMenuRowDetail;
import ckb.dao.med.eat.menu.template.DEatMenuTemplate;
import ckb.dao.med.eat.menu.template.DEatMenuTemplateRow;
import ckb.dao.med.nurse.eat.DNurseEatPatient;
import ckb.dao.med.nurse.eat.DNurseEats;
import ckb.dao.med.patient.DPatient;
import ckb.domains.med.eat.*;
import ckb.domains.med.eat.dict.*;
import ckb.domains.med.nurse.eat.NurseEatPatients;
import ckb.models.ObjList;
import ckb.models.PatientList;
import ckb.models.eat.EatMenuTable;
import ckb.models.eat.EatMenuTableEat;
import ckb.models.eat.EatMenuType;
import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.DB;
import ckb.utils.Req;
import ckb.utils.Util;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.persistence.PersistenceException;
import javax.servlet.http.HttpServletRequest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/eats")
public class CEat {

  @Autowired private DEatCategory dEatCategory;
  @Autowired private DEatProduct dEatProduct;
  @Autowired private DEatMeasure dEatMeasure;
  @Autowired private DEatTable dEatTable;
  @Autowired private DEat dEat;
  @Autowired private DEatType dEatType;
  @Autowired private DEatNorm dEatNorm;
  @Autowired private DDict dDict;
  @Autowired private DEatMenu dEatMenu;
  @Autowired private DEatMenuType dEatMenuType;
  @Autowired private DEatMenuRow dEatMenuRow;
  @Autowired private DEatMenuRowDetail dEatMenuRowDetail;
  @Autowired private DEatMenuTemplate dEatMenuTemplate;
  @Autowired private DEatMenuTemplateRow dEatMenuTemplateRow;
  @Autowired private DEatClaim dEatClaim;
  @Autowired private DEatClaimPatient dEatClaimPatient;
  @Autowired private DEatClaimEat dEatClaimEat;
  @Autowired private DPatient dPatient;
  @Autowired private DNurseEats dNurseEat;
  @Autowired private DNurseEatPatient dNurseEatPatient;

  @RequestMapping("/acts.s")
  protected String acts(){
    return "/med/eat/act/index";
  }

  @RequestMapping("/claims.s")
  protected String claims(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/eats/claims.s");
    //
    model.addAttribute("list", dEatClaim.getList("From EatClaims Order By Id Desc"));
    model.addAttribute("menuTypes", dEatMenuType.getList("From EatMenuTypes Where state = 'A'"));
    model.addAttribute("eatMenus", dEatMenu.getList("From EatMenus Order By Id Desc"));
    return "/med/eat/claims/index";
  }

  @RequestMapping("/claim.s")
  protected String claim(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    //
    EatMenus menu;
    EatMenuTypes menuType;
    EatClaims claim = new EatClaims();
    List<EatMenuTable> list = new ArrayList<>();
    if(Util.isNull(req, "id")) {
      List<EatTables> tables = dEatTable.getList("From EatTables");
      menu = dEatMenu.get(Util.getInt(req, "menu"));
      menuType = dEatMenuType.get(Util.getInt(req, "menu_type"));
      session.setCurUrl("/eats/claim.s?menu=" + menu.getId() + "&menu_type=" + menuType.getId());
      //
      for (EatTables table : tables) {
        EatMenuTable tb = new EatMenuTable();
        tb.setId(table.getId());
        tb.setName(table.getName());
        // Patients
        List<NurseEatPatients> patients = dNurseEatPatient.getList("From NurseEatPatients Where nurseEat.actDate = '" + Util.dateDB(Util.dateToString(menu.getMenuDate())) + "' And nurseEat.menuType.id = " + menuType.getId() + " And table.id = " + table.getId());
        List<PatientList> pats = new ArrayList<>();
        for (NurseEatPatients patient : patients) {
          PatientList pat = new PatientList();
          if(patient.getPatient() != null) {
            pat.setId(patient.getPatient().getId());
            pat.setFio(patient.getPatient().getSurname() + " " + patient.getPatient().getName() + " " + patient.getPatient().getMiddlename());
            pat.setOtdPal(patient.getPatient().getDept().getName() + "/" + patient.getPatient().getRoom().getName() + "-" + patient.getPatient().getRoom().getRoomType().getName());
            pat.setIbNum(patient.getPatient().getYearNum() + "");
            pat.setDateBegin(Util.dateToString(patient.getPatient().getDateBegin()));
            pat.setDateEnd(Util.dateToString(patient.getPatient().getDateEnd()));
          } else {
            pat.setFio(patient.getComment());
          }
          pats.add(pat);
        }
        tb.setPatients(pats);
        // Eats
        List<EatMenuRows> eats = dEatMenuRow.getList("From EatMenuRows Where menu.id = " + menu.getId() + " And table.id = " + table.getId() + " And menuType.id = " + menuType.getId());
        List<EatMenuTableEat> mEats = new ArrayList<>();
        for (EatMenuRows eat : eats) {
          EatMenuTableEat mEat = new EatMenuTableEat();
          mEat.setRowId(eat.getId());
          mEat.setId(eat.getEat().getId());
          mEat.setName(eat.getEat().getName());
          mEat.setTypeName(eat.getEat().getType().getName());
          mEats.add(mEat);
        }
        tb.setEats(mEats);
        list.add(tb);
      }
    } else {
      claim = dEatClaim.get(Util.getInt(req, "id"));
      menu = claim.getMenu();
      menuType = claim.getMenuType();
      List<Integer> tables = dEatClaimPatient.getClaimTables(claim.getId());
      for(Integer tbl: tables) {
        EatTables table = dEatTable.get(tbl);
        EatMenuTable tb = new EatMenuTable();
        tb.setId(table.getId());
        tb.setName(table.getName());
        // Patients
        List<EatClaimPatients> patients = dEatClaimPatient.getList("From EatClaimPatients Where claim.id = " + claim.getId() + " And table.id = " + table.getId());
        List<PatientList> pats = new ArrayList<>();
        for (EatClaimPatients patient : patients) {
          PatientList pat = new PatientList();
          if(patient.getPatient() != null) {
            pat.setId(patient.getPatient().getId());
            pat.setFio(patient.getPatient().getSurname() + " " + patient.getPatient().getName() + " " + patient.getPatient().getMiddlename());
            pat.setOtdPal(patient.getPatient().getDept().getName() + "/" + patient.getPatient().getRoom().getName() + "-" + patient.getPatient().getRoom().getRoomType().getName());
            pat.setIbNum(patient.getPatient().getYearNum() + "");
            pat.setDateBegin(Util.dateToString(patient.getPatient().getDateBegin()));
            pat.setDateEnd(Util.dateToString(patient.getPatient().getDateEnd()));
          } else {
            pat.setFio(patient.getInfo());
            pat.setId(-1);
          }
          pats.add(pat);
        }
        tb.setPatients(pats);
        // Eats
        List<EatClaimEats> eats = dEatClaimEat.getList("From EatClaimEats Where claim.id = " + claim.getId() + " And table.id = " + table.getId());
        List<EatMenuTableEat> mEats = new ArrayList<>();
        for (EatClaimEats eat : eats) {
          EatMenuTableEat mEat = new EatMenuTableEat();
          mEat.setRowId(eat.getId());
          mEat.setId(eat.getEat().getId());
          mEat.setName(eat.getEat().getName());
          mEat.setTypeName(eat.getEat().getType().getName());
          mEats.add(mEat);
        }
        tb.setEats(mEats);
        list.add(tb);
      }
    }
    model.addAttribute("claim", claim);
    model.addAttribute("list", list);
    model.addAttribute("menu", menu);
    model.addAttribute("menuType", menuType);
    return "/med/eat/claims/generate";
  }

  @RequestMapping("/claim/patients.s")
  protected String claimPatients(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    EatClaims claim = dEatClaim.get(Util.getInt(req, "id"));
    session.setCurUrl("/eats/claim/patients.s?id=" + claim.getId());
    model.addAttribute("claim", claim);
    //
    List<ObjList> patients = new ArrayList<>();
    List<ObjList> eats = new ArrayList<>();
    //
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      conn = DB.getConnection();
      ps = conn.prepareStatement(
        "Select Concat(t.surname, ' ',  t.name, ' ', t.middlename) Fio, t.yearnum, Date_Format(t.date_begin, '%d.%m.%Y') date_begin, Date_Format(t.date_end, '%d.%m.%Y') date_end, t.intime, t.date_end, " +
          "         (Select c.Name From Rooms c Where c.Id = t.Room_Id) Room, " +
          "         (Select c.Name From Depts c Where c.Id = t.Dept_Id) Dept, " +
          "         (Select c.Name From Eat_S_Tables c Where c.Id = d.Table_Id) Table_Num," +
          "         (Select c.fio From Users c Where c.Id = t.lv_id) lv" +
          "     From Patients t, Patient_Eats d " +
          "    Where t.Id = d.patient_id And date(d.actDate) = ? And d.menuType_Id = ?"
      );
      ps.setString(1, Util.dateDB(Util.dateToString(claim.getMenu().getMenuDate())));
      ps.setInt(2, claim.getMenuType().getId());
      rs = ps.executeQuery();
      while (rs.next()) {
        ObjList obj = new ObjList();
        obj.setFio(rs.getString("Fio"));
        obj.setIb(rs.getString("yearnum"));
        obj.setC1(rs.getString("dept") + " / " + rs.getString("room"));
        obj.setC2(rs.getString("date_begin"));
        obj.setC3(rs.getString("intime"));
        obj.setC4(rs.getString("date_end"));
        obj.setC5(rs.getString("table_num"));
        obj.setC6(rs.getString("lv"));
        patients.add(obj);
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(conn);
    }
    //
    model.addAttribute("patients", patients);
    model.addAttribute("eats", eats);
    //
    return "/med/eat/claims/patients";
  }

  @RequestMapping("/claim/refresh.s")
  protected String claimRefresh(HttpServletRequest req, Model model) {
    //
    List<EatMenuTable> list = new ArrayList<>();
    EatClaims claim = dEatClaim.get(Util.getInt(req, "id"));
    EatMenus menu = claim.getMenu();
    EatMenuTypes menuType = claim.getMenuType();

    List<EatTables> tables = dEatTable.getList("From EatTables Where state = 'A'");
    //
    for (EatTables table : tables) {
      EatMenuTable tb = new EatMenuTable();
      tb.setId(table.getId());
      tb.setName(table.getName());
      // Patients
      List<NurseEatPatients> patients = dNurseEatPatient.getList("From NurseEatPatients Where nurseEat.actDate = '" + Util.dateDB(Util.dateToString(menu.getMenuDate())) + "' And nurseEat.menuType.id = " + menuType.getId() + " And table.id = " + table.getId());
      List<PatientList> pats = new ArrayList<>();
      for (NurseEatPatients patient : patients) {
        PatientList pat = new PatientList();
        if(patient.getPatient() != null) {
          pat.setId(patient.getPatient().getId());
          pat.setFio(patient.getPatient().getSurname() + " " + patient.getPatient().getName() + " " + patient.getPatient().getMiddlename());
          pat.setOtdPal(patient.getPatient().getDept().getName() + "/" + patient.getPatient().getRoom().getName() + "-" + patient.getPatient().getRoom().getRoomType().getName());
          pat.setIbNum(patient.getPatient().getYearNum() + "");
          pat.setDateBegin(Util.dateToString(patient.getPatient().getDateBegin()));
          pat.setDateEnd(Util.dateToString(patient.getPatient().getDateEnd()));
        } else {
          pat.setFio(patient.getComment());
          pat.setId(-1);
        }
        pats.add(pat);
      }
      tb.setPatients(pats);
      // Eats
      List<EatMenuRows> eats = dEatMenuRow.getList("From EatMenuRows Where menu.id = " + menu.getId() + " And table.id = " + table.getId() + " And menuType.id = " + menuType.getId());
      List<EatMenuTableEat> mEats = new ArrayList<>();
      for (EatMenuRows eat : eats) {
        EatMenuTableEat mEat = new EatMenuTableEat();
        mEat.setRowId(eat.getId());
        mEat.setId(eat.getEat().getId());
        mEat.setName(eat.getEat().getName());
        mEat.setTypeName(eat.getEat().getType().getName());
        mEats.add(mEat);
      }
      tb.setEats(mEats);
      list.add(tb);
    }
    model.addAttribute("claim", claim);
    model.addAttribute("list", list);
    model.addAttribute("menu", menu);
    model.addAttribute("menuType", menuType);
    return "/med/eat/claims/generate";
  }

  @RequestMapping(value = "/claim/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String claimSave(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      EatMenus menu = dEatMenu.get(Util.getInt(req, "menu"));
      EatMenuTypes menuType = dEatMenuType.get(Util.getInt(req, "menu_type"));
      String[] tIds = req.getParameterValues("table");
      List<EatTables> tables = new ArrayList<>();
      if(tIds != null)
        for(String id: tIds)
          tables.add(dEatTable.get(Integer.parseInt(id)));
      //
      EatClaims claim = new EatClaims();
      if(Util.isNull(req, "id")) {
        Long checker = dEatClaim.getCount("From EatClaims Where menu.id = " + menu.getId() + " And menuType.id = " + menuType.getId());
        if(checker > 0) {
          throw new Exception("По выбранным параметрам уже существует Заявка");
        }
        claim.setMenu(menu);
        claim.setMenuType(menuType);
        claim.setState("ENT");
        dEatClaim.save(claim);
      } else {
        claim = dEatClaim.get(Util.getInt(req, "id"));
      }
      for(EatTables table: tables) {
        dEatClaimPatient.deleteTable(claim, table);
        dEatClaimEat.deleteTable(claim, table);
        String[] patients = req.getParameterValues("p" + table.getId());
        String[] infos = req.getParameterValues("info" + table.getId());
        String[] eats = req.getParameterValues("e" + table.getId());
        int i=0;
        if(patients != null) {
          for(String pId: patients) {
            EatClaimPatients tb = new EatClaimPatients();
            tb.setClaim(claim);
            tb.setTable(table);
            if(Integer.parseInt(pId) > 0) {
              tb.setPatient(dPatient.get(Integer.parseInt(pId)));
            } else {
              tb.setInfo(infos[i]);
            }
            dEatClaimPatient.save(tb);
            i++;
          }
          if(eats != null) {
            for(String eat: eats) {
              EatClaimEats et = new EatClaimEats();
              et.setEat(dEat.get(Integer.parseInt(eat)));
              et.setClaim(claim);
              et.setTable(table);
              dEatClaimEat.save(et);
            }
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

  @RequestMapping(value = "/claim/del.s", method = RequestMethod.POST)
  @ResponseBody
  protected String claimDelete(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      dEatClaimPatient.deleteByClaim(Util.getInt(req, "id"));
      dEatClaimEat.deleteByClaim(Util.getInt(req, "id"));
      dEatClaim.delete(Util.getInt(req, "id"));
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/claims/check.s", method = RequestMethod.POST)
  @ResponseBody
  protected String checkClaim(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      int menu = Util.getInt(req, "menu");
      int type = Util.getInt(req, "menu_type");
      Long checker = dEatClaim.getCount("From EatClaims Where menu.id = " + menu + " And menuType.id = " + type);
      EatMenus m = dEatMenu.get(menu);
      if(checker > 0)
        throw new Exception("По выбранным параметрам уже существует Заявка");
      checker = dEatClaim.getCount("From EatClaims Where state = 'ENT'");
      if(checker > 0)
        throw new Exception("Подтвердите предыдущие записи");
      checker = dNurseEat.getCount("From NurseEats Where menuType.id = " + type + " And actDate = '" + Util.dateDB(Util.dateToString(m.getMenuDate())) + "' And state = 'CON'");
      if(checker == 0)
        throw new Exception("Нет подтвержденных настроенных данных с пациентами со стораны Старшой медсестры");
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/claim/confirm.s", method = RequestMethod.POST)
  @ResponseBody
  protected String claimConfirm(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      EatClaims menu = dEatClaim.get(Util.getInt(req, "id"));
      menu.setState("CON");
      dEatClaim.save(menu);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("/menu/details.s")
  protected String menuDetails(HttpServletRequest req, Model model) throws JSONException {
    Session session = SessionUtil.getUser(req);
    EatMenus menu = dEatMenu.get(Util.getInt(req, "id"));
    session.setCurUrl("/eats/menu/details.s?id=" + menu.getId());
    //
    List<EatMenuType> mMenuTypes = new ArrayList<>();
    List<EatMenuTypes> menuTypes = dEatMenuType.getList("From EatMenuTypes Where state = 'A'");
    List<EatTables> tables = dEatTable.getList("From EatTables Order By Id");
    model.addAttribute("tables", tables);
    for(EatMenuTypes menuType: menuTypes) {
      EatMenuType mMenuType = new EatMenuType();
      mMenuType.setId(menuType.getId());
      mMenuType.setName(menuType.getName());
      List<EatMenuTable> mTables = new ArrayList<>();
      for(EatTables table: tables) {
        EatMenuTable tbl = new EatMenuTable();
        tbl.setId(table.getId());
        tbl.setName(table.getName());
        List<EatMenuRows> rows = dEatMenuRow.getList("From EatMenuRows Where menu.id = " + menu.getId() + " And table.id = " + tbl.getId() + " And menuType.id = " + mMenuType.getId());
        JSONArray eatJson = new JSONArray();
        List<EatMenuTableEat> mEats = new ArrayList<>();
        for(EatMenuRows row: rows) {
          EatMenuTableEat mEat = new EatMenuTableEat();
          JSONObject mEatJson = new JSONObject();
          mEat.setRowId(row.getId());
          mEat.setId(row.getEat().getId());
          mEat.setName(row.getEat().getName());
          mEatJson.put("row_id", mEat.getRowId());
          mEatJson.put("id", mEat.getId());
          mEatJson.put("name", mEat.getName());
          eatJson.put(mEatJson);
          mEats.add(mEat);
        }
        tbl.setEats(mEats);
        tbl.setEatJson(eatJson.toString());
        mTables.add(tbl);
      }
      mMenuType.setTables(mTables);
      mMenuTypes.add(mMenuType);
    }
    List<EatTypes> types = dEatType.getList("From EatTypes Where state = 'A'");
    List<ObjList> eats = new ArrayList<>();
    for(EatTypes type: types) {
      ObjList obj = new ObjList();
      obj.setC1(type.getName());
      obj.setC2("" + type.getId());
      List<Eats> ets = dEat.getList("From Eats Where type.id = " + type.getId() + " And state = 'A'");
      List<ObjList> list = new ArrayList<>();
      for(Eats et : ets) {
        ObjList e = new ObjList();
        e.setC1("" + et.getId());
        e.setC2(et.getName());
        if(dEatNorm.getCount("From EatNorms Where eat.id = " + et.getId()) > 0) {
          list.add(e);
        }
      }
      if(!list.isEmpty()) {
        obj.setList(list);
        eats.add(obj);
      }
    }
    model.addAttribute("menuTypes", mMenuTypes);
    model.addAttribute("menu", menu);
    model.addAttribute("eats", eats);
    return "/med/eat/menus/details";
  }

  @RequestMapping("/menu.s")
  protected String menu(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/eats/menu.s");
    model.addAttribute("menus", dEatMenu.getList("From EatMenus Order By Id Desc"));
    model.addAttribute("curDate", Util.getCurDate());
    return "/med/eat/menus/index";
  }

  @RequestMapping("/menu/rasxod.s")
  protected String menuRasxod(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    EatClaims claim = dEatClaim.get(Util.getInt(req, "id"));
    session.setCurUrl("/eats/menu/rasxod.s?id=" + claim.getId());
    model.addAttribute("claim", claim);
    //
    List<ObjList> products = new ArrayList<>();
    List<ObjList> eats = new ArrayList<>();
    //
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      conn = DB.getConnection();
      ps = conn.prepareStatement(
        " Select d.Id, " +
          " Max(d.name) product_name, " +
          " Sum(a.rasxod) rasxod, " +
          " f.name measure_name " +
          "  From Eat_Claims t, eat_claim_patients s, eat_claim_eats e, eat_s_norms a, eat_s_products d, eat_s_measures f " +
          "  Where t.Id = ? " +
          "    and s.claim_Id = t.Id " +
          "    and s.table_Id = e.table_Id " +
          "    And e.claim_Id = s.claim_Id " +
          "    and a.eat_Id = e.eat_Id " +
          "    and d.id = a.product_id " +
          "    and f.id = a.measure_Id " +
          "   Group By d.Id, f.name "
      );
      ps.setInt(1, claim.getId());
      rs = ps.executeQuery();
      while (rs.next()) {
        ObjList obj = new ObjList();
        obj.setC1(rs.getString("id"));
        obj.setC2(rs.getString("product_name"));
        obj.setC3(rs.getString("rasxod"));
        obj.setC4(rs.getString("measure_name"));
        products.add(obj);
      }
      ps = conn.prepareStatement(
        "Select t.Eat_Id Eat_Id, " +
          "          Max(c.Name) eat_Name, " +
          "          Count(*) Eat_Count " +
          "From Eat_Claims a, eat_claim_patients f, Eat_Menu_rows t, Eat_s_Eats c " +
          "Where a.Id = ? " +
          "  And a.Id = f.claim_Id" +
          "  And t.menu_Id = a.menu_Id" +
          "  and t.menuType_Id = a.menuType_Id" +
          "  and t.table_Id = f.table_Id" +
          "  and c.Id = t.eat_Id" +
          " Group By t.eat_Id "
      );
      ps.setInt(1, claim.getId());
      rs = ps.executeQuery();
      while (rs.next()) {
        if(rs.getDouble("eat_count") > 0) {
          ObjList obj = new ObjList();
          obj.setC1(rs.getString("eat_id"));
          obj.setC2(rs.getString("eat_name"));
          obj.setC3(rs.getString("eat_count"));
          eats.add(obj);
        }
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(conn);
    }
    //
    model.addAttribute("products", products);
    model.addAttribute("eats", eats);
    //
    return "/med/eat/menus/rasxod";
  }

  @RequestMapping(value = "/menu/confirm.s", method = RequestMethod.POST)
  @ResponseBody
  protected String menuConfirm(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      EatMenus menu = dEatMenu.get(Util.getInt(req, "id"));
      menu.setState("CON");
      dEatMenu.save(menu);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/menu/copy/eat.s", method = RequestMethod.POST)
  @ResponseBody
  protected String menuCopyEat(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    Connection conn = null;
    PreparedStatement ps = null;
    JSONArray ids = new JSONArray();
    try {
      conn = DB.getConnection();
      //
      Integer menu = Req.getInt(req, "menu");
      Integer menuType = Req.getInt(req, "menu_type");
      Integer table = Req.getInt(req, "table");
      String[] tables = req.getParameterValues("id");
      if(tables != null) {
        for (String tb : tables) {
          ids.put(tb);
          ps = conn.prepareStatement("Delete t From Eat_Menu_Rows t Where t.menu_id = ? And t.menuType_id = ? And t.table_id = ?");
          ps.setInt(1, menu);
          ps.setInt(2, menuType);
          ps.setInt(3, Integer.parseInt(tb));
          ps.execute();
          //
          ps = conn.prepareStatement("Insert Into Eat_Menu_Rows(eat_id, menu_id, menuType_id, table_id) Select t.eat_id, t.menu_id, t.menuType_Id, ? From Eat_Menu_Rows t Where t.menu_id = ? And t.menuType_id = ? And t.table_id = ?");
          ps.setInt(1, Integer.parseInt(tb));
          ps.setInt(2, menu);
          ps.setInt(3, menuType);
          ps.setInt(4, table);
          ps.execute();
          //
        }
      }
      json.put("ids", ids);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    } finally {
      DB.done(conn);
      DB.done(ps);
    }
    return json.toString();
  }

  @RequestMapping("/eat/filter.s")
  protected String eatFilter(HttpServletRequest req, Model model) {
    List<EatTypes> types = dEatType.getList("From EatTypes Where state = 'A'");
    List<ObjList> eats = new ArrayList<>();
    for(EatTypes type: types) {
      ObjList obj = new ObjList();
      obj.setC1(type.getName());
      obj.setC2("" + type.getId());
      List<Eats> ets = dEat.getList("From Eats Where upper(name) like '%" + Util.get(req, "filter").toUpperCase() + "%' And type.id = " + type.getId() + " And state = 'A'");
      List<ObjList> list = new ArrayList<>();
      for(Eats et : ets) {
        ObjList e = new ObjList();
        e.setC1("" + et.getId());
        e.setC2(et.getName());
        list.add(e);
      }
      if(!list.isEmpty()) {
        obj.setList(list);
        eats.add(obj);
      }
    }
    model.addAttribute("eats", eats);
    return "/med/eat/menus/filter";
  }

  @RequestMapping(value = "/menu/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String menuSave(HttpServletRequest req) throws JSONException {
    Session session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      Long checker = dEatClaim.getCount("From EatMenus Where menuDate = '" + Util.dateDB(Util.get(req, "menu_date")) + "'");
      if(checker > 0) throw new Exception("По выбранным параметрам уже существует Меню");
      checker = dEatClaim.getCount("From EatMenus Where state = 'ENT'");
      if(checker > 0) throw new Exception("Подтвердите предыдущие записи");
      EatMenus menu = Util.isNull(req, "id") ? new EatMenus() : dEatMenu.get(Util.getInt(req, "id"));
      menu.setMenuDate(Util.getDate(req, "menu_date"));
      menu.setInfo(Util.get(req, "extra_info"));
      if(menu.getId() == null) {
        menu.setState("ENT");
        menu.setCrBy(session.getUserId());
        menu.setCrOn(new Date());
      }
      try {
        dEatMenu.save(menu);
      } catch (PersistenceException e) {
        throw new Exception("Запись за выбранную дату уже существует");
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/menu/del.s", method = RequestMethod.POST)
  @ResponseBody
  protected String menuDel(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      dEatMenu.delete(Util.getInt(req, "id"));
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/menu/table/row/del.s", method = RequestMethod.POST)
  @ResponseBody
  protected String menuTableRowDel(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      List<EatMenuRowDetails> details = dEatMenuRowDetail.getList("From EatMenuRowDetails Where eatMenuRow.id = " + Util.getInt(req, "id"));
      for(EatMenuRowDetails detail: details) {
        dEatMenuRowDetail.delete(detail.getId());
      }
      dEatMenuRow.delete(Util.getInt(req, "id"));
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/menu/table/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String menuTableSave(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      EatMenus menu = dEatMenu.get(Util.getInt(req, "menu"));
      EatMenuTypes menuType = dEatMenuType.get(Util.getInt(req, "menu_type"));
      EatTables table = dEatTable.get(Util.getInt(req, "table"));
      List<EatMenuRows> rows = dEatMenuRow.getList("From EatMenuRows Where menu.id = " + menu.getId() + " And table.id = " + table.getId() + " And menuType.id = " + menuType.getId());
      for(EatMenuRows row: rows) dEatMenuRow.delete(row.getId());
      String[] ids = req.getParameterValues("id");
      if(ids != null)
        for(String id: ids) {
          EatMenuRows row = new EatMenuRows();
          row.setEat(dEat.get(Integer.parseInt(id)));
          row.setMenu(menu);
          row.setTable(table);
          row.setMenuType(menuType);
          dEatMenuRow.save(row);
          List<EatNorms> norms = dEatNorm.getList("From EatNorms Where eat.id = " + row.getEat().getId());
          for(EatNorms norm: norms) {
            EatMenuRowDetails detail = new EatMenuRowDetails();
            detail.setRasxod(norm.getRasxod());
            detail.setMeasure(norm.getMeasure());
            detail.setProduct(norm.getProduct());
            detail.setEatMenuRow(row);
            dEatMenuRowDetail.save(detail);
          }
        }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/menu/table/eats/get.s", method = RequestMethod.POST)
  @ResponseBody
  protected String menuTableEatsGet(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      List<EatMenuRows> rows = dEatMenuRow.getList("From EatMenuRows Where menu.id = " + Util.getInt(req, "menu") + " And table.id = " + Util.getInt(req, "table") + " And menuType.id = " + Util.getInt(req, "menuType"));
      JSONArray list = new JSONArray();
      for(EatMenuRows row: rows) {
        JSONObject obj = new JSONObject();
        obj.put("row_id", row.getId());
        obj.put("id", row.getEat().getId());
        obj.put("name", row.getEat().getName());
        list.put(obj);
      }
      json.put("list", list);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/template/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String templateSave(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      String[] ids = req.getParameterValues("id");
      EatMenuTypes type = dEatMenuType.get(Util.getInt(req, "menu_type"));
      EatTables table = dEatTable.get(Util.getInt(req, "table"));
      String name = Util.get(req, "name");
      Long count = dEatMenuTemplate.getCount("From EatMenuTemplates Where upper(name) = '" + name.toUpperCase() + "' And table.id = " + table.getId() + " And menuType.id = " + type.getId());
      if(count == 0) {
        EatMenuTemplates template = new EatMenuTemplates();
        template.setName(name);
        template.setMenuType(type);
        template.setTable(table);
        dEatMenuTemplate.save(template);
        for(String id: ids) {
          EatMenuTemplateRows row = new EatMenuTemplateRows();
          row.setTemplateId(template.getId());
          row.setEat(dEat.get(Integer.parseInt(id)));
          dEatMenuTemplateRow.save(row);
        }
      } else {
        throw new Exception("Данное название уже существует в списке");
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("/templates.s")
  protected String templates(HttpServletRequest req, Model model) {
    List<EatMenuTable> list = new ArrayList<>();
    String tableName = "", menuTypeName = "";
    List<EatMenuTemplates> temps = dEatMenuTemplate.getList("From EatMenuTemplates Where table.id = " + Util.getInt(req, "table") + " And menuType.id = " + Util.getInt(req, "type"));
    for(EatMenuTemplates temp: temps) {
      EatMenuTable obj = new EatMenuTable();
      obj.setId(temp.getId());
      obj.setName(temp.getName());
      List<EatMenuTableEat> rows = new ArrayList<>();
      List<EatMenuTemplateRows> rws = dEatMenuTemplateRow.getList("From EatMenuTemplateRows Where templateId = " + temp.getId());
      for(EatMenuTemplateRows rw: rws) {
        EatMenuTableEat row = new EatMenuTableEat();
        row.setId(rw.getEat().getId());
        row.setName(rw.getEat().getName());
        rows.add(row);
      }
      obj.setEats(rows);
      list.add(obj);
      menuTypeName = temp.getMenuType().getName();
      tableName = temp.getTable().getName();
    }
    model.addAttribute("templates", list);
    model.addAttribute("tableName", tableName);
    model.addAttribute("menuTypeName", menuTypeName);
    return "/med/eat/menus/templates";
  }

  @RequestMapping(value = "/template/set.s", method = RequestMethod.POST)
  @ResponseBody
  protected String templateSet(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      EatMenuTemplates temp = dEatMenuTemplate.get(Util.getInt(req, "id"));
      List<EatMenuRows> rows = dEatMenuRow.getList("From EatMenuRows Where menu.id = " + Util.getInt(req, "menu") + " And table.id = " + temp.getTable().getId() + " And menuType.id = " + temp.getMenuType().getId());
      for(EatMenuRows row: rows) {
        List<EatMenuRowDetails> details = dEatMenuRowDetail.getList("From EatMenuRowDetails Where eatMenuRow.id = " + row.getId());
        for(EatMenuRowDetails detail: details) {
          dEatMenuRowDetail.delete(detail.getId());
        }
        dEatMenuRow.delete(row.getId());
      }
      List<EatMenuTemplateRows> rws = dEatMenuTemplateRow.getList("From EatMenuTemplateRows Where templateId = " + temp.getId());
      for(EatMenuTemplateRows rw: rws) {
        EatMenuRows row = new EatMenuRows();
        row.setMenuType(temp.getMenuType());
        row.setMenu(dEatMenu.get(Util.getInt(req, "menu")));
        row.setTable(temp.getTable());
        row.setEat(rw.getEat());
        dEatMenuRow.save(row);
        List<EatNorms> norms = dEatNorm.getList("From EatNorms Where eat.id = " + row.getEat().getId());
        for(EatNorms norm: norms) {
          EatMenuRowDetails detail = new EatMenuRowDetails();
          detail.setRasxod(norm.getRasxod());
          detail.setMeasure(norm.getMeasure());
          detail.setProduct(norm.getProduct());
          detail.setEatMenuRow(row);
          dEatMenuRowDetail.save(detail);
        }
      }
      json.put("mtId", temp.getMenuType().getId());
      json.put("tbId", temp.getTable().getId());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("/dicts.s")
  protected String dicts(HttpServletRequest request, Model model) {
    Session session = SessionUtil.getUser(request);
    session.setCurUrl("/eats/dicts.s");
    if(!session.getCurSubUrl().contains("/eats/dict/"))
      session.setCurSubUrl("/eats/dict/categories.s");
    //
    Util.makeMsg(request, model);
    return "/med/eat/dict/index";
  }

  @RequestMapping(value = "/dict/delete.s", method = RequestMethod.POST)
  @ResponseBody
  protected String deleteDict(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      if(Util.get(req, "code").equals("category")) dEatCategory.delete(Util.getInt(req, "id"));
      if(Util.get(req, "code").equals("type")) dEatType.delete(Util.getInt(req, "id"));
      if(Util.get(req, "code").equals("product")) dEatProduct.delete(Util.getInt(req, "id"));
      if(Util.get(req, "code").equals("measure")) dEatMeasure.delete(Util.getInt(req, "id"));
      if(Util.get(req, "code").equals("table")) dEatTable.delete(Util.getInt(req, "id"));
      if(Util.get(req, "code").equals("menuType")) dEatMenuType.delete(Util.getInt(req, "id"));
      if(Util.get(req, "code").equals("eat")) {
        dEatNorm.deleteByEat(Util.getInt(req, "id"));
        dEat.delete(Util.getInt(req, "id"));
      }
      if(Util.get(req, "code").equals("eat-product")) {
        dEatNorm.delete(Util.getInt(req, "id"));
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/dict/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String save(HttpServletRequest req) throws JSONException {
    Session session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      if(Util.get(req, "code").equals("category")) {
        EatCategories obj = Util.isNull(req, "id") ? new EatCategories() : dEatCategory.get(Util.getInt(req, "id"));
        obj.setName(Util.get(req, "name"));
        obj.setState(Util.isNull(req, "state") ? "P" : "A");
        if (Util.isNull(req, "id")) {
          obj.setCrBy(session.getUserId());
          obj.setCrOn(new Date());
        }
        try {
          dEatCategory.save(obj);
        } catch (PersistenceException e) {
          throw new Exception("Данное название уже существует в списке");
        }
      }
      if(Util.get(req, "code").equals("product")) {
        EatProducts obj = Util.isNull(req, "id") ? new EatProducts() : dEatProduct.get(Util.getInt(req, "id"));
        obj.setName(Util.get(req, "name"));
        obj.setState(Util.isNull(req, "state") ? "P" : "A");
        obj.setCategory(dEatCategory.get(Util.getInt(req, "category")));
        obj.setMeasureType(dDict.get(Util.getInt(req, "measureType")));
        if (Util.isNull(req, "id")) {
          obj.setCrBy(session.getUserId());
          obj.setCrOn(new Date());
        }
        dEatProduct.save(obj);
      }
      if(Util.get(req, "code").equals("table")) {
        EatTables obj = Util.isNull(req, "id") ? new EatTables() : dEatTable.get(Util.getInt(req, "id"));
        obj.setName(Util.get(req, "name"));
        obj.setState(Util.isNull(req, "state") ? "P" : "A");
        if (Util.isNull(req, "id")) {
          obj.setCrBy(session.getUserId());
          obj.setCrOn(new Date());
        }
        try {
          dEatTable.save(obj);
        } catch (PersistenceException e) {
          throw new Exception("Данное название уже существует в списке");
        }
      }
      if(Util.get(req, "code").equals("menuType")) {
        EatMenuTypes obj = Util.isNull(req, "id") ? new EatMenuTypes() : dEatMenuType.get(Util.getInt(req, "id"));
        obj.setName(Util.get(req, "name"));
        obj.setState(Util.isNull(req, "state") ? "P" : "A");
        if (Util.isNull(req, "id")) {
          obj.setCrBy(session.getUserId());
          obj.setCrOn(new Date());
        }
        try {
          dEatMenuType.save(obj);
        } catch (PersistenceException e) {
          throw new Exception("Данное название уже существует в списке");
        }
      }
      if(Util.get(req, "code").equals("type")) {
        EatTypes obj = Util.isNull(req, "id") ? new EatTypes() : dEatType.get(Util.getInt(req, "id"));
        obj.setName(Util.get(req, "name"));
        obj.setState(Util.isNull(req, "state") ? "P" : "A");
        if (Util.isNull(req, "id")) {
          obj.setCrBy(session.getUserId());
          obj.setCrOn(new Date());
        }
        try {
          dEatType.save(obj);
        } catch (PersistenceException e) {
          throw new Exception("Данное название уже существует в списке");
        }
      }
      if(Util.get(req, "code").equals("eat")) {
        Eats obj = Util.isNull(req, "id") ? new Eats() : dEat.get(Util.getInt(req, "id"));
        obj.setName(Util.get(req, "name"));
        obj.setType(dEatType.get(Util.getInt(req, "type_id")));
        obj.setState(Util.isNull(req, "state") ? "P" : "A");
        if (Util.isNull(req, "id")) {
          obj.setCrBy(session.getUserId());
          obj.setCrOn(new Date());
        }
        try {
          dEat.save(obj);
          String[] ids = req.getParameterValues("norm_id");
          String[] products = req.getParameterValues("product");
          String[] rasxods = req.getParameterValues("rasxod");
          String[] measures = req.getParameterValues("measure");
          int i=0;
          if(ids == null) {
            throw new Exception("Расходы блюд не может быть пустым");
          }
          for (String id: ids) {
            EatNorms norm = id.equals("0") ? new EatNorms() : dEatNorm.get(Integer.parseInt(id));
            norm.setEat(obj);
            norm.setProduct(dEatProduct.get(Integer.parseInt(products[i])));
            norm.setMeasure(dEatMeasure.get(Integer.parseInt(measures[i])));
            norm.setRasxod(Double.parseDouble(rasxods[i]));
            dEatNorm.save(norm);
            i++;
          }
        } catch (PersistenceException e) {
          throw new Exception("Данное название уже существует в списке");
        }
        json.put("id", obj.getId());
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/dict/get.s", method = RequestMethod.POST)
  @ResponseBody
  protected String getDict(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      if(Util.get(req, "code").equals("category")) {
        EatCategories obj = dEatCategory.get(Util.getInt(req, "id"));
        json.put("id", obj.getId());
        json.put("name", obj.getName());
        json.put("state", obj.getState());
      }
      if(Util.get(req, "code").equals("product")) {
        EatProducts obj = dEatProduct.get(Util.getInt(req, "id"));
        json.put("id", obj.getId());
        json.put("category", obj.getCategory().getId());
        json.put("name", obj.getName());
        json.put("state", obj.getState());
        if(obj.getMeasureType() != null)
          json.put("measureType", obj.getMeasureType().getId());
      }
      if(Util.get(req, "code").equals("table")) {
        EatTables obj = dEatTable.get(Util.getInt(req, "id"));
        json.put("id", obj.getId());
        json.put("name", obj.getName());
        json.put("state", obj.getState());
      }
      if(Util.get(req, "code").equals("menuType")) {
        EatMenuTypes obj = dEatMenuType.get(Util.getInt(req, "id"));
        json.put("id", obj.getId());
        json.put("name", obj.getName());
        json.put("state", obj.getState());
      }
      if(Util.get(req, "code").equals("type")) {
        EatTypes obj = dEatType.get(Util.getInt(req, "id"));
        json.put("id", obj.getId());
        json.put("name", obj.getName());
        json.put("state", obj.getState());
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("/dict/categories.s")
  protected String dictCategories(HttpServletRequest req, Model model){
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/eats/dicts.s");
    session.setCurSubUrl("/eats/dict/categories.s");
    //
    model.addAttribute("list", dEatCategory.getAll());
    return "/med/eat/dict/categories/index";
  }

  @RequestMapping("/dict/products.s")
  protected String dictProducts(HttpServletRequest req, Model model){
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/eats/dicts.s");
    session.setCurSubUrl("/eats/dict/products.s");
    //
    model.addAttribute("list", dEatProduct.getAll());
    model.addAttribute("categories", dEatCategory.getAll());
    model.addAttribute("measureTypes", dDict.getByTypeList("MEASURE_CATS"));
    return "/med/eat/dict/products/index";
  }

  @RequestMapping("/dict/measures.s")
  protected String dictMeasure(HttpServletRequest req, Model model){
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/eats/dicts.s");
    session.setCurSubUrl("/eats/dict/measures.s");
    //
    model.addAttribute("cats", dDict.getByTypeList("MEASURE_CATS"));
    model.addAttribute("list", dEatMeasure.getAll());
    return "/med/eat/dict/measures/index";
  }

  @RequestMapping("/dict/tables.s")
  protected String dictTable(HttpServletRequest req, Model model){
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/eats/dicts.s");
    session.setCurSubUrl("/eats/dict/tables.s");
    //
    model.addAttribute("list", dEatTable.getAll());
    return "/med/eat/dict/tables/index";
  }

  @RequestMapping("/dict/menuTypes.s")
  protected String dictMenuType(HttpServletRequest req, Model model){
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/eats/dicts.s");
    session.setCurSubUrl("/eats/dict/menuTypes.s");
    //
    model.addAttribute("list", dEatMenuType.getAll());
    return "/med/eat/dict/menuTypes/index";
  }

  @RequestMapping("/dict/types.s")
  protected String dictEatTypes(HttpServletRequest req, Model model){
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/eats/dicts.s");
    session.setCurSubUrl("/eats/dict/types.s");
    //
    model.addAttribute("list", dEatType.getAll());
    return "/med/eat/dict/types/index";
  }

  @RequestMapping("/dict/eats.s")
  protected String dictEats(HttpServletRequest req, Model model){
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/eats/dicts.s");
    session.setCurSubUrl("/eats/dict/eats.s");
    //
    model.addAttribute("list", dEat.getAll());
    model.addAttribute("tables", dEatTable.getAll());
    return "/med/eat/dict/eats/index";
  }

  @RequestMapping("/dict/eat/addEdit.s")
  protected String dictEatAddEdit(HttpServletRequest req, Model model){
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/eats/dicts.s");
    session.setCurSubUrl("/eats/dict/eat/addEdit.s?id=" + Util.getInt(req, "id"));
    //
    model.addAttribute("types", dEatType.getAll());
    model.addAttribute("eat", dEat.get(Util.getInt(req, "id")));
    model.addAttribute("norms", dEatNorm.getList("From EatNorms Where eat.id = " + Util.getInt(req, "id")));
    model.addAttribute("products", dEatProduct.getAll());
    model.addAttribute("measures", dEatMeasure.getList("From EatMeasures t Order By cat.id, ord"));
    return "/med/eat/dict/eats/addEdit";
  }

}
