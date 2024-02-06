package ckb.domains.print;

import ckb.domains.GenId;

import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "Print_Pages")
public class PrintPages extends GenId {

  private String typeCode;
  private String name;
  private String url;

  public String getTypeCode() {
    return typeCode;
  }

  public void setTypeCode(String typeCode) {
    this.typeCode = typeCode;
  }

  public String getUrl() {
    return url;
  }

  public void setUrl(String url) {
    this.url = url;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }
}
