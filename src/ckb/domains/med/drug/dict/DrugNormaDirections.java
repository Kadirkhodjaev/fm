package ckb.domains.med.drug.dict;

import ckb.domains.GenId;

import javax.persistence.*;

@Entity
@Table(name = "Drug_s_Norma_Directions")
public class DrugNormaDirections extends GenId {

  @OneToOne @JoinColumn private DrugNormas doc;

  @OneToOne @JoinColumn private DrugDirections direction;

  @Column private Double norma;

  public DrugNormas getDoc() {
    return doc;
  }

  public void setDoc(DrugNormas doc) {
    this.doc = doc;
  }

  public DrugDirections getDirection() {
    return direction;
  }

  public void setDirection(DrugDirections direction) {
    this.direction = direction;
  }

  public Double getNorma() {
    return norma;
  }

  public void setNorma(Double norma) {
    this.norma = norma;
  }
}
