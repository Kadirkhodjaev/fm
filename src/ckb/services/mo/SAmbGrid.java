package ckb.services.mo;

import ckb.grid.AmbGrid;
import ckb.models.AmbPatient;
import ckb.session.Session;

import java.util.List;

public interface SAmbGrid {

  List<AmbPatient> rows(AmbGrid grid, Session session);

  long rowCount(AmbGrid grid);
}
