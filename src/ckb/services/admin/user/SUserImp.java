package ckb.services.admin.user;

import ckb.dao.admin.params.DParam;
import ckb.dao.admin.users.DUser;
import ckb.dao.admin.users.DUserIp;
import ckb.dao.admin.users.DUserLog;
import ckb.domains.admin.Params;
import ckb.domains.admin.Roles;
import ckb.domains.admin.UserLogs;
import ckb.domains.admin.Users;
import ckb.session.Session;
import ckb.utils.Req;
import ckb.utils.Util;
import org.springframework.beans.factory.annotation.Autowired;

import javax.servlet.http.HttpServletRequest;
import java.util.*;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 19.08.15
 * Time: 23:23
 * To change this template use File | Settings | File Templates.
 */
public class SUserImp implements SUser {

  @Autowired DUser dUser;
  @Autowired DParam dParam;
  @Autowired DUserLog dUserLog;
  @Autowired DUserIp dUserIp;

  @Override
  public Session login(HttpServletRequest request) {
    Session session = null;
    Users user;
    if(Util.isNull(request, "session_user_id"))
      user = dUser.getByLoginPassword(Req.get(request, "login"), Req.get(request, "password"));
    else
      user = dUser.get(Util.getInt(request, "session_user_id"));
    if (user != null) {
      session = new Session();
      String ip = request.getRemoteAddr();
      if(dUserIp.getCount("From UserIps Where user.id = " + user.getId()) > 0) {
        if(dUserIp.getCount("From UserIps Where user.id = " + user.getId() + " And ip = '" + ip + "'") == 0) {
          session.setUserId(-1);
          return session;
        }
      }
      session.setUserId(user.getId());
      session.setUserName(user.getFio());
      session.setDeptId(user.getDept() != null ? user.getDept().getId() : 0);
      session.setKdoTypesIds(dUser.getKdoTypesIds(user.getId()));
      List<Params> params = dParam.getAll();
      Map<String, String> list = new HashMap<String, String>();
      for(Params param : params) {
        list.put(param.getCode(), param.getVal());
      }
      session.setParams(list);
      UserLogs log = new UserLogs();
      log.setUser(user);
      log.setIp(ip);
      log.setDateTime(new Date());
      dUserLog.save(log);
    }
    return session;
  }

  @Override
  public List<Roles> getUserRoles(int userId) {
    List<Roles> roles = dUser.get(userId).getRoles();
    List<Roles> list = new ArrayList<Roles>();
    for(Roles r : roles)
      if(r.getState().equals("Y"))
        list.add(r);
    return list;
  }

  @Override
  public void createMode(HttpServletRequest request, Users user) {
    if(!Req.isNull(request, "id")) {
      Users u = dUser.get(Req.getInt(request, "id"));
      user.setId(u.getId());
      user.setLogin(u.getLogin());
      user.setDescription(u.getDescription());
      user.setFio(u.getFio());
      user.setLv(u.isLv());
      user.setActive(u.isActive());
      user.setConsul(u.isConsul());
      user.setZavlv(u.isZavlv());
      user.setDept(u.getDept());
      user.setProfil(u.getProfil());
      user.setAmbAdmin(u.isAmbAdmin());
      user.setAmbFizio(u.isAmbFizio());
      user.setBoss(u.isBoss());
      user.setGlb(u.isGlb());
      user.setGlavbuh(u.isGlavbuh());
      user.setMainNurse(u.isMainNurse());
      user.setDrugDirection(u.isDrugDirection());
      user.setConsul_price(u.getConsul_price());
      user.setFor_consul_price(u.getFor_consul_price());
      user.setReal_consul_price(u.getReal_consul_price());
      user.setFor_real_consul_price(u.getFor_real_consul_price());
      user.setDocfizio(u.isDocfizio());
    }
  }

  @Override
  public Users save(Users user) {
    Users u = user.getId() != null ? dUser.get(user.getId()) : new Users();
    u.setId(user.getId());
    u.setDept(user.getDept().getId() == null ? null : user.getDept());
    u.setFio(user.getFio());
    if(user.getId() == null || !user.getPassword().equals(""))
      u.setPassword(Util.md5(user.getPassword()));
    u.setLogin(user.getLogin());
    u.setLv(user.isLv());
    u.setActive(user.isActive());
    u.setConsul(user.isConsul());
    u.setZavlv(user.isZavlv());
    u.setProfil(user.getProfil());
    u.setAmbAdmin(user.isAmbAdmin());
    u.setAmbFizio(user.isAmbFizio());
    u.setGlavbuh(user.isGlavbuh());
    u.setMainNurse(user.isMainNurse());
    u.setDocfizio(user.isDocfizio());
    u.setDrugDirection(user.isDrugDirection());
    u.setConsul_price(user.getConsul_price());
    u.setFor_consul_price(user.getFor_consul_price());
    u.setReal_consul_price(user.getReal_consul_price());
    u.setFor_real_consul_price(user.getFor_real_consul_price());
    //
    u.setGlb(user.isGlb());
    if(user.isGlb()) {
      Users uglb = dUser.getGlb(user.getId() == null ? 0 : user.getId());
      if(uglb.getId() != null) {
        uglb.setGlb(false);
        dUser.save(uglb);
      }
    }
    //
    u.setBoss(user.isBoss());
    if(user.isBoss()) {
      Users uboss = dUser.getBoss(user.getId() == null ? 0 : user.getId());
      if(uboss.getId() != null) {
        uboss.setBoss(false);
        dUser.save(uboss);
      }
    }
    //
    u.setGlavbuh(user.isGlavbuh());
    if(user.isGlavbuh()) {
      Users uboss = dUser.getGlavbuh(user.getId() == null ? 0 : user.getId());
      if(uboss.getId() != null) {
        uboss.setGlavbuh(false);
        dUser.save(uboss);
      }
    }
    return dUser.saveAndReturn(u);
  }

  @Override
  public List<Users> getLvs() {
    return dUser.getLvs();
  }

  @Override
  public Users getLv(Integer lvId) {
    return dUser.get(lvId);
  }

  @Override
  public List<Users> getConsuls() {
    return dUser.getConsuls();
  }

}
