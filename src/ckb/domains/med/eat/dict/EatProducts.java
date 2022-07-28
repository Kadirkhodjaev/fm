package ckb.domains.med.eat.dict;

import ckb.domains.GenId;
import ckb.domains.admin.Dicts;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Eat_s_Products")
public class EatProducts extends GenId {

  @OneToOne @JoinColumn private EatCategories category;
  @OneToOne @JoinColumn private Dicts measureType;
  @Column private String name;
  @Column private String state;

  @Column private Integer crBy;
  @Column private Date crOn;

  public Dicts getMeasureType() {
    return measureType;
  }

  public void setMeasureType(Dicts measureType) {
    this.measureType = measureType;
  }

  public EatCategories getCategory() {
    return category;
  }

  public void setCategory(EatCategories category) {
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
}
