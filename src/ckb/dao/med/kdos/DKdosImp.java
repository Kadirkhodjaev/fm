package ckb.dao.med.kdos;

import ckb.dao.DaoImp;
import ckb.domains.admin.Kdos;
import ckb.session.Session;

import java.util.ArrayList;
import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 16.10.16
 * Time: 23:49
 * To change this template use File | Settings | File Templates.
 */
public class DKdosImp extends DaoImp<Kdos> implements DKdos {

  public DKdosImp() {
    super(Kdos.class);
  }

  @Override
  public List<Kdos> getTypeKdos(Integer id) {
    try {
      return entityManager.createQuery("Select t from Kdos t Where t.state = 'A' And t.kdoType.id = " + id + " order by t.ord").getResultList();
    } catch (Exception ex) {
      return new ArrayList<Kdos>();
    }
  }

  @Override
  public List<Kdos> getUser999Kdos(Session session) {
    try {
      return getList("From Kdos t Where t.state = 'A' And formId = 999 And Exists (From Users c Join c.kdoTypes d Where d.id = t.kdoType.id And c.id = " + session.getUserId() +  ")");
    } catch (Exception ex) {
      return new ArrayList<Kdos>();
    }
  }

  @Override
  public List<Kdos> getLabKdos() {
    try {
      return entityManager.createQuery("Select t from Kdos t Where t.state = 'A' And t.kdoType.id in (1, 2) order by t.ord").getResultList();
    } catch (Exception ex) {
      return new ArrayList<Kdos>();
    }
  }

  @Override
  public Double getKdoPrice(Integer counteryId, int kdo_id) {
    Kdos kdo = get(kdo_id);
    if(counteryId == 199) {
      return kdo.getPrice();
    } else {
      return kdo.getFor_price();
    }
  }

  @Override
  public Double getKdoRealPrice(Integer counteryId, int kdo_id) {
    Kdos kdo = get(kdo_id);
    if(counteryId == 199) {
      return kdo.getReal_price();
    } else {
      return kdo.getFor_real_price();
    }
  }
}
