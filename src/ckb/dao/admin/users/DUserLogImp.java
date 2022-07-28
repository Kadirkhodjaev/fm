package ckb.dao.admin.users;

import ckb.dao.DaoImp;
import ckb.domains.admin.UserLogs;

public class DUserLogImp extends DaoImp<UserLogs> implements DUserLog {

  public DUserLogImp( ) {
    super(UserLogs.class);
  }
}
