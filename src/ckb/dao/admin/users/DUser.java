package ckb.dao.admin.users;

import ckb.dao.Dao;
import ckb.domains.admin.KdoTypes;
import ckb.domains.admin.Reports;
import ckb.domains.admin.Users;

import java.util.List;

public interface DUser extends Dao<Users> {

  Users getByLoginPassword(String login, String password);

  List<Reports> getReports(Integer id);

  List<Users> getLvs();

  List<KdoTypes> getKdoTypes(Integer id);

  List<Users> getConsuls();

  List<Integer> getKdoTypesIds(Integer id);

  Users getZavOtdel(Integer id);

  Users getGlb(Integer id);

  Users getBoss(Integer id);

  Users getGlavbuh(int id);
}
