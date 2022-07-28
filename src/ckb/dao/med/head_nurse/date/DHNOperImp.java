package ckb.dao.med.head_nurse.date;

import ckb.dao.DaoImp;
import ckb.domains.med.head_nurse.HNOpers;

public class DHNOperImp extends DaoImp<HNOpers> implements DHNOper {

  public DHNOperImp() {
    super(HNOpers.class);
  }
}
