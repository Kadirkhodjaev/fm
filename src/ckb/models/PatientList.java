package ckb.models;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 30.08.15
 * Time: 20:09
 * To change this template use File | Settings | File Templates.
 */
public class PatientList {
  // Ид пациента
  private int id;
  // Флаг видимости чекбокса
  private boolean showCheckbox;
  // Url иконки пациента
  private String iconUrl;
  // ФИО
  private String fio;
  // Год рождения
  private String birthYear;
  // Дата регистрации
  private String dateBegin;
  // Дата выписки
  private String dateEnd;
  // Номер истории болезни
  private String ibNum;
  // Отделения / Палата
  private String otdPal;
  // Категория
  private String cat;
  // Метка
  private String metka;
  // Леч врач
  private String lv;
  // Состояние опалаты
  private String paid;

  public int getId() {
    return id;
  }

  public void setId(int id) {
    this.id = id;
  }

  public boolean isShowCheckbox() {
    return showCheckbox;
  }

  public void setShowCheckbox(boolean showCheckbox) {
    this.showCheckbox = showCheckbox;
  }

  public String getIconUrl() {
    return iconUrl;
  }

  public void setIconUrl(String iconUrl) {
    this.iconUrl = iconUrl;
  }

  public String getFio() {
    return fio;
  }

  public void setFio(String fio) {
    this.fio = fio;
  }

  public String getBirthYear() {
    return birthYear;
  }

  public void setBirthYear(String birthYear) {
    this.birthYear = birthYear;
  }

  public String getDateBegin() {
    return dateBegin;
  }

  public void setDateBegin(String dateBegin) {
    this.dateBegin = dateBegin;
  }

  public String getIbNum() {
    return ibNum;
  }

  public void setIbNum(String ibNum) {
    this.ibNum = ibNum;
  }

  public String getOtdPal() {
    return otdPal;
  }

  public void setOtdPal(String otdPal) {
    this.otdPal = otdPal;
  }

  public String getCat() {
    return cat;
  }

  public void setCat(String cat) {
    this.cat = cat;
  }

  public String getMetka() {
    return metka;
  }

  public void setMetka(String metka) {
    this.metka = metka;
  }

  public String getLv() {
    return lv;
  }

  public void setLv(String lv) {
    this.lv = lv;
  }

  public String getDateEnd() {
    return dateEnd;
  }

  public void setDateEnd(String dateEnd) {
    this.dateEnd = dateEnd;
  }

  public String getPaid() {
    return paid;
  }

  public void setPaid(String paid) {
    this.paid = paid;
  }
}
