<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="/res/editor/nicEdit.js" type="text/javascript"></script>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<script>
  bkLib.onDomLoaded(nicEditors.allTextAreas);
  function getResult() {
    $.ajax({
      url:'/lv/results.s',
      data:'',
      method:'post',
      dataType:'json',
      success:function(res) {
        nicEditors.findEditor("c4").setContent(res.results);
      }
    });
  }
  function setMkb(text, id) {
    var obos =  nicEditors.findEditor('c5').getContent();
    $('#mkb').val(text);
    $('#mkb_id').val(id);
    nicEditors.findEditor('c5').setContent(obos.length > 0 && obos != '<br>' ? obos + ', ' + text : text);
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
        if(res.success) {
          alert('Данные успешно сохранены');
        } else {
          alert(res.msg);
        }
      }
    });
  }
</script>
<form id="doc_form" action="#"></form>
<div class="panel panel-info" style="width: 800px !important; margin: auto">
  <div class="panel-heading">
    КЛИНИК ТАШХИСНИ АСОСЛАШ
  </div>
  <form action='#' method="post" id="lv_doc">
    <input type="hidden" name="id" value="${doc.id}"/>
    <input type="hidden" name="doc_code" value="obos"/>
    <div class="panel-body">
      <table class="formTable" style="width:100%">
        <tr>
          <td>Сана:</td>
          <td><input id="Doc_Date" type="text" class="form-control datepicker" name="c8" value="${doc.c8}"/></td>
        </tr>
        <tr>
          <td><b>Бемор:</b> ${patient.fio}</td>
          <td><b>Тугилган йили:</b> ${patient.birthyear}</td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Шикоятлар:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('obos_c1', 'c1'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('obos_c1', 'c1'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><textarea name="c1" id="c1" style="width: 100%;" rows="8" cols="2">${doc.c1}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Anamnesis:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('obos_c2', 'c2'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('obos_c2', 'c2'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><textarea name="c2" id="c2" style="width: 100%" rows="8" cols="2">${doc.c2}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Status praesens:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('obos_c3', 'c3'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('obos_c3', 'c3'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><textarea name="c3" id="c3" style="width: 100%" rows="8" cols="2">${doc.c3}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">Текширув ва тахлиллар:
            <a title="Результаты" style="float: right; font-weight: bold" class="btn btn-xs btn-default" onclick="getResult (); return false;">
              <span class="fa fa-flask"></span> Обновить
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><textarea name="c4" id="c4" style="width: 100%" rows="8" cols="2">${doc.c4}</textarea></td>
        </tr>
        <tr><td colspan="2" class="bold">Ташхис</td></tr>
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
            Асосий
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('obos_c5', 'c5'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('obos_c5', 'c5'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><textarea name="c5" id="c5" style="width: 100%" rows="8" cols="2">${doc.c5}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Хамрох
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('obos_c6', 'c6'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('obos_c6', 'c6'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><textarea name="c6" id="c6" style="width: 100%" rows="8" cols="2">${doc.c6}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Асорати
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('obos_c7', 'c7'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('obos_c7', 'c7'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><textarea name="c7" id="c7" style="width: 100%" rows="8" cols="2">${doc.c7}</textarea></td>
        </tr>
      </table>
    </div>
    <div class="panel-footer" style="display: none">
      <button id=saveBtn type="button" onclick="saveDoc()">Сохранить</button>
    </div>
  </form>
</div>
