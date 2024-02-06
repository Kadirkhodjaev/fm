package ckb.domains.med.amb;

import ckb.domains.GenId;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "Amb_Form_Fields")
public class AmbFormFields extends GenId {

  @Column private Integer service;
  @Column private String fieldName;
  @Column private String fieldLabel;
  @Column private String typeCode;
  @Column private String ei;
  @Column private Integer ord;
  @Column private String normaType;

  public Integer getService() {
    return service;
  }

  public void setService(Integer service) {
    this.service = service;
  }

  public String getFieldName() {
    return fieldName;
  }

  public void setFieldName(String fieldName) {
    this.fieldName = fieldName;
  }

  public String getFieldLabel() {
    return fieldLabel;
  }

  public void setFieldLabel(String fieldLabel) {
    this.fieldLabel = fieldLabel;
  }

  public String getTypeCode() {
    return typeCode;
  }

  public void setTypeCode(String typeCode) {
    this.typeCode = typeCode;
  }

  public String getEi() {
    return ei;
  }

  public void setEi(String ei) {
    this.ei = ei;
  }

  public Integer getOrd() {
    return ord;
  }

  public void setOrd(Integer ord) {
    this.ord = ord;
  }

  public String getNormaType() {
    return normaType;
  }

  public void setNormaType(String normaType) {
    this.normaType = normaType;
  }
}
