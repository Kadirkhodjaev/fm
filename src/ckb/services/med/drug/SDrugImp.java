package ckb.services.med.drug;

import ckb.dao.med.drug.actdrug.DDrugActDrug;
import ckb.dao.med.head_nurse.date.DHNDatePatientRow;
import ckb.dao.med.head_nurse.date.DHNDateRow;
import ckb.dao.med.head_nurse.drug.DHNDrug;
import ckb.domains.med.drug.DrugActDrugs;
import ckb.domains.med.head_nurse.HNDrugs;
import org.springframework.beans.factory.annotation.Autowired;

import java.math.BigDecimal;
import java.util.List;

public class SDrugImp implements SDrug {

  @Autowired private DHNDrug dhnDrug;
  @Autowired private DDrugActDrug dDrugActDrug;
  @Autowired private DHNDateRow dhnDateRow;
  @Autowired private DHNDatePatientRow dhnDatePatientRow;

  @Override
  public void hndrug_rasxod(Integer hndrug, Double rasxod) throws Exception {
    HNDrugs drug = dhnDrug.get(hndrug);
    if(drug.getId() > 50435) {
      BigDecimal r1 = BigDecimal.valueOf(dhnDateRow.getHDRasxod(hndrug));
      BigDecimal r2 = BigDecimal.valueOf(dhnDatePatientRow.getHDRasxod(hndrug));
      BigDecimal r3 = BigDecimal.valueOf(dhnDrug.getTransferRasxod(hndrug));
      BigDecimal fact = r1.add(r2).add(r3);
      if (Double.parseDouble(String.valueOf(fact)) != drug.getRasxod())
        throw new Exception("������ � ���� �� ��������� � �������� ��������. ���������� � �������������� HNDRUG: " + hndrug + " ����: " + fact + " ��: " + drug.getRasxod());
    }
    if(rasxod == 0)
      throw new Exception("������ ������� ������ �� ���������: 0");
    if(rasxod > 0 && drug.getDrugCount() - drug.getRasxod() < rasxod)
      throw new Exception("������ ������� ������ �������. �������: " + (drug.getDrugCount() - drug.getRasxod()) + " ������: " + rasxod);
    if(rasxod < 0 && Math.abs(rasxod) > drug.getRasxod())
      throw new Exception("������ ������� ������ �����. ����: " + drug.getRasxod() + " ������: " + Math.abs(rasxod));
    if(drug.getRasxod() > drug.getDrugCount())
      throw new Exception("������ �� ����� ���� ������ �������. ����: " + drug.getRasxod() + " ������: " + Math.abs(rasxod));
    drug.setRasxod(drug.getRasxod() + rasxod);
    drug.setHistory(0);
    dhnDrug.save(drug);
  }

  @Override
  public Double saldo(int direction, Integer drug) {
    List<HNDrugs> drugs = dhnDrug.list("From HNDrugs Where direction.id = " + direction + " And drug.id = " + drug + " And drugCount - rasxod > 0");
    if(drugs.isEmpty())
      return 0.0;
    double saldo = 0;
    for(HNDrugs d: drugs)
      saldo += d.getDrugCount() - d.getRasxod();
    return saldo;
  }

  @Override
  public double drug_saldo(Integer drug) {
    List<DrugActDrugs> drugs = dDrugActDrug.list("From DrugActDrugs Where drug.id = " + drug + " And counter - rasxod > 0");
    if(drugs.isEmpty())
      return 0;
    double saldo = 0;
    for(DrugActDrugs d: drugs) {
      saldo += d.getCounter() -  d.getRasxod();
    }
    return saldo;
  }

}
