package ckb.domains.med.patient;

import ckb.domains.GenId;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Patient_Drug_Dates")
public class PatientDrugDates extends GenId {

  @OneToOne
  @JoinColumn
  private PatientDrugs patientDrug;
  @Column
  private Date date;
  @Column
  private String state;
  @Column
  private boolean checked;

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
}
