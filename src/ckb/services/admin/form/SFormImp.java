package ckb.services.admin.form;

import ckb.dao.admin.forms.DForm;
import ckb.dao.admin.forms.fields.DFormField;
import ckb.dao.med.amb.DAmbServices;
import ckb.domains.admin.FormFields;
import ckb.domains.admin.Kdos;
import ckb.domains.admin.SelOpts;
import ckb.domains.med.amb.AmbServices;
import ckb.models.FormField;
import ckb.utils.Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;

import java.util.ArrayList;
import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * User: Sardor
 * Date: 21.08.15
 * Time: 23:50
 * To change this template use File | Settings | File Templates.
 */
public class SFormImp implements SForm {

  @Autowired DForm dForm;
  @Autowired DFormField dFormField;
  @Autowired DAmbServices dAmbServices;

  @Override
  public void setSelectOptionModel(Model model, Integer formId, String field) {
    model.addAttribute(field, dForm.getOpts(formId, field));
  }

  @Override
  public void createFields(Model model, int formId, Kdos kdo) {
    List<FormFields> fields = dFormField.getFiledsByForm(formId);
    for(FormFields f : fields){
      model.addAttribute(f.getFieldCode()+"name", f.getField());
      model.addAttribute(f.getFieldCode()+"html", getFieldHtml(f));
      if(formId != 777) {
        String norma = Util.nvl(f.getNormaFrom()) + " " + Util.nvl(f.getNormaTo()), ei = Util.nvl(f.getEI());
        model.addAttribute(f.getFieldCode() + "norma", Util.nvl(norma.length() > 0 ? norma : kdo.getNorma()));
        model.addAttribute(f.getFieldCode() + "ei", Util.nvl(ei.length() > 0 ? ei : kdo.getEi()));
      } else {
        model.addAttribute(f.getFieldCode() + "norma", Util.nvl(kdo.getNorma()));
        model.addAttribute(f.getFieldCode() + "ei", Util.nvl(kdo.getEi()));
      }
    }
  }

  @Override
  public List<FormField> createFields(Integer formId, int serviceId) {
    List<FormFields> fields = dFormField.getFileds(formId);
    List<FormField> list = new ArrayList<FormField>();
    for(FormFields f : fields) {
      String norma = "", ei = "";
      if(formId == 777) {
        AmbServices service = dAmbServices.get(serviceId);
        norma = service.getNormaFrom() != null ? service.getNormaFrom() + (service.getNormaTo() != null && !"".equals(service.getNormaTo()) ? " - " + service.getNormaTo() : "") : "";
        ei = service.getEi() != null ? service.getEi() : "";
        f.setEI(ei);
        f.setNormaFrom(norma);
      }
      FormField li = new FormField();
      li.setId(f.getId());
      li.setName(f.getField());
      li.setFieldCode(f.getFieldCode());
      li.setHtml(getFieldHtml(f));
      li.setNorma(f.getNormaFrom() != null ? f.getNormaFrom() + (!"".equals(f.getNormaTo()) ? " - " + f.getNormaTo() : "") : norma);
      li.setEi(f.getEI() != null ? f.getEI() : ei);
      li.setOrd(f.getOrd());
      list.add(li);
    }
    return list;
  }

  private String getFieldHtml(FormFields f) {
    StringBuffer sb = new StringBuffer();
    if(f.getFieldType().equals("text")) {
      sb.append("<input style='" + f.getCssStyle() + "' type='text' class='" + f.getCssClass() + "' name='" + f.getFieldCode() + "' maxLength='" + f.getMaxLength() + "' value='" + Util.nvl(f.getDefVal()) + "'>");
    }
    if(f.getFieldType().equals("select")) {
      sb.append("<select style='" + f.getCssStyle() + "' class='" + f.getCssClass() + "' name='" + f.getFieldCode() + "'>");
      for(SelOpts s : dForm.getOpts(f.getId())) {
        sb.append("<option value='" + s.getName() + "'>" + s.getName());
      }
      sb.append("</select>");
    }
    if(f.getFieldType().equals("textarea")) {
      sb.append("<textarea style='" + f.getCssStyle() + "' maxlength='" + f.getMaxLength() + "' class='" + f.getCssClass() + "' id='id_" + f.getFieldCode() + "' name='" + f.getFieldCode() + "' cols='" + f.getTextCols() + "' rows='" + f.getTextRows() + "'>" + Util.nvl(f.getDefVal()) + "</textarea>");
    }
    return sb.toString();
  }
}
