package ckb.dao.med.amb;

import ckb.dao.Dao;
import ckb.domains.admin.Users;
import ckb.domains.med.amb.AmbServiceUsers;

public interface DAmbServiceUsers extends Dao<AmbServiceUsers> {
  Users getFirstUser(Integer id);
}
