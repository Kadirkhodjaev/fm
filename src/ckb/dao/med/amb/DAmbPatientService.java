package ckb.dao.med.amb;

import ckb.dao.Dao;
import ckb.domains.med.amb.AmbPatientServices;

import java.util.List;

public interface DAmbPatientService extends Dao<AmbPatientServices> {

  Double patientTotalSum(int curPat);

  Double patientNdsSum(int curPat);

  List<AmbPatientServices> byUser(int curPat, int userId);

}
