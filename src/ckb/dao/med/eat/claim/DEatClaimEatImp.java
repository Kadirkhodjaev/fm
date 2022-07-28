package ckb.dao.med.eat.claim;

import ckb.dao.DaoImp;
import ckb.domains.med.eat.EatClaimEats;
import ckb.domains.med.eat.EatClaims;
import ckb.domains.med.eat.dict.EatTables;
import org.springframework.transaction.annotation.Transactional;

public class DEatClaimEatImp extends DaoImp<EatClaimEats> implements DEatClaimEat {
  public DEatClaimEatImp() {
    super(EatClaimEats.class);
  }

  @Transactional
  public void deleteTable(EatClaims claim, EatTables table) {
    entityManager.createQuery("Delete From EatClaimEats Where claim.id = " + claim.getId() + " And table.id = " + table.getId()).executeUpdate();
  }

  @Transactional
  public void deleteByClaim(int id) {
    entityManager.createQuery("Delete From EatClaimEats Where claim.id = " + id).executeUpdate();
  }
}
