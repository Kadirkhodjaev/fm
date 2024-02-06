package ckb.models.amb;

import ckb.domains.med.amb.AmbFormFieldNormas;
import ckb.domains.med.amb.AmbFormFieldOptions;

import java.util.List;

public class AmbFormField {

  private Integer id;
  private Integer service;
  private String fieldName;
  private String fieldLabel;
  private String typeCode;
  private String ei;
  private Integer ord;
  private String normaType;
  private Integer normaId;
  private String normaFrom;
  private String normaTo;
  private Integer maleNormaId;
  private String maleNormaFrom;
  private String maleNormaTo;
  private Integer femaleNormaId;
  private String femaleNormaFrom;
  private String femaleNormaTo;
  private List<AmbFormFieldOptions> options;
  private List<AmbFormFieldNormas> normas;

  public Integer getId() {
    return id;
  }

  public void setId(Integer id) {
    this.id = id;
  }

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

  public Integer getNormaId() {
    return normaId;
  }

  public void setNormaId(Integer normaId) {
    this.normaId = normaId;
  }

  public String getNormaFrom() {
    return normaFrom;
  }

  public void setNormaFrom(Double normaFrom) {
    String val = String.valueOf(normaFrom);
    this.normaFrom = val.indexOf(".") == val.length() - 2 ? val + "0" : val;
  }

  public String getNormaTo() {
    return normaTo;
  }

  public void setNormaTo(Double normaTo) {
    String val = String.valueOf(normaTo);
    this.normaTo = val.indexOf(".") == val.length() - 2 ? val + "0" : val;
  }

  public List<AmbFormFieldOptions> getOptions() {
    return options;
  }

  public void setOptions(List<AmbFormFieldOptions> options) {
    this.options = options;
  }

  public List<AmbFormFieldNormas> getNormas() {
    return normas;
  }

  public void setNormas(List<AmbFormFieldNormas> normas) {
    this.normas = normas;
  }

  public Integer getMaleNormaId() {
    return maleNormaId;
  }

  public void setMaleNormaId(Integer maleNormaId) {
    this.maleNormaId = maleNormaId;
  }

  public String getMaleNormaFrom() {
    return maleNormaFrom;
  }

  public void setMaleNormaFrom(Double maleNormaFrom) {
    String val = String.valueOf(maleNormaFrom);
    this.maleNormaFrom = val.indexOf(".") == val.length() - 2 ? val + "0" : val;
  }

  public String getMaleNormaTo() {
    return maleNormaTo;
  }

  public void setMaleNormaTo(Double maleNormaTo) {
    String val = String.valueOf(maleNormaTo);
    this.maleNormaTo = val.indexOf(".") == val.length() - 2 ? val + "0" : val;
  }

  public Integer getFemaleNormaId() {
    return femaleNormaId;
  }

  public void setFemaleNormaId(Integer femaleNormaId) {
    this.femaleNormaId = femaleNormaId;
  }

  public String getFemaleNormaFrom() {
    return femaleNormaFrom;
  }

  public void setFemaleNormaFrom(Double femaleNormaFrom) {
    String val = String.valueOf(femaleNormaFrom);
    this.femaleNormaFrom = val.indexOf(".") == val.length() - 2 ? val + "0" : val;
  }

  public String getFemaleNormaTo() {
    return femaleNormaTo;
  }

  public void setFemaleNormaTo(Double femaleNormaTo) {
    String val = String.valueOf(femaleNormaTo);
    this.femaleNormaTo = val.indexOf(".") == val.length() - 2 ? val + "0" : val;
  }
}
