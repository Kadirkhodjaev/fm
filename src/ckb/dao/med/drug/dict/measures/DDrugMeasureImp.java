package ckb.dao.med.drug.dict.measures;

import ckb.dao.DaoImp;
import ckb.domains.med.drug.dict.DrugMeasures;

public class DDrugMeasureImp extends DaoImp<DrugMeasures> implements DDrugMeasure {
  public DDrugMeasureImp() {
    super(DrugMeasures.class);
  }
}
