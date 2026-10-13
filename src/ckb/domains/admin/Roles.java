package ckb.domains.admin;


import ckb.domains.GenId;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@org.hibernate.annotations.Cache(usage = org.hibernate.annotations.CacheConcurrencyStrategy.READ_WRITE)
@Table(name = "Roles")
public class Roles extends GenId {

  // Наименование
  @Column(length = 128)
  private String name;

  // Рабочий адрес роли
  @Column(length = 512)
  private String url;

  // Иконка роли
  @Column(length = 128)
  private String icon;

  // Цвет роли
  @Column(length = 128)
  private String color;

  // Состояние
  @Column(length = 1)
  private String state;

  // Y - левое меню видно всегда, даже когда открыта карточка пациента; N - меню скрывается внутри карточки
  @Column(length = 1)
  private String showMenu;

  // Y - поиск пациента в шапке
  @Column(length = 1)
  private String showSearch;

  public String getShowMenu() {
    return showMenu;
  }

  public void setShowMenu(String showMenu) {
    this.showMenu = showMenu;
  }

  public String getShowSearch() {
    return showSearch;
  }

  public void setShowSearch(String showSearch) {
    this.showSearch = showSearch;
  }

  public String getColor() {
    return color;
  }

  public void setColor(String color) {
    this.color = color;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public String getUrl() {
    return url;
  }

  public void setUrl(String url) {
    this.url = url;
  }

  public String getIcon() {
    return icon;
  }

  public void setIcon(String icon) {
    this.icon = icon;
  }

  public String getState() {
    return state;
  }

  public void setState(String state) {
    this.state = state;
  }
}
