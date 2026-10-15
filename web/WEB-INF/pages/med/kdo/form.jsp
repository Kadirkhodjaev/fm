<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- КДО → бланк одного анализа: шапка с пациентом и действиями, сам бланк фрагментом из /kdo/obs.s?frag=1 --%>
<%@include file="/WEB-INF/pages/core/forms/style.jsp"%>
<c:set var="kfDone" value="${plan.done == 'Y'}"/>
<%-- text: заключение (бланк 999) — протокол в редакторе Quill (c2) и заключение (c1), шаблоны через fmsTpl --%>
<c:if test="${text}">
  <link href="/res/quill/quill.snow.css" rel="stylesheet">
  <script src="/res/quill/quill.js" type="text/javascript"></script>
  <script src="/res/quill/quill-fms.js?v=2026101501" type="text/javascript" charset="UTF-8"></script>
  <script src="/res/js/fms-templates.js?v=4" type="text/javascript" charset="UTF-8"></script>
</c:if>
<style>
  .kf-wrap { display:grid; grid-template-columns:300px minmax(0, 860px); gap:14px; padding:14px; background:#F7F8FA; min-height:100%; align-items:start; }
  .kf-card { background:#fff; border:1px solid #E6E8EC; border-radius:14px; overflow:hidden; }
  .kf-info { padding:14px 16px; display:flex; flex-direction:column; gap:10px; font-size:13px; }
  .kf-info .l { display:block; font-size:11px; font-weight:600; color:#9AA1AC; text-transform:uppercase; letter-spacing:.3px; margin-bottom:2px; }
  .kf-info b { font-weight:600; color:#1F2430; }
  .kf-st { display:inline-flex; align-items:center; gap:7px; padding:3px 11px; border-radius:999px; font-size:12.5px; font-weight:600; }
  .kf-st::before { content:''; width:8px; height:8px; border-radius:50%; background:currentColor; }
  .kf-st.new { background:#FDECEE; color:#A50F22; }
  .kf-st.fill { background:#FEF6D6; color:#8A6100; }
  .kf-st.done { background:#E3F6EC; color:#1E7A4C; }
  .kf-head { display:flex; align-items:center; gap:10px; padding:12px 16px; border-bottom:1px solid #F0F1F4; background:#FAFBFC; }
  .kf-head h3 { flex:1; margin:0; font-size:15px; font-weight:700; }
  .kf-body { padding:8px 14px 14px; font-size:13px; overflow-x:auto; }
  /* широкий бланк: колонка бланка на всю оставшуюся ширину; если и так не влезает - прокрутка, а не обрезка */
  .kf-wrap.wide { grid-template-columns:300px minmax(0, 1fr); }
  .kf-body table { width:100% !important; border-collapse:collapse; }
  .kf-body td { padding:4px 8px !important; border:0 !important; border-bottom:1px solid #F0F1F4 !important; background:none !important; font-size:13px; }
  .kf-body tr:first-child td { color:#6B7280; font-size:11px; font-weight:600; text-transform:uppercase; letter-spacing:.3px; }
  .kf-body .form-control { height:30px; padding:2px 10px; border:1px solid #E6E8EC; border-radius:8px; box-shadow:none; font-size:13.5px; font-weight:600; }
  .kf-body textarea.form-control { height:auto; font-weight:400; }
  .kf-body .form-control:focus { outline:none; border-color:#4B5563; box-shadow:0 0 0 3px rgba(75,85,99,.12); }
  .kf-body .form-control[disabled] { background:#F5F6F8; border-color:transparent; color:#1F2430; }
  .kf-card.dirty { border-color:#F59E0B; }
  .kf-txt { padding:14px 16px 16px; display:flex; flex-direction:column; gap:14px; }
  .kf-lbl { display:flex; align-items:center; gap:8px; margin:0 0 6px; font-size:12px; font-weight:600; color:#6B7280; text-transform:uppercase; letter-spacing:.3px; }
  .kf-lbl .sp { flex:1; }
  .kf-lbl .btn-group { text-transform:none; letter-spacing:0; font-weight:400; }
  .kf-txt .ql-toolbar { border-color:#E6E8EC; border-radius:10px 10px 0 0; }
  .kf-txt .ql-container { border-color:#E6E8EC; border-radius:0 0 10px 10px; font-family:inherit; font-size:14px; }
  .kf-txt .ql-editor { min-height:260px; }
  .kf-txt .ql-disabled .ql-editor { background:#F9FAFB; }
  .kf-txt textarea { width:100%; min-height:110px; padding:10px 12px; border:1px solid #E6E8EC; border-radius:10px; font-family:inherit; font-size:14px; resize:vertical; }
  .kf-txt textarea:focus { outline:none; border-color:#4B5563; box-shadow:0 0 0 3px rgba(75,85,99,.12); }
  .kf-txt textarea[disabled] { background:#F9FAFB; color:#1F2430; }
  .kf-load { padding:30px; text-align:center; color:#9AA1AC; }
  @media (max-width: 1100px) { .kf-wrap { grid-template-columns:1fr; } }
</style>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa fa-flask"></i></span>
        <div>
          <h2>${plan.kdo.name}</h2>
          <span class="fm-count">${fn:escapeXml(p.surname)} ${fn:escapeXml(p.name)} ${fn:escapeXml(p.middlename)}</span>
        </div>
      </div>
      <span class="fm-spacer"></span>
      <c:if test="${!kfDone}">
        <button type="button" class="fm-btn" id="kfSave" onclick="kfSave(false)" title="Ctrl+S"><i class="fa fa-floppy-o"></i>Сохранить</button>
        <button type="button" class="fm-btn primary" id="kfConf" onclick="kfSave(true)"><i class="fa fa-check"></i>Сохранить и подтвердить</button>
      </c:if>
      <c:if test="${kfDone}">
        <button type="button" class="fm-btn" id="kfFix" onclick="kfFix()" title="Результат подтверждён; изменить его"><i class="fa fa-pencil"></i>Исправить</button>
        <button type="button" class="fm-btn primary" id="kfSave" style="display:none" onclick="kfSave(false)"><i class="fa fa-floppy-o"></i>Сохранить исправление</button>
      </c:if>
      <c:if test="${plan.resultId > 0}">
        <button type="button" class="fm-btn" onclick="window.open('/kdo/print.s?id=${plan.id}')"><i class="fa fa-print"></i>Печать</button>
      </c:if>
      <button type="button" class="fm-btn" onclick="setPage('/patients/list.s')"><i class="fa fa-arrow-left"></i>Назад</button>
    </div>
    <div class="fm-table-wrap" style="padding:0">
      <div class="kf-wrap">
        <div class="kf-card">
          <div class="kf-info">
            <div>
              <c:choose>
                <c:when test="${kfDone}"><span class="kf-st done">Подтверждено</span></c:when>
                <c:when test="${plan.resultId > 0}"><span class="kf-st fill">Заполнено, не подтверждено</span></c:when>
                <c:otherwise><span class="kf-st new">Нет результата</span></c:otherwise>
              </c:choose>
            </div>
            <div><span class="l">Пациент</span><b>${fn:escapeXml(p.surname)} ${fn:escapeXml(p.name)} ${fn:escapeXml(p.middlename)}</b></div>
            <c:if test="${not empty p.yearNum || not empty p.birthyear}">
              <div><span class="l">И/Б · год рождения</span>${p.yearNum}<c:if test="${not empty p.birthyear}"> · ${p.birthyear}</c:if></div>
            </c:if>
            <c:if test="${not empty p.dept}">
              <div><span class="l">Отделение / палата</span>${p.dept.name}<c:if test="${not empty p.room}"> / ${p.room.name}</c:if></div>
            </c:if>
            <div><span class="l">Группа</span>${plan.kdoType.name}</div>
            <div><span class="l">Назначено</span><fmt:formatDate pattern="dd.MM.yyyy" value="${plan.actDate}"/></div>
            <c:if test="${kfDone}">
              <div><span class="l">Подтверждено</span><fmt:formatDate pattern="dd.MM.yyyy HH:mm" value="${plan.resDate}"/></div>
            </c:if>
            <c:if test="${not empty confFio}">
              <div><span class="l">Врач</span>${confFio}</div>
            </c:if>
            <c:if test="${not empty plan.comment}">
              <div><span class="l">Примечание</span>${fn:escapeXml(plan.comment)}</div>
            </c:if>
          </div>
        </div>
        <c:if test="${!text}">
        <div class="kf-card" id="kfCard">
          <div class="kf-head"><h3>Результаты</h3><span class="fm-hint">Enter — следующее поле</span></div>
          <div class="kf-body" id="kfBody"><div class="kf-load"><i class="fa fa-spinner fa-spin"></i></div></div>
        </div>
        </c:if>
        <c:if test="${text}">
        <div class="kf-card" id="kfCard">
          <div class="kf-head"><h3>Заключение</h3></div>
          <div class="kf-txt" id="kfBody">
            <div>
              <div class="kf-lbl"><span>Протокол</span><span class="sp"></span>
                <div class="btn-group">
                  <button type="button" class="btn btn-xs btn-default dropdown-toggle kf-tpl" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
                  <ul class="dropdown-menu pull-right">
                    <li><a href="#" onclick="fmsTpl.pick('${plan.kdo.id}_c2', 'c2'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                    <li><a href="#" onclick="fmsTpl.save('${plan.kdo.id}_c2', 'c2'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
                  </ul>
                </div>
              </div>
              <textarea id="c2" style="display:none">${fn:escapeXml(c2)}</textarea>
              <div id="kfQuill"></div>
            </div>
            <div>
              <div class="kf-lbl"><span>Заключение</span><span class="sp"></span>
                <div class="btn-group">
                  <button type="button" class="btn btn-xs btn-default dropdown-toggle kf-tpl" data-toggle="dropdown" title="Шаблоны текста для этого поля"><i class="fa fa-file-text-o"></i> Шаблоны <span class="caret"></span></button>
                  <ul class="dropdown-menu pull-right">
                    <li><a href="#" onclick="fmsTpl.pick('${plan.kdo.id}_c1', 'c1'); return false;"><i class="fa fa-download fa-fw"></i> Вставить шаблон…</a></li>
                    <li><a href="#" onclick="fmsTpl.save('${plan.kdo.id}_c1', 'c1'); return false;"><i class="fa fa-save fa-fw"></i> Сохранить как шаблон…</a></li>
                  </ul>
                </div>
              </div>
              <textarea id="c1" name="c1">${fn:escapeXml(c1)}</textarea>
            </div>
          </div>
        </div>
        </c:if>
      </div>
    </div>
  </div>
</div>
<script>
  (function () {
    var body = $('#kfBody'), card = $('#kfCard'), done = ${kfDone ? 'true' : 'false'}, fixing = false, orig = '', text = ${text ? 'true' : 'false'};
    function fields() { return body.find('input[name], select[name], textarea[name]'); }
    function ser() {
      if (!text) return fields().serialize();
      return 'c1=' + encodeURIComponent($.trim($('#c1').val())) + '&c2=' + encodeURIComponent(window.quills.c2 ? getEditorHtml('c2') : '');
    }
    function mark() { card.toggleClass('dirty', ser() !== orig); }
    function lock(on) {
      fields().prop('disabled', on);
      if (text) { if (window.quills.c2) window.quills.c2.enable(!on); body.find('.kf-tpl').prop('disabled', on); }
    }
    if (text) {
      window.quills = window.quills || {};
      var q = new Quill('#kfQuill', {theme: 'snow', modules: {toolbar: [['bold', 'italic', 'underline', 'strike'], [{list: 'ordered'}, {list: 'bullet'}], [{script: 'sub'}, {script: 'super'}], ['clean']]}});
      var html = $('#c2').val();
      if ($.trim(html)) q.setContents(q.clipboard.convert({html: html}), 'silent');
      window.quills.c2 = q;
      window.quillRange = window.quillRange || {};
      q.on('selection-change', function (rg) { if (rg) window.quillRange.c2 = rg; });
      q.on('text-change', mark);
      lock(done);
      orig = ser();
      if (!done) q.focus();
    } else $.ajax({
      url: '/kdo/obs.s', data: {id: ${plan.id}, kdo: ${plan.kdo.id}, frag: 1}, dataType: 'html',
      success: function (html) {
        body.html(html);
        var d = {};
        try { d = JSON.parse(body.find('script.kb-data').text() || '{}'); } catch (e) {}
        body.find('script').remove();
        fields().each(function () { if (d[this.name] != null) $(this).val(d[this.name]); });
        var wide = function () { if (body[0].scrollWidth > body[0].clientWidth + 2) body.closest('.kf-wrap').addClass('wide'); };
        wide();
        setTimeout(wide, 300);
        if (done) lock(true);
        orig = ser();
        if (!done) fields().filter('input:not([type=hidden])').filter(function () { return this.value === ''; }).first().focus();
      },
      error: function () { body.html('<div class="kf-load">Не удалось открыть бланк</div>'); }
    });
    body.on('input change', 'input, select, textarea', mark);
    body.on('keydown', 'input', function (e) {
      if (e.keyCode != 13 && e.keyCode != 40 && e.keyCode != 38) return;
      e.preventDefault();
      var all = body.find('input:not([disabled]):not([type=hidden]):visible'), i = all.index(this);
      var next = all.eq(e.keyCode == 38 ? Math.max(i - 1, 0) : i + 1);
      if (next.length) next.focus().select();
    });
    window.kfFix = function () {
      fixing = true;
      lock(false);
      $('#kfFix').hide();
      $('#kfSave').show();
      fields().filter('input:not([type=hidden])').first().focus();
    };
    window.kfSave = function (confirm) {
      if (done && !fixing) return;
      var dirty = ser() !== orig;
      if (!dirty && !confirm) { FmsToast.show('Изменений нет', 'info'); return; }
      var go = function () {
        $('#kfSave, #kfConf').prop('disabled', true);
        $.ajax({
          url: '/kdo/batch/form.s', method: 'post', dataType: 'json',
          data: 'planId=${plan.id}&' + (dirty ? ser() : 'only_confirm=Y') + (confirm ? '&confirm=Y' : '') + (fixing ? '&fix=Y' : ''),
          success: function (res) {
            if (!res.success) { FmsToast.show(res.msg || 'Не удалось сохранить', 'err'); return; }
            FmsToast.show(confirm ? 'Сохранено и подтверждено' : 'Сохранено', 'ok');
            setPage('/kdo/kdo.s?id=${plan.id}&kdo=${plan.kdo.id}');
          },
          complete: function () { $('#kfSave, #kfConf').prop('disabled', false); }
        });
      };
      if (text && !$.trim($('#c1').val())) { FmsToast.show('Не заполнено заключение', 'info'); $('#c1').focus(); return; }
      if (confirm) {
        if (!dirty && ${plan.resultId > 0 ? 'false' : 'true'}) { FmsToast.show('Сначала заполните результат', 'info'); return; }
        FmsConfirm('Подтвердить результат? После подтверждения изменить его можно только кнопкой «Исправить».', go, null, {ok: 'Подтвердить'});
      } else go();
    };
    $(document).off('keydown.kf').on('keydown.kf', function (e) {
      if (!document.getElementById('kfBody')) { $(document).off('keydown.kf'); return; }
      if ((e.ctrlKey || e.metaKey) && e.keyCode == 83) { e.preventDefault(); if ($('#kfSave:visible').length) kfSave(false); }
    });
  })();
</script>
