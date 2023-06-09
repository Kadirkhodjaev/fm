package ckb.dao.med.head_nurse.date;

import ckb.dao.DaoImp;
import ckb.domains.med.head_nurse.HNDateRows;

public class DHNDateRowImp extends DaoImp<HNDateRows> implements DHNDateRow {
  public DHNDateRowImp() {
    super(HNDateRows.class);
  }

  @Override
  public Double getHDRasxod(int hndrug) {
    try {
      Double sum = (Double) entityManager.createQuery("Select Round(Sum(rasxod), 2) From HNDateRows Where drug.id = " + hndrug).getSingleResult();
      return sum == null ? 0D : sum;
    } catch (Exception e) {
      return 0D;
    }
  }
}
