package ckb.services.mo.amb;

import ckb.grid.AmbGrid;
import ckb.models.AmbPatient;
import ckb.models.amb.AmbFormField;
import ckb.session.Session;

import java.util.List;

public interface SMoAmb {

  List<AmbPatient> gridRows(AmbGrid grid, Session session);

  long gridRowCount(AmbGrid grid);

  int createPatientServiceId(int patient, int service, int user, int treatment);

  void createPatientService(int patient, int service, int user);

  void updatePaySum(Integer patient);

  List<AmbFormField> serviceFields(Integer service);
}
