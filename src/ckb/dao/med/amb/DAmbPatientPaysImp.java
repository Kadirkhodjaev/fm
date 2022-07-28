package ckb.dao.med.amb;

import ckb.dao.DaoImp;
import ckb.domains.med.amb.AmbPatientPays;

import java.util.ArrayList;
import java.util.List;

public class DAmbPatientPaysImp extends DaoImp<AmbPatientPays> implements DAmbPatientPays {

  public DAmbPatientPaysImp() {
    super(AmbPatientPays.class);
  }

  @Override
  public List<AmbPatientPays> byPatient(int curPat) {
    try {
      return getList("From AmbPatientPays Where patient = " + curPat);
    } catch (Exception e) {
      return new ArrayList<AmbPatientPays>();
    }
  }
}
