package ckb.dao.med.drug.write_off;

import ckb.dao.DaoImp;
import ckb.domains.med.drug.DrugWriteOffs;

public class DDrugWriteOffImp extends DaoImp<DrugWriteOffs> implements DDrugWriteOff {
  public DDrugWriteOffImp() {
    super(DrugWriteOffs.class);
  }
}
