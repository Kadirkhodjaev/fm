package ckb.domains.med.head_nurse;

import ckb.domains.GenId;
import ckb.domains.med.drug.DrugWriteOffRows;
import ckb.domains.med.drug.dict.DrugCount;
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
  @OneToOne @JoinColumn private DrugWriteOffRows writeOffRows;

  @OneToOne @JoinColumn private DrugCount counter;
  @OneToOne @JoinColumn private DrugMeasures measure;

  @Column private Integer parent_id;
  @Column private Integer parent_row;
  @Column private Double parentCount;
  @Column private Double dropCount;
  @Column private Double drugCount;
  @Column private Double rasxod;

  @Column private Integer crBy;
  @Column private Date crOn;

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

  public Integer getParent_id() {
    return parent_id;
  }

  public void setParent_id(Integer parent_id) {
    this.parent_id = parent_id;
  }

  public Drugs getDrug() {
    return drug;
  }

  public void setDrug(Drugs drug) {
    this.drug = drug;
  }

  public DrugWriteOffRows getWriteOffRows() {
    return writeOffRows;
  }

  public void setWriteOffRows(DrugWriteOffRows writeOffRows) {
    this.writeOffRows = writeOffRows;
  }

  public DrugCount getCounter() {
    return counter;
  }

  public void setCounter(DrugCount counter) {
    this.counter = counter;
  }

  public Double getParentCount() {
    return parentCount;
  }

  public void setParentCount(Double parentCount) {
    this.parentCount = parentCount;
  }

  public Double getDropCount() {
    return dropCount;
  }

  public void setDropCount(Double dropCount) {
    this.dropCount = dropCount;
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

  public Integer getParent_row() {
    return parent_row;
  }

  public void setParent_row(Integer parent_row) {
    this.parent_row = parent_row;
  }
}
