package ckb.domains.med.eat;

import ckb.domains.GenId;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.util.Date;

@Entity
@Table(name = "Eat_Menus")
public class EatMenus extends GenId {

  @Column private Date menuDate;

  @Column private String info;
  @Column private String state;

  @Column private Integer crBy;
  @Column private Date crOn;

  public Date getMenuDate() {
    return menuDate;
  }

  public void setMenuDate(Date menuDate) {
    this.menuDate = menuDate;
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
