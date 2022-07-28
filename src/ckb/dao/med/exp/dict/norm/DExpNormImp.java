package ckb.dao.med.exp.dict.norm;

import ckb.dao.DaoImp;
import ckb.domains.med.exp.dict.ExpNorms;

import java.util.List;

public class DExpNormImp extends DaoImp<ExpNorms> implements DExpNorm {
  public DExpNormImp() {
    super(ExpNorms.class);
  }

  @Override
  public List<Integer> getServiceIds(String parentType) {
    return entityManager.createQuery("Select service From ExpNorms Where parentType = '" + parentType + "' group by service").getResultList();
  }
}
