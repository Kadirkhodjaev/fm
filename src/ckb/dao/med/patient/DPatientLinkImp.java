package ckb.dao.med.patient;

import ckb.dao.DaoImp;
import ckb.domains.med.patient.PatientLinks;
import org.springframework.transaction.annotation.Transactional;

public class DPatientLinkImp extends DaoImp<PatientLinks> implements DPatientLink {

  public DPatientLinkImp() {
    super(PatientLinks.class);
  }

  @Transactional
  public void saveLink(Integer parent, Integer child) {
    if(parent == null) return;
    PatientLinks obj = new PatientLinks();
    obj.setParent(parent);
    obj.setChild(child);
    save(obj);
    obj = new PatientLinks();
    obj.setParent(child);
    obj.setChild(parent);
    save(obj);
  }

  @Transactional
  public void deletePatient(int curPat) {
    entityManager.createQuery("delete from PatientLinks where parent = " + curPat + " or child = " + curPat).executeUpdate();
  }
}
