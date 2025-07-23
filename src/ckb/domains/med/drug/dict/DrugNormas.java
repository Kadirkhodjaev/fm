package ckb.domains.med.drug.dict;

import ckb.domains.GenId;

import javax.persistence.*;

@Entity
@Table(name = "Drug_s_Normas")
public class DrugNormas extends GenId {

  @OneToOne @JoinColumn private Drugs drug;
  @Column private String normaType;

  @Column private Double norma;

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
}
