package ckb.dao.med.eat.dict.eat.norm;

import ckb.dao.DaoImp;
import ckb.domains.med.eat.dict.EatNorms;
import org.springframework.transaction.annotation.Transactional;

public class DEatNormImp extends DaoImp<EatNorms> implements DEatNorm {
  public DEatNormImp() {
    super(EatNorms.class);
  }

  @Transactional
  public void deleteByEat(int id) {
    entityManager.createQuery("Delete From EatNorms t Where t.eat.id = " + id).executeUpdate();
  }
}
