package ckb.models;

public class AmbPatient {

  private int id;
  private String fio;
  private String birthdate;
  private String tel;
  private String country;
  private String region;
  private String dateReg;
  private String state;
  private String icon;
  private Double paySum;

  public int getId() {
    return id;
  }

  public void setId(int id) {
    this.id = id;
  }

  public String getFio() {
    return fio;
  }

  public void setFio(String fio) {
    this.fio = fio;
  }

  public String getBirthdate() {
    return birthdate;
  }

  public void setBirthdate(String birthdate) {
    this.birthdate = birthdate;
  }

  public String getTel() {
    return tel;
  }

  public void setTel(String tel) {
    this.tel = tel;
  }

  public String getCountry() {
    return country;
  }

  public void setCountry(String country) {
    this.country = country;
  }

  public String getRegion() {
    return region;
  }

  public void setRegion(String region) {
    this.region = region;
  }

  public String getDateReg() {
    return dateReg;
  }

  public void setDateReg(String dateReg) {
    this.dateReg = dateReg;
  }

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
  }

  public String getIcon() {
    return icon;
  }

  public void setIcon(String icon) {
    this.icon = icon;
  }

  public Double getPaySum() {
    return paySum;
  }

  public void setPaySum(Double paySum) {
    this.paySum = paySum;
  }
}
