package ckb.dao.med.eat.dict.eat;

import ckb.dao.DaoImp;
import ckb.domains.med.eat.dict.Eats;

public class DEatImp extends DaoImp<Eats> implements DEat {
  public DEatImp() {
    super(Eats.class);
  }
}
