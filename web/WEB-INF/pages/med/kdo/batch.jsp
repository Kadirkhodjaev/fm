<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- КДО → Пакетный ввод: однопольные анализы (бланки 777/888) одной таблицей, многопольные бланки отдельными блоками
     (сам бланк приходит фрагментом из /kdo/obs.s?frag=1), заключения (999/889) — ссылками --%>
<%@include file="/WEB-INF/pages/med/mn/mn_style.jsp"%>
<%-- kbSvc: ввод по одной услуге (/kdo/service.s) — строки и бланки по пациентам; иначе по одному пациенту (/kdo/batch.s) --%>
<c:set var="kbSvc" value="${svcId > 0}"/>
<c:set var="kbBack" value="${kbSvc ? '/kdo/services.s' : '/patients/list.s'}"/>
<c:set var="kbReload"><c:if test="${kbSvc}">/kdo/service.s?kdo=${svcId}<c:if test="${all}">&all=Y</c:if></c:if><c:if test="${!kbSvc}">/kdo/batch.s?id=${p.id}</c:if></c:set>
<c:set var="kbForms" value="0"/>
<c:set var="kbTodo" value="0"/>
<c:forEach items="${single}" var="s"><c:if test="${s.done != 'Y'}"><c:set var="kbTodo" value="${kbTodo + 1}"/></c:if></c:forEach>
<c:forEach items="${other}" var="s"><c:if test="${s.kdo.formId != 999 && s.kdo.formId != 889 && s.done != 'Y'}"><c:set var="kbTodo" value="${kbTodo + 1}"/></c:if></c:forEach>
<c:forEach items="${other}" var="s"><c:if test="${s.kdo.formId != 999 && s.kdo.formId != 889}"><c:set var="kbForms" value="${kbForms + 1}"/></c:if></c:forEach>
<style>
  .kb-pat { display:flex; flex-wrap:wrap; gap:4px 16px; font-size:12.5px; color:#6B7280; }
  .kb-pat b { color:#1F2430; font-weight:600; }
  table.mn td.kb-in { padding:3px 8px; }
  .kb-in input { width:100%; height:30px; padding:0 10px; border:1px solid #E6E8EC; border-radius:8px; font-family:inherit; font-size:14px;
    font-weight:600; text-align:center; font-variant-numeric:tabular-nums; background:#fff; }
  .kb-in input:focus, .kb-fbody .form-control:focus { outline:none; border-color:#4B5563; box-shadow:0 0 0 3px rgba(75,85,99,.12); }
  .kb-in input[disabled] { background:#F5F6F8; color:#1F2430; border-color:transparent; }
  tr.dirty .kb-in input { border-color:#F59E0B; background:#FFFBEB; }
  tr.out .kb-in input { color:#A50F22; }
  tr.out .kb-norm { color:#A50F22; }
  .kb-dot { display:inline-block; width:10px; height:10px; border-radius:50%; background:#E5484D; flex:none; }
  .kb-dot.filled { background:#F5B800; }
  .kb-dot.done { background:#30A46C; }
  .kb-norm { font-size:12.5px; color:#6B7280; }
  .kb-sec { padding:16px 14px 8px; }
  .kb-legend { display:flex; flex-wrap:wrap; gap:14px; font-size:12px; color:#6B7280; }
  .kb-legend span { display:inline-flex; align-items:center; gap:6px; }
  .kb-links a { color:#1F2430; font-weight:600; text-decoration:none; }
  .kb-links a:hover { color:#D7182E; }

  /* многопольные бланки */
  .kb-forms { display:grid; grid-template-columns:repeat(auto-fill, minmax(560px, 1fr)); gap:12px; padding:0 12px 12px; align-items:start; }
  .kb-form { background:#fff; border:1px solid #E6E8EC; border-radius:14px; overflow:hidden; }
  .kb-form.dirty { border-color:#F59E0B; }
  .kb-fhead { display:flex; align-items:center; gap:10px; padding:10px 14px; border-bottom:1px solid #F0F1F4; background:#FAFBFC; }
  .kb-fhead .nm { flex:1; font-weight:700; font-size:14px; }
  .kb-fhead .m { font-size:12px; color:#6B7280; white-space:nowrap; }
  .kb-fhead a { font-size:12px; color:#6B7280; }
  .kb-fbody { padding:6px 10px 10px; font-size:13px; overflow-x:auto; }
  /* широкий бланк (много столбцов, например антибиотикограмма) занимает всю строку; если и так не влезает - прокрутка, а не обрезка */
  .kb-form.wide { grid-column:1 / -1; }
  .kb-fbody table { width:100% !important; border-collapse:collapse; }
  .kb-fbody td { padding:3px 6px !important; border:0 !important; border-bottom:1px solid #F0F1F4 !important; background:none !important; font-size:13px; }
  .kb-fbody tr:first-child td { color:#6B7280; font-size:11px; font-weight:600; text-transform:uppercase; letter-spacing:.3px; }
  .kb-fbody .form-control { height:28px; padding:2px 8px; border:1px solid #E6E8EC; border-radius:8px; box-shadow:none; font-size:13px; font-weight:600; }
  .kb-fbody textarea.form-control { height:auto; font-weight:400; }
  .kb-fbody .form-control[disabled] { background:#F5F6F8; border-color:transparent; }
  .kb-who { font-weight:600; }
  .kb-who small { display:block; font-weight:400; font-size:11.5px; color:#9AA1AC; }
  .kb-fload { padding:20px; text-align:center; color:#9AA1AC; }
</style>
<div class="fm-page">
  <div class="fm-box">
    <div class="fm-toolbar">
      <div class="fm-title">
        <span class="ic"><i class="fa ${kbSvc ? 'fa-list-alt' : 'fa-flask'}"></i></span>
        <div>
          <c:if test="${kbSvc}">
            <h2>${empty svc ? 'Услуга' : svc.name}</h2>
            <span class="kb-pat">
              <c:if test="${not empty svc}"><span>${svc.kdoType.name}</span></c:if>
              <span>Пациентов: <b>${fn:length(single) + kbForms}</b></span>
              <span>Заполнено: <b id="kbFilled">0</b></span>
            </span>
          </c:if>
          <c:if test="${!kbSvc}">
          <h2>${fn:escapeXml(p.surname)} ${fn:escapeXml(p.name)} ${fn:escapeXml(p.middlename)}</h2>
          <span class="kb-pat">
            <c:if test="${not empty p.birthyear}"><span>Год рожд.: <b>${p.birthyear}</b></span></c:if>
            <c:if test="${not empty p.dept}"><span>Отделение: <b>${p.dept.name}</b></span></c:if>
            <c:if test="${not empty p.room}"><span>Палата: <b>${p.room.name}</b></span></c:if>
            <span>Заполнено: <b id="kbFilled">0</b> из <b>${fn:length(single) + kbForms}</b></span>
          </span>
          </c:if>
        </div>
      </div>
      <%-- всё подтверждено: менять нечего, кнопки сохранения и фильтр не нужны --%>
      <c:if test="${kbSvc}">
        <%-- по услуге фильтр серверный: подтверждённые грузятся только по «Все» --%>
        <div class="fm-seg">
          <button type="button" class="${all ? '' : 'on'}" onclick="setPage('/kdo/service.s?kdo=${svcId}')">Не подтверждены</button>
          <button type="button" class="${all ? 'on' : ''}" onclick="setPage('/kdo/service.s?kdo=${svcId}&all=Y')">Все</button>
        </div>
      </c:if>
      <div class="fm-seg" id="kbSeg" <c:if test="${kbTodo == 0 || kbSvc}">style="display:none"</c:if>>
        <button type="button" class="on" data-f="" onclick="kbSeg(this)">Все</button>
        <button type="button" data-f="todo" onclick="kbSeg(this)">Не подтверждены</button>
      </div>
      <span class="fm-spacer"></span>
      <div class="fm-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="fm-search" id="kbSearch" placeholder="${kbSvc ? 'Пациент' : 'Анализ или показатель'}" oninput="kbFilter()" autocomplete="off"/>
      </div>
      <c:if test="${kbTodo > 0}">
        <button type="button" class="fm-btn" id="kbSave" onclick="kbSave(false)" title="Ctrl+S"><i class="fa fa-floppy-o"></i>Сохранить</button>
        <button type="button" class="fm-btn primary" id="kbConf" onclick="kbSave(true)"><i class="fa fa-check"></i>Сохранить и подтвердить</button>
      </c:if>
      <button type="button" class="fm-btn" onclick="setPage('${kbBack}')"><i class="fa fa-arrow-left"></i>Назад</button>
    </div>
    <div class="fm-table-wrap" id="kbRoot">
      <c:if test="${not empty single}">
        <table class="mn">
          <thead>
          <tr>
            <th style="width:44px">№</th>
            <th style="width:30px"></th>
            <th class="l">${kbSvc ? 'Пациент' : 'Показатель'}</th>
            <th style="width:200px">Результат</th>
            <th class="l" style="width:240px">Норма</th>
            <th style="width:110px">Ед. изм.</th>
            <th style="width:100px">Назначено</th>
            <th style="width:130px">Подтверждено</th>
          </tr>
          </thead>
          <tbody id="kbRows">
          <c:set var="kbType" value=""/>
          <c:set var="kbN" value="0"/>
          <c:forEach items="${single}" var="s">
            <c:set var="pt" value="${pats[s.patientId]}"/>
            <c:if test="${!kbSvc && kbType != s.kdoType.id}">
              <c:set var="kbType" value="${s.kdoType.id}"/>
              <tr class="grp kb-grp" data-g="${s.kdoType.id}"><td colspan="8">${s.kdoType.name}</td></tr>
            </c:if>
            <c:set var="kbN" value="${kbN + 1}"/>
            <c:set var="v" value="${s.resultId > 0 ? vals[s.resultId] : ''}"/>
            <tr data-id="${s.id}" data-g="${s.kdoType.id}" data-done="${s.done == 'Y' ? 'Y' : 'N'}" data-s="${fn:escapeXml(fn:toLowerCase(kbSvc ? pt.fio : s.kdo.name))}" data-norm="${fn:escapeXml(s.kdo.norma)}">
              <td class="c m">${kbN}</td>
              <td class="c"><span class="kb-dot ${s.done == 'Y' ? 'done' : ''}"></span></td>
              <c:if test="${kbSvc}"><td class="kb-who">${fn:escapeXml(pt.fio)}<small>И/Б ${pt.yearNum}<c:if test="${not empty pt.dept}"> · ${pt.dept.name}</c:if><c:if test="${not empty pt.room}"> / ${pt.room.name}</c:if></small></td></c:if>
              <c:if test="${!kbSvc}"><td class="nm">${s.kdo.name}</td></c:if>
              <td class="kb-in"><input type="text" value="${fn:escapeXml(v)}" data-o="${fn:escapeXml(v)}" autocomplete="off" <c:if test="${s.done == 'Y'}">disabled title="Результат подтверждён"</c:if>/></td>
              <td class="kb-norm">${s.kdo.norma}</td>
              <td class="c m">${s.kdo.ei}</td>
              <td class="c m"><fmt:formatDate pattern="dd.MM.yyyy" value="${s.actDate}"/></td>
              <td class="c m"><fmt:formatDate pattern="dd.MM.yyyy HH:mm" value="${s.resDate}"/></td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </c:if>
      <c:if test="${kbForms > 0}">
        <c:if test="${!kbSvc}"><div class="kb-sec fm-sec">Бланки анализов</div></c:if>
        <c:if test="${kbSvc}"><div style="height:12px"></div></c:if>
        <div class="kb-forms" id="kbForms">
          <c:forEach items="${other}" var="s">
            <c:if test="${s.kdo.formId != 999 && s.kdo.formId != 889}">
              <c:set var="pt" value="${pats[s.patientId]}"/>
              <div class="kb-form" data-plan="${s.id}" data-kdo="${s.kdo.id}" data-done="${s.done == 'Y' ? 'Y' : 'N'}" data-s="${fn:escapeXml(fn:toLowerCase(kbSvc ? pt.fio : s.kdo.name))}">
                <div class="kb-fhead">
                  <span class="kb-dot ${s.done == 'Y' ? 'done' : ''}"></span>
                  <c:if test="${kbSvc}"><span class="nm kb-who">${fn:escapeXml(pt.fio)}<small>И/Б ${pt.yearNum}<c:if test="${not empty pt.dept}"> · ${pt.dept.name}</c:if><c:if test="${not empty pt.room}"> / ${pt.room.name}</c:if></small></span></c:if>
                  <c:if test="${!kbSvc}"><span class="nm">${s.kdo.name}</span></c:if>
                  <span class="m">назн. <fmt:formatDate pattern="dd.MM.yyyy" value="${s.actDate}"/></span>
                  <c:if test="${s.done == 'Y'}"><span class="m">подтв. <fmt:formatDate pattern="dd.MM.yyyy HH:mm" value="${s.resDate}"/></span></c:if>
                  <a href="#" onclick="setPage('/kdo/kdo.s?id=${s.id}&kdo=${s.kdo.id}'); return false" title="Открыть отдельным бланком"><i class="fa fa-external-link"></i></a>
                </div>
                <div class="kb-fbody"><div class="kb-fload"><i class="fa fa-spinner fa-spin"></i></div></div>
              </div>
            </c:if>
          </c:forEach>
        </div>
      </c:if>
      <c:if test="${empty single && kbForms == 0}">
        <div class="fm-empty" style="display:block"><i class="fa fa-flask"></i>${kbSvc ? (all ? 'Пациентов с этой услугой нет' : 'Все результаты по услуге подтверждены') : 'Анализов для ввода нет'}</div>
      </c:if>
      <div class="fm-empty" id="kbEmpty" style="display:none"><i class="fa fa-search"></i>Ничего не найдено</div>
      <c:if test="${fn:length(other) > kbForms}">
        <div class="kb-sec fm-sec">Заключения — заполняются отдельно</div>
        <table class="mn kb-links">
          <tbody>
          <c:forEach items="${other}" var="s">
            <c:if test="${s.kdo.formId == 999 || s.kdo.formId == 889}">
              <tr>
                <td class="c" style="width:44px"><span class="kb-dot ${s.done == 'Y' ? 'done' : (s.resultId > 0 ? 'filled' : '')}"></span></td>
                <td><a href="#" onclick="setPage('/kdo/kdo.s?id=${s.id}&kdo=${s.kdo.formId}'); return false">${s.kdo.name}</a></td>
                <td class="m" style="width:200px">${s.kdoType.name}</td>
                <td class="c m" style="width:100px"><fmt:formatDate pattern="dd.MM.yyyy" value="${s.actDate}"/></td>
              </tr>
            </c:if>
          </c:forEach>
          </tbody>
        </table>
      </c:if>
      <div class="kb-sec kb-legend">
        <span><i class="kb-dot"></i>нет результата</span>
        <span><i class="kb-dot filled"></i>заполнено, не подтверждено</span>
        <span><i class="kb-dot done"></i>подтверждено</span>
        <span>Enter — следующее поле, Ctrl+S — сохранить</span>
      </div>
    </div>
  </div>
</div>
<script>
  (function () {
    var rows = $('#kbRows tr[data-id]'), forms = $('#kbForms .kb-form');
    function num(v) { v = String(v).replace(/\s/g, '').replace(',', '.'); return v !== '' && !isNaN(v) ? Number(v) : null; }
    // норма вида «a-b» (числа с точкой или запятой); остальные записи нормы не проверяются
    function range(n) {
      var m = /^\s*(\d+(?:[.,]\d+)?)\s*-\s*(\d+(?:[.,]\d+)?)\s*$/.exec(n || '');
      return m ? [num(m[1]), num(m[2])] : null;
    }
    function fields(f) { return f.find('.kb-fbody').find('input[name], select[name], textarea[name]'); }
    function ser(f) { return fields(f).serialize(); }
    function hasVal(f) { return fields(f).filter(function () { return $.trim($(this).val() || '') !== ''; }).length > 0; }
    function mark(tr) {
      var inp = tr.find('input'), v = $.trim(inp.val()), r = range(tr.attr('data-norm')), x = num(v);
      tr.toggleClass('dirty', v !== $.trim(inp.attr('data-o')));
      tr.toggleClass('out', r != null && x != null && (x < r[0] || x > r[1]));
      if (tr.attr('data-done') != 'Y') tr.find('.kb-dot').toggleClass('filled', v !== '');
    }
    function markForm(f) {
      if (!f.data('loaded')) return;
      f.toggleClass('dirty', ser(f) !== f.data('o'));
      if (f.attr('data-done') != 'Y') f.find('.kb-fhead .kb-dot').toggleClass('filled', hasVal(f));
    }
    function count() {
      // подтверждённые считаются заполненными (их бланки только для просмотра, полей ввода в них нет)
      var n = rows.filter(function () { return $(this).attr('data-done') == 'Y' || $.trim($(this).find('input').val()) !== ''; }).length;
      n += forms.filter(function () { return $(this).attr('data-done') == 'Y' || ($(this).data('loaded') && hasVal($(this))); }).length;
      $('#kbFilled').text(n);
    }
    // бланк шире своей колонки: карточка на всю строку (проверяем ещё раз, когда подгрузятся шрифты и картинки)
    function fitWide(card, body) {
      var check = function () { if (body[0].scrollWidth > body[0].clientWidth + 2) card.addClass('wide'); };
      check();
      setTimeout(check, 300);
    }
    // бланк фрагментом: таблица полей + данные; значения раскладываются по полям этого блока
    forms.each(function () {
      var f = $(this), body = f.find('.kb-fbody');
      $.ajax({
        url: '/kdo/obs.s', data: {id: f.attr('data-plan'), kdo: f.attr('data-kdo'), frag: 1}, dataType: 'html',
        success: function (html) {
          body.html(html);
          var d = {};
          try { d = JSON.parse(body.find('script.kb-data').text() || '{}'); } catch (e) {}
          body.find('script').remove();
          fields(f).each(function () { if (d[this.name] != null) $(this).val(d[this.name]); });
          if (f.attr('data-done') == 'Y') fields(f).prop('disabled', true).attr('title', 'Результат подтверждён');
          fitWide(f, body);
          f.data('loaded', true).data('o', ser(f));
          markForm(f);
          count();
        },
        error: function () {
          body.html('<div class="kb-fload">Бланк не открылся здесь. Откройте его отдельно по ссылке справа вверху.</div>');
        }
      });
    });
    window.kbSeg = function (b) { $(b).addClass('on').siblings().removeClass('on'); kbFilter(); };
    window.kbFilter = function () {
      var todo = $('#kbSeg .on').attr('data-f') == 'todo', q = $.trim($('#kbSearch').val()).toLowerCase(), n = 0;
      rows.add(forms).each(function () {
        var ok = (!todo || $(this).attr('data-done') != 'Y') && (!q || $(this).attr('data-s').indexOf(q) >= 0);
        $(this).toggle(ok);
        if (ok) n++;
      });
      $('#kbRows tr.kb-grp').each(function () { $(this).toggle(rows.filter('[data-g=' + $(this).attr('data-g') + ']:visible').length > 0); });
      $('#kbEmpty').toggle(n == 0 && rows.length + forms.length > 0);
    };
    window.kbSave = function (confirm) {
      var data = [], filled = 0, posts = [];
      rows.filter('[data-done=N]').each(function () {
        var tr = $(this), v = $.trim(tr.find('input').val());
        if (v !== '') filled++;
        if (!confirm && !tr.hasClass('dirty')) return;
        data.push('id=' + tr.attr('data-id') + '&val=' + encodeURIComponent(v));
      });
      if (data.length) posts.push({url: '/kdo/batch/save.s', data: data.join('&') + (confirm ? '&confirm=Y' : '')});
      forms.filter('[data-done=N]').each(function () {
        var f = $(this);
        if (!f.data('loaded')) return;
        var dirty = f.hasClass('dirty'), full = hasVal(f);
        if (full) filled++;
        if (dirty) posts.push({url: '/kdo/batch/form.s', data: 'planId=' + f.attr('data-plan') + '&' + ser(f) + (confirm && full ? '&confirm=Y' : ''), form: f});
        else if (confirm && full) posts.push({url: '/kdo/batch/form.s', data: 'planId=' + f.attr('data-plan') + '&only_confirm=Y&confirm=Y', form: f});
      });
      if (!posts.length) { FmsToast.show(confirm ? 'Нет заполненных неподтверждённых анализов' : 'Изменений нет', 'info'); return; }
      var go = function () {
        $('#kbSave, #kbConf').prop('disabled', true);
        var errs = [], i = 0;
        (function next() {
          if (i >= posts.length) {
            $('#kbSave, #kbConf').prop('disabled', false);
            if (errs.length) { FmsToast.show(errs.join('; '), 'err'); return; }
            FmsToast.show(confirm ? 'Сохранено и подтверждено' : 'Сохранено', 'ok');
            if (confirm) { setPage('${kbReload}'); return; }
            rows.each(function () { var inp = $(this).find('input'); inp.attr('data-o', $.trim(inp.val())); mark($(this)); });
            forms.each(function () { var f = $(this); if (f.data('loaded')) { f.data('o', ser(f)); markForm(f); } });
            return;
          }
          var p = posts[i++];
          $.ajax({
            url: p.url, method: 'post', data: p.data, dataType: 'json',
            success: function (res) { if (!res.success) errs.push(res.msg || 'ошибка'); },
            error: function () { errs.push(p.form ? p.form.find('.kb-fhead .nm').text() + ': ошибка сервера' : 'ошибка сервера'); },
            complete: next
          });
        })();
      };
      if (confirm) FmsConfirm('Подтвердить заполненные анализы (' + filled + ')? После подтверждения результат не меняется.', go, null, {ok: 'Подтвердить'});
      else go();
    };
    rows.find('input').on('input', function () { mark($(this).closest('tr')); count(); });
    $('#kbForms').on('input change', 'input, select, textarea', function () { markForm($(this).closest('.kb-form')); count(); });
    // Enter / стрелки: следующее поле по всей странице (таблица и бланки)
    $('#kbRoot').on('keydown', 'input', function (e) {
      if (e.keyCode != 13 && e.keyCode != 40 && e.keyCode != 38) return;
      e.preventDefault();
      var all = $('#kbRoot').find('input:not([disabled]):not([type=hidden]):visible'), i = all.index(this);
      var next = all.eq(e.keyCode == 38 ? Math.max(i - 1, 0) : i + 1);
      if (next.length) next.focus().select();
    });
    $(document).off('keydown.kb').on('keydown.kb', function (e) {
      if (!document.getElementById('kbRoot')) { $(document).off('keydown.kb'); return; }
      if ((e.ctrlKey || e.metaKey) && e.keyCode == 83) { e.preventDefault(); if (document.getElementById('kbSave')) kbSave(false); }
    });
    rows.each(function () { mark($(this)); });
    count();
    rows.find('input:not([disabled])').filter(function () { return this.value === ''; }).first().focus();
  })();
</script>
