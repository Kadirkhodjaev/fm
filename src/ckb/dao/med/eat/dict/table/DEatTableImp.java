package ckb.dao.med.eat.dict.table;

import ckb.dao.DaoImp;
import ckb.domains.med.eat.dict.EatTables;

public class DEatTableImp extends DaoImp<EatTables> implements DEatTable {
  public DEatTableImp() {
    super(EatTables.class);
  }
}
