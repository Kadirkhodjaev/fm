package ckb.domains.admin;

import ckb.domains.GenId;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import java.util.Date;

@Entity
@Table(name = "Sale_Packs")
public class SalePacks extends GenId {

  @Column private String name;
  @Column private String text;
  @Column private String ambStat = "STAT";
  @Column private Double price;
  @Column private Double ndsProc;

  @Column private Date start;
  @Column private Date end;

  @Column private String state;

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getText() {
    return text;
  }

  public void setText(String text) {
    this.text = text;
  }

  public Double getPrice() {
    return price;
  }

  public void setPrice(Double price) {
    this.price = price;
  }

  public Date getStart() {
    return start;
  }

  public void setStart(Date start) {
    this.start = start;
  }

  public Date getEnd() {
    return end;
  }

  public void setEnd(Date end) {
    this.end = end;
  }

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
  }

  public String getAmbStat() {
    return ambStat;
  }

  public void setAmbStat(String ambStat) {
    this.ambStat = ambStat;
  }

  public Double getNdsProc() {
    return ndsProc;
  }

  public void setNdsProc(Double ndsProc) {
    this.ndsProc = ndsProc;
  }
}
