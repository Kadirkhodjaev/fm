package ckb.dao.med.lv.consul;

import ckb.dao.DaoImp;
import ckb.domains.med.lv.LvConsuls;

import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 27.10.16
 * Time: 21:28
 * To change this template use File | Settings | File Templates.
 */
public class DLvConsulImp extends DaoImp<LvConsuls> implements DLvConsul {
  public DLvConsulImp() {
    super(LvConsuls.class);
  }

  @Override
  public List<LvConsuls> getByPat(int curPat) {
    return getList("From LvConsuls Where patientId = " + curPat);
  }

  @Override
  public List<LvConsuls> getUserConsul(int userId, int patId) {
    return getList("From LvConsuls t Where t.lvId=" + userId + " And Exists (Select 1 From Patients c Where c.id = t.patientId And c.state = 'LV') And t.patientId = " + patId);
  }
}
