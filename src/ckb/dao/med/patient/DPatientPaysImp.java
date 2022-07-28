package ckb.dao.med.patient;

import ckb.dao.DaoImp;
import ckb.domains.med.patient.PatientPays;

import java.util.ArrayList;
import java.util.List;

public class DPatientPaysImp extends DaoImp<PatientPays> implements DPatientPays {

  public DPatientPaysImp() {
    super(PatientPays.class);
  }


  @Override
  public List<PatientPays> byPatient(Integer id) {
    try {
      return getList("From PatientPays Where patient_id = " + id);
    } catch (Exception e) {
      return new ArrayList<PatientPays>();
    }
  }
}
