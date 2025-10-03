package ckb.services.med.drug;

public interface SDrug {

  void hndrug_rasxod(Integer hndrug, Double rasxod) throws Exception;

  Double saldo(int direction, Integer drug);

  double drug_saldo(Integer drug);
}
