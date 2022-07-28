package ckb.dao.med.lv.form5;

import ckb.dao.DaoImp;
import ckb.domains.med.lv.LvForm5;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 31.08.15
 * Time: 20:55
 * To change this template use File | Settings | File Templates.
 */
public class DLvForm5Imp extends DaoImp<LvForm5> implements DLvForm5 {
  public DLvForm5Imp() {
    super(LvForm5.class);
  }

  @Override
  public LvForm5 getByPatient(int curPat) {
    try {
      return getObj("From LvForm5 Where patient.id = " + curPat);
    }catch (Exception e) {
      return null;
    }
  }
}
