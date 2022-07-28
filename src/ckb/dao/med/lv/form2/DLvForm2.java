package ckb.dao.med.lv.form2;

import ckb.dao.Dao;
import ckb.domains.med.lv.LvForm2;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 31.08.15
 * Time: 20:55
 * To change this template use File | Settings | File Templates.
 */
public interface DLvForm2 extends Dao<LvForm2> {
  LvForm2 getByPatient(int curPat);
}
