package ckb.dao.med.lv.epic;

import ckb.dao.DaoImp;
import ckb.domains.med.lv.LvEpics;

import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 26.10.16
 * Time: 22:28
 * To change this template use File | Settings | File Templates.
 */
public class DLvEpicImp extends DaoImp<LvEpics> implements DLvEpic {
  public DLvEpicImp() {
    super(LvEpics.class);
  }

  @Override
  public List<LvEpics> getPatientEpics(Integer patientId) {
    return getList("From LvEpics Where patientId = " + patientId);
  }
}
