package ckb.dao.med.lv.dairy;

import ckb.dao.DaoImp;
import ckb.domains.med.lv.LvDairies;

import java.util.ArrayList;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 07.07.16
 * Time: 22:13
 * To change this template use File | Settings | File Templates.
 */
public class DLvDairyImp extends DaoImp<LvDairies> implements DLvDairy {
  public DLvDairyImp() {
    super(LvDairies.class);
  }

  @Override
  public ArrayList<LvDairies> getByPatientId(int curPat) {
    try {
      return (ArrayList<LvDairies>) getList("From LvDairies Where patient = " + curPat);
    } catch (Exception e) {
      return null;
    }
  }

}
