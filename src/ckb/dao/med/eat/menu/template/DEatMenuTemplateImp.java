package ckb.dao.med.eat.menu.template;

import ckb.dao.DaoImp;
import ckb.domains.med.eat.EatMenuTemplates;

public class DEatMenuTemplateImp extends DaoImp<EatMenuTemplates> implements DEatMenuTemplate {
  public DEatMenuTemplateImp() {
    super(EatMenuTemplates.class);
  }
}
