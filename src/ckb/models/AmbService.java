package ckb.models;

import ckb.domains.admin.Users;
import ckb.domains.med.amb.AmbPatientServices;
import ckb.domains.med.amb.AmbResults;
import ckb.domains.med.amb.AmbServices;

import java.util.Date;
import java.util.List;

public class AmbService {

  private Integer id;
  private AmbServices service;
  private Date regDate;
  private Date confDate;
  private Date planDate;
  private String msg;
  private List<AmbPatientServices> services;
  private String price;
  private String nds;
  private Double dnds;
  private Double dprice;
  private String state;
  private String newForm;
  private boolean isToday;
  private boolean isTreatment;
  private boolean canDelete;
  private Users worker;
  private List<Users> users;
  private AmbResults result;
  private Integer resultId;
  private Integer crBy;
  private String pack;
  private Double saleProc;
  private List<FormField> fields;
  private boolean repeat;
  private String c1_name;
  private String c2_name;
  private String c3_name;
  private String c4_name;
  private String c5_name;
  private String c6_name;
  private String c7_name;
  private String c8_name;
  private String c9_name;
  private String c10_name;

  public List<FormField> getFields() {
    return fields;
  }

  public void setFields(List<FormField> fields) {
    this.fields = fields;
  }

  public Integer getId() {
    return id;
  }

  public void setId(Integer id) {
    this.id = id;
  }

  public AmbServices getService() {
    return service;
  }

  public Date getPlanDate() {
    return planDate;
  }

  public void setPlanDate(Date planDate) {
    this.planDate = planDate;
  }

  public void setService(AmbServices service) {
    this.service = service;
  }

  public String getPrice() {
    return price;
  }

  public void setPrice(String price) {
    this.price = price;
  }

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
  }

  public void setWorker(Users worker) {
    this.worker = worker;
  }

  public Users getWorker() {
    return worker;
  }

  public List<Users> getUsers() {
    return users;
  }

  public void setUsers(List<Users> users) {
    this.users = users;
  }

  public AmbResults getResult() {
    return result;
  }

  public void setResult(AmbResults result) {
    this.result = result;
  }

  public String getC1_name() {
    return c1_name;
  }

  public void setC1_name(String c1_name) {
    this.c1_name = c1_name;
  }

  public String getC2_name() {
    return c2_name;
  }

  public void setC2_name(String c2_name) {
    this.c2_name = c2_name;
  }

  public String getC3_name() {
    return c3_name;
  }

  public void setC3_name(String c3_name) {
    this.c3_name = c3_name;
  }

  public String getC4_name() {
    return c4_name;
  }

  public void setC4_name(String c4_name) {
    this.c4_name = c4_name;
  }

  public String getC5_name() {
    return c5_name;
  }

  public void setC5_name(String c5_name) {
    this.c5_name = c5_name;
  }

  public String getC6_name() {
    return c6_name;
  }

  public void setC6_name(String c6_name) {
    this.c6_name = c6_name;
  }

  public String getC7_name() {
    return c7_name;
  }

  public void setC7_name(String c7_name) {
    this.c7_name = c7_name;
  }

  public String getC8_name() {
    return c8_name;
  }

  public void setC8_name(String c8_name) {
    this.c8_name = c8_name;
  }

  public String getC9_name() {
    return c9_name;
  }

  public void setC9_name(String c9_name) {
    this.c9_name = c9_name;
  }

  public String getC10_name() {
    return c10_name;
  }

  public void setC10_name(String c10_name) {
    this.c10_name = c10_name;
  }

  public Date getRegDate() {
    return regDate;
  }

  public void setRegDate(Date regDate) {
    this.regDate = regDate;
  }

  public List<AmbPatientServices> getServices() {
    return services;
  }

  public void setServices(List<AmbPatientServices> services) {
    this.services = services;
  }

  public boolean isRepeat() {
    return repeat;
  }

  public void setRepeat(boolean repeat) {
    this.repeat = repeat;
  }

  public Date getConfDate() {
    return confDate;
  }

  public void setConfDate(Date confDate) {
    this.confDate = confDate;
  }

  public boolean isClosed() {
    return "DONE".equals(state) || "DEL".equals(state) || "AUTO_DEL".equals(state);
  }

  public boolean isCanDelete() {
    return canDelete;
  }

  public void setCanDelete(boolean canDelete) {
    this.canDelete = canDelete;
  }

  public boolean isToday() {
    return isToday;
  }

  public void setToday(boolean today) {
    isToday = today;
  }

  public boolean isTreatment() {
    return isTreatment;
  }

  public void setTreatment(boolean treatment) {
    isTreatment = treatment;
  }

  public Double getDprice() {
    return dprice;
  }

  public void setDprice(Double dprice) {
    this.dprice = dprice;
  }

  public String getMsg() {
    return msg;
  }

  public void setMsg(String msg) {
    this.msg = msg;
  }

  public String getNewForm() {
    return newForm;
  }

  public void setNewForm(String newForm) {
    this.newForm = newForm;
  }

  public String getNds() {
    return nds;
  }

  public void setNds(String nds) {
    this.nds = nds;
  }

  public Double getDnds() {
    return dnds;
  }

  public void setDnds(Double dnds) {
    this.dnds = dnds;
  }

  public Integer getResultId() {
    return resultId;
  }

  public void setResultId(Integer resultId) {
    this.resultId = resultId;
  }

  public Integer getCrBy() {
    return crBy;
  }

  public void setCrBy(Integer crBy) {
    this.crBy = crBy;
  }

  public String getPack() {
    return pack;
  }

  public void setPack(String pack) {
    this.pack = pack;
  }

  public Double getSaleProc() {
    return saleProc;
  }

  public void setSaleProc(Double saleProc) {
    this.saleProc = saleProc;
  }
}
