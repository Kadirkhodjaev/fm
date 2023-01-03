package ckb.domains.med.head_nurse;

import ckb.domains.GenId;
import ckb.domains.med.drug.dict.DrugMeasures;
import ckb.domains.med.patient.Patients;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "HN_h_Date_Patient_Rows")
public class HNHDatePatientRows extends GenId {

  @OneToOne @JoinColumn private Patients patient;
  @OneToOne @JoinColumn private HNHDrugs drug;
  @OneToOne @JoinColumn private HNHDates doc;
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

  public Patients getPatient() {
    return patient;
  }

  public void setPatient(Patients patient) {
    this.patient = patient;
  }

  public HNHDrugs getDrug() {
    return drug;
  }

  public void setDrug(HNHDrugs drug) {
    this.drug = drug;
  }

  public void setDoc(HNHDates doc) {
    this.doc = doc;
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
