package ckb.dao.med.amb;

import ckb.dao.Dao;
import ckb.domains.med.amb.AmbServiceFields;

import java.util.List;

public interface DAmbServiceField extends Dao<AmbServiceFields> {
  List<AmbServiceFields> byService(int service);
}
