package ckb.domains.med.patient;

import ckb.domains.GenId;
import ckb.domains.admin.Dicts;
import ckb.domains.med.lv.LvDrugGoals;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Patient_Drugs")
public class PatientDrugs extends GenId {

  @OneToOne @JoinColumn private Patients patient;
  @OneToOne @JoinColumn private LvDrugGoals goal;
  @OneToOne @JoinColumn private Dicts drugType;
  @OneToOne @JoinColumn private Dicts injectionType;
  @Column private String tabletType;

  @Column private String note;
  @Column private String state;

  @Column private boolean morningTime;
  @Column private boolean noonTime;
  @Column private boolean eveningTime;

  @Column private boolean morningTimeBefore;
  @Column private boolean morningTimeAfter;
  @Column private boolean noonTimeBefore;
  @Column private boolean noonTimeAfter;
  @Column private boolean eveningTimeBefore;
  @Column private boolean eveningTimeAfter;

  @Column private Date dateBegin;
  @Column private Date dateEnd;

  @Column private Integer crBy;
  @Column private Date crOn;

  public Patients getPatient() {
    return patient;
  }

  public void setPatient(Patients patient) {
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

  public LvDrugGoals getGoal() {
    return goal;
  }

  public void setGoal(LvDrugGoals goal) {
    this.goal = goal;
  }

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
  }

  public Date getCrOn() {
    return crOn;
  }

  public void setCrOn(Date crOn) {
    this.crOn = crOn;
  }

  public Integer getCrBy() {
    return crBy;
  }

  public void setCrBy(Integer crBy) {
    this.crBy = crBy;
  }

  public boolean isMorningTime() {
    return morningTime;
  }

  public void setMorningTime(boolean morningTime) {
    this.morningTime = morningTime;
  }

  public boolean isEveningTime() {
    return eveningTime;
  }

  public void setEveningTime(boolean eveningTime) {
    this.eveningTime = eveningTime;
  }

  public boolean isMorningTimeBefore() {
    return morningTimeBefore;
  }

  public void setMorningTimeBefore(boolean morningTimeBefore) {
    this.morningTimeBefore = morningTimeBefore;
  }

  public boolean isMorningTimeAfter() {
    return morningTimeAfter;
  }

  public void setMorningTimeAfter(boolean morningTimeAfter) {
    this.morningTimeAfter = morningTimeAfter;
  }

  public boolean isEveningTimeBefore() {
    return eveningTimeBefore;
  }

  public void setEveningTimeBefore(boolean eveningTimeBefore) {
    this.eveningTimeBefore = eveningTimeBefore;
  }

  public boolean isEveningTimeAfter() {
    return eveningTimeAfter;
  }

  public void setEveningTimeAfter(boolean eveningTimeAfter) {
    this.eveningTimeAfter = eveningTimeAfter;
  }

  public boolean isNoonTime() {
    return noonTime;
  }

  public void setNoonTime(boolean noonTime) {
    this.noonTime = noonTime;
  }

  public boolean isNoonTimeBefore() {
    return noonTimeBefore;
  }

  public void setNoonTimeBefore(boolean noonTimeBefore) {
    this.noonTimeBefore = noonTimeBefore;
  }

  public boolean isNoonTimeAfter() {
    return noonTimeAfter;
  }

  public void setNoonTimeAfter(boolean noonTimeAfter) {
    this.noonTimeAfter = noonTimeAfter;
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

  public String getTabletType() {
    return tabletType;
  }

  public void setTabletType(String tabletType) {
    this.tabletType = tabletType;
  }

}
