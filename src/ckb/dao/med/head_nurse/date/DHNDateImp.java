package ckb.dao.med.head_nurse.date;

import ckb.dao.DaoImp;
import ckb.domains.med.head_nurse.HNDates;

public class DHNDateImp extends DaoImp<HNDates> implements DHNDate {
  public DHNDateImp() {
    super(HNDates.class);
  }
}
