package ckb.dao.med.lv.garmon;

import ckb.dao.Dao;
import ckb.domains.med.lv.LvGarmons;

public interface DLvGarmon extends Dao<LvGarmons> {

  LvGarmons getByPlan(Integer planId);

  void deletePlan(int id);
}
