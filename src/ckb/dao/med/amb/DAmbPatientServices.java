package ckb.dao.med.amb;

import ckb.dao.Dao;
import ckb.domains.med.amb.AmbPatientServices;

import java.util.List;

public interface DAmbPatientServices extends Dao<AmbPatientServices> {

  String patientTotal(int curPat);

  Double patientTotalSum(int curPat);

  List<AmbPatientServices> byUser(int curPat, int userId);
}
