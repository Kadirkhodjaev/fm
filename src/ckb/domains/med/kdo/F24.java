package ckb.domains.med.kdo;

import ckb.domains.GenId;
import ckb.domains.med.lv.LvPlans;

import javax.persistence.*;

@Entity
@Table(name = "F24")
public class F24 extends GenId {

  @Column(name = "plan_id") private Integer plan_id;
  @Column private Integer patientId;
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

  public Integer getPlan_id() {
    return plan_id;
  }

  public void setPlan_id(Integer plan_id) {
    this.plan_id = plan_id;
  }

  public Integer getPatientId() {
    return patientId;
  }

  public void setPatientId(Integer patientId) {
    this.patientId = patientId;
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
}
