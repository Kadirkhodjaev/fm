package ckb.domains.med.drug.dict;

import ckb.domains.GenId;

import javax.persistence.*;

@Entity
@Table(name = "Drug_s_Normas")
public class DrugNormas extends GenId {

  @OneToOne @JoinColumn private Drugs drug;
  @Column private String normaType;

  @Column private Double norma;
  @Column private Double tab;
  @Column private Double proc;
  @Column private Double maxval;

  public Drugs getDrug() {
    return drug;
  }

  public void setDrug(Drugs drug) {
    this.drug = drug;
  }

  public String getNormaType() {
    return normaType;
  }

  public void setNormaType(String normaType) {
    this.normaType = normaType;
  }

  public Double getNorma() {
    return norma;
  }

  public void setNorma(Double norma) {
    this.norma = norma;
  }

  public Double getTab() {
    return tab;
  }

  public Double getMaxval() {
    return maxval;
  }

  public void setMaxval(Double maxval) {
    this.maxval = maxval;
  }

  public void setTab(Double tab) {
    this.tab = tab;
  }

  public Double getProc() {
    return proc;
  }

  public void setProc(Double proc) {
    this.proc = proc;
  }

}
