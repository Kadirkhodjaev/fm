package ckb.dao.med.exp.dict.product;

import ckb.dao.DaoImp;
import ckb.domains.med.exp.dict.ExpProducts;

public class DExpProductImp extends DaoImp<ExpProducts> implements DExpProduct {
  public DExpProductImp() {
    super(ExpProducts.class);
  }
}
