package ckb.dao.med.amb;

import ckb.dao.Dao;
import ckb.domains.med.amb.AmbPatients;

import java.util.List;

public interface DAmbPatients extends Dao<AmbPatients> {
  List<AmbPatients> currentsByClient(Integer id);

  List<AmbPatients> archiveByClient(Integer id);

  List<AmbPatients> currentsStatByClient(Integer id);

  List<AmbPatients> archiveStatByClient(Integer id);
}
