package ckb.domains.med.drug;

import ckb.domains.GenId;
import ckb.domains.med.drug.dict.DrugMeasures;
import ckb.domains.med.drug.dict.Drugs;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Drug_Out_Rows")
public class DrugOutRows extends GenId {

  @OneToOne @JoinColumn private DrugOuts doc;

  @OneToOne @JoinColumn private Drugs drug;
  @OneToOne @JoinColumn private DrugMeasures measure;
  @Column private Double claimCount;

  @OneToOne @JoinColumn private DrugActDrugs income;
  @Column private Double drugCount;
  @Column private Double price;
  @Column private Integer hndrug;

  @Column private Integer crBy;
  @Column private Date crOn;


  public Double getPrice() {
    return price;
  }

  public void setPrice(Double price) {
    this.price = price;
  }

  public DrugOuts getDoc() {
    return doc;
  }

  public void setDoc(DrugOuts doc) {
    this.doc = doc;
  }

  public DrugActDrugs getIncome() {
    return income;
  }

  public void setIncome(DrugActDrugs income) {
    this.income = income;
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

  public Integer getHndrug() {
    return hndrug;
  }

  public void setHndrug(Integer hndrug) {
    this.hndrug = hndrug;
  }
}
