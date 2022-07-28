package ckb.dao.med.nurse.eat;

import ckb.dao.Dao;
import ckb.domains.med.nurse.eat.NurseEats;

public interface DNurseEats extends Dao<NurseEats> {
  boolean check(NurseEats eat);
}
