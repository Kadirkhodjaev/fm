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
<script src="/res/js/common.js?v=2026101309" type="text/javascript"></script>
<script src="/res/js/fms-templates.js?v=4" type="text/javascript" charset="UTF-8"></script>
<style>
  .osm-editor .ql-editor { min-height: 150px; max-height: 420px; overflow-y: auto; font-size: 14px; }
  .osm-editor.ql-container { border-bottom-left-radius: 6px; border-bottom-right-radius: 6px; }
  .ql-toolbar.ql-snow { border-top-left-radius: 6px; border-top-right-radius: 6px; }
  .mkb-cell { padding: 4px 3px 14px; }
  .mkb-pick { position: relative; font-size: 14px; }
  .mkb-field { display: flex; align-items: center; gap: 8px; min-height: 38px; padding: 0 4px 0 12px; background: #fff;
    border: 1px solid #ccc; border-radius: 6px; transition: border-color .15s, box-shadow .15s; }
  .mkb-field:focus-within { border-color: #9AA1AC; box-shadow: 0 0 0 3px rgba(31, 36, 48, .06); }
  .mkb-pick.mkb-error .mkb-field { border-color: #d9534f; box-shadow: 0 0 0 3px rgba(217, 83, 79, .12); }
  .mkb-ico { flex: none; color: #9AA1AC; font-size: 14px; }
  .mkb-pick.mkb-error .mkb-ico { color: #d9534f; }
  .mkb-field input.mkb-input { flex: 1; min-width: 0; height: 36px !important; padding: 0; border: 0; outline: none;
    box-shadow: none; background: transparent; font-size: 14px; color: #1F2430; }
  .mkb-input::placeholder { color: #9AA1AC; }
  .mkb-chip { flex: 1; min-width: 0; display: none; align-items: center; gap: 8px; margin: 5px 0; color: #1F2430; }
  .mkb-pick.has-value .mkb-chip { display: flex; }
  .mkb-pick.has-value .mkb-input, .mkb-pick.has-value .mkb-ico { display: none; }
  .mkb-chip-code { flex: none; padding: 3px 8px; border-radius: 5px; background: #FDECEC; color: #C62828; font-weight: 700; font-size: 13px; }
  .mkb-chip-name { min-width: 0; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
  .mkb-btn { flex: none; height: 28px; padding: 0 10px; border: 0; border-radius: 6px; background: none; color: #4B5563; font-size: 13px; font-weight: 600; cursor: pointer; }
  .mkb-btn:hover { background: #F1F2F4; color: #1F2430; }
  .mkb-btn-clear { width: 28px; padding: 0; color: #9AA1AC; }
  .mkb-pick:not(.has-value) .mkb-btn-clear { display: none; }
  .mkb-sep { flex: none; width: 1px; height: 20px; background: #E6E8EC; }
  .mkb-list { display: none; position: absolute; z-index: 1000; left: 0; right: 0; top: calc(100% + 4px); margin: 0; padding: 6px; list-style: none;
    max-height: 320px; overflow-y: auto; background: #fff; border: 1px solid #E6E8EC; border-radius: 10px; box-shadow: 0 12px 32px rgba(20, 25, 40, .14); }
  .mkb-list li a { display: flex; gap: 10px; padding: 7px 10px; border-radius: 6px; color: #1F2430; text-decoration: none; line-height: 1.35; }
  .mkb-list li a:hover, .mkb-list li.active a { background: #F1F2F4; }
  .mkb-list li.disabled a { color: #9AA1AC; cursor: default; background: none; }
  .mkb-list .mkb-code { flex: none; min-width: 56px; font-weight: 700; color: #C62828; }
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
  // Показывает выбранный диагноз плашкой: код отдельно, название рядом
  function showMkbChip(text) {
    var m = /^([A-ZА-Я]\d{2}(?:[.\-][\w.\-]*)?)\s+(.*)$/i.exec(text || '');
    $('.mkb-chip-code').text(m ? m[1] : 'МКБ').toggle(true);
    $('.mkb-chip-name').text(m ? m[2] : text).attr('title', text);
    $('.mkb-pick').toggleClass('has-value', !!$('#mkb_id').val());
  }
  function setMkb(text, id) {
    text = $.trim(text);
    $('#mkb_id').val(id);
    $('#mkb').val(text);
    $('#mkb_search').val('');
    $('#mkb_list').hide().empty();
    $('.mkb-pick').removeClass('mkb-error');
    showMkbChip(text);
    var q = window.quills['c5'];
    if (q && q.getText().indexOf(text) < 0) {
      var hasText = q.getText().trim().length > 0;
      q.insertText(q.getLength() - 1, (hasText ? ', ' : '') + text);
    }
  }
  function clearMkb() {
    $('#mkb_id, #mkb, #mkb_search').val('');
    $('#mkb_list').hide().empty();
    $('.mkb-pick').removeClass('has-value');
    $('#mkb_search').focus();
  }
  $(function () {
    var timer = null, xhr = null;
    var box = $('#mkb_list'), inp = $('#mkb_search');
    // Старые записи хранили id диагноза в поле mkb: подтягиваем название из справочника
    if (!$('#mkb_id').val() && /^\d+$/.test($('#mkb').val())) $('#mkb_id').val($('#mkb').val());
    if ($('#mkb_id').val() && !/\D/.test($('#mkb').val())) {
      showMkbChip('');
      $.post('/mkb/get.s', {id: $('#mkb_id').val()}, function (res) {
        if (res.success && res.name) {
          var t = (res.code ? res.code + ' ' : '') + res.name;
          $('#mkb').val(t);
          showMkbChip(t);
        }
      }, 'json');
    } else {
      showMkbChip($('#mkb').val());
    }
    function render(rows) {
      box.empty();
      if (!rows.length) {
        box.append('<li class="disabled"><a href="#">Ничего не найдено</a></li>');
      }
      $.each(rows, function (i, r) {
        var text = (r.code ? r.code + ' ' : '') + r.name;
        var a = $('<a href="#"></a>').attr('data-id', r.id).attr('data-text', text);
        if (r.code) a.append($('<span class="mkb-code"></span>').text(r.code));
        a.append($('<span></span>').text(r.name));
        box.append($('<li></li>').append(a));
      });
      box.show();
    }
    inp.on('input', function () {
      $('#mkb_id').val('');
      $('#mkb').val('');
      var v = $.trim(inp.val());
      clearTimeout(timer);
      if (v.length < 2) { box.hide().empty(); return; }
      timer = setTimeout(function () {
        if (xhr) xhr.abort();
        xhr = $.post('/mkb/search.s', {q: v}, function (res) {
          if (res.success) render(res.rows || []);
        }, 'json');
      }, 300);
    });
    inp.on('keydown', function (e) {
      if (!box.is(':visible')) return;
      var items = box.find('li:not(.disabled)'), cur = items.index(items.filter('.active'));
      if (e.keyCode === 40 || e.keyCode === 38) {
        e.preventDefault();
        cur = e.keyCode === 40 ? Math.min(cur + 1, items.length - 1) : Math.max(cur - 1, 0);
        items.removeClass('active').eq(cur).addClass('active');
        var el = items.eq(cur)[0];
        if (el) el.scrollIntoView({block: 'nearest'});
      } else if (e.keyCode === 13) {
        e.preventDefault();
        if (cur >= 0) items.eq(cur).find('a').click();
      } else if (e.keyCode === 27) {
        box.hide();
      }
    });
    box.on('click', 'a', function (e) {
      e.preventDefault();
      if ($(this).attr('data-id')) setMkb($(this).attr('data-text'), $(this).attr('data-id'));
    });
    $(document).on('click', function (e) {
      if (!$(e.target).closest('.mkb-pick').length) box.hide();
    });
  });
  function saveDoc() {
    if (!$('#mkb_id').val()) {
      $('.mkb-pick').addClass('mkb-error');
      $('#mkb_search')[0].scrollIntoView({block: 'center'});
      $('#mkb_search').focus();
      FmsToast.show('Выберите основной диагноз по МКБ-10: без него форму сохранить нельзя', 'err');
      return;
    }
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
  <div class="ld-title">БУЛИМДАГИ КУРИК</div>
  <form action='#' method="post" id="lv_doc">
    <input type="hidden" name="id" value="${doc.id}"/>
    <input type="hidden" name="doc_code" value="osm"/>
    <div class="ld-body">

        <div class="ld-head"><div class="ld-c"><b>Бемор:</b> ${patient.fio}</div><div class="ld-c"><b>Тугилган йили:</b> ${patient.birthyear}</div><div class="ld-c"><b>Сана:</b></div><div class="ld-c"><input id="Doc_Date" type="text" class="form-control fms-cal" autocomplete="off" placeholder="дд.мм.гггг" name="c7" value="${doc.c7}"/></div></div>
        <div class="ld-l">
            Шикоятлар:
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('osm_c1', 'c1'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('osm_c1', 'c1'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
        </div>
        <div class="ld-f"><textarea name="c1" id="c1" style="display:none" rows="8" cols="2">${doc.c1}</textarea>
        </div>
        <div class="ld-l">
            Anamnesis morbi:
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('osm_c2', 'c2'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('osm_c2', 'c2'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
        </div>
        <div class="ld-f"><textarea name="c2" id="c2" style="display:none" rows="8" cols="2">${doc.c2}</textarea>
        </div>
        <div class="ld-l">
            Anamnesis vitae:
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('osm_c8', 'c8'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('osm_c8', 'c8'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
        </div>
        <div class="ld-f"><textarea name="c8" id="c8" style="display:none" rows="8" cols="2">${doc.c8}</textarea>
        </div>
        <div class="ld-l">
            Status praesens:
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('osm_c3', 'c3'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('osm_c3', 'c3'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
        </div>
        <div class="ld-f"><textarea name="c3" id="c3" style="display:none" rows="8" cols="2">${doc.c3}</textarea>
        </div>
        <div class="ld-l">
            Нафас олиш системаси:
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('osm_c9', 'c9'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('osm_c9', 'c9'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
        </div>
        <div class="ld-f"><textarea name="c9" id="c9" style="display:none" rows="8" cols="2">${doc.c9}</textarea>
        </div>
        <div class="ld-l">
            Қон айланиш системаси:
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('osm_c10', 'c10'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('osm_c10', 'c10'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
        </div>
        <div class="ld-f"><textarea name="c10" id="c10" style="display:none" rows="8" cols="2">${doc.c10}</textarea>
        </div>
        <div class="ld-l">
            Хазм қилиш cистемаси:
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('osm_c11', 'c11'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('osm_c11', 'c11'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
        </div>
        <div class="ld-f"><textarea name="c11" id="c11" style="display:none" rows="8" cols="2">${doc.c11}</textarea>
        </div>
        <div class="ld-l">
            Сийдик-таносил системаси:
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('osm_c12', 'c12'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('osm_c12', 'c12'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
        </div>
        <div class="ld-f"><textarea name="c12" id="c12" style="display:none" rows="8" cols="2">${doc.c12}</textarea>
        </div>
        <div class="ld-l">
            Нерв системаси:
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('osm_c13', 'c13'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('osm_c13', 'c13'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
        </div>
        <div class="ld-f"><textarea name="c13" id="c13" style="display:none" rows="8" cols="2">${doc.c13}</textarea>
        </div>
        <div class="ld-l">
            Эндокрин системаси:
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('osm_c14', 'c14'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('osm_c14', 'c14'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
        </div>
        <div class="ld-f"><textarea name="c14" id="c14" style="display:none" rows="8" cols="2">${doc.c14}</textarea>
        </div>
        <div class="ld-l">
            Қалқонсимон без:
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('osm_c15', 'c15'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('osm_c15', 'c15'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
        </div>
        <div class="ld-f"><textarea name="c15" id="c15" style="display:none" rows="8" cols="2">${doc.c15}</textarea>
        </div>
        <div class="ld-l">
            Меьда ости бези:
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('osm_c16', 'c16'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('osm_c16', 'c16'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
        </div>
        <div class="ld-f"><textarea name="c16" id="c16" style="display:none" rows="8" cols="2">${doc.c16}</textarea>
        </div>
        <div class="ld-l">
            Стационар даволанишдан олдинги муолажалар:
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('osm_c4', 'c4'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('osm_c4', 'c4'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
        </div>
        <div class="ld-f"><textarea name="c4" id="c4" style="display:none" rows="8" cols="2">${doc.c4}</textarea>
        </div>
        <div class="ld-l">
            Асосий ташхис по МКБ-10 <span style="color:#d9534f" title="Обязательное поле">*</span>
        </div>
        <div class="ld-raw">
            <input type="hidden" name="mkb_id" id="mkb_id" value="${doc.mkb_id}"/>
            <input type="hidden" name="mkb" id="mkb" value="<c:out value='${doc.mkb}'/>"/>
            <div class="mkb-pick">
              <div class="mkb-field">
                <i class="fa fa-search mkb-ico"></i>
                <input type="text" id="mkb_search" class="mkb-input" autocomplete="off" placeholder="Начните вводить код или название диагноза, например I10 или гипертензия"/>
                <div class="mkb-chip" title="Выбранный диагноз">
                  <span class="mkb-chip-code"></span>
                  <span class="mkb-chip-name"></span>
                </div>
                <button class="mkb-btn mkb-btn-clear" type="button" onclick="clearMkb()" title="Убрать диагноз"><i class="fa fa-times"></i></button>
                <span class="mkb-sep"></span>
                <button class="mkb-btn" type="button" onclick="window.open('/mkb/index.s', '_blank')" title="Открыть справочник МКБ-10"><i class="fa fa-sitemap"></i> Справочник</button>
              </div>
              <ul id="mkb_list" class="mkb-list"></ul>
            </div>
        </div>
        <div class="ld-l">
            Тахминий ташхис: Асосий
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('osm_c5', 'c5'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('osm_c5', 'c5'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
        </div>
        <div class="ld-f"><textarea name="c5" id="c5" style="display:none" rows="8" cols="2">${doc.c5}</textarea>
        </div>
        <div class="ld-l">
            Тахминий ташхис: Хамрох
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('osm_c18', 'c18'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('osm_c18', 'c18'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
        </div>
        <div class="ld-f"><textarea name="c18" id="c18" style="display:none" rows="8" cols="2">${doc.c18}</textarea>
        </div>
        <div class="ld-l">
            Тахминий ташхис: Асорати
            <div class="btn-group pull-right" style="margin-left:6px">
              <button type="button" class="btn btn-xs btn-default dropdown-toggle" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
              <ul class="dropdown-menu pull-right">
                <li><a href="#" onclick="fmsTpl.pick('osm_c19', 'c19'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                <li><a href="#" onclick="fmsTpl.save('osm_c19', 'c19'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
              </ul>
            </div>
        </div>
        <div class="ld-f"><textarea name="c19" id="c19" style="display:none" rows="8" cols="2">${doc.c19}</textarea>
        </div>
      
    </div>
    <div style="display:none">
      <button id=saveBtn type="button" onclick="saveDoc()">Сохранить</button>
    </div>
  </form>
</div>
