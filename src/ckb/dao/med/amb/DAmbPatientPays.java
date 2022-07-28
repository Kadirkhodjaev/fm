package ckb.dao.med.amb;

import ckb.dao.Dao;
import ckb.domains.med.amb.AmbPatientPays;

import java.util.List;

public interface DAmbPatientPays extends Dao<AmbPatientPays> {
  List<AmbPatientPays> byPatient(int curPat);
}
