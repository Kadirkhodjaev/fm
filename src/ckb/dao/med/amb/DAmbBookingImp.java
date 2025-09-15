package ckb.dao.med.amb;

import ckb.dao.DaoImp;
import ckb.domains.med.amb.AmbBookings;

public class DAmbBookingImp extends DaoImp<AmbBookings> implements DAmbBooking {
  public DAmbBookingImp() {
    super(AmbBookings.class);
  }
}
