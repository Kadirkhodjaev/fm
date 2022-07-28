package ckb.dao.med.cashbox.discount;

import ckb.dao.Dao;
import ckb.domains.med.cash.CashDiscounts;

import java.util.List;

public interface DCashDiscount extends Dao<CashDiscounts> {

  List<CashDiscounts> amb(Integer patId);
  List<CashDiscounts> stat(Integer patId);

  Double patientAmbDiscountSum(Integer patId);
  Double patientStatDiscountSum(Integer patId);
}
