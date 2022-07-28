package ckb.dao.med.amb;

import ckb.dao.DaoImp;
import ckb.domains.med.amb.AmbServiceFields;

import java.util.List;

public class DAmbServiceFieldsImp extends DaoImp<AmbServiceFields> implements DAmbServiceFields {

  public DAmbServiceFieldsImp() {
    super(AmbServiceFields.class);
  }

  @Override
  public List<AmbServiceFields> byService(int service) {
    return getList("From AmbServiceFields Where service = " + service);
  }
}
