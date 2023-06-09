package ckb.controllers.admin;

import ckb.dao.admin.depts.DDept;
import ckb.dao.admin.dicts.DLvPartner;
import ckb.dao.admin.forms.DForm;
import ckb.dao.admin.forms.fields.DFormField;
import ckb.dao.admin.forms.opts.DOpt;
import ckb.dao.admin.nurse.DNurse;
import ckb.dao.admin.nurse.DNurseDept;
import ckb.dao.admin.params.DParam;
import ckb.dao.admin.reports.DReport;
import ckb.dao.admin.roles.DRole;
import ckb.dao.admin.users.DUser;
import ckb.dao.admin.users.DUserDrugLine;
import ckb.dao.admin.users.DUserIp;
import ckb.dao.admin.users.DUserLog;
import ckb.dao.med.amb.DAmbGroups;
import ckb.dao.med.amb.DAmbServiceFields;
import ckb.dao.med.amb.DAmbServiceUsers;
import ckb.dao.med.amb.DAmbServices;
import ckb.dao.med.dicts.rooms.DRooms;
import ckb.dao.med.drug.dict.directions.DDrugDirection;
import ckb.dao.med.kdos.DKdoTypes;
import ckb.dao.med.kdos.DKdos;
import ckb.dao.med.lv.plan.DKdoChoosen;
import ckb.domains.admin.*;
import ckb.domains.med.amb.AmbGroups;
import ckb.domains.med.amb.AmbServiceFields;
import ckb.domains.med.amb.AmbServiceUsers;
import ckb.domains.med.amb.AmbServices;
import ckb.domains.med.drug.dict.DrugDirections;
import ckb.domains.med.lv.KdoChoosens;
import ckb.models.AmbService;
import ckb.models.Obj;
import ckb.models.ObjList;
import ckb.services.admin.user.SUser;
import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.DB;
import ckb.utils.Req;
import ckb.utils.Util;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class CAdmin {

  @Autowired DUser dUser;
  @Autowired DDept dDept;
  @Autowired SUser sUser;
  @Autowired DRole dRole;
  @Autowired DOpt dOpt;
  @Autowired DForm dForm;
  @Autowired DFormField dFormField;
  @Autowired DReport dReport;
  @Autowired DKdoTypes dKdoType;
  @Autowired DParam dParam;
  @Autowired DAmbServices dAmbServices;
  @Autowired DAmbServiceUsers dAmbServiceUsers;
  @Autowired private DAmbGroups dAmbGroups;
  @Autowired private DAmbServiceFields dAmbServiceFields;
  @Autowired DKdos dKdo;
  @Autowired private DKdoChoosen dKdoChoosen;
  @Autowired private DDrugDirection dDrugDirection;
  @Autowired private DUserDrugLine dUserDrugLine;
  @Autowired private DUserLog dUserLog;
  @Autowired private DRooms dRooms;
  @Autowired private DLvPartner dLvPartner;
  @Autowired private DUserIp dUserIp;
  @Autowired private DNurse dNurse;
  @Autowired private DNurseDept dNurseDept;

  @RequestMapping({"/users/list.s", "/"})
  protected String userList(HttpServletRequest request, Model model) {
    Session session = SessionUtil.getUser(request);
    session.setCurUrl("/admin/users/list.s");
    List<Users> users = dUser.getAll();
    model.addAttribute("users", users);
    model.addAttribute("kdoUser", request.getParameter("kdoUser"));
    Util.makeMsg(request, model);
    return "/admin/users/index";
  }

  @RequestMapping("/users/addEdit.s")
  protected String addEdit(@ModelAttribute("user") Users user, HttpServletRequest req, Model model) {
    model.addAttribute("deptList", dDept.getAll());
    sUser.createMode(req, user);
    List<ObjList> list = new ArrayList<ObjList>();
    List<DrugDirections> directions = dDrugDirection.getAll();
    for(DrugDirections direction: directions) {
      ObjList obj = new ObjList();
      obj.setC1(direction.getId().toString());
      obj.setC2(direction.getName());
      obj.setC3(dUserDrugLine.getCount("From UserDrugLines Where user.id = " + Req.getInt(req, "id") + " And direction.id = " + direction.getId()).toString());
      list.add(obj);
    }
    if(Util.isNotNull(req, "id"))
      model.addAttribute("ips", dUserIp.getList("From UserIps Where user.id = " + Util.getInt(req, "id")));
    model.addAttribute("directions", list);
    Util.makeMsg(req, model);
    return "/admin/users/addEdit";
  }

  @RequestMapping(value = "/users/addEdit.s", method = RequestMethod.POST)
  protected String addEdit(@ModelAttribute("user") Users user, Errors errors, HttpServletRequest request, Model model) {
    ValidationUtils.rejectIfEmpty(errors, "login", "login.isEmpty", "Password field is empty");
    // Вводится пароль но подтверждению не ввели
    if(!user.getPassword().equals("") && Req.isNull(request, "confirm_password"))
      errors.rejectValue("password", "confirmNewPassword.isEmpty", "Confirm is null");
    // Вводится пароль но пороль с подтверждением не совподает
    if (!user.getPassword().equals("") && !user.getPassword().equals(Req.get(request, "confirm_password")))
      errors.rejectValue("password", "confirmPassword.error", "Password is not Equal to Confirm");
    if(user.getId() == null) // Добавление нового пользователя - пароль обезательно поле
      ValidationUtils.rejectIfEmpty(errors, "password", "password.isEmpty", "Password field is empty");
    ValidationUtils.rejectIfEmpty(errors, "fio", "fio.isEmpty", "Password field is empty");
    if (errors.hasErrors()) {
      model.addAttribute("deptList", dDept.getAll());
      List<ObjList> list = new ArrayList<ObjList>();
      List<DrugDirections> directions = dDrugDirection.getAll();
      for(DrugDirections direction: directions) {
        ObjList obj = new ObjList();
        obj.setC1(direction.getId().toString());
        obj.setC2(direction.getName());
        obj.setC3(dUserDrugLine.getCount("From UserDrugLines Where user.id = " + Req.getInt(request, "id") + " And direction.id = " + direction.getId()).toString());
        list.add(obj);
      }
      model.addAttribute("directions", list);
      return "/admin/users/addEdit";
    }
    Users u = sUser.save(user);
    List<UserIps> userIps = dUserIp.getList("From UserIps Where user.id = " + user.getId());
    for(UserIps ip: userIps) dUserIp.delete(ip.getId());
    String[] ips = request.getParameterValues("ip");
    if(ips != null) {
      for(String ip: ips) {
        if(ip != null && !ip.equals("")) {
          UserIps userIp = new UserIps();
          userIp.setUser(user);
          userIp.setIp(ip);
          dUserIp.save(userIp);
        }
      }
    }
    String[] storages = request.getParameterValues("storage");
    List<UserDrugLines> lines = dUserDrugLine.getList("From UserDrugLines Where user.id = " + u.getId());
    for(UserDrugLines line: lines) dUserDrugLine.delete(line.getId());
    if(storages != null)
      for(String storage: storages) {
        UserDrugLines line = new UserDrugLines();
        line.setUser(u);
        line.setDirection(dDrugDirection.get(Integer.parseInt(storage)));
        dUserDrugLine.save(line);
      }

    return "redirect:/admin/users/addEdit.s?id=" + u.getId() + "&msgState=1&msgCode=successSave";
  }

  @RequestMapping("/users/del.s")
  protected String del(HttpServletRequest request, Model model) {
    try {
      dUser.delete(Req.getInt(request, "id"));
      return "redirect:/admin/users/list.s?msgState=1&msgCode=successDelete";
    } catch(Exception ex) {
      return "redirect:/admin/users/list.s?msgState=0&msgCode=deleteError";
    }
  }

  @RequestMapping("/users/roles.s")
  protected String userRolesReports(HttpServletRequest request, Model model) {
    Users user = dUser.get(Req.getInt(request, "id"));
    List<Obj> list = new ArrayList<Obj>();
    List<Integer> kdoTypes = dUser.getKdoTypesIds(user.getId());
    boolean isActive;
    for(Roles role : dRole.getAll()) {
      isActive = false;
      for (Roles r : user.getRoles())
        if(role.getId().equals(r.getId()) && role.getState().equals("Y")) {
          isActive = true;
          break;
        }
      if(role.getState().equals("Y"))
        list.add(new Obj(role.getId(), role.getName(), isActive));
    }
    model.addAttribute("roles", list);
    list = new ArrayList<Obj>();
    List<Reports> reports = dUser.getReports(user.getId());
    for(Reports report : dReport.getAll()) {
      isActive = false;
      for (Reports r : reports)
        if(report.getId().equals(r.getId())) {
          isActive = true;
          break;
        }
      list.add(new Obj(report.getId(), report.getName(), isActive));
    }
    List<Obj> kdos = new ArrayList<Obj>();
    for(KdoTypes kdo : dKdoType.getList("From KdoTypes Where state = 'A'"))
      kdos.add(new Obj(kdo.getId(), kdo.getName(), kdoTypes.contains(kdo.getId())));
    model.addAttribute("kdos", kdos);
    List<Obj> services = new ArrayList<Obj>();
    List<AmbServices> ss = dAmbServices.getList("From AmbServices Where group.isGroup = 0 And state = 'A'");
    // Группируем данные
    List<AmbGroups> groups = dAmbGroups.getAll();
    for(AmbGroups group: groups) {
      if(group.isGroup())
        services.add(new Obj(-1 * group.getId(), group.getName(), dAmbServiceUsers.getCount("From AmbServiceUsers t, AmbServices c Where c.group.id = " + group.getId() + " And t.service = c.id And user = " + user.getId()) > 0));
    }
    for(AmbServices s: ss)
      services.add(new Obj(s.getId(), s.getName(), dAmbServiceUsers.getCount("From AmbServiceUsers Where service = " + s.getId() + " And user = " + user.getId()) > 0));
    model.addAttribute("services", services);
    model.addAttribute("reports", list);
    model.addAttribute("user", user);
    Util.makeMsg(request, model);
    return "/admin/users/roles";
  }

  @RequestMapping(value = "/users/roles.s", method = RequestMethod.POST)
  protected String setUserRolesReports(HttpServletRequest request, Model model) {
    Users u = dUser.get(Req.getInt(request, "userId"));
    List<Roles> roles = new ArrayList<Roles>();
    List<Reports> reports = new ArrayList<Reports>();
    List<KdoTypes> kdoTypes = new ArrayList<KdoTypes>();
    String[] roleList = request.getParameterValues("role");
    String[] kdos = request.getParameterValues("kdo");
    String[] services = request.getParameterValues("service");
    String[] reportList = request.getParameterValues("report");
    boolean isKdo = false;
    u.setKdoTypes(new ArrayList<KdoTypes>());
    if(reportList != null)
      for (String aReportList : reportList)
        reports.add(dReport.get(Integer.parseInt(aReportList)));
    if(roleList != null)
      for (String aRoleList : roleList) {
        isKdo = aRoleList.equals("7") || isKdo;
        roles.add(dRole.get(Integer.parseInt(aRoleList)));
      }
    if(kdos != null)
      for (String aKdo : kdos)
        kdoTypes.add(dKdoType.get(Integer.parseInt(aKdo)));
    // Амбулаторные услуги
    List<AmbServiceUsers> us = dAmbServiceUsers.getList("From AmbServiceUsers Where user = " + u.getId());
    for(AmbServiceUsers uu: us) dAmbServiceUsers.delete(uu.getId());
    if(services != null)
      for (String s : services) {
        Integer sId = Integer.parseInt(s);
        if(sId > 0) {
          AmbServiceUsers su = new AmbServiceUsers();
          su.setUser(u.getId());
          su.setService(sId);
          dAmbServiceUsers.save(su);
        } else { //Лаб
          List<AmbServices> ds = new ArrayList<AmbServices>();
          if(sId < 0)
            ds = dAmbServices.byType(-1 * sId);
          for(AmbServices d: ds) {
            AmbServiceUsers su = new AmbServiceUsers();
            su.setUser(u.getId());
            su.setService(d.getId());
            dAmbServiceUsers.save(su);
          }
        }
      }
    u.setRoles(roles);
    u.setReports(reports);
    u.setKdoTypes(kdoTypes);
    dUser.save(u);
    Util.makeMsg(request, model);
    return "redirect:/admin/users/list.s?msgState=1&msgCode=successDelete";
  }

  @RequestMapping("/users/kdos.s")
  protected String kdos(HttpServletRequest request, Model model) {
    Users u = dUser.get(Req.getInt(request, "id"));
    List<Obj> list = new ArrayList<Obj>();
    List<Integer> kdoTypes = dUser.getKdoTypesIds(u.getId());
    for(KdoTypes kdo : dKdoType.getAll())
      list.add(new Obj(kdo.getId(), kdo.getName(), kdoTypes.contains(kdo.getId())));
    model.addAttribute("userId", u.getId());
    model.addAttribute("kdos", list);
    return "/admin/users/kdos";
  }

  @RequestMapping(value = "/users/kdos.s", method = RequestMethod.POST)
  protected String kdosSave(HttpServletRequest request, Model model) {
    Users u = dUser.get(Req.getInt(request, "userId"));
    List<KdoTypes> kdoTypes = new ArrayList<KdoTypes>();
    String[] list = request.getParameterValues("ids");
    for (String l : list)
      kdoTypes.add(dKdoType.get(Integer.parseInt(l)));
    u.setKdoTypes(kdoTypes);
    dUser.save(u);
    Util.makeMsg(request, model);
    return "redirect:/admin/users/list.s?msgState=1&msgCode=successDelete";
  }

  @RequestMapping("/forms/list.s")
  protected String formList(HttpServletRequest request, Model model) {
    Session session = SessionUtil.getUser(request);
    session.setCurUrl("/admin/forms/list.s");
    model.addAttribute("forms", dForm.getAll());
    model.addAttribute("debug", dParam.byCode("IS_DEBUG").equals("Y"));
    return "/admin/forms/index";
  }

  @RequestMapping(value = "/form/get.s", method = RequestMethod.POST)
  @ResponseBody
  protected String getForm(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      Forms d = dForm.get(Util.getInt(req, "id"));
      json.put("id", d.getId());
      json.put("form_name", d.getName());
      json.put("ei_flag", d.getEiFlag());
      json.put("norma_flag", d.getNormaFlag());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/addForm.s", method = RequestMethod.POST)
  @ResponseBody
  protected String addForm(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      Forms form = new Forms();
      form.setAmb("Y");
      form.setName(Util.get(req, "name"));
      form.setType(1);
      form.setEiFlag(Util.get(req, "ei_flag", "N"));
      form.setNormaFlag(Util.get(req, "norma_flag", "N"));
      dForm.save(form);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("/forms/fields.s")
  protected String formFields(HttpServletRequest request, Model model){
    int formId = Req.getInt(request, "formId");
    Session session = SessionUtil.getUser(request);
    session.setCurUrl("/admin/forms/fields.s?formId=" + formId);
    model.addAttribute("fields", dFormField.getFiledsByForm(formId));
    model.addAttribute("form", dForm.get(formId));
    return "/admin/forms/fields";
  }

  @RequestMapping("/forms/fields/removeVal.s")
  protected void removeElem(HttpServletRequest request){
    int fieldId = Req.getInt(request, "fieldId");
    int id = Req.getInt(request, "id");
    FormFields field = dFormField.get(fieldId);
    List<SelOpts> opts = field.getOpts();
    List<SelOpts> list = new ArrayList<SelOpts>();
    for(SelOpts opt : opts)
      if(!opt.getId().equals(id))
        list.add(opt);
    field.setOpts(list);
    dFormField.save(field);
  }

  @RequestMapping(value = "/forms/fields/add.s", method = RequestMethod.POST)
  protected void add(HttpServletRequest request) {
    Long count = dFormField.getCount("From FormFields Where form.id = " + Req.getInt(request, "formId"));
    FormFields f = new FormFields();
    f.setForm(dForm.get(Req.getInt(request, "formId")));
    f.setField(Req.get(request, "field"));
    f.setCssClass("form-control");
    f.setFieldType("text");
    f.setMaxLength(255);
    f.setResFlag("Y");
    f.setTextCols(60);
    f.setTextRows(4);
    f.setOrd(Integer.parseInt("" + (count+1)));
    f.setFieldCode(dFormField.getNextFieldCode(Req.getInt(request, "formId")));
    dFormField.save(f);
  }

  @RequestMapping(value = "/forms/fields/upd.s", method = RequestMethod.POST)
  protected void upd(HttpServletRequest request){
    FormFields f = dFormField.get(Req.getInt(request, "id"));
    f.setField(Req.get(request, "field"));
    f.setCssClass(Req.get(request, "cssClass"));
    f.setFieldCode(Req.get(request, "fieldCode"));
    f.setFieldType(Req.get(request, "fieldType"));
    f.setDefVal(Req.get(request, "defVal"));
    f.setCssStyle(Req.get(request, "cssStyle"));
    f.setEI(Req.get(request, "EI"));
    f.setNormaFrom(Req.get(request, "normaFrom"));
    f.setNormaTo(Req.get(request, "normaTo"));
    f.setMaxLength(Req.getInt(request, "maxLength"));
    f.setTextCols(Req.getInt(request, "textCols"));
    f.setTextRows(Req.getInt(request, "textRows"));
    f.setOrd(Util.isNull(request, "ord") ? null : Util.getInt(request, "ord"));
    f.setResFlag(Util.nvl(Req.get(request, "resFlag"), "N"));
    dFormField.save(f);
    List<SelOpts> opts = f.getOpts();
    SelOpts val = new SelOpts();
    val.setName(Req.get(request, "selVal"));
    if(!val.getName().equals("")) {
      val = dOpt.saveAndReturn(val);
      opts.add(val);
      f.setOpts(opts);
      dFormField.save(f);
    }
  }

  @RequestMapping("/forms/fields/vals.s")
  protected String vals(HttpServletRequest request, Model model){
    int fieldId = Req.getInt(request, "fieldId");
    model.addAttribute("fieldId", fieldId);
    model.addAttribute("opts", dOpt.getAll());
    return "/admin/forms/vals";
  }

  @RequestMapping("/forms/fields/addVals.s")
  protected void addVals(HttpServletRequest request){
    int fieldId = Req.getInt(request, "fieldId");
    FormFields field = dFormField.get(fieldId);
    List<SelOpts> opts = field.getOpts();
    String[] ids = request.getParameterValues("val");
    for(String id : ids)
      opts.add(dOpt.get(Integer.parseInt(id)));
    field.setOpts(opts);
    dFormField.save(field);
  }

  @RequestMapping("/forms/fields/saveVal.s")
  protected void saveVal(HttpServletRequest request){
    int fieldId = Req.getInt(request, "id");
    FormFields field = dFormField.get(fieldId);
    List<SelOpts> opts = field.getOpts();
    SelOpts val = new SelOpts();
    val.setName(Util.toUTF8(Req.get(request, "val")));
    if(!val.getName().equals("")) {
      val = dOpt.saveAndReturn(val);
      opts.add(val);
      field.setOpts(opts);
      dFormField.save(field);
    }
  }

  @RequestMapping("/forms/addField.s")
  protected void addField(HttpServletRequest request){
    int formId = Req.getInt(request, "formId");
    FormFields field = new FormFields();
    field.setField(Util.toUTF8(Req.get(request, "field")));
    field.setForm(dForm.get(formId));
    dFormField.save(field);
  }

  @RequestMapping("/forms/removeField.s")
  protected void removeField(HttpServletRequest request){
    int id = Req.getInt(request, "id");
    FormFields field = dFormField.get(id);
    field.setOpts(null);
    dFormField.save(field);
    dFormField.delete(id);
  }

  @RequestMapping("/changePass.s")
  protected String changePass(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    model.addAttribute("u", dUser.get(session.getUserId()));
    Util.makeMsg(request, model);
    return "/admin/users/changePass";
  }

  @RequestMapping(value = "/changePass.s", method = RequestMethod.POST)
  protected String changePass(HttpServletRequest request){
    Session session = SessionUtil.getUser(request);
    String password = Req.get(request, "newPass");
    Users u = dUser.get(session.getUserId());
    u.setPassword(Util.md5(password));
    dUser.save(u);
    //
    return "redirect:/admin/changePass.s?msgState=1&msgCode=successSave";
  }

  @RequestMapping("/amb.s")
  protected String amb(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    session.setCurUrl("/admin/amb.s");
    //
    String page = Util.get(request, "page");
    if(page == null) page = session.getDateBegin().get("admin_amb_index");
    if(page == null) page = "0";
    //
    HashMap<String, String> dh = session.getDateBegin();
    dh.put("admin_amb_index", page);
    session.setDateBegin(dh);
    //
    List<AmbService> services = new ArrayList<AmbService>();
    List<AmbServices> list = dAmbServices.getList("From AmbServices t " + (page.equals("0") ? "" : " Where  group.id = " + page) + " Order By t.state, t.group.id");
    for(AmbServices l:list) {
      AmbService s = new AmbService();
      s.setId(l.getId());
      s.setService(l);
      //if(l.getGroup().getId() == 1)
        services.add(s);
    }
    model.addAttribute("services", services);
    model.addAttribute("groups", dAmbGroups.getAll());
    model.addAttribute("page", page);
    return "/admin/amb/index";
  }

  @RequestMapping("/addAmb.s")
  protected String addAmb(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/admin/addAmb.s?id=" + Util.nvl(req, "id"));
    model.addAttribute("groups", dAmbGroups.getAll());
    model.addAttribute("forms", dForm.getList("From Forms Where amb = 'Y'"));
    if(Util.isNotNull(req, "id")) {
      model.addAttribute("ser", dAmbServices.get(Util.getInt(req, "id")));
      model.addAttribute("rows", dAmbServiceFields.byService(Util.getInt(req, "id")));
      StringBuilder users = new StringBuilder();
      for(AmbServiceUsers rw: dAmbServiceUsers.getList("From AmbServiceUsers Where service = " + Util.get(req, "id"))) {
        Users u = dUser.get(rw.getUser());
        users.append(u.getFio()).append("; ");
      }
      model.addAttribute("users", users.toString());
    }
    return "/admin/amb/add";
  }

  @RequestMapping(value = "/addAmb.s", method = RequestMethod.POST)
  @ResponseBody
  protected String addAmb(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      AmbServices ser = Util.isNull(req, "id") ? new AmbServices() : dAmbServices.get(Util.getInt(req, "id"));
      ser.setName(Util.get(req, "name"));
      ser.setConsul(Util.isNull(req, "consul") ? "N" : "Y");
      ser.setDiagnoz(Util.isNull(req, "diagnoz") ? "N" : "Y");
      ser.setPrice(Double.parseDouble(Util.get(req, "price")));
      ser.setFor_price(Double.parseDouble(Util.get(req, "for_price")));
      ser.setGroup(dAmbGroups.get(Util.getInt(req, "group")));
      ser.setForm_id(Util.getInt(req, "form_id") != -1 ? Util.getInt(req, "form_id") : null);
      ser.setEi(Util.get(req, "ei"));
      ser.setNormaFrom(Util.get(req, "normaFrom"));
      ser.setNormaTo(Util.get(req, "normaTo"));
      ser.setState(Util.isNull(req, "state") ? "P": "A");
      AmbServices ds = dAmbServices.saveAndReturn(ser);
      String[] names = req.getParameterValues("names");
      if(names != null) {
        List<AmbServiceFields> fields = dAmbServiceFields.byService(ds.getId());
        for (AmbServiceFields ff : fields)
          dAmbServiceFields.delete(ff.getId());
        int d = 0;
        for (String name : names) {
          d++;
          AmbServiceFields field = new AmbServiceFields();
          field.setService(ds.getId());
          field.setName(name);
          field.setField(d);
          dAmbServiceFields.save(field);
        }
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("/ambGroups.s")
  protected String amb_groups(HttpServletRequest request, Model model) {
    Session session = SessionUtil.getUser(request);
    session.setCurUrl("/admin/ambGroups.s");
    model.addAttribute("groups", dAmbGroups.getAll());
    return "/admin/amb/groups";
  }

  @RequestMapping("/addGroup.s")
  protected String addGroup(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/admin/addGroup.s?id=" + Util.nvl(req, "id"));
    if(Util.isNotNull(req, "id"))
      model.addAttribute("ser", dAmbGroups.get(Util.getInt(req, "id")));
    return "/admin/amb/addGroup";
  }

  @RequestMapping("/statGroups.s")
  protected String stat_groups(HttpServletRequest request, Model model) {
    Session session = SessionUtil.getUser(request);
    session.setCurUrl("/admin/statGroups.s");
    model.addAttribute("groups", dKdoType.getAll());
    return "/admin/stat/groups";
  }

  @RequestMapping("/addStatGroup.s")
  protected String addStatGroup(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/admin/addStatGroup.s?id=" + Util.nvl(req, "id"));
    if(Util.isNotNull(req, "id"))
      model.addAttribute("ser", dKdoType.get(Util.getInt(req, "id")));
    return "/admin/stat/addGroup";
  }

  @RequestMapping(value = "/addStatGroup.s", method = RequestMethod.POST)
  @ResponseBody
  protected String saveStatGroup(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      KdoTypes ser = Util.isNull(req, "id") ? new KdoTypes() : dKdoType.get(Util.getInt(req, "id"));
      ser.setName(Util.get(req, "name"));
      ser.setGroupState(Util.isNull(req, "group") ? "N" : Util.get(req, "group"));
      ser.setState(Util.isNull(req, "active") ? "P" : Util.get(req, "active"));
      dKdoType.save(ser);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/addGroup.s", method = RequestMethod.POST)
  @ResponseBody
  protected String saveGroup(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      AmbGroups ser = Util.isNull(req, "id") ? new AmbGroups() : dAmbGroups.get(Util.getInt(req, "id"));
      ser.setName(Util.get(req, "name"));
      ser.setGroup(Util.isNotNull(req, "group"));
      ser.setActive(Util.isNotNull(req, "active"));
      dAmbGroups.save(ser);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("/stat/services.s")
  protected String statServices(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    String group = Util.get(req, "group", "0");
    session.setCurUrl("/admin/stat/services.s?group=" + group);
    model.addAttribute("groups", dKdoType.getList("From KdoTypes Order By id Desc"));
    model.addAttribute("services", dKdo.getList("From Kdos Where state = 'A' " + (group.equals("0") ? "" : " And kdoType.id = " + group) + " And id not in (13, 56, 120, 121, 153) Order By kdoType.id"));
    model.addAttribute("forms", dForm.getAll());
    model.addAttribute("group", group);
    return "/admin/stat/services";
  }

  @RequestMapping("/addStat.s")
  protected String addStat(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/admin/stat/addStat.s?id=" + Util.nvl(req, "id"));
    model.addAttribute("groups", dKdoType.getList("From KdoTypes Order By id Desc"));
    if(Util.isNotNull(req, "id")) {
      model.addAttribute("ser", dKdo.get(Util.getInt(req, "id")));
    }
    return "/admin/stat/add";
  }

  @RequestMapping("/stat/kdoDetails.s")
  protected String kdoDetails(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/admin/stat/kdoDetails.s");
    model.addAttribute("services", dKdoChoosen.getList("From KdoChoosens Where kdo.state = 'A' "));
    return "/admin/stat/kdoDetails";
  }

  @RequestMapping(value = "/stat/kdoDetails.s", method = RequestMethod.POST)
  @ResponseBody
  protected String kdoDetailsSave(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      KdoChoosens kdo = dKdoChoosen.get(Util.getInt(req, "id"));
      if(Util.isNotNull(req, "price")) kdo.setPrice(Double.parseDouble(Util.get(req, "price").replaceAll(",", ".")));
      if(Util.isNotNull(req, "for_price")) kdo.setFor_price(Double.parseDouble(Util.get(req, "for_price").replaceAll(",", ".")));
      if(Util.isNotNull(req, "real_price")) kdo.setReal_price(Double.parseDouble(Util.get(req, "real_price").replaceAll(",", ".")));
      if(Util.isNotNull(req, "for_real_price")) kdo.setFor_real_price(Double.parseDouble(Util.get(req, "for_real_price").replaceAll(",", ".")));
      dKdoChoosen.save(kdo);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/stat/getKdo.s", method = RequestMethod.POST)
  @ResponseBody
  protected String statGeyKdo(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      Kdos d = dKdo.get(Util.getInt(req, "id"));
      json.put("name", d.getName());
      json.put("price", d.getPrice());
      json.put("priced", d.getPriced());
      json.put("for_price", d.getFor_price());
      json.put("real_price", d.getReal_price());
      json.put("for_real_price", d.getFor_real_price());
      json.put("minTime", d.getMinTime());
      json.put("maxTime", d.getMaxTime());
      json.put("state", d.getState());
      json.put("necKdo", d.getNecKdo());
      json.put("group", d.getKdoType().getId());
      json.put("kdoType", d.getKdoType().getId());
      json.put("norma", d.getNorma());
      json.put("ei", d.getEi());
      json.put("room", d.getRoom());
      json.put("fizei", d.getFizei());
      json.put("form", d.getFormId());
      StringBuilder users = new StringBuilder();
      conn = DB.getConnection();
      ps = conn.prepareStatement("Select a.fio From User_Kdo_Types t, Kdos c, Users a Where a.id = t.users_id And c.kdo_type = t.kdoTypes_Id And c.id = " + d.getId());
      rs = ps.executeQuery();
      while(rs.next()) {
        users.append(rs.getString("fio")).append("; ");
      }
      json.put("users", users);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(conn);
    }
    return json.toString();
  }

  @RequestMapping(value = "/stat/kdoSave.s", method = RequestMethod.POST)
  @ResponseBody
  protected String kdoSave(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      Kdos d = Util.isNotNull(req, "id") ? dKdo.get(Util.getInt(req, "id")) : new Kdos();
      d.setName(Util.get(req, "name"));
      if(Util.isNotNull(req, "price")) d.setPrice(Double.parseDouble(Util.get(req, "price").replaceAll(",", ".")));
      if(Util.isNotNull(req, "for_price")) d.setFor_price(Double.parseDouble(Util.get(req, "for_price").replaceAll(",", ".")));
      if(Util.isNotNull(req, "real_price")) d.setReal_price(Double.parseDouble(Util.get(req, "real_price").replaceAll(",", ".")));
      if(Util.isNotNull(req, "for_real_price")) d.setFor_real_price(Double.parseDouble(Util.get(req, "for_real_price").replaceAll(",", ".")));
      d.setState(Util.isNull(req, "state") ? "P": "A");
      d.setPriced(Util.isNull(req, "priced") ? "N": "Y");
      d.setNecKdo(Util.isNull(req, "necKdo") ? "N": "Y");
      d.setKdoType(dKdoType.get(Util.getInt(req, "group")));
      d.setCssWidth("700");
      d.setNorma(Util.get(req, "norma"));
      d.setEi(Util.get(req, "ei"));
      d.setShortName(d.getName());
      d.setFormId(Util.getInt(req, "form_id"));
      d.setRoom(Util.get(req, "room"));
      d.setFizei(Util.get(req, "fizei"));
      if(Util.isNotNull(req, "minTime")) d.setMinTime(Integer.parseInt(Util.get(req, "minTime").replaceAll(",", ".")));
      if(Util.isNotNull(req, "maxTime")) d.setMaxTime(Integer.parseInt(Util.get(req, "maxTime").replaceAll(",", ".")));
      dKdo.save(d);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("/price.s")
  protected String price(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/admin/price.s");
    model.addAttribute("prices", dParam.getList("From Params Where showFlag = 'Y'"));
    return "/admin/prices";
  }

  @RequestMapping(value = "/price.s", method = RequestMethod.POST)
  @ResponseBody
  protected String savePrice(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      String[] codes = req.getParameterValues("code");
      String[] prices = req.getParameterValues("price");
      for(int i=0;i<codes.length;i++) {
        Params param = dParam.getObj("From Params Where code = '" + codes[i] + "'");
        param.setVal(prices[i]);
        dParam.save(param);
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("/log.s")
  protected String log(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/admin/log.s");
    String user = Util.get(req, "user", "0");
    String ip = Util.get(req, "ip", "");
    //
    String db = session.getDateBegin().get("user_log");
    if(db == null) db = "01" + Util.getCurDate().substring(2);
    String de = session.getDateEnd().get("user_log");
    if(de == null) de = Util.getCurDate();
    //
    String startDate = Util.get(req, "period_start", db);
    String endDate = Util.get(req, "period_end", de);
    //
    HashMap<String, String> dh = session.getDateBegin();
    dh.put("user_log", startDate);
    session.setDateBegin(dh);
    dh = session.getDateEnd();
    dh.put("user_log", endDate);
    session.setDateEnd(dh);
    //
    model.addAttribute("rows", dUserLog.getList("From UserLogs Where " + (ip.equals("") ? "" : " ip like '%" + ip + "%' And ") + (user.equals("") || user.equals("0") ? "" : " user.id = " + user + " And ") + " date(dateTime) Between '" + Util.dateDBBegin(startDate) + "' And '" + Util.dateDBBegin(endDate) + "' Order By id Desc"));
    model.addAttribute("users", dUser.getAll());
    model.addAttribute("period_start", startDate);
    model.addAttribute("period_end", endDate);
    model.addAttribute("user_id", user);
    model.addAttribute("filterWord", ip);
    //
    return "/admin/log";
  }

  @RequestMapping("/depts.s")
  protected String depts(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/admin/depts.s");
    //
    model.addAttribute("rows", dDept.getAll());
    model.addAttribute("users", dUser.getAll());
    //
    return "/admin/depts";
  }

  @RequestMapping(value = "/dept/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String saveDept(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      Depts rp = Util.isNull(req, "id") ? new Depts() : dDept.get(Util.getInt(req, "id"));
      rp.setName(Util.get(req, "name"));
      rp.setNurse(dUser.get(Util.getInt(req, "user")));
      rp.setState(Util.get(req, "state", "P"));
      dDept.save(rp);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/dept/get.s", method = RequestMethod.POST)
  @ResponseBody
  protected String getDept(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      Depts rp = dDept.get(Util.getInt(req, "id"));
      json.put("id", rp.getId());
      json.put("name", rp.getName());
      json.put("nurse", rp.getNurse() == null ? 0 : rp.getNurse().getId());
      json.put("state", rp.getState());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }


  @RequestMapping("/lvpartners.s")
  protected String lvpartners(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/admin/lvpartners.s");
    //
    model.addAttribute("rows", dLvPartner.getAll());
    //
    return "/admin/lvpartners";
  }

  @RequestMapping(value = "/lvpartner/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String saveLvPartner(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      LvPartners rp = Util.isNull(req, "id") ? new LvPartners() : dLvPartner.get(Util.getInt(req, "id"));
      rp.setCode(Util.get(req, "code"));
      rp.setFio(Util.get(req, "fio"));
      rp.setState(Util.get(req, "state", "P"));
      dLvPartner.save(rp);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/lvpartner/get.s", method = RequestMethod.POST)
  @ResponseBody
  protected String getLvPartner(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      LvPartners rp = dLvPartner.get(Util.getInt(req, "id"));
      json.put("id", rp.getId());
      json.put("code", rp.getCode());
      json.put("fio", rp.getFio());
      json.put("state", rp.getState());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  //region Медсестры
  @RequestMapping("/nurses.s")
  protected String nurses(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/admin/nurses.s");
    //
    model.addAttribute("rows", dLvPartner.getAll());
    //
    return "/admin/nurses/index";
  }

  @RequestMapping("/nurse/info.s")
  protected String nurseInfo(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/admin/nurse/info.s");
    //
    Nurses nurse = dNurse.get(Util.getInt(req, "id"));

    model.addAttribute("d", nurse);
    //
    return "/admin/nurses/info";
  }

  @RequestMapping(value = "/nurse/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String nurseSave(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      LvPartners rp = dLvPartner.get(Util.getInt(req, "id"));
      json.put("id", rp.getId());
      json.put("code", rp.getCode());
      json.put("fio", rp.getFio());
      json.put("state", rp.getState());
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

}
