package ckb.controllers.mo;

import ckb.dao.med.client.DClient;
import ckb.domains.admin.Clients;
import ckb.utils.Util;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
@RequestMapping(value = "/clients/")
public class CClients {

  @Autowired private DClient dClient;

  @RequestMapping("search_by_letters.s")
  @ResponseBody
  protected String search_by_letters(HttpServletRequest req) throws JSONException {
    JSONObject json = new JSONObject();
    try {
      String word = Util.nvl(req, "word");
      JSONArray arr = new JSONArray();
      List<Clients> clients = dClient.list("From Clients Where upper(surname) like '%" + word + "%' Or upper(name) like '%" + word + "%'");
      for(Clients client: clients) {
        JSONObject obj = new JSONObject();
        obj.put("id", client.getId());
        obj.put("name", client.getFio());
        obj.put("birthdate", Util.dateToString(client.getBirthdate()));
        obj.put("sex", client.getSex() == null ? "" : client.getSex().getName());
        obj.put("passport", client.getDocInfo());
        obj.put("country", client.getCountry() == null ? "" : client.getCountry().getName());
        obj.put("region", client.getRegion() == null ? "" : client.getRegion().getName());
        obj.put("address", client.getAddress());
        obj.put("tel", client.getTel());
        arr.put(obj);
      }
      json.put("clients", arr);
      json.put("success", true);
    } catch (Exception e) {
      e.printStackTrace();
      return Util.err(json, e.getMessage());
    }
    return json.toString();
  }

}
