package ckb.dao.med.lv.form6;

import ckb.dao.Dao;
import ckb.domains.med.lv.LvForm6;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 31.08.15
 * Time: 20:55
 * To change this template use File | Settings | File Templates.
 */
public interface DLvForm6 extends Dao<LvForm6> {
  LvForm6 getByPatient(int curPat);
}
