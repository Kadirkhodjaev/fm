package ckb.domains.med.nurse.eat;

import ckb.domains.GenId;
import ckb.domains.admin.Depts;
import ckb.domains.admin.Users;
import ckb.domains.med.eat.dict.EatMenuTypes;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Nurse_Eats")
public class NurseEats extends GenId {

  @Column(name = "act_date") private Date actDate;

  @OneToOne @JoinColumn(name = "menu_type_id") private EatMenuTypes menuType;

  @OneToOne @JoinColumn private Depts dept;

  @OneToOne @JoinColumn(name = "cr_by") private Users crBy;
  @Column(name = "cr_on") private Date crOn;

  @Column(name = "state") private String state;

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

  public Users getCrBy() {
    return crBy;
  }

  public void setCrBy(Users crBy) {
    this.crBy = crBy;
  }

  public Date getCrOn() {
    return crOn;
  }

  public void setCrOn(Date crOn) {
    this.crOn = crOn;
  }

  public Depts getDept() {
    return dept;
  }

  public void setDept(Depts dept) {
    this.dept = dept;
  }

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
  }
}
