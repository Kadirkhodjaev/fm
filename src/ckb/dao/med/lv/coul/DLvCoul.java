package ckb.dao.med.lv.coul;

import ckb.dao.Dao;
import ckb.domains.med.lv.LvCouls;

public interface DLvCoul extends Dao<LvCouls> {

  LvCouls getByPlan(Integer planId);

  void deletePlan(int id);
}
