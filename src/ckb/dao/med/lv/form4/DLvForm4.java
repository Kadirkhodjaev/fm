package ckb.dao.med.lv.form4;

import ckb.dao.Dao;
import ckb.domains.med.lv.LvForm4;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 31.08.15
 * Time: 20:55
 * To change this template use File | Settings | File Templates.
 */
public interface DLvForm4 extends Dao<LvForm4> {
  LvForm4 getByPatient(int curPat);
}
