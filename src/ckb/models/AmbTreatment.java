package ckb.models;

import ckb.domains.admin.Users;

import java.util.List;

public class AmbTreatment {

  private Integer id;
  private Integer service;
  private String name;
  private Integer worker;
  private String workerFio;
  private String saved;
  private List<AmbTreatmentDate> dates;
  private List<Users> users;

  public Integer getId() {
    return id;
  }

  public void setId(Integer id) {
    this.id = id;
  }

  public Integer getService() {
    return service;
  }

  public void setService(Integer service) {
    this.service = service;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public Integer getWorker() {
    return worker;
  }

  public void setWorker(Integer worker) {
    this.worker = worker;
  }

  public String getWorkerFio() {
    return workerFio;
  }

  public void setWorkerFio(String workerFio) {
    this.workerFio = workerFio;
  }

  public String getSaved() {
    return saved;
  }

  public void setSaved(String saved) {
    this.saved = saved;
  }

  public List<AmbTreatmentDate> getDates() {
    return dates;
  }

  public void setDates(List<AmbTreatmentDate> dates) {
    this.dates = dates;
  }

  public List<Users> getUsers() {
    return users;
  }

  public void setUsers(List<Users> users) {
    this.users = users;
  }
}
