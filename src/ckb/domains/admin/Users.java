package ckb.domains.admin;

import ckb.domains.GenId;

import javax.persistence.*;
import java.util.List;

@Entity
@Table(name = "Users")
public class Users extends GenId {

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

  @Column(name = "Lv")
  private boolean lv;

  @Column(name = "Consul")
  private boolean consul;

  @Column(name = "zavlv")
  private boolean zavlv = false;

  @Column private boolean glavbuh = false;

  @OneToOne
  @JoinColumn(name="Dept_Id")
  private Depts dept;

  @ManyToMany(fetch = FetchType.EAGER)
  @JoinTable(name="User_Roles")
  private List<Roles> roles;

  @ManyToMany
  @JoinTable(name="User_Reports")
  private List<Reports> reports;

  @ManyToMany
  @JoinTable(name="User_Kdo_Types")
  private List<KdoTypes> kdoTypes;

  @Column(name = "profil")
  private String profil;

  @Column(name = "is_amb_admin")
  private boolean ambAdmin;

  @Column(name = "doc_fizio")
  private boolean docfizio;

  @Column(name = "amb_treatment")
  private boolean ambTreatment;

  @Column private boolean glb = false;
  @Column private boolean boss = false;
  @Column private boolean drugDirection = false;
  @Column private boolean mainNurse = false;
  @Column private boolean statExp = false;
  @Column private boolean procUser = false;
  @Column private boolean needleDoc = false;

  @Column private Double consul_price;
  @Column private Double for_consul_price;

  @Column private Double real_consul_price;
  @Column private Double for_real_consul_price;

  @Column private boolean ambFizio;


  public Double getReal_consul_price() {
    return real_consul_price;
  }

  public void setReal_consul_price(Double real_consul_price) {
    this.real_consul_price = real_consul_price;
  }

  public Double getFor_real_consul_price() {
    return for_real_consul_price;
  }

  public void setFor_real_consul_price(Double for_real_consul_price) {
    this.for_real_consul_price = for_real_consul_price;
  }

  public boolean isAmbFizio() {
    return ambFizio;
  }

  public void setAmbFizio(boolean ambFizio) {
    this.ambFizio = ambFizio;
  }

  public List<KdoTypes> getKdoTypes() {
    return kdoTypes;
  }

  public void setKdoTypes(List<KdoTypes> kdoTypes) {
    this.kdoTypes = kdoTypes;
  }

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

  public Depts getDept() {
    return dept;
  }

  public void setDept(Depts dept) {
    this.dept = dept;
  }

  public List<Roles> getRoles() {
    return roles;
  }

  public void setRoles(List<Roles> roles) {
    this.roles = roles;
  }

  public List<Reports> getReports() {
    return reports;
  }

  public void setReports(List<Reports> reports) {
    this.reports = reports;
  }

  public boolean isConsul() {
    return consul;
  }

  public void setConsul(boolean consul) {
    this.consul = consul;
  }

  public boolean isLv() {
    return lv;
  }

  public void setLv(boolean lv) {
    this.lv = lv;
  }

  public boolean isZavlv() {
    return zavlv;
  }

  public void setZavlv(boolean zavlv) {
    this.zavlv = zavlv;
  }

  public String getProfil() {
    return profil;
  }

  public void setProfil(String profil) {
    this.profil = profil;
  }

  public boolean isAmbAdmin() {
    return ambAdmin;
  }

  public void setAmbAdmin(boolean ambAdmin) {
    this.ambAdmin = ambAdmin;
  }

  public boolean isMainNurse() {
    return mainNurse;
  }

  public void setMainNurse(boolean mainNurse) {
    this.mainNurse = mainNurse;
  }

  public boolean isDrugDirection() {
    return drugDirection;
  }

  public void setDrugDirection(boolean drugDirection) {
    this.drugDirection = drugDirection;
  }

  public boolean isGlb() {
    return glb;
  }

  public void setGlb(boolean glb) {
    this.glb = glb;
  }

  public boolean isBoss() {
    return boss;
  }

  public void setBoss(boolean boss) {
    this.boss = boss;
  }

  public boolean isGlavbuh() {
    return glavbuh;
  }

  public void setGlavbuh(boolean glavbuh) {
    this.glavbuh = glavbuh;
  }

  public Double getConsul_price() {
    return consul_price;
  }

  public void setConsul_price(Double consul_price) {
    this.consul_price = consul_price;
  }

  public Double getFor_consul_price() {
    return for_consul_price;
  }

  public void setFor_consul_price(Double for_consul_price) {
    this.for_consul_price = for_consul_price;
  }

  public boolean isDocfizio() {
    return docfizio;
  }

  public void setDocfizio(boolean docfizio) {
    this.docfizio = docfizio;
  }

  public boolean isProcUser() {
    return procUser;
  }

  public void setProcUser(boolean procUser) {
    this.procUser = procUser;
  }

  public boolean isStatExp() {
    return statExp;
  }

  public void setStatExp(boolean statExp) {
    this.statExp = statExp;
  }

  public boolean isAmbTreatment() {
    return ambTreatment;
  }

  public void setAmbTreatment(boolean ambTreatment) {
    this.ambTreatment = ambTreatment;
  }

  public boolean isNeedleDoc() {
    return needleDoc;
  }

  public void setNeedleDoc(boolean needleDoc) {
    this.needleDoc = needleDoc;
  }
}
