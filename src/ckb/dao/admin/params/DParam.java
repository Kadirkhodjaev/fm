package ckb.dao.admin.params;

import ckb.dao.Dao;
import ckb.domains.admin.Params;

public interface DParam extends Dao<Params> {
  String byCode(String clinic_name);
}
