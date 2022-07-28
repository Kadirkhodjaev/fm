package ckb.dao.med.cashbox.operday;

import ckb.dao.DaoImp;
import ckb.domains.med.cash.CashOperdays;

import java.util.Date;

public class DCashOperdayImp extends DaoImp<CashOperdays> implements DCashOperday {
  public DCashOperdayImp() {
    super(CashOperdays.class);
  }

  @Override
  public Date getOpenDay() {
    try {
      return (Date) entityManager.createQuery("Select operday From CashOperdays Where state = 'OPEN'").getSingleResult();
    } catch (Exception e) {
      return null;
    }
  }
}
