package ckb.domains.med.eat.dict;

import ckb.domains.GenId;

import javax.persistence.*;

@Entity
@Table(name = "Eat_s_Norms")
public class EatNorms extends GenId {

  @OneToOne @JoinColumn private Eats eat;
  @OneToOne @JoinColumn private EatProducts product;

  @Column private Double rasxod;
  @OneToOne @JoinColumn private EatMeasures measure;

  public Eats getEat() {
    return eat;
  }

  public void setEat(Eats eat) {
    this.eat = eat;
  }

  public EatProducts getProduct() {
    return product;
  }

  public void setProduct(EatProducts product) {
    this.product = product;
  }

  public Double getRasxod() {
    return rasxod;
  }

  public void setRasxod(Double rasxod) {
    this.rasxod = rasxod;
  }

  public EatMeasures getMeasure() {
    return measure;
  }

  public void setMeasure(EatMeasures measure) {
    this.measure = measure;
  }
}
