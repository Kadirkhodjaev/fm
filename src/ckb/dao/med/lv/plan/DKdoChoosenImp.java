package ckb.dao.med.lv.plan;

import ckb.dao.DaoImp;
import ckb.domains.med.lv.KdoChoosens;

import java.util.List;

public class DKdoChoosenImp extends DaoImp<KdoChoosens> implements DKdoChoosen {

  public DKdoChoosenImp() {
    super(KdoChoosens.class);
  }

  @Override
  public List<Integer> getKdoIds() {
    return entityManager.createQuery("Select kdo.id From KdoChoosens group by kdo.id").getResultList();
  }

  @Override
  public Double getPrice(Integer counteryId, int kdo, int col) {
    try {
      KdoChoosens ch = (KdoChoosens) entityManager.createQuery("From KdoChoosens Where kdo.id = " + kdo + " And colName = '" + col + "'").getSingleResult();
      Double price = counteryId == 199 ? ch.getPrice() : ch.getFor_price();
      return price == null ? 0D : price;
    } catch (Exception e) {
      return 0D;
    }
  }

  @Override
  public Double getRealPrice(Integer counteryId, int kdo, int col) {
    try {
      KdoChoosens ch = (KdoChoosens) entityManager.createQuery("From KdoChoosens Where kdo.id = " + kdo + " And colName = '" + col + "'").getSingleResult();
      Double price = counteryId == 199 ? ch.getReal_price() : ch.getFor_real_price();
      return price == null ? 0D : price;
    } catch (Exception e) {
      return 0D;
    }
  }
}
