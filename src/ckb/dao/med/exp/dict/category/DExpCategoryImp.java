package ckb.dao.med.exp.dict.category;

import ckb.dao.DaoImp;
import ckb.domains.med.exp.dict.ExpCategories;

public class DExpCategoryImp extends DaoImp<ExpCategories> implements DExpCategory {
  public DExpCategoryImp() {
    super(ExpCategories.class);
  }
}
