package ckb.dao.med.head_nurse.patient;

import ckb.dao.DaoImp;
import ckb.domains.med.head_nurse.HNPatients;

public class DHNPatientImp extends DaoImp<HNPatients> implements DHNPatient {
  public DHNPatientImp() {
    super(HNPatients.class);
  }
}
