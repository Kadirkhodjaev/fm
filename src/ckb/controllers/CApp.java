package ckb.controllers;

import ckb.dao.admin.roles.DRole;
import ckb.dao.admin.users.DUser;
import ckb.dao.admin.users.DUserDrugLine;
import ckb.dao.med.lv.consul.DLvConsul;
import ckb.domains.admin.Roles;
import ckb.domains.admin.UserDrugLines;
import ckb.domains.admin.Users;
import ckb.models.Login;
import ckb.models.Menu;
import ckb.services.admin.user.SUser;
import ckb.services.med.patient.SPatient;
import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.*;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;
import java.util.zip.Deflater;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

@Controller
@RequestMapping("/")
public class  CApp {

  private static final String JSON = "application/json; charset=UTF-8";

  @Autowired private SUser sUser;
  @Autowired private DUser dUser;
  @Autowired private DRole dRole;
  @Autowired private DLvConsul dLvConsul;
  @Autowired private DUserDrugLine dUserDrugLine;
  @Autowired private BeanUsers beanUsers;
  @Autowired private BeanSession beanSession;
  @Autowired private SPatient sPatient;

  @RequestMapping({"/main.s", "/"})
  protected String main(HttpServletRequest req, Model model) {
    //
    Session session = SessionUtil.getUser(req);
    if(session == null) {
      return "redirect: login.s";
    }
    Users user = dUser.get(session.getUserId());
    //
    List<Menu> m = new ArrayList<>();
    if(user.isProcUser()) {
      session.setCurUrl(session.getCurUrl() == null ? "/proc/palatas.s" : session.getCurUrl());
      m.add(new Menu("Палаты", "/proc/palatas.s", "fa fa-users fa-fw", session.getCurUrl().equals("/proc/palatas.s")));
      model.addAttribute("openPage", session.getCurUrl());
      model.addAttribute("menuList", m);
      return "proc/index";
    }
    List<Roles> userRoles = sUser.getUserRoles(session.getUserId());
    if(userRoles.size() == 1 && session.getRoleId() == 0) {
      session.setRoleId(userRoles.get(0).getId());
      session.setCurPat(0);
      session.setCurUrl("");
    }
    int roleId = session.getRoleId();
    if(roleId == 1) { // Администрирование
      session.setCurUrl(session.getCurUrl().equals("") ? "/core/user/list.s" : session.getCurUrl());
      m.add(new Menu("Пользователи", "/core/user/list.s", "fa fa-users fa-fw", session));
      m.add(new Menu("Формы", "/core/form/list.s", "fa fa-edit fa-fw", session));
      m.add(new Menu("Амб группы", "/core/amb/groups.s", "fa fa-list-alt fa-fw", session));
      m.add(new Menu("Амб услуги", "/core/amb/services.s", "fa fa-plus fa-fw", session));
      m.add(new Menu("Амбулатория", "/core/ambv2/index.s", "fa fa-plus fa-fw", session));
      m.add(new Menu("Стат группы", "/core/stat/groups.s", "fa fa-list-alt fa-fw", session));
      m.add(new Menu("Стат услуги", "/core/stat/services.s", "fa fa-list-alt fa-fw", session));
      m.add(new Menu("Детали лаб", "/core/stat/details.s", "fa fa-th fa-fw", session));
      m.add(new Menu("МКБ", "/mkb/admin.s", "fa fa-th fa-fw", session));
      m.add(new Menu("Отделении", "/admin/depts.s", "fa fa-th-list fa-fw", session));
      m.add(new Menu("Параметры", "/admin/price.s", "fa fa-th fa-fw", session));
      m.add(new Menu("Партнеры", "/admin/lvpartners.s", "fa fa-users fa-fw", session));
      m.add(new Menu("Палата", "/admin/rooms.s", "fa fa-archive fa-fw", session));
      m.add(new Menu("Протокол", "/admin/log.s", "fa fa-users fa-fw", session));
      m.add(new Menu("Пакет услуг", "/admin/pack/index.s", "fa fa-users fa-fw", session));
      m.add(new Menu("Акции", "/cashbox/sales.s", "fa fa-users fa-fw", session));
    }
    if(roleId == 3) { // Приемное – медсестра
      session.setCurUrl(session.getCurUrl().equals("") ? "/reg/nurse/index.s" : session.getCurUrl());
      m.add(new Menu("Регистрация", "/reg/nurse/index.s", "fa fa-edit fa-fw", session.getCurUrl().equals("/reg/nurse/index.s")));
      m.add(new Menu("Клиенты", "/clients/list.s", "fa fa-group fa-fw", session));
      //m.add(new Menu("Брон", "/booking/nurse.s", "fa fa-th fa-fw", session.getCurUrl().equals("/booking/nurse.s")));
      m.add(new Menu("Пациенты", "/patients/list.s", "fa fa-align-justify fa-fw", session.getCurUrl().equals("/patients/list.s")));
      m.add(new Menu("Архив", "/patients/archive.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/archive/list.s")));
    }
    if(roleId == 4) { // Приемное – врач
      session.setCurUrl(session.getCurUrl().equals("") ? "/patients/list.s" : session.getCurUrl());
      m.add(new Menu("Пациенты", "/patients/list.s", "fa fa-align-justify fa-fw", session.getCurUrl().equals("/patients/list.s")));
      m.add(new Menu("Архив", "/patients/archive.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/archive/list.s")));
    }
    if(roleId == 5) { // Лечащий врач
      session.setCurUrl(session.getCurUrl().equals("") ? "/patients/list.s" : session.getCurUrl());
      m.add(new Menu("Статистика", "/view/stat.s", "fa fa-list-alt fa-fw", session.getCurUrl().equals("/view/stat.s")));
      m.add(new Menu("Пациенты", "/patients/list.s", "fa fa-align-justify fa-fw", session.getCurUrl().equals("/patients/list.s")));
      m.add(new Menu("Консультация", "/patients/consul.s", "fa fa-group fa-fw", session.getCurUrl().equals("/patients/consul.s")));
      m.add(new Menu("Архив", "/patients/archive.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/archive/list.s")));
    }
    if(roleId == 6) { // Заместитель главного врача
      session.setCurUrl(session.getCurUrl().equals("") ? "/patients/list.s" : session.getCurUrl());
      m.add(new Menu("Статистика", "/patients/stat.s", "fa fa-edit fa-fw", session.getCurUrl().equals("/patients/stat.s")));
      m.add(new Menu("Палаты", "/booking/palata.s", "fa fa-sign-out fa-fw", session.getCurUrl().equals("/booking/palata.s")));
      m.add(new Menu("Выписка", "/patients/list.s", "fa fa-align-justify fa-fw", session.getCurUrl().equals("/patients/list.s")));
      m.add(new Menu("Пациенты", "/patients/list.s?curPat=Y", "fa fa-edit fa-fw", session.getCurUrl().equals("/patients/list.s?curPat=Y")));
      m.add(new Menu("Архив", "/patients/archive.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/archive/list.s")));
    }
    if(roleId == 7) { // КДО
      session.setCurUrl(session.getCurUrl().equals("") ? "/patients/list.s" : session.getCurUrl());
      m.add(new Menu("Пациенты", "/patients/list.s", "fa fa-align-justify fa-fw", session.getCurUrl().equals("/patients/list.s")));
      m.add(new Menu("Архив", "/patients/archive.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/archive/list.s")));
    }
    if(roleId == 8) { // Дежурный врач
      session.setCurUrl(session.getCurUrl().equals("") ? "/patients/list.s" : session.getCurUrl());
      m.add(new Menu("Пациенты", "/patients/list.s", "fa fa-align-justify fa-fw", session.getCurUrl().equals("/patients/list.s")));
      m.add(new Menu("Архив", "/patients/archive.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/archive/list.s")));
    }
    if(roleId == 9) { // Консультация
      session.setCurUrl(session.getCurUrl().equals("") ? "/patients/consul.s" : session.getCurUrl());
      Long conCount = dLvConsul.getCount("From LvConsuls c Where c.text = null And c.lvId = " + session.getUserId());
      m.add(new Menu("Консультация (" + conCount + ")", "/patients/consul.s", "fa fa-group fa-fw", session.getCurUrl().equals("/patients/consul.s")));
      m.add(new Menu("Архив", "/patients/archive.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/archive/list.s")));
    }
    if(roleId == 10) { // Аптека
      session.setCurUrl(session.getCurUrl().equals("") ? "/drugs/acts.s" : session.getCurUrl());
      m.add(new Menu("Детализация", "/drugs/details.s", "fa fa-group fa-fw", session.getCurUrl().equals("/drugs/details.s")));
      m.add(new Menu("Склад", "/drugs/sklad.s", "fa fa-group fa-fw", session.getCurUrl().equals("/drugs/sklad.s")));
      //m.add(new Menu("Сальдо", "/drugs/saldo.s", "fa fa-group fa-fw", session.getCurUrl().equals("/drugs/saldo.s")));
      m.add(new Menu("Приход", "/drugs/acts.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/drugs/acts.s")));
      m.add(new Menu("Расход", "/drugs/out.s", "fa fa-align-justify fa-fw", session.getCurUrl().equals("/drugs/out.s")));
      m.add(new Menu("Заявки", "/drugs/out/drug/claim.s", "fa fa-align-justify fa-fw", session));
      //m.add(new Menu("Архив заявок", "/drugs/claims/archive.s", "fa fa-archive fa-edit", session.getCurUrl().equals("/drugs/claims/archive.s")));
      m.add(new Menu("Справочники", "/drugs/dicts.s", "fa fa-align-justify fa-fw", session.getCurUrl().equals("/drugs/dicts.s")));
    }
    if(roleId == 11) { // Постовой
      session.setCurUrl(session.getCurUrl().equals("") ? "/patients/list.s" : session.getCurUrl());
      m.add(new Menu("Статистика", "/head_nurse/stat.s", "fa fa-home fa-fw", session.getCurUrl().equals("/head_nurse/stat.s")));
      m.add(new Menu("Услуги", "/nurses/work.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/nurses/work.s")));
      m.add(new Menu("Пациенты", "/patients/list.s", "fa fa-align-justify fa-fw", session.getCurUrl().equals("/patients/list.s")));
      m.add(new Menu("Палаты", "/proc/palatas.s", "fa fa-users fa-fw", session.getCurUrl().equals("/proc/palatas.s")));
    }
    if(roleId == 12) { // Питание
      session.setCurUrl(session.getCurUrl().equals("") ? "/eats/menu.s" : session.getCurUrl());
      m.add(new Menu("Заявки", "/eats/claims.s", "fa fa-group fa-fw", session.getCurUrl().equals("/eats/claims.s")));
      m.add(new Menu("Меню", "/eats/menu.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/eats/menu.s")));
      m.add(new Menu("Справочники", "/eats/dicts.s", "fa fa-align-justify fa-fw", session.getCurUrl().equals("/eats/dicts.s")));
    }
    if(roleId == 13) { // Касса
      m.add(new Menu("Статистика", "/cashbox/statistic.s", "fa fa-edit fa-fw", session.getCurUrl().equals("/patients/cashStat.s")));
      m.add(new Menu("Амбулатория", "/amb/home.s", "fa fa-group fa-fw", session.getCurUrl().equals("/amb/home.s")));
      m.add(new Menu("Стационар", "/patients/list.s", "fa fa-group fa-fw", session.getCurUrl().equals("/patients/list.s")));
      m.add(new Menu("Архив (Амб)", "/amb/archive.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/amb/archive.s")));
      m.add(new Menu("Архив (Стац)", "/patients/archive.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/patients/archive.s")));
    }
    if(roleId == 14) {  // Амбулаторные услуги
      m.add(new Menu("Текущие", "/amb/home.s", "fa fa-group fa-fw", session));
      m.add(new Menu("Сотрудники", "/emp/doctor/emps.s", "fa fa-group fa-fw", session));
      m.add(new Menu("Бронирование", "/amb/booking/lvs.s", "fa fa-group fa-fw", session));
      m.add(new Menu("Архив", "/amb/archive.s", "fa fa-archive fa-fw", session));
    }
    if(roleId == 15) { // Амбулаторная регистрация
      m.add(new Menu("Регистрация", "/amb/reg.s", "fa fa-edit fa-fw", session.getCurUrl().contains("/amb/reg.s")));
      m.add(new Menu("Текущие", "/amb/home.s", "fa fa-group fa-fw", session.getCurUrl().equals("/amb/home.s")));
      m.add(new Menu("Бронирование", "/amb/bookings.s", "fa fa-group fa-fw", session.getCurUrl().equals("/amb/bookings.s")));
      m.add(new Menu("Клиенты", "/clients/list.s", "fa fa-group fa-fw", session));
      m.add(new Menu("Архив", "/amb/archive.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/amb/archive.s")));
      m.add(new Menu("Прейскурант", "/amb/prices.s", "fa fa-list-alt fa-fw", session.getCurUrl().equals("/amb/prices.s")));
    }
    if(roleId == 16) { // Физиотерапия
      if(user.isDocfizio()) {
        session.setCurUrl(session.getCurUrl().isEmpty() ? "/patients/list.s" : session.getCurUrl());
        m.add(new Menu("Пациенты", "/patients/list.s", "fa fa-align-justify fa-fw", session.getCurUrl().equals("/patients/list.s")));
      } else {
        session.setCurUrl(session.getCurUrl().isEmpty() ? "/nurses/fizio.s" : session.getCurUrl());
      }
      m.add(new Menu("Постовой", "/nurses/fizio.s", "fa fa-align-justify fa-fw", session.getCurUrl().equals("/nurses/fizio.s")));
      m.add(new Menu("Архив", "/patients/archive.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/archive/list.s")));
    }
    if(roleId == 17) { // Бронирование
      session.setCurUrl(session.getCurUrl().equals("") ? "/patients/list.s" : session.getCurUrl());
      m.add(new Menu("Статистика", "/patients/stat.s", "fa fa-edit fa-fw", session.getCurUrl().equals("/patients/stat.s")));
      m.add(new Menu("Койки", "/booking/koyki.s", "fa fa-home fa-fw", session.getCurUrl().equals("/booking/koyki.s")));
      m.add(new Menu("Бронирование", "/booking/index.s", "fa fa-plus fa-fw", session.getCurUrl().equals("/booking/index.s")));
      m.add(new Menu("Пациенты", "/patients/list.s", "fa fa-align-justify fa-fw", session.getCurUrl().equals("/patients/list.s")));
      m.add(new Menu("Архив", "/patients/archive.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/archive/list.s")));
    }
    if(roleId == 18) { // Расходы по услугам
      session.setCurUrl(session.getCurUrl().equals("") ? "/exp/stat.s" : session.getCurUrl());
      m.add(new Menu("Статистика", "/exp/stat.s", "fa fa-signal", session.getCurUrl().equals("/exp/stat.s")));
      m.add(new Menu("Справочники", "/exp/dicts.s", "fa fa-align-justify fa-fw", session.getCurUrl().equals("/exp/dicts.s")));
    }
    if(roleId == 19) { // Старшая медсестра
      session.setCurUrl(session.getCurUrl().equals("") ? "/head_nurse/incomes.s" : session.getCurUrl());
      List<UserDrugLines> lines = dUserDrugLine.getList("From UserDrugLines Where user.id = " + session.getUserId());
      boolean isTransfer = false;
      for(UserDrugLines line: lines) {
        if(line.getDirection().getTransfer() != null && line.getDirection().getTransfer().equals("Y")) {
          isTransfer = true;
        }
      }
      m.add(new Menu("Статистика", "/head_nurse/stat.s", "fa fa-home fa-fw", session.getCurUrl().equals("/head_nurse/stat.s")));
      if(user.isMainNurse())
        m.add(new Menu("Питание", "/head_nurse/eats.s", "fa fa-home fa-fw", session.getCurUrl().equals("/head_nurse/eats.s")));
      m.add(new Menu("Сальдо", "/head_nurse/saldo.s", "fa fa-briefcase fa-fw", session.getCurUrl().equals("/head_nurse/saldo.s")));
      if(user.isMainNurse() || user.isStatExp()) {
        m.add(new Menu("Стационар", "/head_nurse/out/patient.s", "fa fa-th-list fa-fw", session.getCurUrl().equals("/head_nurse/out/patient.s")));
        m.add(new Menu("Новые назначения", "/head_nurse/new_drugs.s", "fa fa-th-list fa-fw", session.getCurUrl().equals("/head_nurse/new_drugs.s")));
      }
      //m.add(new Menu("Амбулатория", "/head_nurse/out/amb.s", "fa fa-th-list fa-fw", session.getCurUrl().equals("/head_nurse/out/amb.s")));
      m.add(new Menu("Расход", "/head_nurse/out.s", "fa fa-file-text fa-users", session.getCurUrl().equals("/head_nurse/out.s")));
      if(isTransfer || session.getUserId() == 1)
        m.add(new Menu("Перевод", "/head_nurse/transfer.s", "fa fa-folder-o fa-fw", session.getCurUrl().equals("/head_nurse/transfer.s")));
      m.add(new Menu("Приход", "/head_nurse/incomes.s", "fa fa-stack-overflow fa-fw", session.getCurUrl().equals("/head_nurse/incomes.s")));
      if(user.isMainNurse()) {
        m.add(new Menu("Пациенты", "/head_nurse/total/patients.s", "fa fa-barcode fa-fw", session.getCurUrl().equals("/head_nurse/total/patients.s")));
        m.add(new Menu("Новые медикаменты", "/head_nurse/new_income_drugs.s", "fa fa-folder-o fa-fw", session.getCurUrl().equals("/head_nurse/new_income_drugs.s")));
      }
    }
    if(roleId == 20) {
      session.setCurUrl(session.getCurUrl().equals("") ? "/act/index.s" : session.getCurUrl());
      m.add(new Menu("Пациенты", "/act/index.s", "fa fa-group fa-fw", session.getCurUrl().equals("/act/index.s")));
    }
    if(roleId == 21) {
      session.setCurUrl(session.getCurUrl().equals("") ? "/cashbox/statistic.s" : session.getCurUrl());
      m.add(new Menu("Касса", "/cashbox/statistic.s", "fa fa-group fa-fw", session.getCurUrl().equals("/cashbox/statistic.s")));
      m.add(new Menu("Медикаменты", "/mn/drugs.s", "fa fa-th-list fa-fw", session.getCurUrl().equals("/mn/drugs.s")));
      m.add(new Menu("Анализ склада", "/mn/analys.s", "fa fa-th-list fa-fw", session.getCurUrl().equals("/mn/analys.s")));
      m.add(new Menu("Анализ медикаметов", "/mn/drugs/days.s", "fa fa-th-list fa-fw", session.getCurUrl().equals("/mn/drugs/days.s")));
      m.add(new Menu("Рейтинг услуг", "/mn/services.s", "fa fa-edit fa-fw", session.getCurUrl().equals("/mn/services.s")));
      m.add(new Menu("Рейтинг по врачам", "/mn/users.s", "fa fa-edit fa-fw", session.getCurUrl().equals("/mn/users.s")));
      m.add(new Menu("Аптека", "/mn/drugstore.s", "fa fa-group fa-fw", session.getCurUrl().equals("/mn/drugstore.s")));
      m.add(new Menu("Склад", "/mn/stores.s", "fa fa-home fa-fw", session.getCurUrl().equals("/mn/stores.s")));
      m.add(new Menu("Стационар", "/patients/stat.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/patients/stat.s")));
      m.add(new Menu("Склад: Простой", "/mn/drug_downtime.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/patients/stat.s")));
    }
    if(roleId == 22) {
      session.setCurUrl(session.getCurUrl().equals("") ? "/ambs/reg.s" : session.getCurUrl());
      m.add(new Menu("Регистрация", "/ambs/reg.s", "fa fa-edit fa-fw", session));
      m.add(new Menu("Текущие", "/ambs/patients.s", "fa fa-group fa-fw", session));
      m.add(new Menu("Клиенты", "/clients/list.s", "fa fa-group fa-fw", session));
      m.add(new Menu("Архив", "/ambs/archive.s", "fa fa-group fa-fw", session));
    }
    if(roleId == 23) {
      session.setCurUrl(session.getCurUrl().equals("") ? "/ambs/patients.s" : session.getCurUrl());
      m.add(new Menu("Текущие", "/ambs/patients.s", "fa fa-group fa-fw", session));
      m.add(new Menu("Архив", "/ambs/archive.s", "fa fa-group fa-fw", session));
    }
    if(roleId == 24) {
      session.setCurUrl(session.getCurUrl().equals("") ? "/ambs/patients.s" : session.getCurUrl());
      m.add(new Menu("Текущие", "/ambs/patients.s", "fa fa-group fa-fw", session));
      m.add(new Menu("Архив", "/ambs/archive.s", "fa fa-group fa-fw", session));
    }
    if(roleId == 25) { // Дежурный врач
      session.setCurUrl(session.getCurUrl().equals("") ? "/patients/list.s" : session.getCurUrl());
      m.add(new Menu("Пациенты", "/patients/list.s", "fa fa-align-justify fa-fw", session.getCurUrl().equals("/patients/list.s")));
      m.add(new Menu("Архив", "/patients/archive.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/archive/list.s")));
    }
    if(roleId == 26) { // Сотрудники
      session.setCurUrl(session.getCurUrl().equals("") ? "/emp/index.s" : session.getCurUrl());
      m.add(new Menu("Сотрудники", "/emp/index.s", "fa fa-align-justify fa-fw", session));
    }
    model.addAttribute("menuList", m);
    model.addAttribute("lvs", beanUsers.getLvs());
    model.addAttribute("groups", beanSession.getAmbGroups());
    model.addAttribute("depts", beanSession.getDepts());
    model.addAttribute("repList", dUser.getReports(session.getUserId()));
    model.addAttribute("openPage", roleId == 0 ? "/roles.s" : session.getCurUrl().equals("") ? dRole.get(roleId).getUrl() : session.getCurUrl());
    model.addAttribute("showMenu", (m.size() > 0 && session.getCurPat() == 0) || session.getRoleId() == 7 || session.getRoleId() == 3 || session.getRoleId() == 4 || session.getRoleId() == 15 || session.getRoleId() == 14 || session.getRoleId() == 13 || session.getRoleId() == 22 || session.getRoleId() == 23 || session.getRoleId() == 24 || session.getRoleId() == 26);
    model.addAttribute("showSearch", roleId != 0 && roleId != 1 && roleId != 10 && roleId != 22 && roleId != 23 && roleId != 24 && roleId != 26);
    model.addAttribute("isEnterFilter", beanSession.getParam("FILTER_WITH_ENTER").equals("Y"));
    model.addAttribute("session", session);
    model.addAttribute("clinicName", beanSession.getParam("CLINIC_NAME"));

    List<Users> users = beanUsers.getUsers();
    model.addAttribute("users", users);
    return "index";
  }

  @RequestMapping("/login.s")
  protected String login(@ModelAttribute("loginForm") Login auth, Model model){
    model.addAttribute("login", Util.getUI("login"));
    model.addAttribute("password", Util.getUI("password"));
    model.addAttribute("debug", beanSession.getParam("IS_DEBUG").equals("Y"));
    return "login";
  }

  @RequestMapping("/setRole.s")
  protected String setRole(HttpServletRequest request){
    try {
      Session session = SessionUtil.getUser(request);
      if(session == null) return "redirect:/login.s";
      session.setRoleId(Req.getInt(request, "id"));
      session.setCurUrl("");
      session.setCurPat(0);
      SessionUtil.setUser(request, session);
      return "redirect:/main.s";
    }catch(Exception e) {
      return "redirect:/login.s";
    }
  }

  @RequestMapping("/roles.s")
  protected String roles(HttpServletRequest req, Model model){
    Session session = SessionUtil.getUser(req);
    model.addAttribute("roles", sUser.getUserRoles(session.getUserId()));
    return "roles";
  }

  @RequestMapping("/boss.s")
  protected String boss(HttpServletRequest req, Model model){
    Session session = SessionUtil.getUser(req);
    return "boss/boss";
  }

  @RequestMapping(value = "/boss/data.s", method = RequestMethod.POST)
  protected void boss_(HttpServletRequest req, HttpServletResponse res) throws IOException {
    Session session = SessionUtil.getUser(req);
    String tab = req.getParameter("tab");

    String db = Util.get(req, "from");
    String de = Util.get(req, "to");
    String fdb = Util.get(req, "prevFrom");
    String fde = Util.get(req, "prevTo");
    JSONObject json = new JSONObject(); // данные вкладки
    res.setContentType("application/json;charset=UTF-8");
    res.setCharacterEncoding("UTF-8");

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      conn = DB.getConnection();
      if(tab.equals("sum")) {
        JSONObject summary = new JSONObject();
        JSONObject cur = new JSONObject();
        JSONObject prev = new JSONObject();
        for(int i=0;i < 2; i++) {
          ps = conn.prepareStatement(
            "Select Sum(case When t.amb_stat = 'AMB' Then t.summ else 0 End) amb, " +
              "         Sum(case When t.amb_stat = 'STAT' Then t.summ else 0 End) stat, " +
              "         (Select ifnull(Sum(d.summ), 0) From Cash_Discounts d Where d.ambStat = 'STAT' And date(d.crOn) Between ? And ?) cash_discount," +
              "         (Select ifnull(Sum(f.disSum), 0) From Hn_Patients f Where f.dateEnd Between ? And ?) disSum, " +
              "         (Select ifnull(Sum(f.totalSum), 0) From Hn_Patients f Where f.dateEnd Between ? And ?) totalSum " +
              "  From Dwh_Cashboxs t " +
              " Where t.oper_day Between ? And ? ");
          ps.setString(1, Util.dateDB(i == 0 ? db : fdb));
          ps.setString(2, Util.dateDB(i == 0 ? de : fde));
          ps.setString(3, Util.dateDB(i == 0 ? db : fdb));
          ps.setString(4, Util.dateDB(i == 0 ? de : fde));
          ps.setString(5, Util.dateDB(i == 0 ? db : fdb));
          ps.setString(6, Util.dateDB(i == 0 ? de : fde));
          ps.setString(7, Util.dateDB(i == 0 ? db : fdb));
          ps.setString(8, Util.dateDB(i == 0 ? de : fde));
          rs = ps.executeQuery();
          if (rs.next()) {
            if(i == 0) {
              cur.put("cash", rs.getDouble("amb") + rs.getDouble("stat"));
              cur.put("amb", rs.getDouble(1));
              cur.put("stat", rs.getDouble(2));
              cur.put("cash_discount", rs.getDouble(3));
              cur.put("dis_sum", rs.getDouble(4));
              cur.put("total_sum", rs.getDouble(5));
            } else {
              prev.put("cash", rs.getDouble("amb") + rs.getDouble("stat"));
              prev.put("amb", rs.getDouble(1));
              prev.put("stat", rs.getDouble(2));
              prev.put("cash_discount", rs.getDouble(3));
              prev.put("dis_sum", rs.getDouble(4));
              prev.put("total_sum", rs.getDouble(5));
            }
          }
          ps = conn.prepareStatement("Select Count(*) Counter, Sum(t.drugSum) drugSum From Hn_Patients t Where t.dateEnd Between ? And ?");
          ps.setString(1, Util.dateDB(i == 0 ? db : fdb));
          ps.setString(2, Util.dateDB(i == 0 ? de : fde));
          rs = ps.executeQuery();
          if (rs.next()) {
            if(i == 0) {
              cur.put("discharged", rs.getDouble(1));
              cur.put("drugs", rs.getDouble(2));
            } else {
              prev.put("discharged", rs.getDouble(1));
              prev.put("drugs", rs.getDouble(2));
            }
          }
          ps = conn.prepareStatement("Select count(*) From amb_patients t Where date(t.crOn) between ? And ? ");
          ps.setString(1, Util.dateDB(i == 0 ? db : fdb));
          ps.setString(2, Util.dateDB(i == 0 ? de : fde));
          rs = ps.executeQuery();
          if (rs.next()) {
            if(i == 0) cur.put("ambRegs", rs.getDouble(1));
            else prev.put("ambRegs", rs.getDouble(1));
          }
        }
        summary.put("cur", cur);
        summary.put("prev", prev);
        json.put("summary", summary);
        //
        JSONObject beds =  new JSONObject();
        ps = conn.prepareStatement(
          "Select Sum(t.koykoLimit) total, " +
          "  (Select Count(*) From Patients t Where t.state = 'LV') occupied, " +
          "  0 booked " +
          "  From rooms t");
        rs = ps.executeQuery();
        if (rs.next()) {
          beds.put("total", rs.getDouble(1));
          beds.put("occupied", rs.getDouble(2));
          beds.put("booked", rs.getDouble(3));
        }
        json.put("beds", beds);
        //
        JSONArray months =  new JSONArray();
        for(int i=0;i<12;i++) {
          Date d = new Date();
          Calendar cal = Calendar.getInstance();
          cal.setTime(d);
          cal.add(Calendar.MONTH, -i);
          Date ld = cal.getTime();
          String dd = Util.dateDB(ld);

          JSONObject m = new JSONObject();
          ps = conn.prepareStatement(
            "Select Sum(case When t.amb_stat = 'AMB' Then t.Summ Else 0 End) amb, " +
              "         Sum(case When t.amb_stat = 'STAT' Then t.Summ Else 0 End) stat " +
              "  From Dwh_Cashboxs t " +
              " Where DATE_FORMAT(t.oper_day, '%Y-%m-01') = DATE_FORMAT(?, '%Y-%m-01')");
          ps.setString(1, dd);
          rs = ps.executeQuery();
          if (rs.next()) {
            m.put("ym", dd.substring(0, 7));
            m.put("amb", rs.getDouble(1));
            m.put("stat", rs.getDouble(2));
          }
          ps = conn.prepareStatement("Select Count(*) Counter From Hn_Patients t Where DATE_FORMAT(t.dateEnd, '%Y-%m-01') = DATE_FORMAT(?, '%Y-%m-01')");
          ps.setString(1, dd);
          rs = ps.executeQuery();
          if(rs.next()) {
            m.put("discharged", rs.getDouble(1));
          }
          ps = conn.prepareStatement("Select count(*) From amb_patients t Where DATE_FORMAT(t.crOn, '%Y-%m-01') = DATE_FORMAT(?, '%Y-%m-01') ");
          ps.setString(1, dd);
          rs = ps.executeQuery();
          if (rs.next()) {
            m.put("ambRegs", rs.getDouble(1));
          }
          months.put(m);
        }
        json.put("months", months);
        //
        JSONObject debts =  new JSONObject();
        JSONArray actSections = new JSONArray();
        JSONObject bed = new JSONObject(); // Койко дней
        JSONObject svc = new JSONObject(); // KDO
        JSONObject lab = new JSONObject(); // LAB
        JSONObject drug = new JSONObject(); // DRUG
        JSONObject spec = new JSONObject(); // Consul
        JSONObject extra = new JSONObject(); // Watcher
        JSONObject food = new JSONObject(); // EatSum
        ps = conn.prepareStatement(
          "Select ifnull(Sum(t.koykoSum), 0) koykoSum, " +
            "         ifnull(Sum(t.kdoSum), 0) kdoSum, " +
            "         ifnull(Sum(t.labSum), 0) labSum, " +
            "         ifnull(Sum(t.drugSum), 0) drugSum, " +
            "         ifnull(Sum(t.consulSum), 0) consulSum, " +
            "         ifnull(Sum(t.watcherSum), 0) watcherSum, " +
            "         ifnull(Sum(t.eatSum), 0) eatSum," +
            "         Sum(Case When t.paySum > 0 Then 1 Else 0 End) debt_count, " +
            "         Sum(Case When t.paySum > 0 Then t.paySum Else 0 End) debt_sum " +
            "    From Hn_Patients t Where t.dateEnd Between ? And ? "
        );
        ps.setString(1, Util.dateDB(db));
        ps.setString(2, Util.dateDB(de));
        rs = ps.executeQuery();
        if (rs.next()) {
          bed.put("cur", rs.getDouble("koykoSum"));
          svc.put("cur", rs.getDouble("kdoSum"));
          lab.put("cur", rs.getDouble("labSum"));
          drug.put("cur", rs.getDouble("drugSum"));
          spec.put("cur", rs.getDouble("consulSum"));
          extra.put("cur", rs.getDouble("watcherSum"));
          food.put("cur", rs.getDouble("eatSum"));
          debts.put("count", rs.getDouble("debt_count"));
          debts.put("sum", rs.getDouble("debt_sum"));
        }
        ps = conn.prepareStatement(
          "Select ifnull(Sum(t.koykoSum), 0) koykoSum, " +
            "         ifnull(Sum(t.kdoSum), 0) kdoSum, " +
            "         ifnull(Sum(t.labSum), 0) labSum, " +
            "         ifnull(Sum(t.drugSum), 0) drugSum, " +
            "         ifnull(Sum(t.consulSum), 0) consulSum, " +
            "         ifnull(Sum(t.watcherSum), 0) watcherSum, " +
            "         ifnull(Sum(t.eatSum), 0) eatSum " +
            "    From Hn_Patients t Where t.dateEnd Between ? And ? "
        );
        ps.setString(1, Util.dateDB(fdb));
        ps.setString(2, Util.dateDB(fde));
        rs = ps.executeQuery();
        if (rs.next()) {
          bed.put("prev", rs.getDouble("koykoSum"));
          svc.put("prev", rs.getDouble("kdoSum"));
          lab.put("prev", rs.getDouble("labSum"));
          drug.put("prev", rs.getDouble("drugSum"));
          spec.put("prev", rs.getDouble("consulSum"));
          extra.put("prev", rs.getDouble("watcherSum"));
          food.put("prev", rs.getDouble("eatSum"));
        }
        json.put("debts", debts);
        bed.put("code", "bed");
        bed.put("name", "Койко дней");
        actSections.put(bed);
        svc.put("code", "svc");
        svc.put("name", "Медицинские услуги");
        actSections.put(svc);
        lab.put("code", "lab");
        lab.put("name", "Лабораторные исследования");
        actSections.put(lab);
        drug.put("code", "drug");
        drug.put("name", "Медикаменты");
        actSections.put(drug);
        spec.put("code", "spec");
        spec.put("name", "Узкие специалисты");
        actSections.put(spec);
        extra.put("code", "extra");
        extra.put("name", "Дополнительное место");
        actSections.put(extra);
        food.put("code", "food");
        food.put("name", "Питание");
        actSections.put(food);
        json.put("actSections", actSections);
      }
      if(tab.equals("cash")) {
        JSONArray payTypes = new JSONArray();
        JSONObject cash = new JSONObject();
        JSONObject card = new JSONObject();
        JSONObject transfer = new JSONObject();
        JSONObject online = new JSONObject();
        cash.put("code", "cash");
        card.put("code", "card");
        transfer.put("code", "transfer");
        online.put("code", "online");
        cash.put("name", "Наличные");
        card.put("name", "Пластик");
        transfer.put("name", "Перечисление");
        online.put("name", "Онлайн");
        ps = conn.prepareStatement(
          "Select Sum(case When t.pay_type = 'cash' Then t.summ else 0 End) cash, " +
            "         Sum(case When t.pay_type = 'card' Then t.summ else 0 End) card, " +
            "         Sum(case When t.pay_type = 'transfer' Then t.summ else 0 End) transfer, " +
            "         Sum(case When t.pay_type = 'online' Then t.summ else 0 End) online " +
            "  From Dwh_Cashboxs t " +
            " Where t.oper_day Between ? And ? ");
        ps.setString(1, Util.dateDB(db));
        ps.setString(2, Util.dateDB(de));
        rs = ps.executeQuery();
        if (rs.next()) {
          cash.put("sum", rs.getDouble(1));
          card.put("sum", rs.getDouble(2));
          transfer.put("sum", rs.getDouble(3));
          online.put("sum", rs.getDouble(4));
        }
        payTypes.put(cash);
        payTypes.put(card);
        payTypes.put(transfer);
        payTypes.put(online);
        json.put("payTypes", payTypes);
        JSONArray discounts = new JSONArray();
        JSONObject staff = new JSONObject();
        JSONObject manual = new JSONObject();
        JSONObject benefit = new JSONObject();
        JSONObject packages = new JSONObject();
        DB.done(ps);
        DB.done(rs);
        ps = conn.prepareStatement(
          "Select ifnull(Sum(Round(d.price * (1+ifnull(t.ndsProc, 0) / 100) / 100) * 100 - t.price), 0) " +
            "  From amb_patient_services t, Amb_Patients c, Amb_Services d " +
            " Where t.patient = c.id " +
            "   And c.emp is not null " +
            "  And t.confDate Is Not Null " +
            "  And d.id = t.service_Id " +
            "  And t.crOn Between ? And ? ");
        ps.setString(1, Util.dateDBBegin(db));
        ps.setString(2, Util.dateDBEnd(de));
        rs = ps.executeQuery();
        if (rs.next()) staff.put("sum", rs.getDouble(1));
        DB.done(ps);
        DB.done(rs);
        ps = conn.prepareStatement("Select ifnull(Sum(t.summ), 0) From cash_discounts t Where date(t.crOn) between ? And ? ");
        ps.setString(1, Util.dateDB(db));
        ps.setString(2, Util.dateDB(de));
        rs = ps.executeQuery();
        if (rs.next()) manual.put("sum", rs.getDouble(1));
        DB.done(ps);
        DB.done(rs);
        ps = conn.prepareStatement("Select ifnull(Sum(t.disSum), 0) From hn_patients t Where t.dateEnd between ? And ? ");
        ps.setString(1, Util.dateDB(db));
        ps.setString(2, Util.dateDB(de));
        rs = ps.executeQuery();
        if (rs.next()) benefit.put("sum", rs.getDouble(1));
        DB.done(ps);
        DB.done(rs);
        ps = conn.prepareStatement(
          "Select ifnull(Sum(Round(d.price * (1+ifnull(t.ndsProc, 0) / 100) / 100) * 100 - t.price), 0) " +
            "  From Amb_Patient_Services t, Amb_Patients c, amb_services d " +
            " Where t.patient = c.id " +
            "   And t.pack is not null " +
            "   And t.cashDate Is Not Null " +
            "   And d.id = t.service_Id " +
            "   And t.crOn Between ? And ? "
        );
        ps.setString(1, Util.dateDBBegin(db));
        ps.setString(2, Util.dateDBEnd(de));
        rs = ps.executeQuery();
        if (rs.next()) packages.put("sum", rs.getDouble(1));
        staff.put("code", "staff");      staff.put("name", "Сотрудники клиники");     staff.put("manual", false);
        manual.put("code", "manual");    manual.put("name", "Ручная скидка в кассе"); manual.put("manual", true);
        benefit.put("code", "benefit");  benefit.put("name", "Льготные категории");   benefit.put("manual", false);
        packages.put("code", "package"); packages.put("name", "Пакеты услуг");        packages.put("manual", false);
        discounts.put(staff);
        discounts.put(manual);
        discounts.put(benefit);
        discounts.put(packages);
        json.put("discounts", discounts);
        JSONArray cashiers = new JSONArray();
        DB.done(ps);
        DB.done(rs);
        ps = conn.prepareStatement(
          "Select g.fio, " +
            "       ifnull(Sum(g.ops), 0) ops, " +
            "       ifnull(Sum(g.ret_count), 0) ret_count, " +
            "       ifnull(Sum(g.ret_sum), 0) ret_sum, " +
            "       ifnull(Sum(g.discount), 0) discounts, " +
            "       ifnull(Sum(g.cash), 0) summ " +
            "  From ( " +
            "    Select (Select a.Fio From Users a Where a.id = t.crBy) fio, " +
            "           Sum(case When t.payType = 'pay' Then t.cash + t.card + t.transfer + t.online else 0 End) cash, " +
            "           Sum(case When t.payType != 'pay' Then t.cash + t.card + t.transfer + t.online else 0 End) ret_sum, " +
            "           Sum(case When t.payType = 'pay' Then 1 else 0 End) ops, " +
            "           Sum(case When t.payType != 'pay' Then 1 else 0 End) ret_count, " +
            "           (Select ifnull(Sum(d.summ), 0) From cash_discounts d Where d.crOn between ? And ? And d.ambStat = 'AMB' And d.crBy_Id = t.crBy) discount " +
            "      From amb_patient_pays t " +
            "     Where t.crOn between ? And ? " +
            "     GROUP BY t.crBy " +
            "    Union All " +
            "    Select (Select a.Fio From Users a Where a.id = t.crBy) fio, " +
            "           Sum(case When t.payType = 'pay' Then t.cash + t.card + t.transfer + t.online else 0 End) cash, " +
            "           Sum(case When t.payType != 'pay' Then t.cash + t.card + t.transfer + t.online else 0 End) ret_sum, " +
            "           Sum(case When t.payType = 'pay' Then 1 else 0 End) ops, " +
            "           Sum(case When t.payType != 'pay' Then 1 else 0 End) ret_count, " +
            "           (Select ifnull(Sum(d.summ), 0) From cash_discounts d Where d.crOn between ? And ? And d.ambStat = 'STAT' And d.crBy_Id = t.crBy) discount " +
            "      From patient_pays t " +
            "     Where t.crOn between ? And ? " +
            "     GROUP BY t.crBy " +
            "    ) g " +
            "  Group By g.fio "
        );
        ps.setString(1, Util.dateDBBegin(db));
        ps.setString(2, Util.dateDBEnd(de));
        ps.setString(3, Util.dateDBBegin(db));
        ps.setString(4, Util.dateDBEnd(de));
        ps.setString(5, Util.dateDBBegin(db));
        ps.setString(6, Util.dateDBEnd(de));
        ps.setString(7, Util.dateDBBegin(db));
        ps.setString(8, Util.dateDBEnd(de));
        rs = ps.executeQuery();
        while (rs.next()) {
          JSONObject a = new JSONObject();
          a.put("name", rs.getString(1));
          a.put("ops", rs.getString("ops"));
          a.put("returns", rs.getString("ret_count"));
          a.put("returnsSum", rs.getString("ret_sum"));
          a.put("discounts", rs.getString("discounts"));
          a.put("sum", rs.getString("summ"));
          cashiers.put(a);
        }
        json.put("cashiers", cashiers);
      }
      if(tab.equals("amb")) {
        JSONArray flow = new JSONArray();
        ps = conn.prepareStatement(
          "Select t.state," +
            "         Count(*) counter" +
            "  From Amb_Patients t " +
            " Where date(t.crOn) = CURRENT_DATE() " +
            " Group By t.state ");
        rs = ps.executeQuery();
        while (rs.next()) {
          JSONObject a = new JSONObject();
          a.put("code", "PRN");
          if(rs.getString("state").equals("PRN")) a.put("name", "Регистрация");
          if(rs.getString("state").equals("CASH")) a.put("name", "Ожидание оплаты");
          if(rs.getString("state").equals("WORK")) a.put("name", "Оказание услуг");
          if(rs.getString("state").equals("DONE")) a.put("name", "Услуги оказаны");
          if(rs.getString("state").equals("ARCH")) a.put("name", "Закрыта сегодня");
          a.put("count", rs.getInt("counter"));
          flow.put(a);
        }
        json.put("flow", flow);
        JSONArray groups = new JSONArray();
        ps = conn.prepareStatement(
          "Select a.name, " +
            "         Sum(t.price + t.nds) summ " +
            "  From amb_patient_services t, Amb_Services c, amb_groups a " +
            " Where t.service_Id = c.id " +
            "   And a.id = c.group_Id " +
            "   And t.crOn Between ? And ? " +
            "  Group By a.name ");
        ps.setString(1, Util.dateDBBegin(db));
        ps.setString(2, Util.dateDBEnd(de));
        rs = ps.executeQuery();
        while (rs.next()) {
          JSONObject a = new JSONObject();
          a.put("name", rs.getString(1));
          a.put("sum", rs.getDouble("summ"));
          groups.put(a);
        }
        json.put("groups", groups);
        ps = conn.prepareStatement(
          "Select Sum(case When c.counteryId = 199 Then 1 Else 0 End) residents, " +
            "       Sum(case When c.counteryId != 199 Then 1 Else 0 End) foreigners, " +
            "       Sum(case When c.counteryId != 199 Then t.price + t.nds Else 0 End) foreignersSum, " +
            "       Sum(t.price + t.nds) ambSum " +
            "  From amb_patient_services t, Amb_Patients c " +
            " Where t.patient = c.id " +
            "   And t.crOn Between ? And ? ");
        ps.setString(1, Util.dateDBBegin(db));
        ps.setString(2, Util.dateDBEnd(de));
        rs = ps.executeQuery();
        JSONObject residents = new JSONObject();
        if (rs.next()) {
          residents.put("residents", rs.getInt("residents"));
          residents.put("foreigners", rs.getInt("foreigners"));
          residents.put("foreignersSum", rs.getDouble("foreignersSum"));
          residents.put("ambSum", rs.getDouble("ambSum"));
        }
        json.put("waitingLong", 0);
        json.put("residents", residents);
      }
      if(tab.equals("")) {

      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn, ps, rs);
    }
    res.getWriter().write(json.toString());
  }

  @RequestMapping(value = "/login.s", method = RequestMethod.POST)
  protected String loginPost(@ModelAttribute("loginForm") Login auth, Errors errors, HttpServletRequest request, Model model){
    ValidationUtils.rejectIfEmptyOrWhitespace(errors, "login", "login.isEmpty", "Field name is required.");
    ValidationUtils.rejectIfEmptyOrWhitespace(errors, "password", "password.isEmpty", "Password must not be empty.");
    Session session = sUser.login(request);
    if(session == null && !errors.hasErrors())
      errors.rejectValue("login", "authError", "Field name is required.");
    if(session != null && !errors.hasErrors()) {
      if(session.getUserId() == -1)
        errors.rejectValue("login", "ip_error", "Отказано в доступе с этого компьютера");
    }
    if (errors.hasErrors()) {
      model.addAttribute("login", Util.getUI("login"));
      model.addAttribute("password", Util.getUI("password"));
      return "login";
    }
    SessionUtil.setUser(request, session);
    return "redirect:/main.s";
  }

  @RequestMapping("/out.s")
  protected String out(HttpServletRequest req) throws Exception {
    SessionUtil.kill(req);
    return "redirect:/login.s";
  }

  @RequestMapping(value = "/user_login.s", method = RequestMethod.POST)
  @ResponseBody
  protected String loginPost(HttpServletRequest request) {
    JSONObject json = new JSONObject();
    try {
      Session session = sUser.login(request);
      if(session == null) {
        json.put("msg", "Ошибка в паре логин - Пароль!");
        json.put("success", false);
        return json.toString();
      }
      SessionUtil.setUser(request, session);
      json.put("success", true);
    } catch (Exception e) {
      e.printStackTrace();
    }
    return json.toString();
  }

  @RequestMapping(value = "test.s", method = RequestMethod.POST)
  protected String test(MultipartHttpServletRequest request){
    Iterator<String> req = request.getFileNames();
    List<MultipartFile> files = request.getFiles("files");
    return "redirect:/login.s";
  }

  @Scheduled(fixedRate=5000)
  public void ScheduledFixedRate(){
    System.out.println("I will execute after evey 5 seconds");
  }

  @RequestMapping("/random_data.s")
  protected String login() {
    /*List<Users> users = dUser.getAll();
    for(Users user: users) {
      if(user.getId() != 1) {
        user.setFio(Util.randomLetter(user.getFio()));
        user.setPassword("C4CA4238A0B923820DCC509A6F75849B");
        user.setLogin("user" + user.getId());
        dUser.save(user);
      }
    }
    List<Kdos> kdos = dKdo.getAll();
    for(Kdos kdo : kdos) {
      kdo.setPrice(100D);
      kdo.setFor_price(100D);
      dKdo.save(kdo);
    }
    List<AmbServices> services = dAmbService.getAll();
    for(AmbServices service: services) {
      service.setPrice(200D);
      service.setFor_price(200D);
      dAmbService.save(service);
    }
    List<KdoChoosens> kdoChoosens = dKdoChoosen.getAll();
    for(KdoChoosens kdoChoosen: kdoChoosens) {
      kdoChoosen.setPrice(300D);
      kdoChoosen.setFor_price(300D);
      dKdoChoosen.save(kdoChoosen);
    }
    List<Patients> patients = dPatient.getAll();
    for(Patients patient: patients) {
      patient.setName(Util.randomLetter(patient.getName()));
      patient.setSurname(Util.randomLetter(patient.getSurname()));
      patient.setMiddlename(Util.randomLetter(patient.getMiddlename()));
      patient.setAddress("");
      patient.setWork("");
      patient.setTel("");
      patient.setPassportInfo("");
      patient.setAmbNum("");
      patient.setPost("");
      dPatient.save(patient);
    }
    List<AmbPatients> ambPatients = dAmbPatient.getAll();
    for(AmbPatients ambPatient: ambPatients) {
      ambPatient.setName(Util.randomLetter(ambPatient.getName()));
      ambPatient.setSurname(Util.randomLetter(ambPatient.getSurname()));
      ambPatient.setMiddlename(Util.randomLetter(ambPatient.getMiddlename()));
      ambPatient.setAddress("");
      ambPatient.setTel("");
      ambPatient.setPassportInfo("");
      dAmbPatient.save(ambPatient);
    }
    List<LvConsuls> consuls = dLvConsul.getAll();
    for(LvConsuls consul:consuls) {
      consul.setLvName(Util.randomLetter(consul.getLvName()));
      dLvConsul.save(consul);
    }
    List<Drugs> drugs = dDrug.getAll();
    for(Drugs drug: drugs) {
      drug.setPrice(500D);
      dDrug.save(drug);
    }
    List<DrugSaldos> saldos = dDrugSaldo.getAll();
    for(DrugSaldos saldo: saldos) {
      saldo.setPrice(600D);
      dDrugSaldo.save(saldo);
    }
    List<DrugActDrugs> actDrugs = dDrugActDrug.getAll();
    for(DrugActDrugs actDrug: actDrugs) {
      actDrug.setPrice(800D);
      dDrugActDrug.save(actDrug);
    }
    List<DrugOutRows> drugOutRows = dDrugOutRow.getAll();
    for(DrugOutRows drugOutRow: drugOutRows) {
      drugOutRow.setPrice(800D);
      dDrugOutRow.save(drugOutRow);
    }
    List<HNPatientKdos> hnPatientKdos = dHNPatientKdo.getAll();
    for(HNPatientKdos hnPatientKdo: hnPatientKdos) {
      hnPatientKdo.setPrice(1000D);
      dHNPatientKdo.save(hnPatientKdo);
    }
    List<HNPatientDrugs> hnPatientDrugs = dHNPatientDrug.getAll();
    for(HNPatientDrugs hnPatientDrug: hnPatientDrugs) {
      hnPatientDrug.setPrice(1100D);
      dHNPatientDrug.save(hnPatientDrug);
    }
    List<PatientPays> pays = dPatientPay.getAll();
    for(PatientPays pay: pays) {
      pay.setCard(5600D);
      pay.setCash(5600D);
      pay.setTransfer(5600D);
      dPatientPay.save(pay);
    }
    List<AmbPatientPays> ambPatientPays = dAmbPatientPay.getAll();
    for(AmbPatientPays ambPatientPay: ambPatientPays) {
      ambPatientPay.setCard(5600D);
      ambPatientPay.setCash(5600D);
      ambPatientPay.setTransfer(5600D);
      dAmbPatientPay.save(ambPatientPay);
    }*/
    return "redirect:/login.s";
  }

  @RequestMapping("/rrr.s")
  protected String rrr() throws Exception {
    String[] commands = {"cmd", "/c", "mysqldump -uroot -proot fm > D:\\dump\\" + Util.getCurDate().replace(".", "") + ".sql"};
    Process pb = Runtime.getRuntime().exec(commands);
    pb.waitFor();
    byte[] buf = new byte[1024];
    File f = new File("D:\\dump\\" + Util.getCurDate().replace(".", "") + ".zip");
    ZipOutputStream out = new ZipOutputStream(new FileOutputStream(f));
    out.setLevel(Deflater.BEST_COMPRESSION);
    File entity = new File("D:\\dump\\" + Util.getCurDate().replace(".", "") + ".sql");
    InputStream in = new FileInputStream(entity);
    out.putNextEntry(new ZipEntry(entity.getName()));
    int len;
    while ((len = in.read(buf)) > 0) {
      out.write(buf, 0, len);
    }
    // Complete the entry
    out.closeEntry();
    in.close();
    out.close();
    File file = new File("D:\\dump\\" + Util.getCurDate().replace(".", "") + ".sql");
    file.delete();
    return "test";
  }

  @RequestMapping("/loganalys.s")
  protected String ddd(Model model) {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    List<String> exceptions = new ArrayList<>();
    List<String> likes = new ArrayList<>();
    try {
      conn = DB.getConnection();
      ps = conn.prepareStatement("Select * From log_exceptions");
      rs = ps.executeQuery();
      while (rs.next()) exceptions.add(rs.getString("name").replaceAll(" ", ""));

      ps = conn.prepareStatement("Select * From log_exception_likes");
      rs = ps.executeQuery();
      while (rs.next()) likes.add(rs.getString("name").replaceAll(" ", ""));

      File file = new File("C:\\mysql_logs\\mysql-slow.log");
      BufferedReader br = new BufferedReader(new InputStreamReader(Files.newInputStream(file.toPath()), StandardCharsets.UTF_8));
      String st, time = "", queryTime = "", qt = "", lockTime, rowSent, rowsExamined;
      List<String> rws = new ArrayList<>();
      int i = 0;
      String line = "";
      ps = conn.prepareStatement("Delete t From log_slows t");
      ps.executeUpdate();
      while (line != null) {
        line = br.readLine();
        if(line == null) break;
        if(!exceptions.contains(line.trim().replaceAll(" ", ""))) {
          boolean isOK = true;
          for(String like: likes) {
            if(line.toLowerCase().replaceAll(" ", "").contains(like.toLowerCase()))
              isOK = false;
          }
          if(!isOK) {
            if(!line.contains("SET timestamp="))
              queryTime = "";
            continue;
          }
          if(line.contains("# Time")) {
            time = line.replaceAll("# Time: ", "");
            continue;
          }
          if(line.contains("# Query_time")) {
            queryTime = line;
            continue;
          }
          if(queryTime.isEmpty()) continue;
          st = queryTime;
          st = st.substring(14);
          qt = st.substring(0, st.indexOf(" "));
          st = st.substring(st.indexOf("Lock_time:") + 11);
          lockTime = st.substring(0, st.indexOf(" "));
          st = st.substring(st.indexOf("Rows_sent:") + 11);
          rowSent = st.substring(0, st.indexOf(" "));
          st = st.substring(st.indexOf("Rows_examined:") + 15);
          rowsExamined = st.substring(0);
          ps = conn.prepareStatement("Insert into log_slows(query, date_time, query_time, lock_time, row_sent, row_examined) Values(?, ?, ?, ?, ?, ?)");
          ps.setString(1, line);
          ps.setString(2, time);
          ps.setInt(3, Integer.parseInt(qt));
          ps.setInt(4, Integer.parseInt(lockTime));
          ps.setInt(5, Integer.parseInt(rowSent));
          ps.setInt(6, Integer.parseInt(rowsExamined));
          ps.executeUpdate();
          //rws.add(i + ". " + time + " _ " + queryTime );
          i++;
          /*if(i > 10000) break;*/
        } else {
          queryTime = "";
        }
      }
      model.addAttribute("rows", rws);
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(rs);
      DB.done(ps);
      DB.done(conn);
    }
    return "logfile";
  }

  @RequestMapping("/s.s")
  protected String sss() {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    //
    try {
      conn = DB.getConnection();
      ps = conn.prepareStatement("Select id From hn_clones");
      ps.execute();
      rs =  ps.getResultSet();
      while (rs.next()) {
        sPatient.act_calc(rs.getInt("id"));
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn, ps, rs);
    }
    return "redirect:main.s";
  }

}
