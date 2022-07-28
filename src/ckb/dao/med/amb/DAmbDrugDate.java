package ckb.dao.med.amb;

import ckb.dao.Dao;
import ckb.domains.med.amb.AmbDrugDates;

import java.util.Date;

public interface DAmbDrugDate extends Dao<AmbDrugDates> {
  Date minDate(int curPat);

  Date maxDate(int curPat);
}
