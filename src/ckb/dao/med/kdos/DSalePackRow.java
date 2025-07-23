package ckb.dao.med.kdos;

import ckb.dao.Dao;
import ckb.domains.admin.SalePackRows;

public interface DSalePackRow extends Dao<SalePackRows> {
  Double getTotal(Integer id);
}
