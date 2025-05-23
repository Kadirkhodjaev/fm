package ckb.domains.med.amb;

import ckb.domains.GenId;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "Amb_Groups")
public class AmbGroups extends GenId {

  @Column private String name;
  @Column private boolean isGroup;
  @Column private boolean isFizio;
  @Column private boolean active;
  @Column private Double partnerProc;
  @Column private Double bonusProc;
  @Column private Double empProc;

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public boolean isFizio() {
    return isFizio;
  }

  public void setFizio(boolean fizio) {
    isFizio = fizio;
  }

  public boolean isGroup() {
    return isGroup;
  }

  public void setGroup(boolean group) {
    isGroup = group;
  }

  public boolean isActive() {
    return active;
  }

  public void setActive(boolean active) {
    this.active = active;
  }

  public Double getPartnerProc() {
    return partnerProc;
  }

  public void setPartnerProc(Double partnerProc) {
    this.partnerProc = partnerProc;
  }

  public Double getBonusProc() {
    return bonusProc;
  }

  public void setBonusProc(Double bonusProc) {
    this.bonusProc = bonusProc;
  }

  public Double getEmpProc() {
    return empProc;
  }

  public void setEmpProc(Double empProc) {
    this.empProc = empProc;
  }
}
