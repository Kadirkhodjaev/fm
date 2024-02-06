package ckb.domains.med.amb;

import ckb.domains.GenId;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "Amb_Form_Field_Options")
public class AmbFormFieldOptions extends GenId {

  @Column private Integer service;
  @Column private Integer field;
  @Column private String optName;
  @Column private Integer ord;

  public Integer getService() {
    return service;
  }

  public void setService(Integer service) {
    this.service = service;
  }

  public Integer getField() {
    return field;
  }

  public void setField(Integer field) {
    this.field = field;
  }

  public String getOptName() {
    return optName;
  }

  public void setOptName(String optName) {
    this.optName = optName;
  }

  public Integer getOrd() {
    return ord;
  }

  public void setOrd(Integer ord) {
    this.ord = ord;
  }
}
