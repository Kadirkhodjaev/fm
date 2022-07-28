package ckb.domains.med.lv;

import ckb.domains.GenId;
import ckb.utils.Util;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.util.Date;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 07.07.16
 * Time: 22:07
 * To change this template use File | Settings | File Templates.
 */
@Entity
@Table(name = "Lv_Dairies")
public class LvDairies  extends GenId {

  // ID Пациента
  @Column
  private Integer patient;
  // Дата дневника
  @Column
  private Date actDate;
  // Пульс
  @Column
  private String puls;
  // Температура
  @Column
  private String temp;
  // Давление
  @Column
  private String dav1;
  // Давление
  @Column
  private String dav2;
  // Состояние пациента
  @Column
  private String text;

  @Column
  private Date creationDate;
  @Column
  private Integer createdBy;
  @Column
  private Date updateDate;
  @Column
  private Integer updatedBy;

  public Integer getPatient() {
    return patient;
  }

  public void setPatient(Integer patient) {
    this.patient = patient;
  }

  public Date getActDate() {
    return actDate;
  }

  public void setActDate(Date actDate) {
    this.actDate = actDate;
  }

  public String getPuls() {
    return puls;
  }

  public void setPuls(String puls) {
    this.puls = puls;
  }

  public String getTemp() {
    return temp;
  }

  public void setTemp(String temp) {
    this.temp = temp;
  }

  public String getText() {
    return text;
  }

  public void setText(String text) {
    this.text = text;
  }

  public Date getCreationDate() {
    return creationDate;
  }

  public void setCreationDate(Date creationDate) {
    this.creationDate = creationDate;
  }

  public Integer getCreatedBy() {
    return createdBy;
  }

  public void setCreatedBy(Integer createdBy) {
    this.createdBy = createdBy;
  }

  public Date getUpdateDate() {
    return updateDate;
  }

  public void setUpdateDate(Date updateDate) {
    this.updateDate = updateDate;
  }

  public Integer getUpdatedBy() {
    return updatedBy;
  }

  public void setUpdatedBy(Integer updatedBy) {
    this.updatedBy = updatedBy;
  }

  public String getDav1() {
    return dav1;
  }

  public void setDav1(String dav1) {
    this.dav1 = dav1;
  }

  public String getDav2() {
    return dav2;
  }

  public void setDav2(String dav2) {
    this.dav2 = dav2;
  }

  public String getAct_Date(){
    return Util.dateToString(actDate);
  }
}
