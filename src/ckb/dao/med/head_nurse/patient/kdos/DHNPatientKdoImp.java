package ckb.dao.med.head_nurse.patient.kdos;

import ckb.dao.DaoImp;
import ckb.domains.med.head_nurse.HNPatientKdos;

public class DHNPatientKdoImp extends DaoImp<HNPatientKdos> implements DHNPatientKdo {

  public DHNPatientKdoImp() {
    super(HNPatientKdos.class);
  }
}
