package ckb.dao.med.amb.form;

import ckb.dao.DaoImp;
import ckb.domains.med.amb.AmbForms;

public class DAmbFormImp extends DaoImp<AmbForms> implements DAmbForm {
  public DAmbFormImp() {
    super(AmbForms.class);
  }

  @Override
  public Integer maxForm(Integer service) {
    Integer max;
    try {
      max = (Integer) entityManager.createQuery("Select Max(id) From AmbForms Where service = " + service).getSingleResult();
    } catch (Exception e) {
      max = null;
    }
    return max;
  }
}
