<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="../../header.jsp"%>
<script type="text/javascript">
  bkLib.onDomLoaded(function() {
    nicEditors.editors.push(
      new nicEditor().panelInstance(
        document.getElementById('id_c2')
      )
    );
  });
  function saveKdoTemplate(field, fieldId) {
    if (confirm('Вы действительно хотите сохранить значения данного поля как шаблон')) {
      var name = prompt('Наименование шаблона');
      if (name != '') {
        $.ajax({
          url: '/templates/lv/save.s',
          data: 'field=' + field + '&name=' + name + '&template=' + encodeURIComponent($('textarea[name=c2]').val()),
          method: 'post',
          dataType: 'json',
          success: function (res) {
            alert(res.msg);
          }
        });
      }
    }
  }

  function getKdoTemplate(field, id) {
    var res = window.open('/templates/lv/get.s?kdo=1&field=' + field + '&id=' + id);
  }
  function setText(dom, id) {
    var el = $('textarea[name=' + id + ']');
    nicEditors.findEditor("id_c2").setContent(dom.innerHTML);
  }
</script>
<tr>
  <td align=left style="padding:5px; border:1px solid #e8e8e8;text-align:right">
    <a title="Сохранить как шаблон" style="float:right;padding:1px 5px" class="btn btn-xs btn-default" onclick="saveKdoTemplate('${plan.kdo.id}_c2', 'c2'); return false;">
      <span class="fa fa-save"></span>
    </a>
    <a title="Из шаблона" style="float: right;padding:1px 5px" class="btn btn-xs btn-default" onclick="getKdoTemplate('${plan.kdo.id}_c2', 'c2'); return false;">
      <span class="fa fa-plus"></span>
    </a>
  </td>
</tr>
<tr>
  <input style="display: none" id="form_999"/>
  <td style="border:1px solid #e8e8e8; padding:5px">${c2html}</td>
</tr>
<tr>
  <td align=left style="padding:5px; border:1px solid #e8e8e8">${c1name}</td>
</tr>
<tr>
  <td style="border:1px solid #e8e8e8; padding:5px" required="true">${c1html}</td>
</tr>
<%@include file="../../footer.jsp"%>