package ckb.domains.med.lv;

import ckb.domains.GenId;
import ckb.domains.med.patient.Patients;
import ckb.utils.Util;

import javax.persistence.*;

// Осмотр леч врача
@Entity
@Table(name = "Lv_Form_1")
public class LvForm1 extends GenId {

  // ID Пациента
  @OneToOne
  @JoinColumn(name = "Patient_Id", unique = true)
  private Patients patient;
  // Жалобы при поступлении
  @Column
  private String c1;
  // Из анамнеза
  @Column
  private String c2;
  // Состояние при поступлении
  @Column
  private String c3;
  // Обследование до стационарного лечения
  @Column
  private String c4;
  // Предворительный диагноз
  @Column
  private String c5;
  // Обоснование препоратов
  @Column
  private String c6;
  // Дата документа
  @Column
  private String c7;
  // Anamnez vitae
  @Column
  private String c8;
  // Нафас олиш системаси
  @Column
  private String c9;
  // ?он айланиш системаси
  @Column
  private String c10;
  // Хазм ?илиш cистемаси
  @Column
  private String c11;
  // Сийдик-таносил системаси
  @Column
  private String c12;
  // Нерв системаси
  @Column
  private String c13;
  // Эндокрин системаси
  @Column
  private String c14;
  // ?ал?онсимон без
  @Column
  private String c15;
  // Меьда ости бези
  @Column
  private String c16;
  // keremas polya
  @Column
  private String c17;
  // Тахминий ташхис: Hamroh
  @Column
  private String c18;
  // Тахминий ташхис: Asorati
  @Column
  private String c19;
  //
  @Column private String mkb;

  public Patients getPatient() {return patient;}

  public void setPatient(Patients patient) {this.patient = patient;}

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

  public String getC6() {
    return c6;
  }

  public void setC6(String c6) {
    this.c6 = c6;
  }

  public String getC7() {
    return c7;
  }

  public void setC7(String c7) {
    this.c7 = c7;
  }

  public String getC8() {
    return c8;
  }

  public void setC8(String c8) {
    this.c8 = c8;
  }

  public String getC9() {
    return c9;
  }

  public void setC9(String c9) {
    this.c9 = c9;
  }

  public String getC10() {
    return c10;
  }

  public void setC10(String c10) {
    this.c10 = c10;
  }

  public String getC11() {
    return c11;
  }

  public void setC11(String c11) {
    this.c11 = c11;
  }

  public String getC12() {
    return c12;
  }

  public void setC12(String c12) {
    this.c12 = c12;
  }

  public String getC13() {
    return c13;
  }

  public void setC13(String c13) {
    this.c13 = c13;
  }

  public String getC14() {
    return c14;
  }

  public void setC14(String c14) {
    this.c14 = c14;
  }

  public String getC15() {
    return c15;
  }

  public void setC15(String c15) {
    this.c15 = c15;
  }

  public String getC16() {
    return c16;
  }

  public void setC16(String c16) {
    this.c16 = c16;
  }

  public String getC17() {
    return Util.nvl(c17);
  }

  public void setC17(String c17) {
    this.c17 = c17;
  }

  public String getC18() {
    return c18;
  }

  public void setC18(String c18) {
    this.c18 = c18;
  }

  public String getC19() {
    return c19;
  }

  public void setC19(String c19) {
    this.c19 = c19;
  }

  public String getMkb() {
    return mkb;
  }

  public void setMkb(String mkb) {
    this.mkb = mkb;
  }
}
