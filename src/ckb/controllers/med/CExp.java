package ckb.controllers.med;

import ckb.dao.admin.dicts.DDict;
import ckb.dao.med.amb.DAmbService;
import ckb.dao.med.exp.dict.category.DExpCategory;
import ckb.dao.med.exp.dict.measure.DExpMeasure;
import ckb.dao.med.exp.dict.norm.DExpNorm;
import ckb.dao.med.exp.dict.product.DExpProduct;
import ckb.dao.med.kdos.DKdos;
import ckb.dao.med.lv.plan.DKdoChoosen;
import ckb.domains.admin.Kdos;
import ckb.domains.med.amb.AmbServices;
import ckb.domains.med.exp.dict.ExpCategories;
import ckb.domains.med.exp.dict.ExpNorms;
import ckb.domains.med.exp.dict.ExpProducts;
import ckb.domains.med.lv.KdoChoosens;
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

import javax.persistence.PersistenceException;
import javax.servlet.http.HttpServletRequest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;

@Controller
@RequestMapping("/exp/")
public class CExp {

  private Session session;

  @Autowired private DExpCategory dExpCategory;
  @Autowired private DExpProduct dExpProduct;
  @Autowired private DExpMeasure dExpMeasure;
  @Autowired private DExpNorm dExpNorm;
  @Autowired private DDict dDict;
  //
  @Autowired private DAmbService dAmbService;
  @Autowired private DKdos dKdo;
  @Autowired private DKdoChoosen dKdoChoosen;

