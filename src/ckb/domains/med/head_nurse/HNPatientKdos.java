package ckb.domains.med.head_nurse;

import ckb.domains.GenId;
import ckb.domains.admin.Kdos;

import javax.persistence.*;

@Entity
@Table(name = "Hn_Patient_Kdos")
public class HNPatientKdos extends GenId {

  @OneToOne @JoinColumn(name = "hn_patient") private HNPatients parent;
  @OneToOne @JoinColumn private Kdos kdo;

  @Column private String serviceName;
  @Column private int serviceType;
  @Column private Double serviceCount;
  @Column private Double price;
  @Column private Double real_price;

  public HNPatients getParent() {
    return parent;
  }

  public void setParent(HNPatients parent) {
    this.parent = parent;
  }

  public String getServiceName() {
    return serviceName;
  }

  public void setServiceName(String serviceName) {
    this.serviceName = serviceName;
  }

  public int getServiceType() {
    return serviceType;
  }

  public void setServiceType(int serviceType) {
    this.serviceType = serviceType;
  }

  public Double getServiceCount() {
    return serviceCount;
  }

  public void setServiceCount(Double serviceCount) {
    this.serviceCount = serviceCount;
  }

  public Double getPrice() {
    return price;
  }

  public void setPrice(Double price) {
    this.price = price;
  }

  public Kdos getKdo() {
    return kdo;
  }

  public void setKdo(Kdos kdo) {
    this.kdo = kdo;
  }

  public Double getReal_price() {
    return real_price;
  }

  public void setReal_price(Double real_price) {
    this.real_price = real_price;
  }
}
