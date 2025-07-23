package ckb.dao.med.kdos;

import ckb.dao.DaoImp;
import ckb.domains.admin.SalePacks;

public class DSalePackImp extends DaoImp<SalePacks> implements DSalePack {
  public DSalePackImp() {
    super(SalePacks.class);
  }
}
