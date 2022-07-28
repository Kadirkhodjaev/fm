package ckb.domains.med.exp.dict;

import ckb.domains.GenId;

import javax.persistence.*;

@Entity
@Table(name = "Exp_s_Measure_Links")
public class ExpMeasureLinks  extends GenId {

  @OneToOne @JoinColumn private ExpMeasures parent;
  @OneToOne @JoinColumn private ExpMeasures child;

  @Column private Double value;

  public ExpMeasures getParent() {
    return parent;
  }

  public void setParent(ExpMeasures parent) {
    this.parent = parent;
  }

  public ExpMeasures getChild() {
    return child;
  }

  public void setChild(ExpMeasures child) {
    this.child = child;
  }

  public Double getValue() {
    return value;
  }

  public void setValue(Double value) {
    this.value = value;
  }
}
