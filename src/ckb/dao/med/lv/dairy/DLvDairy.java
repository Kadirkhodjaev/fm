package ckb.dao.med.lv.dairy;

import ckb.dao.Dao;
import ckb.domains.med.lv.LvDairies;

import java.util.ArrayList;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 07.07.16
 * Time: 22:13
 * To change this template use File | Settings | File Templates.
 */
public interface DLvDairy extends Dao<LvDairies> {
  public ArrayList<LvDairies> getByPatientId(int curPat);
}
