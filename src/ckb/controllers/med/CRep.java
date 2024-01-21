package ckb.controllers.med;

import ckb.dao.admin.depts.DDept;
import ckb.dao.admin.forms.opts.DOpt;
import ckb.dao.admin.reports.DRepParam;
import ckb.dao.admin.reports.DReport;
import ckb.dao.admin.users.DUser;
import ckb.dao.med.amb.DAmbGroups;
import ckb.dao.med.amb.DAmbPatientServices;
import ckb.dao.med.amb.DAmbPatients;
import ckb.domains.med.report.RepParams;
import ckb.models.ObjList;
import ckb.services.med.rep.SRep;
import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.DB;
import ckb.utils.Req;
import ckb.utils.Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping("/rep/")
public class CRep {

  private Session session;
  @Autowired DUser dUser;
  @Autowired DRepParam dRepParam;
  @Autowired DReport dReport;
  @Autowired DDept dDept;
  @Autowired DOpt dOpt;
  @Autowired DAmbPatients dAmbPatients;
  @Autowired DAmbPatientServices dAmbPatientServices;
  @Autowired DAmbGroups dAmbGroups;
  @Autowired SRep sRep;

  @RequestMapping("home.s")
  private String home(HttpServletRequest r, Model m){
    session = SessionUtil.getUser(r);
    session.setCurUrl("/rep/home.s?id=" + Req.get(r, "id"));
    m.addAttribute("authErr", session == null);
    m.addAttribute("id", Req.get(r, "id"));
    m.addAttribute("repList", dUser.getReports(session.getUserId()));
    return "/med/rep/index";
  }

  @RequestMapping("run.s")
  private String runRep(HttpServletRequest req, Model m){
    try {
      session = SessionUtil.getUser(req);
      Integer id = Util.getInt(req, "repId");
      sRep.gRep(req, m);
      m.addAttribute("excel", Util.get(req, "word"));
       return "/med/rep/forms/rep" + id;
    } catch (Exception e) {
      return "redirect:/med/rep/home.s";
    }
  }

  @RequestMapping("params.s")
  private String params(HttpServletRequest r, Model m) {
    session = SessionUtil.getUser(r);
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    //
    try {
      conn = DB.getConnection();
      Integer id = Util.getInt(r, "id");
      m.addAttribute("id", id);
      List<RepParams> params = dRepParam.regParams(id);
      List<ObjList> list = new ArrayList<ObjList>();
      for (RepParams param : params) {
        ObjList d = new ObjList();
        d.setC1(param.getId().toString());
        d.setC2(param.getLabel());
        d.setC3(param.getType());
        d.setC5(param.getDate_type());
        d.setC6(param.getName());
        d.setC7(param.getRequired().toString());
        //
        if (param.getType().equals("select")) {
          if (conn == null)
            conn = DB.getConnection();
          ps = conn.prepareStatement(param.getSelectSql());
          ps.execute();
          rs = ps.getResultSet();
          StringBuffer sb = new StringBuffer();
          sb.append("<option value=''></option>");
          while (rs.next())
            sb.append("<option value='" + rs.getString(1) + "'>" + rs.getString(2) + "</option>");
          d.setC4(sb.toString());
        }
        list.add(d);
      }
      m.addAttribute("report", dReport.get(id));
      m.addAttribute("params", list);
      m.addAttribute("sysdate", Util.getCurDate());
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DB.done(ps);
      DB.done(rs);
      DB.done(conn);
    }
    return "/med/rep/params";
  }
}
