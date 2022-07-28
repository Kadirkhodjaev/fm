package ckb.dao.med.lv.form1;

import ckb.dao.Dao;
import ckb.domains.med.lv.LvForm1;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 31.08.15
 * Time: 20:52
 * To change this template use File | Settings | File Templates.
 */
public interface DLvForm1 extends Dao<LvForm1> {
  LvForm1 getByPatient(int curPat);
}
