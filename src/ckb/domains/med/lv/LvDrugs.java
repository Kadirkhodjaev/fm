package ckb.domains.med.lv;

import ckb.domains.GenId;
import ckb.domains.admin.SelOpts;
import ckb.utils.Util;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Lv_Drugs")
public class LvDrugs extends GenId {

  // ID Пациента
  @Column private Integer patient;
  @Column private String drugName;
  @Column private boolean morningTime;
  @Column private boolean noonTime;
  @Column private boolean eveningTime;
  @Column private Date startDate;
  @Column private Date endDate;
  @Column private String note;
  @Column private String type;
  @Column private String cat;
  @OneToOne private LvDrugGoals goal;

  public String getCat() {
    return cat;
  }

  public void setCat(String cat) {
    this.cat = cat;
  }


  public Integer getPatient() {
    return patient;
  }

  public void setPatient(Integer patient) {
    this.patient = patient;
  }

  public String getDrugName() {
    return drugName;
  }

  public void setDrugName(String drugName) {
    this.drugName = drugName;
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

  public Date getStartDate() {
    return startDate;
  }

  public void setStartDate(Date startDate) {
    this.startDate = startDate;
  }

  public Date getEndDate() {
    return endDate;
  }

  public void setEndDate(Date endDate) {
    this.endDate = endDate;
  }

  public String getNote() {
    return note;
  }

  public void setNote(String note) {
    this.note = note;
  }

  public String getDateStart(){
    return Util.dateToString(startDate);
  }

  public String getDateEnd(){
    return Util.dateToString(endDate);
  }

  public String getType() {
    return type;
  }

  public void setType(String type) {
    this.type = type;
  }

  public LvDrugGoals getGoal() {
    return goal;
  }

  public void setGoal(LvDrugGoals goal) {
    this.goal = goal;
  }
}
