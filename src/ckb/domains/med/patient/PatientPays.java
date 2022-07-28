package ckb.domains.med.patient;

import ckb.domains.GenId;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.util.Date;

@Entity
@Table(name = "patient_pays")
public class PatientPays extends GenId {

  @Column private Integer patient_id;
  @Column private Double cash;
  @Column private Double card;
  @Column private Double transfer;
  @Column private String payType = "pay";

  @Column private Integer crBy;
  @Column private Date crOn;

  public Integer getPatient_id() {
    return patient_id;
  }

  public void setPatient_id(Integer patient_id) {
    this.patient_id = patient_id;
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

  public String getPayType() {
    return payType;
  }

  public void setPayType(String payType) {
    this.payType = payType;
  }
}
