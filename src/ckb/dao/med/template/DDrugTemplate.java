package ckb.dao.med.template;

import ckb.dao.Dao;
import ckb.domains.med.template.DrugTemplates;

import java.util.List;

public interface DDrugTemplate extends Dao<DrugTemplates> {
  List<DrugTemplates> byUser(Integer userId);
}
