package ckb.controllers.med;

import ckb.dao.med.kdos.DKdos;
import ckb.dao.med.template.DDrugTemplate;
import ckb.dao.med.template.DTemplate;
import ckb.domains.admin.Kdos;
import ckb.domains.med.template.DrugTemplates;
import ckb.domains.med.template.Templates;
import ckb.session.Session;
import ckb.session.SessionUtil;
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

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

@Controller
@RequestMapping("/templates")
public class CTemplate {
  @Autowired DKdos dKdos;
  @Autowired private DTemplate dTemplate;
  @Autowired private DDrugTemplate dDrugTemplate;

  @RequestMapping("/index.s")
  protected String main(HttpServletRequest request, Model model){
    try {
      Session session = SessionUtil.getUser(request);
      session.setCurUrl("/templates/index.s");
      //
      model.addAttribute("kdos", dKdos.getUser999Kdos(session));
    } catch (Exception e) {
      return "redirect:/login.s";
    }
    //
    Util.makeMsg(request, model);
    return "/med/kdo/templates/index";
  }

  @RequestMapping("/edit.s")
  protected String edit(HttpServletRequest request, Model model){
    Integer id = Req.getInt(request, "id");
    try {
      Session session = SessionUtil.getUser(request);
      session.setCurUrl("/templates/edit.s?id=" + id);
    } catch (Exception e) {
      return "redirect:/login.s";
    }
    //
    model.addAttribute("kdo", dKdos.get(id));
    //
    Util.makeMsg(request, model);
    return "/med/kdo/templates/edit";
  }

  @RequestMapping(value = "/edit.s", method = RequestMethod.POST)
  protected String save(HttpServletRequest request, Model model){
    Integer id = Req.getInt(request, "id");
    //
    Kdos k = dKdos.get(id);
    k.setTemplate(Req.get(request, "template"));
    dKdos.save(k);
    //
    Util.makeMsg(request, model);
    return "redirect:/templates/edit.s?id=" + id;
  }

  @RequestMapping(value = "/lv/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String lvTempSave(HttpServletRequest req) throws JSONException {
    Session session = SessionUtil.getUser(req);
    JSONObject res = new JSONObject();
    String template = req.getParameter("template");
    String field = req.getParameter("field");
    if (field == null || !FIELD_CODE.matcher(field).matches()) {
      res.put("msg", "Не указано поле шаблона");
      return res.toString();
    }
    boolean exists = false;
    for (Templates t : userTemplates(session.getUserId(), field)) {
      if (template != null && template.equals(t.getTemplate())) {
        exists = true;
        break;
      }
    }
    if (!exists) {
      Templates temp = new Templates();
      temp.setField(field);
      temp.setName(req.getParameter("name"));
      temp.setTemplate(template);
      temp.setUserId(session.getUserId());
      dTemplate.save(temp);
      res.put("msg", "Данные успешно сохранены");
    } else {
      res.put("msg", "Такой шаблон уже сущестувует");
    }
    return res.toString();
  }


  @RequestMapping("/lv/get.s")
  protected String getLvTemplate(HttpServletRequest req, Model model){
    Session session = SessionUtil.getUser(req);
    model.addAttribute("isKdo", Util.isNull(req, "kdo"));
    model.addAttribute("id", req.getParameter("id"));
    model.addAttribute("templates", userTemplates(session.getUserId(), req.getParameter("field")));
    return "/med/template/index";
  }

  @RequestMapping(value = "/lv/drug/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String lvDrugTemplateSave(HttpServletRequest req) throws JSONException {
    Session session = SessionUtil.getUser(req);
    JSONObject res = new JSONObject();
    String name = req.getParameter("name");
    String cat = req.getParameter("cat");
    String goal = req.getParameter("goal");
    String doza = req.getParameter("doza");
    Long checker = dDrugTemplate.getCount("From DrugTemplates Where userId = " + session.getUserId() + " And name = '" + name.trim() + "' And doza = '" + doza.trim() + "'");
    if(checker == 0) {
      DrugTemplates temp = new DrugTemplates();
      temp.setUserId(session.getUserId());
      temp.setName(name.trim());
      temp.setCat(cat);
      temp.setGoal(Integer.parseInt(goal));
      temp.setDoza(doza.trim());
      dDrugTemplate.save(temp);
      res.put("msg", "Данные успешно сохранены");
    } else {
      res.put("msg", "Такой шаблон уже сущестувует");
    }
    return res.toString();
  }

