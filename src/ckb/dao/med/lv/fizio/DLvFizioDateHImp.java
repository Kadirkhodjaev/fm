package ckb.dao.med.lv.fizio;

import ckb.dao.DaoImp;
import ckb.domains.med.lv.LvFizioDatesH;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;

public class DLvFizioDateHImp extends DaoImp<LvFizioDatesH> implements DLvFizioDateH {

  public DLvFizioDateHImp() {
    super(LvFizioDatesH.class);
  }

  @Transactional
  public void delFizio(Integer id) {
    entityManager.createQuery("Delete From LvFizioDatesH t Where t.fizio.id = " + id).executeUpdate();
  }

  @Override
  public Date getPatientMaxDay(Integer id) {
    try {
      return (Date) entityManager.createQuery("Select Max(date) From LvFizioDatesH Where fizio.patientId = " + id).getSingleResult();
    } catch (Exception e) {
      return null;
    }
  }

  @Transactional
  public void delDateFizio(String end, Integer id) {
    entityManager.createQuery("Delete From LvFizioDatesH t Where t.fizio.id = " + id + " And date(date) = '" + end + "'").executeUpdate();
  }

  @Override
  public Long getStateCount(Integer id) {
    return getCount("From LvFizioDatesH t Where t.fizio.id = " + id + " And state = 'Y'");
  }
}
