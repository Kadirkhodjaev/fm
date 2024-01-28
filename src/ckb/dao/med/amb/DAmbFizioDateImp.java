package ckb.dao.med.amb;

import ckb.dao.DaoImp;
import ckb.domains.med.amb.AmbFizioDates;
import ckb.domains.med.amb.AmbPatients;

import java.util.Calendar;
import java.util.Date;

public class DAmbFizioDateImp extends DaoImp<AmbFizioDates> implements DAmbFizioDate {
  public DAmbFizioDateImp() {
    super(AmbFizioDates.class);
  }

  @Override
  public Date getPatientMaxDate(AmbPatients patient) {
    Date end = null;
    try {
      end = (Date) entityManager.createQuery("Select Max(date) From AmbFizioDates Where fizio.patient = " + patient.getId()).getSingleResult();
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
