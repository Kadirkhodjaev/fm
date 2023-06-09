package ckb.dao.med.head_nurse.drug;

import ckb.dao.Dao;
import ckb.domains.med.head_nurse.HNDrugs;

public interface DHNDrug extends Dao<HNDrugs> {
  void delByDoc(int id);

  Double getTransferRasxod(int hndrug);
}
