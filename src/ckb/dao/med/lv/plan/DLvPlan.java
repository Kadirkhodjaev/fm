package ckb.dao.med.lv.plan;

import ckb.dao.Dao;
import ckb.domains.med.lv.LvPlans;

import java.util.ArrayList;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 09.07.16
 * Time: 17:45
 * To change this template use File | Settings | File Templates.
 */
public interface DLvPlan extends Dao<LvPlans> {

  ArrayList<LvPlans> getByPatientId(int curPat);
}
