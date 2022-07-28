package ckb.domains.med.cash;

import ckb.domains.GenId;
import ckb.domains.admin.Users;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Cash_Discounts")
public class CashDiscounts extends GenId {

  @Column private Integer patient;
  @Column private String ambStat = "STAT";

  @Column private String text;
  @Column private Double summ;

  @OneToOne @JoinColumn private Users crBy;
  @Column private Date crOn;

  public Integer getPatient() {
    return patient;
  }

  public void setPatient(Integer patient) {
    this.patient = patient;
  }

  public String getText() {
    return text;
  }

  public void setText(String text) {
    this.text = text;
  }

  public String getAmbStat() {
    return ambStat;
  }

  public void setAmbStat(String ambStat) {
    this.ambStat = ambStat;
  }

  public Double getSumm() {
    return summ;
  }

  public void setSumm(Double summ) {
    this.summ = summ;
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
}
