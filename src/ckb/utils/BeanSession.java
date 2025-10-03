package ckb.utils;

import ckb.dao.admin.country.DCountry;
import ckb.dao.admin.depts.DDept;
import ckb.dao.admin.dicts.DLvPartner;
import ckb.dao.admin.params.DParam;
import ckb.dao.admin.region.DRegion;
import ckb.dao.med.amb.DAmbGroup;
import ckb.dao.med.dicts.rooms.DRooms;
import ckb.dao.med.kdos.DSalePack;
import ckb.domains.admin.*;
import ckb.domains.med.amb.AmbGroups;
import ckb.domains.med.dicts.Rooms;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BeanSession {

  @Autowired private DRooms dRoom;
  @Autowired private DAmbGroup dAmbGroup;
  @Autowired private DDept dDept;
  @Autowired private DCountry dCountry;
  @Autowired private DRegion dRegion;
  @Autowired private DParam dParam;
  @Autowired private DSalePack dSalePack;
  @Autowired private DLvPartner dLvPartner;

  private List<Depts> depts = new ArrayList<>();
  private List<AmbGroups> ambGroups = new ArrayList<>();
  private List<Counteries> counteries = new ArrayList<>();
  private List<Regions> regions = new ArrayList<>();
  private HashMap<String, String> params = new HashMap<>();
  private List<Rooms> rooms = new ArrayList<>();
  private List<SalePacks> salePacks = new ArrayList<>();
  private List<LvPartners> lvPartners = new ArrayList<>();

  public void initialize() {
    depts = dDept.getAll();
    ambGroups = dAmbGroup.getAll();
    counteries = dCountry.list("From Counteries Order By ord, name");
    regions = dRegion.list("From Regions Order By ord, name");
    rooms = dRoom.list("From Rooms");
    salePacks = dSalePack.list("From SalePacks Where state = 'A' And ambStat = 'AMB'");
    lvPartners = dLvPartner.list("From LvPartners Where state = 'A' Order By code");
    List<Params> ps = dParam.getAll();
    for(Params p : ps) {
      params.put(p.getCode(), p.getVal());
    }
  }

  public List<Depts> getDepts() {
    return depts;
  }

  public List<AmbGroups> getAmbGroups() {
    return ambGroups;
  }

  public List<Counteries> getCounteries() {
    return counteries;
  }

  public List<Regions> getRegions() {
    return regions;
  }

  public String getParam(String code) {
    return params.get(code);
  }

  public List<Rooms> getRooms() {
    return rooms;
  }

  public Depts getDept(int id) {
    for(Depts d : depts) {
      if(d.getId() == id) {
        return d;
      }
    }
    return null;
  }

  public Double getNds() {
    return Double.parseDouble(params.get("NDS_PROC"));
  }

  public Map<String, String> getParams() {
    return params;
  }

  public List<SalePacks> getSalePacks() {
    return salePacks;
  }

  public List<LvPartners> getLvPartners() {
    return lvPartners;
  }
}
