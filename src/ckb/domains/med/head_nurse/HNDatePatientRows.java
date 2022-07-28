package ckb.domains.med.head_nurse;

import ckb.domains.GenId;
import ckb.domains.med.drug.dict.DrugMeasures;
import ckb.domains.med.patient.Patients;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "HN_Date_Patient_Rows")
public class HNDatePatientRows extends GenId {

  @OneToOne @JoinColumn private Patients patient;
  @OneToOne @JoinColumn private HNDrugs drug;
  @OneToOne @JoinColumn private HNDates doc;
  @OneToOne @JoinColumn private DrugMeasures measure;

  @Column private Date date;
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

  public Patients getPatient() {
    return patient;
  }

  public void setPatient(Patients patient) {
    this.patient = patient;
  }

  public HNDrugs getDrug() {
    return drug;
  }

  public void setDrug(HNDrugs drug) {
    this.drug = drug;
  }

  public Date getDate() {
    return date;
  }

  public void setDate(Date date) {
    this.date = date;
  }

  public Double getRasxod() {
    return rasxod;
  }

  public void setRasxod(Double rasxod) {
    this.rasxod = rasxod;
  }

  public DrugMeasures getMeasure() {
    return measure;
  }

  public void setMeasure(DrugMeasures measure) {
    this.measure = measure;
  }
}
