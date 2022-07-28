package ckb.dao.med.patient;

import ckb.dao.DaoImp;
import ckb.domains.med.patient.PatientDrugTemps;

public class DPatientDrugTempImp extends DaoImp<PatientDrugTemps> implements DPatientDrugTemp {
  public DPatientDrugTempImp() {
    super(PatientDrugTemps.class);
  }
}
