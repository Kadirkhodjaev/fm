package ckb.controllers.med;

import ckb.dao.med.amb.*;
import ckb.dao.med.template.DTemplate;
import ckb.domains.med.amb.*;
import ckb.models.FormField;
import ckb.services.admin.form.SForm;
import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.DB;
import ckb.utils.Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;

/**
 * јмбулаторные услуги: ввод результатов в новом виде (как у  ƒќ).
 *   /amb/svc.s          Ч одна услуга: бланк анализа (фрагментом из /amb/doWork.s?frag=1) или текстовое заключение;
 *   /amb/batch.s        Ч пакетный ввод: все услуги пациента, назначенные текущему врачу;
 *   /amb/svcs.s         Ч Ђѕо услугамї: услуги врача у текущих пациентов с количеством;
 *   /amb/svcPatients.s  Ч ввод по одной услуге: все пациенты с ней.
 * —охранение и подтверждение Ч прежние /amb/work.s (POST) и /amb/confirmService.s.
 */
@Controller
@RequestMapping("/amb")
public class CAmbEntry {

  @Autowired private DAmbPatient dAmbPatients;
  @Autowired private DAmbPatientService dAmbPatientServices;
  @Autowired private DAmbResult dAmbResults;
  @Autowired private DAmbServiceField dAmbServiceFields;
  @Autowired private DTemplate dTemplate;
  @Autowired private SForm sForm;

  // вид бланка услуги: single Ч одно поле (777, 888), form Ч бланк анализа, text Ч текстовое заключение (без формы)
  public static String kind(AmbServices s) {
    Integer f = s.getForm_id();
    if (f == null || f == 0) return "text";
    return f == 777 || f == 888 ? "single" : "form";
  }

  @RequestMapping("/svc.s")
  protected String svc(HttpServletRequest req, Model m) {
    Session session = SessionUtil.getUser(req);
    AmbPatientServices service = dAmbPatientServices.get(Util.getInt(req, "id"));
    if (service == null) return "redirect:/amb/home.s";
    session.setCurUrl("/amb/work.s?id=" + service.getId());
    session.setCurPat(service.getPatient());
    AmbPatients pat = dAmbPatients.get(service.getPatient());
    m.addAttribute("patient", pat);
    m.addAttribute("service", service);
    m.addAttribute("kind", kind(service.getService()));
    // ЂЌазадї: в список, из которого открыли (текущие или архив)
    m.addAttribute("backUrl", session.isArchive() ? "/amb/archive.s" : "/amb/home.s");
    m.addAttribute("canEdit", service.getWorker() != null && service.getWorker().getId() == session.getUserId());
    if ("text".equals(kind(service.getService()))) {
      AmbResults result = service.getResult() != null && service.getResult() > 0 ? dAmbResults.get(service.getResult()) : null;
      // как в старом бланке: без результата первое поле берЄтс€ из единственного шаблона врача
      String tplC1 = "";
      if (result == null) {
        String field = service.getService().getId() + "_c1";
        if (dTemplate.getCount("From Templates where userId = " + session.getUserId() + " And field='" + field + "'") == 1)
          tplC1 = dTemplate.getObj("From Templates where userId = " + session.getUserId() + " And field='" + field + "'").getTemplate();
      }
      List<Map<String, String>> fields = new ArrayList<Map<String, String>>();
      List<AmbServiceFields> names = dAmbServiceFields.byService(service.getService().getId());
      for (int i = 0; i < names.size() && i < 10; i++) {
        Map<String, String> f = new HashMap<String, String>();
        f.put("code", "c" + (i + 1));
        f.put("name", Util.nvl(names.get(i).getName()));
        // старые сохранени€ пустых полей записаны как Ђundefinedї
        String v = result != null ? Util.nvl(value(result, i + 1)) : null;
        f.put("value", v != null ? (v.equals("undefined") ? "" : v) : (i == 0 ? Util.nvl(tplC1) : ""));
        fields.add(f);
      }
      m.addAttribute("fields", fields);
    }
    return "med/amb/svc";
  }

  private static String value(AmbResults r, int n) {
    switch (n) {
      case 1: return r.getC1(); case 2: return r.getC2(); case 3: return r.getC3(); case 4: return r.getC4(); case 5: return r.getC5();
      case 6: return r.getC6(); case 7: return r.getC7(); case 8: return r.getC8(); case 9: return r.getC9(); default: return r.getC10();
    }
  }

  // обща€ подготовка дл€ пакетного ввода и ввода по услуге: пациенты, значени€ однопольных, нормы
  private void fill(Model m, List<AmbPatientServices> rows) {
    HashMap<Integer, AmbPatients> pats = new HashMap<Integer, AmbPatients>();
    HashMap<Integer, String> vals = new HashMap<Integer, String>();
    HashMap<Integer, FormField> norms = new HashMap<Integer, FormField>();
    List<AmbPatientServices> single = new ArrayList<AmbPatientServices>(), forms = new ArrayList<AmbPatientServices>(), texts = new ArrayList<AmbPatientServices>();
    StringBuilder pids = new StringBuilder(), rids = new StringBuilder();
    for (AmbPatientServices r : rows) {
      String k = kind(r.getService());
      if ("single".equals(k)) {
        single.add(r);
        if (r.getResult() != null && r.getResult() > 0) rids.append(rids.length() > 0 ? "," : "").append(r.getResult());
        int sid = r.getService().getId();
        if (!norms.containsKey(sid)) {
          List<FormField> ff = sForm.createFields(r.getService().getForm_id(), sid);
          if (!ff.isEmpty()) norms.put(sid, ff.get(0));
        }
      } else if ("form".equals(k)) forms.add(r);
      else texts.add(r);
      pids.append(pids.length() > 0 ? "," : "").append(r.getPatient());
    }
    if (pids.length() > 0)
      for (AmbPatients p : dAmbPatients.getList("From AmbPatients Where id In (" + pids + ")")) pats.put(p.getId(), p);
    if (rids.length() > 0)
      for (AmbResults r : dAmbResults.getList("From AmbResults Where id In (" + rids + ")")) vals.put(r.getId(), r.getC1());
    m.addAttribute("pats", pats);
    m.addAttribute("vals", vals);
    m.addAttribute("norms", norms);
    m.addAttribute("single", single);
    m.addAttribute("forms", forms);
    m.addAttribute("texts", texts);
  }

