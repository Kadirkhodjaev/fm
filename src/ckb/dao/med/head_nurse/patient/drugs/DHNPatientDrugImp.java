package ckb.dao.med.head_nurse.patient.drugs;

import ckb.dao.DaoImp;
import ckb.domains.med.head_nurse.HNPatientDrugs;
import org.springframework.transaction.annotation.Transactional;

public class DHNPatientDrugImp extends DaoImp<HNPatientDrugs> implements DHNPatientDrug {
  public DHNPatientDrugImp() {
    super(HNPatientDrugs.class);
  }

  @Transactional
  public void deletePatient(int id) {
    entityManager.createQuery("Delete From HNPatientDrugs Where parent.id=" + id).executeUpdate();
  }
}
