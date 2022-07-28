package ckb.dao.med.nurse.eat;

import ckb.dao.DaoImp;
import ckb.domains.med.nurse.eat.NurseEatPatients;
import org.springframework.transaction.annotation.Transactional;

public class DNurseEatPatientImp extends DaoImp<NurseEatPatients> implements DNurseEatPatient {
  public DNurseEatPatientImp() {
    super(NurseEatPatients.class);
  }

  @Transactional
  public void delByEat(Integer id) {
    entityManager.createQuery("Delete From NurseEatPatients Where nurseEat.id = " + id).executeUpdate();
  }

  @Transactional
  public void delByEatTable(Integer eat, Integer table) {
    entityManager.createQuery("Delete From NurseEatPatients Where nurseEat.id = " + eat + " And table.id = " + table).executeUpdate();
  }

  @Transactional
  public void delPatientsByEat(Integer id) {
    entityManager.createQuery("Delete From NurseEatPatients Where patient != null And nurseEat.id = " + id).executeUpdate();
  }
}
