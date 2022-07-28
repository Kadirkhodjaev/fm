package ckb.services.med.kdo;

import ckb.domains.med.lv.LvPlans;
import ckb.models.ObjList;
import ckb.session.Session;
import org.springframework.ui.Model;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

public interface SKdo {

  String getKdoTypeIds(int userId);

  List<ObjList> getPatientPlans(int id, Session session);

  void createKdoModel(int planId, Model model);

  Integer save(LvPlans plan, HttpServletRequest request);
}
