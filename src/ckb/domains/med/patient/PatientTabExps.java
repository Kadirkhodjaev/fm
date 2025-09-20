package ckb.domains.med.patient;

import ckb.domains.GenId;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Patient_Tab_Exps")
public class PatientTabExps extends GenId {
  @OneToOne @JoinColumn private Patients patient;
  @Column private Date operDay;
  @OneToOne @JoinColumn private PatientDrugs drug;
  @Column private Double morningExp;
  @Column private Double noonExp;
  @Column private Double eveningExp;

  public Patients getPatient() {
    return patient;
  }

  public void setPatient(Patients patient) {
    this.patient = patient;
  }

  public Date getOperDay() {
    return operDay;
  }

  public void setOperDay(Date operDay) {
    this.operDay = operDay;
  }

  public PatientDrugs getDrug() {
    return drug;
  }

  public void setDrug(PatientDrugs drug) {
    this.drug = drug;
  }

  public Double getMorningExp() {
    return morningExp;
  }

  public void setMorningExp(Double morningExp) {
    this.morningExp = morningExp;
  }

  public Double getNoonExp() {
    return noonExp;
  }

  public void setNoonExp(Double noonExp) {
    this.noonExp = noonExp;
  }

  public Double getEveningExp() {
    return eveningExp;
  }

  public void setEveningExp(Double eveningExp) {
    this.eveningExp = eveningExp;
  }
}
