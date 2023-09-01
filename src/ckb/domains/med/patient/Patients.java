package ckb.domains.med.patient;

import ckb.domains.GenId;
import ckb.domains.admin.*;
import ckb.domains.med.dicts.Rooms;
import ckb.utils.Util;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Patients")
public class Patients extends GenId {
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
  // Дата рождения
  @Column
  private Date birthday;
  // Должность
  @Column(length = 512)
  private String post;
  // Телефон
  @Column(length = 512)
  private String tel;
  // Место работы
  @Column(length = 512)
  private String work;
  // Адрес
  @Column(length = 128)
  private String passportInfo;
  // Страна
  @Column
  private Integer counteryId;
  // Область
  @Column
  private Integer regionId;
  // Адрес
  @Column(length = 512)
  private String address;
  // Пол
  @OneToOne
  @JoinColumn(name="Sex_Id")
  private SelOpts sex;
  // Метка
  @OneToOne
  @JoinColumn(name="Metka_Id")
  private SelOpts metka;
  // Категория
  @OneToOne
  @JoinColumn(name="Cat_Id")
  private SelOpts cat;
  // Терианхоз (Беседа)
  @Column
  private String tarDate;
  // Температура
  @Column(length = 32)
  private String temp;
  // Рост
  @Column(length = 32)
  private String rost;
  // Вес
  @Column(length = 32)
  private String ves;
  // Номер амб. карты
  @Column(length = 32)
  private String ambNum;
  // Питание
  @OneToOne
  @JoinColumn(name="Pitanie_Id")
  private SelOpts pitanie;
  // Тип льготы
  @OneToOne
  @JoinColumn(name="Lgota_Type_Id")
  private SelOpts lgotaType;
  // Пациент направлен
  @OneToOne
  @JoinColumn(name="Redirect_Id")
  private SelOpts redirect;
  // Вид перевозки пациента
  @OneToOne
  @JoinColumn(name="Vid_Per_Id")
  private SelOpts vidPer;
  // Диагноз направительного учреждения
  @Column(length = 512)
  private String diagnoz;
  // Лечащий врач
  @Column(name="lv_id")
  private Integer lv_id;
  // Департамент леч врача
  @Column(name="lv_dept_id")
  private Integer lv_dept_id;
  // Состояние пациента
  @Column(length = 32)
  private String state = "PRN";
  // Дата поступления
  @Column(name = "Date_Begin")
  private Date dateBegin;
  // Дата выписки
  @Column(name = "Date_End")
  private Date dateEnd;
  // Отделение
  @OneToOne
  @JoinColumn(name="Dept_Id")
  private Depts dept;
  // № палаты
  @Column(name = "Palata")
  private String palata;
  // № палаты
  @OneToOne
  @JoinColumn(name = "Room_Id")
  private Rooms room;
  // Для генерации номер истории болезни используется два поля: Номер истории болезни/Номер отделений
  // Порядковый номер истории болезни в клинике за этот год
  private Integer yearNum;
  // Порядковый номер пациента в отделений за этот год
  private Integer otdNum;
  // Дата(Диагноз)
  @Column(name = "Diagnoz_Date")
  private Date diagnosDate;
  // Дата переводного эпикриза
  @Column(name = "Start_Epic_Date")
  private Date startEpicDate;
  // Диагноз при поступлении
  @Column(name = "Start_Diagnoz", length = 512)
  private String startDiagnoz;
  // Сопутствующие болезни
  @Column(name = "Sopust_Bolezn", length = 512)
  private String sopustDBolez;
  // Осложнение
  @Column(name = "Oslojn", length = 512)
  private String oslojn;
  // No1
  @Column(name = "No1", length = 64)
  private String no1;
  // No2
  @Column(name = "No2", length = 64)
  private String no2;
  // No3
  @Column(name = "No3", length = 64)
  private String no3;
  // No4
  @Column(name = "No4", length = 64)
  private String no4;
  // Жалобы
  @Column(length = 2048)
  private String jaloby;
  // Анамнез
  @Column(length = 2048)
  private String anamnez;
  // Общее состояние
  @Column(length = 256)
  private String c1;
  // Сознание
  @Column(length = 256)
  private String c2;
  // Положение
  @Column(length = 256)
  private String c3;
  // Телосложение
  @Column(length = 256)
  private String c4;
  // Клечатка
  @Column(length = 256)
  private String c5;
  // Костно-мышечная сис.
  @Column(length = 256)
  private String c6;
  // Суставы
  @Column(length = 256)
  private String c7;
  // Лимфатические узлы
  @Column(length = 256)
  private String c8;
  // Грудная клетка
  @Column(length = 256)
  private String c9;
  // Число дыхания
  @Column(length = 256)
  private String c10;
  // Перкуссия грудной клетки
  @Column(length = 256)
  private String c11;
  // Аускультация легких
  @Column(length = 256)
  private String c12;
  // Осмотр сердечной области
  @Column(length = 256)
  private String c13;
  // Правая
  @Column(length = 256)
  private String c14;
  // Левая
  @Column(length = 256)
  private String c15;
  // Верхняя
  @Column(length = 256)
  private String c16;
  // Аускультация сердца
  @Column(length = 256)
  private String c17;
  // на аорте
  @Column(length = 256)
  private String c18;
  // на легочной артерии
  @Column(length = 256)
  private String c19;
  // Пульс: Частота
  @Column(length = 256)
  private String c20;
  // ритм
  @Column(length = 256)
  private String c21;
  // наполнение
  @Column(length = 256)
  private String c22;
  // напряжение
  @Column(length = 256)
  private String c23;
  // дефицит пульса
  @Column(length = 256)
  private String c24;
  // Артериальное давление
  @Column(length = 256)
  private String c25;
  // Язык
  @Column(length = 256)
  private String c26;
  // Живот
  @Column(length = 256)
  private String c27;
  // Печень
  @Column(length = 256)
  private String c28;
  // Селезенка
  @Column(length = 256)
  private String c29;
  // Стул
  @Column(length = 256)
  private String c30;
  // Мочеиспускание
  @Column(length = 256)
  private String c31;
  // Боли в области почек
  @Column(length = 256)
  private String c32;
  // Симптом Пастернацкого
  @Column(length = 256)
  private String c33;
  // Периферические отеки
  @Column(length = 256)
  private String c34;
  // Время поступления
  @Column(length = 256)
  private String c35;
  // Кожные покровы
  @Column(length = 256)
  private String c36;
  // Шумы в сердца
  @Column(length = 256)
  private String c37;

