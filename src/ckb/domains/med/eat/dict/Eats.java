package ckb.domains.med.eat.dict;

import ckb.domains.GenId;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Eat_s_Eats")
public class Eats extends GenId {

  @OneToOne @JoinColumn private EatTypes type;
  @Column private String name;
  @Column private String state;

  @Column private Integer crBy;
  @Column private Date crOn;

  public EatTypes getType() {
    return type;
  }

  public void setType(EatTypes type) {
    this.type = type;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
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
