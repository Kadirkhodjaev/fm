package ckb.dao.med.amb.form;

import ckb.dao.Dao;
import ckb.domains.med.amb.AmbFormFields;

public interface DAmbFormField extends Dao<AmbFormFields> {
  Integer getMaxCol(Integer service, Integer form);

  Integer getMaxRow(Integer service, Integer form);
}
