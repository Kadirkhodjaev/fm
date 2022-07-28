package ckb.dao.med.patient;

import ckb.dao.DaoImp;
import ckb.domains.med.patient.PatientDrugRows;

import java.util.List;

public class DPatientDrugRowImp extends DaoImp<PatientDrugRows> implements DPatientDrugRow {
  public DPatientDrugRowImp() {
    super(PatientDrugRows.class);
  }

  @Override
  public List<PatientDrugRows> byDrug(int id) {
    return getList("From PatientDrugRows Where drug.id = " + id);
  }
}
