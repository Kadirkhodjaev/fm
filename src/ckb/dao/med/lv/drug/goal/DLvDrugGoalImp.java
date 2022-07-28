package ckb.dao.med.lv.drug.goal;

import ckb.dao.DaoImp;
import ckb.domains.med.lv.LvDrugGoals;

public class DLvDrugGoalImp extends DaoImp<LvDrugGoals> implements DLvDrugGoal {
  public DLvDrugGoalImp() {
    super(LvDrugGoals.class);
  }
}
