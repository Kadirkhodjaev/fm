package ckb.dao.admin.forms.fields;

import ckb.dao.Dao;
import ckb.domains.admin.FormFields;

import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 27.08.15
 * Time: 21:38
 * To change this template use File | Settings | File Templates.
 */
public interface DFormField extends Dao<FormFields> {

  List<FormFields> getFiledsByForm(int formId);

  List<FormFields> getFileds(int formId);

  String getNextFieldCode(Integer formId);
}
