package ckb.domains.med.drug;

import ckb.domains.GenId;
import ckb.domains.med.drug.dict.DrugDirections;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Drug_Outs")
public class DrugOuts extends GenId {

  @Column private String regNum;
  @Column private Date regDate;
  @Column private String info;
  @Column private String state;
  @OneToOne @JoinColumn private DrugDirections direction;

  @Column private Date crOn;
  @Column private Date sendOn;
  @Column private Date confirmOn;
  @Column private String insFlag;
  @Column private String autoFlag;

  public String getRegNum() {
    return regNum;
  }

  public void setRegNum(String regNum) {
    this.regNum = regNum;
  }

  public Date getRegDate() {
    return regDate;
  }

  public void setRegDate(Date regDate) {
    this.regDate = regDate;
  }

  public String getInfo() {
    return info;
  }

  public void setInfo(String info) {
    this.info = info;
  }

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
  }

  public DrugDirections getDirection() {
    return direction;
  }

  public void setDirection(DrugDirections direction) {
    this.direction = direction;
  }

  public Date getCrOn() {
    return crOn;
  }

  public void setCrOn(Date crOn) {
    this.crOn = crOn;
  }

  public Date getSendOn() {
    return sendOn;
  }

  public void setSendOn(Date sendOn) {
    this.sendOn = sendOn;
  }

  public Date getConfirmOn() {
    return confirmOn;
  }

  public void setConfirmOn(Date confirmOn) {
    this.confirmOn = confirmOn;
  }

  public String getInsFlag() {
    return insFlag;
  }

  public void setInsFlag(String insFlag) {
    this.insFlag = insFlag;
  }

  public String getAutoFlag() {
    return autoFlag;
  }

  public void setAutoFlag(String autoFlag) {
    this.autoFlag = autoFlag;
  }
}
