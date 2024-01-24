package ckb.dao.med.client;

import ckb.dao.Dao;
import ckb.domains.admin.Clients;

import java.util.List;

public interface DClient extends Dao<Clients> {
  List<Clients> dublicates(Clients client);

  long checkDublicate(Clients client);
}
