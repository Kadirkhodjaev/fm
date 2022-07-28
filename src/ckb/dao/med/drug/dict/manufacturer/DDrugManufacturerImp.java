package ckb.dao.med.drug.dict.manufacturer;

import ckb.dao.DaoImp;
import ckb.domains.med.drug.dict.DrugManufacturers;

public class DDrugManufacturerImp extends DaoImp<DrugManufacturers> implements DDrugManufacturer {
  public DDrugManufacturerImp() {
    super(DrugManufacturers.class);
  }
}
