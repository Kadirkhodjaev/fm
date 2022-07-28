package ckb.services.admin.user;

import ckb.domains.admin.Roles;
import ckb.domains.admin.Users;
import ckb.session.Session;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 19.08.15
 * Time: 23:22
 * To change this template use File | Settings | File Templates.
 */
public interface SUser {
  Session login(HttpServletRequest request);

  List<Roles> getUserRoles(int userId);

  void createMode(HttpServletRequest request, Users user);

  Users save(Users user);

  List<Users> getLvs();

  Users getLv(Integer lvId);

  List<Users> getConsuls();
}
