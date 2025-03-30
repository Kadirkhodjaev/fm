package ckb.models.drugs;

import java.util.Date;
import java.util.List;

public class PatientDrugNurseDate {

  private Date date;
  private List<PatientDrug> drugs;

  public Date getDate() {
    return date;
  }

  public void setDate(Date date) {
    this.date = date;
  }

  public List<PatientDrug> getDrugs() {
    return drugs;
  }

  public void setDrugs(List<PatientDrug> drugs) {
    this.drugs = drugs;
  }
}
