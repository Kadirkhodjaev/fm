package ckb.dao.emp;

import ckb.dao.DaoImp;
import ckb.domains.emp.EmpDoctors;

public class DEmpDoctorImp extends DaoImp<EmpDoctors> implements DEmpDoctor {
  public DEmpDoctorImp() {
    super(EmpDoctors.class);
  }
}
