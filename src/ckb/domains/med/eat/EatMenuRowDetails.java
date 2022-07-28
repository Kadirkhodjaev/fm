package ckb.domains.med.eat;

import ckb.domains.GenId;
import ckb.domains.med.eat.dict.EatMeasures;
import ckb.domains.med.eat.dict.EatProducts;

import javax.persistence.*;

@Entity
@Table(name = "Eat_Menu_Row_Details")
public class EatMenuRowDetails extends GenId {

  @OneToOne @JoinColumn private EatMenuRows eatMenuRow;
  @OneToOne @JoinColumn private EatProducts product;

  @Column private Double rasxod;
  @OneToOne @JoinColumn private EatMeasures measure;

  public EatMenuRows getEatMenuRow() {
    return eatMenuRow;
  }

  public void setEatMenuRow(EatMenuRows eatMenuRow) {
    this.eatMenuRow = eatMenuRow;
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
