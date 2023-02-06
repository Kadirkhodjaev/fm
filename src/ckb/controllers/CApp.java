package ckb.controllers;

import ckb.dao.admin.depts.DDept;
import ckb.dao.admin.params.DParam;
import ckb.dao.admin.roles.DRole;
import ckb.dao.admin.users.DUser;
import ckb.dao.med.amb.DAmbGroups;
import ckb.dao.med.lv.consul.DLvConsul;
import ckb.domains.admin.Roles;
import ckb.domains.admin.Users;
import ckb.models.Login;
import ckb.models.Menu;
import ckb.services.admin.user.SUser;
import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.Req;
import ckb.utils.Util;
import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.zip.Deflater;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

@Controller
@RequestMapping("/")
public class  CApp {

  @Autowired SUser sUser;
  @Autowired DUser dUser;
  @Autowired DRole dRole;
  @Autowired DLvConsul dLvConsul;
  @Autowired DParam dParam;
  @Autowired DDept dDept;
  @Autowired DAmbGroups dAmbGroups;
  /*@Autowired private DKdos dKdo;
  @Autowired private DAmbServices dAmbService;
  @Autowired private DKdoChoosen dKdoChoosen;
  @Autowired private DPatient dPatient;
  @Autowired private DAmbPatients dAmbPatient;
  @Autowired private DDrug dDrug;
  @Autowired private DDrugSaldo dDrugSaldo;
  @Autowired private DDrugActDrug dDrugActDrug;
  @Autowired private DDrugOutRow dDrugOutRow;
  @Autowired private DHNPatientKdo dHNPatientKdo;
  @Autowired private DHNPatientDrug dHNPatientDrug;
  @Autowired private DPatientPays dPatientPay;
  @Autowired private DAmbPatientPays dAmbPatientPay;*/

