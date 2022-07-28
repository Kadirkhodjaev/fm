package ckb.domains.med.amb;

import ckb.domains.GenId;
import ckb.domains.med.drug.dict.DrugMeasures;
import ckb.domains.med.drug.dict.Drugs;

import javax.persistence.*;

@Entity
@Table(name = "Amb_Drug_Rows")
public class AmbDrugRows extends GenId {

  @OneToOne @JoinColumn private AmbDrugs ambDrug;
  @OneToOne @JoinColumn private Drugs drug;
  @Column private String source;
  @Column private String name;
  @Column private Double rasxod;
  @OneToOne @JoinColumn private DrugMeasures measure;

  public AmbDrugs getAmbDrug() {
    return ambDrug;
  }

  public void setAmbDrug(AmbDrugs ambDrug) {
    this.ambDrug = ambDrug;
  }

  public Drugs getDrug() {
    return drug;
  }

  public void setDrug(Drugs drug) {
    this.drug = drug;
  }

  public String getSource() {
    return source;
  }

  public void setSource(String source) {
    this.source = source;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public Double getRasxod() {
    return rasxod;
  }

  public void setRasxod(Double rasxod) {
    this.rasxod = rasxod;
  }

  public DrugMeasures getMeasure() {
    return measure;
  }

  public void setMeasure(DrugMeasures measure) {
    this.measure = measure;
  }
}
