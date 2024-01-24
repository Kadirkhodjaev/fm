package ckb.services.med.client;

import ckb.domains.admin.Clients;
import ckb.grid.ClientGrid;
import ckb.models.Client;
import ckb.models.Grid;
import ckb.session.Session;

import java.util.List;

public interface SClient {
  long getCount(String sql);

  List<Clients> getGridList(Grid grid, Session session);

  List<Client> rows(ClientGrid grid, Session session);
}
