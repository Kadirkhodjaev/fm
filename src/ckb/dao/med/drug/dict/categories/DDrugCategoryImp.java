package ckb.dao.med.drug.dict.categories;

import ckb.dao.DaoImp;
import ckb.domains.med.drug.dict.DrugCategories;

public class DDrugCategoryImp extends DaoImp<DrugCategories> implements DDrugCategory {
  public DDrugCategoryImp() {
    super(DrugCategories.class);
  }
}
