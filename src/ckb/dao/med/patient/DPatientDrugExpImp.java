package ckb.dao.med.patient;

import ckb.dao.DaoImp;
import ckb.domains.med.patient.PatientDrugExps;

public class DPatientDrugExpImp extends DaoImp<PatientDrugExps> implements DPatientDrugExp {

  public DPatientDrugExpImp() {
    super(PatientDrugExps.class);
  }
}
