package ckb.domains.med.amb;

import ckb.domains.GenId;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "Amb_Service_Fields")
public class AmbServiceFields extends GenId {

  @Column private Integer service;
  @Column private String name;
  @Column private Integer field;

  public Integer getService() {
    return service;
  }

  public void setService(Integer service) {
    this.service = service;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public Integer getField() {
    return field;
  }

  public void setField(Integer field) {
    this.field = field;
  }
}
