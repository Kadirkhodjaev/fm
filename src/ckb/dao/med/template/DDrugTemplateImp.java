package ckb.dao.med.template;

import ckb.dao.DaoImp;
import ckb.domains.med.template.DrugTemplates;

import java.util.ArrayList;
import java.util.List;

public class DDrugTemplateImp extends DaoImp<DrugTemplates> implements DDrugTemplate {
  public DDrugTemplateImp() {
    super(DrugTemplates.class);
  }

  @Override
  public List<DrugTemplates> byUser(Integer userId) {
    try {
      return getList("From DrugTemplates where userId = " + userId);
    } catch (Exception e) {
      return new ArrayList<DrugTemplates>();
    }
  }
}
