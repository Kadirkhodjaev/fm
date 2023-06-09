package ckb.domains.med;

import ckb.domains.GenId;
import ckb.domains.admin.*;
import ckb.domains.med.dicts.Rooms;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Room_Bookings")
public class RoomBookings extends GenId {
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
  @Column private Integer birthyear;
  // Телефон
  @Column(length = 512) private String tel;
  // Адрес
  @Column(length = 512) private String passportInfo;
  // Страна
  @OneToOne @JoinColumn(name = "country_id") private Counteries country;
  // Пол
  @OneToOne
  @JoinColumn(name="Sex_Id")
  private SelOpts sex;
  // Лечащий врач
  @OneToOne
  @JoinColumn(name = "lv_id")
  private Users lv;
  // Дата поступления
  @Column(name = "Date_Begin")
  private Date dateBegin;
  // Отделение
  @OneToOne
  @JoinColumn(name="Dept_Id")
  private Depts dept;
  // № палаты
  @OneToOne
  @JoinColumn(name = "Room_Id")
  private Rooms room;

  @OneToOne @JoinColumn private Dicts bron;

  @Column private String state;

  @Column private Integer crBy;
  @Column private Date crOn;

  @Column(name = "history_patient_id") private Integer historyId;

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

  public String getPassportInfo() {
    return passportInfo;
  }

  public void setPassportInfo(String passportInfo) {
    this.passportInfo = passportInfo;
  }

  public SelOpts getSex() {
    return sex;
  }

  public void setSex(SelOpts sex) {
    this.sex = sex;
  }

  public Users getLv() {
    return lv;
  }

  public void setLv(Users lv) {
    this.lv = lv;
  }

  public Depts getDept() {
    return dept;
  }

  public void setDept(Depts dept) {
    this.dept = dept;
  }

  public Date getDateBegin() {
    return dateBegin;
  }

  public void setDateBegin(Date dateBegin) {
    this.dateBegin = dateBegin;
  }

  public Rooms getRoom() {
    return room;
  }

  public void setRoom(Rooms room) {
    this.room = room;
  }

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
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

  public Counteries getCountry() {
    return country;
  }

  public void setCountry(Counteries country) {
    this.country = country;
  }

  public Integer getHistoryId() {
    return historyId;
  }

  public void setHistoryId(Integer historyId) {
    this.historyId = historyId;
  }

  public Dicts getBron() {
    return bron;
  }

  public void setBron(Dicts bron) {
    this.bron = bron;
  }
}
