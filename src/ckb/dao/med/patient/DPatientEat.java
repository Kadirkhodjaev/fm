package ckb.dao.med.patient;

import ckb.dao.Dao;
import ckb.domains.med.eat.dict.EatTables;
import ckb.domains.med.patient.PatientEats;

import java.util.List;

public interface DPatientEat extends Dao<PatientEats> {

  List<PatientEats> getPatientEat(Integer patientId);

  Integer getPatientTable(Integer id);

  EatTables minTable(Integer id);
}
