package ckb.dao.med.drug.outs;

import ckb.dao.DaoImp;
import ckb.domains.med.drug.DrugOuts;

public class DDrugOutImp extends DaoImp<DrugOuts> implements DDrugOut {
  public DDrugOutImp() {
    super(DrugOuts.class);
  }
}
