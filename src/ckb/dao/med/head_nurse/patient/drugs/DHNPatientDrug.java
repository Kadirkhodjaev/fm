package ckb.dao.med.head_nurse.patient.drugs;

import ckb.dao.Dao;
import ckb.domains.med.head_nurse.HNPatientDrugs;

public interface DHNPatientDrug extends Dao<HNPatientDrugs> {
  void deletePatient(int id);
}
