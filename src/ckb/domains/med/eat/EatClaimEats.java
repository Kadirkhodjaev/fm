package ckb.domains.med.eat;

import ckb.domains.GenId;
import ckb.domains.med.eat.dict.EatTables;
import ckb.domains.med.eat.dict.Eats;

import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

@Entity
@Table(name = "Eat_Claim_Eats")
public class EatClaimEats extends GenId {

  @OneToOne @JoinColumn private EatClaims claim;
  @OneToOne @JoinColumn private EatTables table;
  @OneToOne @JoinColumn private Eats eat;

  public EatClaims getClaim() {
    return claim;
  }

  public void setClaim(EatClaims claim) {
    this.claim = claim;
  }

  public EatTables getTable() {
    return table;
  }

  public void setTable(EatTables table) {
    this.table = table;
  }

  public Eats getEat() {
    return eat;
  }

  public void setEat(Eats eat) {
    this.eat = eat;
  }
}
