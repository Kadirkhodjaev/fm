package ckb.models.eat;

import ckb.models.PatientList;

import java.util.ArrayList;
import java.util.List;

public class EatMenuTable {

  private Integer id;
  private String name;
  private List<EatMenuTableEat> eats = new ArrayList<EatMenuTableEat>();
  private List<PatientList> patients = new ArrayList<PatientList>();
  private String eatJson;

  public Integer getId() {
    return id;
  }

  public void setId(Integer id) {
    this.id = id;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public List<EatMenuTableEat> getEats() {
    return eats;
  }

  public void setEats(List<EatMenuTableEat> eats) {
    this.eats = eats;
  }

  public String getEatJson() {
    return eatJson;
  }

  public void setEatJson(String eatJson) {
    this.eatJson = eatJson;
  }

  public List<PatientList> getPatients() {
    return patients;
  }

  public void setPatients(List<PatientList> patients) {
    this.patients = patients;
  }
}
