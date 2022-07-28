package ckb.domains.admin;


import ckb.domains.GenId;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "Roles")
public class Roles extends GenId {

  // ������������
  @Column(length = 128)
  private String name;

  // ������� ����� ����
  @Column(length = 512)
  private String url;

  // ������ ����
  @Column(length = 128)
  private String icon;

  // ���� ����
  @Column(length = 128)
  private String color;

  // ���������
  @Column(length = 1)
  private String state;

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
