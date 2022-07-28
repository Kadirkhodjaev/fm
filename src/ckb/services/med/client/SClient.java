package ckb.services.med.client;

import ckb.domains.admin.Clients;
import ckb.models.Grid;
import ckb.session.Session;

import java.util.List;

public interface SClient {
  long getCount(Session session, String sql);

  List<Clients> getGridList(Grid grid, Session session);
}
