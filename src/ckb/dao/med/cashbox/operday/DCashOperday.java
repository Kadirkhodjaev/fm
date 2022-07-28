package ckb.dao.med.cashbox.operday;

import ckb.dao.Dao;
import ckb.domains.med.cash.CashOperdays;

import java.util.Date;

public interface DCashOperday extends Dao<CashOperdays> {
  Date getOpenDay();
}
