package ckb.domains.med.eat;

import ckb.domains.GenId;
import ckb.domains.med.eat.dict.EatMenuTypes;

import javax.persistence.*;

@Entity
@Table(name = "Eat_Claims")
public class EatClaims extends GenId {

  @OneToOne @JoinColumn private EatMenuTypes menuType;
  @OneToOne @JoinColumn private EatMenus menu;
  @Column private String state;

  public EatMenuTypes getMenuType() {
    return menuType;
  }

  public void setMenuType(EatMenuTypes menuType) {
    this.menuType = menuType;
  }

  public EatMenus getMenu() {
    return menu;
  }

  public void setMenu(EatMenus menu) {
    this.menu = menu;
  }

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
  }
}
