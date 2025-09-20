package ckb.dao.med.patient;

import ckb.dao.DaoImp;
import ckb.domains.med.patient.PatientTabExps;

public class DPatientTabExpImp extends DaoImp<PatientTabExps> implements DPatientTabExp {

  public DPatientTabExpImp() {
    super(PatientTabExps.class);
  }
}
