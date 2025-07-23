package ckb.domains.admin;

import ckb.domains.GenId;
import ckb.domains.med.amb.AmbPatients;
import ckb.session.Session;

import javax.persistence.*;

@Entity
@Table(name = "Sale_Pack_Rows")
public class SalePackRows extends GenId {

  @OneToOne @JoinColumn private SalePacks doc;

  @Column private Integer service;

  @Column private Double price;
  @Column private Double proc;

  public SalePacks getDoc() {
    return doc;
  }

  public void setDoc(SalePacks kdoPackage) {
    this.doc = kdoPackage;
  }

  public Integer getService() {
    return service;
  }

  public void setService(Integer service) {
    this.service = service;
  }

  public Double getPrice() {
    return price;
  }

  public Double getPrice(AmbPatients pat, Session session) {
    double non_proc = pat.isResident() ? 0 : Double.parseDouble(session.getParam("NONRESIDENT_PROC"));
    return price + price * non_proc / 100;
  }

  public void setPrice(Double price) {
    this.price = price;
  }

  public Double getProc() {
    return proc;
  }

  public void setProc(Double proc) {
    this.proc = proc;
  }
}
