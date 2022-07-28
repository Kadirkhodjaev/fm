package ckb.domains.admin;

import ckb.domains.GenId;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "Params")
public class Params extends GenId {

  // Наименование
  @Column(length = 32)
  private String code;

  // Рабочий адрес роли
  @Column(length = 512)
  private String name;

  // Рабочий адрес роли
  @Column(length = 512)
  private String val;

  public String getCode() {
    return code;
  }

  public void setCode(String code) {
    this.code = code;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getVal() {
    return val;
  }

  public void setVal(String val) {
    this.val = val;
  }
}
