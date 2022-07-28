package ckb.domains.med.amb;

import ckb.domains.GenId;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "Amb_Patient_Links")
public class AmbPatientLinks extends GenId {

  @Column private Integer parent;
  @Column private Integer child;

  public Integer getParent() {
    return parent;
  }

  public void setParent(Integer parent) {
    this.parent = parent;
  }

  public Integer getChild() {
    return child;
  }

  public void setChild(Integer child) {
    this.child = child;
  }
}
