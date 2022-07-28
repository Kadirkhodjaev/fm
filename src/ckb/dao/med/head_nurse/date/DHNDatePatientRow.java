package ckb.dao.med.head_nurse.date;

import ckb.dao.Dao;
import ckb.domains.med.head_nurse.HNDatePatientRows;

public interface DHNDatePatientRow extends Dao<HNDatePatientRows> {
  void delByDoc(int id);
}
