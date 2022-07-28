package ckb.dao.med.patient;

import ckb.dao.Dao;
import ckb.domains.med.patient.PatientLinks;

public interface DPatientLink extends Dao<PatientLinks> {
  void saveLink(Integer parent, Integer child);

  void deletePatient(int curPat);
}
