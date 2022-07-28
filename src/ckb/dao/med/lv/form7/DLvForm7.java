package ckb.dao.med.lv.form7;

import ckb.dao.Dao;
import ckb.domains.med.lv.LvForm7;

public interface DLvForm7 extends Dao<LvForm7> {

  LvForm7 getByPatient(int curPat);

}
