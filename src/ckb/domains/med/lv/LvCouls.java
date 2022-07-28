package ckb.domains.med.lv;

import ckb.domains.GenId;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "Lv_Couls")
public class LvCouls extends GenId {

  @Column(name = "Patient_Id") private Integer patientId;
  @Column(name = "Plan_Id") private Integer planId;
  @Column private boolean c1;
  @Column private boolean c2;
  @Column private boolean c3;
  @Column private boolean c4;

  public Integer getPatientId() {
    return patientId;
  }

  public void setPatientId(Integer patientId) {
    this.patientId = patientId;
  }

  public Integer getPlanId() {
    return planId;
  }

  public void setPlanId(Integer planId) {
    this.planId = planId;
  }

  public boolean isC1() {
    return c1;
  }

  public void setC1(boolean c1) {
    this.c1 = c1;
  }

  public boolean isC2() {
    return c2;
  }

  public void setC2(boolean c2) {
    this.c2 = c2;
  }

  public boolean isC3() {
    return c3;
  }

  public void setC3(boolean c3) {
    this.c3 = c3;
  }

  public boolean isC4() {
    return c4;
  }

  public void setC4(boolean c4) {
    this.c4 = c4;
  }
}
