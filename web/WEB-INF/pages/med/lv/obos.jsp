<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/res/quill/quill.snow.css" rel="stylesheet">
<script src="/res/quill/quill.js" type="text/javascript"></script>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js"></script>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script src="/res/js/common.js?v=2026101309" type="text/javascript"></script>
<script src="/res/js/fms-templates.js?v=4" type="text/javascript" charset="UTF-8"></script>
<script src="/res/js/fms-calendar.js" type="text/javascript"></script>
<style>
  .osm-editor .ql-editor { min-height: 150px; max-height: 420px; overflow-y: auto; font-size: 14px; }
  .osm-editor.ql-container { border-bottom-left-radius: 6px; border-bottom-right-radius: 6px; }
  .ql-toolbar.ql-snow { border-top-left-radius: 6px; border-top-right-radius: 6px; }
</style>
<script>
  window.quills = window.quills || {};
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
      window.quillRange = window.quillRange || {};
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
        setEditorHtml('c4', res.results);
      }
    });
  }
  function setMkb(text, id) {
    var q = window.quills['c5'];
    $('#mkb').val(text);
    $('#mkb_id').val(id);
    var hasText = q.getText().trim().length > 0;
    q.insertText(q.getLength() - 1, (hasText ? ', ' : '') + text);
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
        FmsToast.show(res.success ? 'Сохранено' : (res.msg || 'Не удалось сохранить'), res.success ? 'ok' : 'err');
        if(res.success && res.id)
          $('#lv_doc input[name=id]').val(res.id);
      }
    });
  }
</script>
<%@include file="/WEB-INF/pages/med/lv/doc_style.jsp"%>
<form id="doc_form" action="#"></form>
<div class="ld-sheet">
  <div class="ld-title">КЛИНИК ТАШХИСНИ АСОСЛАШ</div>
  <form action='#' method="post" id="lv_doc">
    <input type="hidden" name="id" value="${doc.id}"/>
    <input type="hidden" name="doc_code" value="obos"/>
    <div class="ld-body">

        <div class="ld-head"></div>
        <div class="ld-raw"><b>Бемор:</b> ${patient.fio}<b>Тугилган йили:</b> ${patient.birthyear}<b>Сана:</b><input id="Doc_Date" type="text" class="form-control fms-cal" autocomplete="off" placeholder="дд.мм.гггг" name="c8" value="${doc.c8}"/>
        </div>
        <div class="ld-l">
            Шикоятлар:
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('obos_c1', 'c1'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('obos_c1', 'c1'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
        </div>
        <div class="ld-f"><textarea name="c1" id="c1" style="display:none" rows="8" cols="2">${doc.c1}</textarea>
        </div>
        <div class="ld-l">
            Anamnesis:
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('obos_c2', 'c2'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('obos_c2', 'c2'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
        </div>
        <div class="ld-f"><textarea name="c2" id="c2" style="display:none" rows="8" cols="2">${doc.c2}</textarea>
        </div>
        <div class="ld-l">
            Status praesens:
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('obos_c3', 'c3'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('obos_c3', 'c3'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
        </div>
        <div class="ld-f"><textarea name="c3" id="c3" style="display:none" rows="8" cols="2">${doc.c3}</textarea>
        </div>
        <div class="ld-l">Текширув ва тахлиллар:
            <a title="Результаты" style="float: right; font-weight: bold" class="btn btn-xs btn-default" onclick="getResult (); return false;">
              <span class="fa fa-refresh"></span> Обновить
            </a>
        </div>
        <div class="ld-f"><textarea name="c4" id="c4" style="display:none" rows="8" cols="2">${doc.c4}</textarea>
        </div>
        <div class="ld-l">Ташхис
        </div>
        <div class="ld-raw">
            <table style="width:100%">
              <tr>
                <td style="width:100px"><a href="#" onclick="window.open('/mkb/index.s', '_blank')">МКБ 10</a>:</td>
                <td>
                  <input type="hidden" name="mkb_id" id="mkb_id" value="${doc.mkb_id}"/>
                  <input type="text" readonly name="mkb" id="mkb" class="form-control" value="${doc.mkb}"/>
                </td>
              </tr>
            </table>
        </div>
        <div class="ld-l">
            Асосий
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('obos_c5', 'c5'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('obos_c5', 'c5'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
        </div>
        <div class="ld-f"><textarea name="c5" id="c5" style="display:none" rows="8" cols="2">${doc.c5}</textarea>
        </div>
        <div class="ld-l">
            Хамрох
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('obos_c6', 'c6'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('obos_c6', 'c6'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
        </div>
        <div class="ld-f"><textarea name="c6" id="c6" style="display:none" rows="8" cols="2">${doc.c6}</textarea>
        </div>
        <div class="ld-l">
            Асорати
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('obos_c7', 'c7'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('obos_c7', 'c7'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
        </div>
        <div class="ld-f"><textarea name="c7" id="c7" style="display:none" rows="8" cols="2">${doc.c7}</textarea>
        </div>
      
    </div>
    <div style="display:none">
      <button id=saveBtn type="button" onclick="saveDoc()">Сохранить</button>
    </div>
  </form>
</div>
