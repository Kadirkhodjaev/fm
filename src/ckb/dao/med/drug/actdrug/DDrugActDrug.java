package ckb.dao.med.drug.actdrug;

import ckb.dao.Dao;
import ckb.domains.med.drug.DrugActDrugs;
import ckb.domains.med.drug.dict.Drugs;

import java.util.List;

public interface DDrugActDrug extends Dao<DrugActDrugs> {
  void deleteByAct(int id);

  List<Drugs> getExists();

  Double getActSum(Integer id);

  // atomic: decreases the batch balance only if there is enough stock; returns the number of changed rows (0 = not enough)
  int takeStock(Integer id, double qty);

  // returns the quantity to the batch (compensation)
  void giveBack(Integer id, double qty);
}
