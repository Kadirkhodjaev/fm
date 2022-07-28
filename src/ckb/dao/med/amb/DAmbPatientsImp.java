package ckb.dao.med.amb;

import ckb.dao.DaoImp;
import ckb.domains.med.amb.AmbPatients;

import java.util.ArrayList;
import java.util.List;

public class DAmbPatientsImp extends DaoImp<AmbPatients> implements DAmbPatients {

  public DAmbPatientsImp() {
    super(AmbPatients.class);
  }

  @Override
  public List<AmbPatients> currentsByClient(Integer id) {
    try {
      return getList("From AmbPatients Where state != 'ARCH' And client.id = " + id);
    } catch (Exception e) {
      return new ArrayList<AmbPatients>();
    }
  }

  @Override
  public List<AmbPatients> archiveByClient(Integer id) {
    try {
      return getList("From AmbPatients Where state = 'ARCH' And client.id = " + id);
    } catch (Exception e) {
      return new ArrayList<AmbPatients>();
    }
  }

  @Override
  public List<AmbPatients> currentsStatByClient(Integer id) {
    try {
      return getList("From Patients Where state != 'ARCH' And client.id = " + id);
    } catch (Exception e) {
      return new ArrayList<AmbPatients>();
    }
  }

  @Override
  public List<AmbPatients> archiveStatByClient(Integer id) {
    try {
      return getList("From Patients Where state = 'ARCH' And client.id = " + id);
    } catch (Exception e) {
      return new ArrayList<AmbPatients>();
    }
  }
}
