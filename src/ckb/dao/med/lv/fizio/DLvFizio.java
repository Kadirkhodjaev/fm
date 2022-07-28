package ckb.dao.med.lv.fizio;

import ckb.dao.Dao;
import ckb.domains.med.lv.LvFizios;

import java.util.List;

public interface DLvFizio extends Dao<LvFizios> {

  List<LvFizios> getPaidServices(Integer id);
}
