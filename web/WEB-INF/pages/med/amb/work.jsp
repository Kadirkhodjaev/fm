<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<html>

<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/res/bs/metisMenu/metisMenu.min.css" rel="stylesheet">
<link href="/res/bs/sb_admin/css/timeline.css" rel="stylesheet">
<link href="/res/bs/sb_admin/css/sb-admin-2.css" rel="stylesheet">
<link href="/res/bs/morrisjs/morris.css" rel="stylesheet">
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
<link href="/res/tinymce/jquery-te-1.4.0.css" rel="stylesheet">

<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<script src="/res/bs/metisMenu/metisMenu.min.js"></script>
<script src="/res/bs/morrisjs/morris.min.js"></script>
<script src="/res/bs/sb_admin/js/sb-admin-2.js"></script>
<script src="/res/js/common.js"></script>
<script src="/res/editor/nicEdit.js" type="text/javascript"></script>
<script src="/res/tinymce/jquery-te-1.4.0.js" type="text/javascript"></script>

<script>
  bkLib.onDomLoaded(nicEditors.allTextAreas);
  function saveKdoTemplate(field, fieldId) {
    if(nicEditors.findEditor("id_" + fieldId).getContent() != '')
    if (confirm('Вы действительно хотите сохранить значения данного поля как шаблон')) {
      var name = prompt('Наименование шаблона');
      if (name != '') {
        $.ajax({
          url: '/templates/lv/save.s',
          data: 'field=' + field + '&name=' + name + '&template=' + encodeURIComponent(nicEditors.findEditor("id_" + fieldId).getContent()),
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
    nicEditors.findEditor("id_" + id).setContent(dom.innerHTML);
  }
  function serviceSave() {
    if (nicEditors.findEditor("id_c1").getContent() != '') {
      var f = [];
      f[0] = encodeURIComponent(nicEditors.findEditor("id_c1").getContent());
      if (nicEditors.findEditor("id_c2") != undefined) f[1] = encodeURIComponent(nicEditors.findEditor("id_c2").getContent());
      if (nicEditors.findEditor("id_c3") != undefined) f[2] = encodeURIComponent(nicEditors.findEditor("id_c3").getContent());
      if (nicEditors.findEditor("id_c4") != undefined) f[3] = encodeURIComponent(nicEditors.findEditor("id_c4").getContent());
      if (nicEditors.findEditor("id_c5") != undefined) f[4] = encodeURIComponent(nicEditors.findEditor("id_c5").getContent());
      if (nicEditors.findEditor("id_c6") != undefined) f[5] = encodeURIComponent(nicEditors.findEditor("id_c6").getContent());
      if (nicEditors.findEditor("id_c7") != undefined) f[6] = encodeURIComponent(nicEditors.findEditor("id_c7").getContent());
      if (nicEditors.findEditor("id_c8") != undefined) f[7] = encodeURIComponent(nicEditors.findEditor("id_c8").getContent());
      if (nicEditors.findEditor("id_c9") != undefined) f[8] = encodeURIComponent(nicEditors.findEditor("id_c9").getContent());
      if (nicEditors.findEditor("id_c10") != undefined) f[9] = encodeURIComponent(nicEditors.findEditor("id_c10").getContent());
      var diagnoz = document.getElementById('diagnoz') ? document.getElementById('diagnoz').value : '';
      $.ajax({
        url: '/amb/work.s',
        data: 'id=${service.id}&f1=' + f[0] + '&f2=' + f[1] + '&f3=' + f[2] + '&f4=' + f[3] + '&f5=' + f[4] + '&f6=' + f[5] + '&f7=' + f[6] + '&f8=' + f[7] + '&f9=' + f[8] + '&f10=' + f[9] + '&diagnoz=' + diagnoz,
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert('Данные успешно сохранены');
            parent.setPage('/amb/work.s?id=${service.id}');
          } else
            alert(res.msg);
        }
      });
    }
  }
  function confirmResult() {
    if (confirm('Подтвердить данную услугу?')) {
      $.ajax({
        url: '/amb/confirmService.s',
        data: 'id=${service.id}',
        method: 'post',
        dataType: 'json',
        success: function (res) {
          if (res.success) {
            alert('Данные успешно сохранены');
            parent.setPage('/amb/home.s');
          } else
            alert(res.msg);
        }
      });
    }
  }
  function setPrintPage() {
    window.open('/amb/print.s?ids=${service.id}_');
  }
</script>
<body style="background: white">
  <div class="panel panel-info" style="width: 1000px !important; margin: auto">
    <div class="panel-heading">
      ${patient.surname} ${patient.name} ${patient.middlename}
      <ul class="pagination" style="float:right; margin-top:-5px">
        <c:if test="${curUser == service.worker.id}">
          <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="serviceSave()"><i title="Сохранить" class="fa fa-save"></i> Сохранить</a></li>
        </c:if>
        <c:if test="${service.result > 0 && service.service.consul == 'Y'}">
          <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="openDrug()"><i title="Лист назначение" class="fa fa-list"></i> Лист назначение</a></li>
        </c:if>
        <c:if test="${service.result > 0}">
          <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="setPrintPage()"><i title="Печать" class="fa fa-print"></i> Печать</a></li>
        </c:if>
        <c:if test="${service.result > 0 && service.state == 'PAID'}">
          <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="confirmResult()"><i title="Подтвердить" class="fa fa-check"></i> Подтвердить</a></li>
        </c:if>
        <li class="paginate_button" tabindex="0" style="width: 100px !important;"><a href="#" onclick="parent.openMainPage('/amb/home.s', true)"><i title="Назад" class="fa fa-backward"></i> Назад</a></li>
      </ul>
    </div>
    <div class="panel-body">
      <table class="formTable" style="width:100%">
        <tr>
          <td class="right bold" nowrap>ФИО<d></d>:</td>
          <td colspan="3">
            ${patient.surname} ${patient.name} ${patient.middlename}
          </td>
        </tr>
        <tr>
          <td class="right bold" nowrap><ui:message code="birthyear"/>:</td>
          <td>${patient.birthyear}</td>
          <td class="right bold" nowrap><ui:message code="sex"/>:</td>
          <td>${patient.sex.name}</td>
        </tr>
        <tr>
          <td class="right bold" nowrap><ui:message code="phone"/>:</td>
          <td>${patient.tel}</td>
          <td class="right bold" nowrap><ui:message code="passportInfo"/>:</td>
          <td>${patient.passportInfo}</td>
        </tr>
        <tr>
          <td class="right bold" nowrap>Резиденство:</td>
          <td>${country}</td>
          <td class="right bold" nowrap>Область:</td>
          <td>${region}</td>
        </tr>
        <tr>
          <td class="right bold" nowrap><ui:message code="address"/>:</td>
          <td colspan="3">${patient.address}</td>
        </tr>
      </table>
    </div>
    <div class="" style="margin-left:-1px; width: 1000px !important;">
      <div class="center" style="font-weight:bold; font-size:18px">
        ${service.service.name}
      </div>
      <c:if test="${isC1}">
        <div style="float:left;padding-left:10px;" class="bold">${c1_name}</div>
        <div style="float:right" class="right" style="padding:5px 0">
          <a title="Сохранить как шаблон" style="padding:1px 5px" class="btn btn-xs btn-default" onclick="saveKdoTemplate('${service.service.id}_c1', 'c1'); return false;">
            <span class="fa fa-save"></span>
          </a>
          <a title="Из шаблона" style="padding:1px 5px" class="btn btn-xs btn-default" onclick="getKdoTemplate('${service.service.id}_c1', 'c1'); return false;">
            <span class="fa fa-plus"></span>
          </a>
        </div>
        <div style="clear:both"></div>
        <div>
          <textarea id="id_c1" name="c1" style="width:100%" cols="110" rows="6">${result.c1}</textarea>
        </div>
      </c:if>
      <c:if test="${isC2}">
        <div style="float:left;padding-left:10px;" class="bold">${c2_name}</div>
        <div style="float:right" class="right" style="padding:5px 0">
          <a title="Сохранить как шаблон" style="padding:1px 5px" class="btn btn-xs btn-default" onclick="saveKdoTemplate('${service.service.id}_c2', 'c2'); return false;">
            <span class="fa fa-save"></span>
          </a>
          <a title="Из шаблона" style="padding:1px 5px" class="btn btn-xs btn-default" onclick="getKdoTemplate('${service.service.id}_c2', 'c2'); return false;">
            <span class="fa fa-plus"></span>
          </a>
        </div>
        <div style="clear:both"></div>
        <div>
          <textarea id="id_c2" name="c2" style="width:100%" cols="110" rows="6">${result.c2}</textarea>
        </div>
      </c:if>
      <c:if test="${isC3}">
        <div style="float:left;padding-left:10px;" class="bold">${c3_name}</div>
        <div style="float:right" class="right" style="padding:5px 0">
          <a title="Сохранить как шаблон" style="padding:1px 5px" class="btn btn-xs btn-default" onclick="saveKdoTemplate('${service.service.id}_c3', 'c3'); return false;">
            <span class="fa fa-save"></span>
          </a>
          <a title="Из шаблона" style="padding:1px 5px" class="btn btn-xs btn-default" onclick="getKdoTemplate('${service.service.id}_c3', 'c3'); return false;">
            <span class="fa fa-plus"></span>
          </a>
        </div>
        <div style="clear:both"></div>
        <div>
          <textarea id="id_c3" name="c3" style="width:100%" cols="110" rows="6">${result.c3}</textarea>
        </div>
      </c:if>
      <c:if test="${isC4}">
        <div style="float:left;padding-left:10px;" class="bold">${c4_name}</div>
        <div style="float:right" class="right" style="padding:5px 0">
          <a title="Сохранить как шаблон" style="padding:1px 5px" class="btn btn-xs btn-default" onclick="saveKdoTemplate('${service.service.id}_c4', 'c4'); return false;">
            <span class="fa fa-save"></span>
          </a>
          <a title="Из шаблона" style="padding:1px 5px" class="btn btn-xs btn-default" onclick="getKdoTemplate('${service.service.id}_c4', 'c4'); return false;">
            <span class="fa fa-plus"></span>
          </a>
        </div>
        <div style="clear:both"></div>
        <div>
          <textarea id="id_c4" name="c4" style="width:100%" cols="110" rows="6">${result.c4}</textarea>
        </div>
      </c:if>
      <c:if test="${isC5}">
        <div style="float:left;padding-left:10px;" class="bold">${c5_name}</div>
        <div style="float:right" class="right" style="padding:5px 0">
          <a title="Сохранить как шаблон" style="padding:1px 5px" class="btn btn-xs btn-default" onclick="saveKdoTemplate('${service.service.id}_c5', 'c5'); return false;">
            <span class="fa fa-save"></span>
          </a>
          <a title="Из шаблона" style="padding:1px 5px" class="btn btn-xs btn-default" onclick="getKdoTemplate('${service.service.id}_c5', 'c5'); return false;">
            <span class="fa fa-plus"></span>
          </a>
        </div>
        <div style="clear:both"></div>
        <div>
          <textarea id="id_c5" name="c5" style="width:100%" cols="110" rows="6">${result.c5}</textarea>
        </div>
      </c:if>
      <c:if test="${isC6}">
        <div style="float:left;padding-left:10px;" class="bold">${c6_name}</div>
        <div style="float:right" class="right" style="padding:5px 0">
          <a title="Сохранить как шаблон" style="padding:1px 5px" class="btn btn-xs btn-default" onclick="saveKdoTemplate('${service.service.id}_c6', 'c6'); return false;">
            <span class="fa fa-save"></span>
          </a>
          <a title="Из шаблона" style="padding:1px 5px" class="btn btn-xs btn-default" onclick="getKdoTemplate('${service.service.id}_c6', 'c6'); return false;">
            <span class="fa fa-plus"></span>
          </a>
        </div>
        <div style="clear:both"></div>
        <div>
          <textarea id="id_c6" name="c6" style="width:100%" cols="110" rows="6">${result.c6}</textarea>
        </div>
      </c:if>
      <c:if test="${isC7}">
        <div style="float:left;padding-left:10px;" class="bold">${c7_name}</div>
        <div style="float:right" class="right" style="padding:5px 0">
          <a title="Сохранить как шаблон" style="padding:1px 5px" class="btn btn-xs btn-default" onclick="saveKdoTemplate('${service.service.id}_c7', 'c7'); return false;">
            <span class="fa fa-save"></span>
          </a>
          <a title="Из шаблона" style="padding:1px 5px" class="btn btn-xs btn-default" onclick="getKdoTemplate('${service.service.id}_c7', 'c7'); return false;">
            <span class="fa fa-plus"></span>
          </a>
        </div>
        <div style="clear:both"></div>
        <div>
          <textarea id="id_c7" name="c7" style="width:100%" cols="110" rows="6">${result.c7}</textarea>
        </div>
      </c:if>
      <c:if test="${isC8}">
        <div style="float:left;padding-left:10px;" class="bold">${c8_name}</div>
        <div style="float:right" class="right" style="padding:5px 0">
          <a title="Сохранить как шаблон" style="padding:1px 5px" class="btn btn-xs btn-default" onclick="saveKdoTemplate('${service.service.id}_c8', 'c8'); return false;">
            <span class="fa fa-save"></span>
          </a>
          <a title="Из шаблона" style="padding:1px 5px" class="btn btn-xs btn-default" onclick="getKdoTemplate('${service.service.id}_c8', 'c8'); return false;">
            <span class="fa fa-plus"></span>
          </a>
        </div>
        <div style="clear:both"></div>
        <div>
          <textarea id="id_c8" name="c8" style="width:100%" cols="110" rows="6">${result.c8}</textarea>
        </div>
      </c:if>
      <c:if test="${isC9}">
        <div style="float:left;padding-left:10px;" class="bold">${c9_name}</div>
        <div style="float:right" class="right" style="padding:5px 0">
          <a title="Сохранить как шаблон" style="padding:1px 5px" class="btn btn-xs btn-default" onclick="saveKdoTemplate('${service.service.id}_c9', 'c9'); return false;">
            <span class="fa fa-save"></span>
          </a>
          <a title="Из шаблона" style="padding:1px 5px" class="btn btn-xs btn-default" onclick="getKdoTemplate('${service.service.id}_c9', 'c9'); return false;">
            <span class="fa fa-plus"></span>
          </a>
        </div>
        <div style="clear:both"></div>
        <div>
          <textarea id="id_c9" name="c9" style="width:100%" cols="110" rows="6">${result.c9}</textarea>
        </div>
      </c:if>
      <c:if test="${isC10}">
        <div style="float:left;padding-left:10px;" class="bold">${c10_name}</div>
        <div style="float:right" class="right" style="padding:5px 0">
          <a title="Сохранить как шаблон" style="padding:1px 5px" class="btn btn-xs btn-default" onclick="saveKdoTemplate('${service.service.id}_c10', 'c10'); return false;">
            <span class="fa fa-save"></span>
          </a>
          <a title="Из шаблона" style="padding:1px 5px" class="btn btn-xs btn-default" onclick="getKdoTemplate('${service.service.id}_c10', 'c10'); return false;">
            <span class="fa fa-plus"></span>
          </a>
        </div>
        <div style="clear:both"></div>
        <div>
          <textarea id="id_c10" name="c10" style="width:100%" cols="110" rows="6">${result.c10}</textarea>
        </div>
      </c:if>

      <c:if test="${service.service.diagnoz == 'Y'}">
        <div style="float:left;padding-left:10px;" class="bold">Диагноз</div>
        <div style="float:right" class="right" style="padding:5px 0">
          <a title="Сохранить как шаблон" style="padding:1px 5px" class="btn btn-xs btn-default" onclick="saveKdoTemplate('${service.service.id}_diagnoz', 'diagnoz'); return false;">
            <span class="fa fa-save"></span>
          </a>
          <a title="Из шаблона" style="padding:1px 5px" class="btn btn-xs btn-default" onclick="getKdoTemplate('${service.service.id}_diagnoz', 'diagnoz'); return false;">
            <span class="fa fa-plus"></span>
          </a>
        </div>
        <div style="clear:both"></div>
        <div>
          <input id="diagnoz" name="diagnoz" style="width:100%" maxlength="2000" value="${service.diagnoz}"/>
        </div>
      </c:if>
    </div>
  </div>

  <a href="#" data-toggle="modal" data-target="#myModal" id="modal_window" class="hidden"></a>
  <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none;">
    <div class="modal-dialog" style="width:100%">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
          <h4 class="modal-title" id="myModalLabel">Лист назначение</h4>
        </div>
        <div class="modal-body" id="amb_drug"></div>
      </div>
      <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
  </div>
</body>
<script>
  function openDrug() {
    $('#amb_drug').load('/amb/drug.s', () => {
      $('#modal_window').click();
    });
  }
</script>
</html>
