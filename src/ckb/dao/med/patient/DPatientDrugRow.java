package ckb.dao.med.patient;

import ckb.dao.Dao;
import ckb.domains.med.patient.PatientDrugRows;

import java.util.List;

public interface DPatientDrugRow extends Dao<PatientDrugRows> {
  List<PatientDrugRows> byDrug(int id);
}
