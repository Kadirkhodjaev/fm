package ckb.domains.admin;

import ckb.domains.GenId;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "Nurses")
public class Nurses extends GenId {

  @Column(name = "Fio", length = 256, nullable = false)
  private String fio;

  @Column(name = "Login", length = 32, unique = true)
  private String login;

  @Column(name = "Password", length = 32)
  private String password;

  @Column(name = "Description", length = 512)
  private String description;

  @Column(name = "Active")
  private boolean active;

  public String getFio() {
    return fio;
  }

  public void setFio(String fio) {
    this.fio = fio;
  }

  public String getLogin() {
    return login;
  }

  public void setLogin(String login) {
    this.login = login;
  }

  public String getPassword() {
    return password;
  }

  public void setPassword(String password) {
    this.password = password;
  }

  public String getDescription() {
    return description;
  }

  public void setDescription(String description) {
    this.description = description;
  }

  public boolean isActive() {
    return active;
  }

  public void setActive(boolean active) {
    this.active = active;
  }
}
