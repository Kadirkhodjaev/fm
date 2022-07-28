package ckb.dao.med.patient;

import ckb.dao.Dao;
import ckb.domains.med.patient.PatientPlans;

public interface DPatientPlan extends Dao<PatientPlans> {

  void delPlan(Integer planId);

  void delPatientTempPlans(Integer id);

  PatientPlans byPlan(Integer id);
}
