package ckb.dao.med.patient;

import ckb.dao.DaoImp;
import ckb.domains.med.patient.Patients;
import ckb.utils.Util;

import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 22.08.15
 * Time: 0:40
 * To change this template use File | Settings | File Templates.
 */
public class DPatientImp extends DaoImp<Patients> implements DPatient {

  public DPatientImp() {
    super(Patients.class);
  }

  @Override
  public String getFio(int id) {
    Patients p = get(id);
    return Util.nvl(p.getSurname()) + " " + Util.nvl(p.getName()) + " " + Util.nvl(p.getMiddlename());
  }

  @Override
  public Integer getNextYearNum() {
    Integer yearNum = (Integer) entityManager.createQuery("Select Max(yearNum) From Patients Where yearNum > 0 And YEAR(dateBegin) = YEAR(CURRENT_TIMESTAMP())").getSingleResult();
    return yearNum == null ? 1 : yearNum + 1;
  }

  @Override
  public Integer getNextOtdNum(int deptId) {
    Integer otdNum = (Integer) entityManager.createQuery("Select Max(otdNum) From Patients Where otdNum > 0 And YEAR(dateBegin) = YEAR(CURRENT_TIMESTAMP()) And dept.id = " + deptId).getSingleResult();
    return otdNum == null ? 1 : otdNum + 1;
  }

  @Override
  public List<Patients> getEatPatients(Integer deptId, String actDate) {
    return getList("From Patients t Where t.dateEnd Is null");
  }

  @Override
  public boolean existIbNum(Integer pId, Integer yearNum, Integer otdNum) {
    return getCount("From Patients Where id != " + pId + " And yearNum = " + yearNum + " And otdNum = " + otdNum + " And YEAR(dateBegin) = YEAR(CURRENT_TIMESTAMP())") > 0;
  }

  @Override
  public Long getKoykoCount(String s) {
    try {
      Long koyko = (Long) entityManager.createQuery("Select Sum(dayCount) " + s).getSingleResult();
      return koyko == null ? 0L : koyko;
    } catch (Exception e) {
      return 0L;
    }
  }
}
