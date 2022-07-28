package ckb.dao.med.lv.coul;

import ckb.dao.DaoImp;
import ckb.domains.med.lv.LvCouls;
import org.springframework.transaction.annotation.Transactional;

public class DLvCoulImp extends DaoImp<LvCouls> implements DLvCoul {

  public DLvCoulImp() {
    super(LvCouls.class);
  }

  @Override
  public LvCouls getByPlan(Integer planId) {
    try {
      return getObj("From LvCouls Where planId = " + planId);
    } catch (Exception e) {
      return new LvCouls();
    }
  }

  @Transactional
  public void deletePlan(int id) {
    entityManager.createQuery("delete from LvCouls where planId = " + id).executeUpdate();
  }
}
