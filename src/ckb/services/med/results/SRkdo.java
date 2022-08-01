package ckb.services.med.results;

import ckb.models.result.Result;

import java.util.List;

public interface SRkdo {
  List<String> getResults(int curPat);

  Result getAmbResult(int id);
}
