package ckb.dao.med.kdos;

import ckb.dao.Dao;
import ckb.domains.admin.Kdos;
import ckb.session.Session;

import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 16.10.16
 * Time: 23:48
 * To change this template use File | Settings | File Templates.
 */
public interface DKdos extends Dao<Kdos> {
  List<Kdos> getTypeKdos(Integer id);

  List<Kdos> getUser999Kdos(Session session);

  List<Kdos> getLabKdos();

  Double getKdoPrice(Integer counteryId, int kdo_id);

  Double getKdoRealPrice(Integer counteryId, int kdo_id);
}
