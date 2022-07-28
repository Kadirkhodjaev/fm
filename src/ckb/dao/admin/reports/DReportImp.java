package ckb.dao.admin.reports;

import ckb.dao.DaoImp;
import ckb.domains.admin.Reports;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 26.08.15
 * Time: 14:23
 * To change this template use File | Settings | File Templates.
 */
public class DReportImp extends DaoImp<Reports> implements DReport {
  public DReportImp() {
    super(Reports.class);
  }
}
