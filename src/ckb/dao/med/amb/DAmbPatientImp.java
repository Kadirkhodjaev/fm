package ckb.dao.med.amb;

import ckb.dao.DaoImp;
import ckb.domains.med.amb.AmbPatients;

import java.util.ArrayList;
import java.util.List;

public class DAmbPatientImp extends DaoImp<AmbPatients> implements DAmbPatient {

  public DAmbPatientImp() {
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
}
