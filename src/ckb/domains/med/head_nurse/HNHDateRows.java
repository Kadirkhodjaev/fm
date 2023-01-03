package ckb.domains.med.head_nurse;

import ckb.domains.GenId;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "HN_h_Date_Rows")
public class HNHDateRows extends GenId {

  @OneToOne @JoinColumn private HNHDates doc;
  @OneToOne @JoinColumn private HNHDrugs drug;

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

  public HNHDates getDoc() {
    return doc;
  }

  public void setDoc(HNHDates doc) {
    this.doc = doc;
  }

  public HNHDrugs getDrug() {
    return drug;
  }

  public void setDrug(HNHDrugs drug) {
    this.drug = drug;
  }

  public Double getRasxod() {
    return rasxod;
  }

  public void setRasxod(Double rasxod) {
    this.rasxod = rasxod;
  }
}
