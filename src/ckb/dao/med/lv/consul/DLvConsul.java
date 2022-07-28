package ckb.dao.med.lv.consul;

import ckb.dao.Dao;
import ckb.domains.med.lv.LvConsuls;

import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 27.10.16
 * Time: 21:28
 * To change this template use File | Setstings | File Templates.
 */
public interface DLvConsul extends Dao<LvConsuls> {

  List<LvConsuls> getByPat(int curPat);

  List<LvConsuls> getUserConsul(int userId, int patId);
}
