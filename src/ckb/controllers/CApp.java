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
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
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
  @Autowired private DUserDrugLine dUserDrugLine;
  @Autowired private BeanUsers beanUsers;
  @Autowired private BeanSession beanSession;
  @Autowired private SPatient sPatient;

  @RequestMapping({"/main.s", "/"})
  protected String mains(HttpServletRequest req, Model model) {
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
      m.add(new Menu("Палаты", "/proc/palatas.s", "fa fa-building-o fa-fw", session.getCurUrl().equals("/proc/palatas.s")));
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
      session.setCurUrl(session.getCurUrl().isEmpty() ? "/core/user/list.s" : session.getCurUrl());
      m.add(new Menu("Пользователи", "/core/user/list.s", "fa fa-users fa-fw", session));
      m.add(new Menu("Формы", "/core/form/list.s", "fa fa-file-text-o fa-fw", session));
      m.add(new Menu("Амбулатория", "/core/amb/index.s", "fa fa-stethoscope fa-fw", session));
      m.add(new Menu("Стационар", "/core/stat/index.s", "fa fa-hospital-o fa-fw", session));
      m.add(new Menu("Детали лаб", "/core/stat/details.s", "fa fa-flask fa-fw", session));
      m.add(new Menu("МКБ", "/mkb/admin.s", "fa fa-book fa-fw", session));
      m.add(new Menu("Отделении", "/admin/depts.s", "fa fa-sitemap fa-fw", session));
      m.add(new Menu("Параметры", "/admin/price.s", "fa fa-sliders fa-fw", session));
      m.add(new Menu("Партнеры", "/admin/lvpartners.s", "fa fa-briefcase fa-fw", session));
      m.add(new Menu("Палата", "/admin/rooms.s", "fa fa-building-o fa-fw", session));
      m.add(new Menu("Протокол", "/admin/log.s", "fa fa-history fa-fw", session));
      m.add(new Menu("Телеграм", "/admin/tg/index.s", "fa fa-paper-plane fa-fw", session));
      m.add(new Menu("Пакет услуг", "/admin/pack/index.s", "fa fa-gift fa-fw", session));
      m.add(new Menu("Акции", "/cashbox/sales.s", "fa fa-tags fa-fw", session));
    }
    if(roleId == 3) { // Приемное – медсестра
      session.setCurUrl(session.getCurUrl().isEmpty() ? "/reg/nurse/index.s" : session.getCurUrl());
      m.add(new Menu("Регистрация", "/reg/nurse/index.s", "fa fa-sign-in fa-fw", session.getCurUrl().equals("/reg/nurse/index.s")));
      m.add(new Menu("Клиенты", "/clients/list.s", "fa fa-users fa-fw", session));
      //m.add(new Menu("Брон", "/booking/nurse.s", "fa fa-th fa-fw", session.getCurUrl().equals("/booking/nurse.s")));
      m.add(new Menu("Пациенты", "/patients/list.s", "fa fa-hospital-o fa-fw", (session.getCurUrl().equals("/patients/list.s") || session.getCurUrl().equals("/patients/archive.s"))));
    }
    // Приемное – врач, Дежурный врач: меню нет, работают из списка пациентов (стартовая страница в Roles для них не годится)
    if(roleId == 4 || roleId == 8)
      session.setCurUrl(session.getCurUrl().isEmpty() ? "/patients/list.s" : session.getCurUrl());
    if(roleId == 7) { // КДО: пациенты (пакетный ввод по пациенту) и ввод по услугам
      session.setCurUrl(session.getCurUrl().isEmpty() ? "/patients/list.s" : session.getCurUrl());
      m.add(new Menu("Пациенты", "/patients/list.s", "fa fa-hospital-o fa-fw", session.getCurUrl().startsWith("/patients/") || session.getCurUrl().startsWith("/kdo/batch.s") || session.getCurUrl().startsWith("/kdo/kdo.s")));
      m.add(new Menu("По услугам", "/kdo/services.s", "fa fa-list-alt fa-fw", session.getCurUrl().startsWith("/kdo/service")));
    }
    if(roleId == 5) { // Лечащий врач
      session.setCurUrl(session.getCurUrl().isEmpty() ? "/patients/list.s" : session.getCurUrl());
      m.add(new Menu("Статистика", "/view/stat.s", "fa fa-bar-chart fa-fw", session.getCurUrl().equals("/view/stat.s")));
      m.add(new Menu("Пациенты", "/patients/list.s", "fa fa-hospital-o fa-fw", (session.getCurUrl().equals("/patients/list.s") || session.getCurUrl().equals("/patients/archive.s"))));
      m.add(new Menu("Консультация", "/patients/consul.s", "fa fa-comments fa-fw", session.getCurUrl().equals("/patients/consul.s")));
    }
    if(roleId == 6) { // Заместитель главного врача
      session.setCurUrl(session.getCurUrl().isEmpty() ? "/patients/list.s" : session.getCurUrl());
      m.add(new Menu("Статистика", "/patients/stat.s", "fa fa-bar-chart fa-fw", session.getCurUrl().equals("/patients/stat.s")));
      m.add(new Menu("Палаты", "/booking/palata.s", "fa fa-building-o fa-fw", session.getCurUrl().equals("/booking/palata.s")));
      m.add(new Menu("Выписка", "/patients/list.s", "fa fa-sign-out fa-fw", (session.getCurUrl().equals("/patients/list.s") || session.getCurUrl().equals("/patients/archive.s"))));
      m.add(new Menu("Пациенты", "/patients/list.s?curPat=Y", "fa fa-hospital-o fa-fw", session.getCurUrl().equals("/patients/list.s?curPat=Y")));
    }
    if(roleId == 9) { // Консультация
      session.setCurUrl(session.getCurUrl().isEmpty() ? "/patients/consul.s" : session.getCurUrl());
      Long conCount = dLvConsul.getCount("From LvConsuls c Where c.text = null And c.lvId = " + session.getUserId());
      m.add(new Menu("Консультация (" + conCount + ")", "/patients/consul.s", "fa fa-comments fa-fw", session.getCurUrl().equals("/patients/consul.s")));
      m.add(new Menu("Архив", "/patients/archive.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/patients/archive.s")));
    }
    if(roleId == 10) { // Аптека
      session.setCurUrl(session.getCurUrl().isEmpty() ? "/drugs/acts.s" : session.getCurUrl());
      m.add(new Menu("Детализация", "/drugs/details.s", "fa fa-list-alt fa-fw", session.getCurUrl().equals("/drugs/details.s")));
      m.add(new Menu("Склад", "/drugs/sklad.s", "fa fa-cubes fa-fw", session.getCurUrl().equals("/drugs/sklad.s")));
      m.add(new Menu("Приход", "/drugs/acts.s", "fa fa-download fa-fw", session.getCurUrl().equals("/drugs/acts.s")));
      m.add(new Menu("Расход", "/drugs/out.s", "fa fa-upload fa-fw", session.getCurUrl().equals("/drugs/out.s")));
      m.add(new Menu("Заявки", "/drugs/out/drug/claim.s", "fa fa-file-text-o fa-fw", session));
      m.add(new Menu("Справочники", "/drugs/dicts.s", "fa fa-book fa-fw", session.getCurUrl().equals("/drugs/dicts.s")));
    }
    if(roleId == 11) { // Постовой
      session.setCurUrl(session.getCurUrl().isEmpty() ? "/patients/list.s" : session.getCurUrl());
      m.add(new Menu("Статистика", "/head_nurse/stat.s", "fa fa-bar-chart fa-fw", session.getCurUrl().equals("/head_nurse/stat.s")));
      m.add(new Menu("Услуги", "/nurses/work.s", "fa fa-check-square-o fa-fw", session.getCurUrl().equals("/nurses/work.s")));
      m.add(new Menu("Больничные", "/nurses/sicks.s", "fa fa-file-text-o fa-fw", session.getCurUrl().equals("/nurses/sicks.s")));
      m.add(new Menu("Пациенты", "/patients/list.s", "fa fa-hospital-o fa-fw", session.getCurUrl().equals("/patients/list.s")));
      m.add(new Menu("Палаты", "/proc/palatas.s", "fa fa-building-o fa-fw", session.getCurUrl().equals("/proc/palatas.s")));
    }
    if(roleId == 12) { // Питание
      m.add(new Menu("Заявки", "/eats/claims.s", "fa fa-file-text-o fa-fw", session.getCurUrl().equals("/eats/claims.s")));
      m.add(new Menu("Меню", "/eats/menu.s", "fa fa-calendar fa-fw", session.getCurUrl().equals("/eats/menu.s")));
      m.add(new Menu("Справочники", "/eats/dicts.s", "fa fa-book fa-fw", session.getCurUrl().equals("/eats/dicts.s")));
    }
    if(roleId == 13) { // Касса
      m.add(new Menu("Статистика", "/cashbox/statistic.s", "fa fa-bar-chart fa-fw", session.getCurUrl().equals("/patients/cashStat.s")));
      m.add(new Menu("Амбулатория", "/amb/home.s", "fa fa-stethoscope fa-fw", (session.getCurUrl().equals("/amb/home.s") || session.getCurUrl().equals("/amb/archive.s"))));
      m.add(new Menu("Стационар", "/patients/list.s", "fa fa-hospital-o fa-fw", (session.getCurUrl().equals("/patients/list.s") || session.getCurUrl().equals("/patients/archive.s"))));
    }
    if(roleId == 14) {  // Амбулаторные услуги
      m.add(new Menu("Пациенты", "/amb/home.s", "fa fa-stethoscope fa-fw", (session.getCurUrl().equals("/amb/home.s") || session.getCurUrl().equals("/amb/archive.s"))));
      m.add(new Menu("По услугам", "/amb/svcs.s", "fa fa-list-alt fa-fw", session.getCurUrl().startsWith("/amb/svcs.s") || session.getCurUrl().startsWith("/amb/svcPatients.s")));
      m.add(new Menu("Сотрудники", "/emp/doctor/emps.s", "fa fa-user-md fa-fw", session));
      m.add(new Menu("Бронирование", "/amb/booking/lvs.s", "fa fa-calendar fa-fw", session));
    }
    if(roleId == 15) { // Амбулаторная регистрация
      m.add(new Menu("Регистрация", "/amb/reg.s", "fa fa-sign-in fa-fw", session.getCurUrl().contains("/amb/reg.s")));
      m.add(new Menu("Пациенты", "/amb/home.s", "fa fa-stethoscope fa-fw", (session.getCurUrl().equals("/amb/home.s") || session.getCurUrl().equals("/amb/archive.s"))));
      m.add(new Menu("Бронирование", "/amb/bookings.s", "fa fa-calendar fa-fw", session.getCurUrl().equals("/amb/bookings.s")));
      m.add(new Menu("Клиенты", "/clients/list.s", "fa fa-users fa-fw", session));
      m.add(new Menu("Прейскурант", "/amb/prices.s", "fa fa-list-alt fa-fw", session.getCurUrl().equals("/amb/prices.s")));
    }
    if(roleId == 16) { // Физиотерапия
      if(user.isDocfizio()) {
        session.setCurUrl(session.getCurUrl().isEmpty() ? "/patients/list.s" : session.getCurUrl());
        // текущие и архив на одной странице: архив открывается переключателем в списке
        m.add(new Menu("Пациенты", "/patients/list.s", "fa fa-hospital-o fa-fw", (session.getCurUrl().equals("/patients/list.s") || session.getCurUrl().equals("/patients/archive.s"))));
      } else {
        session.setCurUrl(session.getCurUrl().isEmpty() ? "/nurses/fizio.s" : session.getCurUrl());
      }
      m.add(new Menu("Постовой", "/nurses/fizio.s", "fa fa-bolt fa-fw", session.getCurUrl().equals("/nurses/fizio.s")));
      if(!user.isDocfizio())
        m.add(new Menu("Архив", "/patients/archive.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/patients/archive.s")));
    }
    if(roleId == 17) { // Бронирование
      session.setCurUrl(session.getCurUrl().isEmpty() ? "/patients/list.s" : session.getCurUrl());
      m.add(new Menu("Статистика", "/patients/stat.s", "fa fa-bar-chart fa-fw", session.getCurUrl().equals("/patients/stat.s")));
      m.add(new Menu("Койки", "/booking/koyki.s", "fa fa-building-o fa-fw", session.getCurUrl().equals("/booking/koyki.s")));
      m.add(new Menu("Бронирование", "/booking/index.s", "fa fa-calendar fa-fw", session.getCurUrl().equals("/booking/index.s")));
      m.add(new Menu("Пациенты", "/patients/list.s", "fa fa-hospital-o fa-fw", (session.getCurUrl().equals("/patients/list.s") || session.getCurUrl().equals("/patients/archive.s"))));
    }
    if(roleId == 18) { // Расходы по услугам
      session.setCurUrl(session.getCurUrl().isEmpty() ? "/exp/stat.s" : session.getCurUrl());
      m.add(new Menu("Статистика", "/exp/stat.s", "fa fa-signal", session.getCurUrl().equals("/exp/stat.s")));
      m.add(new Menu("Справочники", "/exp/dicts.s", "fa fa-align-justify fa-fw", session.getCurUrl().equals("/exp/dicts.s")));
    }
    if(roleId == 19) { // Старшая медсестра
      session.setCurUrl(session.getCurUrl().isEmpty() ? "/head_nurse/incomes.s" : session.getCurUrl());
      List<UserDrugLines> lines = dUserDrugLine.getList("From UserDrugLines Where user.id = " + session.getUserId());
      boolean isTransfer = false;
      for(UserDrugLines line: lines) {
        if (line.getDirection().getTransfer() != null && line.getDirection().getTransfer().equals("Y")) {
          isTransfer = true;
          break;
        }
      }
      m.add(new Menu("Статистика", "/head_nurse/stat.s", "fa fa-bar-chart fa-fw", session.getCurUrl().equals("/head_nurse/stat.s")));
      if(user.isMainNurse())
        m.add(new Menu("Питание", "/head_nurse/eats.s", "fa fa-cutlery fa-fw", session.getCurUrl().equals("/head_nurse/eats.s")));
      m.add(new Menu("Сальдо", "/head_nurse/saldo.s", "fa fa-calculator fa-fw", session.getCurUrl().equals("/head_nurse/saldo.s")));
      if(user.isMainNurse() || user.isStatExp()) {
        m.add(new Menu("Стационар", "/head_nurse/out/patient.s", "fa fa-hospital-o fa-fw", session.getCurUrl().equals("/head_nurse/out/patient.s")));
        m.add(new Menu("Новые назначения", "/head_nurse/new_drugs.s", "fa fa-medkit fa-fw", session.getCurUrl().equals("/head_nurse/new_drugs.s")));
      }
      //m.add(new Menu("Амбулатория", "/head_nurse/out/amb.s", "fa fa-th-list fa-fw", session.getCurUrl().equals("/head_nurse/out/amb.s")));
      m.add(new Menu("Расход", "/head_nurse/out.s", "fa fa-upload fa-fw", session.getCurUrl().equals("/head_nurse/out.s")));
      if(isTransfer || session.getUserId() == 1)
        m.add(new Menu("Перевод", "/head_nurse/transfer.s", "fa fa-exchange fa-fw", session.getCurUrl().equals("/head_nurse/transfer.s")));
      m.add(new Menu("Приход", "/head_nurse/incomes.s", "fa fa-download fa-fw", session.getCurUrl().equals("/head_nurse/incomes.s")));
      if(user.isMainNurse()) {
        m.add(new Menu("Пациенты", "/head_nurse/total/patients.s", "fa fa-hospital-o fa-fw", session.getCurUrl().equals("/head_nurse/total/patients.s")));
        m.add(new Menu("Новые медикаменты", "/head_nurse/new_income_drugs.s", "fa fa-plus-square fa-fw", session.getCurUrl().equals("/head_nurse/new_income_drugs.s")));
      }
    }
    if(roleId == 21) {
      session.setCurUrl(session.getCurUrl().isEmpty() ? "/cashbox/statistic.s" : session.getCurUrl());
      m.add(new Menu("Касса", "/cashbox/statistic.s", "fa fa-money fa-fw", session.getCurUrl().equals("/cashbox/statistic.s")));
      m.add(new Menu("Медикаменты", "/mn/drugs.s", "fa fa-medkit fa-fw", session.getCurUrl().equals("/mn/drugs.s")));
      m.add(new Menu("Анализ склада", "/mn/analys.s", "fa fa-line-chart fa-fw", session.getCurUrl().equals("/mn/analys.s")));
      m.add(new Menu("Анализ медикаментов", "/mn/drugs/days.s", "fa fa-area-chart fa-fw", session.getCurUrl().equals("/mn/drugs/days.s")));
      m.add(new Menu("Рейтинг услуг", "/mn/services.s", "fa fa-trophy fa-fw", session.getCurUrl().equals("/mn/services.s")));
      m.add(new Menu("Рейтинг по врачам", "/mn/users.s", "fa fa-user-md fa-fw", session.getCurUrl().equals("/mn/users.s")));
      m.add(new Menu("Аптека", "/mn/drugstore.s", "fa fa-plus-square fa-fw", session.getCurUrl().equals("/mn/drugstore.s")));
      m.add(new Menu("Склад", "/mn/stores.s", "fa fa-cubes fa-fw", session.getCurUrl().equals("/mn/stores.s")));
      m.add(new Menu("Стационар", "/patients/stat.s", "fa fa-hospital-o fa-fw", session.getCurUrl().equals("/patients/stat.s")));
      m.add(new Menu("Склад: Простой", "/mn/drug_downtime.s", "fa fa-clock-o fa-fw", session.getCurUrl().equals("/patients/stat.s")));
    }
    if(roleId == 22) {
      session.setCurUrl(session.getCurUrl().isEmpty() ? "/ambs/reg.s" : session.getCurUrl());
      m.add(new Menu("Регистрация", "/ambs/reg.s", "fa fa-edit fa-fw", session));
      m.add(new Menu("Текущие", "/ambs/patients.s", "fa fa-group fa-fw", session));
      m.add(new Menu("Клиенты", "/clients/list.s", "fa fa-group fa-fw", session));
      m.add(new Menu("Архив", "/ambs/archive.s", "fa fa-group fa-fw", session));
    }
    if(roleId == 23) {
      session.setCurUrl(session.getCurUrl().isEmpty() ? "/ambs/patients.s" : session.getCurUrl());
      m.add(new Menu("Текущие", "/ambs/patients.s", "fa fa-group fa-fw", session));
      m.add(new Menu("Архив", "/ambs/archive.s", "fa fa-group fa-fw", session));
    }
    if(roleId == 24) {
      session.setCurUrl(session.getCurUrl().isEmpty() ? "/ambs/patients.s" : session.getCurUrl());
      m.add(new Menu("Текущие", "/ambs/patients.s", "fa fa-group fa-fw", session));
      m.add(new Menu("Архив", "/ambs/archive.s", "fa fa-group fa-fw", session));
    }
    model.addAttribute("menuList", m);
    model.addAttribute("lvs", beanUsers.getLvs());
    model.addAttribute("groups", beanSession.getAmbGroups());
    model.addAttribute("depts", beanSession.getDepts());
    model.addAttribute("repList", dUser.getReports(session.getUserId()));
    model.addAttribute("openPage", roleId == 0 ? "/roles.s" : session.getCurUrl().isEmpty() ? dRole.get(roleId).getUrl() : session.getCurUrl());
    // показ меню и поиска пациента настраивается в таблице Roles (поля showMenu, showSearch: Y / N)
    Roles curRole = roleId > 0 ? dRole.get(roleId) : null;
    model.addAttribute("showMenu", (!m.isEmpty() && session.getCurPat() == 0) || (curRole != null && "Y".equals(curRole.getShowMenu())));
    model.addAttribute("showSearch", curRole != null && "Y".equals(curRole.getShowSearch()));
    model.addAttribute("isEnterFilter", beanSession.getParam("FILTER_WITH_ENTER").equals("Y"));
    model.addAttribute("session", session);
    model.addAttribute("clinicName", beanSession.getParam("CLINIC_NAME"));

    List<Users> users = beanUsers.getUsers();
    model.addAttribute("users", users);
    return "index";
  }

  /** Жива ли сессия: common.js спрашивает после ошибки запроса, чтобы показать «Сессия истекла» вместо молчания */
  @RequestMapping("/session/ping.s")
  @ResponseBody
  protected String sessionPing(HttpServletRequest request, HttpServletResponse response) {
    response.setHeader("Cache-Control", "no-store");
    return SessionUtil.getUser(request) == null ? "N" : "Y";
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

  // QR-код картинкой PNG, генерируется внутри проекта (zxing, ckb.utils.QRCode), как в nano.
  //   ?url=<ссылка>  - любая http/https ссылка (например, подключение пациента к Telegram-боту)
  //   ?code=<код>    - ссылка на результаты амбулатории: адрес из параметра QRCODEURL (часть после "url=") + код
  //   &size=<px>     - размер, по умолчанию 220
  @RequestMapping(value = "/qrcode_png.s", method = RequestMethod.GET)
  public void qrcodePng(HttpServletRequest req, HttpServletResponse res) throws IOException {
    String url = Util.nvl(req.getParameter("url")).trim();
    if (url.isEmpty()) {
      String base = Util.nvl(beanSession.getParam("QRCODEURL"));
      int i = base.indexOf("url=");
      url = (i >= 0 ? base.substring(i + 4) : base) + Util.nvl(req.getParameter("code")).trim();
    }
    int size = 220;
    try {
      size = Math.max(80, Math.min(600, Integer.parseInt(Util.nvl(req.getParameter("size"), "220"))));
    } catch (NumberFormatException ignore) {
      // размер по умолчанию
    }
    byte[] png;
    try {
      png = QRCode.generateUrlQrPng(url, size);
    } catch (Exception e) {
      res.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
      return;
    }
    res.setContentType("image/png");
    res.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
    res.setHeader("Pragma", "no-cache");
    res.setContentLength(png.length);
    res.getOutputStream().write(png);
    res.flushBuffer();
  }

  @RequestMapping("/boss.s")
  protected String boss(){
    return "boss/boss";
  }

  @RequestMapping(value = "/boss/data.s", method = RequestMethod.POST)
  protected void boss_(HttpServletRequest req, HttpServletResponse res) throws IOException {
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
    ResultSet rs = null, rc = null;
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
              "         (Select ifnull(Sum(d.summ), 0) From Cash_Discounts d Where d.ambStat = 'STAT' And d.crOn >= ? And d.crOn < DATE_ADD(?, INTERVAL 1 DAY)) cash_discount," +
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
          ps = conn.prepareStatement("Select count(*) From amb_patients t Where t.crOn >= ? And t.crOn < DATE_ADD(?, INTERVAL 1 DAY) ");
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
              " Where t.oper_day >= DATE_FORMAT(?, '%Y-%m-01') And t.oper_day < DATE_FORMAT(?, '%Y-%m-01') + INTERVAL 1 MONTH");
          ps.setString(1, dd);
          ps.setString(2, dd);
          rs = ps.executeQuery();
          if (rs.next()) {
            m.put("ym", dd.substring(0, 7));
            m.put("amb", rs.getDouble(1));
            m.put("stat", rs.getDouble(2));
          }
          ps = conn.prepareStatement("Select Count(*) Counter From Hn_Patients t Where t.dateEnd >= DATE_FORMAT(?, '%Y-%m-01') And t.dateEnd < DATE_FORMAT(?, '%Y-%m-01') + INTERVAL 1 MONTH");
          ps.setString(1, dd);
          ps.setString(2, dd);
          rs = ps.executeQuery();
          if(rs.next()) {
            m.put("discharged", rs.getDouble(1));
          }
          ps = conn.prepareStatement("Select count(*) From amb_patients t Where t.crOn >= DATE_FORMAT(?, '%Y-%m-01') And t.crOn < DATE_FORMAT(?, '%Y-%m-01') + INTERVAL 1 MONTH ");
          ps.setString(1, dd);
          ps.setString(2, dd);
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
        ps = conn.prepareStatement("Select ifnull(Sum(t.summ), 0) From cash_discounts t Where t.crOn >= ? And t.crOn < DATE_ADD(?, INTERVAL 1 DAY) ");
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
            " Where t.crOn >= CURRENT_DATE() And t.crOn < CURRENT_DATE() + INTERVAL 1 DAY " +
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
          "Select Sum(IF(c.counteryId = 199, 1, 0)) residents, " +
            "       Sum(IF(c.counteryId != 199, 1, 0)) foreigners, " +
            "       Sum(IF(c.counteryId != 199, t.price + t.nds, 0)) foreignersSum, " +
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
      if(tab.equals("stat")) {
        JSONObject beds = new JSONObject();
        JSONArray floors = new JSONArray();
        // occupied and booked beds for all rooms in two grouped queries, not two queries per room
        java.util.Map<Integer, Long> occByRoom = ckb.utils.Counts.patientsByRoom("state = 'LV'");
        java.util.Map<Integer, Long> bookedByRoom = ckb.utils.Counts.group("Select Room_Id, Count(*) From Room_Bookings Where date_begin >= CURRENT_DATE() Group By Room_Id");
        ps = conn.prepareStatement("Select floor From Rooms Group By floor");
        rs = ps.executeQuery();
        int roomCount = 0;
        while (rs.next()) {
          JSONObject a = new JSONObject();
          a.put("name", rs.getString("floor") + " - этаж");
          JSONArray rooms = new JSONArray();
          ps = conn.prepareStatement("Select * From Rooms Where floor = ?");
          ps.setInt(1, rs.getInt("floor"));
          ps.execute();
          rc = ps.getResultSet();
          while (rc.next()) {
            JSONObject room = new JSONObject();
            room.put("no", rc.getString("name"));
            room.put("cap", rc.getString("koykoLimit"));
            room.put("occ", ckb.utils.Counts.get(occByRoom, rc.getInt("id")).doubleValue());
            room.put("booked", ckb.utils.Counts.get(bookedByRoom, rc.getInt("id")).doubleValue());
            rooms.put(room);
            roomCount++;
          }
          a.put("rooms", rooms);
          floors.put(a);
        }
        beds.put("total", roomCount);
        beds.put("occupied", DB.getSum(conn, "Select Count(*) From Patients Where state = 'LV'"));
        beds.put("booked", DB.getSum(conn, "Select Count(*) From Room_Bookings Where date_begin >= CURRENT_DATE()"));
        beds.put("floors", floors);
        json.put("beds", beds);
        JSONArray deps = new JSONArray();
        DB.done(ps);
        DB.done(rs);
        DB.done(rc);
        ps = conn.prepareStatement(
          "Select f.id, f.name, " +
            "       Count(*) discharged, " +
            "       Sum(c.dayCount) / Count(*) alos, " +
            "       Sum(c.totalSum) summ " +
            "  From Patients t, Hn_Patients c, Users d, Depts f " +
            " Where c.patient_Id = t.id " +
            "   And d.id = t.lv_id " +
            "   And f.Id = d.Dept_Id " +
            "   And c.dateEnd Between ? And ? " +
            " Group By f.id, f.name"
        );
        ps.setString(1, Util.dateDB(db));
        ps.setString(2, Util.dateDB(de));
        ps.execute();
        rs = ps.getResultSet();
        while (rs.next()) {
          JSONObject a = new JSONObject();
          a.put("name", rs.getString("name"));
          a.put("discharged", rs.getInt("discharged"));
          a.put("alos", rs.getDouble("alos"));
          a.put("sum", rs.getDouble("summ"));
          deps.put(a);
        }
        json.put("deps", deps);
        JSONObject debts = new JSONObject();
        JSONArray rows = new JSONArray();
        DB.done(ps);
        DB.done(rs);
        ps = conn.prepareStatement(
          "Select t.yearNum, t.surname, t.name, t.middlename, " +
            "         f.name dep, " +
            "       date_format(c.dateEnd, '%d.%m.%Y') discharged, " +
            "       c.totalSum total, " +
            "       c.totalSum - c.paySum paid " +
            "  From Patients t, Hn_Patients c, Users d, Depts f " +
            " Where c.patient_Id = t.id " +
            "   And d.id = t.lv_id " +
            "   And f.Id = d.Dept_Id " +
            "   And c.paySum > 0 " +
            "   And c.dateEnd Between ? And ? "
        );
        ps.setString(1, Util.dateDB(db));
        ps.setString(2, Util.dateDB(de));
        ps.execute();
        rs = ps.getResultSet();
        double totalDebt = 0;
        int totalCount = 0;
        while (rs.next()) {
          JSONObject a = new JSONObject();
          String ib = rs.getString("yearNum") + "-" + rs.getString("surname") + " " + rs.getString("name") + (rs.getString("middlename") == null ? "" : " " + rs.getString("middlename"));
          a.put("ib", ib);
          a.put("dep", rs.getString("dep"));
          a.put("discharged", rs.getString("discharged"));
          a.put("total", rs.getDouble("total"));
          a.put("paid", rs.getDouble("paid"));
          rows.put(a);
          totalCount++;
          totalDebt += rs.getDouble("total");
        }
        debts.put("count", totalCount);
        debts.put("sum", totalDebt);
        debts.put("rows", rows);
        json.put("debts", debts);
      }
      if(tab.equals("doc")) {
        JSONArray doctors = new JSONArray();
        DB.done(ps);
        DB.done(rs);
        ps = conn.prepareStatement(
          "Select a.fio, " +
            "       count(*) counter, " +
            "       sum(t.price) revenue, " +
            "       Sum(t.price * Case When ifnull(f.bonusProc, 0) > 0 Then ifnull(f.bonusProc, 0) Else ifnull(c.bonusProc, 0) End / 100) reward " +
            "  From Amb_Patient_Services t, Users a, Amb_Services c, Amb_Groups f " +
            " Where t.cron between ? And ? " +
            "   And t.worker_Id = a.id " +
            "   And t.state = 'DONE' " +
            "   And c.id = t.service_Id " +
            "   And f.id = c.group_Id " +
            "  Group By a.fio"
        );
        ps.setString(1, Util.dateDBBegin(db));
        ps.setString(2, Util.dateDBBegin(de));
        ps.execute();
        rs = ps.getResultSet();
        while (rs.next()) {
          JSONObject a = new JSONObject();
          a.put("name", rs.getString("fio"));
          double revenue = rs.getDouble("revenue"), reward = rs.getDouble("reward");
          a.put("services", rs.getInt("counter"));
          a.put("percent", revenue > 0 ? Math.round(reward / revenue * 1000) / 10.0 : 0);
          a.put("revenue", revenue);
          a.put("reward", reward);
          doctors.put(a);
        }
        json.put("doctors", doctors);
        JSONArray partners = new JSONArray();
        ps = conn.prepareStatement(
          "Select (Select c.code From lv_partners c Where c.id = d.lvpartner_id) partner,  " +
            "       COUNT(DISTINCT a.patient) counter,  " +
            "       Sum(a.price) summ,  " +
            "       s.partnerProc proc,  " +
            "       Sum(s.partnerProc * a.price / 100) bonus  " +
            "  From amb_patient_services a, Amb_Patients d, Amb_Services t, Amb_Groups s  " +
            " Where a.cron between ? And ? " +
            "   And a.patient = d.id  " +
            "   And s.id = t.group_Id  " +
            "   And t.id = a.service_Id  " +
            "   And a.state = 'DONE'  " +
            "   And s.partnerProc > 0 " +
            "   And d.lvpartner_Id > 0  " +
            "   And (a.crBy = d.crBy Or a.crBy = 1)  " +
            "  Group By d.lvpartner_Id, s.partnerProc "
        );
        ps.setString(1, Util.dateDBBegin(db));
        ps.setString(2, Util.dateDBBegin(de));
        ps.execute();
        rs = ps.getResultSet();
        while (rs.next()) {
          JSONObject a = new JSONObject();
          a.put("code", "-");
          a.put("name", rs.getString("partner"));
          a.put("patients", rs.getInt("counter"));
          a.put("percent", rs.getInt("proc"));
          a.put("revenue", rs.getDouble("summ"));
          a.put("payout", rs.getDouble("bonus"));
          partners.put(a);
        }
        json.put("partners", partners);
      }
      if(tab.equals("drug")) {
        json = bossDrugs(conn, Util.dateDB(db), Util.dateDB(de), Util.dateDB(fdb), Util.dateDB(fde));
      }
    } catch (Exception e) {
      e.printStackTrace();
      try { json.put("error", e.getMessage()); } catch (Exception ignore) {}
    } finally {
      DB.done(conn, ps, rs);
    }
    res.getWriter().write(json.toString());
  }

  // Руководство -> Медикаменты. Даты в формате yyyy-MM-dd, prev* могут быть null (нет прошлого периода).
  //   billed / statBilled - медикаменты в закрытых актах стационара (Hn_Patients.drugSum по дате выписки)
  //   deps.issued - выдано аптекой на пост (Drug_Outs CON по дате, направление привязано ровно к одному отделению)
  //   stock - остаток в аптеке по приходам (Drug_Act_Drugs: (counter - rasxod) * countPrice)
  //   top - препараты из актов, types / source - назначения врачей (Patient_Drugs) за период
  private JSONObject bossDrugs(Connection conn, String db, String de, String fdb, String fde) throws Exception {
    JSONObject d = new JSONObject();
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      // медикаменты в актах и число выписанных, текущий и прошлый период
      for (int i = 0; i < 2; i++) {
        String a = i == 0 ? db : fdb, b = i == 0 ? de : fde;
        if (a == null || b == null) continue;
        // по цене аптеки (drugSum в акте включает НДС), чтобы сравнивать с выдачей на пост
        ps = conn.prepareStatement(
          "Select (Select IfNull(Sum(IfNull(r.serviceCount, 0) * IfNull(r.drugPrice, r.price)), 0) From Hn_Patient_Drugs r Join Hn_Patients h On h.id = r.hn_patient Where h.dateEnd Between ? And ?), " +
          "       (Select Count(*) From Hn_Patients h Where h.dateEnd Between ? And ?)");
        ps.setString(1, a);
        ps.setString(2, b);
        ps.setString(3, a);
        ps.setString(4, b);
        rs = ps.executeQuery();
        if (rs.next()) {
          if (i == 0) {
            d.put("billed", rs.getDouble(1));
            d.put("statBilled", rs.getDouble(1));
            d.put("discharged", rs.getInt(2));
          } else {
            d.put("prevBilled", rs.getDouble(1));
          }
        }
        DB.done(rs);
        DB.done(ps);
      }
      // поступления в кассу за период (для доли медикаментов)
      ps = conn.prepareStatement("Select IfNull(Sum(t.summ), 0) From Dwh_Cashboxs t Where t.oper_day Between ? And ?");
      ps.setString(1, db);
      ps.setString(2, de);
      rs = ps.executeQuery();
      d.put("cash", rs.next() ? rs.getDouble(1) : 0);
      DB.done(rs);
      DB.done(ps);

      // по отделениям: списано в акты и выдано на пост
      Map<Integer, JSONObject> deps = new LinkedHashMap<>();
      ps = conn.prepareStatement(
        "Select p.Dept_Id, dp.name, IfNull(Sum(IfNull(r.serviceCount, 0) * IfNull(r.drugPrice, r.price)), 0) " +
        "  From Hn_Patient_Drugs r Join Hn_Patients t On t.id = r.hn_patient Join Patients p On p.id = t.patient_Id Left Join Depts dp On dp.id = p.Dept_Id " +
        " Where t.dateEnd Between ? And ? And p.Dept_Id Is Not Null Group By p.Dept_Id, dp.name");
      ps.setString(1, db);
      ps.setString(2, de);
      rs = ps.executeQuery();
      while (rs.next()) {
        JSONObject x = new JSONObject();
        x.put("name", Util.nvl(rs.getString(2)).trim());
        x.put("billed", rs.getDouble(3));
        x.put("issued", 0D);
        deps.put(rs.getInt(1), x);
      }
      DB.done(rs);
      DB.done(ps);
      ps = conn.prepareStatement(
        "Select dd.dept_Id, dp.name, IfNull(Sum(r.drugCount * r.price), 0) " +
        "  From Drug_Out_Rows r Join Drug_Outs o On o.id = r.doc_Id " +
        "  Join Drug_s_Direction_Deps dd On dd.direction_Id = o.direction_Id " +
        "  Left Join Depts dp On dp.id = dd.dept_Id " +
        " Where o.state = 'CON' And o.regDate >= ? And o.regDate < Date_Add(?, Interval 1 Day) " +
        "   And (Select Count(*) From Drug_s_Direction_Deps z Where z.direction_Id = o.direction_Id) = 1 " +
        " Group By dd.dept_Id, dp.name");
      ps.setString(1, db);
      ps.setString(2, de);
      rs = ps.executeQuery();
      while (rs.next()) {
        JSONObject x = deps.get(rs.getInt(1));
        if (x == null) {
          x = new JSONObject();
          x.put("name", Util.nvl(rs.getString(2)).trim());
          x.put("billed", 0D);
          deps.put(rs.getInt(1), x);
        }
        x.put("issued", rs.getDouble(3));
      }
      DB.done(rs);
      DB.done(ps);
      JSONArray depArr = new JSONArray();
      for (JSONObject x : deps.values()) depArr.put(x);
      d.put("deps", depArr);

      // остаток в аптеке
      ps = conn.prepareStatement("Select IfNull(Sum((t.counter - IfNull(t.rasxod, 0)) * t.countPrice), 0) From Drug_Act_Drugs t Where t.counter > IfNull(t.rasxod, 0)");
      rs = ps.executeQuery();
      d.put("stock", rs.next() ? rs.getDouble(1) : 0);
      DB.done(rs);
      DB.done(ps);

      // топ-8 препаратов в актах за период
      JSONArray top = new JSONArray();
      ps = conn.prepareStatement(
        "Select IfNull(n.name, r.drugName) nm, " +
        "       (Select Min(c.name) From Drug_s_Drug_Categories dc Join Drug_s_Categories c On c.id = dc.category_Id Where dc.drug_Id = r.drug_Id) cat, " +
        "       Sum(IfNull(r.serviceCount, 0) * IfNull(r.drugPrice, r.price)) summ " +
        "  From Hn_Patient_Drugs r Join Hn_Patients t On t.id = r.hn_patient Left Join Drug_s_Names n On n.id = r.drug_Id " +
        " Where t.dateEnd Between ? And ? Group By r.drug_Id, IfNull(n.name, r.drugName) Order By summ Desc Limit 8");
      ps.setString(1, db);
      ps.setString(2, de);
      rs = ps.executeQuery();
      while (rs.next()) {
        JSONObject x = new JSONObject();
        x.put("name", Util.nvl(rs.getString("nm")).trim());
        x.put("type", Util.nvl(rs.getString("cat")).trim());
        x.put("sum", rs.getDouble("summ"));
        top.put(x);
      }
      DB.done(rs);
      DB.done(ps);
      d.put("top", top);

      // назначения врачей за период: по типу (таблетки / способ введения) и чьи препараты
      JSONArray types = new JSONArray();
      ps = conn.prepareStatement(
        "Select IfNull(it.name, IfNull(dt.name, 'Не указан')) nm, Count(*) cnt " +
        "  From Patient_Drugs p Left Join Dicts dt On dt.id = p.drugType_Id Left Join Dicts it On it.id = p.injectionType_Id " +
        " Where p.crOn >= ? And p.crOn < Date_Add(?, Interval 1 Day) Group By IfNull(it.name, IfNull(dt.name, 'Не указан')) Order By cnt Desc");
      ps.setString(1, db);
      ps.setString(2, de);
      rs = ps.executeQuery();
      while (rs.next()) {
        JSONObject x = new JSONObject();
        x.put("name", Util.nvl(rs.getString(1)).trim());
        x.put("count", rs.getInt(2));
        types.put(x);
      }
      DB.done(rs);
      DB.done(ps);
      d.put("types", types);
      JSONObject source = new JSONObject();
      source.put("clinic", 0);
      source.put("own", 0);
      ps = conn.prepareStatement(
        "Select r.source, Count(*) From Patient_Drug_Rows r Join Patient_Drugs p On p.id = r.patientDrug_Id " +
        " Where p.crOn >= ? And p.crOn < Date_Add(?, Interval 1 Day) Group By r.source");
      ps.setString(1, db);
      ps.setString(2, de);
      rs = ps.executeQuery();
      while (rs.next()) {
        if ("own".equals(rs.getString(1))) source.put("own", rs.getInt(2));
        else source.put("clinic", source.getInt("clinic") + rs.getInt(2));
      }
      d.put("source", source);
    } finally {
      DB.done(rs);
      DB.done(ps);
    }
    return d;
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
