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
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/templates")
public class CTemplate {

  private Session session = null;
  @Autowired DKdos dKdos;
  @Autowired private DTemplate dTemplate;
  @Autowired private DDrugTemplate dDrugTemplate;

  @RequestMapping("/index.s")
  protected String main(HttpServletRequest request, Model model){
    try {
      session = SessionUtil.getUser(request);
    } catch (Exception e) {
      return "redirect:/login.s";
    }
    session.setCurUrl("/templates/index.s");
    //
    model.addAttribute("kdos", dKdos.getUser999Kdos(session));
    //
    Util.makeMsg(request, model);
    return "/med/kdo/templates/index";
  }

  @RequestMapping("/edit.s")
  protected String edit(HttpServletRequest request, Model model){
    try {
      session = SessionUtil.getUser(request);
    } catch (Exception e) {
      return "redirect:/login.s";
    }
    Integer id = Req.getInt(request, "id");
    session.setCurUrl("/templates/edit.s?id=" + id);
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
    session = SessionUtil.getUser(req);
    JSONObject res = new JSONObject();
    String template = req.getParameter("template");
    Long checker = dTemplate.getCount("From Templates Where userId = " + session.getUserId() + " And template = '" + template + "'");
    if(checker == 0) {
      Templates temp = new Templates();
      temp.setField(req.getParameter("field"));
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
    session = SessionUtil.getUser(req);
    model.addAttribute("isKdo", Util.isNull(req, "kdo"));
    model.addAttribute("id", req.getParameter("id"));
    model.addAttribute("templates", dTemplate.getList("From Templates where userId = " + session.getUserId() + " And field='" + req.getParameter("field") + "'"));
    return "/med/template/index";
  }

  @RequestMapping(value = "/lv/drug/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String lvDrugTemplateSave(HttpServletRequest req) throws JSONException {
    session = SessionUtil.getUser(req);
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
    session = SessionUtil.getUser(req);
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



}
