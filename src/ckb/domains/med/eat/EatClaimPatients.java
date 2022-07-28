package ckb.domains.med.eat;

import ckb.domains.GenId;
import ckb.domains.med.eat.dict.EatTables;
import ckb.domains.med.patient.Patients;

import javax.persistence.*;

@Entity
@Table(name = "Eat_Claim_Patients")
public class EatClaimPatients extends GenId {

  @OneToOne @JoinColumn private EatClaims claim;
  @OneToOne @JoinColumn private Patients patient;
  @Column(name = "info") String info;
  @OneToOne @JoinColumn private EatTables table;

  public EatClaims getClaim() {
    return claim;
  }

  public void setClaim(EatClaims claim) {
    this.claim = claim;
  }

  public Patients getPatient() {
    return patient;
  }

  public void setPatient(Patients patient) {
    this.patient = patient;
  }

  public EatTables getTable() {
    return table;
  }

  public void setTable(EatTables table) {
    this.table = table;
  }

  public String getInfo() {
    return info;
  }

  public void setInfo(String info) {
    this.info = info;
  }
}
