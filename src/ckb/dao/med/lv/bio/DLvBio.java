package ckb.dao.med.lv.bio;

import ckb.dao.Dao;
import ckb.domains.med.lv.LvBios;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 06.11.16
 * Time: 22:29
 * To change this template use File | Settings | File Templates.
 */
public interface DLvBio extends Dao<LvBios> {
  LvBios getByPlan(Integer planId);

  void deletePlan(int id);
}
