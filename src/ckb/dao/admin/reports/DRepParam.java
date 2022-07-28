package ckb.dao.admin.reports;

import ckb.dao.Dao;
import ckb.domains.med.report.RepParams;

import java.util.List;

public interface DRepParam extends Dao<RepParams> {
  List<RepParams> regParams(Integer id);
}
