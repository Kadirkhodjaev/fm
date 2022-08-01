package ckb.models.reports;

import ckb.models.ObjList;

import java.util.List;

public class Rep36 {

  private String fio;
  private List<ObjList> rows;
  private Double ambProc;
  private Double statProc;
  private Double ambSum;
  private Double statSum;

  private Double summ;

  public String getFio() {
    return fio;
  }

  public void setFio(String fio) {
    this.fio = fio;
  }

  public List<ObjList> getRows() {
    return rows;
  }

  public void setRows(List<ObjList> rows) {
    this.rows = rows;
  }

  public Double getAmbProc() {
    return ambProc;
  }

  public void setAmbProc(Double ambProc) {
    this.ambProc = ambProc;
  }

  public Double getStatProc() {
    return statProc;
  }

  public void setStatProc(Double statProc) {
    this.statProc = statProc;
  }

  public Double getSumm() {
    return summ;
  }

  public void setSumm(Double summ) {
    this.summ = summ;
  }

  public Double getAmbSum() {
    return ambSum;
  }

  public void setAmbSum(Double ambSum) {
    this.ambSum = ambSum;
  }

  public Double getStatSum() {
    return statSum;
  }

  public void setStatSum(Double statSum) {
    this.statSum = statSum;
  }
}
