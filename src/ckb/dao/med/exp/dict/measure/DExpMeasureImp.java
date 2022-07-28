package ckb.dao.med.exp.dict.measure;

import ckb.dao.DaoImp;
import ckb.domains.med.exp.dict.ExpMeasures;

public class DExpMeasureImp extends DaoImp<ExpMeasures> implements DExpMeasure {
  public DExpMeasureImp() {
    super(ExpMeasures.class);
  }
}
