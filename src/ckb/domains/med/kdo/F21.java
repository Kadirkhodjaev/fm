package ckb.domains.med.kdo;

import ckb.domains.GenId;
import ckb.domains.med.lv.LvPlans;

import javax.persistence.*;

@Entity
@Table(name = "F21")
public class F21 extends GenId {

  @Column(name = "plan_id") private Integer plan_id;
  @Column private Integer patientId;
  @Column private String c1;
  @Column private String c2;

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
}
