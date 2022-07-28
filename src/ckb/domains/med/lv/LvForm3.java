package ckb.domains.med.lv;

import ckb.domains.GenId;
import ckb.domains.med.patient.Patients;

import javax.persistence.*;

// Совместный осмотр
@Entity
@Table(name = "Lv_Form_3")
public class LvForm3 extends GenId {

  // ID Пациента
  @OneToOne
  @JoinColumn(name = "Patient_Id")
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
  // Обследование
  @Column
  private String c4;
  @Column
  private String c5;
  // Рекомендовано
  @Column
  private String c6;

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

  public String getC6() {return c6;}

  public void setC6(String c6) {this.c6 = c6;}
}
