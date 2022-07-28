package ckb.dao.admin.forms.opts;

import ckb.dao.DaoImp;
import ckb.domains.admin.SelOpts;

import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 27.08.15
 * Time: 22:36
 * To change this template use File | Settings | File Templates.
 */
public class DOptImp extends DaoImp<SelOpts> implements DOpt {
  public DOptImp() {
    super(SelOpts.class);
  }

  @Override
  public List<SelOpts> getAmbTypes() {
    return getList("From SelOpts Where id in (444, 445, 446, 447, 448)");
  }
}
