package ckb.domains.med.eat;

import ckb.domains.GenId;
import ckb.domains.med.eat.dict.EatMenuTypes;
import ckb.domains.med.eat.dict.EatTables;
import ckb.domains.med.eat.dict.Eats;

import javax.persistence.*;

@Entity
@Table(name = "Eat_Menu_Rows")
public class EatMenuRows extends GenId {

  @OneToOne @JoinColumn private EatMenus menu;
  @OneToOne @JoinColumn private EatTables table;
  @OneToOne @JoinColumn private EatMenuTypes menuType;
  @OneToOne @JoinColumn private Eats eat;

  public EatMenus getMenu() {
    return menu;
  }

  public void setMenu(EatMenus menu) {
    this.menu = menu;
  }

  public EatTables getTable() {
    return table;
  }

  public void setTable(EatTables table) {
    this.table = table;
  }

  public Eats getEat() {
    return eat;
  }

  public void setEat(Eats eat) {
    this.eat = eat;
  }

  public EatMenuTypes getMenuType() {
    return menuType;
  }

  public void setMenuType(EatMenuTypes menuType) {
    this.menuType = menuType;
  }
}
