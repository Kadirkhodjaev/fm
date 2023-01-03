package ckb.domains.med.drug.dict;

import ckb.domains.GenId;

import javax.persistence.*;

@Entity
@Table(name = "Drug_s_Drug_Measures")
public class DrugDrugMeasures extends GenId {

  @Column private Integer drug;
  @OneToOne @JoinColumn private DrugMeasures measure;

  public Integer getDrug() {
    return drug;
  }

  public void setDrug(Integer drug) {
    this.drug = drug;
  }

  public DrugMeasures getMeasure() {
    return measure;
  }

  public void setMeasure(DrugMeasures measure) {
    this.measure = measure;
  }
}
