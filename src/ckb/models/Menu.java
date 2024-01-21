package ckb.models;

import ckb.session.Session;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 25.08.15
 * Time: 19:27
 * To change this template use File | Settings | File Templates.
 */
public class Menu {

  public Menu(String name, String url, String icon, boolean isActive) {
    this.url = url;
    this.name = name;
    this.icon = icon;
    state = isActive ? "active" : "";
  }

  public Menu(String name, String url, String icon, Session session) {
    this.url = url;
    this.name = name;
    this.icon = icon;
    state = session.getCurUrl().contains(url) ? "active" : "";
  }

  public Menu(Integer ord, String name, String url, String icon, boolean isActive) {
    this.ord = ord;
    this.url = url;
    this.name = name;
    this.icon = icon;
    state = isActive ? "active" : "";
  }

  private Integer ord;
  private String url;
  private String name;
  private String icon;
  private String state;

  public String getUrl() {
    return url;
  }

  public void setUrl(String url) {
    this.url = url;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
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

  public Integer getOrd() {
    return ord;
  }

  public void setOrd(Integer ord) {
    this.ord = ord;
  }
}
