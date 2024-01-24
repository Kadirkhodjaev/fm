package ckb.controllers.med;


import ckb.dao.admin.countery.DCountry;
import ckb.dao.admin.forms.fields.DFormField;
import ckb.dao.admin.forms.opts.DOpt;
import ckb.dao.admin.region.DRegion;
import ckb.dao.admin.users.DUser;
import ckb.dao.med.amb.DAmbPatients;
import ckb.dao.med.client.DClient;
import ckb.domains.admin.Clients;
import ckb.models.Grid;
import ckb.services.admin.form.SForm;
import ckb.services.med.client.SClient;
import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.Req;
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
import java.util.Date;

@Controller
@RequestMapping("/client/")
public class CClient {

  private Session session = null;

  @Autowired private DClient dClient;
  @Autowired private DOpt dOpt;
  @Autowired private DCountry dCountry;
  @Autowired private DRegion dRegion;
  @Autowired private DUser dUser;
  @Autowired private SClient sClient;
  @Autowired private DFormField dFormField;
  @Autowired private SForm sForm;
  @Autowired private DAmbPatients dAmbPatient;

  @RequestMapping("list.s")
  protected String main(HttpServletRequest req, Model model) {
    try {
      session = SessionUtil.getUser(req);
      session.setCurUrl("/client/list.s");
      session.setArchive(false);
      session.setCurPat(0);
      String sql = " From Crm_Clients t";
      Grid grid = SessionUtil.getGrid(req, "clientGrid");
      grid.setPageSize(200);
      //region SORTIROVKA
      if (Req.get(req, "action").equals("sort")) {
        grid.setPage(1);
        if (grid.getOrderCol().equals(Req.get(req, "column"))) {
          grid.setOrderType(grid.getOrderType().equals("") ? "asc" : grid.getOrderType().equals("asc") ? "desc" : grid.getOrderType().equals("desc") ? "" : grid.getOrderType());
        } else {
          grid.setOrderType("asc");
        }
        grid.setOrderCol(Req.get(req, "column"));
        grid.setOrderColId("th" + (Req.get(req, "colId").equals("") ? Req.get(req, "column") : Req.get(req, "colId")));
      } else if (Req.get(req, "action").equals("") && session.getRoleId() != 5) {
        grid.init();
      }
      if (!Req.isNull(req,"filter") || !Util.nvl(session.getFilterFio()).equals("")) {
        session.setFiltered(true);
        if (!Req.isNull(req, "filter"))
          session.setFilterFio(Req.get(req, "filterInput"));
        if (session.getFilterFio().equals(""))
          session.setFiltered(false);
        sql += " And ( " +
          "Upper(t.surname) like Upper('%" + session.getFilterFio() + "%') Or " +
          "Upper(t.name) Like Upper('%" + session.getFilterFio() + "%') Or " +
          "Upper(t.middlename) Like Upper('%" + session.getFilterFio() + "%') " +
          ")";
      }
      if(session.getRoleId() == 21) {
        sql += " And t.id in (Select c.client_id From Ss_Contract_Clients c)";
      }
      if (!grid.getOrderType().equals(""))
        sql += " Order By " + grid.getOrderCol() + " " + grid.getOrderType();
      else
        sql += " Order By t.surname";
      model.addAttribute("htmlClass", grid.getOrderType().equals("") ? "sorting" : "sorting_" + grid.getOrderType());
      //endregion
      model.addAttribute("newFieldId", grid.getOrderColId());
      if (Req.get(req, "action").equals("page"))
        grid.setPage(Req.getInt(req, "page"));
      if (Req.get(req, "action").equals("prev"))
        grid.setPage(grid.getPage() - 1);
      if (Req.get(req, "action").equals("begin"))
        grid.setPage(1);
      if (Req.get(req, "action").equals("next"))
        grid.setPage(grid.getPage() + 1);
      if (Req.get(req, "action").equals("end"))
        grid.setPage(grid.getMaxPage());
      grid.setSql(sql);
      grid.setRowCount(sClient.getCount(sql));
      long tail = grid.getRowCount() % grid.getPageSize();
      grid.setMaxPage(tail == 0 ? Math.round(grid.getRowCount() / grid.getPageSize()) : Math.round(grid.getRowCount() / grid.getPageSize()) + 1);
      grid.setStartPos((grid.getPage() - 1) * grid.getPageSize() + 1);
      if (grid.getStartPos() == 1)
        grid.setEndPos(grid.getRowCount() < grid.getPageSize() ? Integer.parseInt("" + grid.getRowCount()) : grid.getPageSize());
      else
        grid.setEndPos(grid.getStartPos() + grid.getPageSize() < grid.getRowCount() ? grid.getStartPos() + grid.getPageSize() - 1 : Integer.valueOf("" + grid.getRowCount()));
      if (grid.getEndPos() == 0)
        grid.setStartPos(0);
      SessionUtil.addSession(req, "clientGrid", grid);
      model.addAttribute("list", sClient.getGridList(grid, session));
      model.addAttribute("roleId", session.getRoleId());
      model.addAttribute("curUrl", session.getCurUrl());
      Util.makeMsg(req, model);
      return "med/client/index";
    } catch (Exception e) {
      e.printStackTrace();
      return null;
    }
  }

