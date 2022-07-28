package ckb.domains.med.exp.dict;

import ckb.domains.GenId;

import javax.persistence.*;

@Entity
@Table(name = "Exp_s_Norms")
public class ExpNorms extends GenId {

  @Column private String parentType; // amb, stat, detail
  @Column private Integer service;

  @OneToOne @JoinColumn private ExpProducts product;
  @OneToOne @JoinColumn private ExpMeasures measure;
  @Column private Double rasxod;

  public String getParentType() {
    return parentType;
  }

  public void setParentType(String parentType) {
    this.parentType = parentType;
  }

  public Integer getService() {
    return service;
  }

  public void setService(Integer service) {
    this.service = service;
  }

  public ExpProducts getProduct() {
    return product;
  }

  public void setProduct(ExpProducts product) {
    this.product = product;
  }

  public ExpMeasures getMeasure() {
    return measure;
  }

  public void setMeasure(ExpMeasures measure) {
    this.measure = measure;
  }

  public Double getRasxod() {
    return rasxod;
  }

  public void setRasxod(Double rasxod) {
    this.rasxod = rasxod;
  }
}
