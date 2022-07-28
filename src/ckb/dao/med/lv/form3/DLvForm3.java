package ckb.dao.med.lv.form3;

import ckb.dao.Dao;
import ckb.domains.med.lv.LvForm3;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 31.08.15
 * Time: 20:55
 * To change this template use File | Settings | File Templates.
 */
public interface DLvForm3 extends Dao<LvForm3> {
  LvForm3 getByPatient(int curPat);
}
