package ckb.dao.print.page.param;

import ckb.dao.DaoImp;
import ckb.domains.print.PrintPageParams;

public class DPrintPageParamImp extends DaoImp<PrintPageParams> implements DPrintPageParam {
  public DPrintPageParamImp() {
    super(PrintPageParams.class);
  }
}
