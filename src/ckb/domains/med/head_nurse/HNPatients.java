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

  @Column(scale = 2, length = 20) private Double kdoSum;
  @Column(scale = 2, length = 20) private Double labSum;
  @Column(scale = 2, length = 20) private Double consulSum;
  @Column(scale = 2, length = 20) private Double koykoSum;
  @Column(scale = 2, length = 20) private Double disSum;
  @Column(scale = 2, length = 20) private Double watcherSum;
  @Column(scale = 2, length = 20) private Double eatSum;
  @Column(scale = 2, length = 20) private Double drugSum;
  @Column private String checked = "N";

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

  public Double getKdoSum() {
    return kdoSum;
  }

  public void setKdoSum(Double kdoSum) {
    this.kdoSum = kdoSum;
  }

  public Double getLabSum() {
    return labSum;
  }

  public void setLabSum(Double labSum) {
    this.labSum = labSum;
  }

  public Double getConsulSum() {
    return consulSum;
  }

  public void setConsulSum(Double consulSum) {
    this.consulSum = consulSum;
  }

  public Double getKoykoSum() {
    return koykoSum;
  }

  public void setKoykoSum(Double koykoSum) {
    this.koykoSum = koykoSum;
  }

  public Double getDisSum() {
    return disSum;
  }

  public void setDisSum(Double disSum) {
    this.disSum = disSum;
  }

  public Double getWatcherSum() {
    return watcherSum;
  }

  public void setWatcherSum(Double watcherSum) {
    this.watcherSum = watcherSum;
  }

  public Double getEatSum() {
    return eatSum;
  }

  public void setEatSum(Double eatSum) {
    this.eatSum = eatSum;
  }

  public Double getDrugSum() {
    return drugSum;
  }

  public void setDrugSum(Double drugSum) {
    this.drugSum = drugSum;
  }

  public String getChecked() {
    return checked;
  }

  public void setChecked(String checked) {
    this.checked = checked;
  }
}
