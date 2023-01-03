package ckb.domains.med.head_nurse;

import ckb.domains.GenId;
import ckb.domains.admin.Users;
import ckb.domains.med.amb.AmbPatients;
import ckb.domains.med.drug.dict.DrugDirections;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "HN_h_Dates")
public class HNHDates extends GenId {

  @OneToOne @JoinColumn private HNDirections receiver;

  @Column private Date date;
  @Column private String state;
  @Column private String paid;

  @OneToOne @JoinColumn private Users crBy;
  @Column private Date crOn;

  @OneToOne @JoinColumn private DrugDirections direction;
  @OneToOne @JoinColumn private AmbPatients patient;

  public String getPaid() {
    return paid;
  }

  public void setPaid(String paid) {
    this.paid = paid;
  }

  public Date getDate() {
    return date;
  }

  public void setDate(Date date) {
    this.date = date;
  }

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
  }

  public Users getCrBy() {
    return crBy;
  }

  public void setCrBy(Users crBy) {
    this.crBy = crBy;
  }

  public Date getCrOn() {
    return crOn;
  }

  public void setCrOn(Date crOn) {
    this.crOn = crOn;
  }

  public DrugDirections getDirection() {
    return direction;
  }

  public void setDirection(DrugDirections direction) {
    this.direction = direction;
  }

  public HNDirections getReceiver() {
    return receiver;
  }

  public void setReceiver(HNDirections receiver) {
    this.receiver = receiver;
  }

  public AmbPatients getPatient() {
    return patient;
  }

  public void setPatient(AmbPatients patient) {
    this.patient = patient;
  }
}
