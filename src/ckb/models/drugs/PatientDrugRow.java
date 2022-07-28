package ckb.models.drugs;

import ckb.domains.med.drug.DrugActDrugs;
import ckb.domains.med.drug.dict.DrugMeasures;
import ckb.domains.med.drug.dict.Drugs;

public class PatientDrugRow {

  private Integer id;
  private DrugActDrugs actDrug;
  private Drugs drug;
  private String source;
  private String name;
  private Double saldo;
  private Double expanse;
  private String state;
  private DrugMeasures measure;
  private String conDate;

  public Integer getId() {
    return id;
  }

  public void setId(Integer id) {
    this.id = id;
  }

  public DrugActDrugs getActDrug() {
    return actDrug;
  }

  public void setActDrug(DrugActDrugs actDrug) {
    this.actDrug = actDrug;
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

  public Double getSaldo() {
    return saldo;
  }

  public void setSaldo(Double saldo) {
    this.saldo = saldo;
  }

  public Double getExpanse() {
    return expanse;
  }

  public void setExpanse(Double expanse) {
    this.expanse = expanse;
  }

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
  }

  public String getConDate() {
    return conDate;
  }

  public void setConDate(String conDate) {
    this.conDate = conDate;
  }

  public DrugMeasures getMeasure() {
    return measure;
  }

  public void setMeasure(DrugMeasures measure) {
    this.measure = measure;
  }
}
