package ckb.dao.med.client;

import ckb.dao.DaoImp;
import ckb.domains.admin.Clients;

public class DClientImp extends DaoImp<Clients> implements DClient {
  public DClientImp() {
    super(Clients.class);
  }
}
