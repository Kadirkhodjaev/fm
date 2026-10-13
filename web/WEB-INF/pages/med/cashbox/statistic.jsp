<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<style>
  .cs { --brand:#D7182E; --brand-dark:#A50F22; --brand-soft:#FDECEE; --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --bg:#F5F6F8;
    /* цвета способов оплаты (проверены на различимость, в т.ч. для дальтоников) */
    --p-card:#2a78d6; --p-bank:#eb6834; --p-cash:#1baf7a;
    max-width: 1200px; margin: 0 auto; padding: 16px 20px 40px; color: var(--text);
    font-family: 'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; }
  .cs-card { background:#fff; border:1px solid var(--border); border-radius:14px; margin-bottom:16px; overflow:hidden; }
  .cs-num { font-variant-numeric: tabular-nums; }

  /* ---------- Фильтр ---------- */
  .cs-filter { display:flex; align-items:center; flex-wrap:wrap; gap:12px; padding:14px 18px; }
  .cs-filter h2 { margin:0 16px 0 0; font-size:20px; font-weight:700; }
  .cs-range { display:flex; align-items:center; gap:8px; }
  .cs-range span { color:#B0B5BD; }
  .cs .form-control { width:160px; cursor:pointer; font-family:inherit; color:var(--text); height:38px; border:1.5px solid var(--border); border-radius:9px; box-shadow:none; font-size:14px; text-align:center; }
  .cs .form-control:focus { border-color:var(--brand); box-shadow:0 0 0 3px rgba(215,24,46,.10); }
  .cs-presets { display:flex; gap:4px; padding:3px; background:var(--bg); border-radius:10px; }
  .cs-presets button { height:32px; padding:0 12px; border:0; border-radius:8px; background:transparent; color:var(--muted); font-size:13px; font-weight:600; cursor:pointer; }
  .cs-presets button:hover { background:#fff; color:var(--text); }
  .cs-go { height:38px; padding:0 18px; border:0; border-radius:9px; background:var(--brand); color:#fff; font-size:14px; font-weight:600; cursor:pointer; }
  .cs-go:hover { background:var(--brand-dark); }

  /* ---------- Главная сумма ---------- */
  .cs-hero { padding:20px 22px; }
  .cs-hero-top { display:flex; align-items:flex-end; gap:16px; flex-wrap:wrap; margin-bottom:16px; }
  .cs-hero .lbl { font-size:13px; font-weight:600; color:var(--muted); margin-bottom:4px; }
  .cs-hero .big { font-size:36px; font-weight:700; line-height:1.1; letter-spacing:-.5px; color:var(--text); text-decoration:none; }
  .cs-hero .big small { font-size:16px; font-weight:600; color:var(--muted); margin-left:6px; }
  .cs-hero a.big:hover { color:var(--brand-dark); }
  .cs-link { font-size:13px; font-weight:600; color:var(--brand); text-decoration:none; }
  .cs-link:hover { color:var(--brand-dark); text-decoration:underline; }
  .cs-hero-top .sp { flex:1; }

  /* Полоса структуры (stacked bar) */
  .cs-bar { display:flex; gap:2px; height:14px; border-radius:4px; overflow:hidden; background:var(--bg); }
  .cs-bar.sm { height:8px; min-width:120px; }
  .cs-bar i { display:block; height:100%; min-width:0; transition:opacity .12s; }
  .cs-bar i:hover { opacity:.8; }
  .cs-bar .card { background:var(--p-card); } .cs-bar .bank { background:var(--p-bank); } .cs-bar .cash { background:var(--p-cash); }

  /* ---------- Плитки по способам оплаты ---------- */
  .cs-tiles { display:grid; grid-template-columns:repeat(3, 1fr); gap:16px; margin-bottom:16px; }
  .cs-tile { padding:16px 18px; }
  .cs-tiles .cs-card { margin-bottom:0; }
  .cs-tile .t-head { display:flex; align-items:center; gap:8px; font-size:13px; font-weight:600; color:var(--muted); }
  .cs-tile .dot { width:10px; height:10px; border-radius:3px; }
  .cs-tile .t-val { margin-top:8px; font-size:24px; font-weight:700; }
  .cs-tile .t-share { margin-top:2px; font-size:13px; color:var(--muted); }
  .cs-tile .t-split { display:flex; gap:14px; margin-top:12px; padding-top:12px; border-top:1px solid #F0F1F4; font-size:12.5px; color:var(--muted); }
  .cs-tile .t-split b { display:block; color:var(--text); font-size:14px; font-weight:600; }

  /* ---------- Таблица ---------- */
  .cs-card-h { display:flex; align-items:center; gap:10px; padding:14px 18px; border-bottom:1px solid var(--border); }
  .cs-card-h h3 { margin:0; font-size:16px; font-weight:700; }
  .cs-card-h .sp { flex:1; }
  .cs-legend { display:flex; gap:14px; font-size:12.5px; color:var(--muted); }
  .cs-legend span { display:inline-flex; align-items:center; gap:6px; }
  .cs-legend i { width:10px; height:10px; border-radius:3px; display:inline-block; }
  .cs-table { width:100%; border-collapse:separate; border-spacing:0; font-size:14px; }
  .cs-table th { padding:10px 16px; background:#F8F9FA; border-bottom:1px solid var(--border); color:var(--muted); font-size:12px; font-weight:600;
    text-transform:uppercase; letter-spacing:.3px; text-align:right; white-space:nowrap; }
  .cs-table th:first-child, .cs-table td:first-child { text-align:left; }
  .cs-table td { padding:14px 16px; border-bottom:1px solid #F0F1F4; text-align:right; font-variant-numeric:tabular-nums; }
  .cs-table tbody tr:hover td { background:#FAFBFC; }
  .cs-table td.name { font-weight:600; }
  .cs-table td.tot { font-weight:700; }
  .cs-table td.bar-cell { width:200px; }
  .cs-table tfoot td { background:#FAFBFC; font-weight:700; border-bottom:0; }
  .cs-table a { color:inherit; text-decoration:none; }
  .cs-table a:hover { color:var(--brand); }
  .cs-table a .fa { margin-left:6px; font-size:11px; color:#B0B5BD; }

  /* ---------- Скидки ---------- */
  .cs-dis { display:flex; align-items:center; gap:22px; flex-wrap:wrap; padding:16px 20px; border-color:#CDEBD7; background:linear-gradient(90deg, #F3FBF6 0%, #fff 60%); }
  .cs-dis .ic { flex:none; width:44px; height:44px; border-radius:12px; display:flex; align-items:center; justify-content:center; background:#E8F7EE; color:#15803D; font-size:20px; }
  .cs-dis .lbl { font-size:13px; font-weight:600; color:var(--muted); }
  .cs-dis .val { margin-top:2px; font-size:26px; font-weight:700; color:#15803D; }
  .cs-dis .val small { font-size:14px; font-weight:600; color:var(--muted); margin-left:4px; }
  .cs-dis .sep { width:1px; align-self:stretch; background:#E6E8EC; }
  .cs-dis .part { font-size:12.5px; color:var(--muted); }
  .cs-dis .part b { display:block; margin-top:2px; color:var(--text); font-size:16px; font-weight:600; }
  .cs-dis .sp { flex:1; }
  .cs-dis .note { max-width:260px; font-size:12.5px; color:var(--muted); line-height:1.45; }
  .cs-dis .note b { color:#15803D; }
  .cs-chip { display:inline-flex; align-items:center; gap:6px; height:28px; padding:0 12px; border-radius:999px; background:#E8F7EE; color:#15803D; font-size:12.5px; font-weight:600; }
  .cs-table td.dis { color:#15803D; }
  .cs-table td.dis.zero { color:#C3C7CE; }

  @media (max-width: 1100px) { .cs-tiles { grid-template-columns:1fr; } .cs-table td.bar-cell, .cs-table th.bar-cell { display:none; } }
</style>
<script>
  function setCashStat(){
    var start = document.getElementById("period_start");
    var end = document.getElementById("period_end");
    setPage('/cashbox/statistic.s?period_start=' + start.value + '&period_end=' + end.value);
  }
  function openDetails(code) {
    $('#cash_details_form_start').val($('#period_start').val());
    $('#cash_details_form_end').val($('#period_end').val());
    $('#cash_details_form_type').val(code);
    cash_details_form.submit();
  }

  /*
   * Календарь: видимые поля — встроенный календарь браузера (type="date", значение гггг-мм-дд).
   * На сервер уходят скрытые #period_start / #period_end в прежнем формате:
   * дд.мм.гггг, либо гггг-мм-дд, если сервер сам прислал дату в таком виде.
   */
  var CS_ISO = /^\d{4}-\d{2}-\d{2}$/.test('${period_start}' || '${period_end}');
  function csToIso(v) {
    var m;
    if ((m = /^(\d{2})\.(\d{2})\.(\d{4})/.exec(v))) return m[3] + '-' + m[2] + '-' + m[1];
    if ((m = /^(\d{4})-(\d{2})-(\d{2})/.exec(v)))  return m[1] + '-' + m[2] + '-' + m[3];
    return '';
  }
  function csFromIso(v) {
    if (!v) return '';
    var a = v.split('-');
    return CS_ISO ? v : (a[2] + '.' + a[1] + '.' + a[0]);
  }
  function csSync() {
    $('#period_start').val(csFromIso($('#ps_date').val()));
    $('#period_end').val(csFromIso($('#pe_date').val()));
  }
  function csOpen(el) {
    try { el.showPicker(); } catch (e) {}
  }

  // Быстрые периоды
  function setPreset(kind) {
    function iso(d) {
      return d.getFullYear() + '-' + ('0' + (d.getMonth() + 1)).slice(-2) + '-' + ('0' + d.getDate()).slice(-2);
    }
    var now = new Date(), s = new Date(now), e = new Date(now);
    if (kind == 'yesterday') { s.setDate(s.getDate() - 1); e = new Date(s); }
    if (kind == 'week')      { s.setDate(s.getDate() - 6); }
    if (kind == 'month')     { s = new Date(now.getFullYear(), now.getMonth(), 1); }
    $('#ps_date').val(iso(s));
    $('#pe_date').val(iso(e));
    csSync();
    setCashStat();
  }

  // Ширины сегментов и доли считаются из чисел в data-атрибутах
  $(function () {
    $('.cs-bar').each(function () {
      var segs = $(this).find('i'), total = 0;
      segs.each(function () { total += parseFloat($(this).attr('data-v')) || 0; });
      segs.each(function () {
        var v = parseFloat($(this).attr('data-v')) || 0;
        $(this).css('flex-grow', v).css('flex-basis', 0).toggle(v > 0)
          .attr('title', $(this).attr('data-n') + ': ' + (total ? Math.round(v * 1000 / total) / 10 : 0) + '%');
      });
    });
    $('[data-share]').each(function () {
      var v = parseFloat($(this).attr('data-share')) || 0, t = parseFloat($(this).attr('data-total')) || 0;
      $(this).text(t ? (Math.round(v * 1000 / t) / 10) + '% от всех поступлений' : '—');
    });
    // доля скидок от суммы «до скидки» (поступления + скидки)
    $('[data-dis]').each(function () {
      var d = parseFloat($(this).attr('data-dis')) || 0, p = parseFloat($(this).attr('data-paid')) || 0;
      $(this).text(d + p ? (Math.round(d * 1000 / (d + p)) / 10) + '%' : '0%');
    });
    // заполняем календари значениями с сервера
    $('#ps_date').val(csToIso($('#period_start').val()));
    $('#pe_date').val(csToIso($('#period_end').val()));
    $('#ps_date, #pe_date').on('change', csSync)
      .on('keydown', function (e) { if (e.keyCode == 13) { csSync(); setCashStat(); } });
  });
</script>

<form target="_blank" method="post" action="/rep/run.s" name="cash_details_form">
  <input type="hidden" name="repId" value="35"/>
  <input type="hidden" id="cash_details_form_start" name="period_start" value=""/>
  <input type="hidden" id="cash_details_form_end" name="period_end" value=""/>
  <input type="hidden" id="cash_details_form_type" name="type" value=""/>
</form>

<%-- Суммы: амбулатория c1/c3/c4 (итого c20), стационар c5/c7/c8 (итого c10) --%>
<c:set var="sCard" value="${obj.c1 + obj.c5}"/>
<c:set var="sBank" value="${obj.c3 + obj.c7}"/>
<c:set var="sCash" value="${obj.c4 + obj.c8}"/>
<c:set var="sAll"  value="${sCard + sBank + sCash}"/>
<%-- Скидки за период: disAmb / disStat передаёт контроллер (пока их нет, блок скрыт) --%>
<c:set var="hasDis" value="${not empty disAmb || not empty disStat}"/>
<c:set var="dAmb" value="${empty disAmb ? 0 : disAmb}"/>
<c:set var="dStat" value="${empty disStat ? 0 : disStat}"/>
<c:set var="dAll" value="${dAmb + dStat}"/>

<div class="cs">

  <!-- ================= Фильтр ================= -->
  <div class="cs-card">
    <div class="cs-filter">
      <h2>Статистика кассы</h2>
      <div class="cs-range">
        <input type="hidden" name="period_start" id="period_start" value="${period_start}"/>
        <input type="date" id="ps_date" class="form-control" title="Начало периода" onclick="csOpen(this)"/>
        <span>—</span>
        <input type="hidden" name="period_end" id="period_end" value="${period_end}"/>
        <input type="date" id="pe_date" class="form-control" title="Конец периода" onclick="csOpen(this)"/>
      </div>
      <button type="button" onclick="csSync(); setCashStat()" class="cs-go"><i class="fa fa-search"></i>&nbsp; Показать</button>
      <div class="cs-presets">
        <button type="button" onclick="setPreset('today')">Сегодня</button>
        <button type="button" onclick="setPreset('yesterday')">Вчера</button>
        <button type="button" onclick="setPreset('week')">7 дней</button>
        <button type="button" onclick="setPreset('month')">Месяц</button>
      </div>
    </div>
  </div>

  <!-- ================= Всего ================= -->
  <div class="cs-card cs-hero">
    <div class="cs-hero-top">
      <div>
        <div class="lbl">Всего поступлений за период</div>
        <a href="#" class="big cs-num" onclick="openDetails('amb'); return false" title="Открыть детализацию">
          <fmt:formatNumber value="${obj.c10 + obj.c20}" type="number"/><small>сум</small>
        </a>
      </div>
      <c:if test="${hasDis && dAll > 0}">
        <span class="cs-chip"><i class="fa fa-tags"></i> Скидки: <fmt:formatNumber value="${dAll}" type="number"/> сум</span>
      </c:if>
      <span class="sp"></span>
      <div class="cs-legend">
        <span><i style="background:var(--p-card)"></i>Карта</span>
        <span><i style="background:var(--p-bank)"></i>Перечисление</span>
        <span><i style="background:var(--p-cash)"></i>Наличные</span>
      </div>
    </div>
    <div class="cs-bar">
      <i class="card" data-n="Карта"        data-v="${sCard}"></i>
      <i class="bank" data-n="Перечисление" data-v="${sBank}"></i>
      <i class="cash" data-n="Наличные"     data-v="${sCash}"></i>
    </div>
  </div>

  <!-- ================= По способам оплаты ================= -->
  <div class="cs-tiles">
    <div class="cs-card cs-tile">
      <div class="t-head"><span class="dot" style="background:var(--p-card)"></span>Карта</div>
      <div class="t-val cs-num"><fmt:formatNumber value="${sCard}" type="number"/></div>
      <div class="t-share" data-share="${sCard}" data-total="${sAll}"></div>
      <div class="t-split">
        <div>Амбулатория<b class="cs-num"><fmt:formatNumber value="${obj.c1}" type="number"/></b></div>
        <div>Стационар<b class="cs-num"><fmt:formatNumber value="${obj.c5}" type="number"/></b></div>
      </div>
    </div>
    <div class="cs-card cs-tile">
      <div class="t-head"><span class="dot" style="background:var(--p-bank)"></span>Перечисление</div>
      <div class="t-val cs-num"><fmt:formatNumber value="${sBank}" type="number"/></div>
      <div class="t-share" data-share="${sBank}" data-total="${sAll}"></div>
      <div class="t-split">
        <div>Амбулатория<b class="cs-num"><fmt:formatNumber value="${obj.c3}" type="number"/></b></div>
        <div>Стационар<b class="cs-num"><fmt:formatNumber value="${obj.c7}" type="number"/></b></div>
      </div>
    </div>
    <div class="cs-card cs-tile">
      <div class="t-head"><span class="dot" style="background:var(--p-cash)"></span>Наличные</div>
      <div class="t-val cs-num"><fmt:formatNumber value="${sCash}" type="number"/></div>
      <div class="t-share" data-share="${sCash}" data-total="${sAll}"></div>
      <div class="t-split">
        <div>Амбулатория<b class="cs-num"><fmt:formatNumber value="${obj.c4}" type="number"/></b></div>
        <div>Стационар<b class="cs-num"><fmt:formatNumber value="${obj.c8}" type="number"/></b></div>
      </div>
    </div>
  </div>

  <!-- ================= Скидки ================= -->
  <c:if test="${hasDis}">
    <div class="cs-card cs-dis">
      <span class="ic"><i class="fa fa-tags"></i></span>
      <div>
        <div class="lbl">Скидки за период</div>
        <div class="val cs-num"><fmt:formatNumber value="${dAll}" type="number"/><small>сум</small></div>
      </div>
      <span class="sep"></span>
      <div class="part">Амбулатория<b class="cs-num"><fmt:formatNumber value="${dAmb}" type="number"/></b></div>
      <div class="part">Стационар<b class="cs-num"><fmt:formatNumber value="${dStat}" type="number"/></b></div>
      <span class="sp"></span>
      <div class="note">Без скидок поступило бы <b class="cs-num"><fmt:formatNumber value="${obj.c10 + obj.c20 + dAll}" type="number"/></b> сум, скидки составили <b data-dis="${dAll}" data-paid="${obj.c10 + obj.c20}"></b> от этой суммы.</div>
    </div>
  </c:if>

  <!-- ================= Сводная таблица ================= -->
  <div class="cs-card">
    <div class="cs-card-h"><h3>По подразделениям</h3><span class="sp"></span><span style="font-size:12.5px;color:#9AA1AC">Клик по строке — детализация</span></div>
    <table class="cs-table">
      <thead>
      <tr>
        <th>Подразделение</th>
        <th>Карта</th>
        <th>Перечисление</th>
        <th>Наличные</th>
        <th>Итого</th>
        <c:if test="${hasDis}"><th>Скидки</th></c:if>
        <th class="bar-cell" style="text-align:left">Структура</th>
      </tr>
      </thead>
      <tbody>
      <tr>
        <td class="name"><a href="#" onclick="openDetails('amb'); return false">Амбулатория<i class="fa fa-external-link"></i></a></td>
        <td><fmt:formatNumber value="${obj.c1}" type="number"/></td>
        <td><fmt:formatNumber value="${obj.c3}" type="number"/></td>
        <td><fmt:formatNumber value="${obj.c4}" type="number"/></td>
        <td class="tot"><a href="#" onclick="openDetails('amb'); return false"><fmt:formatNumber value="${obj.c20}" type="number"/></a></td>
        <c:if test="${hasDis}"><td class="dis<c:if test="${dAmb == 0}"> zero</c:if>"><fmt:formatNumber value="${dAmb}" type="number"/></td></c:if>
        <td class="bar-cell"><div class="cs-bar sm">
          <i class="card" data-n="Карта" data-v="${obj.c1}"></i><i class="bank" data-n="Перечисление" data-v="${obj.c3}"></i><i class="cash" data-n="Наличные" data-v="${obj.c4}"></i>
        </div></td>
      </tr>
      <tr>
        <td class="name"><a href="#" onclick="openDetails('stat'); return false">Стационар<i class="fa fa-external-link"></i></a></td>
        <td><fmt:formatNumber value="${obj.c5}" type="number"/></td>
        <td><fmt:formatNumber value="${obj.c7}" type="number"/></td>
        <td><fmt:formatNumber value="${obj.c8}" type="number"/></td>
        <td class="tot"><a href="#" onclick="openDetails('stat'); return false"><fmt:formatNumber value="${obj.c10}" type="number"/></a></td>
        <c:if test="${hasDis}"><td class="dis<c:if test="${dStat == 0}"> zero</c:if>"><fmt:formatNumber value="${dStat}" type="number"/></td></c:if>
        <td class="bar-cell"><div class="cs-bar sm">
          <i class="card" data-n="Карта" data-v="${obj.c5}"></i><i class="bank" data-n="Перечисление" data-v="${obj.c7}"></i><i class="cash" data-n="Наличные" data-v="${obj.c8}"></i>
        </div></td>
      </tr>
      </tbody>
      <tfoot>
      <tr>
        <td>Всего</td>
        <td><fmt:formatNumber value="${sCard}" type="number"/></td>
        <td><fmt:formatNumber value="${sBank}" type="number"/></td>
        <td><fmt:formatNumber value="${sCash}" type="number"/></td>
        <td><fmt:formatNumber value="${obj.c10 + obj.c20}" type="number"/></td>
        <c:if test="${hasDis}"><td class="dis"><fmt:formatNumber value="${dAll}" type="number"/></td></c:if>
        <td class="bar-cell"></td>
      </tr>
      </tfoot>
    </table>
  </div>
</div>
