package ckb.domains.med.head_nurse;

import ckb.domains.GenId;
import ckb.domains.admin.Users;
import ckb.domains.med.drug.dict.DrugDirections;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "HN_Opers")
public class HNOpers extends GenId {

  @OneToOne @JoinColumn private DrugDirections parent;
  @OneToOne @JoinColumn private DrugDirections direction;

  @Column private Date date;
  @Column private String state;

  @OneToOne @JoinColumn private Users crBy;
  @Column private Date crOn;

  public Date getDate() {
    return date;
  }

  public void setDate(Date date) {
    this.date = date;
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

  public DrugDirections getDirection() {
    return direction;
  }

  public void setDirection(DrugDirections direction) {
    this.direction = direction;
  }

  public DrugDirections getParent() {
    return parent;
  }

  public void setParent(DrugDirections parent) {
    this.parent = parent;
  }
}