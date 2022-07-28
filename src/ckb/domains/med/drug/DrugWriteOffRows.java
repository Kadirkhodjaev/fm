package ckb.domains.med.drug;

import ckb.domains.GenId;
import ckb.domains.med.drug.dict.DrugMeasures;
import ckb.domains.med.drug.dict.Drugs;

import javax.persistence.*;

@Entity
@Table(name = "Drug_Write_Off_Rows")
public class DrugWriteOffRows extends GenId {

  @OneToOne @JoinColumn private DrugWriteOffs doc;

  @OneToOne @JoinColumn private Drugs drug;
  @OneToOne @JoinColumn private DrugMeasures measure;
  @Column private Double claimCount;

  @OneToOne @JoinColumn private DrugSaldos saldo;
  @OneToOne @JoinColumn private DrugActDrugs income;
  @Column private String childType; // saldo - сальдо, income - приход
  @Column private Double drugCount;
  @Column private Double price;

  public Double getPrice() {
    return price;
  }

  public void setPrice(Double price) {
    this.price = price;
  }

  public DrugWriteOffs getDoc() {
    return doc;
  }

  public void setDoc(DrugWriteOffs doc) {
    this.doc = doc;
  }

  public DrugSaldos getSaldo() {
    return saldo;
  }

  public void setSaldo(DrugSaldos saldo) {
    this.saldo = saldo;
  }

  public DrugActDrugs getIncome() {
    return income;
  }

  public void setIncome(DrugActDrugs income) {
    this.income = income;
  }

  public String getChildType() {
    return childType;
  }

  public void setChildType(String childType) {
    this.childType = childType;
  }

  public Double getDrugCount() {
    return drugCount;
  }

  public void setDrugCount(Double drugCount) {
    this.drugCount = drugCount;
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
}
