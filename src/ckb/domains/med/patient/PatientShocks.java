package ckb.domains.med.patient;

import ckb.domains.GenId;
import ckb.domains.admin.Users;
import ckb.domains.med.drug.dict.Drugs;
import ckb.domains.med.head_nurse.HNDrugs;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Patient_Shocks")
public class PatientShocks extends GenId {

  @OneToOne @JoinColumn private Patients patient;
  @OneToOne @JoinColumn private HNDrugs hndrug;
  @OneToOne @JoinColumn private Drugs drug;
  @Column private Double rasxod;

  @OneToOne @JoinColumn private Users crBy;
  @Column private Date crOn;

  public Patients getPatient() {
    return patient;
  }

  public void setPatient(Patients patient) {
    this.patient = patient;
  }

  public HNDrugs getHndrug() {
    return hndrug;
  }

  public void setHndrug(HNDrugs hndrug) {
    this.hndrug = hndrug;
  }

  public Drugs getDrug() {
    return drug;
  }

  public void setDrug(Drugs drug) {
    this.drug = drug;
  }

  public Double getRasxod() {
    return rasxod;
  }

  public void setRasxod(Double rasxod) {
    this.rasxod = rasxod;
  }

  public Users getCrBy() {
    return crBy;
  }

  public void setCrBy(Users crBy) {
    this.crBy = crBy;
  }

  public Date getCrOn() {
    return crOn;
  }

  public void setCrOn(Date crOn) {
    this.crOn = crOn;
  }
}
