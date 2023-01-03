package ckb.domains.med.head_nurse;

import ckb.domains.GenId;
import ckb.domains.med.patient.Patients;

import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

@Entity
@Table(name = "HN_h_Date_Patients")
public class HNHDatePatients extends GenId {

  @OneToOne @JoinColumn private HNHDates date;
  @OneToOne @JoinColumn private Patients patient;

  public HNHDates getDate() {
    return date;
  }

  public void setDate(HNHDates date) {
    this.date = date;
  }

  public Patients getPatient() {
    return patient;
  }

  public void setPatient(Patients patient) {
    this.patient = patient;
  }
}
