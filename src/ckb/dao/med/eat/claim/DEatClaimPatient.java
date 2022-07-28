package ckb.dao.med.eat.claim;

import ckb.dao.Dao;
import ckb.domains.med.eat.EatClaimPatients;
import ckb.domains.med.eat.EatClaims;
import ckb.domains.med.eat.dict.EatTables;

import java.util.List;

public interface DEatClaimPatient extends Dao<EatClaimPatients> {
  List<Integer> getClaimTables(Integer id);

  void deleteTable(EatClaims claim, EatTables table);

  void deleteByClaim(int id);
}
