package ckb.domains.med.amb;

import ckb.domains.GenId;
import ckb.domains.admin.Clients;
import ckb.domains.admin.LvPartners;
import ckb.domains.admin.SelOpts;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Amb_Patients")
public class AmbPatients extends GenId {

  // Фамилия
  @Column(nullable = false, length = 128)
  private String surname;
  // Имя
  @Column(nullable = false, length = 128)
  private String name;
  // Отчество
  @Column(length = 128)
  private String middlename;
  // Год рождения
  @Column
  private Integer birthyear;
  // Телефон
  @Column(length = 512)
  private String tel;
  // Адрес
  @Column(length = 512)
  private String address;

  // Дата выписки
  @Column(name = "Reg_Date")
  private Date regDate;
  // Состояние
  @Column(name = "state")
  private String state;

  // Адрес
  @Column(length = 128)
  private String passportInfo;
  // Страна
  @Column
  private Integer counteryId;
  // Область
  @Column
  private Integer regionId;
  // Пол
  @OneToOne
  @JoinColumn(name="sex")
  private SelOpts sex;
  // Физиотерпия
  @Column private String fizio = "N";
  @Column private Integer fizioSetUser;

  @Column private String tgNumber;
  @Column private String qrcode;

  @Column(nullable = false) private Double cash = 0D;
  @Column(nullable = false) private Double card = 0D;
  @Column(nullable = false) private Double transfer = 0D;

  @OneToOne @JoinColumn private LvPartners lvpartner;
  @OneToOne @JoinColumn private Clients client;

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

  public Integer getBirthyear() {
    return birthyear;
  }

  public void setBirthyear(Integer birthyear) {
    this.birthyear = birthyear;
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

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
  }

  public String getPassportInfo() {
    return passportInfo;
  }

  public void setPassportInfo(String passportInfo) {
    this.passportInfo = passportInfo;
  }

  public Integer getCounteryId() {
    return counteryId;
  }

  public void setCounteryId(Integer counteryId) {
    this.counteryId = counteryId;
  }

  public Integer getRegionId() {
    return regionId;
  }

  public void setRegionId(Integer regionId) {
    this.regionId = regionId;
  }

  public SelOpts getSex() {
    return sex;
  }

  public void setSex(SelOpts sex) {
    this.sex = sex;
  }

  public Double getCash() {
    return cash;
  }

  public void setCash(Double cash) {
    this.cash = cash;
  }

  public Double getCard() {
    return card;
  }

  public void setCard(Double card) {
    this.card = card;
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

  public String getFizio() {
    return fizio;
  }

  public void setFizio(String fizio) {
    this.fizio = fizio;
  }

  public Integer getFizioSetUser() {
    return fizioSetUser;
  }

  public void setFizioSetUser(Integer fizioSetUser) {
    this.fizioSetUser = fizioSetUser;
  }

  public Double getTransfer() {
    return transfer;
  }

  public void setTransfer(Double transfer) {
    this.transfer = transfer;
  }

  public String getTgNumber() {
    return tgNumber;
  }

  public void setTgNumber(String tgNumber) {
    this.tgNumber = tgNumber;
  }

  public LvPartners getLvpartner() {
    return lvpartner;
  }

  public void setLvpartner(LvPartners lvpartner) {
    this.lvpartner = lvpartner;
  }

  public String getQrcode() {
    return qrcode;
  }

  public void setQrcode(String qrcode) {
    this.qrcode = qrcode;
  }
}
