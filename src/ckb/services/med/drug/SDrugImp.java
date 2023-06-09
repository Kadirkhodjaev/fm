package ckb.services.med.drug;

import ckb.dao.med.head_nurse.date.DHNDatePatientRow;
import ckb.dao.med.head_nurse.date.DHNDateRow;
import ckb.dao.med.head_nurse.drug.DHNDrug;
import ckb.domains.med.head_nurse.HNDrugs;
import org.springframework.beans.factory.annotation.Autowired;

import java.math.BigDecimal;

public class SDrugImp implements SDrug {

  @Autowired private DHNDrug dhnDrug;
  @Autowired private DHNDateRow dhnDateRow;
  @Autowired private DHNDatePatientRow dhnDatePatientRow;

  @Override
  public void hndrug_rasxod(Integer hndrug, Double rasxod) throws Exception {
    HNDrugs drug = dhnDrug.get(hndrug);
    BigDecimal r1 = BigDecimal.valueOf(dhnDateRow.getHDRasxod(hndrug));
    BigDecimal r2 = BigDecimal.valueOf(dhnDatePatientRow.getHDRasxod(hndrug));
    BigDecimal r3 = BigDecimal.valueOf(dhnDrug.getTransferRasxod(hndrug));
    BigDecimal fact = r1.add(r2).add(r3);
    if(Double.parseDouble(String.valueOf(fact)) != drug.getRasxod())
      throw new Exception("Расход в базе не совподает с реальным расходом. Обратитесь к администратору HNDRUG: " + hndrug + " Факт: " + fact + " БД: " + drug.getRasxod());
    if(rasxod == 0)
      throw new Exception("Нельзя создать запись со списанием: 0");
    if(rasxod > 0 && drug.getDrugCount() - drug.getRasxod() < rasxod)
      throw new Exception("Нельзя списать больше остатка. Остаток: " + (drug.getDrugCount() - drug.getRasxod()) + " Расход: " + rasxod);
    if(rasxod < 0 && Math.abs(rasxod) > drug.getRasxod())
      throw new Exception("Нельзя вернуть больше факта. Факт: " + drug.getRasxod() + " Расход: " + Math.abs(rasxod));
    if(drug.getRasxod() > drug.getDrugCount())
      throw new Exception("Расход не может быть больше прихода. Факт: " + drug.getRasxod() + " Расход: " + Math.abs(rasxod));
    drug.setRasxod(drug.getRasxod() + rasxod);
    dhnDrug.save(drug);
  }

}
