package ckb.domains.med.kdo;

import ckb.domains.GenId;
import ckb.domains.med.lv.LvPlans;

import javax.persistence.*;

@Entity
@Table(name = "F49")
public class F49 extends GenId {

  @Column(name = "plan_id") private Integer plan_id;
  @Column private Integer patientId;
  @Column private String c1;
  @Column private String c2;
  @Column private String c3;
  @Column private String c4;

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
}
