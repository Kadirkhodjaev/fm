<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<style>
  .cl-page { --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --bg:#F5F6F8;
    height:calc(100vh - 200px); min-height:560px; box-sizing:border-box; display:flex; flex-direction:column; gap:8px;
    padding:0; background:transparent; font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; color:var(--text); }
  .cl-page * { box-sizing:border-box; }
  .cl-box { flex:1; min-height:0; display:flex; flex-direction:column; background:#fff; border:1px solid var(--border); border-radius:16px;
    overflow:hidden; box-shadow:0 1px 2px rgba(20,25,40,.04), 0 8px 24px rgba(20,25,40,.06); }

  .cl-toolbar { flex:none; display:flex; align-items:center; flex-wrap:wrap; gap:10px; padding:8px 14px; }
  .cl-title { display:flex; align-items:center; gap:12px; }
  .cl-title .ic { width:30px; height:30px; border-radius:9px; display:flex; align-items:center; justify-content:center; background:#EEF1F6; color:#3C4A63; font-size:14px; }
  .cl-title h2 { margin:0; font-size:16px; font-weight:700; line-height:1.2; }
  .cl-count { display:block; font-size:12.5px; color:var(--muted); font-variant-numeric:tabular-nums; }
  .cl-count b { color:var(--text); font-weight:600; }
  .cl-spacer { flex:1; }
  .cl-select, .cl-search { height:30px; padding:0 10px; border:1px solid var(--border); border-radius:9px; background-color:#fff; font-size:13px; font-family:inherit; color:var(--text); }
  .cl-select { padding-right:26px; cursor:pointer; }
  .cl-select:focus, .cl-search:focus { outline:none; border-color:#4B5563; box-shadow:0 0 0 3px rgba(75,85,99,.12); }
  .cl-search-wrap { position:relative; }
  .cl-search-wrap .fa { position:absolute; left:10px; top:9px; color:#9AA1AC; font-size:12px; }
  .cl-search { width:240px; padding-left:28px; }
  .cl-btn { height:30px; padding:0 11px; border:1px solid var(--border); border-radius:9px; background:#fff; color:#3C4250; font-size:12.5px; font-weight:600; font-family:inherit; cursor:pointer; }
  .cl-btn:hover { background:#F5F6F8; }
  .cl-btn[disabled] { opacity:.6; cursor:default; }

  /* плашки типов */
  .cl-segs { flex:none; display:flex; gap:8px; padding:0 14px 10px; overflow-x:auto; }
  .cl-seg { flex:none; min-width:120px; padding:8px 12px; border:1px solid var(--border); border-radius:12px; background:#fff; cursor:pointer; text-align:left; font-family:inherit; color:var(--text); }
  .cl-seg:hover { border-color:#C9CDD4; }
  .cl-seg.on { border-color:#1F2430; box-shadow:0 0 0 1px #1F2430 inset; }
  .cl-seg .nm { display:flex; align-items:center; gap:6px; font-size:12px; font-weight:600; color:var(--muted); }
  .cl-seg .n { display:block; margin-top:2px; font-size:18px; font-weight:700; font-variant-numeric:tabular-nums; }
  .cl-seg .sh { display:block; font-size:11.5px; color:var(--muted); }
  .dot { width:8px; height:8px; border-radius:50%; display:inline-block; flex:none; }

  .badge-seg { display:inline-flex; align-items:center; gap:5px; padding:1px 8px; border-radius:6px; font-size:12px; font-weight:600; line-height:18px; white-space:nowrap; }
  .s-VIP { background:#FFF4D6; color:#8A5A00; } .d-VIP { background:#E0A100; }
  .s-REGULAR { background:#E9F7EF; color:#1E7B43; } .d-REGULAR { background:#22A55B; }
  .s-NEW { background:#E8F1FD; color:#1F5FBF; } .d-NEW { background:#3B82F6; }
  .s-USUAL { background:#F1F2F4; color:#3C4250; } .d-USUAL { background:#9AA1AC; }
  .s-SLEEP { background:#F3EEFB; color:#6B3FA0; } .d-SLEEP { background:#8B5CF6; }
  .s-NONE { background:#F5F6F8; color:#9AA1AC; } .d-NONE { background:#D5D8DE; }

  .cl-table-wrap { flex:1; min-height:0; overflow:auto; border-top:1px solid var(--border); }
  table.cl-grid { width:100%; margin:0; border-collapse:separate; border-spacing:0; font-size:13px; }
  table.cl-grid thead th { position:sticky; top:0; z-index:2; height:32px; padding:0 8px; background:#F8F9FA; border-bottom:1px solid var(--border);
    color:var(--muted); font-size:11px; font-weight:600; text-transform:uppercase; letter-spacing:.3px; text-align:left; white-space:nowrap; }
  table.cl-grid thead th.r, table.cl-grid tbody td.r { text-align:right; }
  table.cl-grid thead th.sortable { cursor:pointer; }
  table.cl-grid thead th.sortable:hover { color:var(--text); }
  table.cl-grid thead th.sorted { color:var(--text); }
  table.cl-grid tbody td { height:36px; padding:0 8px; border-bottom:1px solid #F0F1F4; vertical-align:middle; white-space:nowrap; font-variant-numeric:tabular-nums; }
  table.cl-grid tbody tr { cursor:pointer; }
  table.cl-grid tbody tr:hover td { background:#F8F9FB; }
  table.cl-grid tbody tr.selected td { background:#F1F4F9; }
  table.cl-grid tbody tr.selected td:first-child { box-shadow:inset 3px 0 0 #1F2430; }
  table.cl-grid td.num { color:#B0B5BD; font-size:12px; text-align:center; }
  table.cl-grid td.mut { color:var(--muted); }
  table.cl-grid td.none { color:#C3C7CE; }
  table.cl-grid .fio { font-weight:600; }
  table.cl-grid .by { margin-left:6px; color:var(--muted); font-size:12px; }
  table.cl-grid .money { font-weight:600; }
  table.cl-grid .chk { color:#22A55B; font-size:12px; margin-left:6px; }
  .cl-vis { color:var(--muted); font-size:12px; }
  .cl-vis b { color:var(--text); font-weight:600; }

  .cl-empty { padding:60px 20px; text-align:center; color:#9AA1AC; }
  .cl-empty .fa { display:block; font-size:36px; margin-bottom:10px; color:#D5D8DE; }
  .cl-foot { flex:none; display:flex; align-items:center; gap:10px; padding:6px 14px; border-top:1px solid var(--border); background:#FAFBFC; font-size:12.5px; color:var(--muted); }
  .cl-foot b { color:var(--text); }
  .cl-pg { width:28px; height:26px; border:1px solid var(--border); border-radius:7px; background:#fff; color:#3C4250; cursor:pointer; }
  .cl-pg[disabled] { opacity:.4; cursor:default; }
  .cl-pg-in { width:52px; height:26px; text-align:center; border:1px solid var(--border); border-radius:7px; font-family:inherit; font-size:12.5px; }
</style>

<div class="cl-page">
  <div class="cl-box">
    <div class="cl-toolbar">
      <div class="cl-title">
        <span class="ic"><i class="fa fa-users"></i></span>
        <div>
          <h2>Клиенты</h2>
          <span class="cl-count"><b>${allCount}</b> клиентов · оплачено <b>${allPaid}</b><c:if test="${not empty calcDate}"> · итоги на ${calcDate}</c:if></span>
        </div>
      </div>
      <span class="cl-spacer"></span>
      <select class="cl-select" onchange="clGo({sort: this.value})" title="Сортировка">
        <option <c:if test="${sort == 'new'}">selected</c:if> value="new">Сначала новые</option>
        <option <c:if test="${sort == 'paid'}">selected</c:if> value="paid">По сумме оплат</option>
        <option <c:if test="${sort == 'paid12'}">selected</c:if> value="paid12">По оплатам за 12 мес</option>
        <option <c:if test="${sort == 'visits'}">selected</c:if> value="visits">По числу визитов</option>
        <option <c:if test="${sort == 'last'}">selected</c:if> value="last">По последнему визиту</option>
        <option <c:if test="${sort == 'fio'}">selected</c:if> value="fio">По ФИО</option>
      </select>
      <div class="cl-search-wrap">
        <i class="fa fa-search"></i>
        <input type="text" class="cl-search" id="clSearch" placeholder="ФИО, телефон, паспорт, ID" value="${fn:escapeXml(q)}"
               onkeydown="if(event.keyCode == 13) clGo({q: this.value})" autocomplete="off"/>
      </div>
      <c:if test="${canRefresh}">
        <button type="button" class="cl-btn" id="clRefresh" onclick="clRefresh()" title="Пересчитать типы и итоги клиентов (ночью это делается автоматически)">
          <i class="fa fa-refresh"></i> Пересчитать
        </button>
      </c:if>
    </div>

    <div class="cl-segs">
      <button type="button" class="cl-seg ${empty seg ? 'on' : ''}" onclick="clGo({seg: ''})">
        <span class="nm">Все клиенты</span><span class="n">${allCount}</span><span class="sh">100% оплат</span>
      </button>
      <c:forEach items="${segs}" var="s">
        <button type="button" class="cl-seg ${seg == s.code ? 'on' : ''}" onclick="clGo({seg: '${s.code}'})" title="${fn:escapeXml(s.hint)}">
          <span class="nm"><span class="dot d-${s.code}"></span>${s.name}</span>
          <span class="n">${s.count}</span>
          <span class="sh">${s.share}% оплат</span>
        </button>
      </c:forEach>
    </div>

    <c:if test="${not empty loadErr}">
      <div style="margin:0 14px 8px; padding:8px 12px; border-radius:9px; background:#FDECEE; color:#A50F22; font-size:13px">Ошибка загрузки: ${fn:escapeXml(loadErr)}</div>
    </c:if>

    <div class="cl-table-wrap">
      <table class="cl-grid">
        <thead>
        <tr>
          <th style="width:46px;text-align:center">#</th>
          <th class="sortable ${sort == 'fio' ? 'sorted' : ''}" onclick="clGo({sort: 'fio'})">ФИО</th>
          <th style="width:150px">Телефон</th>
          <th style="width:120px">Тип</th>
          <th style="width:110px" class="sortable ${sort == 'visits' ? 'sorted' : ''}" onclick="clGo({sort: 'visits'})">Визиты</th>
          <th style="width:140px" class="r sortable ${sort == 'paid' ? 'sorted' : ''}" onclick="clGo({sort: 'paid'})">Всего оплачено</th>
          <th style="width:130px" class="r sortable ${sort == 'paid12' ? 'sorted' : ''}" onclick="clGo({sort: 'paid12'})">За 12 мес</th>
          <th style="width:120px" class="sortable ${sort == 'last' ? 'sorted' : ''}" onclick="clGo({sort: 'last'})">Последний визит</th>
        </tr>
        </thead>
        <tbody id="clRows">
        <c:forEach items="${rows}" var="r" varStatus="loop">
          <tr id="cl_${loop.index}" data-id="${r.id}" onclick="clSel(${loop.index})" ondblclick="clView(${r.id})">
            <td class="num">${from + loop.index}</td>
            <td><span class="fio">${fn:escapeXml(r.fio)}</span><c:if test="${not empty r.birth}"><span class="by">${r.birth}</span></c:if><c:if test="${r.flag}"><i class="fa fa-check-circle chk" title="Реквизиты проверены"></i></c:if></td>
            <c:choose>
              <c:when test="${not empty r.tel}"><td class="mut">${fn:escapeXml(r.tel)}</td></c:when>
              <c:otherwise><td class="none">—</td></c:otherwise>
            </c:choose>
            <td><span class="badge-seg s-${r.seg}"><span class="dot d-${r.seg}"></span>${r.segName}</span></td>
            <td class="cl-vis">
              <c:if test="${r.amb > 0}"><b>${r.amb}</b> амб</c:if><c:if test="${r.amb > 0 && r.stat > 0}"> · </c:if><c:if test="${r.stat > 0}"><b>${r.stat}</b> стац</c:if>
              <c:if test="${r.amb == 0 && r.stat == 0}"><span style="color:#C3C7CE">—</span></c:if>
            </td>
            <c:choose>
              <c:when test="${not empty r.paid}"><td class="r money">${r.paid}</td></c:when>
              <c:otherwise><td class="r none">—</td></c:otherwise>
            </c:choose>
            <c:choose>
              <c:when test="${not empty r.paid12}"><td class="r">${r.paid12}</td></c:when>
              <c:otherwise><td class="r none">—</td></c:otherwise>
            </c:choose>
            <c:choose>
              <c:when test="${not empty r.last}"><td>${r.last}</td></c:when>
              <c:otherwise><td class="none">—</td></c:otherwise>
            </c:choose>
          </tr>
        </c:forEach>
        </tbody>
      </table>
      <c:if test="${empty rows}">
        <div class="cl-empty"><i class="fa fa-users"></i>Клиенты не найдены</div>
      </c:if>
    </div>

    <div class="cl-foot">
      <span><b>${from}–${to}</b> из <b>${count}</b></span>
      <span class="cl-spacer"></span>
      <button type="button" class="cl-pg" onclick="clGo({page: 1})" <c:if test="${page <= 1}">disabled</c:if> title="В начало"><i class="fa fa-angle-double-left"></i></button>
      <button type="button" class="cl-pg" onclick="clGo({page: ${page - 1}})" <c:if test="${page <= 1}">disabled</c:if> title="Назад"><i class="fa fa-angle-left"></i></button>
      <span>стр. <input class="cl-pg-in" value="${page}" onkeydown="if(event.keyCode == 13) clGo({page: this.value})"/> из ${maxPage}</span>
      <button type="button" class="cl-pg" onclick="clGo({page: ${page + 1}})" <c:if test="${page >= maxPage}">disabled</c:if> title="Вперёд"><i class="fa fa-angle-right"></i></button>
      <button type="button" class="cl-pg" onclick="clGo({page: ${maxPage}})" <c:if test="${page >= maxPage}">disabled</c:if> title="В конец"><i class="fa fa-angle-double-right"></i></button>
    </div>
  </div>
</div>

<script>
  var clRow = 0;
  function clGo(p) {
    var qs = [];
    for (var k in p) qs.push(k + '=' + encodeURIComponent(p[k]));
    bossCl('/boss/clients/list.s?' + qs.join('&'));
  }
  function clSel(i) {
    $('#cl_' + clRow).removeClass('selected');
    clRow = i;
    $('#cl_' + i).addClass('selected');
  }
  function clView(id) {
    bossCl('/boss/clients/view.s?id=' + id);
  }
  function clRefresh() {
    var b = $('#clRefresh').prop('disabled', true).html('<i class="fa fa-refresh fa-spin"></i> Считаю...');
    $.ajax({
      url: '/boss/clients/refresh.s', method: 'post', dataType: 'json',
      success: function (res) {
        if (!res.success) { errMsg(res.msg); return; }
        bossCl('/boss/clients/list.s');
      },
      complete: function () { b.prop('disabled', false).html('<i class="fa fa-refresh"></i> Пересчитать'); }
    });
  }
  $(document).off('keydown.cl').on('keydown.cl', function (e) {
    if (!$('#clRows').length) { $(document).off('keydown.cl'); return; }
    if (!$('#clRows').is(':visible')) return;
    if ($(e.target).is('input, select, textarea')) return;
    if (e.keyCode == 40 && $('#cl_' + (clRow + 1)).length) { clSel(clRow + 1); e.preventDefault(); }
    if (e.keyCode == 38 && clRow > 0) { clSel(clRow - 1); e.preventDefault(); }
    if (e.keyCode == 13) clView($('#cl_' + clRow).data('id'));
  });
  clSel(0);
</script>
