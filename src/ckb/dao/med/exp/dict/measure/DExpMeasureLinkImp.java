package ckb.dao.med.exp.dict.measure;

import ckb.dao.DaoImp;
import ckb.domains.med.exp.dict.ExpMeasureLinks;

public class DExpMeasureLinkImp extends DaoImp<ExpMeasureLinks> implements DExpMeasureLink {
  public DExpMeasureLinkImp() {
    super(ExpMeasureLinks.class);
  }
}
