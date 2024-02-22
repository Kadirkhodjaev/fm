package ckb.domains.med.amb;

import ckb.domains.GenId;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.util.Date;

@Entity
@Table(name = "Amb_Forms")
public class AmbForms extends GenId {

  @Column private Date actDate;
  @Column private Integer service;
  @Column private String state;

  public Date getActDate() {
    return actDate;
  }

  public void setActDate(Date actDate) {
    this.actDate = actDate;
  }

  public Integer getService() {
    return service;
  }

  public void setService(Integer service) {
    this.service = service;
  }

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
  }
}
