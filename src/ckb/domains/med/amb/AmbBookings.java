package ckb.domains.med.amb;

import ckb.domains.GenId;
import ckb.domains.admin.Clients;
import ckb.domains.admin.Counteries;
import ckb.domains.admin.Regions;
import ckb.domains.admin.SelOpts;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Amb_Bookings")
public class AmbBookings extends GenId {

  @OneToOne @JoinColumn private Clients client;
  @Column(nullable = false, length = 128) private String surname;
  @Column(nullable = false, length = 128) private String name;
  @Column(length = 128) private String middlename;
  @Column private Date birthday;
  @Column(length = 512) private String tel;
  @Column(length = 512) private String address;
  @Column(length = 128) private String passportInfo;
  @OneToOne @JoinColumn private Counteries country;
  @OneToOne @JoinColumn private Regions region;
  @OneToOne @JoinColumn(name="sex") private SelOpts sex;

  @Column(name = "state") private String state;
  @Column(name = "Reg_Date") private Date regDate;

  @Column private Integer crBy;
  @Column private Date crOn;

  public Clients getClient() {
    return client;
  }

  public void setClient(Clients client) {
    this.client = client;
  }

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

  public Date getRegDate() {
    return regDate;
  }

  public void setRegDate(Date regDate) {
    this.regDate = regDate;
  }

  public Date getBirthday() {
    return birthday;
  }

  public void setBirthday(Date birthday) {
    this.birthday = birthday;
  }

  public String getPassportInfo() {
    return passportInfo;
  }

  public void setPassportInfo(String passportInfo) {
    this.passportInfo = passportInfo;
  }

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
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

  public Integer getCrBy() {
    return crBy;
  }

  public void setCrBy(Integer crBy) {
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
