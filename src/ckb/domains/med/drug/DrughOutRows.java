package ckb.domains.med.drug;

import ckb.domains.GenId;
import ckb.domains.med.drug.dict.DrugMeasures;
import ckb.domains.med.drug.dict.Drugs;

import javax.persistence.*;

@Entity
@Table(name = "Drug_h_Out_Rows")
public class DrughOutRows extends GenId {

  @OneToOne @JoinColumn private DrughOuts doc;

  @OneToOne @JoinColumn private Drugs drug;
  @OneToOne @JoinColumn private DrugMeasures measure;
  @Column private Double claimCount;

  @OneToOne @JoinColumn private DrughActDrugs income;
  @OneToOne @JoinColumn private DrugSaldos saldo;
  @Column private Double drugCount;
  @Column private Double price;
  @Column private String childType;

  public DrughOuts getDoc() {
    return doc;
  }

  public void setDoc(DrughOuts doc) {
    this.doc = doc;
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

  public Double getClaimCount() {
    return claimCount;
  }

  public void setClaimCount(Double claimCount) {
    this.claimCount = claimCount;
  }

  public DrughActDrugs getIncome() {
    return income;
  }

  public void setIncome(DrughActDrugs income) {
    this.income = income;
  }

  public Double getDrugCount() {
    return drugCount;
  }

  public void setDrugCount(Double drugCount) {
    this.drugCount = drugCount;
  }

  public Double getPrice() {
    return price;
  }

  public void setPrice(Double price) {
    this.price = price;
  }

  public String getChildType() {
    return childType;
  }

  public void setChildType(String childType) {
    this.childType = childType;
  }

  public DrugSaldos getSaldo() {
    return saldo;
  }

  public void setSaldo(DrugSaldos saldo) {
    this.saldo = saldo;
  }
}
