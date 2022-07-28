package ckb.dao.med.lv.garmon;

import ckb.dao.DaoImp;
import ckb.domains.med.lv.LvGarmons;
import org.springframework.transaction.annotation.Transactional;

public class DLvGarmonImp extends DaoImp<LvGarmons> implements DLvGarmon {

  public DLvGarmonImp() {
    super(LvGarmons.class);
  }

  @Override
  public LvGarmons getByPlan(Integer planId) {
    try {
      return getObj("From LvGarmons Where planId = " + planId);
    } catch (Exception e) {
      return new LvGarmons();
    }
  }

  @Transactional
  public void deletePlan(int id) {
    entityManager.createQuery("delete from LvGarmons where planId = " + id).executeUpdate();
  }
}
