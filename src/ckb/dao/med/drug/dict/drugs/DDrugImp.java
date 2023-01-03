package ckb.dao.med.drug.dict.drugs;

import ckb.dao.DaoImp;
import ckb.domains.med.drug.dict.Drugs;

public class DDrugImp extends DaoImp<Drugs> implements DDrug {
  public DDrugImp() {
    super(Drugs.class);
  }

  @Override
  public boolean isNameExist(Drugs obj) {
    return getCount("From Drugs Where Upper(name) = '" + obj.getName().toUpperCase() + "'") > 0;
  }

  @Override
  public Double getRealSaldo(Integer drugId, Double expense) {
    Double saldo = (Double) entityManager.createQuery("Select Sum(counter - rasxod) From DrugActDrugs Where drug.id = " + drugId).getSingleResult();
    return saldo - expense;
  }
}
