package ckb.domains.med.drug;

import ckb.domains.GenId;
import ckb.domains.med.drug.dict.DrughContracts;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Drug_h_Acts")
public class DrughActs extends GenId {

  @OneToOne @JoinColumn private DrughContracts contract;
  @Column private String regNum;
  @Column private Date regDate;
  @Column private String extraInfo;
  @Column private String state;

  @Column private Integer crBy;
  @Column private Date crOn;

  public DrughContracts getContract() {
    return contract;
  }

  public void setContract(DrughContracts contract) {
    this.contract = contract;
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

  public String getExtraInfo() {
    return extraInfo;
  }

  public void setExtraInfo(String extraInfo) {
    this.extraInfo = extraInfo;
  }

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
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
