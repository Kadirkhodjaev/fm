package ckb.domains.med.patient;

import ckb.domains.GenId;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.util.Date;

@Entity
@Table(name = "Patient_Plans")
public class PatientPlans extends GenId {

  @Column private Integer patient_id;
  @Column private Integer plan_Id;
  @Column private Integer kdo_type_id;
  @Column private Date actDate;
  @Column private String done;

  public Integer getPatient_id() {
    return patient_id;
  }

  public void setPatient_id(Integer patient_id) {
    this.patient_id = patient_id;
  }

  public Integer getPlan_Id() {
    return plan_Id;
  }

  public void setPlan_Id(Integer plan_Id) {
    this.plan_Id = plan_Id;
  }

  public Integer getKdo_type_id() {
    return kdo_type_id;
  }

  public void setKdo_type_id(Integer kdo_type_id) {
    this.kdo_type_id = kdo_type_id;
  }

  public Date getActDate() {
    return actDate;
  }

  public void setActDate(Date actDate) {
    this.actDate = actDate;
  }

  public String getDone() {
    return done;
  }

  public void setDone(String done) {
    this.done = done;
  }
}
