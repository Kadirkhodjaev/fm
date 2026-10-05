<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
  .dt { --brand:#D7182E; --brand-soft:#FDECEE; --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --bg:#F5F6F8; --ok:#15803D; --ok-bg:#E8F7EE; --warn:#B45309; --warn-bg:#FEF3C7;
    padding:12px 14px 28px; color:var(--text); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; font-size:14px; }
  .dt * { box-sizing:border-box; }
  .dt-top { display:flex; align-items:center; gap:10px; flex-wrap:wrap; margin-bottom:12px; }
  .dt-top h2 { margin:0; font-size:19px; font-weight:700; margin-right:6px; }
  .dt .di { height:34px; border:1.5px solid var(--border); border-radius:9px; padding:4px 10px; font-size:14px; background:#fff; color:var(--text); }
  .dt .di:focus { border-color:var(--brand); box-shadow:0 0 0 3px rgba(215,24,46,.10); outline:none; }
  .dt-card { background:#fff; border:1px solid var(--border); border-radius:14px; overflow:hidden; }
  .dt-bar { display:flex; align-items:center; gap:8px; flex-wrap:wrap; padding:10px 14px; border-bottom:1px solid var(--border); background:#FAFBFC; }
  .dt-bar .sp { flex:1; }
  .dt-chip { display:inline-flex; align-items:center; gap:6px; height:30px; padding:0 12px; border-radius:15px; border:1.5px solid var(--border); background:#fff; font-size:13px; font-weight:600; cursor:pointer; color:#374151; }
  .dt-chip b { font-variant-numeric:tabular-nums; }
  .dt-chip.on { background:var(--brand-soft); border-color:var(--brand); color:var(--brand); }
  .dt-chip.bad b { color:var(--brand); }
  table.dtt { width:100%; border-collapse:collapse; }
  table.dtt th { padding:8px 12px; font-size:11px; font-weight:600; color:var(--muted); text-transform:uppercase; letter-spacing:.3px; text-align:right; background:#F8F9FA; border-bottom:1px solid var(--border); white-space:nowrap; cursor:pointer; user-select:none; }
  table.dtt th.l, table.dtt td.l { text-align:left; }
  table.dtt th:hover { color:var(--text); }
  table.dtt th .ar { color:var(--brand); margin-left:3px; }
  table.dtt td { padding:7px 12px; border-bottom:1px solid #F0F1F4; text-align:right; font-variant-numeric:tabular-nums; vertical-align:middle; }
  table.dtt tbody tr { cursor:pointer; }
  table.dtt tbody tr:hover td { background:#FAFBFC; }
  table.dtt td.n { color:var(--muted); width:54px; text-align:center; }
  table.dtt td.nm { text-align:left; font-weight:600; }
  table.dtt td.nm .s { font-weight:400; font-size:12px; color:var(--muted); }
  .dt-exp { display:inline-block; padding:2px 9px; border-radius:8px; font-size:12px; font-weight:600; background:#F1F2F4; color:#374151; white-space:nowrap; }
  .dt-exp.w { background:var(--warn-bg); color:var(--warn); }
  .dt-exp.d { background:var(--brand-soft); color:var(--brand); }
  .dt-tag { display:inline-block; margin-left:6px; padding:1px 8px; border-radius:8px; font-size:11.5px; font-weight:600; background:var(--brand-soft); color:var(--brand); }
  .dt-tag.dr { background:#EEF0F3; color:#4B5563; }
  .dt-pager { display:flex; align-items:center; gap:6px; flex-wrap:wrap; padding:10px 14px; border-top:1px solid var(--border); background:#FAFBFC; font-size:13px; color:var(--muted); }
  .dt-pager .sp { flex:1; }
  .dt-pager button { min-width:32px; height:30px; padding:0 8px; border-radius:8px; border:1.5px solid var(--border); background:#fff; font-size:13px; font-weight:600; cursor:pointer; color:#374151; }
  .dt-pager button:hover:not(:disabled) { background:var(--bg); }
  .dt-pager button.cur { background:var(--brand); border-color:var(--brand); color:#fff; }
  .dt-pager button:disabled { opacity:.45; cursor:default; }
  .dt-pager select { height:30px; border:1.5px solid var(--border); border-radius:8px; background:#fff; padding:0 6px; }
  .dt-msg { padding:34px; text-align:center; color:var(--muted); }
  .dt-msg .btn2 { margin-top:10px; height:32px; padding:0 14px; border-radius:9px; border:1.5px solid var(--border); background:#fff; font-weight:600; cursor:pointer; }
  .dt-modal .modal-content { border:0; border-radius:16px; box-shadow:0 24px 60px rgba(20,25,40,.25); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; }
  .dt-modal .modal-header { padding:14px 18px; border-bottom:1px solid #E6E8EC; }
  .dt-modal .modal-title { font-size:16px; font-weight:700; }
  .dt-tiles { display:grid; grid-template-columns:repeat(4, 1fr); gap:8px; margin-bottom:12px; }
  .dt-tile { border:1px solid #E6E8EC; border-radius:10px; padding:8px 12px; }
  .dt-tile .l { font-size:11px; font-weight:600; color:#6B7280; text-transform:uppercase; letter-spacing:.3px; }
  .dt-tile .v { font-size:17px; font-weight:700; font-variant-numeric:tabular-nums; margin-top:2px; }
  .dt-warn { margin-bottom:10px; padding:8px 12px; border-radius:10px; background:#FDECEE; color:#D7182E; font-weight:600; font-size:13px; display:none; }
  table.dmt { width:100%; border-collapse:collapse; }
  table.dmt th { padding:7px 10px; font-size:11px; font-weight:600; color:#6B7280; text-transform:uppercase; text-align:left; background:#F8F9FA; border-bottom:1px solid #E6E8EC; }
  table.dmt th.r, table.dmt td.r { text-align:right; }
  table.dmt td { padding:7px 10px; border-bottom:1px solid #F0F1F4; font-size:13.5px; }
  table.dmt td a { color:#1F2430; font-weight:600; }
  @media (max-width:760px) { .dt-tiles { grid-template-columns:repeat(2, 1fr); } }
</style>

<div class="dt" id="dt" data-code="${page_code}">
  <div class="dt-top">
    <h2>Детализация</h2>
    <span style="color:var(--muted); font-size:13px">все партии препаратов: приход, расход, остаток</span>
  </div>
  <div class="dt-card">
    <div class="dt-bar">
      <button type="button" class="dt-chip on" data-f="all">Все <b id="n-all">…</b></button>
      <button type="button" class="dt-chip" data-f="saldo">Остаток <b id="n-saldo">…</b></button>
      <button type="button" class="dt-chip" data-f="rasxod">Был расход <b id="n-rasxod">…</b></button>
      <button type="button" class="dt-chip bad" data-f="diff" title="Расход партии не совпадает с суммой выдач по документам расхода">Расхождения <b id="n-diff">…</b></button>
      <button type="button" class="dt-chip bad" data-f="exp" title="Партия с остатком и истёкшим сроком годности">Просрочено <b id="n-exp">…</b></button>
      <span class="sp"></span>
      <input type="text" class="di" id="dt-search" placeholder="Поиск: препарат, акт, производитель..." style="width:320px" autocomplete="off">
    </div>
    <div id="dt-body">
      <div class="dt-msg" id="dt-loading"><i class="fa fa-spinner fa-spin"></i> Загрузка данных…</div>
    </div>
    <div class="dt-pager" id="dt-pager" style="display:none"></div>
  </div>
</div>

<a href="#" data-toggle="modal" data-target="#dtModal" id="dt_modal_btn" class="hidden"></a>
<div class="modal fade dt-modal" id="dtModal" tabindex="-1" role="dialog" aria-hidden="true" style="display:none">
  <div class="modal-dialog" style="width:760px; max-width:96vw">
    <div class="modal-content">
      <div class="modal-header"><button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title"><span id="m-name"></span></h4></div>
      <div class="modal-body">
        <div class="dt-tiles">
          <div class="dt-tile"><div class="l">Цена ед.</div><div class="v" id="m-price">0</div></div>
          <div class="dt-tile"><div class="l">Приход</div><div class="v" id="m-in">0</div></div>
          <div class="dt-tile"><div class="l">Расход (партия)</div><div class="v" id="m-out">0</div></div>
          <div class="dt-tile"><div class="l">По документам</div><div class="v" id="m-docs">0</div></div>
        </div>
        <div class="dt-warn" id="m-warn">Расход партии и сумма по документам расхода не совпадают</div>
        <table class="dmt" id="m-rows">
          <thead><tr><th>Документ расхода</th><th>Получатель</th><th class="r">Количество</th></tr></thead>
          <tbody></tbody>
        </table>
      </div>
      <div class="modal-footer"><button type="button" class="btn btn-default" id="close-modal" data-dismiss="modal">Закрыть</button></div>
    </div>
  </div>
</div>

<script>
  window.DT = (function () {
    var all = [], view = [], filter = 'all', q = '', sort = {key: 'name', dir: 1}, page = 1, size = 50, loaded = false;
    var today = new Date(new Date().toDateString());
    var CODE = {saldo: 'saldo', rasxod: 'rasxod'};

    function esc(s) { return $('<div/>').text(s == null ? '' : s).html(); }
    function fmt2(n) { return n.toLocaleString('ru-RU', {minimumFractionDigits: 2, maximumFractionDigits: 2}); }
    function ru(iso) { return iso && iso.length >= 10 ? iso.substr(8, 2) + '.' + iso.substr(5, 2) + '.' + iso.substr(0, 4) : '—'; }
    function dayDiff(iso) { return iso && iso.length >= 10 ? Math.floor((new Date(iso + 'T00:00:00') - today) / 86400000) : 99999; }
    function expCls(d) { return d < 0 ? 'd' : d <= 90 ? 'd' : d <= 180 ? 'w' : ''; }

    /* ---------- данные ---------- */
    function load() {
      $('#dt-body').html('<div class="dt-msg"><i class="fa fa-spinner fa-spin"></i> Загрузка данных…</div>');
      $.ajax({
        url: '/drugs/details/list.s', method: 'get', dataType: 'json', cache: false,
        success: function (res) {
          if (!res.success) { fail(res.msg); return; }
          var rows = res.rows, out = new Array(rows.length);
          for (var i = 0; i < rows.length; i++) {
            var r = rows[i], remain = Math.round((r[8] - r[9]) * 100) / 100;
            out[i] = {id: r[0], drug: r[1], name: r[2], act: r[3], date: r[4], st: r[5], exp: r[6], price: r[7], inq: r[8], used: r[9], outSum: r[10],
              man: r[11] || '', unit: r[12] || '', remain: remain, days: dayDiff(r[6]),
              diff: Math.abs(r[9] - r[10]) > 0.005,
              text: (r[2] + ' ' + r[3] + ' ' + (r[11] || '') + ' ' + (r[4] || '')).toLowerCase()};
          }
          all = out; loaded = true; counts(); apply(true);
        },
        error: function () { fail('Не удалось загрузить данные'); }
      });
    }
    function fail(t) {
      $('#dt-body').html('<div class="dt-msg">' + esc(t || 'Ошибка') + '<br><button class="btn2" type="button" onclick="DT.reload()">Повторить</button></div>');
    }
    function counts() {
      var n = {all: all.length, saldo: 0, rasxod: 0, diff: 0, exp: 0};
      for (var i = 0; i < all.length; i++) {
        var d = all[i];
        if (d.remain !== 0) n.saldo++;
        if (d.used > 0) n.rasxod++;
        if (d.diff) n.diff++;
        if (d.remain > 0 && d.days < 0) n.exp++;
      }
      $.each(n, function (k, v) { $('#n-' + k).text(v.toLocaleString('ru-RU')); });
    }

    /* ---------- фильтр, сортировка, страницы ---------- */
    function pass(d, words) {
      if (filter === 'saldo' && d.remain === 0) return false;
      if (filter === 'rasxod' && !(d.used > 0)) return false;
      if (filter === 'diff' && !d.diff) return false;
      if (filter === 'exp' && !(d.remain > 0 && d.days < 0)) return false;
      for (var i = 0; i < words.length; i++) if (d.text.indexOf(words[i]) === -1) return false;
      return true;
    }
    function apply(keepPage) {
      var words = $.trim(q).toLowerCase().split(/\s+/).filter(Boolean), res = [];
      for (var i = 0; i < all.length; i++) if (pass(all[i], words)) res.push(all[i]);
      var k = sort.key, dir = sort.dir;
      if (!(k === 'name' && dir === 1)) {   // the server already returns the list ordered by name / expiry
        res.sort(function (a, b) {
          var x = a[k], y = b[k];
          if (typeof x === 'string') return dir * x.localeCompare(y, 'ru');
          return dir * (x - y) || a.name.localeCompare(b.name, 'ru');
        });
      }
      view = res;
      if (!keepPage) page = 1;
      render();
    }
    function render() {
      var pages = Math.max(1, Math.ceil(view.length / size));
      if (page > pages) page = pages;
      var from = (page - 1) * size, slice = view.slice(from, from + size), h = '';
      if (!view.length) {
        $('#dt-body').html('<div class="dt-msg">Ничего не найдено</div>'); $('#dt-pager').hide(); return;
      }
      h = '<div style="overflow-x:auto"><table class="dtt"><thead><tr>' +
        '<th style="width:54px">#</th>' +
        hd('name', 'Препарат', 'l') + hd('act', 'Партия (акт)', 'l') + hd('exp', 'Срок годности') + hd('price', 'Цена ед.') +
        hd('inq', 'Приход') + hd('used', 'Расход') + hd('remain', 'Остаток') + '</tr></thead><tbody>';
      for (var i = 0; i < slice.length; i++) {
        var d = slice[i];
        h += '<tr data-id="' + d.id + '"><td class="n">' + (from + i + 1) + '</td>' +
          '<td class="nm">' + esc(d.name) + (d.man ? '<div class="s">' + esc(d.man) + '</div>' : '') + '</td>' +
          '<td class="l">№' + esc(d.act) + ' от ' + esc(d.date) + (d.st === 'E' ? '<span class="dt-tag dr">черновик</span>' : '') + '</td>' +
          '<td><span class="dt-exp ' + expCls(d.days) + '">' + ru(d.exp) + '</span></td>' +
          '<td>' + fmt2(d.price) + '</td><td>' + fmt2(d.inq) + '</td>' +
          '<td>' + fmt2(d.used) + (d.diff ? '<span class="dt-tag" title="По документам расхода: ' + fmt2(d.outSum) + '">расхождение</span>' : '') + '</td>' +
          '<td><b>' + fmt2(d.remain) + '</b> <span style="color:var(--muted); font-size:12px">' + esc(d.unit) + '</span></td></tr>';
      }
      h += '</tbody></table></div>';
      $('#dt-body').html(h);
      pager(pages, from, slice.length);
    }
    function hd(key, title, cls) {
      return '<th class="' + (cls || '') + '" data-s="' + key + '">' + title + ' <span class="ar">' + (sort.key === key ? (sort.dir > 0 ? '▲' : '▼') : '') + '</span></th>';
    }
    function pager(pages, from, n) {
      var h = '<span>Показано <b style="color:var(--text)">' + (from + 1).toLocaleString('ru-RU') + '–' + (from + n).toLocaleString('ru-RU') + '</b> из <b style="color:var(--text)">' + view.length.toLocaleString('ru-RU') + '</b></span><span class="sp"></span>';
      h += '<button type="button" data-p="1"' + (page === 1 ? ' disabled' : '') + '>«</button><button type="button" data-p="' + (page - 1) + '"' + (page === 1 ? ' disabled' : '') + '>‹</button>';
      var set = {}, list = [];
      [1, 2, page - 2, page - 1, page, page + 1, page + 2, pages - 1, pages].forEach(function (p) { if (p >= 1 && p <= pages && !set[p]) { set[p] = 1; list.push(p); } });
      list.sort(function (a, b) { return a - b; });
      var prev = 0;
      list.forEach(function (p) {
        if (p - prev > 1) h += '<span>…</span>';
        h += '<button type="button" data-p="' + p + '"' + (p === page ? ' class="cur"' : '') + '>' + p + '</button>';
        prev = p;
      });
      h += '<button type="button" data-p="' + (page + 1) + '"' + (page === pages ? ' disabled' : '') + '>›</button><button type="button" data-p="' + pages + '"' + (page === pages ? ' disabled' : '') + '>»</button>';
      h += '<span style="margin-left:8px">на странице</span><select id="dt-size">';
      [25, 50, 100, 200].forEach(function (s) { h += '<option value="' + s + '"' + (s === size ? ' selected' : '') + '>' + s + '</option>'; });
      h += '</select>';
      $('#dt-pager').html(h).show();
    }

    /* ---------- окно детализации партии ---------- */
    function open(id) {
      $.ajax({
        url: '/drugs/details.s', data: 'id=' + id, method: 'post', dataType: 'json',
        success: function (res) {
          if (!res.success) { alert(res.msg); return; }
          $('#m-name').text(res.name);
          $('#m-price').text(fmt2(Number(res.price) || 0));
          $('#m-in').text(fmt2(Number(res.drug_count) || 0));
          $('#m-out').text(fmt2(Number(res.rasxod) || 0));
          $('#m-docs').text(fmt2(Number(res.counter) || 0));
          $('#m-warn').toggle(Math.abs(parseFloat(res.rasxod) - parseFloat(res.counter)) > 0.005);
          var b = $('#m-rows tbody').empty();
          if (!res.rows.length) b.append('<tr><td colspan="3" style="text-align:center; color:#6B7280; padding:16px">Документов расхода по этой партии нет</td></tr>');
          $.each(res.rows, function (i, r) {
            b.append('<tr><td><a href="#" onclick="DT.openDoc(' + r.doc_id + '); return false;">№' + esc(r.reg_num) + ' от ' + esc(r.reg_date) + '</a></td><td>' + esc(r.direction_name) + '</td><td class="r">' + fmt2(Number(r.counter) || 0) + '</td></tr>');
          });
          $('#dt_modal_btn').click();
        }
      });
    }
    function openDoc(id) {
      $('#close-modal').click(); $('.modal-backdrop').remove(); $('body').removeClass('modal-open');
      setPage('/drugs/out/save.s?id=' + id);
    }

    $(function () {
      var c = '' + $('#dt').data('code');
      if (CODE[c]) { filter = CODE[c]; $('.dt-chip').removeClass('on').filter('[data-f=' + filter + ']').addClass('on'); }
      var timer = null;
      $('#dt-search').on('input', function () {
        var v = this.value; clearTimeout(timer);
        timer = setTimeout(function () { q = v; if (loaded) apply(); }, 200);
      });
      $('.dt-chip').on('click', function () { filter = '' + $(this).data('f'); $('.dt-chip').removeClass('on'); $(this).addClass('on'); if (loaded) apply(); });
      $('#dt-body').on('click', 'th[data-s]', function () {
        var k = $(this).data('s');
        sort = {key: k, dir: sort.key === k ? -sort.dir : 1}; apply();
      }).on('click', 'tbody tr', function () { open($(this).data('id')); });
      $('#dt-pager').on('click', 'button[data-p]', function () { page = Number($(this).data('p')); render(); var t = $('#dt')[0]; if (t && t.scrollIntoView) t.scrollIntoView({block: 'start'}); })
        .on('change', '#dt-size', function () { size = Number(this.value); page = 1; render(); });
      load();
    });
    return {reload: load, openDoc: openDoc};
  })();
</script>
