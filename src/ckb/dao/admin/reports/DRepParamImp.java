package ckb.dao.admin.reports;

import ckb.dao.DaoImp;
import ckb.domains.med.report.RepParams;

import java.util.List;

public class DRepParamImp extends DaoImp<RepParams> implements DRepParam {

  public DRepParamImp() {
    super(RepParams.class);
  }

  @Override
  public List<RepParams> regParams(Integer id) {
    return entityManager.createQuery("From RepParams Where repId = " + id).getResultList();
  }
}
