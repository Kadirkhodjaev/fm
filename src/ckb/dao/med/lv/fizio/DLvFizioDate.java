package ckb.dao.med.lv.fizio;

import ckb.dao.Dao;
import ckb.domains.med.lv.LvFizioDates;

import java.util.Date;

public interface DLvFizioDate extends Dao<LvFizioDates> {

  void delFizio(Integer id);

  Date getPatientMaxDay(Integer id);

  void delDateFizio(String end, Integer id);

  Long getStateCount(Integer id);
}
