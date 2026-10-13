<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
  /* ---------- Контейнер ---------- */
  .sk-page { --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --bg:#F5F6F8;
    height:100%; box-sizing:border-box; display:flex; flex-direction:column; gap:8px;
    padding:10px 14px; background:var(--bg); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; color:var(--text); }
  .sk-page * { box-sizing:border-box; }
  .sk-box { display:flex; flex-direction:column; padding:0; background:#fff; border:1px solid var(--border); border-radius:16px;
    overflow:hidden; box-shadow:0 1px 2px rgba(20,25,40,.04), 0 8px 24px rgba(20,25,40,.06); }

  /* ---------- Шапка ---------- */
  .sk-toolbar { flex:none; display:flex; align-items:center; flex-wrap:wrap; gap:10px; padding:8px 14px; }
  .sk-title { display:flex; align-items:center; gap:12px; }
  .sk-title .ic { width:30px; height:30px; border-radius:9px; display:flex; align-items:center; justify-content:center;
    background:#EEF1F6; color:#3C4A63; font-size:14px; }
  .sk-title h2 { margin:0; font-size:16px; font-weight:700; line-height:1.2; }
  .sk-count { display:block; font-size:12.5px; color:var(--muted); font-variant-numeric:tabular-nums; }
  .sk-count b { color:var(--text); font-weight:600; }
  .sk-spacer { flex:1; }

  .sk-select, .sk-search { height:30px; padding:0 10px; border:1px solid var(--border); border-radius:9px; background-color:#fff;
    font-size:13px; font-family:inherit; color:var(--text); }
  .sk-select { padding-right:30px; cursor:pointer; }
  .sk-select:focus, .sk-search:focus { outline:none; border-color:#4B5563; box-shadow:0 0 0 3px rgba(75,85,99,.12); }
    font-size:12.5px; font-weight:600; font-family:inherit; cursor:pointer; }
  .sk-search-wrap { position:relative; }
  .sk-search-wrap .fa { position:absolute; left:10px; top:9px; color:#9AA1AC; font-size:12px; }
  .sk-search { width:220px; padding-left:28px; }

  /* ---------- Таблица ---------- */
  .sk-table-wrap { flex:1; min-height:0; overflow:auto; border-top:1px solid var(--border); }
  table.sk-grid { width:100%; margin:0; border-collapse:separate; border-spacing:0; font-size:13px; }
  table.sk-grid thead th { position:sticky; top:0; z-index:2; height:32px; padding:0 8px; background:#F8F9FA; border-bottom:1px solid var(--border);
    color:var(--muted); font-size:11px; font-weight:600; text-transform:uppercase; letter-spacing:.3px; text-align:left; white-space:nowrap; }
  table.sk-grid thead th.c { text-align:center; }
  table.sk-grid tbody td { height:34px; padding:0 8px; border-bottom:1px solid #F0F1F4; vertical-align:middle; font-variant-numeric:tabular-nums; white-space:nowrap; }
  table.sk-grid tbody td.c { text-align:center; }
  table.sk-grid tbody td.num { color:#B0B5BD; font-size:12px; }
  table.sk-grid tbody td.mut { color:var(--muted); }
  table.sk-grid tbody td.mut b { color:var(--text); font-weight:600; }
  table.sk-grid tbody td.none { color:#C3C7CE; }
  table.sk-grid tbody td.cut { max-width:0; overflow:hidden; text-overflow:ellipsis; }
  table.sk-grid tbody tr { cursor:pointer; transition:background .08s; }
  table.sk-grid tbody tr:hover td { background:#F8F9FB; }
  table.sk-grid tbody tr.selected td { background:#F1F4F9; }
  table.sk-grid tbody tr.selected td:first-child { box-shadow:inset 3px 0 0 #1F2430; }
  table.sk-grid .fio { color:var(--text); font-weight:600; }
  table.sk-grid .by { margin-left:6px; color:var(--muted); font-size:12px; font-weight:400; }
  table.sk-grid .pill { display:inline-block; max-width:100%; padding:1px 7px; border-radius:6px; background:#F1F2F4; color:#3C4250;
    font-size:12px; font-weight:600; line-height:18px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; vertical-align:middle; }
  table.sk-grid .mkb-code { display:inline-block; min-width:44px; margin-right:6px; padding:1px 6px; border-radius:6px; background:#FDECEE; color:#A50F22;
    font-size:12px; font-weight:700; line-height:18px; text-align:center; }
  table.sk-grid td.doc .fa { color:#B0B5BD; margin-right:5px; }

  .sk-empty { padding:60px 20px; text-align:center; color:#9AA1AC; }
  .sk-empty .fa { display:block; font-size:36px; margin-bottom:10px; color:#D5D8DE; }
  .sk-hint { flex:none; padding:6px 14px; border-top:1px solid var(--border); background:#FAFBFC; font-size:12px; color:#9AA1AC; }
  .sk-hint kbd { display:inline-block; padding:1px 6px; margin:0 2px; background:#fff; border:1px solid #E0E3E8; border-bottom-width:2px; border-radius:5px;
    color:var(--muted); font-family:inherit; font-size:11px; box-shadow:none; }
  .sk-hint span { margin-right:14px; }
</style>

<div class="sk-page">
  <div class="sk-box" id="skBox">

    <div class="sk-toolbar">
      <div class="sk-title">
        <span class="ic"><i class="fa fa-file-text"></i></span>
        <div>
          <h2>Больничные листы</h2>
          <span class="sk-count"><b id="skShown">${fn:length(rows)}</b> из <b>${fn:length(rows)}</b> пациентов</span>
        </div>
      </div>

      <span class="sk-spacer"></span>

      <select class="sk-select" id="skDep" onchange="skLoad()" title="Отделение">
        <c:forEach items="${depts}" var="dp">
          <option <c:if test="${dp.id == dep}">selected</c:if> value="${dp.id}">${dp.name}</option>
        </c:forEach>
      </select>

      <div class="sk-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="sk-search" id="skSearch" placeholder="ФИО, ИБ №, МКБ-10" oninput="skFilter()" autocomplete="off"/>
      </div>
    </div>

    <div class="sk-table-wrap">
      <table class="sk-grid">
        <thead>
        <tr>
          <th class="c" style="width:40px">#</th>
          <th style="width:70px">ИБ №</th>
          <th style="width:26%">ФИО</th>
          <th style="width:110px">Дата рег.</th>
          <th style="width:120px">Повторная рег.</th>
          <th style="width:18%">Отделение / палата</th>
          <th style="width:16%">Врач</th>
          <th>МКБ-10 (осмотр врача)</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${rows}" var="r" varStatus="loop">
          <tr id="${r.c1}" onclick="skRow(this)"
              data-s="${fn:toLowerCase(fn:escapeXml(r.c2))} ${r.c3} ${fn:toLowerCase(fn:escapeXml(r.c9))} ${fn:toLowerCase(fn:escapeXml(r.c10))}">
            <td class="c num">${loop.index + 1}</td>
            <td class="mut"><b>${r.c3}</b></td>
            <td class="cut" title="${fn:escapeXml(r.c2)}"><span class="fio">${fn:escapeXml(r.c2)}</span><c:if test="${not empty r.c12}"><span class="by">${r.c12}</span></c:if></td>
            <td>${r.c4}</td>
            <td>${r.c13}</td>
            <c:choose>
              <c:when test="${not empty r.c6 || not empty r.c7}">
                <c:set var="otdPal" value="${r.c6}${not empty r.c6 && not empty r.c7 ? ' / ' : ''}${r.c7}"/>
                <td class="cut"><span class="pill" title="${fn:escapeXml(otdPal)}">${fn:escapeXml(otdPal)}</span></td>
              </c:when>
              <c:otherwise><td class="none">—</td></c:otherwise>
            </c:choose>
            <c:choose>
              <c:when test="${not empty r.c8}"><td class="cut doc" title="${fn:escapeXml(r.c8)}"><i class="fa fa-user-md"></i>${fn:escapeXml(r.c8)}</td></c:when>
              <c:otherwise><td class="none">—</td></c:otherwise>
            </c:choose>
            <c:choose>
              <c:when test="${not empty r.c9 || not empty r.c10}"><td class="cut" title="${fn:escapeXml(r.c9)} ${fn:escapeXml(r.c10)}"><c:if test="${not empty r.c9}"><span class="mkb-code">${fn:escapeXml(r.c9)}</span></c:if>${fn:escapeXml(r.c10)}</td></c:when>
              <c:otherwise><td class="none" title="Осмотр врача ещё не заполнен">— не указан</td></c:otherwise>
            </c:choose>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <div class="sk-empty" id="skEmpty" <c:if test="${not empty rows}">style="display:none"</c:if>>
        <i class="fa fa-file-text-o"></i><span id="skEmptyText">Нет пациентов с больничным листом</span>
      </div>
    </div>

    <div class="sk-hint">
      <span><kbd>↑</kbd><kbd>↓</kbd> выбор</span>
    </div>
  </div>
</div>

<script>
  (function () {
    function resize() { $('#skBox').height($(window).height() - 100); }
    resize();
    $(window).off('resize.sicks').on('resize.sicks', resize);
    <c:if test="${loadErr}">
    if (typeof showMsg === 'function') showMsg('Не удалось загрузить список больничных листов', false);
    </c:if>
  })();

  function skLoad() {
    setPage('/nurses/sicks.s?dep=' + encodeURIComponent($('#skDep').val() || ''));
  }

  function skFilter() {
    var q = $.trim($('#skSearch').val()).toLowerCase(), shown = 0;
    $('.sk-grid tbody tr').each(function () {
      var ok = !q || (this.getAttribute('data-s') || '').indexOf(q) !== -1;
      this.style.display = ok ? '' : 'none';
      if (ok) shown++;
    });
    $('#skShown').text(shown);
    $('#skEmptyText').text(q ? 'Ничего не найдено' : 'Нет пациентов с больничным листом');
    $('#skEmpty').toggle(shown === 0);
    var sel = $('.sk-grid tbody tr.selected');
    if (!sel.length || !sel.is(':visible')) skRow($('.sk-grid tbody tr:visible').get(0));
  }

  function skRow(tr) {
    $('.sk-grid tbody tr.selected').removeClass('selected');
    if (!tr) return;
    $(tr).addClass('selected');
    if (tr.scrollIntoView) tr.scrollIntoView({block: 'nearest'});
  }

  function keyDown(e) {
    var tag = (document.activeElement && document.activeElement.tagName || '').toLowerCase();
    var typing = tag === 'input' && document.activeElement.type !== 'checkbox' || tag === 'textarea' || tag === 'select';
    if (e.keyCode === 40 || e.keyCode === 38) {
      if (typing && document.activeElement.id !== 'skSearch') return;
      e.preventDefault();
      var rows = $('.sk-grid tbody tr:visible'), idx = rows.index($('.sk-grid tbody tr.selected'));
      var next = rows.get(idx + (e.keyCode === 38 ? -1 : 1));
      if (next) skRow(next); else if (idx < 0) skRow(rows.get(0));
    }
  }

  skRow($('.sk-grid tbody tr').get(0));
</script>
