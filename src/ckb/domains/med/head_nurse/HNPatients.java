package ckb.domains.med.head_nurse;

import ckb.domains.GenId;
import ckb.domains.med.patient.Patients;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Hn_Patients")
public class HNPatients extends GenId {

  @OneToOne @JoinColumn private Patients patient;

  @Column private String actNum;
  @Column private Date dateEnd;
  @Column private int dayCount;

  @Column private Double ndsProc;
  @Column private Double koykoPrice;
  @Column private Double eatPrice;

  @Column private String state;
  @Column private Double paySum;
  @Column private Double totalSum;

  @Column private String closed = "N";

  public Patients getPatient() {
    return patient;
  }

  public void setPatient(Patients patient) {
    this.patient = patient;
  }

  public String getActNum() {
    return actNum;
  }

  public void setActNum(String actNum) {
    this.actNum = actNum;
  }

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
  }

  public Date getDateEnd() {
    return dateEnd;
  }

  public void setDateEnd(Date dateEnd) {
    this.dateEnd = dateEnd;
  }

  public int getDayCount() {
    return dayCount;
  }

  public void setDayCount(int dayCount) {
    this.dayCount = dayCount;
  }

  public Double getKoykoPrice() {
    return koykoPrice;
  }

  public void setKoykoPrice(Double koykoPrice) {
    this.koykoPrice = koykoPrice;
  }

  public Double getEatPrice() {
    return eatPrice;
  }

  public void setEatPrice(Double eatPrice) {
    this.eatPrice = eatPrice;
  }

  public Double getPaySum() {
    return paySum;
  }

  public void setPaySum(Double paySum) {
    this.paySum = paySum;
  }

  public Double getTotalSum() {
    return totalSum;
  }

  public void setTotalSum(Double totalSum) {
    this.totalSum = totalSum;
  }

  public String getClosed() {
    return closed;
  }

  public void setClosed(String closed) {
    this.closed = closed;
  }

  public Double getNdsProc() {
    return ndsProc;
  }

  public void setNdsProc(Double ndsProc) {
    this.ndsProc = ndsProc;
  }
}
