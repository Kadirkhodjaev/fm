package ckb.dao.admin.users;

import ckb.dao.DaoImp;
import ckb.domains.admin.UserIps;

public class DUserIpImp extends DaoImp<UserIps> implements DUserIp {
  public DUserIpImp() {
    super(UserIps.class);
  }
}
