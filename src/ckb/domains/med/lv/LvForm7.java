package ckb.domains.med.lv;

import ckb.domains.GenId;
import ckb.domains.med.patient.Patients;

import javax.persistence.*;

// Предоперационный эпикрез
@Entity
@Table(name = "Lv_Form_7")
public class LvForm7 extends GenId {

  // ID Пациента
  @OneToOne
  @JoinColumn(name = "Patient_Id", unique = true)
  private Patients patient;
  // На основании жалоб
  @Column
  private String c1;
  // На основании анамнеза
  @Column
  private String c2;
  // На основании клиники
  @Column
  private String c3;
  // На основании обследования
  @Column
  private String c4;
  // Диагноз
  @Column
  private String c5;

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

}
