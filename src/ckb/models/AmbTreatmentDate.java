package ckb.models;

import java.util.Date;

public class AmbTreatmentDate {

  private Date date;
  private String paid;
  private String state;
  private String psState;

  public Date getDate() {
    return date;
  }

  public void setDate(Date date) {
    this.date = date;
  }

  public String getPaid() {
    return paid;
  }

  public void setPaid(String paid) {
    this.paid = paid;
  }

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
  }

  public String getPsState() {
    return psState;
  }

  public void setPsState(String psState) {
    this.psState = psState;
  }
}
