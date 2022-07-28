package ckb.dao.med.drug.dict.contracts;

import ckb.dao.DaoImp;
import ckb.domains.med.drug.dict.DrugContracts;

public class DDrugContractImp extends DaoImp<DrugContracts> implements DDrugContract {
  public DDrugContractImp() {
    super(DrugContracts.class);
  }
}
