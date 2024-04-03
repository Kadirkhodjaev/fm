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
}
