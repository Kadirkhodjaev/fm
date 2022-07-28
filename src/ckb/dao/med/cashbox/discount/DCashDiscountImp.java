package ckb.dao.med.cashbox.discount;

import ckb.dao.DaoImp;
import ckb.domains.med.cash.CashDiscounts;

import java.util.List;

public class DCashDiscountImp extends DaoImp<CashDiscounts> implements DCashDiscount {
  public DCashDiscountImp() {
    super(CashDiscounts.class);
  }

  @Override
  public List<CashDiscounts> amb(Integer patId) {
    return getList("From CashDiscounts Where ambStat = 'AMB' And patient = " + patId);
  }

  @Override
  public List<CashDiscounts> stat(Integer patId) {
    return getList("From CashDiscounts Where ambStat = 'STAT' And patient = " + patId);
  }

  @Override
  public Double patientAmbDiscountSum(Integer patId) {
    try {
      Double summ = (Double) entityManager.createQuery("Select Sum(summ) From CashDiscounts Where ambStat = 'AMB' And patient = " + patId).getSingleResult();
      return summ == null ? 0D : summ;
    } catch (Exception e) {
      return 0D;
    }
  }

  @Override
  public Double patientStatDiscountSum(Integer patId) {
    try {
      Double summ = (Double) entityManager.createQuery("Select Sum(summ) From CashDiscounts Where ambStat = 'STAT' And patient = " + patId).getSingleResult();
      return summ == null ? 0D : summ;
    } catch (Exception e) {
      return 0D;
    }
  }
}
