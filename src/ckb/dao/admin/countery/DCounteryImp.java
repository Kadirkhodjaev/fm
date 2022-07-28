package ckb.dao.admin.countery;

import ckb.dao.DaoImp;
import ckb.domains.admin.Counteries;

import java.util.List;

public class DCounteryImp extends DaoImp<Counteries> implements DCountery {
  public DCounteryImp() {
    super(Counteries.class);
  }

  @Override
  public List<Counteries> getCounteries() {
    return getList("From Counteries Order By ord, name");
  }
}
