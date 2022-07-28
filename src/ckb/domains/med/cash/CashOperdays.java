package ckb.domains.med.cash;

import ckb.domains.GenId;
import ckb.domains.admin.Users;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Cash_Operdays")
public class CashOperdays extends GenId {

  @Column private Date operday;
  @Column private String state;
  @OneToOne @JoinColumn private Users crBy;
  @Column private Date crOn;

  public Date getOperday() {
    return operday;
  }

  public void setOperday(Date operday) {
    this.operday = operday;
  }

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
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
