package ckb.dao.med.eat.dict.eat.norm;

import ckb.dao.Dao;
import ckb.domains.med.eat.dict.EatNorms;

public interface DEatNorm extends Dao<EatNorms> {
  void deleteByEat(int id);
}
