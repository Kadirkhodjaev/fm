package ckb.domains.med.amb;

import ckb.domains.GenId;
import ckb.domains.admin.Users;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Amb_Booking_Services")
public class AmbBookingServices extends GenId {

  @OneToOne @JoinColumn private AmbServices service;
  @OneToOne @JoinColumn private AmbBookings booking;

  @OneToOne @JoinColumn private Users worker;

  @Column private Integer crBy;
  @Column private Date crOn;

  public AmbServices getService() {
    return service;
  }

  public void setService(AmbServices service) {
    this.service = service;
  }

  public AmbBookings getBooking() {
    return booking;
  }

  public void setBooking(AmbBookings booking) {
    this.booking = booking;
  }

  public Users getWorker() {
    return worker;
  }

  public void setWorker(Users worker) {
    this.worker = worker;
  }

  public Integer getCrBy() {
    return crBy;
  }

  public void setCrBy(Integer crBy) {
    this.crBy = crBy;
  }

  public Date getCrOn() {
    return crOn;
  }

  public void setCrOn(Date crOn) {
    this.crOn = crOn;
  }
}
