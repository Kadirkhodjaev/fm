package ckb.domains.med.eat;

import ckb.domains.GenId;
import ckb.domains.med.eat.dict.Eats;

import javax.persistence.*;

@Entity
@Table(name = "Eat_Menu_Template_Rows")
public class EatMenuTemplateRows extends GenId {

  @Column private Integer templateId;
  @OneToOne @JoinColumn private Eats eat;

  public Integer getTemplateId() {
    return templateId;
  }

  public void setTemplateId(Integer templateId) {
    this.templateId = templateId;
  }

  public Eats getEat() {
    return eat;
  }

  public void setEat(Eats eat) {
    this.eat = eat;
  }
}
