package ckb.models.reports;

import ckb.models.ObjList;

import java.util.List;

public class Rep1 {

  private String groupName;
  private List<ObjList> services;
  private Integer counter;

  public String getGroupName() {
    return groupName;
  }

  public void setGroupName(String groupName) {
    this.groupName = groupName;
  }

  public List<ObjList> getServices() {
    return services;
  }

  public void setServices(List<ObjList> services) {
    this.services = services;
  }

  public Integer getCounter() {
    return counter;
  }

  public void setCounter(Integer counter) {
    this.counter = counter;
  }
}
