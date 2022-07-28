package ckb.domains.med.drug;

import ckb.domains.GenId;
import ckb.domains.med.drug.dict.*;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Drug_Act_Drugs")
public class DrugActDrugs extends GenId {

  @OneToOne
  @JoinColumn
  private DrugActs act;
  @OneToOne
  @JoinColumn
  private Drugs drug;
  @OneToOne
  @JoinColumn
  private DrugMeasures measure;
  @OneToOne
  @JoinColumn
  private DrugStorages storage;
  @OneToOne
  @JoinColumn
  private DrugCupboards cupboard;
  @OneToOne
  @JoinColumn
  private DrugManufacturers manufacturer;


  @Column
  private Double price;
  @Column
  private Double blockCount;
  @Column
  private Double drugCount;
  @Column
  private Double rasxod;
  @Column
  private Double unlead;
  @Column
  private Date startDate;
  @Column
  private Date endDate;

  @Column
  private Integer crBy;
  @Column
  private Date crOn;

  public DrugActs getAct() {
    return act;
  }

  public void setAct(DrugActs act) {
    this.act = act;
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

  public DrugStorages getStorage() {
    return storage;
  }

  public void setStorage(DrugStorages storage) {
    this.storage = storage;
  }

  public DrugCupboards getCupboard() {
    return cupboard;
  }

  public void setCupboard(DrugCupboards cupboard) {
    this.cupboard = cupboard;
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

  public Date getStartDate() {
    return startDate;
  }

  public void setStartDate(Date startDate) {
    this.startDate = startDate;
  }

  public Date getEndDate() {
    return endDate;
  }

  public void setEndDate(Date endDate) {
    this.endDate = endDate;
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

  public Double getUnlead() {
    return unlead;
  }

  public void setUnlead(Double unlead) {
    this.unlead = unlead;
  }

  public Double getBlockCount() {
    return blockCount;
  }

  public void setBlockCount(Double blockCount) {
    this.blockCount = blockCount;
  }

  public DrugManufacturers getManufacturer() {
    return manufacturer;
  }

  public void setManufacturer(DrugManufacturers manufacturer) {
    this.manufacturer = manufacturer;
  }
}
