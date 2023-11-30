package ckb.controllers.admin;

import ckb.dao.admin.depts.DDept;
import ckb.dao.admin.reports.DReport;
import ckb.dao.admin.roles.DRole;
import ckb.dao.admin.users.DUser;
import ckb.dao.admin.users.DUserDrugLine;
import ckb.dao.admin.users.DUserIp;
import ckb.dao.med.amb.DAmbGroups;
import ckb.dao.med.amb.DAmbServiceUsers;
import ckb.dao.med.amb.DAmbServices;
import ckb.dao.med.drug.dict.directions.DDrugDirection;
import ckb.dao.med.kdos.DKdoTypes;
import ckb.domains.admin.*;
import ckb.domains.med.amb.AmbGroups;
import ckb.domains.med.amb.AmbServiceUsers;
import ckb.domains.med.amb.AmbServices;
import ckb.domains.med.drug.dict.DrugDirections;
import ckb.models.Obj;
import ckb.models.ObjList;
import ckb.services.admin.user.SUser;
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

import javax.persistence.PersistenceException;
import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/core/user")
public class CCoreUser {

  @Autowired private DUser dUser;
  @Autowired private DDept dDept;
  @Autowired private SUser sUser;
  @Autowired private DRole dRole;
  @Autowired private DReport dReport;
  @Autowired private DKdoTypes dKdoType;
  @Autowired private DAmbServices dAmbServices;
  @Autowired private DAmbServiceUsers dAmbServiceUsers;
  @Autowired private DAmbGroups dAmbGroups;
  @Autowired private DDrugDirection dDrugDirection;
  @Autowired private DUserDrugLine dUserDrugLine;
  @Autowired private DUserIp dUserIp;

  @RequestMapping({"/list.s", "/"})
  protected String userList(HttpServletRequest request, Model model) {
    Session session = SessionUtil.getUser(request);
    session.setCurUrl("/core/user/list.s");
    List<Users> users = dUser.getAll();
    model.addAttribute("users", users);
    model.addAttribute("kdoUser", request.getParameter("kdoUser"));
    Util.makeMsg(request, model);
    return "/core/users/index";
  }

  @RequestMapping("/save.s")
  protected String addEdit(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    Integer id = Util.getInt(req, "id");
    Users user = dUser.get(id);
    session.setCurUrl("core/user/save.s?id=" + id);
    model.addAttribute("deptList", dDept.getAll());
    model.addAttribute("user", user);
    List<ObjList> list = new ArrayList<>();
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
    return "/core/users/save";
  }

