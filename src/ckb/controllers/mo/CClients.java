package ckb.controllers.mo;

import ckb.dao.admin.country.DCountry;
import ckb.dao.admin.forms.opts.DOpt;
import ckb.dao.admin.region.DRegion;
import ckb.dao.admin.users.DUser;
import ckb.dao.med.amb.DAmbPatient;
import ckb.dao.med.client.DClient;
import ckb.dao.med.patient.DPatient;
import ckb.domains.admin.Clients;
import ckb.domains.med.amb.AmbPatients;
import ckb.domains.med.patient.Patients;
import ckb.grid.ClientGrid;
import ckb.models.Client;
import ckb.services.admin.form.SForm;
import ckb.services.med.client.SClient;
import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.Util;
import ckb.utils.tg.TgClientBot;
import ckb.utils.tg.TgInvite;
import ckb.utils.tg.TgPatientBot;
import org.codehaus.jettison.json.JSONArray;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value = "/clients/")
public class CClients {

  @Autowired private DClient dClient;
  @Autowired private SClient sClient;
  @Autowired private DCountry dCountry;
  @Autowired private DRegion dRegion;
  @Autowired private DAmbPatient dAmbPatient;
  @Autowired private SForm sForm;
  @Autowired private DPatient dPatient;
  @Autowired private DOpt dOpt;
  @Autowired private DUser dUser;

