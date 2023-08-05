package ckb.dao.admin.forms;

import ckb.dao.DaoImp;
import ckb.domains.admin.FormFields;
import ckb.domains.admin.Forms;
import ckb.domains.admin.SelOpts;

import java.util.ArrayList;
import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 21.08.15
 * Time: 23:06
 * To change this template use File | Settings | File Templates.
 */
public class DFormImp extends DaoImp<Forms> implements DForm {

  public DFormImp( ) {
    super(Forms.class);
  }

  @Override
  public List<SelOpts> getOpts(int formId, String field, boolean isEmpty) {
    try {
      FormFields f = (FormFields) entityManager.createQuery("From FormFields Where form=" + formId + " And field = '" + field + "'").getSingleResult();
      List<SelOpts> list = new ArrayList<SelOpts>();
      if(isEmpty) {
        SelOpts empty = new SelOpts();
        empty.setName("");
        list.add(empty);
      }
      list.addAll(f.getOpts());
      return list;
    } catch (Exception e) {
      return null;
    }
  }

  @Override
  public List<SelOpts> getOpts(int formId, String field) {
    return getOpts(formId, field, true);
  }

  @Override
  public List<SelOpts> getOpts(int field) {
    try {
      FormFields f = (FormFields) entityManager.createQuery("From FormFields Where id=" +field).getSingleResult();
      List<SelOpts> list = new ArrayList<SelOpts>();
      SelOpts empty = new SelOpts();
      empty.setName("");
      empty.setState("A");
      list.add(empty);
      list.addAll(f.getOpts());
      return list;
    } catch (Exception e) {
      return null;
    }
  }
}
