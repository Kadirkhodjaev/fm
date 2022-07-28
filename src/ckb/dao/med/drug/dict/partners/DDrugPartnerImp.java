package ckb.dao.med.drug.dict.partners;

import ckb.dao.DaoImp;
import ckb.domains.med.drug.dict.DrugPartners;

public class DDrugPartnerImp extends DaoImp<DrugPartners> implements DDrugPartner {
  public DDrugPartnerImp() {
    super(DrugPartners.class);
  }
}
