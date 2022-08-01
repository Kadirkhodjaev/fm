package ckb.models.result;

import java.util.List;

public class Doctor {

  private int user;
  private String fio;
  private String profil;
  private List<Result> results;

  public int getUser() {
    return user;
  }

  public void setUser(int user) {
    this.user = user;
  }

  public String getFio() {
    return fio;
  }

  public void setFio(String fio) {
    this.fio = fio;
  }

  public String getProfil() {
    return profil;
  }

  public void setProfil(String profil) {
    this.profil = profil;
  }

  public List<Result> getResults() {
    return results;
  }

  public void setResults(List<Result> results) {
    this.results = results;
  }
}