  // Питание - Код диеты
  @Column(name = "Diet_1")
  private String diet1;

  // Питание - Код диеты
  @Column(name = "Diet_2")
  private String diet2;

  // Время
  @Column(name = "intime")
  private String time;

  @OneToOne
  @JoinColumn(name="bloodGroup")
  private SelOpts bloodGroup;

  @Column(name="resus")
  private String resus;

  @Column(name="drugEffect")
  private String drugEffect;

  @Column(name="orientedBy")
  private String orientedBy;

  @Column(name="transport")
  private String transport;

  @Column(name="day_count")
  private Integer dayCount;

  @Column(name = "pay_type")
  private SelOpts pay_type;

  @OneToOne @JoinColumn private Users zavlv;

  @Column private String paid = "N";
  @Column private String contractNum;

  @Column private String mkb;
  @Column private Double price;
  @Column private Double dis_perc = 0D;

  // Флаг физиотерапий: если правда то назначено, не правда то не назначена
  @Column private boolean fizio = false;
  @OneToOne @JoinColumn private LvPartners lvpartner;

  @Column(name="mkb_id")
  private Integer mkb_id;

  @OneToOne @JoinColumn private Clients client;

  public Clients getClient() {
    return client;
  }

  public void setClient(Clients client) {
    this.client = client;
  }

  public Integer getMkb_id() {
    return mkb_id;
  }

  public void setMkb_id(Integer mkb_id) {
    this.mkb_id = mkb_id;
  }

