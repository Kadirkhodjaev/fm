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
<link href="/res/quill/quill.snow.css" rel="stylesheet">
<script src="/res/quill/quill.js" type="text/javascript"></script>
<script src="/res/js/fms-calendar.js" type="text/javascript"></script>
<script src="/res/js/fms-templates.js" type="text/javascript"></script>

<style>
  .osm-editor .ql-editor { min-height: 150px; max-height: 420px; overflow-y: auto; font-size: 14px; }
  .osm-editor.ql-container { border-bottom-left-radius: 6px; border-bottom-right-radius: 6px; }
  .ql-toolbar.ql-snow { border-top-left-radius: 6px; border-top-right-radius: 6px; }
</style>
<script type="text/javascript">
  window.quills = window.quills || {};
  window.quillRange = window.quillRange || {};
  $(function () {
    $('#lv_doc textarea').each(function () {
      var ta = this;
      var host = $('<div class="osm-editor"></div>').insertAfter(ta)[0];
      var q = new Quill(host, {
        theme: 'snow',
        modules: {
          toolbar: [['bold', 'italic', 'underline', 'strike'], [{list: 'ordered'}, {list: 'bullet'}], [{script: 'sub'}, {script: 'super'}], ['clean']]
        }
      });
      if (ta.value && ta.value.trim() !== '')
        q.setContents(q.clipboard.convert({html: ta.value}), 'silent');
      window.quills[ta.id] = q;
      q.on('selection-change', function (r) { if (r) window.quillRange[ta.id] = r; });
    });
  });
  function getResult() {
    $.ajax({
      url:'/lv/results.s',
      data:'',
      method:'post',
      dataType:'json',
      success:function(res) {
        setEditorHtml('c5', res.results);
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
        setEditorHtml('c6', res.results);
      }
    });
  }
  function setMkb(text, id) {
    var q = window.quills['c1'];
    $('#mkb').val(text);
    $('#mkb_id').val(id);
    var hasText = q.getText().trim().length > 0;
    q.insertText(q.getLength() - 1, (hasText ? ', ' : '') + text);
  }
  function printRecommend() {
    window.open('/lv/print_recommend.s');
  }
  function saveDoc() {
    $('#doc_form').html('');
    $('#lv_doc input[name], #lv_doc textarea[name]').each((i, v) => {
      let input = $('<input type="hidden" name="' + v.name + '"/>');
      input.val(v.tagName == 'TEXTAREA' ? getEditorHtml(v.id) : v.value);
      $('#doc_form').append(input);
    })
    $.ajax({
      url: '/lv/doc/save.s',
      method: 'post',
      data: $('#doc_form').serialize(),
      dataType: 'json',
      success: function (res) {
        openMsg(res)
        if(res.success && res.id)
          $('#lv_doc input[name=id]').val(res.id);
      }
    });
  }
</script>
<form id="doc_form" action="#"></form>
<div class="panel panel-info" style="width: 1100px !important; margin: auto">
  <div class="panel-heading">
    Выписка
  </div>
  <form action='#' method="post" id="lv_doc">
    <input type="hidden" name="id" value="${doc.id}"/>
    <input type="hidden" name="doc_code" value="vypiska"/>
    <div class="panel-body">
      <table class="formTable" style="width:100%;">
        <tr>
          <td><b>Пациент(ка):</b> ${patient.fio}</td>
          <td><b>Год рождения:</b> ${patient.birthyear}</td>
          <td nowrap class="bold"><b>Дата выписки:</b></td>
          <td class="wpx-200"><input name="Date_End" id="Date_End" type="text" class="form-control fms-cal" autocomplete="off" value="<fmt:formatDate pattern = "dd.MM.yyyy" value = "${patient.dateEnd}" />"/>
        </tr>
        <tr><td colspan="4"><b>Клинический диагноз</b></td></tr>
        <tr>
          <td colspan="4">
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
          <td nowrap class="bold" colspan="4">
            Основной диагноз
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('vyp_c1', 'c1'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('vyp_c1', 'c1'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <td colspan="4"><textarea id="c1" name="c1" style="display:none" rows="8" cols="2">${doc.c1}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="4">
            Сопуствующие болезни
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('vyp_c8', 'c8'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('vyp_c8', 'c8'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <td colspan="4"><textarea id="c8" name="c8" style="display:none" rows="8" cols="2">${doc.c8}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="4">
            Осложнение
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('vyp_c9', 'c9'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('vyp_c9', 'c9'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <td colspan="4"><textarea id="c9" name="c9" style="display:none" rows="8" cols="2">${doc.c9}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="4">
            Жалобы при поступлении:
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('vyp_c2', 'c2'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('vyp_c2', 'c2'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <td colspan="4"><textarea id="c2" name="c2" style="display:none" rows="8" cols="2">${doc.c2}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="4">
            Из анамнеза:
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('vyp_c3', 'c3'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('vyp_c3', 'c3'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <td colspan="4"><textarea id="c3" name="c3" style="display:none" rows="8" cols="2">${doc.c3}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="4">
            Состояние при поступлении:
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('vyp_c4', 'c4'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('vyp_c4', 'c4'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <td colspan="4"><textarea id="c4" name="c4" style="display:none" rows="8" cols="2">${doc.c4}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="4">
            Проведённые исследования:
            <a title="Результаты" style="float: right; font-weight: bold" class="btn btn-xs btn-default" onclick="getResult (); return false;">
              <span class="fa fa-flask"></span> Обновить
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="4"><textarea id="c5" name="c5" style="display:none" rows="8" cols="2">${doc.c5}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="4">
            Проведено лечение:
            <a title="Результаты" style="float: right; font-weight: bold" class="btn btn-xs btn-default" onclick="getDrugResult (); return false;">
              <span class="fa fa-flask"></span> Обновить
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="4"><textarea id="c6" name="c6" style="display:none" rows="8" cols="2">${doc.c6}</textarea></td>
        </tr>





        <tr><td colspan="4"><b>Диагноз при выписке</b></td></tr>
        <tr>
          <td nowrap class="bold" colspan="4">
            Основной диагноз
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('vyp_c10', 'c10'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('vyp_c10', 'c10'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <td colspan="4"><textarea id="c10" name="c10" style="display:none" rows="8" cols="2">${doc.c10}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="4">
            Сопуствующие болезни
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('vyp_c11', 'c11'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('vyp_c11', 'c11'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <td colspan="4"><textarea id="c11" name="c11" style="display:none" rows="8" cols="2">${doc.c11}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="4">
            Осложнение
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('vyp_c12', 'c12'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('vyp_c12', 'c12'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <td colspan="4"><textarea id="c12" name="c12" style="display:none" rows="8" cols="2">${doc.c12}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="4">
            <c:if test="${!dieFlag}">
              Рекомендовано:
            </c:if>
            <c:if test="${dieFlag}">
              Посмертный диагноз:
            </c:if>
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('vyp_c7', 'c7'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('vyp_c7', 'c7'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
            <a title="Распечатать рекомендацию" style="float: right;padding:3px" class="btn btn-xs btn-default" onclick="printRecommend(); return false;">
              <span class="fa fa-print"></span>
            </a>
          </td>
        </tr>
        <tr>
          <td colspan="4"><textarea id="c7" name="c7" style="display:none" rows="8" cols="2">${doc.c7}</textarea></td>
        </tr>
      </table>
    </div>
    <div class="panel-footer" style="display: none">
      <button id=saveBtn type="button" onclick="saveDoc()">Сохранить</button>
    </div>
  </form>
</div>
