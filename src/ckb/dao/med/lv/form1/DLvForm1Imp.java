package ckb.dao.med.lv.form1;

import ckb.dao.DaoImp;
import ckb.domains.med.lv.LvForm1;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 31.08.15
 * Time: 20:53
 * To change this template use File | Settings | File Templates.
 */
public class DLvForm1Imp extends DaoImp<LvForm1> implements DLvForm1 {
  public DLvForm1Imp() {
    super(LvForm1.class);
  }

  @Override
  public LvForm1 getByPatient(int curPat) {
    try {
      return getObj("From LvForm1 Where patient.id = " + curPat);
    } catch (Exception e) {
      return null;
    }
  }
}
