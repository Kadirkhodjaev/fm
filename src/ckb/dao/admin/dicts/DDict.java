package ckb.dao.admin.dicts;

import ckb.dao.Dao;
import ckb.domains.admin.Dicts;

import java.util.List;

public interface DDict extends Dao<Dicts> {

	// ѕолучить список справочник по типам
	List<Dicts> getByTypeList(String type);

}
