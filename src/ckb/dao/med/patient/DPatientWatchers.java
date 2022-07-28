package ckb.dao.med.patient;

import ckb.dao.Dao;
import ckb.domains.med.patient.PatientWatchers;

import java.util.List;

public interface DPatientWatchers extends Dao<PatientWatchers> {
  List<PatientWatchers> byPatient(Integer id);
}