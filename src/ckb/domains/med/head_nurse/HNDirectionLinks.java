package ckb.domains.med.head_nurse;

import ckb.domains.GenId;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "HN_Direction_Links")
public class HNDirectionLinks extends GenId {

  @Column private Integer direction;
  @Column private Integer rasxod;

  public Integer getDirection() {
    return direction;
  }

  public void setDirection(Integer direction) {
    this.direction = direction;
  }

  public Integer getRasxod() {
    return rasxod;
  }

  public void setRasxod(Integer rasxod) {
    this.rasxod = rasxod;
  }
}
