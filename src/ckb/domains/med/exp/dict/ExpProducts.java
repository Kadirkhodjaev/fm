package ckb.domains.med.exp.dict;

import ckb.domains.GenId;
import ckb.domains.admin.Dicts;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Exp_s_Products")
public class ExpProducts extends GenId {

  @OneToOne @JoinColumn private ExpCategories category;
  @OneToOne @JoinColumn private Dicts measureType;
  @Column private String name;
  @Column private String state;

  @Column private Integer crBy;
  @Column private Date crOn;

  public ExpCategories getCategory() {
    return category;
  }

  public void setCategory(ExpCategories category) {
    this.category = category;
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

  public Dicts getMeasureType() {
    return measureType;
  }

  public void setMeasureType(Dicts measureType) {
    this.measureType = measureType;
  }
}
