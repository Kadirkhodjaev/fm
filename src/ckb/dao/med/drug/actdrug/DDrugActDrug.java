package ckb.dao.med.drug.actdrug;

import ckb.dao.Dao;
import ckb.domains.med.drug.DrugActDrugs;
import ckb.domains.med.drug.dict.Drugs;

import java.util.List;

public interface DDrugActDrug extends Dao<DrugActDrugs> {
  void deleteByAct(int id);

  List<Drugs> getExists();

  List<DrugActDrugs> byDrug(Integer drugId);

  Double getActSum(Integer id);
}
