package ckb.dao.med.amb;

import ckb.dao.DaoImp;
import ckb.domains.med.amb.AmbPatientPays;

import java.util.ArrayList;
import java.util.List;

public class DAmbPatientPaysImp extends DaoImp<AmbPatientPays> implements DAmbPatientPay {

  public DAmbPatientPaysImp() {
    super(AmbPatientPays.class);
  }

  @Override
  public List<AmbPatientPays> byPatient(int curPat) {
    try {
      return getList("From AmbPatientPays Where patient = " + curPat);
    } catch (Exception e) {
      return new ArrayList<>();
    }
  }

  @Override
  public Double paidSum(Integer id) {
    try {
      Double summ = (Double) entityManager.createQuery("Select Sum(card + cash) From AmbPatientPays Where patient = " + id).getSingleResult();
      return summ == null ? 0D : summ;
    } catch (Exception e) {
      return 0D;
    }
  }
}
