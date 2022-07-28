package ckb.dao.med.eat.act.product;

import ckb.dao.DaoImp;
import ckb.domains.med.eat.EatActProducts;

public class DEatActProductImp extends DaoImp<EatActProducts> implements DEatActProduct {
  public DEatActProductImp() {
    super(EatActProducts.class);
  }
}