  // ѕакетный ввод по пациенту: услуги, назначенные текущему врачу (к выполнению и выполненные)
  @RequestMapping("/batch.s")
  protected String batch(HttpServletRequest req, Model m) {
    Session session = SessionUtil.getUser(req);
    int id = Util.getInt(req, "id");
    AmbPatients pat = dAmbPatients.get(id);
    if (pat == null) return "redirect:/amb/home.s";
    session.setCurPat(id);
    session.setCurUrl("/amb/batch.s?id=" + id);
    List<AmbPatientServices> rows = dAmbPatientServices.getList("From AmbPatientServices t Where t.patient = " + id +
      " And t.state In ('PAID', 'DONE') And t.worker.id = " + session.getUserId() + " Order By t.service.name");
    fill(m, rows);
    m.addAttribute("p", pat);
    m.addAttribute("backUrl", session.isArchive() ? "/amb/archive.s" : "/amb/home.s");
    return "med/amb/batch";
  }

  // ѕо услугам: услуги врача у текущих пациентов (как в списке пациентов врача: состо€ние WORK, DONE)
  @RequestMapping("/svcs.s")
  protected String services(HttpServletRequest req, Model m) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/amb/svcs.s");
    session.setCurPat(0);
    List<Map<String, Object>> rows = new ArrayList<Map<String, Object>>();
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
      conn = DB.getConnection();
      ps = conn.prepareStatement(
        "Select s.id, s.name, s.form_id, Count(*), Sum(Case When c.state = 'PAID' Then 1 Else 0 End), " +
        "       Sum(Case When c.state = 'PAID' And c.result > 0 Then 1 Else 0 End) " +
        "  From amb_patient_services c Join amb_services s On s.id = c.service_id Join amb_patients t On t.id = c.patient " +
        " Where t.state In ('WORK', 'DONE') And c.state In ('PAID', 'DONE') And c.worker_id = ? " +
        " Group By s.id, s.name, s.form_id Order By s.name");
      ps.setInt(1, session.getUserId());
      rs = ps.executeQuery();
      while (rs.next()) {
        Map<String, Object> r = new HashMap<String, Object>();
        int f = rs.getInt(3);
        r.put("id", rs.getInt(1));
        r.put("name", rs.getString(2));
        r.put("kind", f == 0 ? "text" : f == 777 || f == 888 ? "single" : "form");
        r.put("total", rs.getInt(4));
        r.put("todo", rs.getInt(5));
        r.put("filled", rs.getInt(6));
        rows.add(r);
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(conn, ps, rs);
    }
    m.addAttribute("rows", rows);
    return "med/amb/svcs";
  }

  // ¬вод по одной услуге: пациенты врача с этой услугой; all=Y Ч вместе с выполненными
  @RequestMapping("/svcPatients.s")
  protected String svcPatients(HttpServletRequest req, Model m) {
    Session session = SessionUtil.getUser(req);
    int sid = Util.getInt(req, "service");
    boolean all = "Y".equals(req.getParameter("all"));
    session.setCurPat(0);
    session.setCurUrl("/amb/svcPatients.s?service=" + sid + (all ? "&all=Y" : ""));
    List<AmbPatientServices> rows = dAmbPatientServices.getList("From AmbPatientServices t Where t.service.id = " + sid +
      " And t.worker.id = " + session.getUserId() + " And t.state In (" + (all ? "'PAID', 'DONE'" : "'PAID'") + ")" +
      " And t.patient In (Select p.id From AmbPatients p Where p.state In ('WORK', 'DONE')) Order By t.id");
    fill(m, rows);
    // по алфавиту пациентов
    @SuppressWarnings("unchecked") final Map<Integer, AmbPatients> pats = (Map<Integer, AmbPatients>) m.asMap().get("pats");
    Comparator<AmbPatientServices> byFio = new Comparator<AmbPatientServices>() {
      public int compare(AmbPatientServices a, AmbPatientServices b) {
        AmbPatients x = pats.get(a.getPatient()), y = pats.get(b.getPatient());
        return Util.nvl(x == null ? "" : x.getFio()).compareToIgnoreCase(Util.nvl(y == null ? "" : y.getFio()));
      }
    };
    for (String key : new String[]{"single", "forms", "texts"}) {
      @SuppressWarnings("unchecked") List<AmbPatientServices> l = (List<AmbPatientServices>) m.asMap().get(key);
      Collections.sort(l, byFio);
    }
    m.addAttribute("svc", rows.isEmpty() ? null : rows.get(0).getService());
    m.addAttribute("svcId", sid);
    m.addAttribute("all", all);
    return "med/amb/batch";
  }
}
