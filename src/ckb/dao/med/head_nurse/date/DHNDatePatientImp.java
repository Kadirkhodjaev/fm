package ckb.dao.med.head_nurse.date;

import ckb.dao.DaoImp;
import ckb.domains.med.head_nurse.HNDatePatients;

public class DHNDatePatientImp extends DaoImp<HNDatePatients> implements DHNDatePatient {
  public DHNDatePatientImp() {
    super(HNDatePatients.class);
  }
}