  @RequestMapping("stat.s")
  private String home(HttpServletRequest req, Model model) {
    session = SessionUtil.getUser(req);
    session.setCurUrl("/exp/stat.s");
    String startDate = Util.get(req, "period_start", Util.getCurDate());
    String endDate = Util.get(req, "period_end", Util.getCurDate());
    model.addAttribute("period_start", startDate);
    model.addAttribute("period_end", endDate);

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    ResultSet rc = null;
    List<ObjList> list = new ArrayList<>();
    try {
      conn = DB.getConnection();
      HashMap<String, Double> totals = new HashMap<>();
      //region Стационар
      ps = conn.prepareStatement(
        "Select c.product_id, d.Name product_name, c.measure_id, m.Name measure_name, Sum(c.Rasxod) Rasxod " +
          "  From Lv_Plans t, Exp_s_Norms c, Exp_s_Products d, Exp_s_Measures m " +
          "  Where d.Id = c.Product_Id " +
          "    And m.Id = c.Measure_Id " +
          "    And c.ParentType = 'stat' " +
          "    And c.service = t.kdo_id " +
          "    And t.Result_Date Between ? And ? " +
          "    And t.Done_Flag = 'Y' " +
          "  Group By c.product_id, d.Name, c.measure_id, m.Name "
      );
      ps.setString(1, Util.dateDBBegin(startDate));
      ps.setString(2, Util.dateDBEnd(endDate));
      ps.execute();
      rs = ps.getResultSet();
      while (rs.next()) {
        ObjList obj = new ObjList();
        obj.setC1(rs.getString("product_id"));
        obj.setC2(rs.getString("product_name"));
        obj.setC3(rs.getString("measure_name"));
        obj.setC4(rs.getString("rasxod"));
        list.add(obj);
        String key = rs.getInt("product_id") + "_" + rs.getInt("measure_id");
        if(totals.containsKey(key))
          totals.put(key, totals.get(key) + rs.getDouble("rasxod"));
        else
          totals.put(key, rs.getDouble("rasxod"));
      }
      model.addAttribute("stats", list);
      //endregion
      //region Амбулатория
      list = new ArrayList<>();
      ps = conn.prepareStatement(
        "Select c.product_id, d.Name product_name, c.measure_id, m.Name measure_name, Sum(c.Rasxod) Rasxod " +
          "  From Amb_Patient_Services t, Exp_s_Norms c, Exp_s_Products d, Exp_s_Measures m " +
          "  Where d.Id = c.Product_Id " +
          "    And m.Id = c.Measure_Id " +
          "    And c.ParentType = 'amb' " +
          "    And c.service = t.service_id " +
          "    And t.confDate Between ? And ? " +
          "    And t.state = 'DONE' " +
          "  Group By c.product_id, d.Name, c.measure_id, m.Name "
      );
      ps.setString(1, Util.dateDBBegin(startDate));
      ps.setString(2, Util.dateDBEnd(endDate));
      ps.execute();
      rs = ps.getResultSet();
      while (rs.next()) {
        ObjList obj = new ObjList();
        obj.setC1(rs.getString("product_id"));
        obj.setC2(rs.getString("product_name"));
        obj.setC3(rs.getString("measure_name"));
        obj.setC4(rs.getString("rasxod"));
        list.add(obj);
        String key = rs.getInt("product_id") + "_" + rs.getInt("measure_id");
        if(totals.containsKey(key))
          totals.put(key, totals.get(key) + rs.getDouble("rasxod"));
        else
          totals.put(key, rs.getDouble("rasxod"));
      }
      model.addAttribute("ambs", list);
      //endregion
      //region Детализация
      list = new ArrayList<>();
      ps = conn.prepareStatement(
        "Select c.kdo_id, c.id, c.colName " +
          "  FROM Exp_s_Norms t, Kdo_Choosens c " +
          "  Where t.parentType = 'detail' " +
          "    And t.service = c.id " +
          "  Group By c.kdo_id, c.id, c.colName "
      );
      ps.execute();
      rs = ps.getResultSet();
      HashMap<String, Double> services = new HashMap<>();
      while (rs.next()) {
        String table = "";
        switch (rs.getInt("kdo_id")) {
          case 153: table = "lv_bios"; break;
          case 56: table = "lv_couls"; break;
          case 120: table = "lv_garmons"; break;
          case 121: table = "lv_torchs"; break;
        }
        ps = conn.prepareStatement(
          "Select t.product_id id, p.id measure_id, sum(t.Rasxod) summ " +
            "  FROM Exp_s_Norms t, Exp_s_Products p, kdo_choosens c, lv_plans d, " + table + " f" +
            "  Where c.id = " + rs.getInt("id") +
            "    And d.kdo_id = c.kdo_id" +
            "    And f.c" + rs.getString("colName") + " = 1 " +
            "    And f.planid = d.id " +
            "    And t.service = c.id " +
            "    And t.parentType = 'detail' " +
            "    And p.id = t.product_id " +
            "    And d.Result_Date Between ? And ? " +
            "    And d.Done_Flag = 'Y' " +
            "    And d.kdo_id = " + rs.getInt("kdo_id") +
            "  Group By t.product_id, p.id "
        );
        ps.setString(1, Util.dateDBBegin(startDate));
        ps.setString(2, Util.dateDBEnd(endDate));
        ps.execute();
        rc = ps.getResultSet();
        while (rc.next()) {
          String key = rc.getInt("id") + "_" + rc.getInt("measure_id");
          if(services.containsKey(key)) {
            services.put(key, services.get(key) + rc.getDouble("summ"));
          } else {
            services.put(key, rc.getDouble("summ"));
          }
        }
        DB.done(rc);
        DB.done(ps);
      }
      Set<String> keys = services.keySet();
      for(String key: keys) {
        ObjList obj = new ObjList();
        obj.setC1(key.substring(0, key.indexOf("_") - 1));
        obj.setC2(dExpProduct.get(Integer.parseInt(key.substring(0, key.indexOf("_")))).getName());
        obj.setC3(dExpMeasure.get(Integer.parseInt(key.substring(key.indexOf("_") + 1))).getName());
        obj.setC4(services.get(key).toString());
        list.add(obj);
        if(totals.containsKey(key))
          totals.put(key, totals.get(key) + services.get(key));
        else
          totals.put(key, services.get(key));
      }
      model.addAttribute("details", list);
      //endregion
      //region По всем
      list = new ArrayList<>();
      Set<String> totalKeys = totals.keySet();
      for(String key: totalKeys) {
        ObjList obj = new ObjList();
        obj.setC1(key.substring(0, key.indexOf("_") - 1));
        obj.setC2(dExpProduct.get(Integer.parseInt(key.substring(0, key.indexOf("_")))).getName());
        obj.setC3(dExpMeasure.get(Integer.parseInt(key.substring(key.indexOf("_") + 1))).getName());
        obj.setC4(totals.get(key).toString());
        list.add(obj);
      }
      model.addAttribute("totals", list);
      //endregion
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rc);
      DB.done(rs);
      DB.done(ps);
      DB.done(conn);
    }
    return "/med/exp/stat/index";
  }

  @RequestMapping("dicts.s")
  protected String dicts(HttpServletRequest request, Model model) {
    session = SessionUtil.getUser(request);
    session.setCurUrl("/exp/dicts.s");
    if(!session.getCurSubUrl().contains("/exp/dict/"))
      session.setCurSubUrl("/exp/dict/categories.s");
    //
    Util.makeMsg(request, model);
    return "/med/exp/dict/tabs";
  }

  @RequestMapping("dict/categories.s")
  protected String dictCategories(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/exp/dicts.s");
    session.setCurSubUrl("/exp/dict/categories.s");
    //
    model.addAttribute("list", dExpCategory.getAll());
    return "/med/exp/dict/category/index";
  }

  @RequestMapping("dict/products.s")
  protected String dictProducts(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/exp/dicts.s");
    session.setCurSubUrl("/exp/dict/products.s");
    //
    model.addAttribute("list", dExpProduct.getAll());
    model.addAttribute("categories", dExpCategory.getAll());
    model.addAttribute("measureTypes", dDict.getByTypeList("MEASURE_CATS"));
    return "/med/exp/dict/product/index";
  }

  @RequestMapping("dict/measures.s")
  protected String dictMeasure(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/exp/dicts.s");
    session.setCurSubUrl("/exp/dict/measures.s");
    //
    model.addAttribute("cats", dDict.getByTypeList("MEASURE_CATS"));
    model.addAttribute("list", dExpMeasure.getAll());
    return "/med/exp/dict/measure/index";
  }

  @RequestMapping("dict/services.s")
  protected String dictServices(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/exp/dicts.s");
    session.setCurSubUrl("/exp/dict/services.s");
    //
    List<ObjList> list = new ArrayList<>();
    List<AmbServices> ambs = dAmbService.getList("From AmbServices Where state = 'A'");
    for(AmbServices amb: ambs) {
      ObjList d = new ObjList();
      d.setC1(amb.getId().toString());
      d.setC2(amb.getGroup().getName());
      d.setC3(amb.getName());
      d.setC4("Амбулатория");
      d.setC5("amb");
      list.add(d);
    }
    List<Kdos> kdos = dKdo.getList("From Kdos Where state = 'A' And id not in (13, 56, 120, 121, 153) Order By kdoType.id");
    for(Kdos kdo: kdos) {
      ObjList d = new ObjList();
      d.setC1(kdo.getId().toString());
      d.setC2(kdo.getKdoType().getName());
      d.setC3(kdo.getName());
      d.setC4("Стационар");
      d.setC5("stat");
      list.add(d);
    }
    List<KdoChoosens> details = dKdoChoosen.getList("From KdoChoosens Where kdo.state = 'A'");
    for(KdoChoosens detail: details) {
      ObjList d = new ObjList();
      d.setC1(detail.getId().toString());
      d.setC2(detail.getKdo().getName());
      d.setC3(detail.getName());
      d.setC4("Стационар детали");
      d.setC5("detail");
      list.add(d);
    }
    model.addAttribute("list", list);
    return "/med/exp/dict/services/index";
  }

  @RequestMapping("dict/service.s")
  protected String dictService(HttpServletRequest req, Model model) {
    String type = Util.get(req, "type");
    int id = Util.getInt(req, "id");
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/exp/dicts.s");
    session.setCurSubUrl("/exp/dict/service.s?type=" + type + "&id=" + id);
    ObjList service = new ObjList();
    service.setC4(type);
    switch (type) {
      case "amb": {
        AmbServices sr = dAmbService.get(id);
        service.setC1(sr.getId().toString());
        service.setC2(sr.getName());
        service.setC3("Амбулаторная услуга");
        break;
      }
      case "stat": {
        Kdos sr = dKdo.get(id);
        service.setC1(sr.getId().toString());
        service.setC2(sr.getName());
        service.setC3("Статционарная услуга");
        break;
      }
      case "detail": {
        KdoChoosens sr = dKdoChoosen.get(id);
        service.setC1(sr.getId().toString());
        service.setC2(sr.getName());
        service.setC3("Стационар детали");
        break;
      }
    }
    List<ExpNorms> norms = dExpNorm.getList("From ExpNorms Where parentType = '" + type + "' And service = " + id);
    //
    model.addAttribute("norms", norms);
    model.addAttribute("service", service);
    //
    model.addAttribute("measures", dExpMeasure.getAll());
    model.addAttribute("products", dExpProduct.getList("From ExpProducts Where state = 'A'"));
    //
    return "/med/exp/dict/services/edit";
  }

  @RequestMapping(value = "dict/service/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String normSave(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      Integer service = Util.getInt(req, "id");
      String[] ids = req.getParameterValues("norm_id");
      String[] products = req.getParameterValues("product");
      String[] rasxods = req.getParameterValues("rasxod");
      String[] measures = req.getParameterValues("measure");
      int i=0;
      if(ids == null) {
        throw new Exception("Расходы услуги нельзя сохранить пустым");
      }
      for (String id: ids) {
        ExpNorms norm = id.equals("0") ? new ExpNorms() : dExpNorm.get(Integer.parseInt(id));
        norm.setParentType(Util.get(req, "type"));
        norm.setService(service);
        norm.setProduct(dExpProduct.get(Integer.parseInt(products[i])));
        norm.setMeasure(dExpMeasure.get(Integer.parseInt(measures[i])));
        norm.setRasxod(Double.parseDouble(rasxods[i]));
        dExpNorm.save(norm);
        i++;
      }

      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "dict/delete.s", method = RequestMethod.POST)
  @ResponseBody
  protected String deleteDict(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      if(Util.get(req, "code").equals("category")) dExpCategory.delete(Util.getInt(req, "id"));
      if(Util.get(req, "code").equals("product")) dExpProduct.delete(Util.getInt(req, "id"));
      if(Util.get(req, "code").equals("norm")) dExpNorm.delete(Util.getInt(req, "id"));
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "dict/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String save(HttpServletRequest req) throws JSONException {
    Session session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      if(Util.get(req, "code").equals("category")) {
        ExpCategories obj = Util.isNull(req, "id") ? new ExpCategories() : dExpCategory.get(Util.getInt(req, "id"));
        obj.setName(Util.get(req, "name"));
        obj.setState(Util.isNull(req, "state") ? "P" : "A");
        if (Util.isNull(req, "id")) {
          obj.setCrBy(session.getUserId());
          obj.setCrOn(new Date());
        }
        try {
          dExpCategory.save(obj);
        } catch (PersistenceException e) {
          throw new Exception("Данное название уже существует в списке");
        }
      }
      if(Util.get(req, "code").equals("product")) {
        ExpProducts obj = Util.isNull(req, "id") ? new ExpProducts() : dExpProduct.get(Util.getInt(req, "id"));
        obj.setName(Util.get(req, "name"));
        obj.setCategory(dExpCategory.get(Util.getInt(req, "category")));
        obj.setMeasureType(dDict.get(Util.getInt(req, "measureType")));
        obj.setState(Util.isNull(req, "state") ? "P" : "A");
        if (Util.isNull(req, "id")) {
          obj.setCrBy(session.getUserId());
          obj.setCrOn(new Date());
        }
        dExpProduct.save(obj);
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "dict/get.s", method = RequestMethod.POST)
  @ResponseBody
  protected String getDict(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      if(Util.get(req, "code").equals("category")) {
        ExpCategories obj = dExpCategory.get(Util.getInt(req, "id"));
        json.put("id", obj.getId());
        json.put("name", obj.getName());
        json.put("state", obj.getState());
      }
      if(Util.get(req, "code").equals("product")) {
        ExpProducts obj = dExpProduct.get(Util.getInt(req, "id"));
        json.put("id", obj.getId());
        json.put("category", obj.getCategory().getId());
        json.put("measureType", obj.getMeasureType() != null ? obj.getMeasureType().getId() : 0);
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


}
