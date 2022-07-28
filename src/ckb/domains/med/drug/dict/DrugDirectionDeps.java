package ckb.domains.med.drug.dict;

import ckb.domains.GenId;
import ckb.domains.admin.Depts;

import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

@Entity
@Table(name = "Drug_s_Direction_Deps")
public class DrugDirectionDeps extends GenId {

  @OneToOne @JoinColumn private DrugDirections direction;
  @OneToOne @JoinColumn private Depts dept;

  public DrugDirections getDirection() {
    return direction;
  }

  public void setDirection(DrugDirections direction) {
    this.direction = direction;
  }

  public Depts getDept() {
    return dept;
  }

  public void setDept(Depts dept) {
    this.dept = dept;
  }
}