  @RequestMapping(value = "edit.s")
  protected String editClient(HttpServletRequest req, Model model) {
    session = SessionUtil.getUser(req);
    session.setCurUrl("/client/edit.s?id=" + Util.get(req, "id"));
    model.addAttribute("client", dClient.get(Util.getInt(req, "id")));
    model.addAttribute("counteries", dCountry.getCounteries());
    model.addAttribute("regions", dRegion.getList("From Regions Order By ord, name"));
    sForm.setSelectOptionModel(model, 1, "sex");
    model.addAttribute("cur_ambs", dAmbPatient.currentsByClient(Util.getInt(req, "id")));
    model.addAttribute("arch_ambs", dAmbPatient.archiveByClient(Util.getInt(req, "id")));
    return "/med/client/edit";
  }

  @RequestMapping(value = "save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String addClient(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      Clients client = Util.isNull(req, "id") ? new Clients() : dClient.get(Util.getInt(req, "id"));
      client.setSurname(Util.get(req, "surname", "").toUpperCase());
      client.setName(Util.get(req, "name", "").toUpperCase());
      if(client.getSurname() == null || client.getName() == null || client.getSurname().equals("") || client.getName().equals("")) {
        json.put("success", false);
        json.put("msg", "Заполните все обязательные поля");
        return json.toString();
      }
      client.setMiddlename(Util.get(req, "middlename", "").toUpperCase());
      if(Util.isNotNull(req, "birthdate")) {
        client.setBirthdate(Util.getDate(req, "birthdate"));
        client.setBirthyear(1900 + client.getBirthdate().getYear());
      }
      if(Util.isNotNull(req, "sex_id"))
        client.setSex(dOpt.get(Util.getInt(req, "sex_id")));
      client.setDocSeria(Util.get(req, "doc_seria"));
      client.setDocNum(Util.get(req, "doc_num"));
      client.setDocInfo(Util.get(req, "doc_info"));
      client.setTel(Util.get(req, "tel"));
      if(Util.isNotNull(req, "country_id"))
        client.setCountry(dCountry.get(Util.getInt(req, "country_id")));
      if(Util.isNotNull(req, "region_id"))
        client.setRegion(dRegion.get(Util.getInt(req, "region_id")));
      client.setAddress(Util.get(req, "address"));
      if(Util.isNull(req,"id")) {
        client.setCrBy(dUser.get(session.getUserId()));
        client.setCrOn(new Date());
      }
      dClient.saveAndReturn(client);
      //
      json.put("fio", client.getSurname() + " " + client.getName() + " " + client.getMiddlename());
      json.put("id", client.getId());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "get.s", method = RequestMethod.POST)
  @ResponseBody
  protected String getClient(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    session = SessionUtil.getUser(req);
    try {
      Clients c = dClient.get(Util.getInt(req, "id"));
      json.put("surname", c.getSurname());
      json.put("name", c.getName());
      json.put("middlename", c.getMiddlename());
      json.put("birthyear", c.getBirthyear());
      json.put("birthdate", Util.dateToString(c.getBirthdate()));
      json.put("sex", c.getSex() != null ? c.getSex().getName() : "");
      json.put("sex_id", c.getSex() != null ? c.getSex().getId() : "");
      json.put("doc_seria", c.getDocSeria());
      json.put("doc_num", c.getDocNum());
      json.put("doc_info", c.getDocInfo());
      json.put("tel", c.getTel());
      json.put("country", c.getCountry() != null ? c.getCountry().getName() : "");
      json.put("region", c.getRegion() != null ? c.getRegion().getName() : "");
      json.put("country_id", c.getCountry() != null ? c.getCountry().getId() : "");
      json.put("region_id", c.getRegion() != null ? c.getRegion().getId() : "");
      json.put("address", c.getAddress());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }
}
