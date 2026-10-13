package ckb.controllers.med;

import ckb.mobile.HomePlan;
import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.DB;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.sql.Connection;

/** Таблица "Препараты на дом" и повторный приём на странице выписки (med/lv/vypiska.jsp), текущий пациент сессии */
@Controller
@RequestMapping("/lv/home")
public class CHomeDrugs {

  @RequestMapping("/get.s")
  @ResponseBody
  protected String get(HttpServletRequest req) throws Exception {
    Session session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    Connection conn = DB.getConnection();
    try {
      json.put("plan", HomePlan.load(conn, session.getCurPat()));
      json.put("success", true);
    } catch (Exception e) {
      e.printStackTrace();
      json.put("success", false);
      json.put("msg", e.getMessage());
    } finally {
      DB.done(conn);
    }
    return json.toString();
  }

  /** Кнопка "Перенести из листа назначений" */
  @RequestMapping("/from_lv.s")
  @ResponseBody
  protected String fromLv(HttpServletRequest req) throws Exception {
    Session session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    Connection conn = DB.getConnection();
    try {
      json.put("drugs", HomePlan.fromPrescriptions(conn, session.getCurPat()));
      json.put("success", true);
    } catch (Exception e) {
      e.printStackTrace();
      json.put("success", false);
      json.put("msg", e.getMessage());
    } finally {
      DB.done(conn);
    }
    return json.toString();
  }

  @RequestMapping(value = "/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String save(HttpServletRequest req) throws Exception {
    Session session = SessionUtil.getUser(req);
    JSONObject json = new JSONObject();
    Connection conn = DB.getConnection();
    try {
      String err = HomePlan.save(conn, session.getCurPat(), session.getUserId(), new JSONObject(req.getParameter("data")));
      json.put("success", err == null);
      if (err != null) json.put("msg", err);
    } catch (Exception e) {
      e.printStackTrace();
      json.put("success", false);
      json.put("msg", e.getMessage());
    } finally {
      DB.done(conn);
    }
    return json.toString();
  }
}
