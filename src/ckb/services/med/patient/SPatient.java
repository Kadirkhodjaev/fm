package ckb.services.med.patient;

import ckb.domains.admin.Kdos;
import ckb.domains.med.patient.Patients;
import ckb.domains.med.lv.LvEpics;
import ckb.models.Grid;
import ckb.models.ObjList;
import ckb.models.PatientList;
import ckb.models.drugs.PatientDrug;
import ckb.models.drugs.PatientDrugNurseDate;
import ckb.session.Session;
import org.springframework.ui.Model;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public interface SPatient {

  Patients save(HttpServletRequest req) throws Exception;

  void createModel(HttpServletRequest request, Patients patient);

  void makeAddEditUrlByRole(Model model, int roleId, String curPat);

  List<PatientList> getGridList(Grid grid, Session session);

  void createDocModel(Patients request, Patients patient);

  Patients docSave(HttpServletRequest req);

  ArrayList<ObjList> getDairies(int curPat);

  ArrayList<ObjList> getPlans(int curPat);

  List<Kdos> getKdos();

  void saveKdos(Session session, String[] ids);

  void createEpicModel(LvEpics epic);

  void saveEpic(LvEpics epic);

  List<ObjList> getEpicGrid(Integer patientId);

  long getCount(Session session, String sql);

  List<PatientDrug> getPatientDrugs(int curPat);

  PatientDrug getDrug(int id);

  List<PatientDrug> getDrugsByType(int curPat, int i);

  List<PatientDrug> getDrugsByType(int curPat, int type, boolean isLv);

  List<PatientDrug> getDrugsByTypeToDate(Integer patId, Date operDay, int i, String time);

  List<PatientDrugNurseDate> getPatientNewDrugs(int dep);
}
