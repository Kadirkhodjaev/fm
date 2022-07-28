package ckb.dao.admin.dicts;

import ckb.dao.DaoImp;
import ckb.domains.admin.Dicts;

import java.util.List;

public class DDictImp extends DaoImp<Dicts> implements DDict {

	public DDictImp() { super(Dicts.class); }

	// ѕолучить список справочник по типам
	@Override
	public List<Dicts> getByTypeList(String type) {
		return getList("From Dicts Where typeCode = '" + type + "'");
	}
}
