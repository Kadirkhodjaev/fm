package ckb.dao.med.drug.dict.directions;

import ckb.dao.DaoImp;
import ckb.domains.med.drug.dict.DrugDirections;

public class DDrugDirectionImp extends DaoImp<DrugDirections> implements DDrugDirection {
  public DDrugDirectionImp() {
    super(DrugDirections.class);
  }
}
