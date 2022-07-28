package ckb.domains.med.head_nurse;

import ckb.domains.GenId;
import ckb.domains.med.patient.Patients;

import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

@Entity
@Table(name = "HN_Date_Patients")
public class HNDatePatients extends GenId {

  @OneToOne @JoinColumn private HNDates date;
  @OneToOne @JoinColumn private Patients patient;

  public HNDates getDate() {
    return date;
  }

  public void setDate(HNDates date) {
    this.date = date;
  }

  public Patients getPatient() {
    return patient;
  }

  public void setPatient(Patients patient) {
    this.patient = patient;
  }
}
