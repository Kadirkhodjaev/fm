package ckb.dao.med.lv.plan;

import ckb.dao.DaoImp;
import ckb.domains.med.lv.LvPlans;

import java.util.ArrayList;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 09.07.16
 * Time: 17:46
 * To change this template use File | Settings | File Templates.
 */
public class DLvPlanImp extends DaoImp<LvPlans> implements DLvPlan {
  public DLvPlanImp() {
    super(LvPlans.class);
  }

  @Override
  public ArrayList<LvPlans> getByPatientId(int curPat) {
    return (ArrayList<LvPlans>) getList("From LvPlans Where patientId = " + curPat);
  }

}
