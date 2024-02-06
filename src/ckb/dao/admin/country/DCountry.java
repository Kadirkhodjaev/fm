package ckb.dao.admin.country;

import ckb.dao.Dao;
import ckb.domains.admin.Counteries;

import java.util.List;

public interface DCountry extends Dao<Counteries> {
  List<Counteries> getCounteries();
}
