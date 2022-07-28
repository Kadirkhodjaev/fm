package ckb.dao.med.patient;

import ckb.dao.DaoImp;
import ckb.domains.med.patient.PatientDrugs;

import java.util.List;

public class DPatientDrugImp extends DaoImp<PatientDrugs> implements DPatientDrug {
  public DPatientDrugImp() {
    super(PatientDrugs.class);
  }

  @Override
  public List<PatientDrugs> byPatient(int patientId) {
    return getList("From PatientDrugs Where patient.id = " + patientId);
  }

  @Override
  public List<PatientDrugs> byType(int curPat, int type) {
    return getList("From PatientDrugs Where patient.id = " + curPat + " And drugType.id = " + type);
  }
}
