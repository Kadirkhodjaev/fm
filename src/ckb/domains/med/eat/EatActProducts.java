package ckb.domains.med.eat;

import ckb.domains.GenId;
import ckb.domains.med.eat.dict.EatProducts;

import javax.persistence.*;

@Entity
@Table(name = "Eat_Act_Products")
public class EatActProducts extends GenId {

  @OneToOne @JoinColumn private EatActs act;
  @OneToOne @JoinColumn private EatProducts product;

  @Column private Double price;
  @Column private Double amout;

  @Column private Double rasxod;

  public EatActs getAct() {
    return act;
  }

  public void setAct(EatActs act) {
    this.act = act;
  }

  public EatProducts getProduct() {
    return product;
  }

  public void setProduct(EatProducts product) {
    this.product = product;
  }

  public Double getPrice() {
    return price;
  }

  public void setPrice(Double price) {
    this.price = price;
  }

  public Double getAmout() {
    return amout;
  }

  public void setAmout(Double amout) {
    this.amout = amout;
  }

  public Double getRasxod() {
    return rasxod;
  }

  public void setRasxod(Double rasxod) {
    this.rasxod = rasxod;
  }
}
