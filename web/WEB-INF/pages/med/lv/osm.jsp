<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="/res/editor/nicEdit.js" type="text/javascript"></script>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet">
<script src="/res/js/common.js" type="text/javascript"></script>
<script type="text/javascript">
  bkLib.onDomLoaded(nicEditors.allTextAreas);
  function setMkb(text, id) {
    var osm =  nicEditors.findEditor('c5').getContent();
    $('#mkb').val(id);
    nicEditors.findEditor('c5').setContent(osm.length > 0 && osm != '<br>' ? osm + ', ' + text : text);
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
          setPage('/lv/doc.s?doc_code=osm');
      }
    });
  }
</script>
<form id="doc_form" action="#"></form>
<div class="panel panel-info" style="width: 800px !important; margin: auto">
  <div class="panel-heading">
    БУЛИМДАГИ КУРИК
  </div>
  <form action='#' method="post" id="lv_doc">
    <input type="hidden" name="id" value="${doc.id}"/>
    <input type="hidden" name="doc_code" value="osm"/>
    <div class="panel-body">
      <table class="formTable" style="width:100%">
        <tr>
          <td>Сана:</td>
          <td><input id="Doc_Date" type="text" class="form-control datepicker" name="c7" value="${doc.c7}"/></td>
        </tr>
        <tr>
          <td><b>Бемор:</b> ${patient.fio}</td>
          <td><b>Тугилган йили:</b> ${patient.birthyear}</td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Шикоятлар:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('osm_c1', 'c1'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('osm_c1', 'c1'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><textarea name="c1" id="c1" style="width: 100%" rows="8" cols="2">${doc.c1}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Anamnesis morbi:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('osm_c2', 'c2'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('osm_c2', 'c2'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><textarea name="c2" id="c2" style="width: 100%" rows="8" cols="2">${doc.c2}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Anamnesis vitae:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('osm_c8', 'c8'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('osm_c8', 'c8'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><textarea name="c8" id="c8" style="width: 100%" rows="8" cols="2">${doc.c8}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Status praesens:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('osm_c3', 'c3'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('osm_c3', 'c3'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><textarea name="c3" id="c3" style="width: 100%" rows="8" cols="2">${doc.c3}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Нафас олиш системаси:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('osm_c9', 'c9'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('osm_c9', 'c9'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><textarea name="c9" id="c9" style="width: 100%" rows="8" cols="2">${doc.c9}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Қон айланиш системаси:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('osm_c10', 'c10'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('osm_c10', 'c10'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><textarea name="c10" id="c10" style="width: 100%" rows="8" cols="2">${doc.c10}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Хазм қилиш cистемаси:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('osm_c11', 'c11'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('osm_c11', 'c11'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><textarea name="c11" id="c11" style="width: 100%" rows="8" cols="2">${doc.c11}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Сийдик-таносил системаси:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('osm_c12', 'c12'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('osm_c12', 'c12'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><textarea name="c12" id="c12" style="width: 100%" rows="8" cols="2">${doc.c12}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Нерв системаси:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('osm_c13', 'c13'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('osm_c13', 'c13'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><textarea name="c13" id="c13" style="width: 100%" rows="8" cols="2">${doc.c13}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Эндокрин системаси:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('osm_c14', 'c14'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('osm_c14', 'c14'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><textarea name="c14" id="c14" style="width: 100%" rows="8" cols="2">${doc.c14}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Қалқонсимон без:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('osm_c15', 'c15'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('osm_c15', 'c15'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><textarea name="c15" id="c15" style="width: 100%" rows="8" cols="2">${doc.c15}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Меьда ости бези:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('osm_c16', 'c16'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('osm_c16', 'c16'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><textarea name="c16" id="c16" style="width: 100%" rows="8" cols="2">${doc.c16}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Стационар даволанишдан олдинги муолажалар:
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('osm_c4', 'c4'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('osm_c4', 'c4'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><textarea name="c4" id="c4" style="width: 100%" rows="8" cols="2">${doc.c4}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Тахминий ташхис: Асосий <a href="/mkb/index.s" target="_blank">МКБ 10</a>
            <input type="hidden" name="mkb" id="mkb" value="${doc.mkb}"/>
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('osm_c5', 'c5'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('osm_c5', 'c5'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><textarea name="c5" id="c5" style="width: 100%" rows="8" cols="2">${doc.c5}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Тахминий ташхис: Хамрох
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('osm_c18', 'c18'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('osm_c18', 'c18'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><textarea name="c18" id="c18" style="width: 100%" rows="8" cols="2">${doc.c18}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="2">
            Тахминий ташхис: Асорати
            <a title="Сохранить как шаблон" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="saveTemplate('osm_c19', 'c19'); return false;">
              <span class="fa fa-save"></span>
            </a>
            <a title="Из шаблона" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="getTemplate('osm_c19', 'c19'); return false;">
              <span class="fa fa-plus"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="2"><textarea name="c19" id="c19" style="width: 100%" rows="8" cols="2">${doc.c19}</textarea></td>
        </tr>
      </table>
    </div>
    <div class="panel-footer" style="display: none">
      <button id=saveBtn type="button" onclick="saveDoc()">Сохранить</button>
    </div>
  </form>
</div>
