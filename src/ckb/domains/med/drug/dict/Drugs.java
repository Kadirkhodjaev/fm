package ckb.domains.med.drug.dict;

import ckb.domains.GenId;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Drug_s_Names")
public class Drugs extends GenId {

  @Column
  private String name;
  @Column
  private String state;

  @Column
  private Double price;

  @Column
  private Integer crBy;
  @Column
  private Date crOn;

  @Column private Double counter;
  @OneToOne @JoinColumn DrugMeasures measure;

  public Double getCounter() {
    return counter;
  }

  public void setCounter(Double counter) {
    this.counter = counter;
  }

  public DrugMeasures getMeasure() {
    return measure;
  }

  public void setMeasure(DrugMeasures measure) {
    this.measure = measure;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
  }

  public Double getPrice() {
    return price;
  }

  public void setPrice(Double price) {
    this.price = price;
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
}
