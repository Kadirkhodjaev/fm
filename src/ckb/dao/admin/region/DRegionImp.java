package ckb.dao.admin.region;

import ckb.dao.DaoImp;
import ckb.domains.admin.Regions;

public class DRegionImp extends DaoImp<Regions> implements DRegion {
  public DRegionImp() {
    super(Regions.class);
  }
}
