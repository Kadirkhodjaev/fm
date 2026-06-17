package ckb.dao.med.patient;

import ckb.dao.DaoImp;
import ckb.domains.med.patient.PatientPays;
import ckb.utils.Util;

import java.util.ArrayList;
import java.util.List;

public class DPatientPaysImp extends DaoImp<PatientPays> implements DPatientPays {

  public DPatientPaysImp() {
    super(PatientPays.class);
  }


  @Override
  public List<PatientPays> byPatient(Integer id) {
    try {
      return getList("From PatientPays Where patient_id = " + id);
    } catch (Exception e) {
      return new ArrayList<PatientPays>();
    }
  }

  @Override
  public double paid(Integer id) {
    List<PatientPays> pays = getList("From PatientPays Where patient_id = " + id);;
    double paid = 0;
    for(PatientPays pay: pays) {
      paid += pay.getTransfer() + pay.getCard() + pay.getCash() + Util.nvl(pay.getOnline(), 0);
    }
    return paid;
  }
}
