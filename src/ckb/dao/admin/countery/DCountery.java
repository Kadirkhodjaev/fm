package ckb.dao.admin.countery;

import ckb.dao.Dao;
import ckb.domains.admin.Counteries;

import java.util.List;

public interface DCountery extends Dao<Counteries> {
  List<Counteries> getCounteries();
}
