package ckb.domains.med.amb;


import ckb.domains.GenId;
import ckb.domains.admin.Users;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Amb_Patient_Services")
public class AmbPatientServices extends GenId {

  @Column private Integer patient;
  @OneToOne @JoinColumn private AmbServices service;
  @Column private Double price;
  @Column private String state;
  @Column private String msg;
  @OneToOne @JoinColumn private Users worker;
  @Column private Integer result;
  @Column private Date confDate;
  @Column private String amb_repeat = "N";
  @Column private String diagnoz = "";

  @Column private Integer pay;

  @Column private Integer crBy;
  @Column private Date crOn;
  @Column private Date cashDate;

  public Integer getPatient() {
    return patient;
  }

  public void setPatient(Integer patient) {
    this.patient = patient;
  }

  public AmbServices getService() {
    return service;
  }

  public void setService(AmbServices service) {
    this.service = service;
  }

  public Double getPrice() {
    return price;
  }

  public void setPrice(Double price) {
    this.price = price;
  }

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
  }

  public Integer getCrBy() {
    return crBy;
  }

  public void setCrBy(Integer crBy) {
    this.crBy = crBy;
  }

  public Date getCrOn() {
    return crOn;
  }

  public void setCrOn(Date crOn) {
    this.crOn = crOn;
  }

  public Users getWorker() {
    return worker;
  }

  public void setWorker(Users worker) {
    this.worker = worker;
  }

  public Integer getResult() {
    return result;
  }

  public void setResult(Integer result) {
    this.result = result;
  }

  public Date getConfDate() {
    return confDate;
  }

  public void setConfDate(Date confDate) {
    this.confDate = confDate;
  }

  public String getMsg() {
    return msg;
  }

  public void setMsg(String msg) {
    this.msg = msg;
  }

  public String getAmb_repeat() {
    return amb_repeat;
  }

  public void setAmb_repeat(String amb_repeat) {
    this.amb_repeat = amb_repeat;
  }

  public String getDiagnoz() {
    return diagnoz;
  }

  public void setDiagnoz(String diagnoz) {
    this.diagnoz = diagnoz;
  }

  public Date getCashDate() {
    return cashDate;
  }

  public void setCashDate(Date cashDate) {
    this.cashDate = cashDate;
  }

  public Integer getPay() {
    return pay;
  }

  public void setPay(Integer pay) {
    this.pay = pay;
  }

  public boolean isClosed() {
    return "DONE".equals(state) || "DEL".equals(state) || "AUTO_DEL".equals(state);
  }

  public boolean canRepeat() {
    return "DONE".equals(state) && "Y".equals(service.getConsul()) && !"D".equals(amb_repeat) && !"Y".equals(amb_repeat);
  }

  public boolean isNoResult() {
    return result == null || result == 0;
  }
}
