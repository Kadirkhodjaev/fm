package ckb.domains.med.head_nurse;

import ckb.domains.GenId;
import ckb.domains.med.amb.AmbPatients;
import ckb.domains.med.drug.dict.Drugs;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "HN_Date_Amb_Rows")
public class HNDateAmbRows extends GenId {

  @Column private Date date;

  @OneToOne @JoinColumn private AmbPatients patient;
  @OneToOne @JoinColumn private HNDates doc;

  @OneToOne @JoinColumn private HNDrugs hndrug;
  @OneToOne @JoinColumn private Drugs drug;

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

  public Double getRasxod() {
    return rasxod;
  }

  public void setRasxod(Double rasxod) {
    this.rasxod = rasxod;
  }

  public Date getDate() {
    return date;
  }

  public void setDate(Date date) {
    this.date = date;
  }

  public AmbPatients getPatient() {
    return patient;
  }

  public void setPatient(AmbPatients patient) {
    this.patient = patient;
  }

  public HNDates getDoc() {
    return doc;
  }

  public void setDoc(HNDates doc) {
    this.doc = doc;
  }

  public HNDrugs getHndrug() {
    return hndrug;
  }

  public void setHndrug(HNDrugs hndrug) {
    this.hndrug = hndrug;
  }

  public Drugs getDrug() {
    return drug;
  }

  public void setDrug(Drugs drug) {
    this.drug = drug;
  }
}
