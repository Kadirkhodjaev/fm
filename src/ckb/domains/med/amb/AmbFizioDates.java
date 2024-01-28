package ckb.domains.med.amb;

import ckb.domains.GenId;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Amb_Fizio_Dates")
public class AmbFizioDates extends GenId {

  @OneToOne @JoinColumn(name = "patient_service") private AmbPatientServices fizio;
  @Column private Date date;
  @Column private String state = "N";

  public AmbPatientServices getFizio() {
    return fizio;
  }

  public void setFizio(AmbPatientServices fizio) {
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
}
