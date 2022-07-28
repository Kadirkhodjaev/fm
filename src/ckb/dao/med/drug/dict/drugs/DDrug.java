package ckb.dao.med.drug.dict.drugs;

import ckb.dao.Dao;
import ckb.domains.med.drug.dict.Drugs;

public interface DDrug extends Dao<Drugs> {
  boolean isNameExist(Drugs obj);

  Double getRealSaldo(Integer drugId, Double expense);
}
