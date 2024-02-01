package ckb.dao.med.amb;

import ckb.dao.DaoImp;
import ckb.domains.med.amb.AmbPatientTreatmentDates;
import ckb.domains.med.amb.AmbPatients;

import java.util.Calendar;
import java.util.Date;

public class DAmbPatientTreatmentDateImp extends DaoImp<AmbPatientTreatmentDates> implements DAmbPatientTreatmentDate {
  public DAmbPatientTreatmentDateImp() {
    super(AmbPatientTreatmentDates.class);
  }

  @Override
  public Date getPatientMaxDate(AmbPatients patient) {
    Date end;
    try {
      end = (Date) entityManager.createQuery("Select Max(actDate) From AmbPatientTreatmentDates Where patient = " + patient.getId()).getSingleResult();
    } catch (Exception e) {
      end = null;
    }
    if(end == null) {
      Calendar cal = Calendar.getInstance();
      cal.setTime(patient.getRegDate());
      cal.add(Calendar.DATE, 10);
      end = cal.getTime();
    }
    return end;
  }
}
