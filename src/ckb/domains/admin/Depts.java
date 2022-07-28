package ckb.domains.admin;

import ckb.domains.GenId;

import javax.persistence.*;

@Entity
@Table(name = "Depts")
public class Depts extends GenId {
  // Наименование
  @Column(length = 128) private String name;

  // Состояние
  @Column(length = 1) private String state;

  // Старшая медсестра
  @OneToOne @JoinColumn private Users nurse;

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
  }

  public Users getNurse() {
    return nurse;
  }

  public void setNurse(Users nurse) {
    this.nurse = nurse;
  }
}
