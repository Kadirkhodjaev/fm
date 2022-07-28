package ckb.dao.med.exp.dict.norm;

import ckb.dao.Dao;
import ckb.domains.med.exp.dict.ExpNorms;

import java.util.List;

public interface DExpNorm extends Dao<ExpNorms> {
  List<Integer> getServiceIds(String parentType);
}
