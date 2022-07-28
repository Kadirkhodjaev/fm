package ckb.dao.med.eat.claim;

import ckb.dao.DaoImp;
import ckb.domains.med.eat.EatClaims;

public class DEatClaimImp extends DaoImp<EatClaims> implements DEatClaim {
  public DEatClaimImp() {
    super(EatClaims.class);
  }
}
