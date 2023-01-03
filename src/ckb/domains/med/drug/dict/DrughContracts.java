package ckb.domains.med.drug.dict;

import ckb.domains.GenId;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Drug_h_Contracts")
public class DrughContracts extends GenId {

  @OneToOne @JoinColumn private DrugPartners partner;
  @Column private String regNum;
  @Column private Date regDate;
  @Column private Date startDate;
  @Column private Date endDate;
  @Column private String extraInfo;

  @Column private Integer crBy;
  @Column private Date crOn;

  public DrugPartners getPartner() {
    return partner;
  }

  public void setPartner(DrugPartners partner) {
    this.partner = partner;
  }

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

  public String getExtraInfo() {
    return extraInfo;
  }

  public void setExtraInfo(String extraInfo) {
    this.extraInfo = extraInfo;
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
