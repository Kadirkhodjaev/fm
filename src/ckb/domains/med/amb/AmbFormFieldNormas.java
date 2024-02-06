package ckb.domains.med.amb;

import ckb.domains.GenId;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "Amb_Form_Field_Normas")
public class AmbFormFieldNormas extends GenId {

  @Column private Integer service;
  @Column private Integer field;
  @Column private String sex;
  @Column private Integer yearFrom;
  @Column private Integer yearTo;
  @Column private Double normaFrom;
  @Column private Double normaTo;

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

  public String getSex() {
    return sex;
  }

  public void setSex(String sex) {
    this.sex = sex;
  }

  public Integer getYearFrom() {
    return yearFrom;
  }

  public void setYearFrom(Integer yearFrom) {
    this.yearFrom = yearFrom;
  }

  public Integer getYearTo() {
    return yearTo;
  }

  public void setYearTo(Integer yearTo) {
    this.yearTo = yearTo;
  }

  public Double getNormaFrom() {
    return normaFrom;
  }

  public void setNormaFrom(Double normaFrom) {
    this.normaFrom = normaFrom;
  }

  public Double getNormaTo() {
    return normaTo;
  }

  public void setNormaTo(Double normaTo) {
    this.normaTo = normaTo;
  }
}
