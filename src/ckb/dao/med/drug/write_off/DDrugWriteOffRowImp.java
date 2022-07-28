package ckb.dao.med.drug.write_off;

import ckb.dao.DaoImp;
import ckb.domains.med.drug.DrugWriteOffRows;
import org.springframework.transaction.annotation.Transactional;

public class DDrugWriteOffRowImp extends DaoImp<DrugWriteOffRows> implements DDrugWriteOffRow {

  public DDrugWriteOffRowImp() {
    super(DrugWriteOffRows.class);
  }

  @Transactional
  public void delByDoc(int id) {
    entityManager.createQuery("Delete From DrugWriteOffRows t Where t.doc.id = " + id).executeUpdate();
  }

  @Override
  public Double getActSum(Integer id) {
    try {
      return (Double) entityManager.createQuery("Select Sum(price * ifnull(drugCount, 0)) From DrugWriteOffRows Where doc.id = " + id).getSingleResult();
    } catch (Exception e) {
      return 0D;
    }
  }
}
