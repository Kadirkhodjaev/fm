package ckb.domains.med.patient;

import ckb.domains.GenId;
import ckb.domains.admin.Dicts;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Patient_Watchers")
public class PatientWatchers extends GenId {

  @Column private Integer patient_id;
  @Column private Integer dayCount;
  @OneToOne @JoinColumn(name = "type_id") private Dicts type;
  @Column private Double price;
  @Column private Double ndsProc;
  @Column private Double nds;
  @Column private Double total;
  @Column private String state;
  @Column private Integer crBy;
  @Column private Date crOn;

  public Integer getPatient_id() {
    return patient_id;
  }

  public void setPatient_id(Integer patient_id) {
    this.patient_id = patient_id;
  }

  public Integer getDayCount() {
    return dayCount;
  }

  public void setDayCount(Integer dayCount) {
    this.dayCount = dayCount;
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

  public Double getTotal() {
    return total;
  }

  public void setTotal(Double total) {
    this.total = total;
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

  public Dicts getType() {
    return type;
  }

  public void setType(Dicts type) {
    this.type = type;
  }

  public Double getNdsProc() {
    return ndsProc == null ? 0 : ndsProc;
  }

  public void setNdsProc(Double ndsProc) {
    this.ndsProc = ndsProc;
  }

  public Double getNds() {
    return nds == null ? 0 : nds;
  }

  public void setNds(Double nds) {
    this.nds = nds;
  }
}
