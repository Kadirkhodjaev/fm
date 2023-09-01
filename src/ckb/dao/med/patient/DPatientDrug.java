package ckb.dao.med.patient;

import ckb.dao.Dao;
import ckb.domains.med.patient.PatientDrugs;

import java.util.Date;
import java.util.List;

public interface DPatientDrug extends Dao<PatientDrugs> {

  List<PatientDrugs> byPatient(int patientId);

  List<PatientDrugs> byType(int curPat, int type);

  List<PatientDrugs> byTypeToDate(Integer curPat, int type, Date operDay);
}
