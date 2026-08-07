package ckb.dao.med.drug.outs;

import ckb.dao.DaoImp;
import ckb.domains.med.drug.DrugOutRows;
import org.springframework.transaction.annotation.Transactional;

public class DDrugOutRowImp extends DaoImp<DrugOutRows> implements DDrugOutRow {

  public DDrugOutRowImp() {
    super(DrugOutRows.class);
  }

  @Transactional
  public void delByDoc(int id) {
    entityManager.createQuery("Delete From DrugOutRows t Where t.doc.id = " + id).executeUpdate();
  }

  @Override
  public Double getActSum(Integer id) {
    try {
      return (Double) entityManager.createQuery("Select Sum(price * ifnull(drugCount, 0)) From DrugOutRows Where doc.id = " + id).getSingleResult();
    } catch (Exception e) {
      return 0D;
    }
  }

  @Override
  public double getIncomeRasxod(Integer id) {
    try {
      Double sum = (Double) entityManager.createQuery("Select Round(Sum(drugCount), 2) From DrugOutRows Where income.id = " + id).getSingleResult();
      return sum == null ? 0D : sum;
    } catch (Exception e) {
      return 0D;
    }
  }
}
