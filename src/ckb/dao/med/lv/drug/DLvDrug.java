package ckb.dao.med.lv.drug;

import ckb.dao.Dao;
import ckb.domains.med.lv.LvDrugs;

import java.util.Date;
import java.util.List;

public interface DLvDrug extends Dao<LvDrugs> {
  List<LvDrugs> getPatientDrugs(Integer patientId);

  Date minDate(int curPat);

  List<LvDrugs> getPatientTabs(int curPat);
  List<LvDrugs> getPatientInes(int curPat);
}
