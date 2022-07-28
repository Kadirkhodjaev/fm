package ckb.domains.med.eat.dict;

import ckb.domains.GenId;

import javax.persistence.*;

@Entity
@Table(name = "Eat_s_Measure_Links")
public class EatMeasureLinks extends GenId {

  @OneToOne @JoinColumn private EatMeasures parent;
  @OneToOne @JoinColumn private EatMeasures child;

  @Column private Double value;

  public EatMeasures getParent() {
    return parent;
  }

  public void setParent(EatMeasures parent) {
    this.parent = parent;
  }

  public EatMeasures getChild() {
    return child;
  }

  public void setChild(EatMeasures child) {
    this.child = child;
  }

  public Double getValue() {
    return value;
  }

  public void setValue(Double value) {
    this.value = value;
  }
}
