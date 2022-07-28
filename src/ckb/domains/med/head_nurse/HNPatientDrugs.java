package ckb.domains.med.head_nurse;

import ckb.domains.GenId;
import ckb.domains.med.drug.dict.DrugCount;
import ckb.domains.med.drug.dict.Drugs;

import javax.persistence.*;

@Entity
@Table(name = "Hn_Patient_Drugs")
public class HNPatientDrugs extends GenId {

  @OneToOne
  @JoinColumn(name = "hn_patient") private HNPatients parent;

  @OneToOne @JoinColumn private Drugs drug;
  @OneToOne @JoinColumn private DrugCount counter;

  @Column private Double drugCounter;
  @Column private String drugName;

  @Column private Double serviceCount;
  @Column private Double price;
  @Column private Double drugPrice;

  public HNPatients getParent() {
    return parent;
  }

  public void setParent(HNPatients parent) {
    this.parent = parent;
  }

  public Drugs getDrug() {
    return drug;
  }

  public void setDrug(Drugs drug) {
    this.drug = drug;
  }

  public Double getServiceCount() {
    return serviceCount;
  }

  public void setServiceCount(Double serviceCount) {
    this.serviceCount = serviceCount;
  }

  public Double getPrice() {
    return price;
  }

  public void setPrice(Double price) {
    this.price = price;
  }

  public DrugCount getCounter() {
    return counter;
  }

  public void setCounter(DrugCount counter) {
    this.counter = counter;
  }

  public String getDrugName() {
    return drugName;
  }

  public void setDrugName(String drugName) {
    this.drugName = drugName;
  }

  public Double getDrugPrice() {
    return drugPrice;
  }

  public void setDrugPrice(Double drugPrice) {
    this.drugPrice = drugPrice;
  }

  public Double getDrugCounter() {
    return drugCounter;
  }

  public void setDrugCounter(Double drugCounter) {
    this.drugCounter = drugCounter;
  }
}
