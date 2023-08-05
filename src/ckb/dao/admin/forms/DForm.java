package ckb.dao.admin.forms;

import ckb.dao.Dao;
import ckb.domains.admin.Forms;
import ckb.domains.admin.SelOpts;

import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 21.08.15
 * Time: 23:06
 * To change this template use File | Settings | File Templates.
 */
public interface DForm extends Dao<Forms> {

  List<SelOpts> getOpts(int formId, String field, boolean isEmpty);

  List<SelOpts> getOpts(int formId, String field);

  List<SelOpts> getOpts(int field);
}
