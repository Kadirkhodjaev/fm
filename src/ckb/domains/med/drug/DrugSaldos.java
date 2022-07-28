package ckb.domains.med.drug;

import ckb.domains.GenId;
import ckb.domains.med.drug.dict.Drugs;

import javax.persistence.*;

@Entity
@Table(name = "Drug_Saldos")
public class DrugSaldos extends GenId {

  @OneToOne
  @JoinColumn
  private Drugs drug;
  @Column
  private Double price;
  @Column
  private Double drugCount;
  @Column
  private Double rasxod;
  @Column
  private Double unlead;

  public Drugs getDrug() {
    return drug;
  }

  public void setDrug(Drugs drug) {
    this.drug = drug;
  }

  public Double getPrice() {
    return price;
  }

  public void setPrice(Double price) {
    this.price = price;
  }

  public Double getDrugCount() {
    return drugCount;
  }

  public void setDrugCount(Double drugCount) {
    this.drugCount = drugCount;
  }

  public Double getRasxod() {
    return rasxod;
  }

  public void setRasxod(Double rasxod) {
    this.rasxod = rasxod;
  }

  public Double getUnlead() {
    return unlead;
  }

  public void setUnlead(Double unlead) {
    this.unlead = unlead;
  }
}
