package ckb.domains.med.eat;

import ckb.domains.GenId;
import ckb.domains.med.eat.dict.EatMenuTypes;
import ckb.domains.med.eat.dict.EatTables;

import javax.persistence.*;

@Entity
@Table(name = "Eat_Menu_Templates")
public class EatMenuTemplates extends GenId {

  @Column private String name;
  @OneToOne @JoinColumn private EatMenuTypes menuType;
  @OneToOne @JoinColumn private EatTables table;

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
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
}
