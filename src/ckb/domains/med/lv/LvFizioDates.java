package ckb.domains.med.lv;

import ckb.domains.GenId;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Lv_Fizio_Dates")
public class LvFizioDates extends GenId {

  @OneToOne @JoinColumn private LvFizios fizio;
  @Column private Date date;
  @Column private String state = "N";
  @Column private String done = "N";
  @Column private Date confDate;

  public LvFizios getFizio() {
    return fizio;
  }

  public void setFizio(LvFizios fizio) {
    this.fizio = fizio;
  }

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

  public String getDone() {
    return done;
  }

  public void setDone(String done) {
    this.done = done;
  }

  public Date getConfDate() {
    return confDate;
  }

  public void setConfDate(Date confDate) {
    this.confDate = confDate;
  }
}
