package ckb.dao.med.lv.torch;

import ckb.dao.Dao;
import ckb.domains.med.lv.LvTorchs;

public interface DLvTorch extends Dao<LvTorchs> {

  LvTorchs getByPlan(Integer planId);

  void deletePlan(int id);
}
