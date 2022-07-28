package ckb.domains.med.amb;

import ckb.domains.GenId;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Amb_Drug_Dates")
public class AmbDrugDates extends GenId {

  @OneToOne @JoinColumn private AmbDrugs ambDrug;
  @Column private Date date;
  @Column private String state;
  @Column private boolean checked;

  public AmbDrugs getAmbDrug() {
    return ambDrug;
  }

  public void setAmbDrug(AmbDrugs ambDrug) {
    this.ambDrug = ambDrug;
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
}