  @RequestMapping("search_by_letters.s")
  @ResponseBody
  protected String search_by_letters(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      String word = Util.nvl(req, "word").replace("'", "''");
      JSONArray arr = new JSONArray();
      List<Clients> clients = dClient.list("From Clients Where upper(surname) like '%" + word + "%' Or upper(name) like '%" + word + "%'");
      for(Clients client: clients) {
        JSONObject obj = new JSONObject();
        obj.put("id", client.getId());
        obj.put("name", client.getFio());
        obj.put("birthdate", Util.dateToString(client.getBirthdate()));
        obj.put("sex", client.getSex() == null ? "" : client.getSex().getName());
        obj.put("passport", client.getDocInfo());
        obj.put("country", client.getCountry() == null ? "" : client.getCountry().getName());
        obj.put("region", client.getRegion() == null ? "" : client.getRegion().getName());
        obj.put("address", client.getAddress());
        obj.put("tel", client.getTel());
        arr.put(obj);
      }
      json.put("clients", arr);
      json.put("success", true);
    } catch (Exception e) {
      return Util.err(json, e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("list.s")
  protected String patients(HttpServletRequest req, Model model) {
    try {
      Session session = SessionUtil.getUser(req);
      session.setCurUrl("/clients/list.s");
      String flag = Util.get(req, "flag", "");
      HashMap<String, String> filters = session.getFilters();
      if(flag.isEmpty() && filters.containsKey("client_flag"))
        flag = filters.get("client_flag");
      if(flag.equals("0")) flag = "";
      filters.put("client_flag", flag);
      session.setFilters(filters);
      ClientGrid grid = SessionUtil.getClientGrid(req, "CLINIC_CLIENTS");
      grid.setGrid(req);
      grid.setSql("From Crm_Clients t" + (flag.isEmpty() ? "" : flag.equals("UNDONE") ? " Where flag is null" : " Where flag = 'DONE'"));
      grid.setOrder("Order By t.id Desc");
      grid.setRowCount(sClient.getCount(grid.select()));
      grid.initPages();
      grid.setStartPos((grid.getPage() - 1) * grid.getPageSize() + 1);
      model.addAttribute("grid", grid);
      model.addAttribute("rows", sClient.rows(grid, session));
      model.addAttribute("view_url", "/clients/view.s?id=");
      SessionUtil.addSession(req, "CLINIC_CLIENTS", grid);
      model.addAttribute("flag", flag);
    } catch (Exception e) {
      e.printStackTrace();
    }
    return "/mo/client/clients";
  }

  @RequestMapping(value = "view.s")
  protected String view_client(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    int id = Util.getInt(req, "id");
    session.setCurUrl("/clients/view.s?id=" + id);
    Clients client = dClient.get(Util.getInt(req, "id"));
    model.addAttribute("client", client);
    model.addAttribute("counteries", dCountry.getCounteries());
    model.addAttribute("regions", dRegion.getList("From Regions Order By ord, name"));
    sForm.setSelectOptionModel(model, 1, "sex");
    model.addAttribute("ambs", dAmbPatient.list("From AmbPatients Where client.id = " + id + " Order By id Desc"));
    model.addAttribute("stats", dPatient.list("From Patients Where client.id = " + id + " Order By id Desc"));
    List<Clients> rows = dClient.dublicates(client);
    List<Client> clients = new ArrayList<>();
    for(Clients row: rows) {
      Client c = new Client();
      c.setFio(row.getFio());
      c.setId(row.getId());
      c.setAmbCount(dAmbPatient.getCount("From AmbPatients Where client.id = " + row.getId()));
      c.setStatCount(dPatient.getCount("From Patients Where client.id = " + row.getId()));
      clients.add(c);
    }
    model.addAttribute("dublicates", clients);
    // Telegram: подключён ли клиент к боту пациентов (по ссылке от регистратуры)
    if (TgPatientBot.isEnabled()) {
      try {
        model.addAttribute("tg", TgClientBot.status(id, 0));
        model.addAttribute("tgInvite", TgInvite.isEnabled());
        model.addAttribute("tgPhone", TgInvite.phone(client.getTel()));
      } catch (Exception e) {
        e.printStackTrace();
      }
    }
    return "/mo/client/view";
  }

  // Telegram клиента для карточки визита: зарегистрирован ли клиент в боте с номером из карточки
  @RequestMapping(value = "tg/status.s", method = RequestMethod.POST)
  @ResponseBody
  protected String tgStatus(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      json.put("enabled", TgPatientBot.isEnabled());
      json.put("invite", TgInvite.isEnabled());
      if (TgPatientBot.isEnabled()) {
        Map<String, String> st = TgClientBot.status(Util.getInt(req, "id"), Util.getInt(req, "amb", 0));
        json.put("linked", "Y".equals(st.get("linked")));
        json.put("noPhone", "Y".equals(st.get("noPhone")));
        json.put("phone", Util.nvl(st.get("phone")));
        json.put("date", Util.nvl(st.get("linkedDate")));
      }
      json.put("success", true);
    } catch (Exception e) {
      e.printStackTrace();
      return Util.err(json, e.getMessage());
    }
    return json.toString();
  }


  // Telegram: уникальная ссылка на бот клиенту с номера клиники (tg-sender)
  @RequestMapping(value = "tg/invite.s", method = RequestMethod.POST)
  @ResponseBody
  protected String tgInvite(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      Clients c = dClient.get(Util.getInt(req, "id"));
      String phone = TgInvite.phone(c.getTel());
      if (phone == null) return Util.err(json, "В карточке клиента неполный номер телефона. Исправьте номер и сохраните карточку.");
      String name = (Util.nvl(c.getName()) + " " + Util.nvl(c.getMiddlename())).trim();
      String text = "Здравствуйте" + (name.isEmpty() ? "" : ", " + name) + "!\n\n" +
        "Это клиника «Фарход Мадад Шифо». Подключитесь к помощнику клиники в Telegram: в нём можно скачать " +
        "результаты анализов и обследований в PDF, а регистратура сможет присылать вам результаты, как только они будут готовы.\n\n" +
        "Откройте ссылку, нажмите «Start» и отправьте свой номер телефона:\n" + TgClientBot.link();
      JSONObject res = TgInvite.send(phone, name, text);
      if (!res.optBoolean("ok")) return Util.err(json, TgInvite.errorText(res.optString("error"), res.optString("detail")));
      json.put("success", true);
      json.put("msg", "Ссылка отправлена на +" + phone + ".");
    } catch (java.net.ConnectException e) {
      return Util.err(json, "Программа отправки (tg-sender) не запущена на сервере.");
    } catch (Exception e) {
      e.printStackTrace();
      return Util.err(json, "Ошибка: " + e.getMessage());
    }
    return json.toString();
  }

