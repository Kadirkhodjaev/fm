package ckb.dao.med.drug.write_off;

import ckb.dao.Dao;
import ckb.domains.med.drug.DrugWriteOffRows;

public interface DDrugWriteOffRow extends Dao<DrugWriteOffRows> {
  void delByDoc(int id);

  Double getActSum(Integer id);
}