  @RequestMapping(value = "/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String addEdit(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    String id = Util.get(req, "id", "0");
    try {
      Users u = id.equals("0") || id.isEmpty() ? new Users() : dUser.get(Integer.parseInt(id));
      u.setDept(Util.getNullInt(req, "dep") == null ? null : dDept.get(Util.getInt(req, "dep")));
      u.setFio(Util.get(req, "fio"));
      if(id.equals("0") || id.isEmpty() || !Util.get(req, "password").isEmpty())
        u.setPassword(Util.md5(Util.get(req, "password")));
      u.setLogin(Util.get(req, "login"));
      u.setLv(Util.getCheckbox(req, "lv"));
      u.setActive(Util.getCheckbox(req, "active"));
      u.setConsul(Util.getCheckbox(req, "consul"));
      u.setZavlv(Util.getCheckbox(req, "zavlv"));
      u.setProfil(Util.get(req, "profil"));
      u.setAmbAdmin(Util.getCheckbox(req, "ambAdmin"));
      u.setAmbFizio(Util.getCheckbox(req, "ambFizio"));
      u.setMainNurse(Util.getCheckbox(req, "mainNurse"));
      u.setStatExp(Util.getCheckbox(req, "statExp"));
      u.setProcUser(Util.getCheckbox(req, "procUser"));
      u.setDocfizio(Util.getCheckbox(req, "docfizio"));
      u.setDrugDirection(Util.getCheckbox(req, "drugDirection"));
      u.setConsul_price(Util.getDouble(req, "consul_price", null));
      u.setFor_consul_price(Util.getDouble(req, "for_consul_price", null));
      u.setReal_consul_price(Util.getDouble(req, "real_consul_price", null));
      u.setFor_real_consul_price(Util.getDouble(req, "for_real_consul_price", null));
      //
      if(u.getLogin() == null || u.getLogin().isEmpty()) return Util.err(json, "Логин не может быть пустым");
      if(u.getId() == null && (u.getPassword() == null || u.getPassword().isEmpty())) return Util.err(json, "Пароль не может быть пустым");
      if(!Util.isNull(req, "password") && Req.isNull(req, "confirm_password")) return Util.err(json, "Подтверждение пароля не может быть пустым");
      if(!Util.isNull(req, "password") && !Req.isNull(req, "confirm_password") && !Util.get(req, "password").equals(Req.get(req, "confirm_password"))) return Util.err(json, "Пароль и подтверждение пароля не совподает");
      if(u.getFio().isEmpty()) return Util.err(json, "ФИО не может быть пустым");

      //
      u.setGlb(Util.getCheckbox(req, "glb"));
      if(u.isGlb()) {
        Users uglb = dUser.getGlb(id == null ? 0 : u.getId());
        if(uglb.getId() != null) {
          uglb.setGlb(false);
          dUser.save(uglb);
        }
      }
      //
      u.setBoss(Util.getCheckbox(req, "boss"));
      if(u.isBoss()) {
        Users uboss = dUser.getBoss(u.getId() == null ? 0 : u.getId());
        if(uboss.getId() != null) {
          uboss.setBoss(false);
          dUser.save(uboss);
        }
      }
      //
      u.setGlavbuh(Util.getCheckbox(req, "glavbuh"));
      if(u.isGlavbuh()) {
        Users uboss = dUser.getGlavbuh(u.getId() == null ? 0 : u.getId());
        if(uboss.getId() != null) {
          uboss.setGlavbuh(false);
          dUser.save(uboss);
        }
      }
      dUser.save(u);
      List<UserIps> userIps = dUserIp.getList("From UserIps Where user.id = " + u.getId());
      for(UserIps ip: userIps) dUserIp.delete(ip.getId());
      String[] ips = req.getParameterValues("ip");
      if(ips != null) {
        for(String ip: ips) {
          if(ip != null && !ip.equals("")) {
            UserIps userIp = new UserIps();
            userIp.setUser(u);
            userIp.setIp(ip);
            dUserIp.save(userIp);
          }
        }
      }
      String[] storages = req.getParameterValues("storage");
      List<UserDrugLines> lines = dUserDrugLine.getList("From UserDrugLines Where user.id = " + u.getId());
      for(UserDrugLines line: lines) dUserDrugLine.delete(line.getId());
      if(storages != null)
        for(String storage: storages) {
          UserDrugLines line = new UserDrugLines();
          line.setUser(u);
          line.setDirection(dDrugDirection.get(Integer.parseInt(storage)));
          dUserDrugLine.save(line);
        }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/del.s", method = RequestMethod.POST)
  @ResponseBody
  protected String delUser(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      dUser.delete(Req.getInt(req, "id"));
      json.put("success", true);
    } catch (PersistenceException e) {
      json.put("success", false);
      json.put("msg", "Нельзя удалить пользователя! Выбранная запись исползуется в других как родительский");
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("/roles.s")
  protected String userRolesReports(HttpServletRequest request, Model model) {
    Users user = dUser.get(Req.getInt(request, "id"));
    List<Obj> list = new ArrayList<>();
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
    list = new ArrayList<>();
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
    List<Obj> kdos = new ArrayList<>();
    for(KdoTypes kdo : dKdoType.getList("From KdoTypes Where state = 'A'"))
      kdos.add(new Obj(kdo.getId(), kdo.getName(), kdoTypes.contains(kdo.getId())));
    model.addAttribute("kdos", kdos);
    List<Obj> services = new ArrayList<>();
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
    return "/core/users/roles";
  }

  @RequestMapping(value = "/roles.s", method = RequestMethod.POST)
  @ResponseBody
  protected String setUserRolesReports(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      Users u = dUser.get(Req.getInt(req, "userId"));
      List<Roles> roles = new ArrayList<>();
      List<Reports> reports = new ArrayList<>();
      List<KdoTypes> kdoTypes = new ArrayList<>();
      String[] roleList = req.getParameterValues("role");
      String[] kdos = req.getParameterValues("kdo");
      String[] services = req.getParameterValues("service");
      String[] reportList = req.getParameterValues("report");
      boolean isKdo = false;
      u.setKdoTypes(new ArrayList<>());
      if (reportList != null)
        for (String aReportList : reportList)
          reports.add(dReport.get(Integer.parseInt(aReportList)));
      if (roleList != null)
        for (String aRoleList : roleList) {
          isKdo = aRoleList.equals("7") || isKdo;
          roles.add(dRole.get(Integer.parseInt(aRoleList)));
        }
      if (kdos != null)
        for (String aKdo : kdos)
          kdoTypes.add(dKdoType.get(Integer.parseInt(aKdo)));
      // Амбулаторные услуги
      List<AmbServiceUsers> us = dAmbServiceUsers.getList("From AmbServiceUsers Where user = " + u.getId());
      for (AmbServiceUsers uu : us) dAmbServiceUsers.delete(uu.getId());
      if (services != null)
        for (String s : services) {
          Integer sId = Integer.parseInt(s);
          if (sId > 0) {
            AmbServiceUsers su = new AmbServiceUsers();
            su.setUser(u.getId());
            su.setService(sId);
            dAmbServiceUsers.save(su);
          } else { //Лаб
            List<AmbServices> ds = new ArrayList<>();
            if (sId < 0)
              ds = dAmbServices.byType(-1 * sId);
            for (AmbServices d : ds) {
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
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }
}
