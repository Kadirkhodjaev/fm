package ckb.dao.med.amb;

import ckb.dao.DaoImp;
import ckb.domains.med.amb.AmbServices;

import java.util.List;

public class DAmbServiceImp extends DaoImp<AmbServices> implements DAmbService {
  public DAmbServiceImp() {
    super(AmbServices.class);
  }

  @Override
  public List<AmbServices> byType(int type) {
    return getList("From AmbServices Where state = 'A' And group.id = " + type + " Order By ord");
  }
}
