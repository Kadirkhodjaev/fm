package ckb.dao.med.lv.torch;

import ckb.dao.DaoImp;
import ckb.domains.med.lv.LvTorchs;
import org.springframework.transaction.annotation.Transactional;

public class DLvTorchImp extends DaoImp<LvTorchs> implements DLvTorch {

  public DLvTorchImp() {
    super(LvTorchs.class);
  }

  @Override
  public LvTorchs getByPlan(Integer planId) {
    try {
      return getObj("From LvTorchs Where planId = " + planId);
    } catch (Exception e) {
      return new LvTorchs();
    }
  }

  @Transactional
  public void deletePlan(int id) {
    entityManager.createQuery("delete from LvTorchs where planId = " + id).executeUpdate();
  }
}
