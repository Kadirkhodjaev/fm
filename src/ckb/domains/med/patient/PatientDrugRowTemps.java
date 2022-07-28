package ckb.domains.med.patient;

import ckb.domains.GenId;
import ckb.domains.med.drug.dict.DrugMeasures;
import ckb.domains.med.drug.dict.Drugs;

import javax.persistence.*;

@Entity
@Table(name = "Patient_Drug_Row_Temps")
public class PatientDrugRowTemps extends GenId {

  @OneToOne
  @JoinColumn
  private PatientDrugTemps patientDrug;
  @OneToOne
  @JoinColumn
  private Drugs drug;
  @Column
  private String source;
  @Column
  private String name;
  @Column
  private Double expanse;
  @OneToOne
  @JoinColumn
  private DrugMeasures measure;

  public PatientDrugTemps getPatientDrug() {
    return patientDrug;
  }

  public void setPatientDrug(PatientDrugTemps patientDrug) {
    this.patientDrug = patientDrug;
  }

  public Drugs getDrug() {
    return drug;
  }

  public void setDrug(Drugs drug) {
    this.drug = drug;
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

  public DrugMeasures getMeasure() {
    return measure;
  }

  public void setMeasure(DrugMeasures measure) {
    this.measure = measure;
  }
}
