package ckb.dao.med.amb.form;

import ckb.dao.DaoImp;
import ckb.domains.med.amb.AmbFormFields;

public class DAmbFormFieldImp extends DaoImp<AmbFormFields> implements DAmbFormField {
  public DAmbFormFieldImp() {
    super(AmbFormFields.class);
  }
}
