package ckb.domains.admin;

import ckb.domains.GenId;

import javax.persistence.*;

@Entity
@Table(name = "User_Ips")
public class UserIps extends GenId {

  @OneToOne @JoinColumn private Users user;
  @Column private String ip;

  public Users getUser() {
    return user;
  }

  public void setUser(Users user) {
    this.user = user;
  }

  public String getIp() {
    return ip;
  }

  public void setIp(String ip) {
    this.ip = ip;
  }
}
