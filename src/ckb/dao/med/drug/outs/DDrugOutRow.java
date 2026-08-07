package ckb.dao.med.drug.outs;

import ckb.dao.Dao;
import ckb.domains.med.drug.DrugOutRows;

public interface DDrugOutRow extends Dao<DrugOutRows> {
  void delByDoc(int id);

  Double getActSum(Integer id);

  double getIncomeRasxod(Integer id);
}
