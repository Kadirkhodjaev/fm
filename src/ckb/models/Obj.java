package ckb.models;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 26.08.15
 * Time: 16:55
 * To change this template use File | Settings | File Templates.
 */
public class Obj {

  public Obj(int id, String name, boolean active) {
    this.id = id;
    this.name = name;
    this.active = active;
  }

  public Obj() {}

  private int id;
  private String name;
  private String fio;

  private Double claimCount;
  private Double drugCount;
  private Double inCount;
  private Double outCount;
  private Double price;
  private Integer extraId;
  private LinkedHashMap<Integer, String> rows = new LinkedHashMap<Integer, String>();

  private boolean active;
  private List<ObjList> list = new ArrayList<ObjList>();

  public Double getClaimCount() {
    return claimCount;
  }

  public void setClaimCount(Double claimCount) {
    this.claimCount = claimCount;
  }

  public int getId() {
    return id;
  }

  public void setId(int id) {
    this.id = id;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public boolean isActive() {
    return active;
  }

  public void setActive(boolean active) {
    this.active = active;
  }

  public List<ObjList> getList() {
    return list;
  }

  public void setList(List<ObjList> list) {
    this.list = list;
  }

  public String getFio() {
    return fio;
  }

  public void setFio(String fio) {
    this.fio = fio;
  }

  public Double getDrugCount() {
    return drugCount;
  }

  public void setDrugCount(Double drugCount) {
    this.drugCount = drugCount;
  }

  public Double getPrice() {
    return price;
  }

  public void setPrice(Double price) {
    this.price = price;
  }

  public Integer getExtraId() {
    return extraId;
  }

  public void setExtraId(Integer extraId) {
    this.extraId = extraId;
  }

  public Double getInCount() {
    return inCount;
  }

  public void setInCount(Double inCount) {
    this.inCount = inCount;
  }

  public Double getOutCount() {
    return outCount;
  }

  public void setOutCount(Double outCount) {
    this.outCount = outCount;
  }

  public LinkedHashMap<Integer, String> getRows() {
    return rows;
  }

  public void setRows(LinkedHashMap<Integer, String> rows) {
    this.rows = rows;
  }
}
