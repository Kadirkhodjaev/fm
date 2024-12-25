package ckb.domains.med.lv;

import ckb.domains.GenId;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.util.Date;

@Entity
@Table(name = "Lv_Consuls")
public class LvConsuls extends GenId {

  @Column private Integer patientId;
  @Column private Integer lvId;
  @Column private String lvName;
  @Column private String date;
  @Column private String text;
  @Column private String comment;
  @Column private String req;
  @Column private String state;
  @Column private String copied = "N";
  @Column private Date saveDate;
  @Column private Date crOn;

  public Integer getPatientId() {
    return patientId;
  }

  public void setPatientId(Integer patientId) {
    this.patientId = patientId;
  }

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
  }

  public Integer getLvId() {
    return lvId;
  }

  public void setLvId(Integer lvId) {
    this.lvId = lvId;
  }

  public String getLvName() {
    return lvName;
  }

  public void setLvName(String lvName) {
    this.lvName = lvName;
  }

  public String getDate() {
    return date;
  }

  public void setDate(String date) {
    this.date = date;
  }

  public String getText() {
    return text;
  }

  public void setText(String text) {
    this.text = text;
  }

  public String getCopied() {
    return copied;
  }

  public void setCopied(String copied) {
    this.copied = copied;
  }

  public Date getSaveDate() {
    return saveDate;
  }

  public void setSaveDate(Date saveDate) {
    this.saveDate = saveDate;
  }

  public String getReq() {
    return req;
  }

  public void setReq(String req) {
    this.req = req;
  }

  public Date getCrOn() {
    return crOn;
  }

  public void setCrOn(Date crOn) {
    this.crOn = crOn;
  }

  public String getComment() {
    return comment;
  }

  public void setComment(String comment) {
    this.comment = comment;
  }
}
