package ckb.dao.med.amb;

import ckb.dao.DaoImp;
import ckb.domains.med.amb.AmbPatientTreatments;

public class DAmbPatientTreatmentImp extends DaoImp<AmbPatientTreatments> implements DAmbPatientTreatment {
  public DAmbPatientTreatmentImp() {
    super(AmbPatientTreatments.class);
  }
}
