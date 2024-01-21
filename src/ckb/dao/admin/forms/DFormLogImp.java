package ckb.dao.admin.forms;

import ckb.dao.DaoImp;
import ckb.domains.admin.FormLogs;

public class DFormLogImp extends DaoImp<FormLogs> implements DFormLog {
  public DFormLogImp() {
    super(FormLogs.class);
  }
}
