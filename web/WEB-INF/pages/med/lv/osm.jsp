<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="f" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link href="/res/quill/quill.snow.css" rel="stylesheet">
<script src="/res/quill/quill.js" type="text/javascript"></script>
<script src="/res/bs/jquery/jquery.min.js" type="text/javascript"></script>
<script src="/res/bs/bootstrap/js/bootstrap.min.js" type="text/javascript"></script>
<link href="/res/css/styles.css" rel="stylesheet">
<link href="/res/bs/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script src="/res/js/fms-calendar.js" type="text/javascript"></script>
<link href="/res/bs/font-awesome/css/font-awesome.min.css" rel="stylesheet">
<script src="/res/js/common.js" type="text/javascript"></script>
<script src="/res/js/fms-templates.js" type="text/javascript"></script>
<style>
  .osm-editor .ql-editor { min-height: 150px; max-height: 420px; overflow-y: auto; font-size: 14px; }
  .osm-editor.ql-container { border-bottom-left-radius: 6px; border-bottom-right-radius: 6px; }
  .ql-toolbar.ql-snow { border-top-left-radius: 6px; border-top-right-radius: 6px; }
</style> 
<script type="text/javascript">
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
  function setMkb(text, id) {
    var q = window.quills['c5'];
    $('#mkb').val(id);
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
    БУЛИМДАГИ КУРИК
  </div>
  <form action='#' method="post" id="lv_doc">
    <input type="hidden" name="id" value="${doc.id}"/>
    <input type="hidden" name="doc_code" value="osm"/>
    <div class="panel-body">
      <table class="formTable" style="width:100%">
        <tr>
          <td><b>Бемор:</b> ${patient.fio}</td>
          <td><b>Тугилган йили:</b> ${patient.birthyear}</td>
          <td><b>Сана:</b></td>
          <td class="wpx-200"><input id="Doc_Date" type="text" class="form-control fms-cal" autocomplete="off" placeholder="дд.мм.гггг" name="c7" value="${doc.c7}"/></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="4">
            Шикоятлар:
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('osm_c1', 'c1'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('osm_c1', 'c1'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <td colspan="4"><textarea name="c1" id="c1" style="display:none" rows="8" cols="2">${doc.c1}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="4">
            Anamnesis morbi:
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('osm_c2', 'c2'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('osm_c2', 'c2'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <td colspan="4"><textarea name="c2" id="c2" style="display:none" rows="8" cols="2">${doc.c2}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="4">
            Anamnesis vitae:
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('osm_c8', 'c8'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('osm_c8', 'c8'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <td colspan="4"><textarea name="c8" id="c8" style="display:none" rows="8" cols="2">${doc.c8}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="4">
            Status praesens:
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('osm_c3', 'c3'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('osm_c3', 'c3'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <td colspan="4"><textarea name="c3" id="c3" style="display:none" rows="8" cols="2">${doc.c3}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="4">
            Нафас олиш системаси:
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('osm_c9', 'c9'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('osm_c9', 'c9'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <td colspan="4"><textarea name="c9" id="c9" style="display:none" rows="8" cols="2">${doc.c9}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="4">
            Қон айланиш системаси:
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('osm_c10', 'c10'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('osm_c10', 'c10'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <td colspan="4"><textarea name="c10" id="c10" style="display:none" rows="8" cols="2">${doc.c10}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="4">
            Хазм қилиш cистемаси:
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('osm_c11', 'c11'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('osm_c11', 'c11'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <td colspan="4"><textarea name="c11" id="c11" style="display:none" rows="8" cols="2">${doc.c11}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="4">
            Сийдик-таносил системаси:
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('osm_c12', 'c12'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('osm_c12', 'c12'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <td colspan="4"><textarea name="c12" id="c12" style="display:none" rows="8" cols="2">${doc.c12}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="4">
            Нерв системаси:
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('osm_c13', 'c13'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('osm_c13', 'c13'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <td colspan="4"><textarea name="c13" id="c13" style="display:none" rows="8" cols="2">${doc.c13}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="4">
            Эндокрин системаси:
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('osm_c14', 'c14'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('osm_c14', 'c14'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <td colspan="4"><textarea name="c14" id="c14" style="display:none" rows="8" cols="2">${doc.c14}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="4">
            Қалқонсимон без:
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('osm_c15', 'c15'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('osm_c15', 'c15'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <td colspan="4"><textarea name="c15" id="c15" style="display:none" rows="8" cols="2">${doc.c15}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="4">
            Меьда ости бези:
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('osm_c16', 'c16'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('osm_c16', 'c16'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <td colspan="4"><textarea name="c16" id="c16" style="display:none" rows="8" cols="2">${doc.c16}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="4">
            Стационар даволанишдан олдинги муолажалар:
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('osm_c4', 'c4'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('osm_c4', 'c4'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <td colspan="4"><textarea name="c4" id="c4" style="display:none" rows="8" cols="2">${doc.c4}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="4">
            Тахминий ташхис: Асосий <a onclick="window.open('/mkb/index.s', '_blank')" href="#">МКБ 10</a>
            <input type="hidden" name="mkb" id="mkb" value="${doc.mkb}"/>
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('osm_c5', 'c5'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('osm_c5', 'c5'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <td colspan="4"><textarea name="c5" id="c5" style="display:none" rows="8" cols="2">${doc.c5}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="4">
            Тахминий ташхис: Хамрох
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('osm_c18', 'c18'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('osm_c18', 'c18'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <td colspan="4"><textarea name="c18" id="c18" style="display:none" rows="8" cols="2">${doc.c18}</textarea></td>
        </tr>
        <tr>
          <td nowrap class="bold" colspan="4">
            Тахминий ташхис: Асорати
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('osm_c19', 'c19'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('osm_c19', 'c19'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
          </td>
        </tr>
        <tr>
          <td colspan="4"><textarea name="c19" id="c19" style="display:none" rows="8" cols="2">${doc.c19}</textarea></td>
        </tr>
      </table>
    </div>
    <div class="panel-footer" style="display: none">
      <button id=saveBtn type="button" onclick="saveDoc()">Сохранить</button>
    </div>
  </form>
</div>
