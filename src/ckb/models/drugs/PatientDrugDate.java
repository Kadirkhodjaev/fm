package ckb.models.drugs;

import java.util.Date;

public class PatientDrugDate {

  private Integer id;
  private Date date;
  private String dateMonth;
  private String state;
  private boolean checked;
  private Integer repeat;
  private boolean disabled;

  private boolean morningDone;
  private boolean noonDone;
  private boolean eveningDone;

  public Integer getId() {
    return id;
  }

  public void setId(Integer id) {
    this.id = id;
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

  public boolean isChecked() {
    return checked;
  }

  public void setChecked(boolean checked) {
    this.checked = checked;
  }

  public String getDateMonth() {
    return dateMonth;
  }

  public void setDateMonth(String dateMonth) {
    this.dateMonth = dateMonth;
  }

  public Integer getRepeat() {
    return repeat;
  }

  public void setRepeat(Integer repeat) {
    this.repeat = repeat;
  }

  public boolean isDisabled() {
    return disabled;
  }

  public void setDisabled(boolean disabled) {
    this.disabled = disabled;
  }

  public boolean isMorningDone() {
    return morningDone;
  }

  public void setMorningDone(boolean morningDone) {
    this.morningDone = morningDone;
  }

  public boolean isNoonDone() {
    return noonDone;
  }

  public void setNoonDone(boolean noonDone) {
    this.noonDone = noonDone;
  }

  public boolean isEveningDone() {
    return eveningDone;
  }

  public void setEveningDone(boolean eveningDone) {
    this.eveningDone = eveningDone;
  }
}
