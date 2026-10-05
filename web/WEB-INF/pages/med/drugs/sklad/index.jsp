<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<script src="/res/js/fms-calendar.js" type="text/javascript"></script>
<style>
  .sk { --brand:#D7182E; --brand-soft:#FDECEE; --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --bg:#F5F6F8;
    --ok:#15803D; --ok-bg:#E8F7EE; --warn:#B45309; --warn-bg:#FEF3C7;
    padding:12px 14px 28px; color:var(--text); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; font-size:14px; }
  .sk * { box-sizing:border-box; }
  .sk-top { display:flex; align-items:center; gap:10px; flex-wrap:wrap; margin-bottom:12px; }
  .sk-top h2 { margin:0; font-size:19px; font-weight:700; margin-right:8px; }
  .sk .lab { font-size:12px; font-weight:600; color:var(--muted); }
  .sk .si { height:34px; border:1.5px solid var(--border); border-radius:9px; padding:4px 10px; font-size:14px; background:#fff; color:var(--text); }
  .sk .si:focus { border-color:var(--brand); box-shadow:0 0 0 3px rgba(215,24,46,.10); outline:none; }
  .sk .ab { display:inline-flex; align-items:center; gap:7px; height:34px; padding:0 13px; border-radius:9px; border:1.5px solid var(--border); background:#fff; color:var(--text);
    font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  .sk .ab:hover { background:var(--bg); }
  .sk .ab.primary { background:var(--brand); border-color:var(--brand); color:#fff; }
  .sk-tiles { display:grid; grid-template-columns:repeat(4, minmax(0, 1fr)); gap:10px; margin-bottom:12px; }
  .sk-tile { background:#fff; border:1px solid var(--border); border-radius:14px; padding:11px 16px; }
  .sk-tile .l { font-size:11.5px; font-weight:600; color:var(--muted); text-transform:uppercase; letter-spacing:.3px; }
  .sk-tile .v { font-size:20px; font-weight:700; margin-top:3px; font-variant-numeric:tabular-nums; white-space:nowrap; }
  .sk-tile.inc .v { color:var(--ok); }
  .sk-tile.out .v { color:var(--brand); }
  .sk-card { background:#fff; border:1px solid var(--border); border-radius:14px; overflow:hidden; }
  .sk-bar { display:flex; align-items:center; gap:8px; flex-wrap:wrap; padding:10px 14px; border-bottom:1px solid var(--border); background:#FAFBFC; }
  .sk-bar .sp { flex:1; }
  .sk-chip { display:inline-flex; align-items:center; gap:6px; height:30px; padding:0 12px; border-radius:15px; border:1.5px solid var(--border); background:#fff; font-size:13px; font-weight:600; cursor:pointer; color:#374151; }
  .sk-chip b { font-variant-numeric:tabular-nums; }
  .sk-chip.on { background:var(--brand-soft); border-color:var(--brand); color:var(--brand); }
  .sk-chip.warn b { color:var(--warn); }
  .sk-chip.bad b { color:var(--brand); }
  .sk-scroll { overflow-x:auto; }
  table.skt { width:100%; border-collapse:collapse; }
  table.skt th { padding:8px 12px; font-size:11px; font-weight:600; color:var(--muted); text-transform:uppercase; letter-spacing:.3px; text-align:right; background:#F8F9FA; border-bottom:1px solid var(--border); white-space:nowrap; cursor:pointer; user-select:none; }
  table.skt th.l, table.skt td.l { text-align:left; }
  table.skt th:hover { color:var(--text); }
  table.skt th .ar { color:var(--brand); margin-left:3px; }
  table.skt td { padding:8px 12px; border-bottom:1px solid #F0F1F4; text-align:right; font-variant-numeric:tabular-nums; vertical-align:middle; }
  table.skt tr.dr { cursor:pointer; }
  table.skt tr.dr:hover td { background:#FAFBFC; }
  table.skt td.nm { text-align:left; font-weight:600; }
  table.skt td.nm .tg { display:inline-block; width:14px; color:#9AA1AC; transition:transform .12s; }
  table.skt tr.open td.nm .tg { transform:rotate(90deg); color:var(--brand); }
  table.skt td.c { text-align:center; }
  .sk-exp { display:inline-block; padding:2px 9px; border-radius:8px; font-size:12.5px; font-weight:600; background:#F1F2F4; color:#374151; white-space:nowrap; }
  .sk-exp.w { background:var(--warn-bg); color:var(--warn); }
  .sk-exp.d { background:var(--brand-soft); color:var(--brand); }
  .sk-exp.ok { background:var(--ok-bg); color:var(--ok); }
  tr.bt > td { padding:0 0 0 38px; background:#FCFCFD; border-bottom:1px solid #E6E8EC; }
  table.bs { width:100%; border-collapse:collapse; }
  table.bs th { padding:6px 12px; font-size:10.5px; font-weight:600; color:var(--muted); text-transform:uppercase; text-align:right; background:transparent; border-bottom:1px solid #EDEEF1; cursor:default; }
  table.bs th.l, table.bs td.l { text-align:left; }
  table.bs td { padding:6px 12px; border-bottom:1px solid #F3F4F6; font-size:13px; text-align:right; }
  table.bs tr:last-child td { border-bottom:0; }
  .sk-empty { padding:26px; text-align:center; color:var(--muted); }
  .sk-foot { display:flex; gap:6px 28px; flex-wrap:wrap; padding:10px 14px; border-top:1px solid var(--border); background:#FAFBFC; font-size:13px; color:var(--muted); }
  .sk-foot b { color:var(--text); font-variant-numeric:tabular-nums; }
  @media (max-width:900px) { .sk-tiles { grid-template-columns:repeat(2, minmax(0, 1fr)); } }
</style>

<%-- Данные: каждая строка - партия препарата с остатком (названия экранируются через c:out) --%>
<table id="sk-src" style="display:none">
  <c:forEach items="${rows}" var="row">
    <tr data-drug="${row.ib}" data-remain="${row.c2}" data-sum="${row.c3}" data-price="${row.c4}" data-nds="${empty row.c5 ? 0 : row.c5}" data-exp="${row.c6}"
        data-act="<c:out value='${row.c7}'/>" data-date="${row.c8}" data-man="<c:out value='${row.c9}'/>" data-measure="<c:out value='${row.c10}'/>"><td><c:out value="${row.c1}"/></td></tr>
  </c:forEach>
</table>

<div class="sk" id="sk" data-nds="${ndsProc}">
  <div class="sk-top">
    <h2>Склад</h2>
    <span class="lab">Период</span>
    <input name="period_start" id="period_start" type="text" class="si fms-cal" autocomplete="off" style="width:130px; text-align:center" value="${period_start}"/>
    <span class="lab">—</span>
    <input name="period_end" id="period_end" type="text" class="si fms-cal" autocomplete="off" style="width:130px; text-align:center" value="${period_end}"/>
    <button onclick="SK.period()" class="ab primary" type="button"><i class="fa fa-refresh"></i> Показать</button>
  </div>

  <div class="sk-tiles">
    <div class="sk-tile"><div class="l">Сальдо на начало</div><div class="v"><fmt:formatNumber value="${saldo_in}" type="number"/></div></div>
    <div class="sk-tile inc"><div class="l">Приход за период</div><div class="v"><fmt:formatNumber value="${income_sum}" type="number"/></div></div>
    <div class="sk-tile out"><div class="l">Расход за период</div><div class="v"><fmt:formatNumber value="${outcome_sum}" type="number"/></div></div>
    <div class="sk-tile"><div class="l">Сальдо на конец</div><div class="v"><fmt:formatNumber value="${saldo_out}" type="number"/></div></div>
  </div>

  <div class="sk-card">
    <div class="sk-bar">
      <button type="button" class="sk-chip on" data-f="all">Все препараты <b id="n-all">0</b></button>
      <button type="button" class="sk-chip warn" data-f="soon">Истекает ≤ 90 дн. <b id="n-soon">0</b></button>
      <button type="button" class="sk-chip bad" data-f="exp">Просрочено <b id="n-exp">0</b></button>
      <span class="sp"></span>
      <input type="text" class="si" id="sk-search" placeholder="Поиск по названию, производителю, партии..." style="width:320px" autocomplete="off">
      <button class="ab" type="button" onclick="SK.excel()"><i class="fa fa-file-excel-o"></i> Excel</button>
    </div>
    <div class="sk-scroll">
      <table class="skt" id="sk-table">
        <thead>
          <tr>
            <th class="l" data-s="name">Препарат <span class="ar"></span></th>
            <th class="l" data-s="measure">Ед.</th>
            <th data-s="remain">Остаток <span class="ar"></span></th>
            <th data-s="batches">Партий</th>
            <th data-s="exp">Ближайший срок <span class="ar"></span></th>
            <th data-s="net">Сумма <span class="ar"></span></th>
            <th data-s="gross">Сумма с НДС <span class="ar"></span></th>
          </tr>
        </thead>
        <tbody id="sk-body"></tbody>
      </table>
      <div class="sk-empty" id="sk-empty" style="display:none">Ничего не найдено</div>
    </div>
    <div class="sk-foot">
      <span>Препаратов: <b id="f-n">0</b></span>
      <span>Партий: <b id="f-b">0</b></span>
      <span>На сумму (без НДС): <b id="f-net">0</b></span>
      <span>С НДС: <b id="f-gross">0</b></span>
      <span style="margin-left:auto">Остаток на текущий момент: учитываются только подтверждённые акты прихода</span>
    </div>
  </div>
</div>
<iframe style="display: none" name="drug_excel"></iframe>

<script>
  window.SK = (function () {
    var nds = Number($('#sk').data('nds')) || 0, all = [], filter = 'all', sort = {key: 'name', dir: 1}, open = {}, q = '';
    function num(v) { var n = parseFloat(('' + v).replace(/[\s ]/g, '').replace(',', '.')); return isNaN(n) ? 0 : n; }
    function fmt2(n) { return n.toLocaleString('ru-RU', {minimumFractionDigits: 2, maximumFractionDigits: 2}); }
    function fmtq(n) { return n.toLocaleString('ru-RU', {maximumFractionDigits: 2}); }
    function esc(s) { return $('<div/>').text(s == null ? '' : s).html(); }
    function ru(iso) { return iso && iso.length >= 10 ? iso.substr(8, 2) + '.' + iso.substr(5, 2) + '.' + iso.substr(0, 4) : '—'; }
    function days(iso) { return iso && iso.length >= 10 ? Math.floor((new Date(iso + 'T00:00:00') - new Date(new Date().toDateString())) / 86400000) : 99999; }
    function expCls(d) { return d < 0 ? 'd' : d <= 90 ? 'd' : d <= 180 ? 'w' : 'ok'; }
    function expTxt(d) { return d < 0 ? 'просрочено ' + (-d) + ' дн.' : d === 0 ? 'сегодня' : d <= 180 ? 'ещё ' + d + ' дн.' : ''; }

    function load() {
      var map = {}, list = [];
      $('#sk-src tr').each(function () {
        var t = $(this), id = t.data('drug');
        var b = {remain: num(t.data('remain')), price: num(t.data('price')), nds: num(t.data('nds')), exp: '' + (t.data('exp') || ''),
          act: '' + (t.data('act') || ''), date: '' + (t.data('date') || ''), man: '' + (t.data('man') || '')};
        b.vat = b.nds ? b.nds : Math.round(b.price * nds) / 100;
        b.net = b.price * b.remain; b.gross = (b.price + b.vat) * b.remain; b.days = days(b.exp);
        if (!map[id]) { map[id] = {id: id, name: t.find('td').first().text(), measure: '' + (t.data('measure') || ''), batches: [], remain: 0, net: 0, gross: 0}; list.push(map[id]); }
        var d = map[id]; d.batches.push(b); d.remain += b.remain; d.net += b.net; d.gross += b.gross;
      });
      $.each(list, function (i, d) {
        d.minDays = Math.min.apply(null, d.batches.map(function (b) { return b.days; }));
        d.minExp = ''; $.each(d.batches, function (j, b) { if (b.days === d.minDays) d.minExp = b.exp; });
        d.expired = d.batches.some(function (b) { return b.days < 0; });
        d.soon = d.batches.some(function (b) { return b.days >= 0 && b.days <= 90; });
        d.text = (d.name + ' ' + d.batches.map(function (b) { return b.man + ' ' + b.act; }).join(' ')).toLowerCase();
      });
      all = list;
    }
    function visible() {
      var words = $.trim(q).toLowerCase().split(/\s+/).filter(Boolean);
      return all.filter(function (d) {
        if (filter === 'soon' && !d.soon) return false;
        if (filter === 'exp' && !d.expired) return false;
        for (var i = 0; i < words.length; i++) if (d.text.indexOf(words[i]) === -1) return false;
        return true;
      });
    }
    function sorted(list) {
      var k = sort.key, dir = sort.dir;
      return list.slice().sort(function (a, b) {
        var x, y;
        if (k === 'name') { return dir * a.name.localeCompare(b.name, 'ru'); }
        if (k === 'measure') { return dir * a.measure.localeCompare(b.measure, 'ru'); }
        if (k === 'exp') { x = a.minDays; y = b.minDays; }
        else if (k === 'batches') { x = a.batches.length; y = b.batches.length; }
        else { x = a[k]; y = b[k]; }
        return dir * (x - y) || a.name.localeCompare(b.name, 'ru');
      });
    }
    function batchRows(d) {
      var h = '<table class="bs"><thead><tr><th class="l">Партия (акт прихода)</th><th class="l">Производитель</th><th>Срок годности</th><th>Остаток</th><th>Цена ед.</th><th>Цена с НДС</th><th>Сумма с НДС</th></tr></thead><tbody>';
      $.each(d.batches, function (i, b) {
        h += '<tr><td class="l">' + (b.act ? '№' + esc(b.act) + (b.date ? ' от ' + esc(b.date) : '') : '—') + '</td><td class="l">' + esc(b.man) + '</td>' +
          '<td><span class="sk-exp ' + expCls(b.days) + '">' + ru(b.exp) + (expTxt(b.days) ? ' · ' + expTxt(b.days) : '') + '</span></td>' +
          '<td>' + fmtq(b.remain) + '</td><td>' + fmt2(b.price) + '</td><td>' + fmt2(b.price + b.vat) + '</td><td>' + fmt2(b.gross) + '</td></tr>';
      });
      return h + '</tbody></table>';
    }
    function render() {
      var list = sorted(visible()), body = $('#sk-body').empty(), net = 0, gross = 0, nb = 0;
      $.each(list, function (i, d) {
        net += d.net; gross += d.gross; nb += d.batches.length;
        var isOpen = !!open[d.id];
        var tr = $('<tr class="dr"/>').toggleClass('open', isOpen).attr('data-id', d.id).html(
          '<td class="nm"><span class="tg"><i class="fa fa-chevron-right"></i></span>' + esc(d.name) + '</td>' +
          '<td class="l">' + esc(d.measure) + '</td><td>' + fmtq(d.remain) + '</td><td>' + d.batches.length + '</td>' +
          '<td><span class="sk-exp ' + expCls(d.minDays) + '">' + ru(d.minExp) + (expTxt(d.minDays) ? ' · ' + expTxt(d.minDays) : '') + '</span></td>' +
          '<td>' + fmt2(d.net) + '</td><td><b>' + fmt2(d.gross) + '</b></td>');
        body.append(tr);
        if (isOpen) body.append($('<tr class="bt"/>').html('<td colspan="7">' + batchRows(d) + '</td>'));
      });
      $('#sk-empty').toggle(!list.length); $('#sk-table').toggle(list.length > 0);
      $('#f-n').text(list.length); $('#f-b').text(nb); $('#f-net').text(fmt2(net)); $('#f-gross').text(fmt2(gross));
      $('#sk-table th .ar').text('');
      $('#sk-table th[data-s=' + sort.key + '] .ar').text(sort.dir > 0 ? '▲' : '▼');
    }
    function counts() {
      $('#n-all').text(all.length);
      $('#n-soon').text(all.filter(function (d) { return d.soon; }).length);
      $('#n-exp').text(all.filter(function (d) { return d.expired; }).length);
    }
    function period() {
      setPage('/drugs/sklad.s?period_start=' + $('#period_start').val() + '&period_end=' + $('#period_end').val());
    }
    function excel() { drug_excel.location = '/drugs/sklad/excel.s'; }

    $(function () {
      load(); counts(); render();
      $('.sk-chip').on('click', function () { filter = $(this).data('f'); $('.sk-chip').removeClass('on'); $(this).addClass('on'); render(); });
      $('#sk-search').on('input', function () { q = this.value; render(); });
      $('#sk-body').on('click', 'tr.dr', function () { var id = $(this).data('id'); open[id] = !open[id]; render(); });
      $('#sk-table thead').on('click', 'th[data-s]', function () {
        var k = $(this).data('s');
        if (k === 'batches') return;
        sort = {key: k, dir: sort.key === k ? -sort.dir : 1}; render();
      });
    });
    return {period: period, excel: excel};
  })();
</script>
