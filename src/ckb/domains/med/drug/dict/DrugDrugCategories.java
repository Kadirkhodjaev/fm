package ckb.domains.med.drug.dict;

import ckb.domains.GenId;

import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

@Entity
@Table(name = "Drug_s_Drug_Categories")
public class DrugDrugCategories extends GenId {

  @OneToOne
  @JoinColumn
  private Drugs drug;
  @OneToOne
  @JoinColumn
  private DrugCategories category;

  public DrugCategories getCategory() {
    return category;
  }

  public void setCategory(DrugCategories category) {
    this.category = category;
  }

  public Drugs getDrug() {
    return drug;
  }

  public void setDrug(Drugs drug) {
    this.drug = drug;
  }
}
