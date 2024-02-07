package ckb.models.amb;

public class AmbFormFieldNorma {

  private Integer id;
  private Integer service;
  private Integer field;
  private String normType;
  private String sex;
  private Integer yearFrom;
  private Integer yearTo;
  private String normaFrom;
  private String normaTo;

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

  public Integer getField() {
    return field;
  }

  public void setField(Integer field) {
    this.field = field;
  }

  public String getNormType() {
    return normType;
  }

  public void setNormType(String normType) {
    this.normType = normType;
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
}
