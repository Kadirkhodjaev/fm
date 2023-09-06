package ckb.domains.med.patient;

import ckb.domains.GenId;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Patient_Drug_Exps")
public class PatientDrugExps extends GenId {

  @OneToOne
  @JoinColumn
  private Patients patient;
  @Column
  private Date operDay;
  @Column private String code;
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

  public String getCode() {
    return code;
  }

  public void setCode(String code) {
    this.code = code;
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
