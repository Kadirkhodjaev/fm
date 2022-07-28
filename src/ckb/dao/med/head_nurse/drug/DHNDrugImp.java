package ckb.dao.med.head_nurse.drug;

import ckb.dao.DaoImp;
import ckb.domains.med.head_nurse.HNDrugs;
import org.springframework.transaction.annotation.Transactional;

public class DHNDrugImp extends DaoImp<HNDrugs> implements DHNDrug {
  public DHNDrugImp() {
    super(HNDrugs.class);
  }

  @Transactional
  public void delByDoc(int id) {
    entityManager.createQuery("Delete From HNDrugs Where parent_id = " + id).executeUpdate();
  }
}
