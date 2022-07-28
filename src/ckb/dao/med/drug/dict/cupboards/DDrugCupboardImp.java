package ckb.dao.med.drug.dict.cupboards;

import ckb.dao.DaoImp;
import ckb.domains.med.drug.dict.DrugCupboards;

public class DDrugCupboardImp extends DaoImp<DrugCupboards> implements DDrugCupboard {
  public DDrugCupboardImp() {
    super(DrugCupboards.class);
  }
}
