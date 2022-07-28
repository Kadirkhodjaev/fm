package ckb.dao.admin.roles;

import ckb.dao.DaoImp;
import ckb.domains.admin.Roles;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 25.08.15
 * Time: 18:50
 * To change this template use File | Settings | File Templates.
 */
public class DRoleImp extends DaoImp<Roles> implements DRole {
  public DRoleImp() {
    super(Roles.class);
  }
}
