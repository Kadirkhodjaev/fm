package ckb.dao.med.lv.fizio;

import ckb.dao.DaoImp;
import ckb.domains.med.lv.LvFizioDates;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;

public class DLvFizioDateImp extends DaoImp<LvFizioDates> implements DLvFizioDate {

  public DLvFizioDateImp() {
    super(LvFizioDates.class);
  }

  @Transactional
  public void delFizio(Integer id) {
    entityManager.createQuery("Delete From LvFizioDates t Where t.fizio.id = " + id).executeUpdate();
  }

  @Override
  public Date getPatientMaxDay(Integer id) {
    try {
      return (Date) entityManager.createQuery("Select Max(date) From LvFizioDates Where fizio.patientId = " + id).getSingleResult();
    } catch (Exception e) {
      return null;
    }
  }

  @Transactional
  public void delDateFizio(String end, Integer id) {
    entityManager.createQuery("Delete From LvFizioDates t Where t.fizio.id = " + id + " And date(date) = '" + end + "'").executeUpdate();
  }

  @Override
  public Long getStateCount(Integer id) {
    return getCount("From LvFizioDates t Where t.fizio.id = " + id + " And state = 'Y'");
  }
}
