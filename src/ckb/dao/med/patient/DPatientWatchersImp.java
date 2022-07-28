package ckb.dao.med.patient;

import ckb.dao.DaoImp;
import ckb.domains.med.patient.PatientWatchers;

import java.util.ArrayList;
import java.util.List;

public class DPatientWatchersImp extends DaoImp<PatientWatchers> implements DPatientWatchers {

  public DPatientWatchersImp() {
    super(PatientWatchers.class);
  }

  @Override
  public List<PatientWatchers> byPatient(Integer id) {
    try {
      return getList("From PatientWatchers Where patient_id = " + id);
    } catch (Exception e) {
      return new ArrayList<PatientWatchers>();
    }
  }
}
