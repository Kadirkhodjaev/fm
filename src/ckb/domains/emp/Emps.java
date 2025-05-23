package ckb.domains.emp;

import ckb.domains.GenId;
import ckb.domains.admin.Clients;
import ckb.domains.admin.Depts;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Emps")
public class Emps extends GenId {

  @OneToOne @JoinColumn private Clients client;
  @OneToOne @JoinColumn private Depts dept;
  @Column private String text;
  @Column private String state;

  @Column private Integer crBy;
  @Column private Date crOn;

  public Clients getClient() {
    return client;
  }

  public void setClient(Clients client) {
    this.client = client;
  }

  public Depts getDept() {
    return dept;
  }

  public void setDept(Depts dept) {
    this.dept = dept;
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

  public String getText() {
    return text;
  }

  public void setText(String text) {
    this.text = text;
  }

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
  }
}
