package ckb.domains.med.lv;

import ckb.domains.GenId;
import ckb.domains.admin.SelOpts;
import ckb.domains.med.patient.Patients;

import javax.persistence.*;
import java.util.Date;

// Доп данные
@Entity
@Table(name = "Lv_Form_6")
public class LvForm6 extends GenId {

  // ID Пациента
  @OneToOne
  @JoinColumn(name = "Patient_Id")
  private Patients patient;
  // Лист нетрудоспобностьи №
  @Column (length = 32)
  private String c1;
  // Продлен с
  @Column
  private Date c2;
  // Продлен по
  @Column
  private Date c3;
  // Умер
  @Column
  private Date c4;
  // Исход болезни
  @OneToOne
  @JoinColumn(name = "c5_id")
  private SelOpts c5;
  // Трудоспособность
  @OneToOne
  @JoinColumn(name = "c6_id")
  private SelOpts c6;
  // Утр. трудоспособности
  @OneToOne
  @JoinColumn(name = "c7_id")
  private SelOpts c7;
  // Вид конфликта
  @OneToOne
  @JoinColumn(name = "c8_id")
  private SelOpts c8;
  // Описание конфликта
  @Column
  private String c9;

  public Patients getPatient() {
    return patient;
  }

  public void setPatient(Patients patient) {
    this.patient = patient;
  }

  public String getC1() {
    return c1;
  }

  public void setC1(String c1) {
    this.c1 = c1;
  }

  public Date getC2() {
    return c2;
  }

  public void setC2(Date c2) {
    this.c2 = c2;
  }

  public Date getC3() {
    return c3;
  }

  public void setC3(Date c3) {
    this.c3 = c3;
  }

  public Date getC4() {
    return c4;
  }

  public void setC4(Date c4) {
    this.c4 = c4;
  }

  public SelOpts getC5() {
    return c5;
  }

  public void setC5(SelOpts c5) {
    this.c5 = c5;
  }

  public SelOpts getC6() {
    return c6;
  }

  public void setC6(SelOpts c6) {
    this.c6 = c6;
  }

  public SelOpts getC7() {
    return c7;
  }

  public void setC7(SelOpts c7) {
    this.c7 = c7;
  }

  public SelOpts getC8() {
    return c8;
  }

  public void setC8(SelOpts c8) {
    this.c8 = c8;
  }

  public String getC9() {
    return c9;
  }

  public void setC9(String c9) {
    this.c9 = c9;
  }
}
