package ckb.dao.med.amb;

import ckb.dao.DaoImp;
import ckb.domains.med.amb.AmbDrugDates;

import java.util.Date;

public class DAmbDrugDateImp extends DaoImp<AmbDrugDates> implements DAmbDrugDate {
  public DAmbDrugDateImp() {
    super(AmbDrugDates.class);
  }

  @Override
  public Date minDate(int curPat) {
    return (Date) entityManager.createQuery("select min (t.date) from AmbDrugDates t where t.ambDrug.patient.id = " + curPat).getSingleResult();
  }

  @Override
  public Date maxDate(int curPat) {
    return (Date) entityManager.createQuery("select max (t.date) from AmbDrugDates t where t.ambDrug.patient.id = " + curPat).getSingleResult();
  }
}