  @RequestMapping(value = "/delete.s", method = RequestMethod.POST)
  @ResponseBody
  protected String delete(HttpServletRequest req) throws JSONException {
    Session session = SessionUtil.getUser(req);
    JSONObject res = new JSONObject();
    Long checker = dDrugTemplate.getCount("From Users Where Id = 1 And Password = '" + Util.md5(Util.get(req, "pas")) + "'");
    if(checker > 0) {
      dTemplate.delete(Util.getInt(req, "id"));
      res.put("msg", "Данные успешно удалены");
    } else {
      res.put("msg", "Код подтверждения не правильный");
    }
    return res.toString();
  }

  // ---------- templates of the attending doctor (JSON api for the template dialogs) ----------
  private static final Pattern FIELD_CODE = Pattern.compile("^[A-Za-z0-9_]{1,64}$");

  // templates of the user for a field; the field code is validated so it is safe to put into HQL
  private List<Templates> userTemplates(Integer userId, String field) {
    if (userId == null || field == null || !FIELD_CODE.matcher(field).matches())
      return new ArrayList<>();
    return dTemplate.getList("From Templates Where userId = " + userId + " And field = '" + field + "' Order By name");
  }

  private void writeJson(HttpServletResponse resp, JSONObject json) throws IOException {
    resp.setContentType("application/json;charset=UTF-8");
    resp.setCharacterEncoding("UTF-8");
    resp.getWriter().write(json.toString());
  }

  @RequestMapping("/lv/list.s")
  protected void lvList(HttpServletRequest req, HttpServletResponse resp) throws Exception {
    Session session = SessionUtil.getUser(req);
    JSONObject res = new JSONObject();
    JSONArray arr = new JSONArray();
    if (session == null) {
      res.put("success", false);
      res.put("msg", "Сессия истекла. Войдите заново");
    } else {
      for (Templates t : userTemplates(session.getUserId(), req.getParameter("field"))) {
        JSONObject o = new JSONObject();
        o.put("id", t.getId());
        o.put("name", t.getName() == null ? "" : t.getName());
        o.put("template", t.getTemplate() == null ? "" : t.getTemplate());
        arr.put(o);
      }
      res.put("success", true);
    }
    res.put("templates", arr);
    writeJson(resp, res);
  }

  @RequestMapping(value = "/lv/store.s", method = RequestMethod.POST)
  protected void lvStore(HttpServletRequest req, HttpServletResponse resp) throws Exception {
    Session session = SessionUtil.getUser(req);
    JSONObject res = new JSONObject();
    String field = req.getParameter("field");
    String name = req.getParameter("name") == null ? "" : req.getParameter("name").trim();
    String template = req.getParameter("template");
    boolean overwrite = "Y".equals(req.getParameter("overwrite"));
    res.put("success", false);
    if (session == null) {
      res.put("msg", "Сессия истекла. Войдите заново");
    } else if (field == null || !FIELD_CODE.matcher(field).matches()) {
      res.put("msg", "Не указано поле шаблона");
    } else if (name.isEmpty()) {
      res.put("msg", "Введите название шаблона");
    } else if (name.length() > 200) {
      res.put("msg", "Название слишком длинное (максимум 200 символов)");
    } else if (template == null || template.trim().isEmpty()) {
      res.put("msg", "Поле пустое: нечего сохранять");
    } else {
      Templates exist = null;
      for (Templates t : userTemplates(session.getUserId(), field)) {
        if (name.equalsIgnoreCase(t.getName())) {
          exist = t;
          break;
        }
      }
      if (exist != null && !overwrite) {
        res.put("exists", true);
        res.put("msg", "Шаблон с таким названием уже есть");
      } else {
        Templates temp = exist != null ? exist : new Templates();
        temp.setField(field);
        temp.setName(name);
        temp.setTemplate(template);
        temp.setUserId(session.getUserId());
        dTemplate.save(temp);
        res.put("success", true);
        res.put("msg", exist != null ? "Шаблон обновлён" : "Шаблон сохранён");
      }
    }
    writeJson(resp, res);
  }
}
