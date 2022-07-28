package ckb.domains.admin;

import ckb.domains.GenId;
import ckb.domains.med.drug.dict.DrugDirections;

import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

@Entity
@Table(name = "User_Drug_Lines")
public class UserDrugLines extends GenId {

  @OneToOne
  @JoinColumn
  private Users user;
  @OneToOne
  @JoinColumn
  private DrugDirections direction;

  public Users getUser() {
    return user;
  }

  public void setUser(Users user) {
    this.user = user;
  }

  public DrugDirections getDirection() {
    return direction;
  }

  public void setDirection(DrugDirections direction) {
    this.direction = direction;
  }
}
