package ckb.dao.med.patient;

import ckb.dao.DaoImp;
import ckb.domains.med.patient.PatientPlans;
import org.springframework.transaction.annotation.Transactional;

public class DPatientPlanImp extends DaoImp<PatientPlans> implements DPatientPlan {

  public DPatientPlanImp() {
    super(PatientPlans.class);
  }

  @Transactional
  public void delPlan(Integer planId) {
    entityManager.createQuery("delete from PatientPlans where plan_Id = " + planId).executeUpdate();
  }

  @Transactional
  public void delPatientTempPlans(Integer id) {
    entityManager.createQuery("delete from PatientPlans where patient_id = " + id).executeUpdate();
  }

  @Override
  public PatientPlans byPlan(Integer id) {
    return getObj("From PatientPlans Where plan_id = " + id);
  }
}
