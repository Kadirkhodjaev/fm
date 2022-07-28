package ckb.domains.med.cash;

import ckb.domains.GenId;

import javax.persistence.*;

@Entity
@Table(name = "Cash_Oper_Details")
public class CashOperDetails extends GenId {

  @OneToOne @JoinColumn private CashOpers oper;
  @Column private Integer patientId;

  @Column private String link_type;
  @Column private Integer link_id;

  

}
