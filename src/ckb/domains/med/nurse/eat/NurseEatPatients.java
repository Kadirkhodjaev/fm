package ckb.domains.med.nurse.eat;


import ckb.domains.GenId;
import ckb.domains.med.eat.dict.EatTables;
import ckb.domains.med.patient.Patients;

import javax.persistence.*;

@Entity
@Table(name = "Nurse_Eat_Patients")
public class NurseEatPatients extends GenId {

  @OneToOne
  @JoinColumn(name = "nurse_eat_id")
  private NurseEats nurseEat;

  @OneToOne
  @JoinColumn(name = "patient_id")
  private Patients patient;

  @OneToOne
  @JoinColumn(name = "table_id")
  private EatTables table;

  @Column(name = "comment") private String comment;

  public NurseEats getNurseEat() {
    return nurseEat;
  }

  public void setNurseEat(NurseEats nurseEat) {
    this.nurseEat = nurseEat;
  }

  public Patients getPatient() {
    return patient;
  }

  public void setPatient(Patients patient) {
    this.patient = patient;
  }

  public String getComment() {
    return comment;
  }

  public void setComment(String comment) {
    this.comment = comment;
  }

  public EatTables getTable() {
    return table;
  }

  public void setTable(EatTables table) {
    this.table = table;
  }
}
