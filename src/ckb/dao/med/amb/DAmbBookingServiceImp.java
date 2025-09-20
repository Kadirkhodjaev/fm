package ckb.dao.med.amb;

import ckb.dao.DaoImp;
import ckb.domains.med.amb.AmbBookingServices;

public class DAmbBookingServiceImp extends DaoImp<AmbBookingServices> implements DAmbBookingService {
  public DAmbBookingServiceImp() {
    super(AmbBookingServices.class);
  }
}
