package ckb.dao.med.drug.actdrug;

import ckb.dao.Dao;
import ckb.domains.med.drug.DrugActDrugs;
import ckb.domains.med.drug.dict.Drugs;

import java.util.List;

public interface DDrugActDrug extends Dao<DrugActDrugs> {
  void deleteByAct(int id);

  List<Drugs> getExists();

  Double getActSum(Integer id);
}
