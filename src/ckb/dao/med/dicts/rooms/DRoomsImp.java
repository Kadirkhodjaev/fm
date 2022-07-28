package ckb.dao.med.dicts.rooms;

import ckb.dao.DaoImp;
import ckb.domains.med.dicts.Rooms;

import java.util.List;

public class DRoomsImp extends DaoImp<Rooms> implements DRooms {
	public DRoomsImp() { super(Rooms.class); }

	@Override
	public Long koekCount() {
		return (Long) entityManager.createQuery("Select Sum(koykoLimit) From Rooms").getSingleResult();
	}

	@Override
	public List<Rooms> getActives() {
		return getList("From Rooms Where state = 'A' ");
	}
}
