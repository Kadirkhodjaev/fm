package ckb.controllers;

import ckb.dao.admin.depts.DDept;
import ckb.dao.admin.params.DParam;
import ckb.dao.admin.roles.DRole;
import ckb.dao.admin.users.DUser;
import ckb.dao.admin.users.DUserDrugLine;
import ckb.dao.med.amb.DAmbGroup;
import ckb.dao.med.lv.consul.DLvConsul;
import ckb.domains.admin.Roles;
import ckb.domains.admin.UserDrugLines;
import ckb.domains.admin.Users;
import ckb.models.Login;
import ckb.models.Menu;
import ckb.services.admin.user.SUser;
import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.Req;
import ckb.utils.Util;
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
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.zip.Deflater;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

@Controller
@RequestMapping("/")
public class  CApp {

  @Autowired private SUser sUser;
  @Autowired private DUser dUser;
  @Autowired private DRole dRole;
  @Autowired private DLvConsul dLvConsul;
  @Autowired private DParam dParam;
  @Autowired private DDept dDept;
  @Autowired private DAmbGroup dAmbGroups;
  @Autowired private DUserDrugLine dUserDrugLine;

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
      m.add(new Menu("Стат группы", "/core/stat/groups.s", "fa fa-list-alt fa-fw", session));
      m.add(new Menu("Стат услуги", "/core/stat/services.s", "fa fa-list-alt fa-fw", session));
      m.add(new Menu("Детали лаб", "/core/stat/details.s", "fa fa-th fa-fw", session));
      m.add(new Menu("МКБ", "/mkb/admin.s", "fa fa-th fa-fw", session));
      m.add(new Menu("Отделении", "/admin/depts.s", "fa fa-th-list fa-fw", session));
      m.add(new Menu("Параметры", "/admin/price.s", "fa fa-th fa-fw", session));
      m.add(new Menu("Партнеры", "/admin/lvpartners.s", "fa fa-users fa-fw", session));
      m.add(new Menu("Протокол", "/admin/log.s", "fa fa-users fa-fw", session));
    }
    if(roleId == 3) { // Приемное – медсестра
      session.setCurUrl(session.getCurUrl().equals("") ? "/reg/nurse/index.s" : session.getCurUrl());
      m.add(new Menu("Регистрация", "/reg/nurse/index.s", "fa fa-edit fa-fw", session.getCurUrl().equals("/reg/nurse/index.s")));
      m.add(new Menu("Брон", "/booking/nurse.s", "fa fa-th fa-fw", session.getCurUrl().equals("/booking/nurse.s")));
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
      Long conCount = dLvConsul.getCount("From LvConsuls c Where c.text = null And c.lvId = " + session.getUserId());
      m.add(new Menu("Пациенты", "/patients/list.s", "fa fa-align-justify fa-fw", session.getCurUrl().equals("/patients/list.s")));
      m.add(new Menu("Консультация (" + conCount + ")", "/patients/consul.s", "fa fa-group fa-fw", session.getCurUrl().equals("/patients/consul.s")));
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
      //m.add(new Menu("Архив заявок", "/drugs/claims/archive.s", "fa fa-archive fa-edit", session.getCurUrl().equals("/drugs/claims/archive.s")));
      m.add(new Menu("Справочники", "/drugs/dicts.s", "fa fa-align-justify fa-fw", session.getCurUrl().equals("/drugs/dicts.s")));
    }
    if(roleId == 11) { // Постовой
      session.setCurUrl(session.getCurUrl().equals("") ? "/patients/list.s" : session.getCurUrl());
      m.add(new Menu("Статистика", "/head_nurse/stat.s", "fa fa-home fa-fw", session.getCurUrl().equals("/head_nurse/stat.s")));
      m.add(new Menu("Услуги", "/nurses/work.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/nurses/work.s")));
      m.add(new Menu("Пациенты", "/patients/list.s", "fa fa-align-justify fa-fw", session.getCurUrl().equals("/patients/list.s")));
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
      m.add(new Menu("Текущие", "/amb/home.s", "fa fa-group fa-fw", session.getCurUrl().equals("/amb/home.s")));
      m.add(new Menu("Архив", "/amb/archive.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/amb/archive.s")));
    }
    if(roleId == 15) { // Амбулаторная регистрация
      m.add(new Menu("Регистрация", "/amb/reg.s", "fa fa-edit fa-fw", session.getCurUrl().contains("/amb/reg.s")));
      m.add(new Menu("Текущие", "/amb/home.s", "fa fa-group fa-fw", session.getCurUrl().equals("/amb/home.s")));
      m.add(new Menu("Клиенты", "/client/list.s", "fa fa-group fa-fw", session.getCurUrl().equals("/client/list.s")));
      m.add(new Menu("Архив", "/amb/archive.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/amb/archive.s")));
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
      if(user.isMainNurse())
        m.add(new Menu("Пациенты", "/head_nurse/total/patients.s", "fa fa-barcode fa-fw", session.getCurUrl().equals("/head_nurse/total/patients.s")));
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
    model.addAttribute("menuList", m);
    model.addAttribute("lvs", dUser.getLvs());
    model.addAttribute("groups", dAmbGroups.getAll());
    model.addAttribute("depts", dDept.getAll());
    model.addAttribute("repList", dUser.getReports(session.getUserId()));
    model.addAttribute("openPage", roleId == 0 ? "/roles.s" : session.getCurUrl().equals("") ? dRole.get(roleId).getUrl() : session.getCurUrl());
    model.addAttribute("showMenu", (m.size() > 0 && session.getCurPat() == 0) || session.getRoleId() == 7 || session.getRoleId() == 3 || session.getRoleId() == 4 || session.getRoleId() == 15 || session.getRoleId() == 14 || session.getRoleId() == 13 || session.getRoleId() == 22 || session.getRoleId() == 23 || session.getRoleId() == 24);
    model.addAttribute("showSearch", roleId != 0 && roleId != 1 && roleId != 10 && roleId != 22 && roleId != 23 && roleId != 24);
    model.addAttribute("isEnterFilter", dParam.byCode("FILTER_WITH_ENTER").equals("Y"));
    model.addAttribute("session", session);
    model.addAttribute("clinicName", dParam.byCode("CLINIC_NAME"));
    return "index";
  }

  @RequestMapping("/login.s")
  protected String login(@ModelAttribute("loginForm") Login auth, Model model){
    model.addAttribute("login", Util.getUI("login"));
    model.addAttribute("password", Util.getUI("password"));
    model.addAttribute("debug", dParam.byCode("IS_DEBUG").equals("Y"));
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

}
