package ckb.domains.med.exp.dict;

import ckb.domains.GenId;
import ckb.domains.admin.Dicts;

import javax.persistence.*;

@Entity
@Table(name = "Exp_s_Measures")
public class ExpMeasures  extends GenId {

  @OneToOne @JoinColumn private Dicts cat;
  @Column(unique = true) private String code;
  @Column private String name;
  @Column private int ord;
  @Column private String state;

  public Dicts getCat() {
    return cat;
  }

  public void setCat(Dicts cat) {
    this.cat = cat;
  }

  public String getCode() {
    return code;
  }

  public void setCode(String code) {
    this.code = code;
  }

  public int getOrd() {
    return ord;
  }

  public void setOrd(int ord) {
    this.ord = ord;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
  }
}
