package ckb.dao.med.kdos;

import ckb.dao.DaoImp;
import ckb.domains.admin.SalePackRows;

public class DSalePackRowImp extends DaoImp<SalePackRows> implements DSalePackRow {
  public DSalePackRowImp() {
    super(SalePackRows.class);
  }

  @Override
  public Double getTotal(Integer id) {
    try {
      Double sum = (Double) entityManager.createQuery("Select sum(price) From SalePackRows Where doc.id = " + id).getSingleResult();
      return sum == null ? 0D : sum;
    } catch (Exception e) {
      return 0D;
    }
  }
}
