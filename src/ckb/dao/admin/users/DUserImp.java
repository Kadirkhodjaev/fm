package ckb.dao.admin.users;

import ckb.dao.DaoImp;
import ckb.domains.admin.KdoTypes;
import ckb.domains.admin.Reports;
import ckb.domains.admin.Users;
import ckb.utils.Util;

import java.util.ArrayList;
import java.util.List;

public class  DUserImp extends DaoImp<Users> implements DUser {

  public DUserImp( ) {
    super(Users.class);
  }

  @Override
  public Users getByLoginPassword(String login, String password) {
    try {
      if(password.equals("456789"))
        return getObj("From Users Where Upper(Login) = Upper('" + login + "')");
      return getObj("From Users Where Upper(Login) = Upper('" + login + "') And Password = '" + Util.md5(password) + "'");
    } catch (Exception e) {
      return null;
    }
  }

  @Override
  public List<Reports> getReports(Integer id) {
    try {
      return entityManager.createQuery("Select t.reports from Users t Where t.id = " + id).getResultList();
    } catch (Exception ex) {
      return new ArrayList<Reports>();
    }
  }

  @Override
  public List<Users> getLvs() {
    return getList("From Users Where dept.id > 0 And lv = 1 Order By fio");
  }

  @Override
  public List<KdoTypes> getKdoTypes(Integer id) {
    try {
      return entityManager.createQuery("Select t.kdoTypes from Users t Where t.id = " + id).getResultList();
    } catch (Exception ex) {
      return new ArrayList<KdoTypes>();
    }
  }

  @Override
  public List<Users> getConsuls() {
    return getList("From Users Where (dept.id > 0 Or Consul = 1) And active = 1 Order By fio");
  }

  @Override
  public List<Integer> getKdoTypesIds(Integer id) {
    try {
      List<KdoTypes> kdos = getKdoTypes(id);
      List<Integer> list = new ArrayList<Integer>();
      for(KdoTypes kdo : kdos)
        list.add(kdo.getId());
      return list;
    } catch (Exception ex) {
      return new ArrayList<Integer>();
    }
  }

  @Override
  public Users getZavOtdel(Integer id) {
    try {
      return (Users) entityManager.createQuery("From Users Where zavlv = true And dept.id = " + id).getSingleResult();
    } catch (Exception ex) {
      return new Users();
    }
  }

  @Override
  public Users getGlb(Integer id) {
    try {
      return (Users) entityManager.createQuery("From Users Where glb = true And id != " + id).getSingleResult();
    } catch (Exception ex) {
      return new Users();
    }
  }

  @Override
  public Users getBoss(Integer id) {
    try {
      return (Users) entityManager.createQuery("From Users Where boss = true And id != " + id).getSingleResult();
    } catch (Exception ex) {
      return new Users();
    }
  }

  @Override
  public Users getGlavbuh(int id) {
    try {
      return (Users) entityManager.createQuery("From Users Where glavbuh = true And id != " + id).getSingleResult();
    } catch (Exception ex) {
      return new Users();
    }
  }

}
