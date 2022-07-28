package ckb.dao.admin.forms.fields;

import ckb.dao.DaoImp;
import ckb.domains.admin.FormFields;

import java.util.ArrayList;
import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 27.08.15
 * Time: 21:39
 * To change this template use File | Settings | File Templates.
 */
public class DFormFieldImp extends DaoImp<FormFields> implements DFormField {
  public DFormFieldImp() {
    super(FormFields.class);
  }

  @Override
  public List<FormFields> getFiledsByForm(int formId) {
    try {
      return getList("From FormFields t Where t.form.id = " + formId + " Order By ord Desc");
    } catch (Exception e) {
      return new ArrayList<FormFields>();
    }
  }

  @Override
  public List<FormFields> getFileds(int formId) {
    try {
      return getList("From FormFields t Where t.form.id = " + formId + " Order By ord, 1*substr(fieldCode, 1)");
    } catch (Exception e) {
      return new ArrayList<FormFields>();
    }
  }

  @Override
  public String getNextFieldCode(Integer formId) {
    Long count = getCount("From FormFields Where form.id = " + formId);
    return "c" + (count + 1);
  }
}
