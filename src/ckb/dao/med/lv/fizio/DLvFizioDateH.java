package ckb.dao.med.lv.fizio;

import ckb.dao.Dao;
import ckb.domains.med.lv.LvFizioDatesH;

import java.util.Date;

public interface DLvFizioDateH extends Dao<LvFizioDatesH> {

  void delFizio(Integer id);

  Date getPatientMaxDay(Integer id);

  void delDateFizio(String end, Integer id);

  Long getStateCount(Integer id);
}
