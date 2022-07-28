package ckb.models.eat;

import java.util.ArrayList;
import java.util.List;

public class EatMenuType {
  private Integer id;
  private String name;
  private List<EatMenuTable> tables = new ArrayList<EatMenuTable>();

  public Integer getId() {
    return id;
  }

  public void setId(Integer id) {
    this.id = id;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public List<EatMenuTable> getTables() {
    return tables;
  }

  public void setTables(List<EatMenuTable> tables) {
    this.tables = tables;
  }
}
