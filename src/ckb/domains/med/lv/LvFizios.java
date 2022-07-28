package ckb.domains.med.lv;

import ckb.domains.GenId;
import ckb.domains.admin.Kdos;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Lv_Fizios")
public class LvFizios extends GenId {

  @Column private Integer patientId;
  // ÀÓ„
  @Column private Integer userId;
  @Column private Date actDate;

  @OneToOne
  @JoinColumn(name = "Kdo_Id")
  private Kdos kdo;

  @Column private String oblast;
  @Column private String comment;
  @Column private Integer count;
  @Column private Double price;
  @Column private String paid;
  @Column private Date payDate;
  @Column private Double paidSum;
  @Column private Integer paidCount;

  public Integer getPatientId() {
    return patientId;
  }

  public void setPatientId(Integer patientId) {
    this.patientId = patientId;
  }

  public Integer getUserId() {
    return userId;
  }

  public void setUserId(Integer userId) {
    this.userId = userId;
  }

  public Date getActDate() {
    return actDate;
  }

  public void setActDate(Date actDate) {
    this.actDate = actDate;
  }

  public Kdos getKdo() {
    return kdo;
  }

  public void setKdo(Kdos kdo) {
    this.kdo = kdo;
  }

  public String getComment() {
    return comment;
  }

  public void setComment(String comment) {
    this.comment = comment;
  }

  public Integer getCount() {
    return count;
  }

  public void setCount(Integer count) {
    this.count = count;
  }

  public String getOblast() {
    return oblast;
  }

  public void setOblast(String oblast) {
    this.oblast = oblast;
  }

  public Double getPrice() {
    return price;
  }

  public void setPrice(Double price) {
    this.price = price;
  }

  public String getPaid() {
    return paid;
  }

  public void setPaid(String paid) {
    this.paid = paid;
  }

  public Date getPayDate() {
    return payDate;
  }

  public void setPayDate(Date payDate) {
    this.payDate = payDate;
  }

  public Double getPaidSum() {
    return paidSum;
  }

  public void setPaidSum(Double paidSum) {
    this.paidSum = paidSum;
  }

  public Integer getPaidCount() {
    return paidCount;
  }

  public void setPaidCount(Integer paidCount) {
    this.paidCount = paidCount;
  }
}
