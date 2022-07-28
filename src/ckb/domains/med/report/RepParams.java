package ckb.domains.med.report;

import ckb.domains.GenId;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "Rep_Params")
public class RepParams extends GenId {

  @Column private Integer repId;
  @Column private String label;
  @Column private String type;
  @Column private String selectSql;
  @Column private String date_type;
  @Column private String name;
  @Column private Boolean required = false;

  public Integer getRepId() {
    return repId;
  }

  public void setRepId(Integer repId) {
    this.repId = repId;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getType() {
    return type;
  }

  public void setType(String type) {
    this.type = type;
  }

  public String getSelectSql() {
    return selectSql;
  }

  public void setSelectSql(String selectSql) {
    this.selectSql = selectSql;
  }

  public String getLabel() {
    return label;
  }

  public void setLabel(String label) {
    this.label = label;
  }

  public String getDate_type() {
    return date_type;
  }

  public void setDate_type(String date_type) {
    this.date_type = date_type;
  }

  public Boolean getRequired() {
    return required;
  }

  public void setRequired(Boolean required) {
    this.required = required;
  }
}
