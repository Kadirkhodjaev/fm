<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
  .or { --brand:#D7182E; --brand-soft:#FDECEE; --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --bg:#F5F6F8; --ok:#15803D; --ok-bg:#E8F7EE; --warn:#B45309; --warn-bg:#FEF3C7; --blue:#1D4ED8; --blue-bg:#E7F0FD;
    padding:12px 14px 28px; color:var(--text); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; font-size:14px; }
  .or * { box-sizing:border-box; }
  .or-top { display:flex; align-items:center; gap:10px; flex-wrap:wrap; margin-bottom:10px; }
  .or-top h2 { margin:0; font-size:19px; font-weight:700; }
  .or .ab { display:inline-flex; align-items:center; gap:7px; height:34px; padding:0 13px; border-radius:9px; border:1.5px solid var(--border); background:#fff; color:var(--text); font-size:13px; font-weight:600; cursor:pointer; white-space:nowrap; }
  .or .ab:hover { background:var(--bg); }
  .or .ab.primary { background:var(--brand); border-color:var(--brand); color:#fff; }
  .or .ab.primary:hover { background:#A50F22; }
  .or .ab:disabled { opacity:.5; cursor:not-allowed; }
  .or-card { background:#fff; border:1px solid var(--border); border-radius:14px; margin-bottom:12px; overflow:hidden; }
  .or-set { display:flex; flex-wrap:wrap; gap:10px 16px; align-items:flex-end; padding:12px 16px; }
  .or-set .f { display:flex; flex-direction:column; gap:3px; }
  .or-set .f > label { margin:0; font-size:11.5px; font-weight:600; color:var(--muted); text-transform:uppercase; letter-spacing:.2px; }
  .or .oi { height:34px; border:1.5px solid var(--border); border-radius:9px; padding:4px 10px; font-size:14px; background:#fff; color:var(--text); }
  .or .oi:focus { border-color:var(--brand); box-shadow:0 0 0 3px rgba(215,24,46,.10); outline:none; }
  .or .ck { display:inline-flex; align-items:center; gap:6px; height:34px; font-size:13px; cursor:pointer; margin:0; }
  .or .ck input { margin:0; width:16px; height:16px; accent-color:var(--brand); }
  .or-tiles { display:grid; grid-template-columns:repeat(4, minmax(0, 1fr)); gap:10px; margin-bottom:12px; }
  .or-tile { background:#fff; border:1px solid var(--border); border-radius:14px; padding:11px 16px; }
  .or-tile .l { font-size:11.5px; font-weight:600; color:var(--muted); text-transform:uppercase; letter-spacing:.3px; }
  .or-tile .v { font-size:20px; font-weight:700; margin-top:3px; font-variant-numeric:tabular-nums; white-space:nowrap; }
  .or-tile .s { font-size:12px; color:var(--muted); margin-top:1px; }
  .or-tile.red .v { color:var(--brand); }
  .or-bar { display:flex; align-items:center; gap:8px; flex-wrap:wrap; padding:10px 14px; border-bottom:1px solid var(--border); background:#FAFBFC; }
  .or-bar .sp { flex:1; }
  .or-chip { display:inline-flex; align-items:center; gap:6px; height:30px; padding:0 12px; border-radius:15px; border:1.5px solid var(--border); background:#fff; font-size:13px; font-weight:600; cursor:pointer; color:#374151; }
  .or-chip b { font-variant-numeric:tabular-nums; }
  .or-chip.on { background:var(--brand-soft); border-color:var(--brand); color:var(--brand); }
  table.ot { width:100%; border-collapse:collapse; }
  table.ot th { padding:8px 10px; font-size:11px; font-weight:600; color:var(--muted); text-transform:uppercase; letter-spacing:.3px; text-align:right; background:#F8F9FA; border-bottom:1px solid var(--border); white-space:nowrap; cursor:pointer; user-select:none; }
  table.ot th.l, table.ot td.l { text-align:left; }
  table.ot th.nos { cursor:default; }
  table.ot th .ar { color:var(--brand); margin-left:3px; }
  table.ot td { padding:8px 10px; border-bottom:1px solid #F0F1F4; text-align:right; font-variant-numeric:tabular-nums; vertical-align:middle; }
  table.ot tbody tr:hover td { background:#FAFBFC; }
  table.ot td.nm { text-align:left; }
  table.ot td.nm .t { font-weight:600; }
  table.ot td.nm .s { font-size:12px; color:var(--muted); margin-top:2px; }
  table.ot td.ck1 { width:34px; text-align:center; }
  .or-st { display:inline-block; padding:2px 10px; border-radius:10px; font-size:12px; font-weight:600; white-space:nowrap; }
  .or-st.urgent { background:var(--brand-soft); color:var(--brand); }
  .or-st.order { background:var(--warn-bg); color:var(--warn); }
  .or-st.ok { background:var(--ok-bg); color:var(--ok); }
  .or-st.excess { background:var(--blue-bg); color:var(--blue); }
  .or-st.stale { background:#F1F2F4; color:#4B5563; }
  .or-st.expired { background:var(--brand-soft); color:#991B1B; }
  .or-st.no_stock { background:#F3E8FF; color:#7E22CE; }
  .or-info { padding:9px 16px; font-size:13px; color:#374151; background:#F8F9FA; border-bottom:1px solid var(--border); }
  .or-tag { display:inline-block; margin-right:5px; padding:0 7px; border-radius:7px; font-size:11px; font-weight:600; background:#EEF0F3; color:#4B5563; }
  .or-tag.a { background:#FDECEE; color:#D7182E; }
  .or-tag.w { background:var(--warn-bg); color:var(--warn); }
  .or-cov.r { color:var(--brand); font-weight:700; }
  .or-cov.y { color:var(--warn); font-weight:600; }
  .or-trend.up { color:var(--warn); }
  .or-trend.down { color:var(--blue); }
  .or .bl { width:76px; height:30px; text-align:right; border:1.5px solid var(--border); border-radius:8px; padding:2px 6px; font-size:13.5px; }
  .or .bl:focus { border-color:var(--brand); outline:none; }
  .or-pager { display:flex; align-items:center; gap:6px; flex-wrap:wrap; padding:10px 14px; border-top:1px solid var(--border); background:#FAFBFC; font-size:13px; color:var(--muted); }
  .or-pager .sp { flex:1; }
  .or-pager button { min-width:32px; height:30px; padding:0 8px; border-radius:8px; border:1.5px solid var(--border); background:#fff; font-size:13px; font-weight:600; cursor:pointer; color:#374151; }
  .or-pager button.cur { background:var(--brand); border-color:var(--brand); color:#fff; }
  .or-pager button:disabled { opacity:.45; cursor:default; }
  .or-pager select { height:30px; border:1.5px solid var(--border); border-radius:8px; background:#fff; padding:0 6px; }
  .or-msg { padding:34px; text-align:center; color:var(--muted); }
  .or-how { padding:12px 16px; font-size:13px; color:#374151; line-height:1.55; }
  .or-how summary { cursor:pointer; font-weight:700; }
  .or-how code { background:#F1F2F4; border-radius:5px; padding:1px 6px; font-size:12.5px; }
  table.ot td.nm { cursor:help; }
  /* the window is as wide as the table, never wider than the screen; the text below the table wraps to the table width */
  .or-pop { display:none; position:fixed; z-index:2000; box-sizing:border-box; width:max-content; max-width:calc(100vw - 32px); max-height:calc(100vh - 16px); overflow:auto;
    background:#fff; border:1px solid #E6E8EC; border-radius:12px; box-shadow:0 10px 30px rgba(17,24,39,.16); padding:10px 12px; font-size:13px; line-height:1.4; color:#1F2430; text-align:left;
    pointer-events:none; font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; }
  .or-pop * { box-sizing:border-box; }
  .or-pop .pt { font-weight:700; margin-bottom:6px; white-space:normal; width:0; min-width:100%; }
  .or-pop .pt span { font-weight:400; color:#6B7280; }
  .or-pop .tw { overflow-x:auto; max-width:100%; }
  .or-pop table { border-collapse:collapse; width:100%; table-layout:auto; margin:0; background:none; }
  .or-pop th { font-size:11px; font-weight:600; color:#6B7280; text-transform:uppercase; padding:4px 8px; text-align:right; border:0; border-bottom:1px solid #E6E8EC; white-space:nowrap; background:none; }
  .or-pop td { padding:4px 8px; text-align:right; border:0; border-bottom:1px solid #F0F1F4; white-space:nowrap; font-variant-numeric:tabular-nums; }
  .or-pop th.l, .or-pop td.l { text-align:left; }
  .or-pop td.l { white-space:normal; min-width:110px; max-width:220px; }
  .or-pop tr.tot td { background:#F8F9FA; font-weight:600; }
  .or-pop .pp { color:#15803D; }
  .or-pop .mm { color:#D7182E; }
  .or-pop .pn { margin-top:7px; font-size:12px; color:#4B5563; line-height:1.5; white-space:normal; width:0; min-width:100%; }
  @media (max-width:900px) { .or-tiles { grid-template-columns:repeat(2, minmax(0, 1fr)); } }
</style>

<div class="or" id="or" data-dirs="${autoDirs}">
  <div class="or-top">
    <h2>Заявки поставщикам</h2>
    <span style="color:var(--muted); font-size:13px">что и сколько заказать по расходу, остаткам и срокам годности</span>
  </div>

  <div class="or-card">
    <div class="or-set">
      <div class="f"><label>Период анализа</label>
        <select class="oi" id="s-period"><option value="14">14 дней</option><option value="28" selected>28 дней</option><option value="60">60 дней</option><option value="90">90 дней</option></select></div>
      <div class="f"><label title="Заказ в Пн, Ср, Пт: поставка вечером, в работе со следующего дня. Пн → 2 дня (Вт, Ср), Ср → 2 дня (Чт, Пт), Пт → 3 дня (Сб, Вс, Пн)">Дней до след. поставки</label>
        <select class="oi" id="s-cover" style="width:170px"><option value="0" selected>авто</option><option value="1">1</option><option value="2">2</option><option value="3">3</option><option value="4">4</option><option value="5">5</option><option value="6">6</option><option value="7">7</option></select></div>
      <div class="f"><label>Не допускать дефицита</label>
        <select class="oi" id="s-service"><option value="90" selected>в 90% случаев</option><option value="95">в 95% случаев</option><option value="98">в 98% случаев</option></select></div>
      <span id="s-cover-info" style="font-size:12.5px; color:var(--muted); align-self:center; max-width:340px">Заказ в Пн, Ср, Пт · поставка вечером, в работе со следующего дня</span>
      <button class="ab primary" type="button" onclick="OR.run()"><i class="fa fa-calculator"></i> Рассчитать</button>
    </div>
  </div>

  <div class="or-tiles">
    <div class="or-tile"><div class="l">К заказу</div><div class="v" id="t-sel">0</div><div class="s" id="t-sel2">позиций</div></div>
    <div class="or-tile"><div class="l">Сумма заказа</div><div class="v" id="t-sum">0</div><div class="s">с НДС, по последней цене</div></div>
    <div class="or-tile red"><div class="l">Срочно</div><div class="v" id="t-urgent">0</div><div class="s">отделениям нужно выдать больше, чем есть на складе аптеки</div></div>
    <div class="or-tile"><div class="l">Риск списания</div><div class="v" id="t-risk">0</div><div class="s" id="t-risk2">просрочено · не успеют использовать до срока годности</div></div>
  </div>

  <div class="or-card">
    <div class="or-bar">
      <button type="button" class="or-chip on" data-f="">Все <b id="n-all">…</b></button>
      <button type="button" class="or-chip" data-f="urgent">Срочно <b id="n-urgent">…</b></button>
      <button type="button" class="or-chip" data-f="order">Заказать <b id="n-order">…</b></button>
      <button type="button" class="or-chip" data-f="ok">Достаточно <b id="n-ok">…</b></button>
      <button type="button" class="or-chip" data-f="excess">Избыток <b id="n-excess">…</b></button>
      <button type="button" class="or-chip" data-f="expired" title="На складе аптеки остался только просроченный препарат, в отделениях нет — к списанию">Просрочено <b id="n-expired">…</b></button>
      <button type="button" class="or-chip" data-f="stale" title="Есть полезный (непросроченный) остаток на складе аптеки или в отделениях, но за выбранный период ни разу не расходовался">Простой <b id="n-stale">…</b></button>
      <button type="button" class="or-chip" data-f="no_stock" title="Нормы нет, остатка нет ни в аптеке, ни в отделениях — решите вручную, нужен ли препарат">Без нормы и остатка <b id="n-no_stock">…</b></button>
      <span class="sp"></span>
      <select class="oi" id="f-partner" style="max-width:220px"><option value="">Все поставщики</option></select>
      <input type="text" class="oi" id="f-search" placeholder="Поиск препарата..." style="width:240px" autocomplete="off">
    </div>
    <div class="or-info" id="or-info" style="display:none"></div>
    <div id="or-body"><div class="or-msg"><i class="fa fa-spinner fa-spin"></i> Расчёт…</div></div>
    <div class="or-pager" id="or-pager" style="display:none"></div>
    <div class="or-pager" id="or-act" style="display:none">
      <span id="act-info"></span><span class="sp"></span>
      <button class="ab" type="button" onclick="OR.excel()"><i class="fa fa-file-excel-o"></i> Excel</button>
      <button class="ab primary" type="button" onclick="OR.print()"><i class="fa fa-print"></i> Сформировать заказ поставщикам</button>
    </div>
  </div>

  <div class="or-card">
    <details class="or-how">
      <summary>Как считается количество к заказу</summary>
      <p><b>Расход</b> — сколько израсходовали основные отделения (общий расход и расход по пациентам). <code>d</code> отделения = средний расход в день за выбранный период анализа (полные дни, без сегодняшнего дня; для нового препарата — за дни с первого прихода, не меньше 7); отдельно учитывается, сколько уже израсходовано сегодня.</p>
      <p><b>Дней до след. поставки</b> — заказ в Пн, Ср, Пт отправляется в тот же день, поставка вечером, в работе со следующего дня. Значит, заказ должен покрыть: в Пн и Ср — 2 дня, в Пт — 3 дня (Сб, Вс, Пн).</p>
      <p><b>Выдать отделению</b> = <code>норма + (d − израсходовано сегодня) + d × дней до поставки − остаток отделения</code> (не меньше 0), но только если остаток к поставке (остаток − расход до поставки) опустится до <b>порога</b>: порог из нормы препарата, если он меньше нормы, иначе половина нормы. Если остатка хватает с запасом, отделению ничего не добавляем. Нормы, пороги, остатки и «+/−» по отделениям видны при наведении мышки на название препарата.</p>
      <p><b>Страховой запас</b> = <code>z × σ × √дней до поставки</code>, где σ — разброс дневного расхода за период анализа. «Не допускать дефицита» задаёт <code>z</code> (90% → 1,28).</p>
      <p><b>Полезный остаток</b> — остаток склада аптеки по партиям (вместе с неподтверждёнными актами), который успеют использовать до окончания срока годности (первыми уходят партии с ранним сроком). Остальное — «риск списания»: <b>просрочено</b> (срок уже истёк) и <b>не успеет</b> (срок истечёт раньше, чем препарат израсходуют). Под названием препарата виден фактический склад аптеки: всего, полезно, просрочено, не успеет, неподтверждённые акты.</p>
      <p><b>Перемещение между отделениями</b> — у отделения есть <b>излишек</b>, если после расхода до поставки у него останется больше порога: <code>излишек = остаток − расход до поставки − порог</code> (отделение может отдать до порога). Сначала нехватку отделений покрываем излишками других (самый большой излишек → самой большой нехватке), из аптеки выдаём только остальное. Предлагаемые перемещения видны в подсказке на препарате.</p>
      <p><b>К заказу</b> = <code>(сумма «выдать» по отделениям − перемещения) + страховой запас − полезный остаток</code>, округляется вверх до целых блоков и не превышает 60% того, что успеют использовать за типичный срок годности. Если из аптеки выдавать не нужно (остатки выше порога или всё покрывается перемещениями), к заказу 0 — страховой запас сам по себе заказ не создаёт. Цена и поставщик — из последнего прихода.</p>
      <p><b>Хватит на, дн.</b> = <code>(полезный остаток аптеки + остаток в отделениях) / расход в день</code>. Статусы проверяются по порядку:</p>
      <p><b>Без нормы и остатка</b> — нормы нет, остатка нет ни в аптеке, ни в отделениях. Эти препараты показываются только на своей вкладке; количество к заказу посчитано по расходу, но галочка не ставится — аптека решает вручную. <b>Срочно</b> — из аптеки (после перемещений между отделениями) нужно выдать больше, чем есть на складе аптеки. <b>Заказать</b> — есть что заказать. <b>Просрочено</b> — на складе аптеки остался только просроченный препарат (срок годности уже истёк), в отделениях нет, выдавать никому не нужно: это к списанию, на вкладке видна сумма. <b>Простой</b> — есть полезный (непросроченный) остаток на складе аптеки или в отделениях, но за выбранный период препарат ни разу не расходовался и никому не нужно выдавать; на вкладке видна сумма такого остатка. <b>Избыток</b> — общего запаса больше чем на 90 дней. Иначе <b>Достаточно</b>.</p>
    </details>
  </div>
</div>

<script>
  window.OR = (function () {
    var R = {id: 0, name: 1, unit: 2, block: 3, d: 4, trend: 5, sigma: 6, usable: 7, risk: 8, draft: 9, dept: 10, deficit: 11, cover: 12, rop: 13, target: 14, units: 15, blocks: 16,
      price: 17, nds: 18, partner: 19, status: 20, abc: 21, q: 22, eff: 23, low: 24, capped: 25, shelf: 26, ss: 27, norm: 28, deps: 29, tr: 30, exp: 31, late: 32, ph: 33, drafts: 34};
    // deps: [[direction id, stock, up to the norm, use per day, norm, to issue, used today, threshold, surplus], ...]
    // tr: transfers between the departments [[from direction id, to direction id, quantity], ...]
    var D = {id: 0, stock: 1, toNorm: 2, d: 3, norm: 4, issue: 5, today: 6, thr: 7, sur: 8};
    var STATUS = {no_stock: 'Нет нормы и остатка', urgent: 'Срочно', order: 'Заказать', expired: 'Просрочено', stale: 'Простой', excess: 'Избыток', ok: 'Достаточно'};
    var DAYS = ['', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    var all = [], view = [], filter = '', q = '', partner = '', sort = {key: 'urgency', dir: 1}, page = 1, size = 50, edited = {}, picked = {}, cover = 2, dirs = [], period = 28, loaded = false;
    var rank = {urgent: 0, order: 1, no_stock: 2, expired: 3, excess: 4, ok: 5, stale: 6};

    function num(v) { var n = parseFloat(('' + v).replace(/[\s ]/g, '').replace(',', '.')); return isNaN(n) ? 0 : n; }
    function fmt(n) { return Math.round(n).toLocaleString('ru-RU'); }
    function fmt1(n) { return n.toLocaleString('ru-RU', {maximumFractionDigits: 1}); }
    function fmt2(n) { return n.toLocaleString('ru-RU', {minimumFractionDigits: 2, maximumFractionDigits: 2}); }
    function esc(s) { return $('<div/>').text(s == null ? '' : s).html(); }

    /* ---------- настройки ---------- */
    function readSettings() {
      return {period: $('#s-period').val(), cover: $('#s-cover').val(), service: $('#s-service').val()};
    }
    // the days until the next delivery are not remembered: by default they follow the day of the week
    function saveSettings(s) { try { localStorage.setItem('or-settings-v2', JSON.stringify({period: s.period, service: s.service})); } catch (e) {} }
    function loadSettings() {
      try {
        var s = JSON.parse(localStorage.getItem('or-settings-v2') || 'null');
        if (!s) return;
        $('#s-period').val(s.period); $('#s-service').val(s.service);
      } catch (e) {}
    }
    function coverInfo(p) {
      var days = String(p.orderDays || '1,3,5').split(',').map(function (x) { return DAYS[+x] || x; }).join(', ');
      $('#s-cover option[value="0"]').text('авто: ' + p.coverDays + ' дн.');
      $('#s-cover-info').html('Заказ в ' + esc(days) + ' · поставка вечером, в работе со следующего дня · сейчас заказ покрывает <b style="color:#1F2430">' + p.coverDays + ' дн.</b>' + (p.auto ? '' : ' (задано вручную)'));
    }

    /* ---------- загрузка ---------- */
    function run() {
      var s = readSettings(); saveSettings(s);
      $('#or-body').html('<div class="or-msg"><i class="fa fa-spinner fa-spin"></i> Расчёт… (анализируются расход, остатки и сроки годности)</div>');
      $('#or-pager, #or-act').hide();
      $.ajax({
        url: '/drugs/order/data.s', data: s, method: 'get', dataType: 'json', cache: false,
        success: function (res) {
          if (!res.success) { fail(res.msg); return; }
          all = res.rows; edited = {}; picked = {}; loaded = true;
          cover = res.params.coverDays; dirs = res.params.dirs || []; period = res.params.period; coverInfo(res.params);
          for (var i = 0; i < all.length; i++) {
            var r = all[i];
            r._text = (r[R.name] + ' ' + r[R.partner]).toLowerCase();
            r._rank = rank[r[R.status]];
            r._open = r[R.blocks] > 0;
            if (r._open && (r[R.status] === 'urgent' || r[R.status] === 'order')) picked[r[R.id]] = true;
          }
          fillPartners(); counts(); apply(); summary();
        },
        error: function () { fail('Не удалось выполнить расчёт'); }
      });
    }
    function fail(t) { $('#or-body').html('<div class="or-msg">' + esc(t || 'Ошибка') + '<br><button class="ab" style="margin-top:10px" type="button" onclick="OR.run()">Повторить</button></div>'); }
    function fillPartners() {
      var set = {}, list = [];
      all.forEach(function (r) { var p = r[R.partner] || ''; if (!set[p]) { set[p] = 1; list.push(p); } });
      list.sort(function (a, b) { return a.localeCompare(b, 'ru'); });
      var h = '<option value="">Все поставщики</option>';
      list.forEach(function (p) { h += '<option value="' + esc(p) + '">' + (p ? esc(p) : 'Без поставщика') + '</option>'; });
      $('#f-partner').html(h).val(partner);
    }
    function counts() {
      // the drugs without a norm and without stock are shown only on their own tab
      var n = {all: 0, urgent: 0, order: 0, ok: 0, excess: 0, expired: 0, stale: 0, no_stock: 0};
      all.forEach(function (r) { n[r[R.status]]++; if (r[R.status] !== 'no_stock') n.all++; });
      $.each(n, function (k, v) { $('#n-' + k).text(v); });
    }

    /* ---------- заказ ---------- */
    function blocksOf(r) { var id = r[R.id]; return edited.hasOwnProperty(id) ? edited[id] : r[R.blocks]; }
    function sumOf(r) { return blocksOf(r) * r[R.block] * (r[R.price] + r[R.nds]); }
    // the real stock of the pharmacy: all, usable, expired, expires before it is used up, unconfirmed acts
    function stockText(r) {
      return 'склад аптеки: всего ' + fmt1(r[R.ph]) + ', полезно ' + fmt1(r[R.usable]) +
        (r[R.exp] > 0 ? ', <span style="color:var(--brand)">просрочено ' + fmt1(r[R.exp]) + '</span>' : '') +
        (r[R.late] > 0 ? ', не успеет ' + fmt1(r[R.late]) : '') +
        (r[R.drafts] > 0 ? ', неподтверждённые ' + fmt1(r[R.drafts]) : '');
    }
    function summary() {
      var cnt = 0, sum = 0, urgent = 0, risk = 0, exp = 0, late = 0, orderable = 0;
      all.forEach(function (r) {
        var price = r[R.price] + r[R.nds];
        if (r[R.status] === 'urgent') urgent++;
        exp += r[R.exp] * price; late += r[R.late] * price;
        risk = exp + late;
        if (r._open) orderable++;
        if (picked[r[R.id]] && blocksOf(r) > 0) { cnt++; sum += sumOf(r); }
      });
      $('#t-sel').text(cnt); $('#t-sel2').text('из ' + orderable + ' рекомендованных');
      $('#t-sum').text(fmt(sum)); $('#t-urgent').text(urgent); $('#t-risk').text(fmt(risk));
      $('#t-risk2').html('просрочено <b style="color:var(--brand)">' + fmt(exp) + '</b> · не успеют использовать ' + fmt(late) + ' · с НДС');
      $('#act-info').html('Выбрано позиций: <b style="color:#1F2430">' + cnt + '</b> · на сумму <b style="color:#1F2430">' + fmt2(sum) + '</b> с НДС');
      $('#or-act').toggle(all.length > 0);
    }

    /* ---------- итог по вкладкам «Простой», «Просрочено» и «Без нормы и остатка» ---------- */
    function info() {
      var $i = $('#or-info');
      if (filter === 'stale') {
        var n = 0, ph = 0, dep = 0, exp = 0;
        all.forEach(function (r) {
          if (r[R.status] !== 'stale') return;
          var price = r[R.price] + r[R.nds];
          n++; ph += r[R.usable] * price; dep += r[R.dept] * price; exp += r[R.exp] * price;
        });
        $i.html('Не расходовались за выбранный период (' + period + ' дн.): препаратов <b>' + n + '</b> · полезный остаток на сумму <b>' + fmt(ph + dep) + '</b> ' +
          '(склад аптеки ' + fmt(ph) + ', отделения ' + fmt(dep) + ')' + (exp > 0 ? ' · кроме того просрочено <b style="color:var(--brand)">' + fmt(exp) + '</b>' : '') +
          ' · с НДС, по последней цене').show();
      } else if (filter === 'expired') {
        var m = 0, sumExp = 0;
        all.forEach(function (r) { if (r[R.status] === 'expired') { m++; sumExp += r[R.exp] * (r[R.price] + r[R.nds]); } });
        $i.html('Весь остаток на складе аптеки просрочен, в отделениях нет: препаратов <b>' + m + '</b> · просрочено на сумму <b style="color:var(--brand)">' + fmt(sumExp) + '</b> — к списанию · с НДС, по последней цене').show();
      } else if (filter === 'no_stock') {
        $i.html('Нормы нет и остатка нет ни в аптеке, ни в отделениях. Количество посчитано по расходу за период, но галочки не ставятся — решите вручную, нужен ли препарат.').show();
      } else $i.hide();
    }

    /* ---------- список ---------- */
    function apply(keep) {
      var words = $.trim(q).toLowerCase().split(/\s+/).filter(Boolean), res = [];
      for (var i = 0; i < all.length; i++) {
        var r = all[i];
        if (filter ? r[R.status] !== filter : r[R.status] === 'no_stock') continue;
        if (partner !== '' && (r[R.partner] || '') !== partner) continue;
        var ok = true;
        for (var w = 0; w < words.length; w++) if (r._text.indexOf(words[w]) === -1) { ok = false; break; }
        if (ok) res.push(r);
      }
      var k = sort.key, dir = sort.dir;
      res.sort(function (a, b) {
        var x, y;
        if (k === 'urgency') { x = a._rank; y = b._rank; if (x !== y) return dir * (x - y); x = a[R.cover]; y = b[R.cover]; return dir * (x - y); }
        if (k === 'name' || k === 'partner') return dir * String(a[R[k]]).localeCompare(String(b[R[k]]), 'ru');
        if (k === 'status') return dir * (a._rank - b._rank);
        if (k === 'sum') { x = sumOf(a); y = sumOf(b); } else { x = a[R[k]]; y = b[R[k]]; }
        return dir * (x - y);
      });
      view = res;
      info();
      if (!keep) page = 1;
      render();
    }
    function hd(key, title, cls) {
      return '<th class="' + (cls || '') + '" data-s="' + key + '">' + title + ' <span class="ar">' + (sort.key === key ? (sort.dir > 0 ? '▲' : '▼') : '') + '</span></th>';
    }
    /* ---------- подсказка по отделениям (при наведении на препарат) ---------- */
    function pm(v) { return v > 0.0001 ? '<span class="pp">+' + fmt1(v) + '</span>' : v < -0.0001 ? '<span class="mm">−' + fmt1(-v) + '</span>' : '<span style="color:var(--muted)">0</span>'; }
    function pop(r) {
      var names = {}, deps = r[R.deps] || [], trs = r[R.tr] || [], s = {norm: 0, stock: 0, sur: 0, d: 0, today: 0, issue: 0}, moved = 0;
      dirs.forEach(function (x) { names[x[0]] = x[1]; });
      function dn(id) { return esc(names[id] || id); }
      var h = '<div class="pt">' + esc(r[R.name]) + ' <span>· ' + esc(r[R.unit]) + '</span></div>' +
        '<div class="tw"><table><tr><th class="l">Отделение</th><th>Норма</th><th>Порог</th><th>Остаток</th><th>+/−</th><th title="Сколько отделение может передать другим и остаться на пороге к поставке">Излишек</th><th>Расход/день</th><th>Сегодня</th><th>Выдать</th></tr>';
      deps.forEach(function (x) {
        s.norm += x[D.norm]; s.stock += x[D.stock]; s.sur += x[D.sur] || 0; s.d += x[D.d]; s.today += x[D.today]; s.issue += x[D.issue];
        h += '<tr><td class="l">' + dn(x[D.id]) + '</td><td>' + fmt1(x[D.norm]) + '</td><td>' + fmt1(x[D.thr] || 0) + '</td><td>' + fmt1(x[D.stock]) + '</td><td><b>' + pm(x[D.stock] - x[D.norm]) + '</b></td>' +
          '<td>' + (x[D.sur] > 0 ? '<span class="pp">' + fmt1(x[D.sur]) + '</span>' : '—') + '</td>' +
          '<td>' + (x[D.d] > 0 ? fmt2(x[D.d]) : '—') + '</td><td>' + (x[D.today] > 0 ? fmt1(x[D.today]) : '—') + '</td><td><b>' + fmt1(x[D.issue]) + '</b></td></tr>';
      });
      h += '<tr class="tot"><td class="l">Итого</td><td>' + fmt1(s.norm) + '</td><td></td><td>' + fmt1(s.stock) + '</td><td><b>' + pm(s.stock - s.norm) + '</b></td>' +
        '<td>' + (s.sur > 0 ? fmt1(s.sur) : '—') + '</td><td>' + (s.d > 0 ? fmt2(s.d) : '—') + '</td><td>' + (s.today > 0 ? fmt1(s.today) : '—') + '</td><td><b>' + fmt1(s.issue) + '</b></td></tr></table></div>';
      if (r[R.status] === 'no_stock') h += '<div class="pn"><b>Нормы нет и остатка нет: решите вручную, нужен ли препарат.</b></div>';
      else if (!r[R.norm]) h += '<div class="pn">Норма для препарата не задана — учитывается только расход.</div>';
      if (r[R.status] === 'stale') h += '<div class="pn"><b>Простой: нет расхода ' + r[R.eff] + ' дн.</b></div>';
      trs.forEach(function (t) { moved += t[2]; });
      var fromPh = Math.max(0, s.issue - moved);
      h += '<div class="pn">Выдаём до нормы, только если остаток к поставке ≤ порога (остаток к поставке = остаток − (расход/день − сегодня) − расход/день × ' + cover + ' дн.); иначе 0.<br>' +
        'Выдать = норма + (расход/день − сегодня) + расход/день × ' + cover + ' дн. − остаток<br>' +
        (trs.length ? '<b>Перемещение:</b> ' + trs.map(function (t) { return dn(t[0]) + ' → ' + dn(t[1]) + ' ' + fmt1(t[2]); }).join('; ') + '<br>' : '') +
        (s.issue <= 0.0001
          ? '<b>Отделениям выдавать не нужно (все выше порога) → к заказу 0</b>'
          : fromPh <= 0.0001
            ? 'Выдать ' + fmt1(s.issue) + ' − перемещение ' + fmt1(moved) + ' = из аптеки 0 → <b>к заказу 0</b>'
            : 'Выдать ' + fmt1(s.issue) + (moved > 0 ? ' − перемещение ' + fmt1(moved) + ' = из аптеки ' + fmt1(fromPh) : '') +
              ' + страховой запас ' + fmt1(r[R.ss]) + ' (σ ' + fmt2(r[R.sigma]) + '/день) − склад аптеки ' + fmt1(r[R.usable]) +
              ' = <b>' + fmt1(Math.max(0, r[R.target] - r[R.usable])) + '</b> → к заказу ' + fmt(r[R.units]) + ' ' + esc(r[R.unit])) +
        (r[R.ph] > 0 ? '<br>' + stockText(r) : '') +
        '<br>Полезный запас: склад аптеки ' + fmt1(r[R.usable]) + ' + в отделениях ' + fmt1(r[R.dept]) +
        (r[R.cover] >= 99999 || r[R.d] <= 0 ? '' : ' — хватит на ' + fmt1(r[R.cover]) + ' дн.') +
        (r[R.exp] > 0 ? ' · <span class="mm">просрочено ' + fmt1(r[R.exp]) + ' — к списанию</span>' : '') +
        (r[R.late] > 0 ? ' · не успеет израсходоваться до срока ' + fmt1(r[R.late]) : '') +
        (r[R.shelf] > 0 ? '<br>Типичный срок годности ' + Math.round(r[R.shelf]) + ' дн.' : '') + '</div>';
      return h;
    }
    function showPop(el, r) {
      var $p = $('#or-pop');
      if (!$p.length) $p = $('<div id="or-pop" class="or-pop"></div>').appendTo('body');
      $p.css({left: 0, top: 0}).html(pop(r)).show();
      // keep the whole window on the screen: move it left / above the drug when it does not fit
      var b = el.getBoundingClientRect(), w = $p.outerWidth(), ht = $p.outerHeight(), vw = document.documentElement.clientWidth, vh = window.innerHeight;
      var left = Math.min(b.left, vw - w - 16), top = b.bottom + 6;
      if (top + ht > vh - 8) top = b.top - ht - 6;
      if (top < 8) top = Math.max(8, vh - ht - 8);
      $p.css({left: Math.max(16, left), top: top});
    }
    function render() {
      var pages = Math.max(1, Math.ceil(view.length / size));
      if (page > pages) page = pages;
      var from = (page - 1) * size, slice = view.slice(from, from + size);
      if (!view.length) { $('#or-body').html('<div class="or-msg">Ничего не найдено</div>'); $('#or-pager').hide(); return; }
      var h = '<div style="overflow-x:auto"><table class="ot"><thead><tr><th class="nos"><input type="checkbox" id="sel-all" title="Выбрать все рекомендованные на странице"></th>' +
        hd('name', 'Препарат', 'l') + hd('d', 'Расход / день') + hd('usable', 'Полезный остаток') + hd('cover', 'Хватит на, дн.') + hd('status', 'Статус', 'l') +
        hd('blocks', 'К заказу, блоков') + hd('units', 'Единиц') + hd('price', 'Цена') + hd('sum', 'Сумма с НДС') + hd('partner', 'Поставщик', 'l') + '</tr></thead><tbody>';
      for (var i = 0; i < slice.length; i++) {
        var r = slice[i], id = r[R.id], bl = blocksOf(r), st = r[R.status];
        var cov = r[R.cover] >= 99999 ? '—' : fmt1(r[R.cover]);
        var covCls = r[R.cover] >= 99999 ? '' : r[R.cover] < 1 ? 'r' : r[R.cover] < cover + 1 ? 'y' : '';
        var tr = r[R.trend], trh = '';
        if (tr > 0.2) trh = ' <span class="or-trend up" title="Расход за последние 14 дней выше среднего за период на ' + Math.round(tr * 100) + '%">▲</span>';
        else if (tr < -0.2) trh = ' <span class="or-trend down" title="Расход за последние 14 дней ниже среднего за период на ' + Math.round(-tr * 100) + '%">▼</span>';
        var tags = '<span class="or-tag' + (r[R.abc] === 'A' ? ' a' : '') + '" title="Класс по стоимости расхода">' + r[R.abc] + '</span>';
        if (r[R.low]) tags += '<span class="or-tag w" title="Мало данных: препарат появился недавно, расчёт приблизительный">мало данных</span>';
        if (r[R.capped]) tags += '<span class="or-tag w" title="Количество ограничено сроком годности">срок годности</span>';
        if (r[R.exp] > 0) tags += '<span class="or-tag a" title="На складе аптеки срок годности уже истёк — к списанию">просрочено ' + fmt1(r[R.exp]) + '</span>';
        if (r[R.late] > 0) tags += '<span class="or-tag w" title="Срок годности истечёт раньше, чем препарат успеют израсходовать">не успеет ' + fmt1(r[R.late]) + '</span>';
        if (st === 'stale') tags += '<span class="or-tag" title="За выбранный период препарат ни разу не расходовался в отделениях">нет расхода ' + r[R.eff] + ' дн.</span>';
        var parts = [];
        if (r[R.ph] > 0) parts.push(stockText(r));
        if (r[R.dept] > 0) parts.push('в отделениях: ' + fmt1(r[R.dept]));
        if (r[R.deficit] > 0) parts.push('<span style="color:var(--brand)">до нормы: ' + fmt1(r[R.deficit]) + '</span>');
        var sub = tags + parts.join(' · ');
        h += '<tr data-id="' + id + '"><td class="ck1">' + (r._open ? '<input type="checkbox" class="pk"' + (picked[id] ? ' checked' : '') + '>' : '') + '</td>' +
          '<td class="nm"><div class="t">' + esc(r[R.name]) + ' <span style="color:var(--muted); font-weight:400">· ' + esc(r[R.unit]) + (r[R.block] > 1 ? ', блок ' + fmt(r[R.block]) : '') + '</span></div><div class="s">' + sub + '</div></td>' +
          '<td>' + (r[R.d] > 0 ? r[R.d].toFixed(r[R.d] < 10 ? 2 : 1) : '—') + trh + '</td><td>' + fmt1(r[R.usable]) + '</td><td class="or-cov ' + covCls + '">' + cov + '</td>' +
          '<td class="l"><span class="or-st ' + st + '">' + STATUS[st] + '</span></td>' +
          '<td>' + (r._open ? '<input type="number" min="0" step="1" class="bl" value="' + bl + '">' : '<span style="color:var(--muted)">—</span>') + '</td>' +
          '<td class="un">' + (r._open ? fmt(bl * r[R.block]) : '') + '</td><td>' + fmt2(r[R.price]) + '</td><td class="sm"><b>' + (r._open ? fmt(sumOf(r)) : '') + '</b></td>' +
          '<td class="l" style="color:var(--muted)">' + esc(r[R.partner]) + '</td></tr>';
      }
      h += '</tbody></table></div>';
      $('#or-body').html(h);
      pager(pages, from, slice.length);
    }
    function pager(pages, from, n) {
      var h = '<span>Показано <b style="color:#1F2430">' + (from + 1) + '–' + (from + n) + '</b> из <b style="color:#1F2430">' + view.length + '</b></span><span class="sp"></span>';
      h += '<button type="button" data-p="1"' + (page === 1 ? ' disabled' : '') + '>«</button><button type="button" data-p="' + (page - 1) + '"' + (page === 1 ? ' disabled' : '') + '>‹</button>';
      var set = {}, list = [];
      [1, 2, page - 2, page - 1, page, page + 1, page + 2, pages - 1, pages].forEach(function (p) { if (p >= 1 && p <= pages && !set[p]) { set[p] = 1; list.push(p); } });
      list.sort(function (a, b) { return a - b; });
      var prev = 0;
      list.forEach(function (p) { if (p - prev > 1) h += '<span>…</span>'; h += '<button type="button" data-p="' + p + '"' + (p === page ? ' class="cur"' : '') + '>' + p + '</button>'; prev = p; });
      h += '<button type="button" data-p="' + (page + 1) + '"' + (page === pages ? ' disabled' : '') + '>›</button><button type="button" data-p="' + pages + '"' + (page === pages ? ' disabled' : '') + '>»</button>';
      h += '<span style="margin-left:8px">на странице</span><select id="or-size">';
      [25, 50, 100, 200].forEach(function (s) { h += '<option value="' + s + '"' + (s === size ? ' selected' : '') + '>' + s + '</option>'; });
      $('#or-pager').html(h + '</select>').show();
    }

    /* ---------- печать и Excel: заказы по поставщикам ---------- */
    function groups() {
      var g = {}, order = [];
      all.forEach(function (r) {
        if (!picked[r[R.id]] || blocksOf(r) <= 0) return;
        var p = r[R.partner] || '';
        if (!g[p]) { g[p] = []; order.push(p); }
        g[p].push(r);
      });
      order.sort(function (a, b) { return a.localeCompare(b, 'ru'); });
      return order.map(function (p) { return {partner: p, rows: g[p]}; });
    }
    function tableHtml(gr) {
      var h = '', today = new Date().toLocaleDateString('ru-RU'), total = 0;
      gr.forEach(function (g) {
        var sub = 0;
        h += '<h3>Заявка поставщику: ' + (g.partner ? esc(g.partner) : 'поставщик не указан') + '</h3><p>Дата: ' + today + '</p>' +
          '<table border="1" cellspacing="0" cellpadding="5" style="border-collapse:collapse; width:100%"><tr style="background:#eee"><th>№</th><th>Препарат</th><th>Ед. изм.</th><th>Блоков</th><th>Единиц</th><th>Цена</th><th>Сумма с НДС</th></tr>';
        g.rows.forEach(function (r, i) {
          var b = blocksOf(r), u = b * r[R.block], s = u * (r[R.price] + r[R.nds]);
          sub += s;
          h += '<tr><td align="center">' + (i + 1) + '</td><td>' + esc(r[R.name]) + '</td><td>' + esc(r[R.unit]) + '</td><td align="right">' + b + '</td><td align="right">' + fmt(u) +
            '</td><td align="right">' + fmt2(r[R.price]) + '</td><td align="right">' + fmt2(s) + '</td></tr>';
        });
        total += sub;
        h += '<tr><td colspan="6" align="right"><b>Итого:</b></td><td align="right"><b>' + fmt2(sub) + '</b></td></tr></table><br>';
      });
      return {html: h, total: total};
    }
    function print() {
      var gr = groups();
      if (!gr.length) { FmsToast.show('Отметьте позиции для заказа', 'err'); return; }
      var t = tableHtml(gr), w = window.open('', '_blank');
      if (!w) { FmsToast.show('Разрешите всплывающие окна для печати', 'err'); return; }
      w.document.write('<!DOCTYPE html><html><head><meta charset="utf-8"><title>Заявка поставщикам</title><style>body{font-family:Arial,sans-serif;font-size:13px;margin:20px}h3{margin:18px 0 4px}p{margin:0 0 8px}th,td{font-size:13px}@media print{h3{page-break-before:auto}}</style></head><body>' +
        t.html + '<p><b>Всего по всем заявкам: ' + fmt2(t.total) + ' с НДС</b></p><br><p>Подпись: ______________________</p></body></html>');
      w.document.close(); w.focus();
    }
    function excel() {
      var gr = groups();
      if (!gr.length) { FmsToast.show('Отметьте позиции для заказа', 'err'); return; }
      var t = tableHtml(gr);
      var blob = new Blob(['﻿<html><head><meta charset="utf-8"></head><body>' + t.html + '</body></html>'], {type: 'application/vnd.ms-excel'});
      var a = document.createElement('a');
      a.href = URL.createObjectURL(blob); a.download = 'zayavka_postavshikam.xls';
      document.body.appendChild(a); a.click(); document.body.removeChild(a);
    }

    $(function () {
      loadSettings();
      var timer = null;
      $('#f-search').on('input', function () { var v = this.value; clearTimeout(timer); timer = setTimeout(function () { q = v; if (loaded) apply(); }, 200); });
      $('#f-partner').on('change', function () { partner = this.value; if (loaded) apply(); });
      $('.or-chip').on('click', function () { filter = '' + $(this).data('f'); $('.or-chip').removeClass('on'); $(this).addClass('on'); if (loaded) apply(); });
      $('#or-body').on('mouseenter', 'td.nm', function () {
          var id = $(this).closest('tr').data('id'), r = all.filter(function (x) { return x[R.id] === id; })[0];
          if (r) showPop(this, r);
        })
        .on('mouseleave', 'td.nm', function () { $('#or-pop').hide(); });
      $(window).on('scroll', function () { $('#or-pop').hide(); });
      $('#or-body').on('click', 'th[data-s]', function () { var k = $(this).data('s'); sort = {key: k, dir: sort.key === k ? -sort.dir : 1}; apply(); })
        .on('change', '.pk', function () { var id = $(this).closest('tr').data('id'); picked[id] = this.checked; summary(); })
        .on('input change', '.bl', function () {
          var tr = $(this).closest('tr'), id = tr.data('id'), v = Math.max(0, Math.floor(num(this.value)));
          var r = all.filter(function (x) { return x[R.id] === id; })[0];
          edited[id] = v; if (v > 0) picked[id] = true;
          tr.find('.un').text(fmt(v * r[R.block])); tr.find('.sm b').text(fmt(sumOf(r))); tr.find('.pk').prop('checked', !!picked[id]);
          summary();
        })
        .on('change', '#sel-all', function () {
          var on = this.checked;
          $('#or-body .pk').each(function () { var id = $(this).closest('tr').data('id'); picked[id] = on; this.checked = on; });
          summary();
        });
      $('#or-pager').on('click', 'button[data-p]', function () { page = Number($(this).data('p')); render(); }).on('change', '#or-size', function () { size = Number(this.value); page = 1; render(); });
      run();
    });
    return {run: run, print: print, excel: excel};
  })();
</script>
