package ckb.dao.admin.depts;

import ckb.dao.DaoImp;
import ckb.domains.admin.Depts;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 25.08.15
 * Time: 21:13
 * To change this template use File | Settings | File Templates.
 */
public class DDeptImp extends DaoImp<Depts> implements DDept {
  public DDeptImp() {
    super(Depts.class);
  }
}
