package ckb.controllers.admin;

import ckb.dao.med.amb.DAmbService;
import ckb.dao.med.kdos.DKdos;
import ckb.dao.med.kdos.DSalePack;
import ckb.dao.med.kdos.DSalePackRow;
import ckb.domains.admin.Kdos;
import ckb.domains.admin.SalePackRows;
import ckb.domains.admin.SalePacks;
import ckb.domains.med.amb.AmbServices;
import ckb.models.Obj;
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
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/admin/pack")
public class CPack {

  @Autowired private DSalePack dSalePack;
  @Autowired private DSalePackRow dSalePackRow;
  @Autowired private DKdos dKdo;
  @Autowired private DAmbService dAmbService;

  @RequestMapping("/index.s")
  protected String packages(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/admin/pack/index.s");
    //
    model.addAttribute("ndsProc", Double.parseDouble(session.getParam("NDS_PROC")));
    model.addAttribute("rows", dSalePack.list("From SalePacks Order By id desc"));
    //
    return "admin/packages/index";
  }

  @RequestMapping("/info.s")
  protected String packageInfo(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/admin/pack/info.s?id=" + Util.getInt(req, "id"));
    //
    SalePacks obj = dSalePack.get(Util.getInt(req, "id"));
    double ndsProc = Double.parseDouble(session.getParam("NDS_PROC"));
    if(obj == null) {
      obj = new SalePacks();
      obj.setId(0);
      obj.setNdsProc(ndsProc);
    }
    model.addAttribute("kdos", dKdo.list("From Kdos t Where Not Exists (Select 1 From SalePackRows c Where c.doc.id =  " + Util.get(req, "id", "0") + " And c.service = t.id) And state = 'A' Order By name"));
    model.addAttribute("services", dAmbService.list("From AmbServices t Where Not Exists (Select 1 From SalePackRows c Where c.doc.id =  " + Util.get(req, "id", "0") + " And c.service = t.id) And state = 'A' Order By name"));
    model.addAttribute("obj", obj);
    List<SalePackRows> rows = dSalePackRow.list("From SalePackRows Where doc.id = " + Util.getInt(req, "id"));
    double sum = 0, realSum = 0;
    List<Obj> rws = new ArrayList<>();
    if(obj.getId() > 0) {
      for (SalePackRows row : rows) {
        Obj rw = new Obj();
        rw.setId(row.getId());
        AmbServices kdo = dAmbService.get(row.getService());
        rw.setName(kdo.getName());
        rw.setPrice(row.getPrice() != null ? row.getPrice() : kdo.getPrice());
        rw.setClaimCount(kdo.getPrice());
        rw.setDrugCount(row.getProc() == null ? 0 : row.getProc());
        realSum += kdo.getPrice() == null ? 0 : kdo.getPrice();
        sum += rw.getPrice() == null ? 0 : rw.getPrice();
        rws.add(rw);
      }
    }
    model.addAttribute("rows", rws);
    model.addAttribute("summ", sum);
    model.addAttribute("real_summ", realSum);
    model.addAttribute("ndsProc", ndsProc);
    //
    return "admin/packages/view";
  }

  @RequestMapping(value = "/info.s", method = RequestMethod.POST)
  @ResponseBody
  protected String packageSave(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      SalePacks pac = Util.nvl(req, "id", "0").equals("0") ? new SalePacks() : dSalePack.get(Util.getInt(req, "id"));
      pac.setName(Util.get(req, "name"));
      pac.setText(Util.get(req, "text"));
      pac.setAmbStat("AMB");
      pac.setPrice(dSalePackRow.getTotal(pac.getId()));
      pac.setStart(Util.getDate(req, "start"));
      pac.setEnd(Util.getDate(req, "end"));
      pac.setState(Util.isNull(req, "state") ? "P" : "A");
      if(pac.getName() == null || pac.getName().isEmpty()) {
        json.put("msg", "Не все поля заполнены корректно");
        json.put("success", false);
        return json.toString();
      }
      if(pac.getStart() == null) {
        pac.setStart(new Date());
      }
      dSalePack.saveAndReturn(pac);
      json.put("id", pac.getId());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/add.s", method = RequestMethod.POST)
  @ResponseBody
  protected String packageKdoAdd(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      SalePacks pac = dSalePack.get(Util.getInt(req, "id"));
      if(pac.getAmbStat().equals("STAT")) {
        Kdos kdo = dKdo.get(Util.getInt(req, "kdo"));
        SalePackRows row = new SalePackRows();
        row.setDoc(pac);
        row.setService(kdo.getId());
        row.setPrice(kdo.getPrice());
        dSalePackRow.saveAndReturn(row);
      } else {
        AmbServices kdo = dAmbService.get(Util.getInt(req, "kdo"));
        SalePackRows row = new SalePackRows();
        row.setDoc(pac);
        row.setService(kdo.getId());
        row.setPrice(kdo.getPrice());
        dSalePackRow.saveAndReturn(row);
      }
      pac.setPrice(dSalePackRow.getTotal(pac.getId()));
      dSalePack.save(pac);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/del.s", method = RequestMethod.POST)
  @ResponseBody
  protected String packageKdoDel(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      SalePackRows kdo = dSalePackRow.get(Util.getInt(req, "id"));
      SalePacks pac = kdo.getDoc();
      pac.setPrice(dSalePackRow.getTotal(pac.getId()) - kdo.getPrice());
      dSalePack.save(pac);
      dSalePackRow.delete(kdo.getId());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/price.s", method = RequestMethod.POST)
  @ResponseBody
  protected String packageKdoPrice(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      SalePackRows row = dSalePackRow.get(Util.getInt(req, "id"));
      row.setProc(Util.getDouble(req, "proc"));
      AmbServices kdo = dAmbService.get(row.getService());
      row.setPrice(kdo.getPrice() * (100 - row.getProc()) / 100);
      dSalePackRow.save(row);
      SalePacks pac = row.getDoc();
      pac.setPrice(dSalePackRow.getTotal(pac.getId()));
      dSalePack.save(pac);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }


}
