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

  @Override
  public Double getTransferRasxod(int hndrug) {
    try {
      Double sum = (Double) entityManager.createQuery("Select Round(Sum(drugCount), 2) From HNDrugs Where transfer_hndrug_id = " + hndrug).getSingleResult();
      return sum == null ? 0D : sum;
    } catch (Exception e) {
      return 0D;
    }
  }
}
