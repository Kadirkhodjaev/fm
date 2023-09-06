package ckb.dao.med.patient;

import ckb.dao.DaoImp;
import ckb.domains.med.patient.PatientDrugs;
import ckb.utils.Util;

import java.util.Date;
import java.util.List;

public class DPatientDrugImp extends DaoImp<PatientDrugs> implements DPatientDrug {
  public DPatientDrugImp() {
    super(PatientDrugs.class);
  }

  @Override
  public List<PatientDrugs> byPatient(int patientId) {
    return getList("From PatientDrugs Where patient.id = " + patientId);
  }

  @Override
  public List<PatientDrugs> byType(int curPat, int type) {
    return getList("From PatientDrugs Where patient.id = " + curPat + " And drugType.id = " + type);
  }

  @Override
  public List<PatientDrugs> byTypeToDate(Integer curPat, int type, Date operDay, String time) {
    return getList("From PatientDrugs t Where t.patient.id = " + curPat + " And t.drugType.id = " + type + " And Exists (Select 1 From PatientDrugDates c Where c.checked = 1 And c.date = '" + Util.dateDB(Util.dateToString(operDay)) + "' And c.patientDrug.id = t.id) And " + (time.equals("1") ? "t.morningTime = 1" : time.equals("2") ? "t.noonTime=1" : "t.eveningTime=1"));
  }
}
