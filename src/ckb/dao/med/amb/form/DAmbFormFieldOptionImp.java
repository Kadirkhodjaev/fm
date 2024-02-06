package ckb.dao.med.amb.form;

import ckb.dao.DaoImp;
import ckb.domains.med.amb.AmbFormFieldOptions;

public class DAmbFormFieldOptionImp extends DaoImp<AmbFormFieldOptions> implements DAmbFormFieldOption {
  public DAmbFormFieldOptionImp() {
    super(AmbFormFieldOptions.class);
  }
}
