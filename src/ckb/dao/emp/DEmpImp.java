package ckb.dao.emp;

import ckb.dao.DaoImp;
import ckb.domains.emp.Emps;

public class DEmpImp extends DaoImp<Emps> implements DEmp {

  public DEmpImp() {
    super(Emps.class);
  }
}
