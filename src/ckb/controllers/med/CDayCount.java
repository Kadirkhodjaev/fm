package ckb.controllers.med;

import ckb.dao.med.patient.DPatient;
import ckb.domains.med.patient.Patients;
import ckb.services.med.patient.DayCount;
import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.Util;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.Date;

/** Кол-во койко-дней в карточке пациента -> Регистрация: просмотр, изменение лечащим врачом или администратором, история */
@Controller
@RequestMapping("/reg/days")
public class CDayCount {

  @Autowired private DPatient dPatient;

  private static String fmt(Date d) {
    return d == null ? "" : new SimpleDateFormat("dd.MM.yyyy").format(d);
  }

  @RequestMapping("/info.s")
  @ResponseBody
  protected String info(HttpServletRequest req) throws Exception {
    Session session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      Patients p = dPatient.get(Util.getInt(req, "id"));
      json.put("days", p.getDayCount() == null ? "" : String.valueOf(p.getDayCount()));
      json.put("begin", fmt(p.getDateBegin()));
      json.put("planEnd", fmt(DayCount.planEnd(p.getDateBegin(), p.getDayCount())));
      json.put("dateEnd", fmt(p.getDateEnd()));
      json.put("canEdit", !DayCount.regEditable(p) && DayCount.canChange(session, p));
      // минимум, при котором выписка (регистрация + дни - 1) не раньше сегодняшнего дня
      json.put("min", p.getDateEnd() == null ? DayCount.minDays(p.getDateBegin()) : 1);
      json.put("max", DayCount.MAX_DAYS);
      // время ухода в день выписки: после какого приёма пищи
      int meal = DayCount.leave(p.getId());
      json.put("leave", meal);
      json.put("leaveCanEdit", DayCount.canChange(session, p) && !"ARCH".equals(p.getState()) && !DayCount.regEditable(p));
      json.put("leaveRequired", "LV".equals(p.getState()) && DayCount.leaveRequired(DayCount.planEnd(p.getDateBegin(), p.getDayCount()), meal));
      json.put("leaveOptions", leaveOptions(p));
      JSONArray h = new JSONArray();
      for (String[] r : DayCount.history(p.getId())) {
        JSONObject o = new JSONObject();
        o.put("date", r[0]);
        o.put("user", r[1]);
        o.put("from", r[2]);
        o.put("to", r[3]);
        o.put("reason", r[4]);
        h.put(o);
      }
      json.put("history", h);
      json.put("success", true);
    } catch (Exception e) {
      e.printStackTrace();
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping(value = "/change.s", method = RequestMethod.POST)
  @ResponseBody
  protected String change(HttpServletRequest req) throws Exception {
    Session session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      Patients p = dPatient.get(Util.getInt(req, "id"));
      if (DayCount.regEditable(p)) return Util.err(json, "Пациент ещё у приёмного отделения: кол-во дней меняется в регистрации.");
      if (!DayCount.canChange(session, p)) return Util.err(json, "Кол-во койко-дней меняют только лечащий врач пациента и администратор.");
      Integer days;
      try {
        days = Integer.parseInt(Util.nvl(Util.get(req, "days")).trim());
      } catch (Exception e) {
        return Util.err(json, "Укажите кол-во койко-дней числом.");
      }
      String reason = Util.nvl(Util.get(req, "reason")).trim();
      if (reason.isEmpty()) return Util.err(json, "Укажите причину изменения.");
      if (days.equals(p.getDayCount())) return Util.err(json, "Кол-во дней не изменилось.");
      String err = DayCount.check(p, days);
      if (err != null) return Util.err(json, err);
      Integer old = p.getDayCount();
      p.setDayCount(days);
      // discharge date always follows registration + bed-days
      if (p.getDateEnd() != null) p.setDateEnd(DayCount.planEnd(p.getDateBegin(), days));
      dPatient.save(p);
      DayCount.afterChange(p, old, days, reason, session.getUserId());
      json.put("planEnd", fmt(DayCount.planEnd(p.getDateBegin(), days)));
      return Util.success(json);
    } catch (Exception e) {
      e.printStackTrace();
      return Util.err(json, e.getMessage());
    }
  }

  /** Варианты времени ухода: «после <приём пищи>» для дня выписки и «завтрак следующего дня» */
  private JSONArray leaveOptions(Patients p) throws Exception {
    JSONArray arr = new JSONArray();
    java.sql.Connection conn = ckb.utils.DB.getConnection();
    try {
      java.util.List<Object[]> types = DayCount.menuTypes(conn);
      Date end = DayCount.planEnd(p.getDateBegin(), p.getDayCount());
      for (int k = 0; k < types.size(); k++) {
        JSONObject o = new JSONObject();
        o.put("id", k + 1);
        o.put("name", "После: " + types.get(k)[1] + (k == 0 ? " (обычно)" : ""));
        arr.put(o);
      }
      if (!types.isEmpty()) {
        JSONObject o = new JSONObject();
        o.put("id", DayCount.NEXT_BREAKFAST);
        o.put("name", "Остаётся на " + types.get(0)[1] + " следующего дня" + (end == null ? "" : " (" + fmt(DayCount.addDays(end, 1)) + ")"));
        arr.put(o);
      }
    } finally {
      ckb.utils.DB.done(conn);
    }
    return arr;
  }

  /** Время ухода в день выписки: лечащий врач пациента или админ */
  @RequestMapping(value = "/leave.s", method = RequestMethod.POST)
  @ResponseBody
  protected String leave(HttpServletRequest req) throws Exception {
    Session session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      Patients p = dPatient.get(Util.getInt(req, "id"));
      if (!DayCount.canChange(session, p)) return Util.err(json, "Время ухода выбирают только лечащий врач пациента и администратор.");
      int meal = Util.getInt(req, "meal");
      if (meal < 1 || (meal > 20 && meal != DayCount.NEXT_BREAKFAST)) return Util.err(json, "Выберите, после какого питания уходит пациент.");
      DayCount.setLeave(p.getId(), meal, session.getUserId());
      return Util.success(json);
    } catch (Exception e) {
      e.printStackTrace();
      return Util.err(json, e.getMessage());
    }
  }

  /** Пациенты текущего лечащего врача, которым пора выбрать время ухода (окно-блокировка на главной странице) */
  @RequestMapping("/pending.s")
  @ResponseBody
  protected String pending(HttpServletRequest req) throws Exception {
    Session session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    try {
      JSONArray arr = new JSONArray();
      if (session != null && session.getRoleId() == 5) {
        for (String[] r : DayCount.leavePending(session.getUserId())) {
          JSONObject o = new JSONObject();
          o.put("id", r[0]);
          o.put("fio", r[1]);
          o.put("ib", r[2]);
          o.put("room", r[3]);
          o.put("end", r[4]);
          Patients p = dPatient.get(Integer.parseInt(r[0]));
          o.put("options", leaveOptions(p));
          arr.put(o);
        }
      }
      json.put("items", arr);
      json.put("success", true);
    } catch (Exception e) {
      e.printStackTrace();
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }
}
