package ckb.dao.med.bookings;

import ckb.dao.DaoImp;
import ckb.domains.med.RoomBookings;

public class DRoomBookingsImp extends DaoImp<RoomBookings> implements DRoomBookings {

  public DRoomBookingsImp() {
    super(RoomBookings.class);
  }

}
