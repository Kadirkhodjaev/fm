package ckb.domains.med.drug.dict;

import ckb.domains.GenId;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.util.Date;

@Entity
@Table(name = "Drug_s_Measures")
public class DrugMeasures extends GenId {

  @Column
  private String name;
  @Column
  private String state;

  @Column
  private Integer crBy;
  @Column
  private Date crOn;

  @Column private boolean incomeFlag;

  public boolean isIncomeFlag() {
    return incomeFlag;
  }

  public void setIncomeFlag(boolean incomeFlag) {
    this.incomeFlag = incomeFlag;
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

  public Integer getCrBy() {
    return crBy;
  }

  public void setCrBy(Integer crBy) {
    this.crBy = crBy;
  }

  public Date getCrOn() {
    return crOn;
  }

  public void setCrOn(Date crOn) {
    this.crOn = crOn;
  }
}
