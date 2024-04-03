package ckb.domains.med.drug;

import ckb.domains.GenId;
import ckb.domains.med.drug.dict.*;

import javax.persistence.*;
import java.util.Date;
import java.util.Objects;

@Entity
@Table(name = "Drug_Act_Drugs")
public class DrugActDrugs extends GenId {

  @OneToOne @JoinColumn private DrugActs act;
  @OneToOne @JoinColumn private Drugs drug;
  @OneToOne @JoinColumn private DrugMeasures measure;
  @OneToOne @JoinColumn private DrugManufacturers manufacturer;

  @Column private Double price;
  @Column private Double blockCount;
  @Column private Double counter;
  @Column private Double countPrice;
  @Column private Double rasxod;
  @Column private Date startDate;
  @Column private Date endDate;
  @Column private Double ndsProc;
  @Column private Double nds;

  @Column private Integer crBy;
  @Column private Date crOn;

  public Double getCountPrice() {
    return countPrice;
  }

  public void setCountPrice(Double countPrice) {
    this.countPrice = countPrice;
  }

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

  public Double getPrice() {
    return price;
  }

  public void setPrice(Double price) {
    this.price = price;
  }

  public Double getCounter() {
    return counter;
  }

  public void setCounter(Double drugCount) {
    this.counter = drugCount;
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

  public Double getNdsProc() {
    return ndsProc;
  }

  public void setNdsProc(Double ndsProc) {
    this.ndsProc = ndsProc;
  }

  public Double getNds() {
    return nds;
  }

  public void setNds(Double nds) {
    this.nds = nds;
  }

  public Double getNdsSum() {
    if(Objects.equals(rasxod, counter)) {
      return 0D;
    } else {
      return nds == null ? countPrice * 0.12 : nds;
    }
  }
}
