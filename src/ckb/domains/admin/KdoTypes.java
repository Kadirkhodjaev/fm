package ckb.domains.admin;

import ckb.domains.GenId;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "Kdo_Types")
public class KdoTypes extends GenId {

  // Наименование
  @Column(length = 128) private String name;

  @Column private String state = "A";
  @Column private String groupState = "N";

  public String getGroupState() {
    return groupState;
  }

  public void setGroupState(String groupState) {
    this.groupState = groupState;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
  }
}
