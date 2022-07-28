package ckb.dao.med.drug.dict.drugs.counter;

import ckb.dao.DaoImp;
import ckb.domains.med.drug.dict.DrugCount;

public class DDrugCountImp extends DaoImp<DrugCount> implements DDrugCount {
  public DDrugCountImp() {
    super(DrugCount.class);
  }
}
