package ckb.controllers.med;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/fizio/")
public class CFizio {

  @RequestMapping("index.s")
  public String home(){
    return "/med/fizio/index";
  }

}
