<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Амбулаторные услуги → услуга пациента: карточка слева, справа бланк анализа (фрагментом из /amb/doWork.s?frag=1)
     или текстовое заключение (поля услуги в редакторе Quill, шаблоны через fmsTpl). Сохранение — /amb/work.s, подтверждение — /amb/confirmService.s --%>
<%@include file="/WEB-INF/pages/core/forms/style.jsp"%>
<c:set var="svDone" value="${service.state == 'DONE'}"/>
<c:set var="svText" value="${kind == 'text'}"/>
<c:if test="${svText}">
  <link href="/res/quill/quill.snow.css" rel="stylesheet">
  <script src="/res/quill/quill.js" type="text/javascript"></script>
  <script src="/res/quill/quill-fms.js?v=2026101501" type="text/javascript" charset="UTF-8"></script>
  <script src="/res/js/fms-templates.js?v=4" type="text/javascript" charset="UTF-8"></script>
</c:if>
<%@include file="/WEB-INF/pages/med/amb/svc_style.jsp"%>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa ${svText ? 'fa-stethoscope' : 'fa-flask'}"></i></span>
        <div>
          <h2>${service.service.name}</h2>
          <span class="fm-count">${fn:escapeXml(patient.surname)} ${fn:escapeXml(patient.name)} ${fn:escapeXml(patient.middlename)}</span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <c:if test="${service.result > 0 && service.service.consul == 'Y'}">
        <button type="button" class="fm-btn" onclick="svModal('Результаты обследования', '/amb/results.s?id=${patient.id}&cur=${service.id}')"><i class="fa fa-flask"></i>Результаты</button>
      </c:if>
      <c:if test="${canEdit && !svDone}">
        <button type="button" class="fm-btn" id="svSave" onclick="svSave(false)" title="Ctrl+S"><i class="fa fa-floppy-o"></i>Сохранить</button>
        <button type="button" class="fm-btn primary" id="svConf" onclick="svSave(true)"><i class="fa fa-check"></i>Сохранить и подтвердить</button>
      </c:if>
      <c:if test="${canEdit && svDone}">
        <button type="button" class="fm-btn" id="svFix" onclick="svFix()" title="Услуга подтверждена; изменить результат"><i class="fa fa-pencil"></i>Исправить</button>
        <button type="button" class="fm-btn primary" id="svSave" style="display:none" onclick="svSave(false)"><i class="fa fa-floppy-o"></i>Сохранить исправление</button>
      </c:if>
      <c:if test="${service.result > 0}">
        <button type="button" class="fm-btn" onclick="window.open('/amb/print.s?ids=${service.id}_')"><i class="fa fa-print"></i>Печать</button>
      </c:if>
      <button type="button" class="fm-btn" onclick="setPage('${backUrl}')"><i class="fa fa-arrow-left"></i>Назад</button>
    </div>
    <div class="fm-table-wrap" style="padding:0">
      <div class="sv-wrap">
        <div class="sv-card">
          <div class="sv-info">
            <div>
              <c:choose>
                <c:when test="${svDone}"><span class="sv-st done">Выполнено</span></c:when>
                <c:when test="${service.result > 0}"><span class="sv-st fill">Заполнено, не подтверждено</span></c:when>
                <c:otherwise><span class="sv-st new">К выполнению</span></c:otherwise>
              </c:choose>
            </div>
            <div><span class="l">Пациент</span><b>${fn:escapeXml(patient.surname)} ${fn:escapeXml(patient.name)} ${fn:escapeXml(patient.middlename)}</b></div>
            <div><span class="l">№ · год рождения</span>${patient.id}<c:if test="${not empty patient.birthyear}"> · ${patient.birthyear}</c:if><c:if test="${not empty patient.sex}"> · ${patient.sex.name}</c:if></div>
            <c:if test="${not empty patient.tel}"><div><span class="l">Телефон</span>${fn:escapeXml(patient.tel)}</div></c:if>
            <div><span class="l">Регистрация</span><fmt:formatDate pattern="dd.MM.yyyy HH:mm" value="${patient.regDate}"/></div>
            <div><span class="l">Врач</span>${service.worker.fio}</div>
            <c:if test="${svDone}"><div><span class="l">Подтверждено</span><fmt:formatDate pattern="dd.MM.yyyy HH:mm" value="${service.confDate}"/></div></c:if>
            <c:if test="${!canEdit}"><div class="sv-note"><i class="fa fa-lock"></i> Услуга назначена другому врачу — только просмотр</div></c:if>
          </div>
        </div>
        <div class="sv-card" id="svCard">
          <c:if test="${!svText}">
            <div class="sv-head"><h3>Результаты</h3><span class="fm-hint">Enter — следующее поле</span></div>
            <div class="sv-body" id="svBody"><div class="sv-load"><i class="fa fa-spinner fa-spin"></i></div></div>
          </c:if>
          <c:if test="${svText}">
            <div class="sv-head"><h3>Заключение</h3></div>
            <div class="sv-txt" id="svBody">
              <c:forEach items="${fields}" var="f">
                <div>
                  <div class="sv-lbl"><span>${f.name}</span><span class="sp"></span>
                    <div class="btn-group">
                      <button type="button" class="btn btn-xs btn-default dropdown-toggle sv-tpl" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
                      <ul class="dropdown-menu pull-right">
                        <li><a href="#" onclick="fmsTpl.pick('${service.service.id}_${f.code}', '${f.code}'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                        <li><a href="#" onclick="fmsTpl.save('${service.service.id}_${f.code}', '${f.code}'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
                      </ul>
                    </div>
                  </div>
                  <textarea id="${f.code}" class="sv-src" style="display:none">${fn:escapeXml(f.value)}</textarea>
                  <div class="sv-q" data-code="${f.code}"></div>
                </div>
              </c:forEach>
              <c:if test="${empty fields}"><div class="sv-load">У услуги не настроены поля заключения</div></c:if>
              <c:if test="${service.service.diagnoz == 'Y'}">
                <div>
                  <div class="sv-lbl"><span>Диагноз</span><span class="sp"></span>
                    <div class="btn-group">
                      <button type="button" class="btn btn-xs btn-default dropdown-toggle sv-tpl" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
                      <ul class="dropdown-menu pull-right">
                        <li><a href="#" onclick="fmsTpl.pick('${service.service.id}_diagnoz', 'diagnoz'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                        <li><a href="#" onclick="fmsTpl.save('${service.service.id}_diagnoz', 'diagnoz'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
                      </ul>
                    </div>
                  </div>
                  <input type="text" id="diagnoz" class="sv-in" maxlength="2000" value="${fn:escapeXml(service.diagnoz)}"/>
                </div>
              </c:if>
            </div>
          </c:if>
        </div>
      </div>
    </div>
  </div>
