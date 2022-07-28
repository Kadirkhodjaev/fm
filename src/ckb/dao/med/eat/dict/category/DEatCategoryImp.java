package ckb.dao.med.eat.dict.category;

import ckb.dao.DaoImp;
import ckb.domains.med.eat.dict.EatCategories;

public class DEatCategoryImp extends DaoImp<EatCategories> implements DEatCategory {

  public DEatCategoryImp() {
    super(EatCategories.class);
  }
}
