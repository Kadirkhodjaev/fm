package ckb.models.drugs;

import ckb.domains.admin.Dicts;
import ckb.domains.med.head_nurse.HNDates;
import ckb.domains.med.lv.LvDrugGoals;
import ckb.domains.med.patient.Patients;

import java.util.Date;
import java.util.List;

public class PatientDrug {

  private Integer id;
  private Dicts drugType;
  private Dicts injectionType;
  private Patients patient;
  private LvDrugGoals goal;
  private List<PatientDrugRow> rows;
  private List<PatientDrugDate> dates;
  private List<HNDates> ds;

  private String note;
  private String state;

  private boolean morningTime;
  private boolean noonTime;
  private boolean eveningTime;

  private boolean morningTimeBefore;
  private boolean morningTimeAfter;
  private boolean noonTimeBefore;
  private boolean noonTimeAfter;
  private boolean eveningTimeBefore;
  private boolean eveningTimeAfter;

  private boolean morningTimeDone;
  private Integer morningTimeDoneBy;
  private Date morningTimeDoneOn;
  private boolean noonTimeDone;
  private Integer noonTimeDoneBy;
  private Date noonTimeDoneOn;
  private boolean eveningTimeDone;
  private Integer eveningTimeDoneBy;
  private Date eveningTimeDoneOn;
  private Integer dateId;

  private boolean timeDone;
  private String timeDoneBy;
  private Date timeDoneOn;

  private boolean canDel;

  private Date dateBegin;
  private Date dateEnd;

  private Integer crBy;
  private Date crOn;

  public Integer getId() {
    return id;
  }

  public void setId(Integer id) {
    this.id = id;
  }

  public Patients getPatient() {
    return patient;
  }

  public void setPatient(Patients patient) {
    this.patient = patient;
  }

  public LvDrugGoals getGoal() {
    return goal;
  }

  public void setGoal(LvDrugGoals goal) {
    this.goal = goal;
  }

  public List<PatientDrugRow> getRows() {
    return rows;
  }

  public void setRows(List<PatientDrugRow> rows) {
    this.rows = rows;
  }

  public List<PatientDrugDate> getDates() {
    return dates;
  }

  public void setDates(List<PatientDrugDate> dates) {
    this.dates = dates;
  }

  public String getNote() {
    return note;
  }

  public void setNote(String note) {
    this.note = note;
  }

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
  }

  public boolean isMorningTime() {
    return morningTime;
  }

  public void setMorningTime(boolean morningTime) {
    this.morningTime = morningTime;
  }

  public boolean isNoonTime() {
    return noonTime;
  }

  public void setNoonTime(boolean noonTime) {
    this.noonTime = noonTime;
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

  public boolean isCanDel() {
    return canDel;
  }

  public void setCanDel(boolean canDel) {
    this.canDel = canDel;
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

  public List<HNDates> getDs() {
    return ds;
  }

  public void setDs(List<HNDates> ds) {
    this.ds = ds;
  }

  public boolean isTimeDone() {
    return timeDone;
  }

  public void setTimeDone(boolean timeDone) {
    this.timeDone = timeDone;
  }

  public String getTimeDoneBy() {
    return timeDoneBy;
  }

  public void setTimeDoneBy(String timeDoneBy) {
    this.timeDoneBy = timeDoneBy;
  }

  public Date getTimeDoneOn() {
    return timeDoneOn;
  }

  public void setTimeDoneOn(Date timeDoneOn) {
    this.timeDoneOn = timeDoneOn;
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

  public Integer getDateId() {
    return dateId;
  }

  public void setDateId(Integer dateId) {
    this.dateId = dateId;
  }
}
