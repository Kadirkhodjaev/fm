package ckb.domains.med.drug.dict;

import ckb.domains.GenId;

import javax.persistence.*;

@Entity
@Table(name = "Drug_s_Counts")
public class DrugCount extends GenId {

  @OneToOne
  @JoinColumn
  private Drugs drug;

  @Column
  private Double drugCount;

  @OneToOne
  @JoinColumn
  private DrugMeasures measure;

  public Drugs getDrug() {
    return drug;
  }

  public void setDrug(Drugs drug) {
    this.drug = drug;
  }

  public Double getDrugCount() {
    return drugCount;
  }

  public void setDrugCount(Double drugCount) {
    this.drugCount = drugCount;
  }

  public DrugMeasures getMeasure() {
    return measure;
  }

  public void setMeasure(DrugMeasures measure) {
    this.measure = measure;
  }
}
