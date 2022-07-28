package ckb.dao.admin.forms.opts;

import ckb.dao.Dao;
import ckb.domains.admin.SelOpts;

import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 27.08.15
 * Time: 22:35
 * To change this template use File | Settings | File Templates.
 */
public interface DOpt extends Dao<SelOpts> {
  List<SelOpts> getAmbTypes();
}
