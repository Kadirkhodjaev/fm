package ckb.domains.med.eat;

import ckb.domains.GenId;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.util.Date;

@Entity
@Table(name = "Eat_Acts")
public class EatActs extends GenId {

  @Column private String regNum;
  @Column private Date regDate;
  @Column private String extraInfo;
  @Column private String state;

  @Column private Integer crBy;
  @Column private Date crOn;

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
