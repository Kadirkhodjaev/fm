package ckb.dao.med.lv.epic;

import ckb.dao.Dao;
import ckb.domains.med.lv.LvEpics;

import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 26.10.16
 * Time: 22:27
 * To change this template use File | Settings | File Templates.
 */
public interface DLvEpic extends Dao<LvEpics> {
  List<LvEpics> getPatientEpics(Integer patientId);
}
