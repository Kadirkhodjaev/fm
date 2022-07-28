package ckb.dao.med.lv.form6;

import ckb.dao.DaoImp;
import ckb.domains.med.lv.LvForm6;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 31.08.15
 * Time: 20:55
 * To change this template use File | Settings | File Templates.
 */
public class DLvForm6Imp extends DaoImp<LvForm6> implements DLvForm6 {
  public DLvForm6Imp() {
    super(LvForm6.class);
  }

  @Override
  public LvForm6 getByPatient(int curPat) {
    try {
      return getObj("From LvForm6 Where patient.id = " + curPat);
    }catch (Exception e) {
      return new LvForm6();
    }
  }
}
