package ckb.controllers.mo;

import ckb.session.Session;
import ckb.session.SessionUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping(value = "/stat/")
public class CStatPatient {

  @RequestMapping("/list.s")
  protected String main(HttpServletRequest r, Model model){
    try {
      Session session = SessionUtil.getUser(r);
    } catch (Exception e) {
      e.printStackTrace();
    }
    return "";
  }

}
