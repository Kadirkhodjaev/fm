package ckb.dao.med.lv.form2;

import ckb.dao.DaoImp;
import ckb.domains.med.lv.LvForm2;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 31.08.15
 * Time: 20:55
 * To change this template use File | Settings | File Templates.
 */
public class DLvForm2Imp extends DaoImp<LvForm2> implements DLvForm2 {
  public DLvForm2Imp() {
    super(LvForm2.class);
  }

  @Override
  public LvForm2 getByPatient(int curPat) {
    try {
      return getObj("From LvForm2 Where patient.id = " + curPat);
    }catch (Exception e) {
      return null;
    }
  }
}
