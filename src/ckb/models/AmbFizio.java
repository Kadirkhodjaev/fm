package ckb.models;

import ckb.domains.med.amb.AmbFizioDates;
import ckb.domains.med.amb.AmbPatientServices;

import java.util.List;

public class AmbFizio {

  private AmbPatientServices fizio;
  private String name;
  private String oblast;
  private String comment;
  private List<AmbFizioDates> dates;

  public AmbPatientServices getFizio() {
    return fizio;
  }

  public void setFizio(AmbPatientServices fizio) {
    this.fizio = fizio;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getOblast() {
    return oblast;
  }

  public void setOblast(String oblast) {
    this.oblast = oblast;
  }

  public String getComment() {
    return comment;
  }

  public void setComment(String comment) {
    this.comment = comment;
  }

  public List<AmbFizioDates> getDates() {
    return dates;
  }

  public void setDates(List<AmbFizioDates> dates) {
    this.dates = dates;
  }
}
