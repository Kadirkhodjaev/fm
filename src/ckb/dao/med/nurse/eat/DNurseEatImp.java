package ckb.dao.med.nurse.eat;

import ckb.dao.DaoImp;
import ckb.domains.med.nurse.eat.NurseEats;
import ckb.utils.Util;

public class DNurseEatImp extends DaoImp<NurseEats> implements DNurseEats {
  public DNurseEatImp() {
    super(NurseEats.class);
  }

  @Override
  public boolean check(NurseEats eat) {
    return getCount("From NurseEats Where dept.id = " + eat.getDept().getId() + " And actDate = '"  + Util.dateDB(Util.dateToString(eat.getActDate())) + "' And menuType.id = " + eat.getMenuType().getId()) == 0;
  }
}
