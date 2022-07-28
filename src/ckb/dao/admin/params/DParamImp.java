package ckb.dao.admin.params;

import ckb.dao.DaoImp;
import ckb.domains.admin.Params;

public class DParamImp extends DaoImp<Params> implements DParam {
  public DParamImp() {
    super(Params.class);
  }

  @Override
  public String byCode(String code) {
    try {
      return getObj("From Params Where code = '" + code + "'").getVal();
    } catch (Exception e) {
      return "";
    }
  }
}