  @RequestMapping({"/main.s", "/"})
  protected String main(HttpServletRequest request, Model model) {
    //
    Session session = SessionUtil.getUser(request);
    List<Roles> userRoles = sUser.getUserRoles(session.getUserId());
    if(userRoles.size() == 1 && session.getRoleId() == 0) {
      session.setRoleId(userRoles.get(0).getId());
      session.setCurPat(0);
      session.setCurUrl("");
    }
    int roleId = session.getRoleId();
    List<Menu> m = new ArrayList<Menu>();
    if(roleId == 1) { // �����������������
      session.setCurUrl(session.getCurUrl().equals("") ? "/admin/users/list.s" : session.getCurUrl());
      m.add(new Menu("������������", "/admin/users/list.s", "fa fa-users fa-fw", session.getCurUrl().equals("/admin/users/list.s")));
      m.add(new Menu("�����", "/admin/forms/list.s", "fa fa-edit fa-fw", session.getCurUrl().equals("/admin/forms/list.s")));
      m.add(new Menu("��� ������", "/admin/ambGroups.s", "fa fa-list-alt fa-fw", session.getCurUrl().equals("/admin/ambGroups.s")));
      m.add(new Menu("��� ������", "/admin/amb.s", "fa fa-plus fa-fw", session.getCurUrl().equals("/admin/amb.s")));
      m.add(new Menu("���� ������", "/admin/statGroups.s", "fa fa-list-alt fa-fw", session.getCurUrl().equals("/admin/statGroups.s")));
      m.add(new Menu("���� ������", "/admin/stat/services.s", "fa fa-list-alt fa-fw", session.getCurUrl().equals("/admin/stat/services.s")));
      m.add(new Menu("������ ���", "/admin/stat/kdoDetails.s", "fa fa-th fa-fw", session.getCurUrl().equals("/admin/stat/kdoDetails.s")));
      m.add(new Menu("���", "/mkb/admin.s", "fa fa-th fa-fw", session.getCurUrl().equals("/mkb/admin.s")));
      m.add(new Menu("���������", "/admin/depts.s", "fa fa-th-list fa-fw", session.getCurUrl().equals("/admin/depts.s")));
      m.add(new Menu("���������", "/admin/price.s", "fa fa-th fa-fw", session.getCurUrl().equals("/mkb/admin.s")));
      m.add(new Menu("��������", "/admin/lvpartners.s", "fa fa-users fa-fw", session.getCurUrl().equals("/admin/lvpartners.s")));
      m.add(new Menu("��������", "/admin/log.s", "fa fa-users fa-fw", session.getCurUrl().equals("/admin/log.s")));
    }
    if(roleId == 3) { // �������� � ���������
      session.setCurUrl(session.getCurUrl().equals("") ? "/reg/nurse/index.s" : session.getCurUrl());
      m.add(new Menu("�����������", "/reg/nurse/index.s", "fa fa-edit fa-fw", session.getCurUrl().equals("/reg/nurse/index.s")));
      m.add(new Menu("����", "/booking/nurse.s", "fa fa-th fa-fw", session.getCurUrl().equals("/booking/nurse.s")));
      m.add(new Menu("��������", "/patients/list.s", "fa fa-align-justify fa-fw", session.getCurUrl().equals("/patients/list.s")));
      m.add(new Menu("�����", "/patients/archive.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/archive/list.s")));
    }
    if(roleId == 4) { // �������� � ����
      session.setCurUrl(session.getCurUrl().equals("") ? "/patients/list.s" : session.getCurUrl());
      m.add(new Menu("��������", "/patients/list.s", "fa fa-align-justify fa-fw", session.getCurUrl().equals("/patients/list.s")));
      m.add(new Menu("�����", "/patients/archive.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/archive/list.s")));
    }
    if(roleId == 5) { // ������� ����
      session.setCurUrl(session.getCurUrl().equals("") ? "/patients/list.s" : session.getCurUrl());
      m.add(new Menu("����������", "/view/stat.s", "fa fa-list-alt fa-fw", session.getCurUrl().equals("/view/stat.s")));
      Long conCount = dLvConsul.getCount("From LvConsuls c Where c.text = null And c.lvId = " + session.getUserId());
      m.add(new Menu("��������", "/patients/list.s", "fa fa-align-justify fa-fw", session.getCurUrl().equals("/patients/list.s")));
      m.add(new Menu("������������ (" + conCount + ")", "/patients/consul.s", "fa fa-group fa-fw", session.getCurUrl().equals("/patients/consul.s")));
      m.add(new Menu("�����", "/patients/archive.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/archive/list.s")));
    }
    if(roleId == 6) { // ����������� �������� �����
      session.setCurUrl(session.getCurUrl().equals("") ? "/patients/list.s" : session.getCurUrl());
      m.add(new Menu("����������", "/patients/stat.s", "fa fa-edit fa-fw", session.getCurUrl().equals("/patients/stat.s")));
      m.add(new Menu("������", "/booking/palata.s", "fa fa-sign-out fa-fw", session.getCurUrl().equals("/booking/palata.s")));
      m.add(new Menu("�������", "/patients/list.s", "fa fa-align-justify fa-fw", session.getCurUrl().equals("/patients/list.s")));
      m.add(new Menu("��������", "/patients/list.s?curPat=Y", "fa fa-edit fa-fw", session.getCurUrl().equals("/patients/list.s?curPat=Y")));
      m.add(new Menu("�����", "/patients/archive.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/archive/list.s")));
    }
    if(roleId == 7) { // ���
      session.setCurUrl(session.getCurUrl().equals("") ? "/patients/list.s" : session.getCurUrl());
      m.add(new Menu("��������", "/patients/list.s", "fa fa-align-justify fa-fw", session.getCurUrl().equals("/patients/list.s")));
      m.add(new Menu("�����", "/patients/archive.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/archive/list.s")));
    }
    if(roleId == 8) { // �������� ����
      session.setCurUrl(session.getCurUrl().equals("") ? "/patients/list.s" : session.getCurUrl());
      m.add(new Menu("��������", "/patients/list.s", "fa fa-align-justify fa-fw", session.getCurUrl().equals("/patients/list.s")));
      m.add(new Menu("�����", "/patients/archive.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/archive/list.s")));
    }
    if(roleId == 9) { // ������������
      session.setCurUrl(session.getCurUrl().equals("") ? "/patients/consul.s" : session.getCurUrl());
      Long conCount = dLvConsul.getCount("From LvConsuls c Where c.text = null And c.lvId = " + session.getUserId());
      m.add(new Menu("������������ (" + conCount + ")", "/patients/consul.s", "fa fa-group fa-fw", session.getCurUrl().equals("/patients/consul.s")));
      m.add(new Menu("�����", "/patients/archive.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/archive/list.s")));
    }
    if(roleId == 10) { // ������
      session.setCurUrl(session.getCurUrl().equals("") ? "/drugs/acts.s" : session.getCurUrl());
      m.add(new Menu("�����������", "/drugs/details.s", "fa fa-group fa-fw", session.getCurUrl().equals("/drugs/details.s")));
      m.add(new Menu("�����", "/drugs/sklad.s", "fa fa-group fa-fw", session.getCurUrl().equals("/drugs/sklad.s")));
      m.add(new Menu("������", "/drugs/saldo.s", "fa fa-group fa-fw", session.getCurUrl().equals("/drugs/saldo.s")));
      m.add(new Menu("������", "/drugs/acts.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/drugs/acts.s")));
      m.add(new Menu("������", "/drugs/out.s", "fa fa-align-justify fa-fw", session.getCurUrl().equals("/drugs/out.s")));
      //m.add(new Menu("����� ������", "/drugs/claims/archive.s", "fa fa-archive fa-edit", session.getCurUrl().equals("/drugs/claims/archive.s")));
      m.add(new Menu("�����������", "/drugs/dicts.s", "fa fa-align-justify fa-fw", session.getCurUrl().equals("/drugs/dicts.s")));
    }
    if(roleId == 11) { // ��������
      session.setCurUrl(session.getCurUrl().equals("") ? "/patients/list.s" : session.getCurUrl());
      m.add(new Menu("����������", "/head_nurse/stat.s", "fa fa-home fa-fw", session.getCurUrl().equals("/head_nurse/stat.s")));
      m.add(new Menu("������", "/nurses/work.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/nurses/work.s")));
      m.add(new Menu("��������", "/patients/list.s", "fa fa-align-justify fa-fw", session.getCurUrl().equals("/patients/list.s")));
    }
    if(roleId == 12) { // �������
      session.setCurUrl(session.getCurUrl().equals("") ? "/eats/menu.s" : session.getCurUrl());
      m.add(new Menu("������", "/eats/claims.s", "fa fa-group fa-fw", session.getCurUrl().equals("/eats/claims.s")));
      m.add(new Menu("����", "/eats/menu.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/eats/menu.s")));
      m.add(new Menu("�����������", "/eats/dicts.s", "fa fa-align-justify fa-fw", session.getCurUrl().equals("/eats/dicts.s")));
    }
    if(roleId == 13) { // �����
      m.add(new Menu("���� ����", "/cashbox/operday.s", "fa fa-edit fa-fw", session.getCurUrl().equals("/cashbox/operday.s")));
      m.add(new Menu("����������", "/cashbox/statistic.s", "fa fa-edit fa-fw", session.getCurUrl().equals("/patients/cashStat.s")));
      m.add(new Menu("�����������", "/amb/home.s", "fa fa-group fa-fw", session.getCurUrl().equals("/amb/home.s")));
      m.add(new Menu("���������", "/patients/list.s", "fa fa-group fa-fw", session.getCurUrl().equals("/patients/list.s")));
      m.add(new Menu("����� (���)", "/amb/archive.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/amb/archive.s")));
      m.add(new Menu("����� (����)", "/patients/archive.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/patients/archive.s")));
    }
    if(roleId == 14) {  // ������������ ������
      m.add(new Menu("�������", "/amb/home.s", "fa fa-group fa-fw", session.getCurUrl().equals("/amb/home.s")));
      m.add(new Menu("�����", "/amb/archive.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/amb/archive.s")));
    }
    if(roleId == 15) { // ������������ �����������
      m.add(new Menu("�����������", "/amb/reg.s", "fa fa-edit fa-fw", session.getCurUrl().contains("/amb/reg.s")));
      m.add(new Menu("�������", "/amb/home.s", "fa fa-group fa-fw", session.getCurUrl().equals("/amb/home.s")));
      m.add(new Menu("�������", "/client/list.s", "fa fa-group fa-fw", session.getCurUrl().equals("/client/list.s")));
      m.add(new Menu("�����", "/amb/archive.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/amb/archive.s")));
    }
    if(roleId == 16) { // ������������
      Users user = dUser.get(session.getUserId());
      if(user.isDocfizio()) {
        session.setCurUrl(session.getCurUrl().equals("") ? "/patients/list.s" : session.getCurUrl());
        m.add(new Menu("��������", "/patients/list.s", "fa fa-align-justify fa-fw", session.getCurUrl().equals("/patients/list.s")));
      } else {
        session.setCurUrl(session.getCurUrl().equals("") ? "/nurses/fizio.s" : session.getCurUrl());
      }
      m.add(new Menu("��������", "/nurses/fizio.s", "fa fa-align-justify fa-fw", session.getCurUrl().equals("/nurses/fizio.s")));
      m.add(new Menu("�����", "/patients/archive.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/archive/list.s")));
    }
    if(roleId == 17) { // ������������
      session.setCurUrl(session.getCurUrl().equals("") ? "/booking/index.s" : session.getCurUrl());
      m.add(new Menu("����������", "/patients/stat.s", "fa fa-edit fa-fw", session.getCurUrl().equals("/patients/stat.s")));
      m.add(new Menu("�����", "/booking/koyki.s", "fa fa-home fa-fw", session.getCurUrl().equals("/booking/koyki.s")));
      m.add(new Menu("������������", "/booking/index.s", "fa fa-plus fa-fw", session.getCurUrl().equals("/booking/index.s")));
      m.add(new Menu("��������", "/patients/list.s", "fa fa-align-justify fa-fw", session.getCurUrl().equals("/patients/list.s")));
      m.add(new Menu("�����", "/patients/archive.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/archive/list.s")));
    }
    if(roleId == 18) { // ������� �� �������
      session.setCurUrl(session.getCurUrl().equals("") ? "/exp/stat.s" : session.getCurUrl());
      m.add(new Menu("����������", "/exp/stat.s", "fa fa-signal", session.getCurUrl().equals("/exp/stat.s")));
      m.add(new Menu("�����������", "/exp/dicts.s", "fa fa-align-justify fa-fw", session.getCurUrl().equals("/exp/dicts.s")));
    }
    if(roleId == 19) { // ������� ���������
      session.setCurUrl(session.getCurUrl().equals("") ? "/head_nurse/incomes.s" : session.getCurUrl());
      Users user = dUser.get(session.getUserId());
      m.add(new Menu("����������", "/head_nurse/stat.s", "fa fa-home fa-fw", session.getCurUrl().equals("/head_nurse/stat.s")));
      m.add(new Menu("�������", "/head_nurse/eats.s", "fa fa-home fa-fw", session.getCurUrl().equals("/head_nurse/eats.s")));
      m.add(new Menu("������", "/head_nurse/saldo.s", "fa fa-briefcase fa-fw", session.getCurUrl().equals("/head_nurse/saldo.s")));
      m.add(new Menu("���������", "/head_nurse/out/patient.s", "fa fa-th-list fa-fw", session.getCurUrl().equals("/head_nurse/out/patient.s")));
      m.add(new Menu("�����������", "/head_nurse/out/amb.s", "fa fa-th-list fa-fw", session.getCurUrl().equals("/head_nurse/out/amb.s")));
      m.add(new Menu("������", "/head_nurse/out.s", "fa fa-file-text fa-users", session.getCurUrl().equals("/head_nurse/out.s")));
      m.add(new Menu("�������", "/head_nurse/transfer.s", "fa fa-folder-o fa-fw", session.getCurUrl().equals("/head_nurse/transfer.s")));
      m.add(new Menu("������", "/head_nurse/incomes.s", "fa fa-stack-overflow fa-fw", session.getCurUrl().equals("/head_nurse/incomes.s")));
      m.add(new Menu("�����������", "/head_nurse/dicts.s", "fa fa-folder-o fa-fw", session.getCurUrl().equals("/head_nurse/dicts.s")));
      m.add(new Menu("��������", "/head_nurse/total/patients.s", "fa fa-barcode fa-fw", session.getCurUrl().equals("/head_nurse/total/patients.s")));
    }
    if(roleId == 20) {
      session.setCurUrl(session.getCurUrl().equals("") ? "/act/index.s" : session.getCurUrl());
      m.add(new Menu("��������", "/act/index.s", "fa fa-group fa-fw", session.getCurUrl().equals("/act/index.s")));
    }
    if(roleId == 21) {
      session.setCurUrl(session.getCurUrl().equals("") ? "/cashbox/statistic.s" : session.getCurUrl());
      m.add(new Menu("�����", "/cashbox/statistic.s", "fa fa-group fa-fw", session.getCurUrl().equals("/cashbox/statistic.s")));
      m.add(new Menu("�����������", "/mn/drugs.s", "fa fa-th-list fa-fw", session.getCurUrl().equals("/mn/drugs.s")));
      m.add(new Menu("������ ������", "/mn/analys.s", "fa fa-th-list fa-fw", session.getCurUrl().equals("/mn/analys.s")));
      m.add(new Menu("������ �����������", "/mn/drugs/days.s", "fa fa-th-list fa-fw", session.getCurUrl().equals("/mn/drugs/days.s")));
      m.add(new Menu("������� �����", "/mn/services.s", "fa fa-edit fa-fw", session.getCurUrl().equals("/mn/services.s")));
      m.add(new Menu("������", "/mn/drugstore.s", "fa fa-group fa-fw", session.getCurUrl().equals("/mn/drugstore.s")));
      m.add(new Menu("�����", "/mn/stores.s", "fa fa-home fa-fw", session.getCurUrl().equals("/mn/stores.s")));
      m.add(new Menu("���������", "/patients/stat.s", "fa fa-archive fa-fw", session.getCurUrl().equals("/patients/stat.s")));
    }
    model.addAttribute("menuList", m);
    model.addAttribute("lvs", dUser.getLvs());
    model.addAttribute("groups", dAmbGroups.getAll());
    model.addAttribute("depts", dDept.getAll());
    model.addAttribute("repList", dUser.getReports(session.getUserId()));
    model.addAttribute("openPage", roleId == 0 ? "/roles.s" : session.getCurUrl().equals("") ? dRole.get(roleId).getUrl() : session.getCurUrl());
    model.addAttribute("showMenu", (m.size() > 0 && session.getCurPat() == 0) || session.getRoleId() == 7 || session.getRoleId() == 3 || session.getRoleId() == 4 || session.getRoleId() == 15 || session.getRoleId() == 14 || session.getRoleId() == 13);
    model.addAttribute("showSearch", roleId != 0 && roleId != 1 && roleId != 10);
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
        errors.rejectValue("login", "ip_error", "�������� � ������� � ����� ����������");
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

  @RequestMapping(value = "test.s", method = RequestMethod.POST)
  protected String test(MultipartHttpServletRequest request){
    Iterator<String> req = request.getFileNames();
    List<MultipartFile> files = request.getFiles("files");
    return "redirect:/login.s";
  }

  /**
   * �������� �������� �� ������ ������������
   * @param response - ������������ ������ �������
   * @param request - HTTP ������ ������������
   */
  @RequestMapping(value = "downloadBrowser.s")
  protected void downloadBrowser(HttpServletResponse response, HttpServletRequest request){
    String url = request.getSession().getServletContext().getRealPath("") + "/res/browsers/chrome.exe";
    File file = new File(url);
    response.setContentType("application/x-msdownload");
    response.setContentLength((int) file.length());
    response.setHeader("Content-Disposition","attachment; filename=chrome.exe");
    try {
      FileCopyUtils.copy(FileUtils.readFileToByteArray(file), response.getOutputStream());
    } catch (IOException e) {
      e.printStackTrace();
    }
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
