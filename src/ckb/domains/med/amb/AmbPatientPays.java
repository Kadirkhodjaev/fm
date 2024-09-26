package ckb.domains.med.amb;

import ckb.domains.GenId;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.util.Date;

@Entity
@Table(name = "Amb_Patient_Pays")
public class AmbPatientPays extends GenId {

  @Column private Integer patient;
  //
  @Column private Double cash;
  @Column private Double card;
  @Column private Double transfer;
  @Column private Double online;
  @Column private String payType;
  //
  @Column private Integer crBy;
  @Column private Date crOn;

  public Integer getPatient() {
    return patient;
  }

  public void setPatient(Integer patient) {
    this.patient = patient;
  }

  public Double getCash() {
    return cash;
  }

  public void setCash(Double cash) {
    this.cash = cash;
  }

  public Double getCard() {
    return card;
  }

  public void setCard(Double card) {
    this.card = card;
  }

  public Double getTransfer() {
    return transfer;
  }

  public void setTransfer(Double transfer) {
    this.transfer = transfer;
  }

  public String getPayType() {
    return payType;
  }

  public void setPayType(String payType) {
    this.payType = payType;
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

  public Double getOnline() {
    return online;
  }

  public void setOnline(Double online) {
    this.online = online;
  }
}
