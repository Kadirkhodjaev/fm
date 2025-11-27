package ckb.domains.admin;

import ckb.domains.GenId;
import ckb.domains.med.patient.Patients;

import javax.persistence.*;
import java.util.Date;


@Entity
@Table(name = "Kdos")
public class Kdos extends GenId {

  // Наименование
  @Column private String name;
  // Наименование
  @Column private String shortName;
  // Наименование
  @Column private int formId;
  // Тип диагностики
  @OneToOne @JoinColumn(name = "Kdo_Type")
  private KdoTypes kdoType;
  // Наименование
  @Column private String state;
  // Размер страницы
  @Column private String cssWidth;

  @Column private String template;
  @Column private Integer ord = 0;
  @Column private Double price;
  @Column private Double for_price;
  @Column private Double bonusProc;
  @Column private String priced;
  @Column private String necKdo = "N";
  @Column private String out_service = "N";
  @Column private String norma;
  @Column private String ei;
  @Column private Double real_price;
  @Column private Double for_real_price;
  @Column private String room;
  @Column private String fizei;
  @Column private Integer minTime = 0;
  @Column private Integer maxTime = 0;

  @Column private Date saleStart;
  @Column private Date saleEnd;
  @Column private Double saleProc;

  public int getFormId() {return formId;}

  public void setFormId(int formId) {this.formId = formId;}

  public String getCssWidth() {return cssWidth;}

  public void setCssWidth(String cssWidth) {this.cssWidth = cssWidth;}

  public String getState() {return state;}

  public void setState(String state) {this.state = state;}

  public String getShortName() {return shortName;}

  public void setShortName(String shortName) {this.shortName = shortName;}

  public String getName() {return name;}

  public void setName(String name) {this.name = name;}

  public KdoTypes getKdoType() {return kdoType;}

  public void setKdoType(KdoTypes kdoType) {this.kdoType = kdoType;}

  public String getTemplate() {
    return template;
  }

  public void setTemplate(String template) {
    this.template = template;
  }

  public Integer getOrd() {
    return ord;
  }

  public void setOrd(Integer ord) {
    this.ord = ord;
  }

  public Double getPrice() {
    return price;
  }

  public void setPrice(Double price) {
    this.price = price;
  }

  public Double getFor_price() {
    return for_price;
  }

  public void setFor_price(Double for_price) {
    this.for_price = for_price;
  }

  public String getPriced() {
    return priced;
  }

  public void setPriced(String priced) {
    this.priced = priced;
  }

  public String getNecKdo() {
    return necKdo;
  }

  public void setNecKdo(String necKdo) {
    this.necKdo = necKdo;
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

  public Double getReal_price() {
    return real_price;
  }

  public void setReal_price(Double real_price) {
    this.real_price = real_price;
  }

  public Double getFor_real_price() {
    return for_real_price;
  }

  public void setFor_real_price(Double for_real_price) {
    this.for_real_price = for_real_price;
  }

  public String getRoom() {
    return room;
  }

  public void setRoom(String room) {
    this.room = room;
  }

  public Integer getMinTime() {
    return minTime;
  }

  public void setMinTime(Integer minTime) {
    this.minTime = minTime;
  }

  public Integer getMaxTime() {
    return maxTime;
  }

  public void setMaxTime(Integer maxTime) {
    this.maxTime = maxTime;
  }

  public String getFizei() {
    return fizei;
  }

  public void setFizei(String fizei) {
    this.fizei = fizei;
  }

  public Double getBonusProc() {
    return bonusProc;
  }

  public void setBonusProc(Double bonusProc) {
    this.bonusProc = bonusProc;
  }

  public double getStatusPrice(Patients patient) {
    return patient.isResident() ? getPrice() : getFor_price();
  }

  public double getStatusRealPrice(Patients patient) {
    return patient.isResident() ? getReal_price() : getFor_real_price();
  }

  public Date getSaleStart() {
    return saleStart;
  }

  public void setSaleStart(Date saleStart) {
    this.saleStart = saleStart;
  }

  public Date getSaleEnd() {
    return saleEnd;
  }

  public void setSaleEnd(Date saleEnd) {
    this.saleEnd = saleEnd;
  }

  public Double getSaleProc() {
    return saleProc;
  }

  public void setSaleProc(Double saleProc) {
    this.saleProc = saleProc;
  }

  public String getOut_service() {
    return out_service;
  }

  public void setOut_service(String out_service) {
    this.out_service = out_service;
  }
}
