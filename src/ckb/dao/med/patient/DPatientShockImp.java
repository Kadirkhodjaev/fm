package ckb.dao.med.patient;

import ckb.dao.DaoImp;
import ckb.domains.med.patient.PatientShocks;

public class DPatientShockImp extends DaoImp<PatientShocks> implements DPatientShock {
  public DPatientShockImp() {
    super(PatientShocks.class);
  }
}
