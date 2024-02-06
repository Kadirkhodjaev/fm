package ckb.dao.print.page;

import ckb.dao.DaoImp;
import ckb.domains.print.PrintPages;

public class DPrintPageImp extends DaoImp<PrintPages> implements DPrintPage {
  public DPrintPageImp() {
    super(PrintPages.class);
  }
}
