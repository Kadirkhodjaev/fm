package ckb.domains.med.cash;

import ckb.domains.GenId;
import ckb.domains.admin.Users;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Cash_Opers")
public class CashOpers extends GenId {

  @Column private String regNum;
  @OneToOne @JoinColumn private CashOpers operday;

  @Column private Users crBy;
  @Column private Date crOn;

  public String getRegNum() {
    return regNum;
  }

  public void setRegNum(String regNum) {
    this.regNum = regNum;
  }

  public CashOpers getOperday() {
    return operday;
  }

  public void setOperday(CashOpers operday) {
    this.operday = operday;
  }

  public Users getCrBy() {
    return crBy;
  }

  public void setCrBy(Users crBy) {
    this.crBy = crBy;
  }

  public Date getCrOn() {
    return crOn;
  }

  public void setCrOn(Date crOn) {
    this.crOn = crOn;
  }
}
