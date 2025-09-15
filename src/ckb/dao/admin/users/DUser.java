package ckb.dao.admin.users;

import ckb.dao.Dao;
import ckb.domains.admin.KdoTypes;
import ckb.domains.admin.Reports;
import ckb.domains.admin.Users;

import java.util.List;

public interface DUser extends Dao<Users> {

  Users getByLoginPassword(String login, String password);

  List<Reports> getReports(Integer id);

  List<KdoTypes> getKdoTypes(Integer id);

  List<Integer> getKdoTypesIds(Integer id);
}
