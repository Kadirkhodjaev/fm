package ckb.dao.admin.nurse;

import ckb.dao.DaoImp;
import ckb.domains.admin.NurseDepts;

public class DNurseDeptImp extends DaoImp<NurseDepts> implements DNurseDept {

  public DNurseDeptImp( ) {
    super(NurseDepts.class);
  }

}
