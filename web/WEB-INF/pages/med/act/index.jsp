<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="ui" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<script src="/res/datepicker/datetimepicker_css.js" type="text/javascript"></script>
<script src="/res/js/fms-calendar.js" type="text/javascript"></script>
<style>
  .al { --brand:#D7182E; --text:#1F2430; --muted:#6B7280; --border:#E6E8EC; --bg:#F5F6F8;
    height:100%; box-sizing:border-box; display:flex; flex-direction:column; padding:16px 20px;
    color:var(--text); font-family:'Inter', -apple-system, 'Segoe UI', Roboto, Arial, sans-serif; }
  .al * { box-sizing:border-box; }
  .al-card { flex:1; min-height:0; display:flex; flex-direction:column; background:#fff; border:1px solid var(--border); border-radius:14px; overflow:hidden; }

  /* ---------- Панель фильтров ---------- */
  .al-bar { flex:none; display:flex; align-items:center; gap:10px; padding:12px 16px; border-bottom:1px solid var(--border); flex-wrap:wrap; }
  .al-bar h3 { margin:0 6px 0 0; font-size:17px; font-weight:700; }
  .al-bar .cnt { font-size:13px; font-weight:600; color:var(--muted); margin-right:6px; }
  .al-bar .sp { flex:1; }
  .al .in { height:36px; padding:0 10px; border:1px solid var(--border); border-radius:9px; font-size:14px; font-family:inherit; color:var(--text);
    background-color:#fff; outline:none; box-shadow:none; transition:border-color .15s, box-shadow .15s; }
  .al .in:focus { border-color:#4B5563; box-shadow:0 0 0 3px rgba(75,85,99,.12); }
  .al .in.date { width:160px; min-width:160px; }
  .al-period { display:flex; align-items:center; gap:6px; color:#9AA1AC; }
  .al .ab { display:inline-flex; align-items:center; gap:7px; height:36px; padding:0 14px; border-radius:9px; border:1px solid var(--border);
    background:#fff; color:var(--text); font-size:13.5px; font-weight:600; font-family:inherit; cursor:pointer; white-space:nowrap; }
  .al .ab:hover { background:var(--bg); }
  .al .ab.dark { background:var(--text); border-color:var(--text); color:#fff; }
  .al .ab.dark:hover { background:#000; }
  .al-seg { display:inline-flex; padding:3px; background:#F1F2F4; border-radius:10px; }
  .al-seg button { height:30px; padding:0 12px; border:0; border-radius:8px; background:none; color:var(--muted); font-size:13px; font-weight:600;
    font-family:inherit; cursor:pointer; }
  .al-seg button:hover { color:var(--text); }
  .al-seg button.on { background:#fff; color:var(--text); box-shadow:0 1px 2px rgba(20,25,40,.08); }
  .al-search { position:relative; }
  .al-search i { position:absolute; left:11px; top:50%; transform:translateY(-50%); color:#9AA1AC; font-size:13px; }
  .al-search .in { width:240px; padding-left:32px; }

  /* ---------- Таблица ---------- */
  .al-scroll { flex:1; min-height:0; overflow:auto; }
  .al-t { width:100%; border-collapse:separate; border-spacing:0; font-size:14px; }
  .al-t th { position:sticky; top:0; z-index:1; padding:10px 12px; background:#F8F9FA; border-bottom:1px solid var(--border); color:var(--muted);
    font-size:11.5px; font-weight:600; text-transform:uppercase; letter-spacing:.3px; text-align:left; white-space:nowrap; }
  .al-t td { padding:10px 12px; border-bottom:1px solid #F0F1F4; vertical-align:middle; white-space:nowrap; }
  .al-t th.r, .al-t td.r { text-align:right; }
  .al-t th.c, .al-t td.c { text-align:center; }
  .al-t tbody tr { cursor:pointer; }
  .al-t tbody tr:hover td { background:#F7F8FA; }
  .al-t td.num { color:#9AA1AC; width:44px; }
  .al-t td.fio { font-weight:600; white-space:normal; min-width:200px; }
  .al-t td.muted { color:var(--muted); }
  .al-t td.money { font-weight:600; font-variant-numeric:tabular-nums; }
  .al-t td.money.neg { color:var(--brand); }
  .al-t td.money.zero { color:#C3C7CE; font-weight:400; }
  .al-t .dot { display:inline-block; width:9px; height:9px; border-radius:50%; }
  .al-t .dot.c { background:#D97706; }
  .al-t .dot.d { background:#16A34A; }
  .al-t .bd { display:inline-block; padding:2px 9px; border-radius:10px; font-size:12px; font-weight:600; }
  .al-t .bd.open { background:#E8F7EE; color:#15803D; }
  .al-t .bd.closed { background:#F1F2F4; color:var(--muted); }
  .al-empty td { padding:40px 12px; text-align:center; color:#9AA1AC; cursor:default; }
  .al-foot { flex:none; display:flex; gap:16px; flex-wrap:wrap; padding:9px 16px; border-top:1px solid var(--border); background:#FCFCFD;
    font-size:12.5px; color:#9AA1AC; }
  .al-foot { align-items:center; }
  .al-foot .sp { flex:1; }
  .al-foot .tot { font-size:12px; font-weight:600; color:var(--muted); text-transform:uppercase; letter-spacing:.3px; white-space:nowrap; }
  .al-foot .tot b { margin-left:8px; font-size:16px; font-weight:700; color:var(--text); text-transform:none; letter-spacing:0; font-variant-numeric:tabular-nums; }
  .al-foot .tot.ret b { color:var(--brand); }
  .al-foot .tot + .tot { padding-left:16px; border-left:1px solid var(--border); }
  .al-foot .dot { display:inline-block; width:8px; height:8px; border-radius:50%; margin-right:5px; vertical-align:0; }
</style>

<div class="al" id="actList">
  <div class="al-card">
    <div class="al-bar">
      <h3>Акты</h3>
      <span class="cnt"></span>
      <div class="al-period">
        <input name="period_start" id="period_start" type="text" class="in date form-control fms-cal" autocomplete="off" placeholder="дд.мм.гггг" value="${period_start}"/>
        —
        <input name="period_end" id="period_end" type="text" class="in date form-control fms-cal" autocomplete="off" placeholder="дд.мм.гггг" value="${period_end}"/>
      </div>
      <button type="button" class="ab dark" onclick="setCashStat()">Показать</button>
      <span class="sp"></span>
      <div class="al-seg" role="group" aria-label="Фильтр по оплате">
        <button type="button" class="<c:if test="${pay_sum_type == '0' || empty pay_sum_type}">on</c:if>" onclick="setPaySumType({value:'0'})">Все</button>
        <button type="button" class="<c:if test="${pay_sum_type == '1'}">on</c:if>" onclick="setPaySumType({value:'1'})">Возврат</button>
        <button type="button" class="<c:if test="${pay_sum_type == '2'}">on</c:if>" onclick="setPaySumType({value:'2'})">Должники</button>
      </div>
      <div class="al-search">
        <i class="fa fa-search"></i>
        <input type="text" class="in" placeholder="Поиск..." id="filter_box" value="${filter}">
      </div>
      <button type="button" class="ab" onclick="setActFilter()">Найти</button>
    </div>

    <div class="al-scroll">
      <table class="al-t">
        <thead>
        <tr>
          <th style="width:44px">№</th>
          <th class="c" style="width:36px" title="Подтверждение"></th>
          <th>ФИО</th>
          <th class="c" style="width:90px">ИБ №</th>
          <th class="c" style="width:120px">Поступление</th>
          <th class="c" style="width:120px">Выписка</th>
          <th class="c" style="width:110px">Год рожд.</th>
          <th style="width:200px">Отд. / Палата</th>
          <th class="r" style="width:150px">Сумма оплаты</th>
          <th class="c" style="width:110px">Акт</th>
          <th class="c" style="width:110px">Касса</th>
        </tr>
        </thead>
        <tbody>
        <c:set var="sumRet" value="${0}"/>
        <c:set var="sumDebt" value="${0}"/>
        <c:forEach items="${rows}" var="obj" varStatus="loop">
          <c:if test="${obj.paySum <= -1}"><c:set var="sumRet" value="${sumRet - obj.paySum}"/></c:if>
          <c:if test="${obj.paySum >= 1}"><c:set var="sumDebt" value="${sumDebt + obj.paySum}"/></c:if>
          <tr ondblclick="setPage('/act/info.s?id=${obj.id}')" title="Двойной клик — открыть акт">
            <td class="num">${loop.index + 1}</td>
            <td class="c">
              <c:if test="${obj.state == 'C'}"><span class="dot c" title="Не подтверждён"></span></c:if>
              <c:if test="${obj.state == 'D'}"><span class="dot d" title="Подтверждён"></span></c:if>
            </td>
            <td class="fio">${obj.patient.surname} ${obj.patient.name} ${obj.patient.middlename}</td>
            <td class="c">${obj.patient.yearNum}</td>
            <td class="c muted"><fmt:formatDate pattern = "dd.MM.yyyy" value = "${obj.patient.dateBegin}" /></td>
            <td class="c muted"><fmt:formatDate pattern = "dd.MM.yyyy" value = "${obj.patient.dateEnd}" /></td>
            <td class="c muted">${obj.patient.birthyear}</td>
            <td class="muted">${obj.patient.dept.name} / ${obj.patient.room.name}</td>
            <td class="r money <c:if test="${obj.paySum <= -1}">neg</c:if> <c:if test="${obj.paySum > -1 && obj.paySum < 1}">zero</c:if>"><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${obj.paySum > -1 && obj.paySum < 1 ? 0 : obj.paySum}" type="number"/></td>
            <td class="c">
              <c:if test="${obj.closed != 'Y'}"><span class="bd open">Открыт</span></c:if>
              <c:if test="${obj.closed == 'Y'}"><span class="bd closed">Закрыт</span></c:if>
            </td>
            <td class="c">
              <c:if test="${obj.patient.paid != 'CLOSED'}"><span class="bd open">Открыта</span></c:if>
              <c:if test="${obj.patient.paid == 'CLOSED'}"><span class="bd closed">Закрыта</span></c:if>
            </td>
          </tr>
        </c:forEach>
        <c:if test="${empty rows}">
          <tr class="al-empty"><td colspan="11">За выбранный период актов нет</td></tr>
        </c:if>
        </tbody>
      </table>
    </div>

    <div class="al-foot">
      <span><span class="dot" style="background:#16A34A"></span>Подтверждён</span>
      <span><span class="dot" style="background:#D97706"></span>Не подтверждён</span>
      <span>Отрицательная сумма — возврат</span>
      <span>Двойной клик по строке открывает акт</span>
      <span class="sp"></span>
      <span class="tot ret">Итого к возврату <b><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${sumRet}" type="number"/></b></span>
      <span class="tot debt">Итого сумма долга <b><fmt:formatNumber minFractionDigits="2" maxFractionDigits="2" value="${sumDebt}" type="number"/></b></span>
    </div>
  </div>
</div>

<script>
  function setCashStat(){
    var start = document.getElementById("period_start");
    var end = document.getElementById("period_end");
    setPage('/act/index.s?period_start=' + start.value + '&period_end=' + end.value);
  }
  function setActFilter() {
    var start = document.getElementById("period_start");
    var end = document.getElementById("period_end");
    var word = document.getElementById("filter_box");
    setPage('/act/index.s?period_start=' + start.value + '&period_end=' + end.value + '&word=' + encodeURIComponent(word.value));
  }
  function setPaySumType(dom) {
    setPage('/act/index.s?pay_sum_type=' + dom.value);
  }

  (function () {
    // Enter в поиске запускает поиск
    var box = document.getElementById('filter_box');
    if (box) box.addEventListener('keydown', function (e) { if (e.key === 'Enter') { e.preventDefault(); setActFilter(); } });

    // Количество актов в шапке
    var page = document.getElementById('actList');
    if (page) {
      var n = page.querySelectorAll('.al-t tbody tr:not(.al-empty)').length;
      var c = page.querySelector('.al-bar .cnt'); if (c) c.textContent = n ? n : '';
    }

    // Высота по окну: если обёртка не задаёт высоту, прокручивается только таблица
    function fit() {
      if (!page) return;
      page.style.height = '';
      var avail = window.innerHeight - page.getBoundingClientRect().top - 8;
      if (avail > 300 && page.offsetHeight > avail) page.style.height = avail + 'px';
    }
    fit(); window.addEventListener('resize', fit);
  })();
</script>
