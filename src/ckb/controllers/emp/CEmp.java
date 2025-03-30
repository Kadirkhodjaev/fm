package ckb.controllers.emp;

import ckb.dao.admin.users.DUser;
import ckb.dao.emp.DEmp;
import ckb.dao.emp.DEmpDoctor;
import ckb.dao.med.client.DClient;
import ckb.session.Session;
import ckb.session.SessionUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/emp")
public class CEmp {

  @Autowired private DEmp dEmp;
  @Autowired private DEmpDoctor dEmpDoctor;
  @Autowired private DUser dUser;
  @Autowired private DClient dClient;

  @RequestMapping("/index.s")
  protected String changePass(HttpServletRequest req, Model model){
    Session session = SessionUtil.getUser(req);

    return "/emp/index";
  }

}
