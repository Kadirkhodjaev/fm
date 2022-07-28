package ckb.dao.med.nurse.eat;

import ckb.dao.Dao;
import ckb.domains.med.nurse.eat.NurseEatPatients;

public interface DNurseEatPatient extends Dao<NurseEatPatients> {
  void delByEat(Integer id);

  void delByEatTable(Integer eat, Integer table);

  void delPatientsByEat(Integer id);
}