</div>
<div class="fm-overlay" id="svOv" onclick="if (event.target === this) $(this).removeClass('open')">
  <div class="fm-modal" style="width:1100px">
    <div class="fm-modal-head"><h3 id="svOvT"></h3><button type="button" class="fm-x" onclick="$('#svOv').removeClass('open')"><i class="fa fa-times"></i></button></div>
    <div class="fm-modal-body" id="svOvB"></div>
  </div>
</div>
<script>
  (function () {
    var body = $('#svBody'), card = $('#svCard'), done = ${svDone ? 'true' : 'false'}, canEdit = ${canEdit ? 'true' : 'false'};
    var text = ${svText ? 'true' : 'false'}, fixing = false, orig = '', codes = [];
    function fields() { return body.find('input[name], select[name], textarea[name]'); }
    function ser() {
      if (!text) return fields().serialize();
      var d = [];
      for (var i = 0; i < 10; i++) d.push('f' + (i + 1) + '=' + encodeURIComponent(codes[i] && window.quills[codes[i]] ? getEditorHtml(codes[i]) : ''));
      if ($('#diagnoz').length) d.push('diagnoz=' + encodeURIComponent($.trim($('#diagnoz').val())));
      return d.join('&');
    }
    function mark() { card.toggleClass('dirty', ser() !== orig); }
    function lock(on) {
      fields().prop('disabled', on);
      if (text) {
        $.each(codes, function (i, c) { if (window.quills[c]) window.quills[c].enable(!on); });
        $('#diagnoz').prop('disabled', on);
        body.find('.sv-tpl').prop('disabled', on);
      }
    }
    if (text) {
      window.quills = window.quills || {};
      body.find('.sv-q').each(function () {
        var c = $(this).attr('data-code');
        var q = new Quill(this, {theme: 'snow', modules: {toolbar: [['bold', 'italic', 'underline', 'strike'], [{list: 'ordered'}, {list: 'bullet'}], [{script: 'sub'}, {script: 'super'}], ['clean']]}});
        var html = $('#' + c).val();
        if ($.trim(html)) q.setContents(q.clipboard.convert({html: html}), 'silent');
        window.quills[c] = q;
        window.quillRange = window.quillRange || {};
        q.on('selection-change', function (rg) { if (rg) window.quillRange[c] = rg; });
        q.on('text-change', mark);
        codes.push(c);
      });
      $('#diagnoz').on('input', mark);
      lock(done || !canEdit);
      orig = ser();
      if (!done && canEdit && codes.length) window.quills[codes[0]].focus();
    } else svFrag(body, ${service.id}, function () {
      if (done || !canEdit) lock(true);
      orig = ser();
      if (!done && canEdit) fields().filter('input:not([type=hidden])').filter(function () { return this.value === ''; }).first().focus();
    });
    body.on('input change', 'input, select, textarea', mark);
    body.on('keydown', 'input', function (e) {
      if (text || (e.keyCode != 13 && e.keyCode != 40 && e.keyCode != 38)) return;
      e.preventDefault();
      var all = body.find('input:not([disabled]):not([type=hidden]):visible'), i = all.index(this);
      var next = all.eq(e.keyCode == 38 ? Math.max(i - 1, 0) : i + 1);
      if (next.length) next.focus().select();
    });
    window.svFix = function () {
      fixing = true;
      lock(false);
      $('#svFix').hide();
      $('#svSave').show();
    };
    window.svSave = function (confirm) {
      if (!canEdit || (done && !fixing)) return;
      var dirty = ser() !== orig;
      if (text && codes.length && !getEditorHtml(codes[0])) { FmsToast.show('Не заполнено поле «' + body.find('.sv-lbl span').first().text() + '»', 'info'); return; }
      if (!dirty && !confirm) { FmsToast.show('Изменений нет', 'info'); return; }
      if (confirm && !dirty && ${service.result > 0 ? 'false' : 'true'}) { FmsToast.show('Сначала заполните результат', 'info'); return; }
      var go = function () {
        $('#svSave, #svConf').prop('disabled', true);
        var fin = function (ok) {
          $('#svSave, #svConf').prop('disabled', false);
          if (!ok) return;
          FmsToast.show(confirm ? 'Сохранено и подтверждено' : 'Сохранено', 'ok');
          setPage('/amb/svc.s?id=${service.id}');
        };
        var conf = function () {
          if (!confirm) { fin(true); return; }
          $.ajax({url: '/amb/confirmService.s', method: 'post', data: 'id=${service.id}', dataType: 'json',
            success: function (res) { if (!res.success) FmsToast.show(res.msg || 'Не удалось подтвердить', 'err'); fin(res.success); },
            error: function () { fin(false); }});
        };
        if (!dirty) { conf(); return; }
        $.ajax({url: '/amb/work.s', method: 'post', dataType: 'json', data: (text ? 'id=${service.id}&' : '') + ser(),
          success: function (res) { if (!res.success) { FmsToast.show(res.msg || 'Не удалось сохранить', 'err'); fin(false); } else conf(); },
          error: function () { fin(false); }});
      };
      if (confirm) FmsConfirm('Подтвердить услугу? После подтверждения изменить результат можно только кнопкой «Исправить».', go, null, {ok: 'Подтвердить'});
      else go();
    };
    window.svModal = function (title, url) {
      $('#svOvT').text(title);
      $('#svOvB').html('<div class="sv-load"><i class="fa fa-spinner fa-spin"></i></div>').load(url);
      $('#svOv').addClass('open');
    };
    $(document).off('keydown.sv').on('keydown.sv', function (e) {
      if (!document.getElementById('svBody')) { $(document).off('keydown.sv'); return; }
      if ((e.ctrlKey || e.metaKey) && e.keyCode == 83) { e.preventDefault(); if ($('#svSave:visible').length) svSave(false); }
    });
  })();
</script>