  // Telegram: PDF результатов визита клиенту через бот (клиент должен быть подключён)
  @RequestMapping(value = "tg/result.s", method = RequestMethod.POST)
  @ResponseBody
  protected String tgResult(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      String err = TgClientBot.sendResultFromRegistry(Util.getInt(req, "amb", 0));
      if (err != null) return Util.err(json, err);
      json.put("success", true);
      json.put("msg", "Результаты отправлены клиенту в Telegram.");
    } catch (Exception e) {
      e.printStackTrace();
      return Util.err(json, "Ошибка: " + e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("combine.s")
  @ResponseBody
  protected String combine_clients(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      int old = Util.getInt(req, "old");
      int cur = Util.getInt(req, "cur");
      List<AmbPatients> ambs = dAmbPatient.list("From AmbPatients Where client.id = " + old);
      if(!ambs.isEmpty()) {
        for(AmbPatients amb: ambs) {
          amb.setClient(dClient.get(cur));
          dAmbPatient.save(amb);
        }
      }
      List<Patients> stats = dPatient.list("From Patients Where client.id = " + old);
      if(!stats.isEmpty()) {
        for(Patients stat: stats) {
          stat.setClient(dClient.get(cur));
          dPatient.save(stat);
        }
      }
      dClient.delete(old);
      json.put("success", true);
    } catch (Exception e) {
      return Util.err(json, e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("del.s")
  @ResponseBody
  protected String del_clients(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      dClient.delete(Util.getInt(req, "id"));
      json.put("success", true);
    } catch (Exception e) {
      return Util.err(json, e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String save_client(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    Session session = SessionUtil.getUser(req);
    try {
      Clients client = Util.isNull(req, "cl_id") ? new Clients() : dClient.get(Util.getInt(req, "cl_id"));
      client.setSurname(Util.fioPart(Util.get(req, "cl_surname", "").toUpperCase()));
      client.setName(Util.fioPart(Util.get(req, "cl_name", "").toUpperCase()));
      if(client.getSurname().isEmpty() || client.getName().isEmpty() || Util.isNull(req, "cl_sex_id") || Util.isNull(req, "cl_birthdate") || Util.isNull(req, "cl_country_id"))
        return Util.err(json, "Заполните все обязательные поля");
      client.setMiddlename(Util.fioPart(Util.get(req, "cl_middlename", "").toUpperCase()));
      client.setBirthdate(Util.getDate(req, "cl_birthdate"));
      client.setBirthyear(1900 + client.getBirthdate().getYear());
      client.setSex(dOpt.get(Util.getInt(req, "cl_sex_id")));
      client.setDocSeria(Util.get(req, "cl_doc_seria").toUpperCase());
      client.setDocNum(Util.get(req, "cl_doc_num"));
      client.setDocInfo(Util.get(req, "cl_doc_info"));
      client.setTel(ckb.utils.Phone.format(Util.get(req, "cl_tel")));
      client.setCountry(dCountry.get(Util.getInt(req, "cl_country_id")));
      if(client.getCountry().getId() != 199) {
        client.setRegion(null);
      } else {
        if (Util.isNotNull(req, "cl_region_id")) client.setRegion(dRegion.get(Util.getInt(req, "cl_region_id")));
      }
      client.setAddress(Util.get(req, "cl_address"));
      if(Util.isNull(req,"cl_id")) {
        client.setCrBy(dUser.get(session.getUserId()));
        client.setCrOn(new Date());
      }
      if(dClient.checkDublicate(client) > 0) {
        json.put("success", false);
        json.put("msg", "В реестре клиентов имеется идентичная запись");
        json.put("dublicate", true);
        return json.toString();
      }
      dClient.saveAndReturn(client);
      if(Util.isNotNull(req, "stat_id")) {
        Patients p = dPatient.get(Util.getInt(req, "stat_id"));
        p.setClient(client);
        dPatient.save(p);
      }
      if(Util.isNotNull(req, "amb_id")) {
        AmbPatients p = dAmbPatient.get(Util.getInt(req, "amb_id"));
        p.setClient(client);
        dAmbPatient.save(p);
      }
      //
      json.put("fio", client.getFio());
      json.put("id", client.getId());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("get.s")
  @ResponseBody
  protected String get_client_info(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      Clients c = dClient.get(Util.getInt(req, "id"));
      json.put("id", c.getId());
      json.put("fio", c.getFio());
      json.put("surname", c.getSurname());
      json.put("name", c.getName());
      json.put("middlename", c.getMiddlename());
      json.put("sex_id", c.getSex() != null ? c.getSex().getId() : null);
      json.put("sex_name", c.getSex() != null ? c.getSex().getName() : null);
      json.put("birthdate", Util.dateToString(c.getBirthdate()));
      json.put("doc_seria", c.getDocSeria());
      json.put("doc_num", c.getDocNum());
      json.put("doc_info", c.getDocInfo());
      json.put("passport", c.getPassport());
      json.put("country_id", c.getCountry() == null ? null : c.getCountry().getId());
      json.put("country_name", c.getCountry() == null ? null : c.getCountry().getName());
      json.put("region_id", c.getRegion() == null ? null : c.getRegion().getId());
      json.put("region_name", c.getRegion() == null ? null : c.getRegion().getName());
      json.put("tel", c.getTel());
      json.put("address", c.getAddress());
      json.put("success", true);
    } catch (Exception e) {
      return Util.err(json, e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("set/flag.s")
  @ResponseBody
  protected String set_flag(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      Clients c = dClient.get(Util.getInt(req, "id"));
      c.setFlag("DONE");
      dClient.save(c);
      json.put("success", true);
    } catch (Exception e) {
      return Util.err(json, e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("get/rows.s")
  @ResponseBody
  protected String set_client_rows(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      String[] rps = req.getParameterValues("code");
      if(rps == null || rps.length == 0) return Util.err(json, "Выберите поля для проверки");
      Clients c = dClient.get(Util.getInt(req, "id"));
      String where = "";
      for(String rp : rps) {
        if(rp.equals("surname")) where += "upper(surname) = upper('" + hq(c.getSurname()) + "') And ";
        if(rp.equals("name")) where += "upper(name) = upper('" + hq(c.getName()) + "') And ";
        if(rp.equals("middlename")) where += "upper(middlename) = upper('" + hq(c.getMiddlename()) + "') And ";
        if(rp.equals("birth")) where += "birthyear = " + c.getBirthyear() + " And ";
      }
      where = where.substring(0, where.length() - 4);
      List<Patients> stats = dPatient.list("From Patients Where client is null And " + where + " Order By surname, name, middlename");
      List<AmbPatients> ambs = dAmbPatient.list("From AmbPatients Where client is null And " + where + " Order By surname, name, middlename");
      JSONArray rows = new JSONArray();
      for(Patients p : stats) {
        JSONObject d = new JSONObject();
        d.put("id", p.getId());
        d.put("type", "stat");
        d.put("fio", p.getFio());
        d.put("birth", p.getBirthyear() == null ? Util.dateToString(p.getBirthday()) : p.getBirthyear());
        d.put("sex", p.getSex() == null ? "" : p.getSex().getName());
        d.put("doc", p.getPassportInfo());
        d.put("state", p.getState().equals("ARCH") ? "Архив" : "Текущий");
        rows.put(d);
      }
      for(AmbPatients p : ambs) {
        JSONObject d = new JSONObject();
        d.put("id", p.getId());
        d.put("type", "amb");
        d.put("fio", p.getFio());
        d.put("birth", p.getBirthyear() == null ? Util.dateToString(p.getBirthday()) : p.getBirthyear());
        d.put("sex", p.getSex() == null ? "" : p.getSex().getName());
        d.put("doc", p.getPassportInfo());
        d.put("state", p.getState().equals("ARCH") ? "Архив" : "Текущий");
        rows.put(d);
      }
      json.put("patients", rows);
      json.put("success", true);
    } catch (Exception e) {
      return Util.err(json, e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("set/patient.s")
  @ResponseBody
  protected String set_patient(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      Clients c = dClient.get(Util.getInt(req, "id"));
      if(Util.get(req, "type").equals("amb")) {
        AmbPatients p = dAmbPatient.get(Util.getInt(req, "patient"));
        if(p.getSex() == null)
          p.setSex(c.getSex());
        p.setClient(c);
        dAmbPatient.save(p);
      } else {
        Patients p = dPatient.get(Util.getInt(req, "patient"));
        p.setClient(c);
        if(p.getSex() == null)
          p.setSex(c.getSex());
        dPatient.save(p);
      }
      json.put("success", true);
      return json.toString();
    } catch (Exception e) {
      return Util.err(json, e.getMessage());
    }
  }

  @RequestMapping("update/patient.s")
  @ResponseBody
  protected String update_patient(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      Clients c = dClient.get(Util.getInt(req, "id"));
      if(Util.get(req, "type").equals("amb")) {
        AmbPatients p = dAmbPatient.get(Util.getInt(req, "patient"));
        p.setSurname(c.getSurname());
        p.setName(c.getName());
        p.setMiddlename(c.getMiddlename());
        p.setBirthyear(c.getBirthyear());
        p.setBirthday(c.getBirthdate());
        p.setSex(c.getSex());
        p.setAddress(c.getAddress());
        p.setCounteryId(c.getCountry().getId());
        p.setRegionId(c.getRegion() != null ? c.getRegion().getId() : null);
        dAmbPatient.save(p);
      } else {
        Patients p = dPatient.get(Util.getInt(req, "patient"));
        p.setSurname(c.getSurname());
        p.setName(c.getName());
        p.setMiddlename(c.getMiddlename());
        p.setBirthyear(c.getBirthyear());
        p.setBirthday(c.getBirthdate());
        p.setSex(c.getSex());
        p.setAddress(c.getAddress());
        p.setCounteryId(c.getCountry().getId());
        p.setRegionId(c.getRegion() != null ? c.getRegion().getId() : null);
        dPatient.save(p);
      }
      json.put("success", true);
      return json.toString();
    } catch (Exception e) {
      return Util.err(json, e.getMessage());
    }
  }

  @RequestMapping("remove/patient.s")
  @ResponseBody
  protected String remove_patient(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      if(Util.get(req, "type").equals("amb")) {
        AmbPatients p = dAmbPatient.get(Util.getInt(req, "patient"));
        p.setClient(null);
        dAmbPatient.save(p);
      } else {
        Patients p = dPatient.get(Util.getInt(req, "patient"));
        p.setClient(null);
        dPatient.save(p);
      }
      json.put("success", true);
      return json.toString();
    } catch (Exception e) {
      return Util.err(json, e.getMessage());
    }
  }

  /** Строка для HQL в кавычках: апостроф удваивается */
  private static String hq(String s) {
    return s == null ? "" : s.replace("'", "''");
  }

  @RequestMapping(value = "exists_list.s")
  protected String exists_list(HttpServletRequest req, Model model) {
    List<Clients> clients;
    if(Util.isNotNull(req, "stat_id")) {
      Patients pat = dPatient.get(Util.getInt(req, "stat_id"));
      clients = dClient.list("From Clients Where upper(surname) = '" + hq(pat.getSurname()).toUpperCase() + "' And upper(name) = '" + hq(pat.getName()).toUpperCase() + "'");
    } else {
      AmbPatients pat = dAmbPatient.get(Util.getInt(req, "amb_id"));
      clients = dClient.list("From Clients Where upper(surname) = '" + hq(pat.getSurname()).toUpperCase() + "' And upper(name) = '" + hq(pat.getName()).toUpperCase() + "'");
    }
    model.addAttribute("clients", clients);
    return "/mo/client/list";
  }
}
