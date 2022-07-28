package ckb.domains.med.lv;

import ckb.domains.GenId;
import ckb.domains.med.dicts.Rooms;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Lv_Epics")
public class LvEpics extends GenId {

  // ID Пациента
  @Column private Integer patientId;
  @Column private Date dateBegin;
  @Column private Date dateEnd;
  @Column private Integer deptId;
  @Column private String palata;
  @Column private Integer lvId;
  // № палаты
  @OneToOne @JoinColumn private Rooms room;

  @Column private Double price;
  @Column private Integer koyko;

  public Rooms getRoom() {
    return room;
  }

  public void setRoom(Rooms room) {
    this.room = room;
  }

  public Integer getPatientId() {
    return patientId;
  }

  public void setPatientId(Integer patientId) {
    this.patientId = patientId;
  }

  public Date getDateBegin() {
    return dateBegin;
  }

  public void setDateBegin(Date dateBegin) {
    this.dateBegin = dateBegin;
  }

  public Date getDateEnd() {
    return dateEnd;
  }

  public void setDateEnd(Date dateEnd) {
    this.dateEnd = dateEnd;
  }

  public Integer getDeptId() {
    return deptId;
  }

  public void setDeptId(Integer deptId) {
    this.deptId = deptId;
  }

  public String getPalata() {
    return palata;
  }

  public void setPalata(String palata) {
    this.palata = palata;
  }

  public Integer getLvId() {
    return lvId;
  }

  public void setLvId(Integer lvId) {
    this.lvId = lvId;
  }

  public Double getPrice() {
    return price;
  }

  public void setPrice(Double price) {
    this.price = price;
  }

  public Integer getKoyko() {
    return koyko;
  }

  public void setKoyko(Integer koyko) {
    this.koyko = koyko;
  }

}
