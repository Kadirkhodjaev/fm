package ckb.domains.med.lv;

import ckb.domains.GenId;
import ckb.domains.admin.Kdos;
import ckb.domains.med.patient.Patients;

import javax.persistence.*;

@Entity
@Table(name = "Kdo_Choosens")
public class KdoChoosens extends GenId {

  @OneToOne @JoinColumn(name = "kdo_id") private Kdos kdo;
  @Column private String name;
  @Column private String colName;
  @Column private Integer ord;
  @Column private Double price;
  @Column private Double for_price;
  @Column private Double real_price;
  @Column private Double for_real_price;

  public Kdos getKdo() {
    return kdo;
  }

  public void setKdo(Kdos kdo) {
    this.kdo = kdo;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getColName() {
    return colName;
  }

  public void setColName(String colName) {
    this.colName = colName;
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

  public double getStatusPrice(Patients patient) {
    return patient.isResident() ? getPrice() : getFor_price();
  }

  public double getStatusRealPrice(Patients patient) {
    return patient.isResident() ? getReal_price() : getFor_real_price();
  }
}
