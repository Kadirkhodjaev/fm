package ckb.domains.med.head_nurse;

import ckb.domains.GenId;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "HN_Date_Rows")
public class HNDateRows extends GenId {

  @OneToOne @JoinColumn private HNDates doc;
  @OneToOne @JoinColumn private HNDrugs drug;

  @Column private Double rasxod;

  @Column private Integer crBy;
  @Column private Date crOn;

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

  public HNDates getDoc() {
    return doc;
  }

  public void setDoc(HNDates doc) {
    this.doc = doc;
  }

  public HNDrugs getDrug() {
    return drug;
  }

  public void setDrug(HNDrugs drug) {
    this.drug = drug;
  }

  public Double getRasxod() {
    return rasxod;
  }

  public void setRasxod(Double rasxod) {
    this.rasxod = rasxod;
  }
}