  public boolean getFizio() {
    return fizio;
  }

  public void setFizio(boolean fizio) {
    this.fizio = fizio;
  }

  public Integer getYearNum() {
    return yearNum;
  }

  public void setYearNum(Integer yearNum) {
    this.yearNum = yearNum;
  }

  public Integer getOtdNum() {
    return otdNum;
  }

  public void setOtdNum(Integer otdNum) {
    this.otdNum = otdNum;
  }

  public Date getDateBegin() {
    return dateBegin;
  }

  public void setDateBegin(Date dateBegin) {
    this.dateBegin = dateBegin;
  }

  public Date getDateEnd() {
    return dateEnd;
  }

  public void setDateEnd(Date dateEnd) {
    this.dateEnd = dateEnd;
  }

  public Depts getDept() {
    return dept;
  }

  public void setDept(Depts dept) {
    this.dept = dept;
  }

  public String getPalata() {
    return palata;
  }

  public void setPalata(String palata) {
    this.palata = palata;
  }

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
  }

  public Integer getLv_id() {
    return lv_id;
  }

  public void setLv_id(Integer lv_id) {
    this.lv_id = lv_id;
  }

  public String getPassportInfo() {
    return passportInfo;
  }

  public void setPassportInfo(String passportInfo) {
    this.passportInfo = passportInfo;
  }

  public SelOpts getLgotaType() {
    return lgotaType;
  }

  public void setLgotaType(SelOpts lgotaType) {
    this.lgotaType = lgotaType;
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

  public String getPost() {
    return post;
  }

  public void setPost(String post) {
    this.post = post;
  }

  public String getTel() {
    return tel;
  }

  public void setTel(String tel) {
    this.tel = tel;
  }

  public Date getStartEpicDate() {
    return startEpicDate;
  }

  public void setStartEpicDate(Date startEpicDate) {
    this.startEpicDate = startEpicDate;
  }

  public String getWork() {
    return work;
  }

  public void setWork(String work) {
    this.work = work;
  }

  public String getAddress() {
    return address;
  }

  public void setAddress(String address) {
    this.address = address;
  }

  public SelOpts getSex() {
    return sex;
  }

  public void setSex(SelOpts sex) {
    this.sex = sex;
  }

  public SelOpts getMetka() {
    return metka;
  }

  public void setMetka(SelOpts metka) {
    this.metka = metka;
  }

  public SelOpts getCat() {
    return cat;
  }

  public void setCat(SelOpts cat) {
    this.cat = cat;
  }

  public String getTarDate() {
    return tarDate;
  }

  public void setTarDate(String tarDate) {
    this.tarDate = tarDate;
  }

  public String getTemp() {
    return temp;
  }

  public void setTemp(String temp) {
    this.temp = temp;
  }

  public String getRost() {
    return rost;
  }

  public void setRost(String rost) {
    this.rost = rost;
  }

  public String getVes() {
    return ves;
  }

  public void setVes(String ves) {
    this.ves = ves;
  }

  public String getAmbNum() {
    return ambNum;
  }

  public void setAmbNum(String ambNum) {
    this.ambNum = ambNum;
  }

  public SelOpts getPitanie() {
    return pitanie;
  }

  public void setPitanie(SelOpts pitanie) {
    this.pitanie = pitanie;
  }

  public SelOpts getRedirect() {
    return redirect;
  }

  public void setRedirect(SelOpts redirect) {
    this.redirect = redirect;
  }

  public SelOpts getVidPer() {
    return vidPer;
  }

  public void setVidPer(SelOpts vidPer) {
    this.vidPer = vidPer;
  }

  public String getDiagnoz() {
    return diagnoz;
  }

  public void setDiagnoz(String diagnoz) {
    this.diagnoz = diagnoz;
  }

  public Date getDiagnosDate() {
    return diagnosDate;
  }

  public void setDiagnosDate(Date diagnosDate) {
    this.diagnosDate = diagnosDate;
  }

  public String getStartDiagnoz() {
    return startDiagnoz;
  }

  public void setStartDiagnoz(String startDiagnoz) {
    this.startDiagnoz = startDiagnoz;
  }

  public String getSopustDBolez() {
    return sopustDBolez;
  }

  public void setSopustDBolez(String sopustDBolez) {
    this.sopustDBolez = sopustDBolez;
  }

  public String getOslojn() {
    return oslojn;
  }

  public void setOslojn(String oslojn) {
    this.oslojn = oslojn;
  }

  public String getNo1() {
    return no1;
  }

  public void setNo1(String no1) {
    this.no1 = no1;
  }

  public String getNo2() {
    return no2;
  }

  public void setNo2(String no2) {
    this.no2 = no2;
  }

  public String getNo3() {
    return no3;
  }

  public void setNo3(String no3) {
    this.no3 = no3;
  }

  public String getNo4() {
    return no4;
  }

  public void setNo4(String no4) {
    this.no4 = no4;
  }

  public String getJaloby() {return jaloby;}

  public void setJaloby(String jaloby) {this.jaloby = jaloby;}

  public String getAnamnez() {return anamnez;}

  public void setAnamnez(String anamnez) {this.anamnez = anamnez;}

  public String getC1() {return c1;}

  public void setC1(String c1) {this.c1 = c1;}

  public String getC2() {return c2;}

  public void setC2(String c2) {this.c2 = c2;}

  public String getC3() {return c3;}

  public void setC3(String c3) {this.c3 = c3;}

  public String getC4() {return c4;}

  public void setC4(String c4) {this.c4 = c4;}

  public String getC5() {return c5;}

  public void setC5(String c5) {this.c5 = c5;}

  public String getC6() {return c6;}

  public void setC6(String c6) {this.c6 = c6;}

  public String getC7() {return c7;}

  public void setC7(String c7) {this.c7 = c7;}

  public String getC8() {return c8;}

  public void setC8(String c8) {this.c8 = c8;}

  public String getC9() {return c9;}

  public void setC9(String c9) {this.c9 = c9;}

  public String getC10() {return c10;}

  public void setC10(String c10) {this.c10 = c10;}

  public String getC11() {return c11;}

  public void setC11(String c11) {this.c11 = c11;}

  public String getC12() {return c12;}

  public void setC12(String c12) {this.c12 = c12;}

  public String getC13() {return c13;}

  public void setC13(String c13) {this.c13 = c13;}

  public String getC14() {return c14;}

  public void setC14(String c14) {this.c14 = c14;}

  public String getC15() {return c15;}

  public void setC15(String c15) {this.c15 = c15;}

  public String getC16() {return c16;}

  public void setC16(String c16) {this.c16 = c16;}

  public String getC17() {return c17;}

  public void setC17(String c17) {this.c17 = c17;}

  public String getC18() {return c18;}

  public void setC18(String c18) {this.c18 = c18;}

  public String getC19() {return c19;}

  public void setC19(String c19) {this.c19 = c19;}

  public String getC20() {return c20;}

  public void setC20(String c20) {this.c20 = c20;}

  public String getC21() {return c21;}

  public void setC21(String c21) {this.c21 = c21;}

  public String getC22() {return c22;}

  public void setC22(String c22) {this.c22 = c22;}

  public String getC23() {return c23;}

  public void setC23(String c23) {this.c23 = c23;}

  public String getC24() {return c24;}

  public void setC24(String c24) {this.c24 = c24;}

  public String getC25() {return c25;}

  public void setC25(String c25) {this.c25 = c25;}

  public String getC26() {return c26;}

  public void setC26(String c26) {this.c26 = c26;}

  public String getC27() {return c27;}

  public void setC27(String c27) {this.c27 = c27;}

  public String getC28() {return c28;}

  public void setC28(String c28) {this.c28 = c28;}

  public String getC29() {return c29;}

  public void setC29(String c29) {this.c29 = c29;}

  public String getC30() {return c30;}

  public void setC30(String c30) {this.c30 = c30;}

  public String getC31() {return c31;}

  public void setC31(String c31) {this.c31 = c31;}

  public String getC32() {return c32;}

  public void setC32(String c32) {this.c32 = c32;}

  public String getC33() {return c33;}

  public void setC33(String c33) {this.c33 = c33;}

  public String getC34() {return c34;}

  public void setC34(String c34) {this.c34 = c34;}

  public String getC35() {return c35;}

  public void setC35(String c35) {this.c35 = c35;}

  public String getDiet1() {return diet1;}

  public void setDiet1(String diet1) {this.diet1 = diet1;}

  public String getDiet2() {return diet2;}

  public void setDiet2(String diet2) {this.diet2 = diet2;}

  public String getTime() {
    return time;
  }

  public void setTime(String time) {
    this.time = time;
  }

  public Integer getLv_dept_id() {
    return lv_dept_id;
  }

  public void setLv_dept_id(Integer lv_dept_id) {
    this.lv_dept_id = lv_dept_id;
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

  public SelOpts getBloodGroup() {
    return bloodGroup;
  }

  public void setBloodGroup(SelOpts bloodGroup) {
    this.bloodGroup = bloodGroup;
  }

  public String getResus() {
    return resus;
  }

  public void setResus(String resus) {
    this.resus = resus;
  }

  public String getDrugEffect() {
    return drugEffect;
  }

  public void setDrugEffect(String drugEffect) {
    this.drugEffect = drugEffect;
  }

  public String getOrientedBy() {
    return orientedBy;
  }

  public void setOrientedBy(String orientedBy) {
    this.orientedBy = orientedBy;
  }

  public String getTransport() {
    return transport;
  }

  public void setTransport(String transport) {
    this.transport = transport;
  }

  public String getDate_Begin(){
    return Util.dateToString(dateBegin);
  }

  public String getDate_End(){
    return Util.dateToString(dateEnd);
  }

  public String getDiagnoz_Date(){
    return Util.dateToString(diagnosDate);
  }

  public String getC36() {
    return c36;
  }

  public void setC36(String c36) {
    this.c36 = c36;
  }

  public String getC37() {
    return c37;
  }

  public Rooms getRoom() {
    return room;
  }

  public void setRoom(Rooms room) {
    this.room = room;
  }

  public void setC37(String c37) {
    this.c37 = c37;
  }

  public Integer getDayCount() {
    return dayCount;
  }

  public void setDayCount(Integer dayCount) {
    this.dayCount = dayCount;
  }

  public SelOpts getPay_type() {
    return pay_type;
  }

  public void setPay_type(SelOpts pay_type) {
    this.pay_type = pay_type;
  }

  public String getPaid() {
    return paid;
  }

  public void setPaid(String paid) {
    this.paid = paid;
  }

  public boolean isFizio() {
    return fizio;
  }

  public String getMkb() {
    return mkb;
  }

  public void setMkb(String mkb) {
    this.mkb = mkb;
  }

  public Double getPrice() {
    return price;
  }

  public void setPrice(Double price) {
    this.price = price;
  }

  public Users getZavlv() {
    return zavlv;
  }

  public void setZavlv(Users zavlv) {
    this.zavlv = zavlv;
  }

  public String getContractNum() {
    return contractNum;
  }

  public void setContractNum(String contractNum) {
    this.contractNum = contractNum;
  }

  public Date getBirthday() {
    return birthday;
  }

  public void setBirthday(Date birthday) {
    this.birthday = birthday;
  }

  public String getBirthdayString() {
    return Util.dateToString(this.birthday);
  }

  public Double getDis_perc() {
    return dis_perc;
  }

  public void setDis_perc(Double dis_perc) {
    this.dis_perc = dis_perc;
  }

  public LvPartners getLvpartner() {
    return lvpartner;
  }

  public void setLvpartner(LvPartners lvpartner) {
    this.lvpartner = lvpartner;
  }

  public String getFio() {
    return this.surname + " " + this.name + " " + this.middlename;
  }
}
