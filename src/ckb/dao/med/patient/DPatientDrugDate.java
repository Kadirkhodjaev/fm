package ckb.dao.med.patient;

import ckb.dao.Dao;
import ckb.domains.med.patient.PatientDrugDates;

import java.util.Date;

public interface DPatientDrugDate extends Dao<PatientDrugDates> {
  Date minDate(int curPat);

  Date maxDate(int curPat);
}
