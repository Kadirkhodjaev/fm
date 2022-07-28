package ckb.dao.med.patient;

import ckb.dao.DaoImp;
import ckb.domains.med.patient.PatientDrugDates;

import java.util.Date;

public class DPatientDrugDateImp extends DaoImp<PatientDrugDates> implements DPatientDrugDate {
  public DPatientDrugDateImp() {
    super(PatientDrugDates.class);
  }

  @Override
  public Date minDate(int curPat) {
    return (Date) entityManager.createQuery("select min (t.date) from PatientDrugDates t where t.patientDrug.patient.id = " + curPat).getSingleResult();
  }

  @Override
  public Date maxDate(int curPat) {
    return (Date) entityManager.createQuery("select max (t.date) from PatientDrugDates t where t.patientDrug.patient.id = " + curPat).getSingleResult();
  }
}
