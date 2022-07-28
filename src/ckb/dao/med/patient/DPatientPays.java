package ckb.dao.med.patient;

import ckb.dao.Dao;
import ckb.domains.med.patient.PatientPays;

import java.util.List;

public interface DPatientPays extends Dao<PatientPays> {

  List<PatientPays> byPatient(Integer id);

}
