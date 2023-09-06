package ckb.domains.med.patient;

import ckb.domains.GenId;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Patient_Drug_Dates")
public class PatientDrugDates extends GenId {

  @OneToOne @JoinColumn private PatientDrugs patientDrug;
  @Column private Date date;
  @Column private String state;
  @Column private boolean checked;

  @Column private boolean morningTimeDone;
  @Column private Integer morningTimeDoneBy;
  @Column private Date morningTimeDoneOn;
  @Column private boolean noonTimeDone;
  @Column private Integer noonTimeDoneBy;
  @Column private Date noonTimeDoneOn;
  @Column private boolean eveningTimeDone;
  @Column private Integer eveningTimeDoneBy;
  @Column private Date eveningTimeDoneOn;

  public PatientDrugs getPatientDrug() {
    return patientDrug;
  }

  public void setPatientDrug(PatientDrugs patientDrug) {
    this.patientDrug = patientDrug;
  }

  public Date getDate() {
    return date;
  }

  public void setDate(Date date) {
    this.date = date;
  }

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
  }

  public boolean isChecked() {
    return checked;
  }

  public void setChecked(boolean checked) {
    this.checked = checked;
  }

  public boolean isMorningTimeDone() {
    return morningTimeDone;
  }

  public void setMorningTimeDone(boolean morningTimeDone) {
    this.morningTimeDone = morningTimeDone;
  }

  public Integer getMorningTimeDoneBy() {
    return morningTimeDoneBy;
  }

  public void setMorningTimeDoneBy(Integer morningTimeDoneBy) {
    this.morningTimeDoneBy = morningTimeDoneBy;
  }

  public Date getMorningTimeDoneOn() {
    return morningTimeDoneOn;
  }

  public void setMorningTimeDoneOn(Date morningTimeDoneOn) {
    this.morningTimeDoneOn = morningTimeDoneOn;
  }

  public boolean isNoonTimeDone() {
    return noonTimeDone;
  }

  public void setNoonTimeDone(boolean noonTimeDone) {
    this.noonTimeDone = noonTimeDone;
  }

  public Integer getNoonTimeDoneBy() {
    return noonTimeDoneBy;
  }

  public void setNoonTimeDoneBy(Integer noonTimeDoneBy) {
    this.noonTimeDoneBy = noonTimeDoneBy;
  }

  public Date getNoonTimeDoneOn() {
    return noonTimeDoneOn;
  }

  public void setNoonTimeDoneOn(Date noonTimeDoneOn) {
    this.noonTimeDoneOn = noonTimeDoneOn;
  }

  public boolean isEveningTimeDone() {
    return eveningTimeDone;
  }

  public void setEveningTimeDone(boolean eveningTimeDone) {
    this.eveningTimeDone = eveningTimeDone;
  }

  public Integer getEveningTimeDoneBy() {
    return eveningTimeDoneBy;
  }

  public void setEveningTimeDoneBy(Integer eveningTimeDoneBy) {
    this.eveningTimeDoneBy = eveningTimeDoneBy;
  }

  public Date getEveningTimeDoneOn() {
    return eveningTimeDoneOn;
  }

  public void setEveningTimeDoneOn(Date eveningTimeDoneOn) {
    this.eveningTimeDoneOn = eveningTimeDoneOn;
  }
}
