package ckb.dao.med.amb;

import ckb.dao.Dao;
import ckb.domains.med.amb.AmbServices;

import java.util.List;

public interface DAmbServices extends Dao<AmbServices> {
  List<AmbServices> byType(int i);
}
