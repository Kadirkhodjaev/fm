package ckb.domains.med.patient;

import ckb.domains.GenId;
import ckb.domains.med.drug.dict.DrugMeasures;
import ckb.domains.med.drug.dict.Drugs;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Patient_Drug_Rows")
public class PatientDrugRows extends GenId {

  @OneToOne @JoinColumn private PatientDrugs patientDrug;
  @OneToOne @JoinColumn private Drugs drug;
  @Column private String source;
  @Column private String name;
  @Column private Double expanse;
  @Column private String state;
  @Column private Date conDate;
  @OneToOne @JoinColumn private DrugMeasures measure;

  public PatientDrugs getPatientDrug() {
    return patientDrug;
  }

  public void setPatientDrug(PatientDrugs patientDrug) {
    this.patientDrug = patientDrug;
  }

  public String getSource() {
    return source;
  }

  public void setSource(String source) {
    this.source = source;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public Double getExpanse() {
    return expanse;
  }

  public void setExpanse(Double expanse) {
    this.expanse = expanse;
  }

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
  }

  public Date getConDate() {
    return conDate;
  }

  public void setConDate(Date conDate) {
    this.conDate = conDate;
  }

  public Drugs getDrug() {
    return drug;
  }

  public void setDrug(Drugs drug) {
    this.drug = drug;
  }

  public DrugMeasures getMeasure() {
    return measure;
  }

  public void setMeasure(DrugMeasures measure) {
    this.measure = measure;
  }
}
