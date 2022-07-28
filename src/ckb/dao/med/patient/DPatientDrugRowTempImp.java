package ckb.dao.med.patient;

import ckb.dao.DaoImp;
import ckb.domains.med.patient.PatientDrugRowTemps;

public class DPatientDrugRowTempImp extends DaoImp<PatientDrugRowTemps> implements DPatientDrugRowTemp {
  public DPatientDrugRowTempImp() {
    super(PatientDrugRowTemps.class);
  }
}
