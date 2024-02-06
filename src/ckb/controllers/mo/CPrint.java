package ckb.controllers.mo;

import ckb.dao.print.page.DPrintPage;
import ckb.domains.print.PrintPages;
import ckb.utils.Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping(value = "/print/")
public class CPrint {

  @Autowired private DPrintPage dPrintPage;

  @RequestMapping("/index.s")
  protected String printCheck(HttpServletRequest req, Model model) {
    PrintPages page = dPrintPage.get(Util.getInt(req, "print_page_id", 0));
    if(page == null) {
      page = new PrintPages();
      page.setUrl("/print/404.s");
    }
    model.addAttribute("page", page);
    model.addAttribute("params", Util.get(req, "params"));
    return "mo/print/index";
  }

  @RequestMapping("/404.s")
  protected String page_not_found() {
    return "mo/print/404";
  }

}
