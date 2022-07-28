package ckb.dao.med.eat.claim;

import ckb.dao.DaoImp;
import ckb.domains.med.eat.EatClaimPatients;
import ckb.domains.med.eat.EatClaims;
import ckb.domains.med.eat.dict.EatTables;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public class DEatClaimPatientImp extends DaoImp<EatClaimPatients> implements DEatClaimPatient {
  public DEatClaimPatientImp() {
    super(EatClaimPatients.class);
  }

  @Override
  public List<Integer> getClaimTables(Integer id) {
    return (List<Integer>) entityManager.createQuery("Select t.table.id From EatClaimPatients t Where t.claim.id = " + id + " Group By t.table.id").getResultList();
  }

  @Transactional
  public void deleteTable(EatClaims claim, EatTables table) {
    entityManager.createQuery("Delete From EatClaimPatients Where claim.id = " + claim.getId() + " And table.id = " + table.getId()).executeUpdate();
  }

  @Transactional
  public void deleteByClaim(int id) {
    entityManager.createQuery("Delete From EatClaimPatients Where claim.id = " + id).executeUpdate();
  }
}
