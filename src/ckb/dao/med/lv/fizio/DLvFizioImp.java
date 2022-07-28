package ckb.dao.med.lv.fizio;

import ckb.dao.DaoImp;
import ckb.domains.med.lv.LvFizios;

import java.util.ArrayList;
import java.util.List;

public class DLvFizioImp extends DaoImp<LvFizios> implements DLvFizio {
  public DLvFizioImp() {
    super(LvFizios.class);
  }

  @Override
  public List<LvFizios> getPaidServices(Integer id) {
    try {
      return getList("From LvFizios Where patientId = " + id + " And price > 0");
    } catch (Exception e) {
      return new ArrayList<LvFizios>();
    }
  }
}
