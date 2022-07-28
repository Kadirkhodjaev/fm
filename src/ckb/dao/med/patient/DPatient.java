package ckb.dao.med.patient;

import ckb.dao.Dao;
import ckb.domains.med.patient.Patients;

import java.util.List;

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

  Integer getNextOtdNum(int deptId);

  List<Patients> getEatPatients(Integer deptId, String actDate);

  boolean existIbNum(Integer id, Integer yearNum, Integer otdNum);

  Long getKoykoCount(String s);
}
