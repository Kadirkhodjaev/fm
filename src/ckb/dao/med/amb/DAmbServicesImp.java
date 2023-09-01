package ckb.dao.med.amb;

import ckb.dao.DaoImp;
import ckb.domains.med.amb.AmbServices;

import java.util.List;

public class DAmbServicesImp extends DaoImp<AmbServices> implements DAmbServices {
  public DAmbServicesImp() {
    super(AmbServices.class);
  }

  @Override
  public List<AmbServices> byType(int type) {
    return getList("From AmbServices Where state = 'A' And group.id = " + type + " Order By ord");
  }
}
