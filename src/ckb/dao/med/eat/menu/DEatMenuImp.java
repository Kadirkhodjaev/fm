package ckb.dao.med.eat.menu;

import ckb.dao.DaoImp;
import ckb.domains.med.eat.EatMenus;

public class DEatMenuImp extends DaoImp<EatMenus> implements DEatMenu {
  public DEatMenuImp() {
    super(EatMenus.class);
  }
}
