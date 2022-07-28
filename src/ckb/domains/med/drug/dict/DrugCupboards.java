package ckb.domains.med.drug.dict;

import ckb.domains.GenId;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Drug_s_Cupboards")
public class DrugCupboards extends GenId {

  @OneToOne
  @JoinColumn
  private DrugStorages storage;
  @Column
  private String name;
  @Column
  private String state;

  @Column
  private Integer crBy;
  @Column
  private Date crOn;

  public DrugStorages getStorage() {
    return storage;
  }

  public void setStorage(DrugStorages storage) {
    this.storage = storage;
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
