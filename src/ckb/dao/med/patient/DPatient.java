package ckb.dao.med.patient;

import ckb.dao.Dao;
import ckb.domains.med.patient.Patients;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 22.08.15
 * Time: 0:39
 * To change this template use File | Settings | File Templates.
 */
public interface DPatient extends Dao<Patients> {
  String getFio(int id);

  Integer getNextYearNum();

  boolean existIbNum(Integer id, Integer yearNum);

  Long getKoykoCount(String s);
}
