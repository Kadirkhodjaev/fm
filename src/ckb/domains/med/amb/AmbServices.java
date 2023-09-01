package ckb.domains.med.amb;

import ckb.domains.GenId;

import javax.persistence.*;

@Entity
@Table(name = "Amb_Services")
public class AmbServices extends GenId {

  @OneToOne @JoinColumn private AmbGroups group;
  @Column private String name;
  @Column private Double price;
  @Column private Double for_price;
  @Column private String state;
  @Column private String consul = "N";
  @Column private String diagnoz = "Y";
  //
  @Column private Integer form_id;
  @Column private String ei;
  @Column private String normaFrom;
  @Column private String normaTo;
  @Column private int ord = 99;

  public AmbGroups getGroup() {
    return group;
  }

  public void setGroup(AmbGroups group) {
    this.group = group;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
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

  public Double getFor_price() {
    return for_price;
  }

  public void setFor_price(Double for_price) {
    this.for_price = for_price;
  }

  public String getConsul() {
    return consul;
  }

  public void setConsul(String consul) {
    this.consul = consul;
  }

  public String getDiagnoz() {
    return diagnoz;
  }

  public void setDiagnoz(String diagnoz) {
    this.diagnoz = diagnoz;
  }

  public Integer getForm_id() {
    return form_id;
  }

  public void setForm_id(Integer form_id) {
    this.form_id = form_id;
  }

  public String getEi() {
    return ei;
  }

  public void setEi(String ei) {
    this.ei = ei;
  }

  public String getNormaFrom() {
    return normaFrom;
  }

  public void setNormaFrom(String normaFrom) {
    this.normaFrom = normaFrom;
  }

  public String getNormaTo() {
    return normaTo;
  }

  public void setNormaTo(String normaTo) {
    this.normaTo = normaTo;
  }

  public int getOrd() {
    return ord;
  }

  public void setOrd(int ord) {
    this.ord = ord;
  }
}
