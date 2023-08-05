package ckb.services.admin.form;

import ckb.domains.admin.Kdos;
import ckb.models.FormField;
import org.springframework.ui.Model;

import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 21.08.15
 * Time: 23:50
 * To change this template use File | Settings | File Templates.
 */
public interface SForm {
  void setSelectOptionModel(Model model, Integer formId, String field);

  void createFields(Model model, int formId, Kdos kdo);

  List<FormField> createFields(Integer formId, int serviceId);
}
