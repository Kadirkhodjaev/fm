package ckb.dao.med.dicts.rooms;

import ckb.dao.Dao;
import ckb.domains.med.dicts.Rooms;

import java.util.List;

public interface DRooms extends Dao<Rooms> {
  Long koekCount();

  List<Rooms> getActives();
}
