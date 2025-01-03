package ckb.domains.med.lv;


import ckb.domains.GenId;
import ckb.domains.admin.KdoTypes;
import ckb.domains.admin.Kdos;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Lv_Plans")
public class LvPlans extends GenId {

  @Column // ID Пациента
  private Integer patientId;
  @Column // ID пользователя
  private Integer userId;
  @OneToOne
  @JoinColumn(name = "Kdo_Id")
  private Kdos kdo;
  @OneToOne
  @JoinColumn(name = "Kdo_Type_Id")
  private KdoTypes kdoType;
  @Column
  private Date actDate;
  @Column
  private String comment;
  @Column (name = "Done_Flag") // Флаг подтверждения КДО
  private String isDone;
  @Column (name = "Result_Id") // Идентификатор результата
  private Integer resultId;
  @Column (name = "Result_Date") // Дата подтверждения результата
  private Date resDate;
  @Column(name = "conf_user")
  private Integer confUser;
  @Column private Double price = 0D;
  @Column private Double counter = 0D;

  @Column private Date payDate;
  @Column private String cashState = "ENT";
  @Column private Date crOn;

  public Date getCrOn() {
    return crOn;
  }

  public void setCrOn(Date crOn) {
    this.crOn = crOn;
  }

  public Integer getPatientId() {
    return patientId;
  }

  public void setPatientId(Integer patient) {
    this.patientId = patient;
  }

  public Integer getUserId() {
    return userId;
  }

  public void setUserId(Integer userId) {
    this.userId = userId;
  }

  public Kdos getKdo() {
    return kdo;
  }

  public void setKdo(Kdos kdo) {
    this.kdo = kdo;
  }

  public KdoTypes getKdoType() {
    return kdoType;
  }

  public void setKdoType(KdoTypes kdoType) {
    this.kdoType = kdoType;
  }

  public Date getActDate() {
    return actDate;
  }

  public void setActDate(Date actDate) {
    this.actDate = actDate;
  }

  public String getComment() {
    return comment;
  }

  public void setComment(String comment) {
    this.comment = comment;
  }

  public String getDone() {
    return isDone;
  }

  public void setDone(String done) {
    isDone = done;
  }

  public Integer getResultId() {
    return resultId;
  }

  public void setResultId(Integer result_id) {
    this.resultId = result_id;
  }

  public Date getResDate() {
    return resDate;
  }

  public void setResDate(Date resDate) {
    this.resDate = resDate;
  }

  public Integer getConfUser() {
    return confUser;
  }

  public void setConfUser(Integer confUser) {
    this.confUser = confUser;
  }

  public String getIsDone() {
    return isDone;
  }

  public void setIsDone(String isDone) {
    this.isDone = isDone;
  }

  public Double getPrice() {
    return price;
  }

  public void setPrice(Double price) {
    this.price = price;
  }

  public Date getPayDate() {
    return payDate;
  }

  public void setPayDate(Date payDate) {
    this.payDate = payDate;
  }

  public String getCashState() {
    return cashState;
  }

  public void setCashState(String cashState) {
    this.cashState = cashState;
  }

  public Double getCounter() {
    return counter;
  }

  public void setCounter(Double counter) {
    this.counter = counter;
  }
}
