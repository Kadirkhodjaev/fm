package ckb.models.amb;

import java.util.List;

public class AmbFormFieldRow {

  private Integer id;
  private String code;
  private String name;
  private String typeCode;
  private String fieldName;
  List<AmbFormField> fields;
  private String norma;
  private String ei;

  public Integer getId() {
    return id;
  }

  public void setId(Integer id) {
    this.id = id;
  }

  public String getCode() {
    return code;
  }

  public void setCode(String code) {
    this.code = code;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getTypeCode() {
    return typeCode;
  }

  public void setTypeCode(String typeCode) {
    this.typeCode = typeCode;
  }

  public String getFieldName() {
    return fieldName;
  }

  public void setFieldName(String fieldName) {
    this.fieldName = fieldName;
  }

  public List<AmbFormField> getFields() {
    return fields;
  }

  public void setFields(List<AmbFormField> fields) {
    this.fields = fields;
  }

  public String getNorma() {
    return norma;
  }

  public void setNorma(String norma) {
    this.norma = norma;
  }

  public String getEi() {
    return ei;
  }

  public void setEi(String ei) {
    this.ei = ei;
  }
}
