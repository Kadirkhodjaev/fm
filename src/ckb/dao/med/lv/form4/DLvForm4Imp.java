package ckb.dao.med.lv.form4;

import ckb.dao.DaoImp;
import ckb.domains.med.lv.LvForm4;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 31.08.15
 * Time: 20:55
 * To change this template use File | Settings | File Templates.
 */
public class DLvForm4Imp extends DaoImp<LvForm4> implements DLvForm4 {
  public DLvForm4Imp() {
    super(LvForm4.class);
  }

  @Override
  public LvForm4 getByPatient(int curPat) {
    try {
      return getObj("From LvForm4 Where patient.id = " + curPat);
    }catch (Exception e) {
      return null;
    }
  }
}
