package ckb.dao.med.amb;

import ckb.dao.DaoImp;
import ckb.domains.med.amb.AmbPatientServices;

import java.util.List;

public class DAmbPatientServiceImp extends DaoImp<AmbPatientServices> implements DAmbPatientService {
  public DAmbPatientServiceImp() {
    super(AmbPatientServices.class);
  }

  @Override
  public String patientTotal(int curPat) {
    try {
      String sum = "" + entityManager.createQuery("Select Sum(price) From AmbPatientServices Where state = 'ENT' And patient = " + curPat).getSingleResult();
      return sum.equals("null") || sum.equals("") ? "0" : sum.replace(",", ".");
    } catch (Exception e) {
      return "";
    }
  }

  @Override
  public Double patientTotalSum(int curPat) {
    try {
      Double sum = (Double) entityManager.createQuery("Select Sum(price) From AmbPatientServices Where state = 'ENT' And patient = " + curPat).getSingleResult();
      return sum == null ? 0D : sum;
    } catch (Exception e) {
      return 0D;
    }
  }

  @Override
  public List<AmbPatientServices> byUser(int curPat, int userId) {
    return getList("From AmbPatientServices Where patient = " + curPat + " And crBy = " + userId);
  }
}
