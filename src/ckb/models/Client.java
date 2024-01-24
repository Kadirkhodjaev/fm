package ckb.models;

public class Client {

  private int id;
  private String fio;
  private String birthdate;
  private String dateReg;
  private String tel;
  private String country;
  private String region;
  private Long ambCount;
  private Long statCount;
  private String sex;
  private String docSeria;
  private String docNum;

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

  public String getDateReg() {
    return dateReg;
  }

  public void setDateReg(String dateReg) {
    this.dateReg = dateReg;
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

  public Long getAmbCount() {
    return ambCount;
  }

  public void setAmbCount(Long ambCount) {
    this.ambCount = ambCount;
  }

  public Long getStatCount() {
    return statCount;
  }

  public void setStatCount(Long statCount) {
    this.statCount = statCount;
  }

  public String getSex() {
    return sex;
  }

  public void setSex(String sex) {
    this.sex = sex;
  }

  public String getDocSeria() {
    return docSeria;
  }

  public void setDocSeria(String docSeria) {
    this.docSeria = docSeria;
  }

  public String getDocNum() {
    return docNum;
  }

  public void setDocNum(String docNum) {
    this.docNum = docNum;
  }
}
