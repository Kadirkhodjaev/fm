package ckb.domains.med.head_nurse;

import ckb.domains.GenId;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "Hn_Oper_Rows")
public class HNOperRows extends GenId {

  @Column private Integer transfer;
  @Column private Integer transfer_hn_drug_id;

  public Integer getTransfer() {
    return transfer;
  }

  public void setTransfer(Integer transfer) {
    this.transfer = transfer;
  }

  public Integer getTransfer_hn_drug_id() {
    return transfer_hn_drug_id;
  }

  public void setTransfer_hn_drug_id(Integer transfer_hn_drug_id) {
    this.transfer_hn_drug_id = transfer_hn_drug_id;
  }
}
