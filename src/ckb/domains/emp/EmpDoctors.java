package ckb.domains.emp;

import ckb.domains.GenId;
import ckb.domains.admin.Users;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "Emp_Doctors")
public class EmpDoctors extends GenId {

  @OneToOne @JoinColumn private Emps emp;
  @OneToOne @JoinColumn private Users doctor;

  @Column private Integer crBy;
  @Column private Date crOn;

  public Emps getEmp() {
    return emp;
  }

  public void setEmp(Emps emp) {
    this.emp = emp;
  }

  public Users getDoctor() {
    return doctor;
  }

  public void setDoctor(Users doctor) {
    this.doctor = doctor;
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
}
