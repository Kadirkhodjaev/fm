package ckb.domains.med.amb;

import ckb.domains.GenId;
import ckb.domains.admin.Dicts;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Amb_Drugs")
public class AmbDrugs extends GenId {

  @OneToOne @JoinColumn private AmbPatients patient;
  @OneToOne @JoinColumn private Dicts drugType;
  @OneToOne @JoinColumn private Dicts injectionType;

  @Column private String note;

  @Column private Date dateBegin;
  @Column private Date dateEnd;

  @Column private Integer crBy;
  @Column private Date crOn;

  public AmbPatients getPatient() {
    return patient;
  }

  public void setPatient(AmbPatients patient) {
    this.patient = patient;
  }

  public Dicts getDrugType() {
    return drugType;
  }

  public void setDrugType(Dicts drugType) {
    this.drugType = drugType;
  }

  public Dicts getInjectionType() {
    return injectionType;
  }

  public void setInjectionType(Dicts injectionType) {
    this.injectionType = injectionType;
  }

  public String getNote() {
    return note;
  }

  public void setNote(String note) {
    this.note = note;
  }

  public Date getDateBegin() {
    return dateBegin;
  }

  public void setDateBegin(Date dateBegin) {
    this.dateBegin = dateBegin;
  }

  public Date getDateEnd() {
    return dateEnd;
  }

  public void setDateEnd(Date dateEnd) {
    this.dateEnd = dateEnd;
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
