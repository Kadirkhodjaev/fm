package ckb.dao.med.lv.form3;

import ckb.dao.DaoImp;
import ckb.domains.med.lv.LvForm3;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 31.08.15
 * Time: 20:55
 * To change this template use File | Settings | File Templates.
 */
public class DLvForm3Imp extends DaoImp<LvForm3> implements DLvForm3 {
  public DLvForm3Imp() {
    super(LvForm3.class);
  }

  @Override
  public LvForm3 getByPatient(int curPat) {
    try {
      return getObj("From LvForm3 Where patient.id = " + curPat);
    }catch (Exception e) {
      return null;
    }
  }
}
