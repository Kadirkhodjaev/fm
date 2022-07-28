package ckb.domains.med.lv;

import ckb.domains.GenId;
import ckb.domains.med.patient.Patients;

import javax.persistence.*;

// �����������
@Entity
@Table(name = "Lv_Form_2")
public class LvForm2 extends GenId {

  // ID ��������
  @OneToOne
  @JoinColumn(name = "Patient_Id", unique = true)
  private Patients patient;
  // �� ��������� �����
  @Column
  private String c1;
  // �� ��������� ��������
  @Column
  private String c2;
  // �� ��������� �������
  @Column
  private String c3;
  // �� ��������� ������������
  @Column
  private String c4;
  // �������
  @Column
  private String c5;
  // �������: Sopustvuyuwie
  @Column
  private String c6;
  // �������: Asorati
  @Column
  private String c7;
  // ���� ���������
  @Column
  private String c8;

  @Column private Integer mkb_id;
  @Column private String mkb;

  public Integer getMkb_id() {
    return mkb_id;
  }

  public void setMkb_id(Integer mkb_id) {
    this.mkb_id = mkb_id;
  }

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

  public String getMkb() {
    return mkb;
  }

  public void setMkb(String mkb) {
    this.mkb = mkb;
  }
}
