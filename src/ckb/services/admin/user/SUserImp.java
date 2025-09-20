package ckb.services.admin.user;

import ckb.dao.admin.users.DUser;
import ckb.dao.admin.users.DUserIp;
import ckb.dao.admin.users.DUserLog;
import ckb.domains.admin.Roles;
import ckb.domains.admin.UserLogs;
import ckb.domains.admin.Users;
import ckb.session.Session;
import ckb.utils.BeanSession;
import ckb.utils.Req;
import ckb.utils.Util;
import org.springframework.beans.factory.annotation.Autowired;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 19.08.15
 * Time: 23:23
 * To change this template use File | Settings | File Templates.
 */
public class SUserImp implements SUser {

  @Autowired DUser dUser;
  @Autowired BeanSession beanSession;
  @Autowired DUserLog dUserLog;
  @Autowired DUserIp dUserIp;

  @Override
  public Session login(HttpServletRequest request) {
    Session session;
    Users user;
    if(Util.isNull(request, "session_user_id"))
      user = dUser.getByLoginPassword(Req.get(request, "login"), Req.get(request, "password"));
    else
      user = dUser.get(Util.getInt(request, "session_user_id"));
    if(user == null || !user.isActive()) return null;
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
    Map<String, String> list = beanSession.getParams();
    session.setParams(list);
    UserLogs log = new UserLogs();
    log.setUser(user);
    log.setIp(ip);
    log.setDateTime(new Date());
    dUserLog.save(log);
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

}
