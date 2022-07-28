package ckb.dao.med.drug.dict.drugs.category;

import ckb.dao.DaoImp;
import ckb.domains.med.drug.dict.DrugDrugCategories;

public class DDrugDrugCategoryImp extends DaoImp<DrugDrugCategories> implements DDrugDrugCategory {

  public DDrugDrugCategoryImp() {
    super(DrugDrugCategories.class);
  }

}
