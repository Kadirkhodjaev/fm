package ckb.services.med.amb;

import ckb.domains.med.amb.AmbPatientServices;
import ckb.domains.med.amb.AmbPatients;
import ckb.models.AmbService;
import ckb.models.FormField;
import ckb.models.Grid;
import ckb.models.PatientList;
import ckb.models.drugs.PatientDrug;
import ckb.session.Session;
import org.springframework.ui.Model;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

public interface SAmb {

  List<PatientList> getGridList(Grid grid, Session session);

  void makeAddEditUrlByRole(Model model, int roleId, boolean isArchive);

  long getCount(Session session, String sql);

  void createModel(HttpServletRequest req, AmbPatients p);

  AmbPatients save(HttpServletRequest req);

  void setFields(Model m, Integer serviceId);

  List<AmbService> getHistoryServices(int curPat);

  String getFormJson(Integer result);

  List<FormField> getResultFields(AmbPatientServices service);

  List<PatientDrug> getDrugs(int curPat);

  PatientDrug getDrug(int id);
}
