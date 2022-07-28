package ckb.dao.med.lv.form7;

import ckb.dao.DaoImp;
import ckb.domains.med.lv.LvForm7;

public class DLvForm7Imp extends DaoImp<LvForm7> implements DLvForm7 {

  public DLvForm7Imp() {
    super(LvForm7.class);
  }

  @Override
  public LvForm7 getByPatient(int curPat) {
    try {
      return getObj("From LvForm7 Where patient.id = " + curPat);
    }catch (Exception e) {
      return null;
    }
  }

}
