package ckb.domains.med.amb;

import ckb.domains.GenId;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.util.Date;

@Entity
@Table(name = "Amb_Patient_Treatment_Dates")
public class AmbPatientTreatmentDates extends GenId {

  @Column private Integer patient;
  @Column private Integer treatment;
  @Column private Date actDate;
  @Column private String state;
  @Column private Integer patientService;
  @Column private String patientServiceState;
  @Column private String paid;

  public Integer getPatient() {
    return patient;
  }

  public void setPatient(Integer patient) {
    this.patient = patient;
  }

  public Integer getTreatment() {
    return treatment;
  }

  public void setTreatment(Integer treatment) {
    this.treatment = treatment;
  }

  public Date getActDate() {
    return actDate;
  }

  public void setActDate(Date actDate) {
    this.actDate = actDate;
  }

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
  }

  public Integer getPatientService() {
    return patientService;
  }

  public void setPatientService(Integer patientService) {
    this.patientService = patientService;
  }

  public String getPaid() {
    return paid;
  }

  public void setPaid(String paid) {
    this.paid = paid;
  }

  public String getPatientServiceState() {
    return patientServiceState;
  }

  public void setPatientServiceState(String patientServiceState) {
    this.patientServiceState = patientServiceState;
  }
}
