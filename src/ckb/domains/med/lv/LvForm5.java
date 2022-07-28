package ckb.domains.med.lv;

import ckb.domains.GenId;
import ckb.domains.med.patient.Patients;

import javax.persistence.*;
import java.util.Date;

// Протокол операции
@Entity
@Table(name = "Lv_Form_5")
public class LvForm5 extends GenId {

  // ID Пациента
  @OneToOne
  @JoinColumn(name = "Patient_Id")
  private Patients patient;
  // Протокол операции
  @Column(length = 512)
  private String c1;
  // Наименование операции
  @Column(length = 512)
  private String c2;
  // Дата операции
  @Column
  private Date operDate;
  // Операция
  @Column
  private String c3;
  // Ход операции
  @Column
  private String c4;

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

  public Date getOperDate() {return operDate;}

  public void setOperDate(Date operDate) {this.operDate = operDate;}
}
