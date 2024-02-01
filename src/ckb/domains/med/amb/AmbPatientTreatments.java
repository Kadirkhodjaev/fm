package ckb.domains.med.amb;

import ckb.domains.GenId;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Amb_Patient_Treatments")
public class AmbPatientTreatments extends GenId {

  @Column private Integer patient;
  @OneToOne @JoinColumn private AmbServices service;

  @Column private Integer workerId;

  @Column private Integer crBy;
  @Column private Date crOn;

  public Integer getPatient() {
    return patient;
  }

  public void setPatient(Integer patient) {
    this.patient = patient;
  }

  public AmbServices getService() {
    return service;
  }

  public void setService(AmbServices service) {
    this.service = service;
  }

  public Integer getWorkerId() {
    return workerId;
  }

  public void setWorkerId(Integer workerId) {
    this.workerId = workerId;
  }

  public Integer getCrBy() {
    return crBy;
  }

  public void setCrBy(Integer crBy) {
    this.crBy = crBy;
  }

  public Date getCrOn() {
    return crOn;
  }

  public void setCrOn(Date crOn) {
    this.crOn = crOn;
  }
}
