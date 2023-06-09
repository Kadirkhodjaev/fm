package ckb.dao.med.head_nurse.direction;

import ckb.dao.DaoImp;
import ckb.domains.med.head_nurse.HNDirectionLinks;

public class DHNDirectionLinkImp extends DaoImp<HNDirectionLinks> implements DHNDirectionLink {
  public DHNDirectionLinkImp() {
    super(HNDirectionLinks.class);
  }
}
