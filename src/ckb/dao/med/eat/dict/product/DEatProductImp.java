package ckb.dao.med.eat.dict.product;

import ckb.dao.DaoImp;
import ckb.domains.med.eat.dict.EatProducts;

public class DEatProductImp extends DaoImp<EatProducts> implements DEatProduct {
  public DEatProductImp() {
    super(EatProducts.class);
  }
}
