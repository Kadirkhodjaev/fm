package ckb.models;

import ckb.domains.med.head_nurse.HNPatientDrugs;
import ckb.domains.med.head_nurse.HNPatientKdos;
import ckb.domains.med.head_nurse.HNPatients;
import ckb.domains.med.patient.PatientWatchers;

import java.util.ArrayList;
import java.util.List;

/**
 * Result of the act calculation (SPatient.act_calc).
 * Holds the recalculated act and everything needed to render it.
 */
public class ActCalc {

  public HNPatients hnPatient;
  public List<HNPatientKdos> labs = new ArrayList<>();
  public List<HNPatientKdos> kdos = new ArrayList<>();
  public List<HNPatientKdos> consuls = new ArrayList<>();
  public List<HNPatientDrugs> drugs = new ArrayList<>();
  public List<PatientWatchers> watchers = new ArrayList<>();
  public List<ObjList> epicRows = new ArrayList<>();
  public double epicSum;
  public double drugSum;
  public double labSum;
  public double kdoSum;
  public double consulSum;
  public double watcherSum;
  public double paidSum;
  public double discountSum;
  public double koyko;
  public double disPerc;
}
