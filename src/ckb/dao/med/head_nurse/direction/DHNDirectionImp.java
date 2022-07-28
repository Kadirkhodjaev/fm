package ckb.dao.med.head_nurse.direction;

import ckb.dao.DaoImp;
import ckb.domains.med.head_nurse.HNDirections;

public class DHNDirectionImp extends DaoImp<HNDirections> implements DHNDirection {
  public DHNDirectionImp() {
    super(HNDirections.class);
  }
}
