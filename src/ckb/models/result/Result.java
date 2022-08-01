package ckb.models.result;

import java.util.List;

public class Result {

  private int patientService;
  private int service;
  private int form;
  private String serviceName;
  private List<String> colName;
  private List<String> vals;
  private String value;
  private String diagnoz;
  private String recom;
  private boolean isei;
  private String EI;
  private boolean isnorma;
  private String norma;
  private List<FormRow> rows;

  public int getPatientService() {
    return patientService;
  }

  public void setPatientService(int patientService) {
    this.patientService = patientService;
  }

  public int getService() {
    return service;
  }

  public void setService(int service) {
    this.service = service;
  }

  public int getForm() {
    return form;
  }

  public void setForm(int form) {
    this.form = form;
  }

  public String getServiceName() {
    return serviceName;
  }

  public void setServiceName(String serviceName) {
    this.serviceName = serviceName;
  }

  public List<String> getColName() {
    return colName;
  }

  public void setColName(List<String> colName) {
    this.colName = colName;
  }

  public List<String> getVals() {
    return vals;
  }

  public void setVals(List<String> vals) {
    this.vals = vals;
  }

  public String getValue() {
    return value;
  }

  public void setValue(String value) {
    this.value = value;
  }

  public String getDiagnoz() {
    return diagnoz;
  }

  public void setDiagnoz(String diagnoz) {
    this.diagnoz = diagnoz;
  }

  public String getRecom() {
    return recom;
  }

  public void setRecom(String recom) {
    this.recom = recom;
  }

  public String getEI() {
    return EI;
  }

  public void setEI(String EI) {
    this.EI = EI;
  }

  public String getNorma() {
    return norma;
  }

  public void setNorma(String norma) {
    this.norma = norma;
  }

  public List<FormRow> getRows() {
    return rows;
  }

  public void setRows(List<FormRow> rows) {
    this.rows = rows;
  }

  public boolean isIsei() {
    return isei;
  }

  public void setIsei(boolean isei) {
    this.isei = isei;
  }

  public boolean isIsnorma() {
    return isnorma;
  }

  public void setIsnorma(boolean isnorma) {
    this.isnorma = isnorma;
  }
}
