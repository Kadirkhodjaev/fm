package ckb.dao.med.patient;

import ckb.dao.DaoImp;
import ckb.domains.med.eat.dict.EatTables;
import ckb.domains.med.patient.PatientEats;

import java.util.List;

public class DPatientEatImp extends DaoImp<PatientEats> implements DPatientEat {

  public DPatientEatImp() {
    super(PatientEats.class);
  }

  @Override
  public List<PatientEats> getPatientEat(Integer patientId) {
    return getList("From PatientEats t Where t.patient.id = " + patientId);
  }

  @Override
  public Integer getPatientTable(Integer id) {
    try {
      return (Integer) entityManager.createQuery("Select max(table.id) From PatientEats t where t.patient.id = " + id).getSingleResult();
    } catch (Exception e) {
      return 0;
    }
  }

  @Override
  public EatTables minTable(Integer id) {
    try {
      return (EatTables) entityManager.createQuery("Select table From PatientEats t Where t.actDate in (Select min(c.actDate) From PatientEats c Where c.patient.id = " + id + ") And t.patient.id = " + id).getSingleResult();
    } catch (Exception e) {
      return new EatTables();
    }
  }
}
