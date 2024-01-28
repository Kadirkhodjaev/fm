package ckb.dao.med.amb;

import ckb.dao.Dao;
import ckb.domains.med.amb.AmbFizioDates;
import ckb.domains.med.amb.AmbPatients;

import java.util.Date;

public interface DAmbFizioDate extends Dao<AmbFizioDates> {
  Date getPatientMaxDate(AmbPatients patient);
}
