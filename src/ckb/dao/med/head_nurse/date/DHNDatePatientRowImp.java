package ckb.dao.med.head_nurse.date;

import ckb.dao.DaoImp;
import ckb.domains.med.head_nurse.HNDatePatientRows;
import org.springframework.transaction.annotation.Transactional;

public class DHNDatePatientRowImp extends DaoImp<HNDatePatientRows> implements DHNDatePatientRow {
  public DHNDatePatientRowImp() {
    super(HNDatePatientRows.class);
  }

  @Transactional
  public void delByDoc(int id) {
    entityManager.createQuery("Delete From HNDatePatientRows t Where t.doc.id = " + id).executeUpdate();
  }

  @Override
  public Double getHDRasxod(int hndrug) {
    try {
      Double sum = (Double) entityManager.createQuery("Select Round(Sum(rasxod), 2) From HNDatePatientRows Where drug.id = " + hndrug).getSingleResult();
      return sum == null ? 0D : sum;
    } catch (Exception e) {
      return 0D;
    }
  }
}
