package ckb.domains.admin;

import ckb.domains.GenId;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "Forms")
public class Forms extends GenId {

  // Наименование
  @Column(length = 512)
  private String name;

  // Надоли выводит 777 шапку
  @Column
  private boolean shapka;

  // Надоли выводит 777 шапку
  @Column
  private String shapka_right;

  // Надоли выводит 777 шапку
  @Column
  private String shapka_left;

  // Тип формы (1 – Формы КДО, 0 – Остальные формы)
  @Column(length = 1)
  private int type = 1;

  @Column private String amb = "N";
  @Column private String jsp;
  @Column private String eiFlag;
  @Column private String normaFlag;
  @Column private String result;

  public String getNormaFlag() {
    return normaFlag;
  }

  public void setNormaFlag(String normaFlag) {
    this.normaFlag = normaFlag;
  }

  public String getEiFlag() {
    return eiFlag;
  }

  public void setEiFlag(String eiFlag) {
    this.eiFlag = eiFlag;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public int getType() {
    return type;
  }

  public void setType(int type) {
    this.type = type;
  }

  public boolean isShapka() {
    return shapka;
  }

  public void setShapka(boolean shapka) {
    this.shapka = shapka;
  }

  public String getShapka_right() {
    return shapka_right;
  }

  public void setShapka_right(String shapka_right) {
    this.shapka_right = shapka_right;
  }

  public String getShapka_left() {
    return shapka_left;
  }

  public void setShapka_left(String shapka_left) {
    this.shapka_left = shapka_left;
  }

  public String getAmb() {
    return amb;
  }

  public void setAmb(String amb) {
    this.amb = amb;
  }

  public String getJsp() {
    return jsp;
  }

  public void setJsp(String jsp) {
    this.jsp = jsp;
  }

  public String getResult() {
    return result;
  }

  public void setResult(String result) {
    this.result = result;
  }
}
