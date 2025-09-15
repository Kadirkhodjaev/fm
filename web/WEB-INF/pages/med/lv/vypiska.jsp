<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet">

<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>

<script src="/res/js/common.js" type="text/javascript"></script>
<script src="/res/editor/nicEdit.js" type="text/javascript"></script>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>

<script type="text/javascript">
  bkLib.onDomLoaded(nicEditors.allTextAreas);
  function getResult() {
    $.ajax({
      url:'/lv/results.s',
      data:'',
      method:'post',
      dataType:'json',
      success:function(res) {
        nicEditors.findEditor("c5").setContent(res.results);
      }
    });
  }
  function getDrugResult() {
    $.ajax({
      url:'/lv/drug_results.s',
      data:'',
      method:'post',
      dataType:'json',
      success:function(res) {
        nicEditors.findEditor("c6").setContent(res.results);
      }
    });
  }
  function setMkb(text, id) {
    var obos =  nicEditors.findEditor('c1').getContent();
    $('#mkb').val(text);
    $('#mkb_id').val(id);
    nicEditors.findEditor('c1').setContent(obos.length > 0 && obos != '<br>' ? obos + ', ' + text : text);
  }
  function printRecommend() {
    window.open('/lv/print_recommend.s');
  }
  function saveDoc() {
    $('#doc_form').html('');
    $('#lv_doc input, #lv_doc textarea').each((i, v) => {
      let input = $('<input type="hidden" name="' + v.name + '"/>');
      input.val(v.tagName == 'TEXTAREA' ? nicEditors.findEditor(v.id).getContent() : v.value);
      $('#doc_form').append(input);
    })
    $.ajax({
      url: '/lv/doc/save.s',
      method: 'post',
      data: $('#doc_form').serialize(),
      dataType: 'json',
      success: function (res) {
        openMsg(res)
        if(res.success)
          setPage('/lv/doc.s?doc_code=vypiska');
      }
    });
  }
</script>
<form id="doc_form" action="#"></form>
<div class="panel panel-info" style="width: 800px !important; margin: auto">
  <div class="panel-heading">
    Выписка
  </div>
  <form action='#' method="post" id="lv_doc">
    <input type="hidden" name="id" value="${doc.id}"/>
    <input type="hidden" name="doc_code" value="vypiska"/>
    <div class="panel-body">
      <table class="formTable" style="width:100%;">
        <tr>
          <td style="font-weight: bold; text-align: center" colspan="2">
            ВЫПИСКА
          </td>
        </tr>
        <tr>
          <td><b>Пациент(ка):</b> ${patient.fio}</td>
          <td><b>Год рождения:</b> ${patient.birthyear}</td>
        </tr>
        <tr>
          <td nowrap class="bold">находился на стац. лечении в клинике с <fmt:formatDate pattern = "dd.MM.yyyy" value = "${patient.dateBegin}" /> по:
          <td><input name="Date_End" id="Date_End" type="text" class="form-control datepicker" value="<fmt:formatDate pattern = "dd.MM.yyyy" value = "${patient.dateEnd}" />"/>
        </tr>
        <tr><td colspan="2"><b>Клинический диагноз</b></td></tr>
        <tr>
          <td colspan="2">
            <table style="width:100%">
              <tr>
                <td style="width:100px"><a href="#" onclick="window.open('/mkb/index.s', '_blank')">МКБ 10</a>:</td>
                <td>
                  <input type="hidden" name="mkb_id" id="mkb_id" value="${doc.mkb_id}"/>
                  <input type="text" readonly name="mkb" id="mkb" class="form-control" value="${doc.mkb}"/>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Основной диагноз
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('vyp_c1', 'c1'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('vyp_c1', 'c1'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><textarea id="c1" name="c1" style="width: 100%" rows="8" cols="2">${doc.c1}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Сопуствующие болезни
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('vyp_c8', 'c8'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('vyp_c8', 'c8'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><textarea id="c8" name="c8" style="width: 100%" rows="8" cols="2">${doc.c8}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Осложнение
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('vyp_c9', 'c9'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('vyp_c9', 'c9'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><textarea id="c9" name="c9" style="width: 100%" rows="8" cols="2">${doc.c9}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Жалобы при поступлении:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('vyp_c2', 'c2'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('vyp_c2', 'c2'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><textarea id="c2" name="c2" style="width: 100%" rows="8" cols="2">${doc.c2}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Из анамнеза:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('vyp_c3', 'c3'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('vyp_c3', 'c3'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><textarea id="c3" name="c3" style="width: 100%" rows="8" cols="2">${doc.c3}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Состояние при поступлении:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('vyp_c4', 'c4'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('vyp_c4', 'c4'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><textarea id="c4" name="c4" style="width: 100%" rows="8" cols="2">${doc.c4}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Проведённые исследования:
            <a title="Результаты" style="float: right; font-weight: bold" class="btn btn-xs btn-default" onclick="getResult (); return false;">
              <span class="fa fa-flask"></span> Обновить
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><textarea id="c5" name="c5" style="width: 100%" rows="8" cols="2">${doc.c5}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Проведено лечение:
            <a title="Результаты" style="float: right; font-weight: bold" class="btn btn-xs btn-default" onclick="getDrugResult (); return false;">
              <span class="fa fa-flask"></span> Обновить
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><textarea id="c6" name="c6" style="width: 100%" rows="8" cols="2">${doc.c6}</textarea></td>
        </tr>





        <tr><td colspan="2"><b>Диагноз при выписке</b></td></tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Основной диагноз
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('vyp_c10', 'c10'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('vyp_c10', 'c10'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><textarea id="c10" name="c10" style="width: 100%" rows="8" cols="2">${doc.c10}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Сопуствующие болезни
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('vyp_c11', 'c11'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('vyp_c11', 'c11'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><textarea id="c11" name="c11" style="width: 100%" rows="8" cols="2">${doc.c11}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Осложнение
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('vyp_c12', 'c12'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('vyp_c12', 'c12'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><textarea id="c12" name="c12" style="width: 100%" rows="8" cols="2">${doc.c12}</textarea></td>
        </tr>




        <tr>
          <td nowrap class="bold" colspan="2">
            <c:if test="${!dieFlag}">
              Рекомендовано:
            </c:if>
            <c:if test="${dieFlag}">
              Посмертный диагноз:
            </c:if>
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('vyp_c7', 'c7'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('vyp_c7', 'c7'); return false;">
              <span class="fa fa-plus"></span>
            </a>
            <a title="Распечатать рекомендацию" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="printRecommend(); return false;">
              <span class="fa fa-print"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><textarea id="c7" name="c7" style="width: 100%" rows="8" cols="2">${doc.c7}</textarea></td>
        </tr>
      </table>
    </div>
    <div class="panel-footer" style="display: none">
      <button id=saveBtn type="button" onclick="saveDoc()">Сохранить</button>
    </div>
  </form>
</div>
