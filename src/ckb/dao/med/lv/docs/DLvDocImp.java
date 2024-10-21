package ckb.dao.med.lv.docs;

import ckb.dao.DaoImp;
import ckb.domains.med.lv.LvDocs;

public class DLvDocImp extends DaoImp<LvDocs> implements DLvDoc {

  public DLvDocImp() {
    super(LvDocs.class);
  }

  @Override
  public LvDocs get(int pat, String code) {
    try {
      return getObj("From LvDocs Where patient.id = " + pat + " and docCode = '" + code + "'");
    } catch (Exception e) {
      return null;
    }
  }

  @Override
  public boolean hasOSM(int pat) {
    return getCount("From LvDocs Where doc = 'osm' And patient.id = " + pat) > 0;
  }
}
