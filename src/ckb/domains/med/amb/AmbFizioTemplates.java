package ckb.domains.med.amb;

import ckb.domains.GenId;

import javax.persistence.*;

@Entity
@Table(name = "Amb_Fizio_Templates")
public class AmbFizioTemplates extends GenId {

  @OneToOne @JoinColumn private AmbServices service;
  @Column private String code;
  @Column private String template;

  public AmbServices getService() {
    return service;
  }

  public void setService(AmbServices service) {
    this.service = service;
  }

  public String getCode() {
    return code;
  }

  public void setCode(String code) {
    this.code = code;
  }

  public String getTemplate() {
    return template;
  }

  public void setTemplate(String template) {
    this.template = template;
  }
}
