package ckb.dao.med.amb;

import ckb.dao.DaoImp;
import ckb.domains.med.amb.AmbDrugRows;

public class DAmbDrugRowImp extends DaoImp<AmbDrugRows> implements DAmbDrugRow {
  public DAmbDrugRowImp() {
    super(AmbDrugRows.class);
  }
}
