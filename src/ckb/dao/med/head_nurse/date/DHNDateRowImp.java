package ckb.dao.med.head_nurse.date;

import ckb.dao.DaoImp;
import ckb.domains.med.head_nurse.HNDateRows;

public class DHNDateRowImp extends DaoImp<HNDateRows> implements DHNDateRow {
  public DHNDateRowImp() {
    super(HNDateRows.class);
  }
}
