package ckb.dao.med.lv.form5;

import ckb.dao.Dao;
import ckb.domains.med.lv.LvForm5;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 31.08.15
 * Time: 20:55
 * To change this template use File | Settings | File Templates.
 */
public interface DLvForm5 extends Dao<LvForm5> {
  LvForm5 getByPatient(int curPat);
}
