package ckb.domains.med.amb;

import ckb.domains.GenId;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "Amb_Form_Cols")
public class AmbFormCols extends GenId {

  @Column private Integer service;
  @Column private Integer form;
  @Column private String name;
  @Column private Integer ord;

  public Integer getService() {
    return service;
  }

  public void setService(Integer service) {
    this.service = service;
  }

  public Integer getForm() {
    return form;
  }

  public void setForm(Integer form) {
    this.form = form;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public Integer getOrd() {
    return ord;
  }

  public void setOrd(Integer ord) {
    this.ord = ord;
  }
}
