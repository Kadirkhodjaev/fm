package ckb.dao.med.amb.form;

import ckb.dao.Dao;
import ckb.domains.med.amb.AmbForms;

public interface DAmbForm extends Dao<AmbForms> {
  Integer maxForm(Integer service);
}
