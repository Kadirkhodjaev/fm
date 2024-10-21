package ckb.dao.med.lv.docs;

import ckb.dao.Dao;
import ckb.domains.med.lv.LvDocs;

public interface DLvDoc extends Dao<LvDocs> {
  LvDocs get(int pat, String code);

  boolean hasOSM(int pat);
}
