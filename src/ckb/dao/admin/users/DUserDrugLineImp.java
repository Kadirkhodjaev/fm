package ckb.dao.admin.users;

import ckb.dao.DaoImp;
import ckb.domains.admin.UserDrugLines;

public class DUserDrugLineImp extends DaoImp<UserDrugLines> implements DUserDrugLine {
  public DUserDrugLineImp() {
    super(UserDrugLines.class);
  }
}
