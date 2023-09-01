package ckb.controllers.admin;

import ckb.dao.admin.forms.DForm;
import ckb.dao.admin.users.DUser;
import ckb.dao.med.amb.DAmbGroups;
import ckb.dao.med.amb.DAmbServiceFields;
import ckb.dao.med.amb.DAmbServiceUsers;
import ckb.dao.med.amb.DAmbServices;
import ckb.domains.admin.Users;
import ckb.domains.med.amb.AmbGroups;
import ckb.domains.med.amb.AmbServiceFields;
import ckb.domains.med.amb.AmbServiceUsers;
import ckb.domains.med.amb.AmbServices;
import ckb.models.AmbService;
import ckb.session.Session;
import ckb.session.SessionUtil;
import ckb.utils.Util;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@Controller
@RequestMapping("/core/amb/")
public class CCoreAmb {

  @Autowired private DAmbServiceFields dAmbServiceFields;
  @Autowired private DAmbServices dAmbServices;
  @Autowired private DAmbServiceUsers dAmbServiceUsers;
  @Autowired private DUser dUser;
  @Autowired private DForm dForm;
  @Autowired private DAmbGroups dAmbGroups;

  @RequestMapping("/services.s")
  protected String amb(HttpServletRequest request, Model model){
    Session session = SessionUtil.getUser(request);
    session.setCurUrl("/core/amb/services.s");
    //
    String page = Util.get(request, "page");
    if(page == null) page = session.getDateBegin().get("admin_amb_index");
    if(page == null) page = "0";
    //
    HashMap<String, String> dh = session.getDateBegin();
    dh.put("admin_amb_index", page);
    session.setDateBegin(dh);
    //
    List<AmbService> services = new ArrayList<>();
    List<AmbServices> list = dAmbServices.getList("From AmbServices t " + (page.equals("0") ? "" : " Where  group.id = " + page) + " Order By t.state, t.group.id");
    for(AmbServices l:list) {
      AmbService s = new AmbService();
      s.setId(l.getId());
      s.setService(l);
      services.add(s);
    }
    model.addAttribute("services", services);
    model.addAttribute("groups", dAmbGroups.getAll());
    model.addAttribute("page", page);
    return "/core/amb/index";
  }

  @RequestMapping("/service/save.s")
  protected String addAmb(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/core/amb/service/save.s?id=" + Util.nvl(req, "id"));
    model.addAttribute("groups", dAmbGroups.getAll());
    model.addAttribute("forms", dForm.getList("From Forms Where amb = 'Y'"));
    if(Util.isNotNull(req, "id")) {
      model.addAttribute("ser", dAmbServices.get(Util.getInt(req, "id")));
      model.addAttribute("rows", dAmbServiceFields.byService(Util.getInt(req, "id")));
      StringBuilder users = new StringBuilder();
      for(AmbServiceUsers rw: dAmbServiceUsers.getList("From AmbServiceUsers Where service = " + Util.get(req, "id"))) {
        Users u = dUser.get(rw.getUser());
        users.append(u.getFio()).append("; ");
      }
      model.addAttribute("users", users.toString());
    }
    return "/core/amb/add";
  }

  @RequestMapping(value = "/service/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String addAmb(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      AmbServices ser = Util.isNull(req, "id") ? new AmbServices() : dAmbServices.get(Util.getInt(req, "id"));
      ser.setName(Util.get(req, "name"));
      ser.setConsul(Util.isNull(req, "consul") ? "N" : "Y");
      ser.setDiagnoz(Util.isNull(req, "diagnoz") ? "N" : "Y");
      ser.setPrice(Double.parseDouble(Util.get(req, "price")));
      ser.setOrd(Util.getInt(req, "ord"));
      ser.setFor_price(Double.parseDouble(Util.get(req, "for_price")));
      ser.setGroup(dAmbGroups.get(Util.getInt(req, "group")));
      ser.setForm_id(Util.getInt(req, "form_id") != -1 ? Util.getInt(req, "form_id") : null);
      ser.setEi(Util.get(req, "ei"));
      ser.setNormaFrom(Util.get(req, "normaFrom"));
      ser.setNormaTo(Util.get(req, "normaTo"));
      ser.setState(Util.isNull(req, "state") ? "P": "A");
      AmbServices ds = dAmbServices.saveAndReturn(ser);
      String[] names = req.getParameterValues("names");
      if(names != null) {
        List<AmbServiceFields> fields = dAmbServiceFields.byService(ds.getId());
        for (AmbServiceFields ff : fields)
          dAmbServiceFields.delete(ff.getId());
        int d = 0;
        for (String name : names) {
          d++;
          AmbServiceFields field = new AmbServiceFields();
          field.setService(ds.getId());
          field.setName(name);
          field.setField(d);
          dAmbServiceFields.save(field);
        }
      }
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

  @RequestMapping("/groups.s")
  protected String amb_groups(HttpServletRequest request, Model model) {
    Session session = SessionUtil.getUser(request);
    session.setCurUrl("/core/amb/groups.s");
    model.addAttribute("groups", dAmbGroups.getAll());
    return "/core/amb/groups";
  }

  @RequestMapping("/group/save.s")
  protected String addGroup(HttpServletRequest req, Model model) {
    Session session = SessionUtil.getUser(req);
    session.setCurUrl("/core/amb/group/save.s?id=" + Util.nvl(req, "id"));
    if(Util.isNotNull(req, "id"))
      model.addAttribute("ser", dAmbGroups.get(Util.getInt(req, "id")));
    return "/core/amb/addGroup";
  }

  @RequestMapping(value = "/group/save.s", method = RequestMethod.POST)
  @ResponseBody
  protected String saveGroup(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      AmbGroups ser = Util.isNull(req, "id") ? new AmbGroups() : dAmbGroups.get(Util.getInt(req, "id"));
      ser.setName(Util.get(req, "name"));
      ser.setGroup(Util.isNotNull(req, "group"));
      ser.setActive(Util.isNotNull(req, "active"));
      dAmbGroups.save(ser);
      json.put("success", true);
    } catch (Exception e) {
      json.put("success", false);
      json.put("msg", e.getMessage());
    }
    return json.toString();
  }

}
