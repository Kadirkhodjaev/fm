package ckb.domains.admin;

import ckb.domains.GenId;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Crm_Clients")
public class Clients extends GenId {
  // ���
  @Column(nullable = false, length = 128) private String surname;
  @Column(nullable = false, length = 128) private String name;
  @Column(length = 128) private String middlename;

  // ��� ��������
  @Column private Integer birthyear;
  // ���� ��������
  @Column private Date birthdate;
  // �������
  @Column(length = 512) private String tel;
  // �����
  @Column(length = 512) private String address;
  // ���������
  @Column(name = "state") private String state;
  // ����
  @Column(length = 32) private String rost;

  // ��������
  @Column(length = 16) private String docSeria;
  @Column(length = 32) private String docNum;
  @Column(length = 256) private String docInfo;

  // ������
  @OneToOne @JoinColumn private Counteries country;
  // �������
  @OneToOne @JoinColumn private Regions region;
  // ���
  @OneToOne @JoinColumn private SelOpts sex;

  @OneToOne @JoinColumn private Users crBy;
  @Column private Date crOn;

  public String getSurname() {
    return surname;
  }

  public void setSurname(String surname) {
    this.surname = surname;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getMiddlename() {
    return middlename;
  }

  public void setMiddlename(String middlename) {
    this.middlename = middlename;
  }

  public Integer getBirthyear() {
    return birthyear;
  }

  public void setBirthyear(Integer birthyear) {
    this.birthyear = birthyear;
  }

  public Date getBirthdate() {
    return birthdate;
  }

  public void setBirthdate(Date birthdate) {
    this.birthdate = birthdate;
  }

  public String getTel() {
    return tel;
  }

  public void setTel(String tel) {
    this.tel = tel;
  }

  public String getAddress() {
    return address;
  }

  public void setAddress(String address) {
    this.address = address;
  }

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
  }

  public String getRost() {
    return rost;
  }

  public void setRost(String rost) {
    this.rost = rost;
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

  public String getDocInfo() {
    return docInfo;
  }

  public void setDocInfo(String docInfo) {
    this.docInfo = docInfo;
  }

  public Counteries getCountry() {
    return country;
  }

  public void setCountry(Counteries country) {
    this.country = country;
  }

  public Regions getRegion() {
    return region;
  }

  public void setRegion(Regions region) {
    this.region = region;
  }

  public SelOpts getSex() {
    return sex;
  }

  public void setSex(SelOpts sex) {
    this.sex = sex;
  }

  public Users getCrBy() {
    return crBy;
  }

  public void setCrBy(Users crBy) {
    this.crBy = crBy;
  }

  public Date getCrOn() {
    return crOn;
  }

  public void setCrOn(Date crOn) {
    this.crOn = crOn;
  }

  public String getFio() {
    return surname + " " + name + " " + middlename;
  }
}
