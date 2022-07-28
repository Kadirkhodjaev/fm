package ckb.domains.med.patient;

import ckb.domains.GenId;
import ckb.domains.med.eat.dict.EatMenuTypes;
import ckb.domains.med.eat.dict.EatTables;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Patient_Eats")
public class PatientEats extends GenId {

  @OneToOne @JoinColumn private Patients patient;
  @Column private Date actDate;
  @OneToOne @JoinColumn private EatMenuTypes menuType;
  @OneToOne @JoinColumn private EatTables table;
  @Column private String state;

  public Patients getPatient() {
    return patient;
  }

  public void setPatient(Patients patient) {
    this.patient = patient;
  }

  public Date getActDate() {
    return actDate;
  }

  public void setActDate(Date actDate) {
    this.actDate = actDate;
  }

  public EatMenuTypes getMenuType() {
    return menuType;
  }

  public void setMenuType(EatMenuTypes menuType) {
    this.menuType = menuType;
  }

  public EatTables getTable() {
    return table;
  }

  public void setTable(EatTables table) {
    this.table = table;
  }

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
  }
}
