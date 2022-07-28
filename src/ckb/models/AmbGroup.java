package ckb.models;

import ckb.domains.med.amb.AmbGroups;
import ckb.domains.med.amb.AmbServices;

import java.util.List;

public class AmbGroup {

  private AmbGroups group;
  private List<AmbServices> services;

  public AmbGroups getGroup() {
    return group;
  }

  public void setGroup(AmbGroups group) {
    this.group = group;
  }

  public List<AmbServices> getServices() {
    return services;
  }

  public void setServices(List<AmbServices> services) {
    this.services = services;
  }
}
