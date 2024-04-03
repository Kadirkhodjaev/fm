package ckb.domains.med.head_nurse;

import ckb.domains.GenId;
import ckb.domains.med.drug.DrugOutRows;
import ckb.domains.med.drug.dict.DrugDirections;
import ckb.domains.med.drug.dict.DrugMeasures;
import ckb.domains.med.drug.dict.Drugs;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "HN_Drugs")
public class HNDrugs extends GenId {

  @OneToOne @JoinColumn private Drugs drug;
  @OneToOne @JoinColumn private DrugDirections direction;
  @OneToOne @JoinColumn private DrugOutRows outRow;

  @Column private Double drugCount;
  @OneToOne @JoinColumn private DrugMeasures measure;
  @Column private Double rasxod;
  @Column private Double price;

  @Column private Integer transfer;
  @Column private Integer transfer_hndrug_id;
  @Column private Integer history;
  @Column private Double ndsProc;
  @Column private Double nds;

  @Column private Integer crBy;
  @Column private Date crOn;

  public Integer getTransfer_hndrug_id() {
    return transfer_hndrug_id;
  }

  public void setTransfer_hndrug_id(Integer transfer_hndrug_id) {
    this.transfer_hndrug_id = transfer_hndrug_id;
  }

  public Integer getTransfer() {
    return transfer;
  }

  public void setTransfer(Integer transfer) {
    this.transfer = transfer;
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

  public DrugDirections getDirection() {
    return direction;
  }

  public void setDirection(DrugDirections direction) {
    this.direction = direction;
  }

  public Drugs getDrug() {
    return drug;
  }

  public void setDrug(Drugs drug) {
    this.drug = drug;
  }

  public DrugOutRows getOutRow() {
    return outRow;
  }

  public void setOutRow(DrugOutRows outRow) {
    this.outRow = outRow;
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

  public Integer getHistory() {
    return history;
  }

  public void setHistory(Integer history) {
    this.history = history;
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
}
