package ckb.domains.med.lv;

import ckb.domains.GenId;
import ckb.domains.med.patient.Patients;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Lv_Docs")
public class LvDocs extends GenId {

  @OneToOne @JoinColumn private Patients patient;
  @Column private String docCode;
  @Column private Date docDate;

  @Column private String mkb;
  @Column private Integer mkb_id;
  @Column private String c1;
  @Column private String c2;
  @Column private String c3;
  @Column private String c4;
  @Column private String c5;
  @Column private String c6;
  @Column private String c7;
  @Column private String c8;
  @Column private String c9;
  @Column private String c10;
  @Column private String c11;
  @Column private String c12;
  @Column private String c13;
  @Column private String c14;
  @Column private String c15;
  @Column private String c16;
  @Column private String c17;
  @Column private String c18;
  @Column private String c19;
  @Column private String c20;
  @Column private String c21;
  @Column private String c22;
  @Column private String c23;
  @Column private String c24;
  @Column private String c25;

  @Column private Date crOn;
  @Column private Integer crBy;

  public Patients getPatient() {
    return patient;
  }

  public void setPatient(Patients patient) {
    this.patient = patient;
  }

  public String getDocCode() {
    return docCode;
  }

  public void setDocCode(String docCode) {
    this.docCode = docCode;
  }

  public Date getDocDate() {
    return docDate;
  }

  public void setDocDate(Date docDate) {
    this.docDate = docDate;
  }

  public String getMkb() {
    return mkb;
  }

  public void setMkb(String mkb) {
    this.mkb = mkb;
  }

  public Integer getMkb_id() {
    return mkb_id;
  }

  public void setMkb_id(Integer mkb_id) {
    this.mkb_id = mkb_id;
  }

  public String getC1() {
    return c1;
  }

  public void setC1(String c1) {
    this.c1 = c1;
  }

  public String getC2() {
    return c2;
  }

  public void setC2(String c2) {
    this.c2 = c2;
  }

  public String getC3() {
    return c3;
  }

  public void setC3(String c3) {
    this.c3 = c3;
  }

  public String getC4() {
    return c4;
  }

  public void setC4(String c4) {
    this.c4 = c4;
  }

  public String getC5() {
    return c5;
  }

  public void setC5(String c5) {
    this.c5 = c5;
  }

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
    return c17;
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

  public String getC20() {
    return c20;
  }

  public void setC20(String c20) {
    this.c20 = c20;
  }

  public String getC21() {
    return c21;
  }

  public void setC21(String c21) {
    this.c21 = c21;
  }

  public String getC22() {
    return c22;
  }

  public void setC22(String c22) {
    this.c22 = c22;
  }

  public String getC23() {
    return c23;
  }

  public void setC23(String c23) {
    this.c23 = c23;
  }

  public String getC24() {
    return c24;
  }

  public void setC24(String c24) {
    this.c24 = c24;
  }

  public String getC25() {
    return c25;
  }

  public void setC25(String c25) {
    this.c25 = c25;
  }

  public Date getCrOn() {
    return crOn;
  }

  public void setCrOn(Date crOn) {
    this.crOn = crOn;
  }

  public Integer getCrBy() {
    return crBy;
  }

  public void setCrBy(Integer crBy) {
    this.crBy = crBy;
  }
}
