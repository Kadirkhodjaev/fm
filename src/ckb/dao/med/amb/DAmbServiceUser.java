package ckb.dao.med.amb;

import ckb.dao.Dao;
import ckb.domains.admin.Users;
import ckb.domains.med.amb.AmbServiceUsers;

public interface DAmbServiceUser extends Dao<AmbServiceUsers> {
  Users getFirstUser(Integer service);
}
