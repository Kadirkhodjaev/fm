package ckb.domains.print;

import ckb.domains.GenId;

import javax.persistence.*;

@Entity
@Table(name = "Print_Page_Params")
public class PrintPageParams extends GenId {

  @OneToOne @JoinColumn private PrintPages page;

  @Column private String code;

  @Column private String typeCode;

  public PrintPages getPage() {
    return page;
  }

  public void setPage(PrintPages page) {
    this.page = page;
  }

  public String getCode() {
    return code;
  }

  public void setCode(String code) {
    this.code = code;
  }

  public String getTypeCode() {
    return typeCode;
  }

  public void setTypeCode(String typeCode) {
    this.typeCode = typeCode;
  }
}
