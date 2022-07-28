package ckb.dao.med.drug.dict.storages;

import ckb.dao.DaoImp;
import ckb.domains.med.drug.dict.DrugStorages;

public class DDrugStorageImp extends DaoImp<DrugStorages> implements DDrugStorage {
  public DDrugStorageImp() {
    super(DrugStorages.class);
  }
}
