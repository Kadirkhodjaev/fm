package ckb.dao.admin.countery;

import ckb.dao.DaoImp;
import ckb.domains.admin.Counteries;

import java.util.List;

public class DCountryImp extends DaoImp<Counteries> implements DCountry {
  public DCountryImp() {
    super(Counteries.class);
  }

  @Override
  public List<Counteries> getCounteries() {
    return getList("From Counteries Order By ord, name");
  }
}
