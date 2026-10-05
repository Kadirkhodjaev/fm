package ckb.dao.med.drug.actdrug;

import ckb.dao.DaoImp;
import ckb.domains.med.drug.DrugActDrugs;
import ckb.domains.med.drug.dict.Drugs;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

public class DDrugActDrugImp extends DaoImp<DrugActDrugs> implements DDrugActDrug {
  public DDrugActDrugImp() {
    super(DrugActDrugs.class);
  }

  @Transactional
  public void deleteByAct(int id) {
    entityManager.createQuery("Delete From DrugActDrugs t Where t.act.id = " + id).executeUpdate();
  }

  @Override
  public List<Drugs> getExists() {
    try {
      return entityManager.createQuery("Select drug From DrugActDrugs Where counter - ifnull(rasxod, 0) > 0").getResultList();
    } catch (Exception e) {
      return new ArrayList<>();
    }
  }

  @Override
  public Double getActSum(Integer id) {
    try {
       return (Double) entityManager.createQuery("Select Sum((countPrice + ifnull(nds, 0)) * counter) From DrugActDrugs Where act.id = " + id).getSingleResult();
    } catch (Exception e) {
      return 0D;
    }
  }

  @Override
  @Transactional
  public int takeStock(Integer id, double qty) {
    int n = entityManager.createQuery("Update DrugActDrugs t Set t.rasxod = t.rasxod + :q Where t.id = :id And t.counter - t.rasxod + 0.0001 >= :q")
      .setParameter("q", qty).setParameter("id", id).executeUpdate();
    if (n > 0)
      entityManager.createQuery("Update DrugActDrugs t Set t.done = 'Y' Where t.id = :id And t.counter - t.rasxod <= 0.0001")
        .setParameter("id", id).executeUpdate();
    return n;
  }

  @Override
  @Transactional
  public void giveBack(Integer id, double qty) {
    entityManager.createQuery("Update DrugActDrugs t Set t.rasxod = t.rasxod - :q, t.done = 'N' Where t.id = :id")
      .setParameter("q", qty).setParameter("id", id).executeUpdate();
  }
}
