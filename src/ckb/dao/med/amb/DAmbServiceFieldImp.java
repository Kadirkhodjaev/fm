package ckb.dao.med.amb;

import ckb.dao.DaoImp;
import ckb.domains.med.amb.AmbServiceFields;

import java.util.List;

public class DAmbServiceFieldImp extends DaoImp<AmbServiceFields> implements DAmbServiceField {

  public DAmbServiceFieldImp() {
    super(AmbServiceFields.class);
  }

  @Override
  public List<AmbServiceFields> byService(int service) {
    return getList("From AmbServiceFields Where service = " + service);
  }
}
