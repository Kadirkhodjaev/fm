package ckb.dao.med.lv.drug;

import ckb.dao.DaoImp;
import ckb.domains.med.lv.LvDrugs;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class DLvDrugImp extends DaoImp<LvDrugs> implements DLvDrug  {

  public DLvDrugImp(){super(LvDrugs.class);}

  @Override
  public List<LvDrugs> getPatientDrugs(Integer patientId) {
    try{
      return getList("From LvDrugs Where patient = " + patientId);
    } catch(Exception e){
      return new ArrayList<LvDrugs>();
    }
  }

  @Override
  public Date minDate(int curPat) {
    return (Date) entityManager.createQuery("select min (startDate) from LvDrugs where patient = " + curPat).getSingleResult();
  }

  @Override
  public List<LvDrugs> getPatientTabs(int curPat) {
    try{
      return getList("From LvDrugs Where patient = " + curPat + " And cat = 'tab'");
    } catch(Exception e){
      return new ArrayList<LvDrugs>();
    }
  }

  @Override
  public List<LvDrugs> getPatientInes(int curPat) {
    try{
      return getList("From LvDrugs Where patient = " + curPat + " And cat like 'ine%'");
    } catch(Exception e){
      return new ArrayList<LvDrugs>();
    }
  }
}
