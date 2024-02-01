package ckb.dao.med.amb;

import ckb.dao.Dao;
import ckb.domains.med.amb.AmbPatientTreatmentDates;
import ckb.domains.med.amb.AmbPatients;

import java.util.Date;

public interface DAmbPatientTreatmentDate extends Dao<AmbPatientTreatmentDates> {
  Date getPatientMaxDate(AmbPatients patient);
}
