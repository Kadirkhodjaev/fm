package ckb.dao.med.drug.drugsaldo;

import ckb.dao.DaoImp;
import ckb.domains.med.drug.DrugSaldos;

public class DDrugSaldoImp extends DaoImp<DrugSaldos> implements DDrugSaldo {
  public DDrugSaldoImp() {
    super(DrugSaldos.class);
  }
}
