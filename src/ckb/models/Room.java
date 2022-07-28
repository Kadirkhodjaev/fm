package ckb.models;

import java.util.List;

public class Room {
  private Integer id;
  private String num;
  private String type;
  private String stage;
  private String next_tr = "N";
  private List<ObjList> patients;
  private String access = "N";
  private String limit;
  private String state;

  public Integer getId() {
    return id;
  }

  public void setId(Integer id) {
    this.id = id;
  }

  public String getNum() {
    return num;
  }

  public void setNum(String num) {
    this.num = num;
  }

  public String getType() {
    return type;
  }

  public void setType(String type) {
    this.type = type;
  }

  public String getStage() {
    return stage;
  }

  public void setStage(String stage) {
    this.stage = stage;
  }

  public String getNext_tr() {
    return next_tr;
  }

  public void setNext_tr(String next_tr) {
    this.next_tr = next_tr;
  }

  public List<ObjList> getPatients() {
    return patients;
  }

  public void setPatients(List<ObjList> patients) {
    this.patients = patients;
  }

  public String getAccess() {
    return access;
  }

  public void setAccess(String access) {
    this.access = access;
  }

  public String getLimit() {
    return limit;
  }

  public void setLimit(String limit) {
    this.limit = limit;
  }

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
  }
}
