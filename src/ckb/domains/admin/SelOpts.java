package ckb.domains.admin;


import ckb.domains.GenId;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "Sel_Opts")
public class SelOpts extends GenId {
  @Column(length = 1024)
  private String name;

  private String state = "A";

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
