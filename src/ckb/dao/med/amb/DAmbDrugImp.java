package ckb.dao.med.amb;

import ckb.dao.DaoImp;
import ckb.domains.med.amb.AmbDrugs;

public class DAmbDrugImp extends DaoImp<AmbDrugs> implements DAmbDrug {
  public DAmbDrugImp() {
    super(AmbDrugs.class);
  }
}
