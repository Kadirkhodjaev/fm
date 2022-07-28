package ckb.domains.med.template;

import ckb.domains.GenId;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "Drug_Templates")
public class DrugTemplates extends GenId {

  @Column private Integer userId;
  @Column private String name;
  @Column private String cat;
  @Column private Integer goal;
  @Column private String doza;

  public Integer getUserId() {
    return userId;
  }

  public void setUserId(Integer userId) {
    this.userId = userId;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getCat() {
    return cat;
  }

  public void setCat(String cat) {
    this.cat = cat;
  }

  public Integer getGoal() {
    return goal;
  }

  public void setGoal(Integer goal) {
    this.goal = goal;
  }

  public String getDoza() {
    return doza;
  }

  public void setDoza(String doza) {
    this.doza = doza;
  }
}
