package ckb.dao.med.lv.plan;

import ckb.dao.Dao;
import ckb.domains.med.lv.KdoChoosens;

import java.util.List;

public interface DKdoChoosen extends Dao<KdoChoosens> {
  List<Integer> getKdoIds();

  Double getPrice(Integer counteryId, int kdo, int col);

  Double getRealPrice(Integer counteryId, int kdo, int col);
}
