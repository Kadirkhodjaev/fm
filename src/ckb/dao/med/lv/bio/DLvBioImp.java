package ckb.dao.med.lv.bio;

import ckb.dao.DaoImp;
import ckb.domains.med.lv.LvBios;
import org.springframework.transaction.annotation.Transactional;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 06.11.16
 * Time: 22:12
 * To change this template use File | Settings | File Templates.
 */
public class DLvBioImp extends DaoImp<LvBios> implements DLvBio {
  public DLvBioImp() {
    super(LvBios.class);
  }

  @Override
  public LvBios getByPlan(Integer planId) {
    try {
      return getObj("From LvBios Where planId = " + planId);
    } catch (Exception e) {
      return new LvBios();
    }
  }

  @Transactional
  public void deletePlan(int id) {
    entityManager.createQuery("delete from LvBios where planId = " + id).executeUpdate();
  }
}
