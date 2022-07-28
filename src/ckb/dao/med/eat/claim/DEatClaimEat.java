package ckb.dao.med.eat.claim;

import ckb.dao.Dao;
import ckb.domains.med.eat.EatClaimEats;
import ckb.domains.med.eat.EatClaims;
import ckb.domains.med.eat.dict.EatTables;

public interface DEatClaimEat extends Dao<EatClaimEats> {
  void deleteTable(EatClaims claim, EatTables table);

  void deleteByClaim(int id);
}
