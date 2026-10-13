<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- Амбулаторные услуги → пакетный ввод. По пациенту (/amb/batch.s) или по одной услуге (/amb/svcPatients.s, abSvc):
     однопольные анализы (777, 888) таблицей, бланки анализов блоками (фрагментом из /amb/doWork.s?frag=1),
     текстовые заключения — ссылками на страницу услуги. Сохранение — /amb/work.s, подтверждение — /amb/confirmService.s --%>
<%@include file="/WEB-INF/pages/med/mn/mn_style.jsp"%>
<%@include file="/WEB-INF/pages/med/amb/svc_style.jsp"%>
<c:set var="abSvc" value="${svcId > 0}"/>
<c:set var="abBack" value="${abSvc ? '/amb/svcs.s' : (empty backUrl ? '/amb/home.s' : backUrl)}"/>
<c:set var="abReload"><c:if test="${abSvc}">/amb/svcPatients.s?service=${svcId}<c:if test="${all}">&all=Y</c:if></c:if><c:if test="${!abSvc}">/amb/batch.s?id=${p.id}</c:if></c:set>
<c:set var="abTodo" value="0"/>
<c:forEach items="${single}" var="s"><c:if test="${s.state != 'DONE'}"><c:set var="abTodo" value="${abTodo + 1}"/></c:if></c:forEach>
<c:forEach items="${forms}" var="s"><c:if test="${s.state != 'DONE'}"><c:set var="abTodo" value="${abTodo + 1}"/></c:if></c:forEach>
<c:set var="abTotal" value="${fn:length(single) + fn:length(forms)}"/>
<style>
  .ab-pat { display:flex; flex-wrap:wrap; gap:4px 16px; font-size:12.5px; color:#6B7280; }
  .ab-pat b { color:#1F2430; font-weight:600; }
  table.mn td.ab-in { padding:3px 8px; }
  .ab-in input { width:100%; height:30px; padding:0 10px; border:1px solid #E6E8EC; border-radius:8px; font-family:inherit; font-size:14px;
    font-weight:600; text-align:center; font-variant-numeric:tabular-nums; background:#fff; }
  .ab-in input:focus { outline:none; border-color:#4B5563; box-shadow:0 0 0 3px rgba(75,85,99,.12); }
  .ab-in input[disabled] { background:#F5F6F8; color:#1F2430; border-color:transparent; }
  tr.dirty .ab-in input { border-color:#F59E0B; background:#FFFBEB; }
  tr.out .ab-in input, tr.out .ab-norm { color:#A50F22; }
  .ab-dot { display:inline-block; width:10px; height:10px; border-radius:50%; background:#E5484D; flex:none; }
  .ab-dot.filled { background:#F5B800; }
  .ab-dot.done { background:#30A46C; }
  .ab-norm { font-size:12.5px; color:#6B7280; }
  .ab-who { font-weight:600; }
  .ab-who small { display:block; font-weight:400; font-size:11.5px; color:#9AA1AC; }
  .ab-sec { padding:16px 14px 8px; }
  .ab-legend { display:flex; flex-wrap:wrap; gap:14px; font-size:12px; color:#6B7280; }
  .ab-legend span { display:inline-flex; align-items:center; gap:6px; }
  .ab-links a { color:#1F2430; font-weight:600; text-decoration:none; }
  .ab-links a:hover { color:#D7182E; }
  .ab-forms { display:grid; grid-template-columns:repeat(auto-fill, minmax(560px, 1fr)); gap:12px; padding:0 12px 12px; align-items:start; }
  .ab-fhead { display:flex; align-items:center; gap:10px; padding:10px 14px; border-bottom:1px solid #F0F1F4; background:#FAFBFC; }
  .ab-fhead .nm { flex:1; font-weight:700; font-size:14px; }
  .ab-fhead .m { font-size:12px; color:#6B7280; white-space:nowrap; }
  .ab-fhead a { font-size:12px; color:#6B7280; }
</style>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa ${abSvc ? 'fa-list-alt' : 'fa-stethoscope'}"></i></span>
        <div>
          <c:if test="${abSvc}">
            <h2>${empty svc ? 'Услуга' : svc.name}</h2>
            <span class="ab-pat"><span>Пациентов: <b>${abTotal + fn:length(texts)}</b></span><span>Заполнено: <b id="abFilled">0</b></span></span>
          </c:if>
          <c:if test="${!abSvc}">
            <h2>${fn:escapeXml(p.surname)} ${fn:escapeXml(p.name)} ${fn:escapeXml(p.middlename)}</h2>
            <span class="ab-pat">
              <span>№ <b>${p.id}</b></span>
              <c:if test="${not empty p.birthyear}"><span>Год рожд.: <b>${p.birthyear}</b></span></c:if>
              <span>Заполнено: <b id="abFilled">0</b> из <b>${abTotal}</b></span>
            </span>
          </c:if>
        </div>
      </div>
      <c:if test="${abSvc}">
        <div class="fm-seg">
          <button type="button" class="${all ? '' : 'on'}" onclick="setPage('/amb/svcPatients.s?service=${svcId}')">К выполнению</button>
          <button type="button" class="${all ? 'on' : ''}" onclick="setPage('/amb/svcPatients.s?service=${svcId}&all=Y')">Все</button>
        </div>
      </c:if>
      <c:if test="${!abSvc && abTodo > 0}">
        <div class="fm-seg" id="abSeg">
          <button type="button" class="on" data-f="" onclick="abSeg(this)">Все</button>
          <button type="button" data-f="todo" onclick="abSeg(this)">К выполнению</button>
        </div>
      </c:if>
      <span class="fm-spacer"></span>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="abSearch" placeholder="${abSvc ? 'Пациент' : 'Услуга'}" oninput="abFilter()" autocomplete="off"/>
      </div>
      <c:if test="${abTodo > 0}">
        <button type="button" class="fm-btn" id="abSave" onclick="abSave(false)" title="Ctrl+S"><i class="fa fa-floppy-o"></i>Сохранить</button>
        <button type="button" class="fm-btn primary" id="abConf" onclick="abSave(true)"><i class="fa fa-check"></i>Сохранить и подтвердить</button>
      </c:if>
      <button type="button" class="fm-btn" onclick="setPage('${abBack}')"><i class="fa fa-arrow-left"></i>Назад</button>
    </div>
    <div class="fm-table-wrap" id="abRoot">
      <c:if test="${not empty single}">
        <table class="mn">
          <thead>
          <tr>
            <th style="width:44px">№</th>
            <th style="width:30px"></th>
            <th class="l">${abSvc ? 'Пациент' : 'Анализ'}</th>
            <th style="width:200px">Результат</th>
            <th class="l" style="width:240px">Норма</th>
            <th style="width:110px">Ед. изм.</th>
            <th style="width:130px">Подтверждено</th>
          </tr>
          </thead>
          <tbody id="abRows">
          <c:forEach items="${single}" var="s" varStatus="loop">
            <c:set var="pt" value="${pats[s.patient]}"/>
            <c:set var="nr" value="${norms[s.service.id]}"/>
            <c:set var="v" value="${s.result > 0 ? vals[s.result] : ''}"/>
            <tr data-id="${s.id}" data-done="${s.state == 'DONE' ? 'Y' : 'N'}" data-s="${fn:escapeXml(fn:toLowerCase(abSvc ? pt.fio : s.service.name))}" data-norm="${fn:escapeXml(nr.norma)}">
              <td class="c m">${loop.index + 1}</td>
              <td class="c"><span class="ab-dot ${s.state == 'DONE' ? 'done' : ''}"></span></td>
              <c:if test="${abSvc}"><td class="ab-who">${fn:escapeXml(pt.fio)}<small>№ ${pt.id}<c:if test="${not empty pt.birthyear}"> · ${pt.birthyear} г.р.</c:if></small></td></c:if>
              <c:if test="${!abSvc}"><td class="nm"><a href="#" style="color:inherit" onclick="setPage('/amb/svc.s?id=${s.id}'); return false">${s.service.name}</a></td></c:if>
              <td class="ab-in"><input type="text" value="${fn:escapeXml(v)}" data-o="${fn:escapeXml(v)}" autocomplete="off" <c:if test="${s.state == 'DONE'}">disabled title="Услуга подтверждена"</c:if>/></td>
              <td class="ab-norm">${nr.norma}</td>
              <td class="c m">${nr.ei}</td>
              <td class="c m"><fmt:formatDate pattern="dd.MM.yyyy HH:mm" value="${s.confDate}"/></td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </c:if>
      <c:if test="${not empty forms}">
        <c:if test="${!abSvc}"><div class="ab-sec fm-sec">Бланки анализов</div></c:if>
        <c:if test="${abSvc}"><div style="height:12px"></div></c:if>
        <div class="ab-forms" id="abForms">
          <c:forEach items="${forms}" var="s">
            <c:set var="pt" value="${pats[s.patient]}"/>
            <div class="sv-card ab-form" data-id="${s.id}" data-done="${s.state == 'DONE' ? 'Y' : 'N'}" data-s="${fn:escapeXml(fn:toLowerCase(abSvc ? pt.fio : s.service.name))}">
              <div class="ab-fhead">
                <span class="ab-dot ${s.state == 'DONE' ? 'done' : ''}"></span>
                <c:if test="${abSvc}"><span class="nm ab-who">${fn:escapeXml(pt.fio)}<small>№ ${pt.id}<c:if test="${not empty pt.birthyear}"> · ${pt.birthyear} г.р.</c:if></small></span></c:if>
                <c:if test="${!abSvc}"><span class="nm">${s.service.name}</span></c:if>
                <c:if test="${s.state == 'DONE'}"><span class="m">подтв. <fmt:formatDate pattern="dd.MM.yyyy HH:mm" value="${s.confDate}"/></span></c:if>
                <a href="#" onclick="setPage('/amb/svc.s?id=${s.id}'); return false" title="Открыть отдельно"><i class="fa fa-external-link"></i></a>
              </div>
              <div class="sv-body"><div class="sv-load"><i class="fa fa-spinner fa-spin"></i></div></div>
            </div>
          </c:forEach>
        </div>
      </c:if>
      <c:if test="${not empty texts}">
        <div class="ab-sec fm-sec">Заключения — заполняются отдельно</div>
        <table class="mn ab-links">
          <tbody>
          <c:forEach items="${texts}" var="s">
            <c:set var="pt" value="${pats[s.patient]}"/>
            <tr data-text="1" data-done="${s.state == 'DONE' ? 'Y' : 'N'}" data-s="${fn:escapeXml(fn:toLowerCase(abSvc ? pt.fio : s.service.name))}">
              <td class="c" style="width:44px"><span class="ab-dot ${s.state == 'DONE' ? 'done' : (s.result > 0 ? 'filled' : '')}"></span></td>
              <td><a href="#" onclick="setPage('/amb/svc.s?id=${s.id}'); return false">${abSvc ? pt.fio : s.service.name}</a></td>
              <td class="c m" style="width:150px"><fmt:formatDate pattern="dd.MM.yyyy HH:mm" value="${s.confDate}"/></td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </c:if>
      <c:if test="${abTotal == 0 && empty texts}">
        <div class="fm-empty" style="display:block"><i class="fa fa-stethoscope"></i>${abSvc ? (all ? 'Пациентов с этой услугой нет' : 'Всё по услуге выполнено') : 'Услуг для ввода нет'}</div>
      </c:if>
      <div class="fm-empty" id="abEmpty" style="display:none"><i class="fa fa-search"></i>Ничего не найдено</div>
      <div class="ab-sec ab-legend">
        <span><i class="ab-dot"></i>нет результата</span>
        <span><i class="ab-dot filled"></i>заполнено, не подтверждено</span>
        <span><i class="ab-dot done"></i>выполнено</span>
        <span>Enter — следующее поле, Ctrl+S — сохранить</span>
      </div>
    </div>
  </div>
</div>
<script>
  (function () {
    var rows = $('#abRows tr[data-id]'), forms = $('#abForms .ab-form'), links = $('#abRoot tr[data-text]');
    function num(v) { v = String(v).replace(/\s/g, '').replace(',', '.'); return v !== '' && !isNaN(v) ? Number(v) : null; }
    function range(n) {
      var m = /^\s*(\d+(?:[.,]\d+)?)\s*-\s*(\d+(?:[.,]\d+)?)\s*$/.exec(n || '');
      return m ? [num(m[1]), num(m[2])] : null;
    }
    function fields(f) { return f.find('.sv-body').find('input[name], select[name], textarea[name]'); }
    function ser(f) { return fields(f).serialize(); }
    function hasVal(f) { return fields(f).not('[name=id]').filter(function () { return $.trim($(this).val() || '') !== ''; }).length > 0; }
    function mark(tr) {
      var inp = tr.find('input'), v = $.trim(inp.val()), r = range(tr.attr('data-norm')), x = num(v);
      tr.toggleClass('dirty', v !== $.trim(inp.attr('data-o')));
      tr.toggleClass('out', r != null && x != null && (x < r[0] || x > r[1]));
      if (tr.attr('data-done') != 'Y') tr.find('.ab-dot').toggleClass('filled', v !== '');
    }
    function markForm(f) {
      if (!f.data('loaded')) return;
      f.toggleClass('dirty', ser(f) !== f.data('o'));
      if (f.attr('data-done') != 'Y') f.find('.ab-fhead .ab-dot').toggleClass('filled', hasVal(f));
    }
    function count() {
      var n = rows.filter(function () { return $.trim($(this).find('input').val()) !== ''; }).length;
      n += forms.filter(function () { return $(this).data('loaded') && hasVal($(this)); }).length;
      $('#abFilled').text(n);
    }
    forms.each(function () {
      var f = $(this);
      svFrag(f.find('.sv-body'), f.attr('data-id'), function () {
        if (f.attr('data-done') == 'Y') fields(f).prop('disabled', true);
        f.data('loaded', true).data('o', ser(f));
        markForm(f);
        count();
      });
    });
    window.abSeg = function (b) { $(b).addClass('on').siblings().removeClass('on'); abFilter(); };
    window.abFilter = function () {
      var todo = $('#abSeg .on').attr('data-f') == 'todo', q = $.trim($('#abSearch').val()).toLowerCase(), n = 0;
      rows.add(forms).add(links).each(function () {
        var ok = (!todo || $(this).attr('data-done') != 'Y') && (!q || $(this).attr('data-s').indexOf(q) >= 0);
        $(this).toggle(ok);
        if (ok) n++;
      });
      $('#abEmpty').toggle(n == 0 && rows.length + forms.length + links.length > 0);
    };
    window.abSave = function (confirm) {
      var posts = [], conf = [], filled = 0;
      rows.filter('[data-done=N]').each(function () {
        var tr = $(this), v = $.trim(tr.find('input').val());
        if (v !== '') { filled++; if (confirm) conf.push(tr.attr('data-id')); }
        if (tr.hasClass('dirty')) posts.push('id=' + tr.attr('data-id') + '&c1=' + encodeURIComponent(v));
      });
      forms.filter('[data-done=N]').each(function () {
        var f = $(this);
        if (!f.data('loaded')) return;
        if (hasVal(f)) { filled++; if (confirm) conf.push(f.attr('data-id')); }
        if (f.hasClass('dirty')) posts.push(ser(f));
      });
      if (!posts.length && !conf.length) { FmsToast.show(confirm ? 'Нет заполненных невыполненных услуг' : 'Изменений нет', 'info'); return; }
      var go = function () {
        $('#abSave, #abConf').prop('disabled', true);
        var jobs = $.map(posts, function (d) { return {url: '/amb/work.s', data: d}; })
          .concat($.map(conf, function (id) { return {url: '/amb/confirmService.s', data: 'id=' + id}; }));
        var errs = [], i = 0;
        (function next() {
          if (i >= jobs.length) {
            $('#abSave, #abConf').prop('disabled', false);
            if (errs.length) { FmsToast.show(errs.join('; '), 'err'); return; }
            FmsToast.show(confirm ? 'Сохранено и подтверждено' : 'Сохранено', 'ok');
            if (confirm) { setPage('${abReload}'); return; }
            rows.each(function () { var inp = $(this).find('input'); inp.attr('data-o', $.trim(inp.val())); mark($(this)); });
            forms.each(function () { var f = $(this); if (f.data('loaded')) { f.data('o', ser(f)); markForm(f); } });
            return;
          }
          var j = jobs[i++];
          $.ajax({url: j.url, method: 'post', data: j.data, dataType: 'json',
            success: function (res) { if (!res.success) errs.push(res.msg || 'ошибка'); },
            error: function () { errs.push('ошибка сервера'); },
            complete: next});
        })();
      };
      if (confirm) FmsConfirm('Подтвердить заполненные услуги (' + filled + ')? После подтверждения результат меняется только на странице услуги.', go, null, {ok: 'Подтвердить'});
      else go();
    };
    rows.find('input').on('input', function () { mark($(this).closest('tr')); count(); });
    $('#abForms').on('input change', 'input, select, textarea', function () { markForm($(this).closest('.ab-form')); count(); });
    $('#abRoot').on('keydown', 'input', function (e) {
      if (e.keyCode != 13 && e.keyCode != 40 && e.keyCode != 38) return;
      e.preventDefault();
      var all = $('#abRoot').find('input:not([disabled]):not([type=hidden]):visible'), i = all.index(this);
      var next = all.eq(e.keyCode == 38 ? Math.max(i - 1, 0) : i + 1);
      if (next.length) next.focus().select();
    });
    $(document).off('keydown.ab').on('keydown.ab', function (e) {
      if (!document.getElementById('abRoot')) { $(document).off('keydown.ab'); return; }
      if ((e.ctrlKey || e.metaKey) && e.keyCode == 83) { e.preventDefault(); if (document.getElementById('abSave')) abSave(false); }
    });
    rows.each(function () { mark($(this)); });
    count();
    rows.find('input:not([disabled])').filter(function () { return this.value === ''; }).first().focus();
  })();
</script>
