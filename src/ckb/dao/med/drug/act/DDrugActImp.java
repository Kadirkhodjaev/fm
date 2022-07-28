package ckb.dao.med.drug.act;

import ckb.dao.DaoImp;
import ckb.domains.med.drug.DrugActs;

public class DDrugActImp extends DaoImp<DrugActs> implements DDrugAct {
  public DDrugActImp() {
    super(DrugActs.class);
  }
}
