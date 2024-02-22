package ckb.dao.med.amb.form;

import ckb.dao.DaoImp;
import ckb.domains.med.amb.AmbFormFields;

public class DAmbFormFieldImp extends DaoImp<AmbFormFields> implements DAmbFormField {
  public DAmbFormFieldImp() {
    super(AmbFormFields.class);
  }

  @Override
  public Integer getMaxCol(Integer service, Integer form) {
    try {
      return (Integer) entityManager.createQuery("Select max(col) From AmbFormFields where service = " + service + " And form = " + form).getSingleResult();
    } catch (Exception e) {
      return 0;
    }
  }

  @Override
  public Integer getMaxRow(Integer service, Integer form) {
    try {
      Integer maxRow = (Integer) entityManager.createQuery("Select max(row) From AmbFormFields where service = " + service + " And form = " + form).getSingleResult();
      return maxRow == null ? 0 : maxRow;
    } catch (Exception e) {
      return 0;
    }
  }
}
